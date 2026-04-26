import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';
import { AuthRequest } from '../middlewares/auth.middleware';

export async function getPosts(req: Request, res: Response) {
  try {
    const posts = await prisma.matchmakingPost.findMany({
      where: { statusi: 'aktiv' },
      include: { perdoruesi: { select: { emri: true, nr_telefoni: true } } },
      orderBy: { created_at: 'desc' }
    });
    res.json(posts);
  } catch (error) {
    res.status(500).json({ error: 'Gabim në server gjatë marrjes së njoftimeve' });
  }
}

export async function createPost(req: AuthRequest, res: Response) {
  try {
    const { titulli, pershkrimi, lloji_sportit, qyteti, data_ndeshjes } = req.body;
    const post = await prisma.matchmakingPost.create({
      data: {
        perdoruesi_id: req.user!.id,
        titulli,
        pershkrimi,
        lloji_sportit,
        qyteti,
        data_ndeshjes: data_ndeshjes ? new Date(data_ndeshjes) : null,
      }
    });
    res.status(201).json(post);
  } catch (error) {
    res.status(500).json({ error: 'Gabim gjatë krijimit të njoftimit' });
  }
}
