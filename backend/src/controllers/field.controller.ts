import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';
import { AuthRequest } from '../middlewares/auth.middleware';
import { getAvailableSlots } from '../services/booking.service';

export async function getAllFields(req: Request, res: Response) {
  try {
    const { qyteti, lloji } = req.query;
    const fields = await prisma.field.findMany({
      where: {
        statusi: 'aktiv',
        qyteti: qyteti ? String(qyteti) : undefined,
        lloji_fushes: lloji ? (lloji as any) : undefined,
      },
    });
    res.json(fields);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së fushave' });
  }
}

export async function getFieldById(req: Request, res: Response) {
  try {
    const field = await prisma.field.findUnique({
      where: { id: parseInt(req.params.id as any) },
      include: { pronari: { select: { emri: true, email: true, nr_telefoni: true } } },
    });
    if (!field) {
      res.status(404).json({ error: 'Fusha nuk u gjet' });
      return;
    }
    res.json(field);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së fushës' });
  }
}

export async function getFieldAvailability(req: Request, res: Response) {
  try {
    const { date } = req.query;
    if (!date) {
      res.status(400).json({ error: 'Data është e detyrueshme (YYYY-MM-DD)' });
      return;
    }
    const slots = await getAvailableSlots(parseInt(req.params.id as any), new Date(String(date)));
    res.json(slots);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë kontrollit të disponueshmërisë' });
  }
}

export async function createField(req: AuthRequest, res: Response) {
  try {
    const field = await prisma.field.create({
      data: {
        ...req.body,
        pronari_id: req.user!.id,
      },
    });
    res.status(201).json(field);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë krijimit të fushës' });
  }
}

export async function updateField(req: AuthRequest, res: Response) {
  try {
    const id = parseInt(req.params.id as any);
    const field = await prisma.field.findUnique({ where: { id } });

    if (!field) {
      res.status(404).json({ error: 'Fusha nuk u gjet' });
      return;
    }

    if (field.pronari_id !== req.user!.id && req.user!.roli !== 'admin') {
      res.status(403).json({ error: 'Nuk keni autorizim për të ndryshuar këtë fushë' });
      return;
    }

    const updatedField = await prisma.field.update({
      where: { id },
      data: req.body,
    });
    res.json(updatedField);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë përditësimit të fushës' });
  }
}

export async function deactivateField(req: AuthRequest, res: Response) {
  try {
    const id = parseInt(req.params.id as any);
    const field = await prisma.field.findUnique({ where: { id } });

    if (!field) {
      res.status(404).json({ error: 'Fusha nuk u gjet' });
      return;
    }

    if (field.pronari_id !== req.user!.id && req.user!.roli !== 'admin') {
      res.status(403).json({ error: 'Nuk keni autorizim' });
      return;
    }

    await prisma.field.update({
      where: { id },
      data: { statusi: 'joaktiv' },
    });
    res.json({ message: 'Fusha u çaktivizua me sukses' });
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë fshirjes' });
  }
}

export async function getMyFields(req: AuthRequest, res: Response) {
  try {
    const fields = await prisma.field.findMany({
      where: { pronari_id: req.user!.id }
    });
    res.json(fields);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së fushave tuaja' });
  }
}

export async function getFieldBookings(req: AuthRequest, res: Response) {
  try {
    const id = parseInt(req.params.id as any);
    const field = await prisma.field.findUnique({ where: { id } });

    if (!field) return res.status(404).json({ error: 'Fusha nuk u gjet' });
    if (field.pronari_id !== req.user!.id && req.user!.roli !== 'admin') {
      return res.status(403).json({ error: 'Nuk keni autorizim' });
    }

    const bookings = await prisma.booking.findMany({
      where: { fusha_id: id },
      include: {
        perdoruesi: { select: { id: true, emri: true, email: true, nr_telefoni: true } }
      },
      orderBy: { data_rezervimit: 'desc' }
    });

    res.json(bookings);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së rezervimeve' });
  }
}