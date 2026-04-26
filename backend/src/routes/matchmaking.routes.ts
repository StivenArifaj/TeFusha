import { Router } from 'express';
import * as matchmakingController from '../controllers/matchmaking.controller';
import { authenticate } from '../middlewares/auth.middleware';

const router = Router();

router.get('/', matchmakingController.getPosts);
router.post('/', authenticate, matchmakingController.createPost);

export default router;
