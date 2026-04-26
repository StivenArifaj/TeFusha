import React from 'react';
import { Link } from 'react-router-dom';

export default function NotFoundPage() {
  return (
    <div className="container not-found">
      <div className="card content">
        <h1>404</h1>
        <h2>Faqja nuk u gjet</h2>
        <p>Na vjen keq, por faqja që po kërkoni nuk ekziston ose është zhvendosur.</p>
        <Link to="/" className="btn btn-primary">Kthehu në Fillim</Link>
      </div>
      <style>{`
        .not-found {
          padding: 80px 20px;
          text-align: center;
          display: flex;
          justify-content: center;
        }
        .content {
          max-width: 500px;
          padding: 60px;
        }
        .content h1 {
          font-size: 80px;
          color: var(--primary);
          margin-bottom: 8px;
        }
        .content h2 {
          margin-bottom: 16px;
        }
        .content p {
          color: var(--text-secondary);
          margin-bottom: 32px;
        }
      `}</style>
    </div>
  );
}
