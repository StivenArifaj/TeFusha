# TeFusha — SKILL: Web Frontend + Admin Panel (React.js 18)
> Feed this file to Gemini CLI before any web/admin work.
> Stack locked by PMP §15.1: React.js 18 + TypeScript

---

## ABSOLUTE RULES (never break these)

1. **Framework**: React.js 18 + TypeScript. Never Vue, Angular, Next.js (unless explicitly approved).
2. **Data fetching**: TanStack Query (react-query) for all server state. Never useEffect + fetch directly.
3. **HTTP**: Axios only. Never fetch() directly.
4. **Routing**: React Router DOM v6. Never older versions.
5. **Styling**: CSS Modules + inline styles OR MUI for admin. No Tailwind (not in PMP stack).
6. **Types**: Full TypeScript. No `any` unless unavoidable.
7. **Language**: All UI text in Albanian.
8. **No hardcoded API URLs** — use environment variable `REACT_APP_API_URL`.
9. **Token storage**: localStorage for web (acceptable for web context). Axios interceptor handles refresh.
10. **Forms**: Controlled components with validation. Never uncontrolled.

---

## TWO SEPARATE APPS

| App | Path | Purpose | Users |
|-----|------|---------|-------|
| Public Web | `apps/web/` | Field search, booking, events for users | Citizens |
| Admin Panel | `apps/admin/` | Manage everything | Admin only |

Both are React.js. Both connect to the same backend API.

---

## SETUP COMMANDS

```bash
# Public web
npx create-react-app apps/web --template typescript
cd apps/web
npm install axios @tanstack/react-query react-router-dom @tanstack/react-query-devtools

# Admin panel
npx create-react-app apps/admin --template typescript
cd apps/admin
npm install axios @tanstack/react-query react-router-dom recharts @mui/material @mui/icons-material @emotion/react @emotion/styled
```

---

## PROJECT STRUCTURE

### apps/web/src/
```
src/
├── index.tsx
├── App.tsx                       ← Router + QueryClient setup
├── api/
│   ├── client.ts                 ← Axios instance + interceptors
│   └── endpoints.ts              ← All API endpoint strings
├── hooks/                        ← Custom hooks wrapping react-query
│   ├── useFields.ts
│   ├── useBookings.ts
│   └── useEvents.ts
├── pages/
│   ├── HomePage.tsx
│   ├── FieldsPage.tsx
│   ├── FieldDetailPage.tsx
│   ├── BookingPage.tsx
│   ├── MyBookingsPage.tsx
│   ├── EventsPage.tsx
│   ├── EventDetailPage.tsx
│   ├── LoginPage.tsx
│   └── RegisterPage.tsx
├── components/
│   ├── FieldCard.tsx
│   ├── TimeSlotPicker.tsx
│   ├── BookingCalendar.tsx
│   ├── BracketView.tsx
│   ├── Navbar.tsx
│   └── ProtectedRoute.tsx
├── context/
│   └── AuthContext.tsx            ← isLoggedIn, user, login(), logout()
├── types/
│   └── index.ts                  ← All TypeScript interfaces
└── utils/
    └── formatters.ts
```

### apps/admin/src/
```
src/
├── App.tsx
├── api/
│   ├── client.ts
│   └── endpoints.ts
├── pages/
│   ├── DashboardPage.tsx         ← Stats + charts
│   ├── UsersPage.tsx
│   ├── FieldsPage.tsx
│   ├── BookingsPage.tsx
│   ├── EventsPage.tsx
│   └── LoginPage.tsx
└── components/
    ├── StatCard.tsx
    ├── DataTable.tsx
    └── Sidebar.tsx
```

---

## TYPES (shared between web and admin)

### types/index.ts
```typescript
export type UserRole = 'perdorues' | 'pronar_fushe' | 'admin';
export type FieldType = 'futboll' | 'basketboll' | 'tenis' | 'volejboll' | 'tjeter';
export type FieldStatus = 'aktiv' | 'joaktiv' | 'ne_mirembajtje';
export type BookingStatus = 'ne_pritje' | 'konfirmuar' | 'anuluar';
export type EventType = 'eventi' | 'kampionat' | 'turneu';
export type EventStatus = 'planifikuar' | 'aktiv' | 'perfunduar';

export interface User {
  id: number;
  emri: string;
  email: string;
  nr_telefoni?: string;
  roli: UserRole;
  data_regjistrimit: string;
}

export interface Field {
  id: number;
  emri_fushes: string;
  lloji_fushes: FieldType;
  vendndodhja: string;
  qyteti: string;
  cmimi_orari: number;
  kapaciteti: number;
  pajisjet?: string;
  statusi: FieldStatus;
  lat?: number;
  lng?: number;
  pronari_id: number;
}

export interface Booking {
  id: number;
  fusha_id: number;
  perdoruesi_id: number;
  data_rezervimit: string;     // "YYYY-MM-DD"
  ora_fillimit: string;        // "HH:MM"
  ora_mbarimit: string;        // "HH:MM"
  statusi: BookingStatus;
  cmimi_total: number;
  data_krijimit: string;
  fusha?: Field;
  perdoruesi?: User;
}

export interface Event {
  id: number;
  emri_eventit: string;
  lloji: EventType;
  fusha_id: number;
  data_fillimit: string;
  data_mbarimit: string;
  nr_max_ekipesh: number;
  organizatori_id: number;
  statusi: EventStatus;
  ekipet?: Team[];
  ndeshjet?: Match[];
}

export interface Team {
  id: number;
  emri: string;
  eventi_id: number;
}

export interface Match {
  id: number;
  eventi_id: number;
  ekipi_shtepi_id: number;
  ekipi_udhetimit_id: number;
  gola_shtepi?: number;
  gola_udhetimit?: number;
  raundi?: string;
}

export interface AuthTokens {
  access_token: string;
  refresh_token: string;
  user: User;
}

export interface AdminStats {
  totalUsers: number;
  activeFields: number;
  todayBookings: number;
  activeEvents: number;
  weeklyBookings: { day: string; count: number }[];
}
```

---

## AXIOS CLIENT + AUTO-REFRESH

### api/client.ts (same pattern for both web and admin)
```typescript
import axios, { AxiosInstance, AxiosError } from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3001';

const apiClient: AxiosInstance = axios.create({
  baseURL: API_URL,
  headers: { 'Content-Type': 'application/json' },
  timeout: 15000,
});

// Attach JWT to every request
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('tf_access');
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

// Auto-refresh on 401
apiClient.interceptors.response.use(
  (res) => res,
  async (error: AxiosError) => {
    const original = error.config as any;
    if (error.response?.status === 401 && !original._retry) {
      original._retry = true;
      try {
        const refresh = localStorage.getItem('tf_refresh');
        const { data } = await axios.post(`${API_URL}/api/auth/refresh`, {
          refresh_token: refresh,
        });
        localStorage.setItem('tf_access',  data.access_token);
        localStorage.setItem('tf_refresh', data.refresh_token);
        original.headers.Authorization = `Bearer ${data.access_token}`;
        return apiClient(original);
      } catch {
        localStorage.removeItem('tf_access');
        localStorage.removeItem('tf_refresh');
        window.location.href = '/login';
      }
    }
    return Promise.reject(error);
  }
);

export default apiClient;
```

### api/endpoints.ts
```typescript
export const ENDPOINTS = {
  // Auth
  REGISTER:  '/api/auth/register',
  LOGIN:     '/api/auth/login',
  REFRESH:   '/api/auth/refresh',

  // Fields
  FIELDS:          '/api/fields',
  FIELD:           (id: number) => `/api/fields/${id}`,
  AVAILABILITY:    (id: number) => `/api/fields/${id}/availability`,

  // Bookings
  BOOKINGS:        '/api/bookings',
  MY_BOOKINGS:     '/api/bookings/mine',
  CONFIRM_BOOKING: (id: number) => `/api/bookings/${id}/confirm`,
  CANCEL_BOOKING:  (id: number) => `/api/bookings/${id}/cancel`,
  FIELD_BOOKINGS:  (fieldId: number) => `/api/bookings/field/${fieldId}`,

  // Events
  EVENTS:          '/api/events',
  EVENT:           (id: number) => `/api/events/${id}`,
  REGISTER_TEAM:   (id: number) => `/api/events/${id}/teams`,
  GEN_FIXTURES:    (id: number) => `/api/events/${id}/generate-fixtures`,
  UPDATE_MATCH:    (eId: number, mId: number) => `/api/events/${eId}/matches/${mId}`,

  // Admin
  ADMIN_USERS:     '/api/admin/users',
  ADMIN_USER_ROLE: (id: number) => `/api/admin/users/${id}/role`,
  ADMIN_FIELDS:    '/api/admin/fields',
  ADMIN_FIELD_STATUS: (id: number) => `/api/admin/fields/${id}/status`,
  ADMIN_BOOKINGS:  '/api/admin/bookings',
  ADMIN_STATS:     '/api/admin/stats',
};
```

---

## AUTH CONTEXT

### context/AuthContext.tsx
```tsx
import React, { createContext, useContext, useState, useEffect } from 'react';
import { User } from '../types';

interface AuthContextType {
  user: User | null;
  isLoggedIn: boolean;
  login: (tokens: { access_token: string; refresh_token: string; user: User }) => void;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType>({} as AuthContextType);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    // Restore user from localStorage on mount
    const stored = localStorage.getItem('tf_user');
    if (stored) setUser(JSON.parse(stored));
  }, []);

  const login = (data: { access_token: string; refresh_token: string; user: User }) => {
    localStorage.setItem('tf_access',  data.access_token);
    localStorage.setItem('tf_refresh', data.refresh_token);
    localStorage.setItem('tf_user',    JSON.stringify(data.user));
    setUser(data.user);
  };

  const logout = () => {
    localStorage.removeItem('tf_access');
    localStorage.removeItem('tf_refresh');
    localStorage.removeItem('tf_user');
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, isLoggedIn: !!user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
```

---

## REACT-QUERY HOOKS PATTERN

```typescript
// hooks/useFields.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import apiClient from '../api/client';
import { ENDPOINTS } from '../api/endpoints';
import { Field } from '../types';

export function useFields(filters?: { qyteti?: string; lloji?: string }) {
  return useQuery({
    queryKey: ['fields', filters],
    queryFn: () =>
      apiClient.get<Field[]>(ENDPOINTS.FIELDS, { params: filters }).then(r => r.data),
  });
}

export function useField(id: number) {
  return useQuery({
    queryKey: ['field', id],
    queryFn: () => apiClient.get<Field>(ENDPOINTS.FIELD(id)).then(r => r.data),
  });
}

export function useAvailability(fieldId: number, date: string) {
  return useQuery({
    queryKey: ['availability', fieldId, date],
    queryFn: () =>
      apiClient.get<string[]>(ENDPOINTS.AVAILABILITY(fieldId), { params: { date } }).then(r => r.data),
    enabled: !!date, // only fetch when date is selected
  });
}

export function useCreateBooking() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (data: {
      fusha_id: number;
      data_rezervimit: string;
      ora_fillimit: string;
      ora_mbarimit: string;
    }) => apiClient.post(ENDPOINTS.BOOKINGS, data).then(r => r.data),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['availability'] });
      qc.invalidateQueries({ queryKey: ['my-bookings'] });
    },
  });
}
```

---

## KEY WEB PAGES

### FieldsPage.tsx
```tsx
import React, { useState } from 'react';
import { useFields } from '../hooks/useFields';
import FieldCard from '../components/FieldCard';

const CITIES = ['Tiranë', 'Durrës', 'Vlorë', 'Shkodër', 'Elbasan', 'Korçë'];
const TYPES  = ['futboll', 'basketboll', 'tenis', 'volejboll'];

export default function FieldsPage() {
  const [city, setCity] = useState('');
  const [type, setType] = useState('');
  const { data: fields, isLoading, error } = useFields({
    qyteti: city || undefined,
    lloji: type || undefined,
  });

  return (
    <div style={{ padding: '24px', maxWidth: 1200, margin: '0 auto' }}>
      <h1>Fushat Sportive</h1>

      {/* Filters */}
      <div style={{ display: 'flex', gap: 12, marginBottom: 24 }}>
        <select value={city} onChange={e => setCity(e.target.value)}>
          <option value="">Të gjitha qytetet</option>
          {CITIES.map(c => <option key={c} value={c}>{c}</option>)}
        </select>
        <select value={type} onChange={e => setType(e.target.value)}>
          <option value="">Të gjitha llojet</option>
          {TYPES.map(t => <option key={t} value={t}>{t}</option>)}
        </select>
      </div>

      {/* Results */}
      {isLoading && <p>Duke ngarkuar...</p>}
      {error && <p style={{ color: 'red' }}>Gabim gjatë ngarkimit të fushave.</p>}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))', gap: 20 }}>
        {fields?.map(f => <FieldCard key={f.id} field={f} />)}
      </div>
      {fields?.length === 0 && <p>Asnjë fushë nuk u gjet.</p>}
    </div>
  );
}
```

### ProtectedRoute.tsx
```tsx
import { Navigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

export default function ProtectedRoute({ children, requiredRole }: {
  children: JSX.Element;
  requiredRole?: 'admin' | 'pronar_fushe';
}) {
  const { isLoggedIn, user } = useAuth();
  if (!isLoggedIn) return <Navigate to="/login" replace />;
  if (requiredRole && user?.roli !== requiredRole && user?.roli !== 'admin') {
    return <Navigate to="/" replace />;
  }
  return children;
}
```

---

## ADMIN PANEL — DASHBOARD

```tsx
// apps/admin/src/pages/DashboardPage.tsx
import { useQuery } from '@tanstack/react-query';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import apiClient from '../api/client';
import { ENDPOINTS } from '../api/endpoints';
import { AdminStats } from '../types';

function StatCard({ title, value, icon }: { title: string; value?: number; icon: string }) {
  return (
    <div style={{
      background: '#fff', borderRadius: 12, padding: 20,
      boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
    }}>
      <div style={{ fontSize: 32 }}>{icon}</div>
      <div style={{ fontSize: 28, fontWeight: 'bold', color: '#E8002D' }}>{value ?? '—'}</div>
      <div style={{ color: '#9E9E9E', fontSize: 14, marginTop: 4 }}>{title}</div>
    </div>
  );
}

export default function DashboardPage() {
  const { data: stats } = useQuery<AdminStats>({
    queryKey: ['admin-stats'],
    queryFn: () => apiClient.get(ENDPOINTS.ADMIN_STATS).then(r => r.data),
  });

  return (
    <div style={{ padding: 24 }}>
      <h1 style={{ color: '#E8002D', marginBottom: 24 }}>Paneli i Administratorit — TeFusha</h1>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 16, marginBottom: 32 }}>
        <StatCard title="Përdorues Total"  value={stats?.totalUsers}    icon="👥" />
        <StatCard title="Fusha Aktive"     value={stats?.activeFields}  icon="🏟️" />
        <StatCard title="Rezervime Sot"    value={stats?.todayBookings} icon="📅" />
        <StatCard title="Evente Aktive"    value={stats?.activeEvents}  icon="🏆" />
      </div>

      <div style={{ background: '#fff', borderRadius: 12, padding: 20 }}>
        <h3>Rezervimet Javore</h3>
        <ResponsiveContainer width="100%" height={300}>
          <BarChart data={stats?.weeklyBookings ?? []}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="day" />
            <YAxis />
            <Tooltip />
            <Bar dataKey="count" fill="#E8002D" radius={[4,4,0,0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
```

---

## .env FILES

### apps/web/.env
```
REACT_APP_API_URL=http://localhost:3001
```

### apps/web/.env.production
```
REACT_APP_API_URL=https://your-backend.vercel.app
```

### apps/admin/.env
```
REACT_APP_API_URL=http://localhost:3001
PORT=3002
```

---

## COMMON ERRORS & FIXES

### Error: "Cannot read properties of undefined (reading 'map')"
- Your query returned `undefined` on first render
- Always use optional chaining: `fields?.map(...)` or check `if (!fields) return null`

### Error: "useQuery is not a function" or import errors from react-query
- Use `@tanstack/react-query` NOT the old `react-query` package
- Import: `import { useQuery } from '@tanstack/react-query'`

### Error: CORS error from browser
- Add the web URL to backend `ALLOWED_ORIGINS`
- `ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3002,https://tefusha.vercel.app`

### Error: "Warning: React Hook useEffect has missing dependency"
- Add all used variables to the dependency array
- OR use `useQuery` (react-query) instead of useEffect — it handles this automatically

### Error: "Objects are not valid as a React child"
- You're trying to render an object directly: `{error}` where error is an AxiosError
- Use: `{(error as any)?.response?.data?.error || 'Gabim i panjohur'}`

### Error: Admin panel blank white screen after login
- Check that ProtectedRoute wraps admin routes
- Check that `REACT_APP_API_URL` is set correctly in admin .env

### Error: recharts "Unknown prop" warnings
- Recharts is fine — these are internal warnings, not errors
- They don't affect functionality

### Error: 413 "Request Entity Too Large" when uploading field images
- Add to Express: `app.use(express.json({ limit: '10mb' }))`
- Add to Express: `app.use(express.urlencoded({ extended: true, limit: '10mb' }))`

---

## VERCEL DEPLOYMENT

### apps/web/vercel.json
```json
{
  "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }]
}
```

```bash
cd apps/web
vercel --prod
# Set REACT_APP_API_URL in Vercel dashboard
```

---

## TESTING CHECKLIST (before declaring web complete)

```bash
# 1. Build succeeds
npm run build

# 2. Start and check no console errors
npm start
```

### Features that MUST work before launch
- [ ] Home page loads with navigation
- [ ] Field list page loads with cards
- [ ] Filter by city and type works
- [ ] Field detail page shows info + book button
- [ ] Booking page shows availability calendar
- [ ] Login / Register forms work and store tokens
- [ ] Protected routes redirect to /login when not authenticated
- [ ] My Bookings page shows user's reservations
- [ ] Events page shows list
- [ ] Event detail shows teams + bracket
- [ ] Admin: Dashboard shows stats
- [ ] Admin: Can see all users and change roles
- [ ] Admin: Can see all fields and change status
- [ ] Admin: Can see all bookings
- [ ] Logout clears tokens and redirects
