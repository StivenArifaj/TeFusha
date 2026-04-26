import { Router } from 'express';
import * as bookingController from '../controllers/booking.controller';
import { authenticate, requireRole } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { bookingSchema } from '../utils/validators';

const router = Router();

router.use(authenticate);

router.get('/mine', bookingController.getMyBookings);
router.post('/', validate(bookingSchema), bookingController.createBooking);
router.put('/:id/confirm', requireRole('pronar_fushe', 'admin'), bookingController.confirmBooking);
router.put('/:id/cancel', bookingController.cancelBooking);
router.get('/field/:fieldId', requireRole('pronar_fushe', 'admin'), bookingController.getFieldBookings);

export default router;