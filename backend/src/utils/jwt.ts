import jwt from 'jsonwebtoken';

const SECRET = process.env.JWT_SECRET || 'fallback_secret';
const ACCESS_EXPIRY = (process.env.JWT_EXPIRY || '15m') as any;
const REFRESH_EXPIRY = (process.env.REFRESH_TOKEN_EXPIRY || '7d') as any;

export function generateTokens(payload: { id: number; roli: string }) {
  const access  = jwt.sign(payload, SECRET, { expiresIn: ACCESS_EXPIRY });
  const refresh = jwt.sign(payload, SECRET, { expiresIn: REFRESH_EXPIRY });
  return { access, refresh };
}

export function verifyToken(token: string): { id: number; roli: string } {
  return jwt.verify(token, SECRET) as { id: number; roli: string };
}