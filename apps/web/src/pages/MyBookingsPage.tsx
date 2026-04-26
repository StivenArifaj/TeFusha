import React from 'react';
import { useQuery } from '@tanstack/react-query';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';

interface Booking {
  id: number;
  data_rezervimit: string;
  ora_fillimit: string;
  ora_mbarimit: string;
  statusi: string;
  fusha: {
    emri_fushes: string;
    vendndodhja: string;
  };
}

export default function MyBookingsPage() {
  const { token } = useAuth();

  const { data: bookings, isLoading } = useQuery<Booking[]>({
    queryKey: ['my-bookings'],
    queryFn: async () => {
      const res = await axios.get('http://localhost:4000/api/bookings/my', {
        headers: { Authorization: `Bearer ${token}` }
      });
      return res.data;
    }
  });

  return (
    <div className="container bookings-page">
      <h1>Rezervimet e Mia</h1>
      
      <div className="bookings-list">
        {isLoading ? (
          <p>Duke ngarkuar rezervimet...</p>
        ) : bookings?.length === 0 ? (
          <div className="empty-state card">
            <p>Nuk keni asnjë rezervim ende.</p>
          </div>
        ) : (
          bookings?.map(booking => (
            <div key={booking.id} className="booking-card card">
              <div className="info">
                <h3>{booking.fusha.emri_fushes}</h3>
                <p className="location">📍 {booking.fusha.vendndodhja}</p>
                <div className="time">
                  <span>📅 {new Date(booking.data_rezervimit).toLocaleDateString('sq-AL')}</span>
                  <span>⏰ {booking.ora_fillimit} - {booking.ora_mbarimit}</span>
                </div>
              </div>
              <div className="status">
                <span className={`status-badge ${booking.statusi}`}>
                  {booking.statusi === 'konfirmuar' ? 'I Konfirmuar' : 'Në Pritje'}
                </span>
              </div>
            </div>
          ))
        )}
      </div>

      <style>{`
        .bookings-page {
          padding: 40px 20px;
        }
        .bookings-page h1 {
          margin-bottom: 32px;
        }
        .bookings-list {
          display: grid;
          gap: 16px;
        }
        .booking-card {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        .booking-card h3 {
          font-size: 18px;
          margin-bottom: 4px;
        }
        .location {
          color: var(--text-secondary);
          font-size: 13px;
          margin-bottom: 12px;
        }
        .time {
          display: flex;
          gap: 20px;
          font-weight: 700;
          font-size: 14px;
        }
        .status-badge {
          padding: 6px 12px;
          border-radius: 8px;
          font-size: 12px;
          font-weight: 800;
          text-transform: uppercase;
        }
        .status-badge.konfirmuar { background: #E8F5E9; color: #2E7D32; }
        .status-badge.ne_pritje { background: #FFF3E0; color: #EF6C00; }
        .empty-state {
          text-align: center;
          padding: 60px;
          color: var(--text-secondary);
        }
      `}</style>
    </div>
  );
}
