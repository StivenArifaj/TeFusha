import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import apiClient from '../api/client';
import { ENDPOINTS } from '../api/endpoints';
import { useAuth } from '../context/AuthContext';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    
    try {
      const { data } = await apiClient.post(ENDPOINTS.LOGIN, { email, fjalekalimi: password });
      login(data);
      navigate('/');
    } catch (err: any) {
      setError(err.response?.data?.error || 'Email ose fjalëkalim i pasaktë');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="auth-page">
      <div className="auth-container card">
        <h2 className="auth-title">Mirësevini përsëri</h2>
        <p className="auth-subtitle">Hyr në llogarinë tënde për të rezervuar fushën</p>
        
        {error && <div className="error-box">{error}</div>}
        
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label>Email</label>
            <input
              type="email"
              placeholder="emri@shembull.al"
              value={email}
              onChange={e => setEmail(e.target.value)}
              required
            />
          </div>
          <div className="form-group">
            <label>Fjalëkalimi</label>
            <input
              type="password"
              placeholder="••••••••"
              value={password}
              onChange={e => setPassword(e.target.value)}
              required
            />
          </div>
          <button
            type="submit"
            className="btn btn-primary w-full"
            disabled={loading}
          >
            {loading ? 'Duke hyrë...' : 'Hyr'}
          </button>
        </form>
        
        <p className="auth-footer">
          Nuk keni llogari? <Link to="/register">Regjistrohu këtu</Link>
        </p>
      </div>

      <style>{`
        .auth-page {
          min-height: calc(100vh - 70px);
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 20px;
          background: #f0f2f5;
        }
        .auth-container {
          width: 100%;
          max-width: 450px;
          padding: 48px;
        }
        .auth-title {
          text-align: center;
          font-size: 28px;
          margin-bottom: 8px;
        }
        .auth-subtitle {
          text-align: center;
          color: var(--text-secondary);
          margin-bottom: 32px;
          font-size: 15px;
        }
        .error-box {
          background-color: #fee2e2;
          color: #dc2626;
          padding: 12px 16px;
          border-radius: 8px;
          margin-bottom: 24px;
          font-size: 14px;
          font-weight: 600;
          text-align: center;
        }
        .form-group {
          margin-bottom: 20px;
          display: flex;
          flex-direction: column;
          gap: 8px;
        }
        .form-group label {
          font-weight: 700;
          font-size: 14px;
        }
        .form-group input {
          padding: 12px 16px;
          border: 1px solid var(--border);
          border-radius: 8px;
          font-size: 16px;
        }
        .form-group input:focus {
          outline: none;
          border-color: var(--primary);
          box-shadow: 0 0 0 3px var(--primary-light);
        }
        .w-full { width: 100%; }
        .auth-footer {
          text-align: center;
          margin-top: 32px;
          font-size: 14px;
          color: var(--text-secondary);
        }
        .auth-footer a {
          color: var(--primary);
          text-decoration: none;
          font-weight: 700;
        }
      `}</style>
    </div>
  );
}
