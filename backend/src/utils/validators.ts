import { z } from 'zod';

export const registerSchema = z.object({
  emri: z.string().min(2, 'Emri duhet të ketë të paktën 2 karaktere'),
  email: z.string().email('Email i pavlefshëm'),
  fjalekalimi: z.string().min(6, 'Fjalëkalimi duhet të ketë të paktën 6 karaktere'),
  nr_telefoni: z.string().optional(),
  roli: z.enum(['perdorues', 'pronar_fushe', 'admin']).default('perdorues'),
});

export const loginSchema = z.object({
  email: z.string().email('Email i pavlefshëm'),
  fjalekalimi: z.string(),
});

export const fieldSchema = z.object({
  emri_fushes: z.string().min(3),
  lloji_fushes: z.enum(['futboll', 'basketboll', 'tenis', 'volejboll', 'tjeter']),
  vendndodhja: z.string(),
  qyteti: z.string(),
  cmimi_orari: z.number().positive(),
  kapaciteti: z.number().int().positive(),
  pajisjet: z.string().optional(),
});

export const fieldUpdateSchema = fieldSchema.partial();

export const bookingSchema = z.object({
  fusha_id: z.number().int(),
  data_rezervimit: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Data duhet të jetë në formatin YYYY-MM-DD'),
  ora_fillimit: z.string().regex(/^\d{2}:\d{2}$/, 'Ora duhet të jetë në formatin HH:MM'),
  ora_mbarimit: z.string().regex(/^\d{2}:\d{2}$/, 'Ora duhet të jetë në formatin HH:MM'),
});

export const eventSchema = z.object({
  emri_eventit: z.string().min(3),
  lloji: z.enum(['eventi', 'kampionat', 'turneu']),
  fusha_id: z.number().int(),
  data_fillimit: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Data duhet të jetë në formatin YYYY-MM-DD'),
  data_mbarimit: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Data duhet të jetë në formatin YYYY-MM-DD'),
  nr_max_ekipesh: z.number().int().positive(),
});

export const teamSchema = z.object({
  emri: z.string().min(2),
});

export const matchUpdateSchema = z.object({
  gola_shtepi: z.number().int().min(0).optional(),
  gola_udhetimit: z.number().int().min(0).optional(),
});

export const createAnnouncementSchema = z.object({
  titull:             z.string().min(5).max(150),
  pershkrim:          z.string().min(10),
  lloji_sportit:      z.enum(['futboll', 'basketboll', 'tenis', 'volejboll', 'tjeter']),
  vendndodhja:        z.string().optional(),
  data_lojes:         z.string().datetime().optional(),
  lojtare_nevojitet:  z.number().int().min(1).max(22),
  tipi:               z.enum(['kerko_lojtar', 'kerko_kundershtare', 'kerko_ekip']),
});

export const createStandaloneTeamSchema = z.object({
  emri:           z.string().min(2).max(100),
  lloji_sportit:  z.enum(['futboll', 'basketboll', 'tenis', 'volejboll', 'tjeter']),
  pershkrim:      z.string().optional(),
});