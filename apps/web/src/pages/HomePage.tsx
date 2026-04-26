import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

export default function HomePage() {
  const navigate = useNavigate();
  const [search, setSearch] = useState('');

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    navigate(`/fields?q=${search}`);
  };

  return (
    <div className="home-page">
      <section className="hero">
        <div className="container hero-content">
          <h1>Rezervo fushën tënde sportive me një klikim</h1>
          <p>Gjej fushat më të mira pranë teje, organizo ndeshje dhe bëhu pjesë e komunitetit tonë.</p>
          
          <form className="search-box" onSubmit={handleSearch}>
            <input 
              type="text" 
              placeholder="Kërko për fusha, qytet ose sport..." 
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
            <button type="submit" className="btn btn-primary">Kërko</button>
          </form>
        </div>
      </section>

      <section className="features container">
        <div className="feature-card">
          <div className="icon">⚽</div>
          <h3>Rezervim i Shpejtë</h3>
          <p>Zgjidh orarin dhe rezervoni fushën në pak sekonda pa pasur nevojë për telefonata.</p>
        </div>
        <div className="feature-card">
          <div className="icon">🏆</div>
          <h3>Turnetë</h3>
          <p>Merrni pjesë në turnetë lokalë, shikoni tabelat e renditjes dhe fitoni trofe.</p>
        </div>
        <div className="feature-card">
          <div className="icon">👥</div>
          <h3>Gjej Lojtarë</h3>
          <p>Nuk keni mjaftueshëm lojtarë? Postoni një njoftim dhe plotësoni ekipin tuaj.</p>
        </div>
      </section>

      <style>{`
        .hero {
          background: linear-gradient(135deg, #1a1a1a 0%, #2e3192 100%);
          color: white;
          padding: 100px 0;
          text-align: center;
        }
        .hero-content h1 {
          font-size: 48px;
          margin-bottom: 24px;
          max-width: 800px;
          margin-left: auto;
          margin-right: auto;
        }
        .hero-content p {
          font-size: 18px;
          color: rgba(255,255,255,0.8);
          margin-bottom: 48px;
        }
        .search-box {
          background: white;
          padding: 8px;
          border-radius: 12px;
          display: flex;
          max-width: 600px;
          margin: 0 auto;
          box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        .search-box input {
          flex: 1;
          border: none;
          padding: 12px 20px;
          font-size: 16px;
          outline: none;
          color: var(--text-primary);
        }
        .features {
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          gap: 32px;
          padding: 80px 20px;
        }
        .feature-card {
          background: white;
          padding: 40px;
          border-radius: 20px;
          text-align: center;
          transition: transform 0.3s ease;
        }
        .feature-card:hover {
          transform: translateY(-10px);
        }
        .feature-card .icon {
          font-size: 48px;
          margin-bottom: 24px;
        }
        .feature-card h3 {
          margin-bottom: 16px;
          font-size: 20px;
        }
        .feature-card p {
          color: var(--text-secondary);
          line-height: 1.6;
        }
        @media (max-width: 768px) {
          .features {
            grid-template-columns: 1fr;
          }
          .hero-content h1 {
            font-size: 32px;
          }
        }
      `}</style>
    </div>
  );
}
