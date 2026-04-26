import { Response } from 'express';
import { prisma } from '../utils/prisma';
import { AuthRequest } from '../middlewares/auth.middleware';

export async function getMyTeams(req: AuthRequest, res: Response) {
  try {
    const teams = await prisma.standaloneTeam.findMany({
      where: {
        OR: [
          { kapiteni_id: req.user!.id },
          { anetaret: { some: { userId: req.user!.id } } }
        ]
      },
      include: {
        kapiteni: { select: { id: true, emri: true } },
        _count: { select: { anetaret: true } }
      }
    });
    res.json(teams);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së ekipeve' });
  }
}

export async function getTeamById(req: AuthRequest, res: Response) {
  try {
    const id = parseInt(req.params.id as any);
    const team = await prisma.standaloneTeam.findUnique({
      where: { id },
      include: {
        kapiteni: { select: { id: true, emri: true } },
        anetaret: {
          include: {
            perdoruesi: { select: { id: true, emri: true } }
          }
        }
      }
    });

    if (!team) return res.status(404).json({ error: 'Ekipi nuk u gjet' });
    res.json(team);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë marrjes së ekipit' });
  }
}

export async function createTeam(req: AuthRequest, res: Response) {
  try {
    const { emri, lloji_sportit, pershkrim } = req.body;
    
    const team = await prisma.$transaction(async (tx) => {
      const newTeam = await tx.standaloneTeam.create({
        data: {
          emri,
          lloji_sportit,
          pershkrim,
          kapiteni_id: req.user!.id
        }
      });

      await tx.standaloneTeamMember.create({
        data: {
          ekipi_id: newTeam.id,
          userId: req.user!.id,
          roli: 'kapiteni'
        }
      });

      return newTeam;
    });

    res.status(201).json(team);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë krijimit të ekipit' });
  }
}

export async function updateTeam(req: AuthRequest, res: Response) {
  try {
    const id = parseInt(req.params.id as any);
    const { emri, lloji_sportit, pershkrim } = req.body;

    const existing = await prisma.standaloneTeam.findUnique({ where: { id } });
    if (!existing) return res.status(404).json({ error: 'Ekipi nuk u gjet' });
    if (existing.kapiteni_id !== req.user!.id) return res.status(403).json({ error: 'Vetëm kapiteni mund të ndryshojë ekipin' });

    const team = await prisma.standaloneTeam.update({
      where: { id },
      data: { emri, lloji_sportit, pershkrim }
    });

    res.json(team);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë përditësimit të ekipit' });
  }
}

export async function joinTeam(req: AuthRequest, res: Response) {
  try {
    const ekipi_id = parseInt(req.params.id as any);
    
    // In a real app we'd check for invitations, but instructions are minimal
    // We'll allow direct join for now if not already a member
    
    const existing = await prisma.standaloneTeamMember.findUnique({
      where: { ekipi_id_userId: { ekipi_id, userId: req.user!.id } }
    });

    if (existing) return res.status(400).json({ error: 'Jeni tashmë anëtar i këtij ekipi' });

    const member = await prisma.standaloneTeamMember.create({
      data: {
        ekipi_id,
        userId: req.user!.id,
        roli: 'anetare'
      }
    });

    res.status(201).json(member);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë bashkimit me ekipin' });
  }
}

export async function removeMember(req: AuthRequest, res: Response) {
  try {
    const ekipi_id = parseInt(req.params.id as any);
    const userId = parseInt(req.params.userId as any);

    const team = await prisma.standaloneTeam.findUnique({ where: { id: ekipi_id } });
    if (!team) return res.status(404).json({ error: 'Ekipi nuk u gjet' });
    
    if (team.kapiteni_id !== req.user!.id && userId !== req.user!.id) {
      return res.status(403).json({ error: 'Nuk keni autorizim për këtë veprim' });
    }

    if (team.kapiteni_id === userId) {
      return res.status(400).json({ error: 'Kapiteni nuk mund të largohet pa e kaluar rolin' });
    }

    await prisma.standaloneTeamMember.delete({
      where: { ekipi_id_userId: { ekipi_id, userId } }
    });

    res.json({ message: 'Anëtari u hoq me sukses' });
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë heqjes së anëtarit' });
  }
}
