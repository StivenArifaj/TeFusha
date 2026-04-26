import { Router } from 'express';
import * as announcementController from '../controllers/announcement.controller';
import { authenticate } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createAnnouncementSchema } from '../utils/validators';

const router = Router();

router.get('/', announcementController.getAllAnnouncements);
router.get('/:id', announcementController.getAnnouncementById);

router.post('/', authenticate, validate(createAnnouncementSchema), announcementController.createAnnouncement);
router.put('/:id', authenticate, announcementController.updateAnnouncement);
router.delete('/:id', authenticate, announcementController.deleteAnnouncement);
router.post('/:id/respond', authenticate, announcementController.respondToAnnouncement);

export default router;
