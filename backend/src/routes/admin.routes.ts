import { Router } from 'express';
import * as adminController from '../controllers/admin.controller';
import { authenticate, requireRole } from '../middlewares/auth.middleware';

const router = Router();

router.use(authenticate, requireRole('admin'));

router.get('/users', adminController.getAllUsers);
router.put('/users/:id/role', adminController.updateUserRole);
router.get('/fields', adminController.getAllFieldsAdmin);
router.put('/fields/:id/status', adminController.updateFieldStatus);
router.get('/bookings', adminController.getAllBookingsAdmin);
router.get('/stats', adminController.getStats);

router.get('/announcements', adminController.getAllAnnouncementsAdmin);
router.delete('/announcements/:id', adminController.deleteAnnouncementAdmin);
router.get('/teams', adminController.getAllTeamsAdmin);

export default router;