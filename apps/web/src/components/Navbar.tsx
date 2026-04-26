import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

export default function Navbar() {
  const { isLoggedIn, user, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <nav className="navbar">
      <div className="container navbar-content">
        <div className="navbar-brand">
          <Link to="/">
            TeFusha
          </Link>
        </div>
        <div className="navbar-links">
          <Link to="/fields">Fushat</Link>
          <Link to="/community">Komuniteti</Link>
          <Link to="/events">Eventet</Link>
          {isLoggedIn ? (
            <>
              <Link to="/my-bookings">Rezervimet</Link>
              <Link to="/profile">Profili</Link>
              {user?.roli === 'admin' && (
                <a href="http://localhost:3002" target="_blank" rel="noopener noreferrer" className="admin-link">Admin</a>
              )}
              <button onClick={handleLogout} className="btn-logout">Dil</button>
            </>
          ) : (
            <>
              <Link to="/login" className="login-link">Hyr</Link>
              <Link to="/register" className="btn btn-primary">Regjistrohu</Link>
            </>
          )}
        </div>
      </div>
      <style>{`
        .navbar {
          background-color: white;
          border-bottom: 1px solid var(--border);
          height: 70px;
          position: sticky;
          top: 0;
          z-index: 1000;
        }
        .navbar-content {
          display: flex;
          justify-content: space-between;
          align-items: center;
          height: 100%;
        }
        .navbar-brand a {
          color: var(--primary);
          text-decoration: none;
          font-size: 24px;
          font-weight: 800;
        }
        .navbar-links {
          display: flex;
          gap: 24px;
          align-items: center;
        }
        .navbar-links a {
          color: var(--text-primary);
          text-decoration: none;
          font-weight: 600;
          font-size: 15px;
          transition: color 0.2s;
        }
        .navbar-links a:hover {
          color: var(--primary);
        }
        .admin-link {
          color: var(--secondary) !important;
        }
        .btn-logout {
          background: none;
          border: 1px solid var(--border);
          padding: 8px 16px;
          border-radius: 6px;
          font-weight: 600;
          color: var(--text-secondary);
        }
        .btn-logout:hover {
          background-color: var(--background);
          color: var(--primary);
          border-color: var(--primary);
        }
        .login-link {
          margin-right: 8px;
        }
      `}</style>
    </nav>
  );
}
