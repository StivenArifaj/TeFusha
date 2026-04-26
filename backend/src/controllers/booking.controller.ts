import { Response } from 'express';
import { prisma } from '../utils/prisma';
import { AuthRequest } from '../middlewares/auth.middleware';
import { createBookingAtomically } from '../services/booking.service';

export async function getMyBookings(req: AuthRequest, res: Response) {
  try {
    const bookings = await prisma.booking.findMany({
      where: { perdoruesi_id: req.user!.id },
      include: { fusha: true },
      orderBy: { data_rezervimit: 'desc' },
    });
    res.json(bookings);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së rezervimeve' });
  }
}

export async function createBooking(req: AuthRequest, res: Response) {
  try {
    const { fusha_id, data_rezervimit, ora_fillimit, ora_mbarimit } = req.body;
    
    const field = await prisma.field.findUnique({ where: { id: fusha_id } });
    if (!field) {
      res.status(404).json({ error: 'Fusha nuk u gjet' });
      return;
    }

    const booking = await createBookingAtomically({
      fusha_id,
      perdoruesi_id: req.user!.id,
      data_rezervimit: new Date(data_rezervimit),
      ora_fillimit,
      ora_mbarimit,
      cmimi_total: Number(field.cmimi_orari), // Simplified logic: price per hour
    });

    res.status(201).json(booking);
  } catch (error: any) {
    res.status(409).json({ error: error.message || 'Gabim gjatë rezervimit' });
  }
}

export async function confirmBooking(req: AuthRequest, res: Response) {
  try {
    const id = parseInt(req.params.id as any);
    const booking = await prisma.booking.findUnique({
      where: { id },
      include: { fusha: true },
    });

    if (!booking) {
      res.status(404).json({ error: 'Rezervimi nuk u gjet' });
      return;
    }

    if (booking.fusha.pronari_id !== req.user!.id && req.user!.roli !== 'admin') {
      res.status(403).json({ error: 'Akses i ndaluar' });
      return;
    }

    const updated = await prisma.booking.update({
      where: { id },
      data: { statusi: 'konfirmuar' },
    });
    res.json(updated);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë konfirmimit' });
  }
}

export async function cancelBooking(req: AuthRequest, res: Response) {
  try {
    const id = parseInt(req.params.id as any);
    const booking = await prisma.booking.findUnique({
      where: { id },
      include: { fusha: true },
    });

    if (!booking) {
      res.status(404).json({ error: 'Rezervimi nuk u gjet' });
      return;
    }

    if (booking.perdoruesi_id !== req.user!.id && booking.fusha.pronari_id !== req.user!.id && req.user!.roli !== 'admin') {
      res.status(403).json({ error: 'Akses i ndaluar' });
      return;
    }

    const updated = await prisma.booking.update({
      where: { id },
      data: { statusi: 'anuluar' },
    });
    res.json(updated);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë anulimit' });
  }
}

export async function getFieldBookings(req: AuthRequest, res: Response) {
  try {
    const fieldId = parseInt(req.params.fieldId as any);
    const field = await prisma.field.findUnique({ where: { id: fieldId } });

    if (!field || (field.pronari_id !== req.user!.id && req.user!.roli !== 'admin')) {
      res.status(403).json({ error: 'Akses i ndaluar' });
      return;
    }

    const bookings = await prisma.booking.findMany({
      where: { fusha_id: fieldId },
      include: { perdoruesi: { select: { emri: true, nr_telefoni: true } } },
      orderBy: { data_rezervimit: 'desc' },
    });
    res.json(bookings);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së rezervimeve' });
  }
}