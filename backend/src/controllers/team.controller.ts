import { Response } from 'express';
import { prisma } from '../utils/prisma';
import { AuthRequest } from '../middlewares/auth.middleware';

export async function getMyTeams(req: AuthRequest, res: Response) {
  try {
    const teams = await prisma.team.findMany({
      where: {
        OR: [
          { kapiteni_id: req.user!.id },
          { anetaret: { some: { perdoruesi_id: req.user!.id } } }
        ]
      },
      include: {
        kapiteni: { select: { emri: true } },
        anetaret: { include: { perdoruesi: { select: { emri: true } } } }
      }
    });
    res.json(teams);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së ekipeve' });
  }
}

export async function createTeam(req: AuthRequest, res: Response) {
  try {
    const { emri, logo_url } = req.body;
    const team = await prisma.team.create({
      data: {
        emri,
        logo_url,
        kapiteni_id: req.user!.id
      }
    });
    res.status(201).json(team);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë krijimit të ekipit' });
  }
}
