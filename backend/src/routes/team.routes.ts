import { Router } from 'express';
import * as teamController from '../controllers/team.controller';
import { authenticate } from '../middlewares/auth.middleware';

const router = Router();

router.get('/mine', authenticate, teamController.getMyTeams);
router.post('/', authenticate, teamController.createTeam);

export default router;
