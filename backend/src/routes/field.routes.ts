import { Router } from 'express';
import * as fieldController from '../controllers/field.controller';
import { authenticate, requireRole } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { fieldSchema, fieldUpdateSchema } from '../utils/validators';

const router = Router();

router.get('/', fieldController.getAllFields);
router.get('/mine', authenticate, requireRole('pronar_fushe', 'admin'), fieldController.getMyFields);
router.get('/:id', fieldController.getFieldById);
router.get('/:id/availability', fieldController.getFieldAvailability);
router.get('/:id/bookings', authenticate, requireRole('pronar_fushe', 'admin'), fieldController.getFieldBookings);

router.post('/', authenticate, requireRole('pronar_fushe', 'admin'), validate(fieldSchema), fieldController.createField);
router.put('/:id', authenticate, requireRole('pronar_fushe', 'admin'), validate(fieldUpdateSchema), fieldController.updateField);
router.delete('/:id', authenticate, requireRole('pronar_fushe', 'admin'), fieldController.deactivateField);

export default router;