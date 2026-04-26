# TeFusha — SKILL: Backend (Node.js + Express + Prisma + PostgreSQL)
> Feed this file to Gemini CLI before any backend work.
> Stack locked by PMP §15.1: Node.js 18 + Express.js + PostgreSQL 15 + Prisma ORM + JWT + bcrypt

---

## ABSOLUTE RULES (never break these)

1. **Language**: TypeScript only. Never plain JS.
2. **ORM**: Prisma only. Never raw SQL except in `$queryRaw` for locking (see booking service).
3. **Auth**: JWT (access + refresh tokens). bcrypt for passwords. Never store plain text passwords.
4. **Framework**: Express.js only. Never Fastify, Hapi, Koa, or any other.
5. **Database**: PostgreSQL only. Never MongoDB, SQLite, MySQL.
6. **Validation**: Zod for all request body validation. Reject invalid input with 400.
7. **Error format**: Always `{ error: "message in Albanian" }` for API errors.
8. **No `any` types** unless absolutely unavoidable — always type everything.
9. **Env vars**: All secrets via `process.env`. Never hardcode. Use dotenv.
10. **Port**: Default 3001 for backend.

---

## PROJECT STRUCTURE

```
backend/
├── src/
│   ├── app.ts                    ← Express app (no listen here)
│   ├── index.ts                  ← Server entry (listen here)
│   ├── controllers/
│   │   ├── auth.controller.ts
│   │   ├── field.controller.ts
│   │   ├── booking.controller.ts
│   │   ├── event.controller.ts
│   │   └── admin.controller.ts
│   ├── middlewares/
│   │   ├── auth.middleware.ts    ← JWT verify + role check
│   │   ├── validate.middleware.ts← Zod schema validation
│   │   └── rate-limit.ts
│   ├── routes/
│   │   ├── auth.routes.ts
│   │   ├── field.routes.ts
│   │   ├── booking.routes.ts
│   │   ├── event.routes.ts
│   │   └── admin.routes.ts
│   ├── services/
│   │   ├── booking.service.ts    ← Contains atomic transaction + slot logic
│   │   ├── fixture.service.ts    ← Round-robin bracket generator
│   │   └── email.service.ts      ← Confirmation emails
│   ├── utils/
│   │   ├── prisma.ts             ← Singleton PrismaClient
│   │   ├── validators.ts         ← Zod schemas
│   │   └── jwt.ts                ← Token generation/verification helpers
│   └── __tests__/
│       ├── auth.test.ts
│       ├── booking.test.ts
│       └── field.test.ts
├── prisma/
│   ├── schema.prisma
│   └── migrations/
├── .env                          ← Never commit this
├── .env.example                  ← Commit this
├── package.json
├── tsconfig.json
└── vercel.json
```

---

## SETUP COMMANDS (run in order, only once)

```bash
mkdir backend && cd backend
npm init -y
npm install express @prisma/client bcrypt jsonwebtoken cors dotenv zod express-rate-limit
npm install -D nodemon typescript ts-node @types/express @types/node @types/bcrypt @types/jsonwebtoken jest ts-jest supertest @types/supertest
npx prisma init
```

### tsconfig.json
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
```

### package.json scripts
```json
{
  "scripts": {
    "dev": "nodemon --exec ts-node src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "jest --runInBand",
    "db:migrate": "prisma migrate dev",
    "db:generate": "prisma generate",
    "db:studio": "prisma studio",
    "db:seed": "ts-node prisma/seed.ts"
  }
}
```

### .env.example
```env
DATABASE_URL=postgresql://user:password@localhost:5432/tefusha
JWT_SECRET=change_this_to_a_long_random_secret
JWT_EXPIRY=15m
REFRESH_TOKEN_EXPIRY=7d
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3002
PORT=3001
```

---

## DATABASE SCHEMA (prisma/schema.prisma)

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id                Int          @id @default(autoincrement())
  emri              String       @db.VarChar(100)
  email             String       @unique @db.VarChar(150)
  fjalekalimi       String       @db.VarChar(255)
  nr_telefoni       String?      @db.VarChar(20)
  roli              UserRole     @default(perdorues)
  data_regjistrimit DateTime     @default(now())

  fushat            Field[]      @relation("PronarFushes")
  rezervimet        Booking[]    @relation("PerdoruesRezervimit")
  eventet           Event[]      @relation("OrganizatorEventi")
  ekipet            TeamMember[]

  @@map("users")
}

enum UserRole {
  perdorues
  pronar_fushe
  admin
}

model Field {
  id           Int         @id @default(autoincrement())
  emri_fushes  String      @db.VarChar(100)
  lloji_fushes FieldType
  vendndodhja  String      @db.VarChar(200)
  qyteti       String      @db.VarChar(100)
  cmimi_orari  Decimal     @db.Decimal(10, 2)
  kapaciteti   Int
  pajisjet     String?     @db.Text
  statusi      FieldStatus @default(aktiv)
  lat          Float?
  lng          Float?
  pronari_id   Int
  created_at   DateTime    @default(now())

  pronari      User        @relation("PronarFushes", fields: [pronari_id], references: [id])
  rezervimet   Booking[]
  eventet      Event[]

  @@map("fields")
}

enum FieldType {
  futboll
  basketboll
  tenis
  volejboll
  tjeter
}

enum FieldStatus {
  aktiv
  joaktiv
  ne_mirembajtje
}

model Booking {
  id              Int           @id @default(autoincrement())
  fusha_id        Int
  perdoruesi_id   Int
  data_rezervimit DateTime      @db.Date
  ora_fillimit    DateTime      @db.Time(6)
  ora_mbarimit    DateTime      @db.Time(6)
  statusi         BookingStatus @default(ne_pritje)
  cmimi_total     Decimal       @db.Decimal(10, 2)
  data_krijimit   DateTime      @default(now())

  fusha           Field         @relation(fields: [fusha_id], references: [id])
  perdoruesi      User          @relation("PerdoruesRezervimit", fields: [perdoruesi_id], references: [id])

  @@map("bookings")
}

enum BookingStatus {
  ne_pritje
  konfirmuar
  anuluar
}

model Event {
  id               Int         @id @default(autoincrement())
  emri_eventit     String      @db.VarChar(150)
  lloji            EventType
  fusha_id         Int
  data_fillimit    DateTime    @db.Date
  data_mbarimit    DateTime    @db.Date
  nr_max_ekipesh   Int
  organizatori_id  Int
  statusi          EventStatus @default(planifikuar)

  fusha            Field       @relation(fields: [fusha_id], references: [id])
  organizatori     User        @relation("OrganizatorEventi", fields: [organizatori_id], references: [id])
  ekipet           Team[]
  ndeshjet         Match[]

  @@map("events")
}

enum EventType {
  eventi
  kampionat
  turneu
}

enum EventStatus {
  planifikuar
  aktiv
  perfunduar
}

model Team {
  id         Int          @id @default(autoincrement())
  emri       String       @db.VarChar(100)
  eventi_id  Int
  created_at DateTime     @default(now())

  eventi                 Event        @relation(fields: [eventi_id], references: [id])
  anetaret               TeamMember[]
  ndeshjat_shtepi        Match[]      @relation("EkipiShtepi")
  ndeshjat_udhetimit     Match[]      @relation("EkipiUdhetimit")

  @@map("teams")
}

model TeamMember {
  id             Int  @id @default(autoincrement())
  ekipi_id       Int
  perdoruesi_id  Int

  ekipi       Team @relation(fields: [ekipi_id], references: [id])
  perdoruesi  User @relation(fields: [perdoruesi_id], references: [id])

  @@map("team_members")
}

model Match {
  id                 Int       @id @default(autoincrement())
  eventi_id          Int
  ekipi_shtepi_id    Int
  ekipi_udhetimit_id Int
  gola_shtepi        Int?
  gola_udhetimit     Int?
  data_ndeshjës      DateTime?
  raundi             String?   @db.VarChar(50)

  eventi           Event  @relation(fields: [eventi_id], references: [id])
  ekipi_shtepi     Team   @relation("EkipiShtepi", fields: [ekipi_shtepi_id], references: [id])
  ekipi_udhetimit  Team   @relation("EkipiUdhetimit", fields: [ekipi_udhetimit_id], references: [id])

  @@map("matches")
}
```

---

## CRITICAL FILES TO IMPLEMENT

### src/utils/prisma.ts
```typescript
import { PrismaClient } from '@prisma/client';

const globalForPrisma = global as unknown as { prisma: PrismaClient };

export const prisma =
  globalForPrisma.prisma ||
  new PrismaClient({
    log: process.env.NODE_ENV === 'development' ? ['query', 'error'] : ['error'],
  });

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma;
```

### src/utils/jwt.ts
```typescript
import jwt from 'jsonwebtoken';

const SECRET = process.env.JWT_SECRET!;
const ACCESS_EXPIRY = process.env.JWT_EXPIRY || '15m';
const REFRESH_EXPIRY = process.env.REFRESH_TOKEN_EXPIRY || '7d';

export function generateTokens(payload: { id: number; roli: string }) {
  const access  = jwt.sign(payload, SECRET, { expiresIn: ACCESS_EXPIRY });
  const refresh = jwt.sign(payload, SECRET, { expiresIn: REFRESH_EXPIRY });
  return { access, refresh };
}

export function verifyToken(token: string): { id: number; roli: string } {
  return jwt.verify(token, SECRET) as { id: number; roli: string };
}
```

### src/middlewares/auth.middleware.ts
```typescript
import { Request, Response, NextFunction } from 'express';
import { verifyToken } from '../utils/jwt';

export interface AuthRequest extends Request {
  user?: { id: number; roli: string };
}

export function authenticate(req: AuthRequest, res: Response, next: NextFunction): void {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) {
    res.status(401).json({ error: 'Token mungon' });
    return;
  }
  try {
    req.user = verifyToken(token);
    next();
  } catch {
    res.status(401).json({ error: 'Token i pavlefshëm ose i skaduar' });
  }
}

export function requireRole(...roles: string[]) {
  return (req: AuthRequest, res: Response, next: NextFunction): void => {
    if (!req.user || !roles.includes(req.user.roli)) {
      res.status(403).json({ error: 'Akses i ndaluar' });
      return;
    }
    next();
  };
}
```

### src/services/booking.service.ts (CRITICAL — prevents double booking)
```typescript
import { prisma } from '../utils/prisma';

export async function getAvailableSlots(fieldId: number, date: Date): Promise<string[]> {
  const allSlots = generateHourlySlots('08:00', '22:00');

  const existing = await prisma.booking.findMany({
    where: {
      fusha_id: fieldId,
      data_rezervimit: date,
      statusi: { in: ['ne_pritje', 'konfirmuar'] },
    },
    select: { ora_fillimit: true, ora_mbarimit: true },
  });

  return allSlots.filter(slot => {
    const slotStart = toMinutes(slot);
    const slotEnd   = slotStart + 60;
    return !existing.some(b => {
      const bStart = new Date(b.ora_fillimit).getHours() * 60 + new Date(b.ora_fillimit).getMinutes();
      const bEnd   = new Date(b.ora_mbarimit).getHours() * 60 + new Date(b.ora_mbarimit).getMinutes();
      return slotStart < bEnd && slotEnd > bStart;
    });
  });
}

export async function createBookingAtomically(data: {
  fusha_id: number;
  perdoruesi_id: number;
  data_rezervimit: Date;
  ora_fillimit: string;
  ora_mbarimit: string;
  cmimi_total: number;
}) {
  return prisma.$transaction(async (tx) => {
    // Row-level lock to prevent race conditions
    const conflict = await tx.$queryRaw<{ id: number }[]>`
      SELECT id FROM bookings
      WHERE fusha_id = ${data.fusha_id}
        AND data_rezervimit = ${data.data_rezervimit}
        AND statusi != 'anuluar'::"BookingStatus"
        AND ora_fillimit < ${data.ora_mbarimit}::time
        AND ora_mbarimit > ${data.ora_fillimit}::time
      FOR UPDATE
    `;
    if (conflict.length > 0) {
      throw new Error('Ora është e zënë — zgjedh një orar tjetër');
    }
    return tx.booking.create({
      data: {
        fusha_id:        data.fusha_id,
        perdoruesi_id:   data.perdoruesi_id,
        data_rezervimit: data.data_rezervimit,
        ora_fillimit:    new Date(`1970-01-01T${data.ora_fillimit}:00`),
        ora_mbarimit:    new Date(`1970-01-01T${data.ora_mbarimit}:00`),
        cmimi_total:     data.cmimi_total,
      },
    });
  });
}

function generateHourlySlots(start: string, end: string): string[] {
  const slots: string[] = [];
  let h = parseInt(start.split(':')[0]);
  const endH = parseInt(end.split(':')[0]);
  while (h < endH) {
    slots.push(`${String(h).padStart(2, '0')}:00`);
    h++;
  }
  return slots;
}

function toMinutes(time: string): number {
  const [h, m] = time.split(':').map(Number);
  return h * 60 + m;
}
```

### src/services/fixture.service.ts
```typescript
export interface MatchFixture {
  home_team_id: number;
  away_team_id: number;
  round: number;
}

export function generateRoundRobin(teamIds: number[]): MatchFixture[] {
  const teams = [...teamIds];
  if (teams.length % 2 !== 0) teams.push(-1); // bye
  const rounds = teams.length - 1;
  const half = teams.length / 2;
  const fixtures: MatchFixture[] = [];

  for (let round = 0; round < rounds; round++) {
    for (let i = 0; i < half; i++) {
      const home = teams[i];
      const away = teams[teams.length - 1 - i];
      if (home !== -1 && away !== -1) {
        fixtures.push({ home_team_id: home, away_team_id: away, round: round + 1 });
      }
    }
    teams.splice(1, 0, teams.pop()!);
  }
  return fixtures;
}
```

---

## ALL API ENDPOINTS REFERENCE

| Method | Path | Auth | Role | Description |
|--------|------|------|------|-------------|
| POST | /api/auth/register | No | - | Register new user |
| POST | /api/auth/login | No | - | Login → returns access+refresh tokens |
| POST | /api/auth/refresh | No | - | Refresh access token |
| POST | /api/auth/logout | Yes | any | Logout (client discards tokens) |
| GET | /api/fields | No | - | List active fields (query: qyteti, lloji) |
| GET | /api/fields/:id | No | - | Single field details |
| GET | /api/fields/:id/availability | No | - | Available slots for a date (query: date=YYYY-MM-DD) |
| POST | /api/fields | Yes | pronar_fushe | Create field |
| PUT | /api/fields/:id | Yes | pronar_fushe | Update own field |
| DELETE | /api/fields/:id | Yes | pronar_fushe,admin | Deactivate field |
| GET | /api/bookings/mine | Yes | any | My bookings |
| POST | /api/bookings | Yes | perdorues | Create booking (atomic) |
| PUT | /api/bookings/:id/confirm | Yes | pronar_fushe | Confirm booking |
| PUT | /api/bookings/:id/cancel | Yes | any | Cancel booking |
| GET | /api/bookings/field/:fieldId | Yes | pronar_fushe | Bookings for owner's field |
| GET | /api/events | No | - | List events |
| GET | /api/events/:id | No | - | Event + teams + fixtures |
| POST | /api/events | Yes | any | Create event |
| POST | /api/events/:id/teams | Yes | any | Register team |
| POST | /api/events/:id/generate-fixtures | Yes | any | Generate round-robin brackets |
| PUT | /api/events/:id/matches/:matchId | Yes | any | Update match result |
| GET | /api/admin/users | Yes | admin | All users |
| PUT | /api/admin/users/:id/role | Yes | admin | Change user role |
| GET | /api/admin/fields | Yes | admin | All fields |
| PUT | /api/admin/fields/:id/status | Yes | admin | Force field status |
| GET | /api/admin/bookings | Yes | admin | All bookings |
| GET | /api/admin/stats | Yes | admin | Platform statistics |

---

## COMMON ERRORS & FIXES

### Error: "Cannot find module '@prisma/client'"
```bash
npx prisma generate
```

### Error: "Environment variable not found: DATABASE_URL"
- Make sure `.env` file exists in `backend/` root
- Make sure `dotenv.config()` is called at the VERY TOP of `src/index.ts` before any imports

### Error: Prisma migration fails with "relation does not exist"
```bash
npx prisma migrate reset   # WARNING: deletes all data
npx prisma migrate dev --name init
```

### Error: "Property 'user' does not exist on type 'Request'"
- Use `AuthRequest` instead of `Request` in all controllers that use `req.user`
- Import: `import { AuthRequest } from '../middlewares/auth.middleware'`

### Error: bcrypt "data and salt arguments required"
- Check that `req.body.fjalekalimi` exists and is a string before calling `bcrypt.hash()`
- Validate with Zod first

### Error: JWT "invalid signature"
- JWT_SECRET in .env must be the same for signing and verifying
- Never change JWT_SECRET in production without invalidating all tokens

### Error: CORS "No 'Access-Control-Allow-Origin' header"
- Add the frontend URL to ALLOWED_ORIGINS in .env
- During development: `ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3002`

### Error: Prisma "$queryRaw" template literal issue
- Always use tagged template literal syntax: `prisma.$queryRaw\`SELECT...\``
- Never use string concatenation in raw queries (SQL injection risk)

### Error: Time fields stored incorrectly
- Prisma @db.Time fields → always pass as `new Date('1970-01-01T' + timeString + ':00')`
- When reading back, extract with `.getHours()` and `.getMinutes()`

---

## TESTING CHECKLIST (before moving to next platform)

Run these in order. All must pass.

```bash
cd backend

# 1. TypeScript compiles without errors
npx tsc --noEmit

# 2. Run all tests
npm test

# 3. Start dev server and test manually
npm run dev

# 4. Test auth flow
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"emri":"Test User","email":"test@test.com","fjalekalimi":"Test123!","roli":"perdorues"}'

# 5. Test field listing (public)
curl http://localhost:3001/api/fields

# 6. Test availability
curl "http://localhost:3001/api/fields/1/availability?date=2026-05-01"

# 7. Prisma Studio — visually verify data
npx prisma studio
```

### Tests that MUST pass before launch
- [ ] Register → Login → get JWT token works
- [ ] Create field as `pronar_fushe` works
- [ ] Get available slots returns correct array
- [ ] Double-booking the same slot returns 409 Conflict
- [ ] Admin-only routes return 403 for non-admin
- [ ] Zod validation rejects missing required fields with 400
- [ ] Round-robin fixture generation produces correct number of matches

---

## VERCEL DEPLOYMENT

### vercel.json (in backend/)
```json
{
  "version": 2,
  "builds": [{ "src": "src/index.ts", "use": "@vercel/node" }],
  "routes": [{ "src": "/(.*)", "dest": "src/index.ts" }]
}
```

```bash
cd backend
vercel --prod
# Set environment variables in Vercel dashboard, NOT in .env
```
