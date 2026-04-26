import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import authRoutes from './routes/auth.routes';
import fieldRoutes from './routes/field.routes';
import bookingRoutes from './routes/booking.routes';
import eventRoutes from './routes/event.routes';
import adminRoutes from './routes/admin.routes';
import matchmakingRoutes from './routes/matchmaking.routes';
import announcementRoutes from './routes/announcement.routes';
import standaloneTeamRoutes from './routes/standalone-team.routes';
import teamRoutes from './routes/team.routes';
import { apiLimiter } from './middlewares/rate-limit';

dotenv.config();

const app = express();

// Middlewares
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || 'http://localhost:3000',
}));
app.use(express.json());
app.use(apiLimiter);

// Root route
app.get('/', (req, res) => res.json({ message: 'Mirësevini në API e TeFusha!' }));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/fields', fieldRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/events', eventRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/matchmaking', matchmakingRoutes);
app.use('/api/announcements', announcementRoutes);
app.use('/api/teams', standaloneTeamRoutes);
// app.use('/api/teams-legacy', teamRoutes);

// Health check
app.get('/health', (req, res) => res.json({ status: 'ok', timestamp: new Date() }));

// Error handling middleware
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {        
  console.error(err.stack);
  res.status(500).json({ error: 'Diçka shkoi keq!' });
});

export default app;
