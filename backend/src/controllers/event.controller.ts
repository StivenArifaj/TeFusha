import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';
import { AuthRequest } from '../middlewares/auth.middleware';
import { generateRoundRobin } from '../services/fixture.service';

export async function getAllEvents(req: Request, res: Response) {
  try {
    const events = await prisma.event.findMany({
      include: { fusha: true },
    });
    res.json(events);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së eventeve' });
  }
}

export async function getEventById(req: Request, res: Response) {
  try {
    const event = await prisma.event.findUnique({
      where: { id: parseInt(req.params.id as any) },
      include: {
        fusha: true,
        ekipet: { include: { ekipi: { include: { anetaret: { include: { perdoruesi: { select: { emri: true } } } } } } } },
        ndeshjet: { include: { ekipi_shtepi: true, ekipi_udhetimit: true } },
      },
    });
    if (!event) {
      res.status(404).json({ error: 'Eventi nuk u gjet' });
      return;
    }
    res.json(event);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së eventit' });
  }
}

export async function createEvent(req: AuthRequest, res: Response) {
  try {
    const { emri_eventit, lloji, fusha_id, data_fillimit, data_mbarimit, nr_max_ekipesh } = req.body;
    const event = await prisma.event.create({
      data: {
        emri_eventit,
        lloji,
        fusha_id,
        data_fillimit: new Date(data_fillimit),
        data_mbarimit: new Date(data_mbarimit),
        nr_max_ekipesh,
        organizatori_id: req.user!.id,
      },
    });
    res.status(201).json(event);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë krijimit të eventit' });
  }
}

export async function registerTeam(req: AuthRequest, res: Response) {
  try {
    const eventi_id = parseInt(req.params.id as any);
    const { emri } = req.body;

    const event = await prisma.event.findUnique({
      where: { id: eventi_id },
      include: { ekipet: true },
    });

    if (!event) {
      res.status(404).json({ error: 'Eventi nuk u gjet' });
      return;
    }

    if (event.ekipet.length >= event.nr_max_ekipesh) {
      res.status(400).json({ error: 'Eventi është plot' });
      return;
    }

    const team = await prisma.team.create({
      data: {
        emri,
        kapiteni_id: req.user!.id,
        anetaret: {
          create: { perdoruesi_id: req.user!.id },
        },
        eventet: {
          create: { eventi_id }
        }
      },
    });

    res.status(201).json(team);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë regjistrimit të ekipit' });
  }
}

export async function generateFixtures(req: AuthRequest, res: Response) {
  try {
    const eventi_id = parseInt(req.params.id as any);
    const event = await prisma.event.findUnique({
      where: { id: eventi_id },
      include: { ekipet: true, ndeshjet: true },
    });

    if (!event || (event.organizatori_id !== req.user!.id && req.user!.roli !== 'admin')) {
      res.status(403).json({ error: 'Akses i ndaluar' });
      return;
    }

    if (event.ndeshjet.length > 0) {
      res.status(400).json({ error: 'Ndeshjet janë gjeneruar më parë' });
      return;
    }

    const teamIds = event.ekipet.map((t: any) => t.ekipi_id);
    const fixtures = generateRoundRobin(teamIds);

    const matches = await Promise.all(
      fixtures.map(f =>
        prisma.match.create({
          data: {
            eventi_id,
            ekipi_shtepi_id: f.home_team_id,
            ekipi_udhetimit_id: f.away_team_id,
            raundi: `Raundi ${f.round}`,
          },
        })
      )
    );

    await prisma.event.update({
      where: { id: eventi_id },
      data: { statusi: 'aktiv' },
    });

    res.json(matches);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë gjenerimit të ndeshjeve' });
  }
}

export async function updateMatchResult(req: AuthRequest, res: Response) {
  try {
    const matchId = parseInt(req.params.matchId as any);
    const eventi_id = parseInt(req.params.id as any);
    const { gola_shtepi, gola_udhetimit } = req.body;

    const event = await prisma.event.findUnique({ where: { id: eventi_id } });
    if (!event || (event.organizatori_id !== req.user!.id && req.user!.roli !== 'admin')) {
      res.status(403).json({ error: 'Akses i ndaluar' });
      return;
    }

    const match = await prisma.match.update({
      where: { id: matchId },
      data: { gola_shtepi, gola_udhetimit },
    });

    res.json(match);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë përditësimit të rezultatit' });
  }
}