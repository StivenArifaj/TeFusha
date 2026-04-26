import { Request, Response } from 'express';
import bcrypt from 'bcrypt';
import { prisma } from '../utils/prisma';
import { generateTokens } from '../utils/jwt';

export async function register(req: Request, res: Response) {
  try {
    const { emri, email, fjalekalimi, nr_telefoni, roli } = req.body;

    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      res.status(400).json({ error: 'Ky email është i regjistruar' });
      return;
    }

    const hashedFjalekalimi = await bcrypt.hash(fjalekalimi, 10);

    const user = await prisma.user.create({
      data: {
        emri,
        email,
        fjalekalimi: hashedFjalekalimi,
        nr_telefoni,
        roli,
      },
    });

    const tokens = generateTokens({ id: user.id, roli: user.roli });
    res.status(201).json({ user: { id: user.id, emri: user.emri, email: user.email, roli: user.roli }, ...tokens });
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë regjistrimit' });
  }
}

export async function login(req: Request, res: Response) {
  try {
    const { email, fjalekalimi } = req.body;

    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) {
      res.status(401).json({ error: 'Email ose fjalëkalim i gabuar' });
      return;
    }

    const match = await bcrypt.compare(fjalekalimi, user.fjalekalimi);
    if (!match) {
      res.status(401).json({ error: 'Email ose fjalëkalim i gabuar' });
      return;
    }

    const tokens = generateTokens({ id: user.id, roli: user.roli });
    res.json({ user: { id: user.id, emri: user.emri, email: user.email, roli: user.roli }, ...tokens });
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë hyrjes' });
  }
}

export async function refresh(req: Request, res: Response) {
  try {
    const { refresh_token } = req.body;
    if (!refresh_token) {
      res.status(400).json({ error: 'Refresh token mungon' });
      return;
    }

    // In a real app, you'd verify the refresh token properly
    // For now, we'll just generate new ones if it's valid
    const jwt = require('jsonwebtoken');
    const payload = jwt.verify(refresh_token, process.env.JWT_SECRET || 'fallback_secret') as { id: number; roli: string };
    
    const tokens = generateTokens({ id: payload.id, roli: payload.roli });
    res.json(tokens);
  } catch (error) {
    res.status(401).json({ error: 'Refresh token i pavlefshëm' });
  }
}