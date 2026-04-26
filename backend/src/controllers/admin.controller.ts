import { Response } from 'express';
import { prisma } from '../utils/prisma';
import { AuthRequest } from '../middlewares/auth.middleware';

export async function getAllUsers(req: AuthRequest, res: Response) {
  try {
    const users = await prisma.user.findMany({
      select: { id: true, emri: true, email: true, roli: true, data_regjistrimit: true },
    });
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së përdoruesve' });
  }
}

export async function updateUserRole(req: AuthRequest, res: Response) {
  try {
    const id = parseInt(req.params.id as any);
    const { roli } = req.body;
    const user = await prisma.user.update({
      where: { id },
      data: { roli },
    });
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë përditësimit të rolit' });
  }
}

export async function getAllFieldsAdmin(req: AuthRequest, res: Response) {
  try {
    const fields = await prisma.field.findMany({
      include: { pronari: { select: { emri: true } } },
    });
    res.json(fields);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së fushave' });
  }
}

export async function updateFieldStatus(req: AuthRequest, res: Response) {
  try {
    const id = parseInt(req.params.id as any);
    const { statusi } = req.body;
    const field = await prisma.field.update({
      where: { id },
      data: { statusi },
    });
    res.json(field);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë përditësimit të statusit' });
  }
}

export async function getAllBookingsAdmin(req: AuthRequest, res: Response) {
  try {
    const bookings = await prisma.booking.findMany({
      include: {
        fusha: true,
        perdoruesi: { select: { emri: true } },
      },
      orderBy: { data_rezervimit: 'desc' },
    });
    res.json(bookings);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së rezervimeve' });
  }
}

export async function getStats(req: AuthRequest, res: Response) {
  try {
    const [totalUsers, activeFields, todayBookings, activeEvents] = await Promise.all([
      prisma.user.count(),
      prisma.field.count({ where: { statusi: 'aktiv' } }),
      prisma.booking.count({
        where: {
          data_rezervimit: new Date(),
          statusi: 'konfirmuar',
        },
      }),
      prisma.event.count({ where: { statusi: 'aktiv' } }),
    ]);

    // Simplified weekly bookings for the chart
    const weeklyBookings = [
      { day: 'Hën', count: 12 },
      { day: 'Mar', count: 19 },
      { day: 'Mër', count: 15 },
      { day: 'Enj', count: 22 },
      { day: 'Pre', count: 30 },
      { day: 'Sht', count: 45 },
      { day: 'Die', count: 38 },
    ];

    res.json({
      totalUsers,
      activeFields,
      todayBookings,
      activeEvents,
      weeklyBookings,
    });
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së statistikave' });
  }
}

export async function getAllAnnouncementsAdmin(req: AuthRequest, res: Response) {
  try {
    const announcements = await prisma.announcement.findMany({
      include: { perdoruesi: { select: { emri: true } } },
      orderBy: { created_at: 'desc' }
    });
    res.json(announcements);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së njoftimeve' });
  }
}

export async function deleteAnnouncementAdmin(req: AuthRequest, res: Response) {
  try {
    const id = parseInt(req.params.id as any);
    await prisma.announcement.delete({ where: { id } });
    res.json({ message: 'Njoftimi u fshi me sukses' });
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë fshirjes së njoftimit' });
  }
}

export async function getAllTeamsAdmin(req: AuthRequest, res: Response) {
  try {
    const teams = await prisma.standaloneTeam.findMany({
      include: {
        kapiteni: { select: { emri: true } },
        _count: { select: { anetaret: true } }
      },
      orderBy: { created_at: 'desc' }
    });
    res.json(teams);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së ekipeve' });
  }
}