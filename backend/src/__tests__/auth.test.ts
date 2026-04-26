import request from 'supertest';
import app from '../app';
import { prismaMock } from '../utils/__mocks__/prisma';
import bcrypt from 'bcrypt';
import { mockReset } from 'jest-mock-extended';

jest.mock('../utils/prisma', () => ({
  prisma: require('../utils/__mocks__/prisma').prismaMock,
}));

beforeEach(() => {
  mockReset(prismaMock);
});

describe('Auth Endpoints', () => {
  describe('POST /api/auth/register', () => {
    it('should register a new user successfully', async () => {
      const userData = {
        emri: 'Test User',
        email: 'test@example.com',
        fjalekalimi: 'password123',
        roli: 'perdorues',
      };

      const hashedPassword = await bcrypt.hash(userData.fjalekalimi, 10);
      
      prismaMock.user.findUnique.mockResolvedValue(null);
      prismaMock.user.create.mockResolvedValue({
        id: 1,
        emri: userData.emri,
        email: userData.email,
        fjalekalimi: hashedPassword,
        roli: 'perdorues',
        data_regjistrimit: new Date(),
        nr_telefoni: null,
      } as any);

      const response = await request(app)
        .post('/api/auth/register')
        .send(userData);

      expect(response.status).toBe(201);
      expect(response.body).toHaveProperty('user');
      expect(response.body).toHaveProperty('access');
      expect(response.body).toHaveProperty('refresh');
      expect(prismaMock.user.create).toHaveBeenCalled();
    });

    it('should return 400 if email already exists', async () => {
      const userData = {
        emri: 'Test User',
        email: 'test@example.com',
        fjalekalimi: 'password123',
      };

      prismaMock.user.findUnique.mockResolvedValue({ id: 1 } as any);

      const response = await request(app)
        .post('/api/auth/register')
        .send(userData);

      expect(response.status).toBe(400);
      expect(response.body).toHaveProperty('error', 'Ky email është i regjistruar');
    });
  });

  describe('POST /api/auth/login', () => {
    it('should login successfully with correct credentials', async () => {
      const loginData = {
        email: 'test@example.com',
        fjalekalimi: 'password123',
      };

      const hashedPassword = await bcrypt.hash(loginData.fjalekalimi, 10);

      prismaMock.user.findUnique.mockResolvedValue({
        id: 1,
        emri: 'Test User',
        email: loginData.email,
        fjalekalimi: hashedPassword,
        roli: 'perdorues',
      } as any);

      const response = await request(app)
        .post('/api/auth/login')
        .send(loginData);

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('access');
      expect(response.body).toHaveProperty('refresh');
      expect(response.body.user).toHaveProperty('email', loginData.email);
    });

    it('should return 401 with incorrect password', async () => {
      const loginData = {
        email: 'test@example.com',
        fjalekalimi: 'wrongpassword',
      };

      const hashedPassword = await bcrypt.hash('correctpassword', 10);

      prismaMock.user.findUnique.mockResolvedValue({
        id: 1,
        email: loginData.email,
        fjalekalimi: hashedPassword,
      } as any);

      const response = await request(app)
        .post('/api/auth/login')
        .send(loginData);

      expect(response.status).toBe(401);
      expect(response.body).toHaveProperty('error', 'Email ose fjalëkalim i gabuar');
    });
  });
});
