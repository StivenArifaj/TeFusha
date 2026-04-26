import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';
import { AuthRequest } from '../middlewares/auth.middleware';

export async function getAllAnnouncements(req: Request, res: Response) {
  try {
    const { lloji_sportit, tipi } = req.query;
    
    const where: any = { statusi: 'aktiv' };
    if (lloji_sportit) where.lloji_sportit = lloji_sportit as string;
    if (tipi) where.tipi = tipi as any;

    const announcements = await prisma.announcement.findMany({
      where,
      include: {
        perdoruesi: {
          select: { id: true, emri: true }
        },
        _count: {
          select: { pergjigjet: true }
        }
      },
      orderBy: { created_at: 'desc' }
    });
    
    res.json(announcements);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së njoftimeve' });
  }
}

export async function getAnnouncementById(req: Request, res: Response) {
  try {
    const id = parseInt(req.params.id as any);
    const announcement = await prisma.announcement.findUnique({
      where: { id },
      include: {
        perdoruesi: {
          select: { id: true, emri: true }
        },
        pergjigjet: {
          include: {
            perdoruesi: {
              select: { id: true, emri: true }
            }
          },
          orderBy: { created_at: 'desc' }
        }
      }
    });

    if (!announcement) {
      return res.status(404).json({ error: 'Njoftimi nuk u gjet' });
    }

    res.json(announcement);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së njoftimit' });
  }
}

export async function createAnnouncement(req: AuthRequest, res: Response) {
  try {
    const { titull, pershkrim, lloji_sportit, vendndodhja, data_lojes, lojtare_nevojitet, tipi } = req.body;
    
    const announcement = await prisma.announcement.create({
      data: {
        userId: req.user!.id,
        titull,
        pershkrim,
        lloji_sportit,
        vendndodhja,
        data_lojes: data_lojes ? new Date(data_lojes) : null,
        lojtare_nevojitet,
        tipi,
      }
    });

    res.status(201).json(announcement);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë krijimit të njoftimit' });
  }
}

export async function updateAnnouncement(req: AuthRequest, res: Response) {
  try {
    const id = parseInt(req.params.id as any);
    const { titull, pershkrim, lloji_sportit, vendndodhja, data_lojes, lojtare_nevojitet, tipi, statusi } = req.body;

    const existing = await prisma.announcement.findUnique({ where: { id } });
    if (!existing) return res.status(404).json({ error: 'Njoftimi nuk u gjet' });
    if (existing.userId !== req.user!.id) return res.status(403).json({ error: 'Nuk keni autorizim për këtë veprim' });

    const announcement = await prisma.announcement.update({
      where: { id },
      data: {
        titull,
        pershkrim,
        lloji_sportit,
        vendndodhja,
        data_lojes: data_lojes ? new Date(data_lojes) : undefined,
        lojtare_nevojitet,
        tipi,
        statusi
      }
    });

    res.json(announcement);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë përditësimit të njoftimit' });
  }
}

export async function deleteAnnouncement(req: AuthRequest, res: Response) {
  try {
    const id = parseInt(req.params.id as any);

    const existing = await prisma.announcement.findUnique({ where: { id } });
    if (!existing) return res.status(404).json({ error: 'Njoftimi nuk u gjet' });
    if (existing.userId !== req.user!.id) return res.status(403).json({ error: 'Nuk keni autorizim për këtë veprim' });

    await prisma.announcement.delete({ where: { id } });
    res.json({ message: 'Njoftimi u fshi me sukses' });
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë fshirjes së njoftimit' });
  }
}

export async function respondToAnnouncement(req: AuthRequest, res: Response) {
  try {
    const announcementId = parseInt(req.params.id as any);
    const { mesazhi } = req.body;

    const response = await prisma.announcementResponse.create({
      data: {
        announcementId,
        userId: req.user!.id,
        mesazhi
      }
    });

    res.status(201).json(response);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë dërgimit të përgjigjes' });
  }
}
