import rateLimit from 'express-rate-limit';

export const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per `window`
  message: { error: 'Shumë kërkesa nga kjo adresë IP, ju lutem provoni përsëri pas 15 minutash' },
  standardHeaders: true,
  legacyHeaders: false,
});

export const authLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 5, // Limit each IP to 5 login attempts per hour
  message: { error: 'Shumë tentativa dështuar, ju lutem provoni përsëri pas një ore' },
  standardHeaders: true,
  legacyHeaders: false,
});