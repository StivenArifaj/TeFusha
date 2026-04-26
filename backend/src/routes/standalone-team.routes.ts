import { Router } from 'express';
import * as teamController from '../controllers/standalone-team.controller';
import { authenticate } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createStandaloneTeamSchema } from '../utils/validators';

const router = Router();

router.get('/mine', authenticate, teamController.getMyTeams);
router.get('/:id', authenticate, teamController.getTeamById);

router.post('/', authenticate, validate(createStandaloneTeamSchema), teamController.createTeam);
router.put('/:id', authenticate, teamController.updateTeam);
router.post('/:id/join', authenticate, teamController.joinTeam);
router.delete('/:id/members/:userId', authenticate, teamController.removeMember);

export default router;
