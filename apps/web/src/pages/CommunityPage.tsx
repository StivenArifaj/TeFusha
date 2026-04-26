import React, { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';

interface Announcement {
  id: number;
  titull: string;
  pershkrim: string;
  tipi: string;
  lloji_sportit: string;
  lojtare_nevojitet: number;
  created_at: string;
  perdoruesi: {
    emri: string;
  };
}

export default function CommunityPage() {
  const { isLoggedIn, token } = useAuth();
  const queryClient = useQueryClient();
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState({
    titull: '',
    pershkrim: '',
    tipi: 'kerko_lojtar',
    lloji_sportit: 'futboll',
    lojtare_nevojitet: 1
  });

  const { data: announcements, isLoading } = useQuery<Announcement[]>({
    queryKey: ['announcements'],
    queryFn: async () => {
      const res = await axios.get('http://localhost:4000/api/announcements');
      return res.data.value;
    }
  });

  const mutation = useMutation({
    mutationFn: (newAnnouncement: any) => {
      return axios.post('http://localhost:4000/api/announcements', newAnnouncement, {
        headers: { Authorization: `Bearer ${token}` }
      });
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['announcements'] });
      setShowForm(false);
      setFormData({
        titull: '',
        pershkrim: '',
        tipi: 'kerko_lojtar',
        lloji_sportit: 'futboll',
        lojtare_nevojitet: 1
      });
    }
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    mutation.mutate(formData);
  };

  return (
    <div className="container community-page">
      <div className="header">
        <h1>Komuniteti</h1>
        {isLoggedIn && (
          <button className="btn btn-primary" onClick={() => setShowForm(!showForm)}>
            {showForm ? 'Anulo' : 'Krijo Njoftim +'}
          </button>
        )}
      </div>

      {showForm && (
        <form className="announcement-form card" onSubmit={handleSubmit}>
          <h3>Krijo Njoftim të Ri</h3>
          <div className="form-group">
            <label>Titulli</label>
            <input 
              type="text" 
              required 
              value={formData.titull}
              onChange={e => setFormData({...formData, titull: e.target.value})}
            />
          </div>
          <div className="form-row">
            <div className="form-group">
              <label>Tipi</label>
              <select 
                value={formData.tipi}
                onChange={e => setFormData({...formData, tipi: e.target.value})}
              >
                <option value="kerko_lojtar">Kërkojmë Lojtar</option>
                <option value="kerko_kundershtare">Kërkojmë Kundërshtar</option>
                <option value="kerko_ekip">Kërkoj Ekip</option>
              </select>
            </div>
            <div className="form-group">
              <label>Sporti</label>
              <select 
                value={formData.lloji_sportit}
                onChange={e => setFormData({...formData, lloji_sportit: e.target.value})}
              >
                <option value="futboll">Futboll</option>
                <option value="basketboll">Basketboll</option>
                <option value="tenis">Tenis</option>
                <option value="volejboll">Volejboll</option>
              </select>
            </div>
            <div className="form-group">
              <label>Nr. Lojtarëve</label>
              <input 
                type="number" 
                min="1"
                value={formData.lojtare_nevojitet}
                onChange={e => setFormData({...formData, lojtare_nevojitet: parseInt(e.target.value)})}
              />
            </div>
          </div>
          <div className="form-group">
            <label>Përshkrimi</label>
            <textarea 
              rows={3} 
              required
              value={formData.pershkrim}
              onChange={e => setFormData({...formData, pershkrim: e.target.value})}
            ></textarea>
          </div>
          <button type="submit" className="btn btn-primary" disabled={mutation.isPending}>
            {mutation.isPending ? 'Duke u dërguar...' : 'Posto Njoftimin'}
          </button>
        </form>
      )}

      <div className="announcements-list">
        {isLoading ? (
          <p>Duke ngarkuar njoftimet...</p>
        ) : announcements?.length === 0 ? (
          <p>Nuk ka njoftime për momentin.</p>
        ) : (
          announcements?.map(ann => (
            <div key={ann.id} className="announcement-card card">
              <div className="card-header">
                <span className={`badge ${ann.tipi}`}>
                  {ann.tipi === 'kerko_lojtar' ? 'Lojtar' : ann.tipi === 'kerko_kundershtare' ? 'Kundërshtar' : 'Ekip'}
                </span>
                <span className="date">{new Date(ann.created_at).toLocaleDateString('sq-AL')}</span>
              </div>
              <h2>{ann.titull}</h2>
              <p>{ann.pershkrim}</p>
              <div className="card-footer">
                <div className="info">
                  <span>⚽ {ann.lloji_sportit}</span>
                  <span>👥 {ann.lojtare_nevojitet} lojtarë</span>
                </div>
                <div className="author">nga {ann.perdoruesi.emri}</div>
              </div>
            </div>
          ))
        )}
      </div>

      <style>{`
        .community-page {
          padding: 40px 20px;
        }
        .header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 40px;
        }
        .announcement-form {
          margin-bottom: 40px;
        }
        .form-row {
          display: grid;
          grid-template-columns: 1fr 1fr 120px;
          gap: 16px;
        }
        .form-group {
          margin-bottom: 16px;
          display: flex;
          flex-direction: column;
          gap: 8px;
        }
        .form-group label {
          font-weight: 700;
          font-size: 14px;
        }
        .form-group input, .form-group select, .form-group textarea {
          padding: 10px 12px;
          border: 1px solid var(--border);
          border-radius: 8px;
          font-size: 15px;
        }
        .announcements-list {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
          gap: 24px;
        }
        .announcement-card h2 {
          font-size: 18px;
          margin: 12px 0;
        }
        .announcement-card p {
          color: var(--text-secondary);
          font-size: 14px;
          line-height: 1.5;
          margin-bottom: 20px;
        }
        .card-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        .badge {
          padding: 4px 10px;
          border-radius: 6px;
          font-size: 11px;
          font-weight: 800;
          text-transform: uppercase;
        }
        .badge.kerko_lojtar { background: #E3F2FD; color: #1976D2; }
        .badge.kerko_kundershtare { background: #FCE4EC; color: #D81B60; }
        .badge.kerko_ekip { background: #F3E5F5; color: #7B1FA2; }
        .date { font-size: 12px; color: var(--text-hint); }
        .card-footer {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding-top: 16px;
          border-top: 1px solid var(--divider);
        }
        .info {
          display: flex;
          gap: 16px;
          font-size: 13px;
          font-weight: 600;
        }
        .author {
          font-size: 13px;
          color: var(--text-secondary);
        }
      `}</style>
    </div>
  );
}
