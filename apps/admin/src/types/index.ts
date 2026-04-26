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
