import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import apiClient from '../api/client';
import { ENDPOINTS } from '../api/endpoints';
import { useAuth } from '../context/AuthContext';

export default function RegisterPage() {
  const [formData, setFormData] = useState({
    emri: '',
    email: '',
    fjalekalimi: '',
    roli: 'perdorues'
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    
    try {
      const { data } = await apiClient.post(ENDPOINTS.REGISTER, formData);
      login(data);
      navigate('/');
    } catch (err: any) {
      setError(err.response?.data?.error || 'Gabim gjatë regjistrimit');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="auth-page">
      <div className="auth-container card">
        <h2 className="auth-title">Krijo një llogari</h2>
        <p className="auth-subtitle">Bëhu pjesë e rrjetit më të madh sportiv në Shqipëri</p>
        
        {error && <div className="error-box">{error}</div>}
        
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label>Emri i plotë</label>
            <input
              type="text"
              placeholder="Emër Mbiemër"
              value={formData.emri}
              onChange={e => setFormData({...formData, emri: e.target.value})}
              required
            />
          </div>
          <div className="form-group">
            <label>Email</label>
            <input
              type="email"
              placeholder="emri@shembull.al"
              value={formData.email}
              onChange={e => setFormData({...formData, email: e.target.value})}
              required
            />
          </div>
          <div className="form-group">
            <label>Fjalëkalimi</label>
            <input
              type="password"
              placeholder="Paktën 6 karaktere"
              value={formData.fjalekalimi}
              onChange={e => setFormData({...formData, fjalekalimi: e.target.value})}
              required
            />
          </div>

          <div className="form-group">
            <label>Ju jeni:</label>
            <div className="role-selector">
              <label className={`role-option ${formData.roli === 'perdorues' ? 'active' : ''}`}>
                <input 
                  type="radio" 
                  name="roli" 
                  value="perdorues" 
                  checked={formData.roli === 'perdorues'}
                  onChange={e => setFormData({...formData, roli: e.target.value})}
                />
                Lojtar
              </label>
              <label className={`role-option ${formData.roli === 'pronar_fushe' ? 'active' : ''}`}>
                <input 
                  type="radio" 
                  name="roli" 
                  value="pronar_fushe" 
                  checked={formData.roli === 'pronar_fushe'}
                  onChange={e => setFormData({...formData, roli: e.target.value})}
                />
                Pronar Fushe
              </label>
            </div>
          </div>

          <button
            type="submit"
            className="btn btn-primary w-full"
            disabled={loading}
          >
            {loading ? 'Duke u regjistruar...' : 'Regjistrohu'}
          </button>
        </form>
        
        <p className="auth-footer">
          Keni një llogari? <Link to="/login">Hyr këtu</Link>
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
          max-width: 500px;
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
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="password"] {
          padding: 12px 16px;
          border: 1px solid var(--border);
          border-radius: 8px;
          font-size: 16px;
        }
        .role-selector {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 12px;
        }
        .role-option {
          border: 1px solid var(--border);
          padding: 12px;
          border-radius: 8px;
          text-align: center;
          cursor: pointer;
          font-weight: 700;
          font-size: 14px;
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 8px;
        }
        .role-option input {
          display: none;
        }
        .role-option.active {
          border-color: var(--primary);
          background-color: var(--primary-light);
          color: var(--primary);
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
