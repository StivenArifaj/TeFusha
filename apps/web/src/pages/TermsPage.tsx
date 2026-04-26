import React from 'react';

export default function TermsPage() {
  return (
    <div className="container policy-page">
      <h1>Kushtet e Përdorimit</h1>
      <div className="card content">
        <p>Mirësevini në TeFusha. Duke përdorur platformën tonë, ju pranoni kushtet e mëposhtme:</p>
        
        <h3>1. Regjistrimi</h3>
        <p>Përdoruesi duhet të sigurojë të dhëna të sakta gjatë regjistrimit.</p>

        <h3>2. Rezervimet</h3>
        <p>Rezervimet janë subjekt i disponueshmërisë së fushave. Pronari i fushës ka të drejtë të konfirmojë ose refuzojë rezervimin.</p>

        <h3>3. Anulimet</h3>
        <p>Anulimet duhet të bëhen të paktën 24 orë para orarit të rezervuar.</p>

        <h3>4. Sjellja</h3>
        <p>Përdoruesit duhet të respektojnë rregullat e fushave sportive ku kryejnë aktivitetin.</p>
      </div>
      <style>{`
        .policy-page { padding: 40px 20px; max-width: 900px; }
        .policy-page h1 { margin-bottom: 32px; }
        .content h3 { margin: 24px 0 12px 0; font-size: 18px; }
        .content p { line-height: 1.6; color: var(--text-secondary); }
      `}</style>
    </div>
  );
}
