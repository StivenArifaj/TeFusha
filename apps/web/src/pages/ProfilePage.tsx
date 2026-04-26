import React from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';

export default function ProfilePage() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  if (!user) return null;

  return (
    <div className="container profile-page">
      <div className="profile-header card">
        <div className="avatar">
          {user.emri.charAt(0).toUpperCase()}
        </div>
        <div className="info">
          <h1>{user.emri}</h1>
          <p>{user.email}</p>
          <span className="role-badge">{user.roli}</span>
        </div>
      </div>

      <div className="profile-actions">
        <div className="card action-card" onClick={() => navigate('/my-bookings')}>
          <h3>Rezervimet e Mia</h3>
          <p>Shiko historikun e lojërave dhe rezervimet aktive.</p>
        </div>
        <div className="card action-card">
          <h3>Ndrysho Profilin</h3>
          <p>Përditëso emrin, numrin e telefonit ose fjalëkalimin.</p>
        </div>
        <div className="card action-card logout" onClick={() => { logout(); navigate('/login'); }}>
          <h3>Dil nga Llogaria</h3>
          <p>Mbyll seancën tuaj në këtë pajisje.</p>
        </div>
      </div>

      <style>{`
        .profile-page {
          padding: 40px 20px;
          max-width: 800px;
        }
        .profile-header {
          display: flex;
          align-items: center;
          gap: 32px;
          margin-bottom: 40px;
        }
        .avatar {
          width: 100px;
          height: 100px;
          background: var(--primary-light);
          color: var(--primary);
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 40px;
          font-weight: 800;
        }
        .info h1 {
          font-size: 28px;
          margin-bottom: 4px;
        }
        .info p {
          color: var(--text-secondary);
          margin-bottom: 12px;
        }
        .role-badge {
          background: var(--background);
          padding: 4px 12px;
          border-radius: 20px;
          font-size: 12px;
          font-weight: 700;
          text-transform: uppercase;
        }
        .profile-actions {
          display: grid;
          gap: 20px;
        }
        .action-card {
          cursor: pointer;
          transition: transform 0.2s;
        }
        .action-card:hover {
          transform: translateX(10px);
          border-color: var(--primary);
        }
        .action-card h3 {
          font-size: 18px;
          margin-bottom: 8px;
        }
        .action-card p {
          color: var(--text-secondary);
          font-size: 14px;
        }
        .logout:hover {
          border-color: var(--error);
        }
        .logout h3 {
          color: var(--error);
        }
      `}</style>
    </div>
  );
}
