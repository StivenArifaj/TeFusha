import request from 'supertest';
import { prismaMock } from '../utils/__mocks__/prisma';
import jwt from 'jsonwebtoken';

const SECRET = 'test_secret_for_unit_tests';
process.env.JWT_SECRET = SECRET;

// Import app after setting SECRET
const app = require('../app').default;

jest.mock('../utils/prisma', () => ({
  prisma: require('../utils/__mocks__/prisma').prismaMock,
}));

const userToken = jwt.sign({ id: 1, roli: 'perdorues' }, SECRET);
const ownerToken = jwt.sign({ id: 2, roli: 'pronar_fushe' }, SECRET);

describe('Booking Endpoints', () => {
  describe('POST /api/bookings', () => {
    it('should create a booking successfully', async () => {
      const bookingData = {
        fusha_id: 1,
        data_rezervimit: '2026-05-01',
        ora_fillimit: '10:00',
        ora_mbarimit: '11:00',
      };

      prismaMock.field.findUnique.mockResolvedValue({ id: 1, cmimi_orari: 1000 } as any);
      
      // Mock transaction
      prismaMock.$transaction.mockImplementation(async (callback: any) => {
        return callback(prismaMock);
      });

      prismaMock.$queryRaw.mockResolvedValue([]);
      prismaMock.booking.create.mockResolvedValue({ id: 1, ...bookingData, statusi: 'ne_pritje' } as any);

      const response = await request(app)
        .post('/api/bookings')
        .set('Authorization', `Bearer ${userToken}`)
        .send(bookingData);

      expect(response.status).toBe(201);
      expect(response.body).toHaveProperty('id');
      expect(prismaMock.booking.create).toHaveBeenCalled();
    });

    it('should return 409 if slot is taken', async () => {
      const bookingData = {
        fusha_id: 1,
        data_rezervimit: '2026-05-01',
        ora_fillimit: '10:00',
        ora_mbarimit: '11:00',
      };

      prismaMock.field.findUnique.mockResolvedValue({ id: 1, cmimi_orari: 1000 } as any);
      
      prismaMock.$transaction.mockImplementation(async (callback: any) => {
        return callback(prismaMock);
      });

      prismaMock.$queryRaw.mockResolvedValue([{ id: 99 }]); // Conflict found

      const response = await request(app)
        .post('/api/bookings')
        .set('Authorization', `Bearer ${userToken}`)
        .send(bookingData);

      expect(response.status).toBe(409);
      expect(response.body).toHaveProperty('error', 'Ora është e zënë — zgjedh një orar tjetër');
    });
  });

  describe('GET /api/bookings/mine', () => {
    it('should return user bookings', async () => {
      prismaMock.booking.findMany.mockResolvedValue([
        { id: 1, fusha_id: 1, statusi: 'konfirmuar' }
      ] as any);

      const response = await request(app)
        .get('/api/bookings/mine')
        .set('Authorization', `Bearer ${userToken}`);

      expect(response.status).toBe(200);
      expect(Array.isArray(response.body)).toBe(true);
      expect(response.body).toHaveLength(1);
    });
  });
});
