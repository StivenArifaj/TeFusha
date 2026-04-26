import React from 'react';

export default function EventsPage() {
  return (
    <div className="container events-page">
      <h1>Eventet dhe Turnetë</h1>
      <div className="card">
        <p>Së shpejti do të mund të shikoni dhe të regjistroheni në turnetë lokalë këtu në ueb.</p>
        <p>Për momentin, turnetë janë të disponueshëm vetëm në aplikacionin tonë mobile.</p>
      </div>
      <style>{`
        .events-page { padding: 40px 20px; }
        .events-page h1 { margin-bottom: 32px; }
        .card { padding: 40px; text-align: center; color: var(--text-secondary); }
      `}</style>
    </div>
  );
}
