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
