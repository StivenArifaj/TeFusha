import { Router } from 'express';
import * as eventController from '../controllers/event.controller';
import { authenticate, requireRole } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { eventSchema, teamSchema, matchUpdateSchema } from '../utils/validators';

const router = Router();

router.get('/', eventController.getAllEvents);
router.get('/:id', eventController.getEventById);

router.post('/', authenticate, validate(eventSchema), eventController.createEvent);
router.post('/:id/teams', authenticate, validate(teamSchema), eventController.registerTeam);
router.post('/:id/generate-fixtures', authenticate, eventController.generateFixtures);
router.put('/:id/matches/:matchId', authenticate, validate(matchUpdateSchema), eventController.updateMatchResult);

export default router;