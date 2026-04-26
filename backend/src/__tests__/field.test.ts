import request from 'supertest';
import { prismaMock } from '../utils/__mocks__/prisma';
import jwt from 'jsonwebtoken';

const SECRET = 'test_secret_for_unit_tests';
process.env.JWT_SECRET = SECRET;

const app = require('../app').default;

jest.mock('../utils/prisma', () => ({
  prisma: require('../utils/__mocks__/prisma').prismaMock,
}));

const adminToken = jwt.sign({ id: 1, roli: 'admin' }, SECRET);
const ownerToken = jwt.sign({ id: 2, roli: 'pronar_fushe' }, SECRET);
const userToken = jwt.sign({ id: 3, roli: 'perdorues' }, SECRET);

describe('Field Endpoints', () => {
  describe('GET /api/fields', () => {
    it('should return all active fields', async () => {
      prismaMock.field.findMany.mockResolvedValue([
        { id: 1, emri_fushes: 'Fusha 1', statusi: 'aktiv' }
      ] as any);

      const response = await request(app).get('/api/fields');

      expect(response.status).toBe(200);
      expect(response.body).toHaveLength(1);
    });
  });

  describe('POST /api/fields', () => {
    it('should create a field as an owner', async () => {
      const fieldData = {
        emri_fushes: 'Fusha e Re',
        lloji_fushes: 'futboll',
        vendndodhja: 'Rruga 123',
        qyteti: 'Tiranë',
        cmimi_orari: 2000,
        kapaciteti: 12,
      };

      prismaMock.field.create.mockResolvedValue({ id: 1, ...fieldData, statusi: 'aktiv' } as any);

      const response = await request(app)
        .post('/api/fields')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send(fieldData);

      expect(response.status).toBe(201);
      expect(response.body).toHaveProperty('id');
    });

    it('should return 403 if user is not an owner or admin', async () => {
      const fieldData = {
        emri_fushes: 'Fusha e Re',
        lloji_fushes: 'futboll',
        vendndodhja: 'Rruga 123',
        qyteti: 'Tiranë',
        cmimi_orari: 2000,
        kapaciteti: 12,
      };

      const response = await request(app)
        .post('/api/fields')
        .set('Authorization', `Bearer ${userToken}`)
        .send(fieldData);

      expect(response.status).toBe(403);
    });
  });
});
