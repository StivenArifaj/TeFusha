import React from 'react';

export default function PrivacyPage() {
  return (
    <div className="container policy-page">
      <h1>Politika e Privatësisë</h1>
      <div className="card content">
        <p>Mbrojtja e të dhënave tuaja është prioriteti ynë.</p>
        
        <h3>1. Mbledhja e të dhënave</h3>
        <p>Ne mbledhim emrin tuaj, email-in dhe numrin e telefonit për të mundësuar rezervimet.</p>

        <h3>2. Përdorimi i të dhënave</h3>
        <p>Të dhënat tuaja përdoren vetëm për komunikim lidhur me rezervimet tuaja dhe për të përmirësuar shërbimin tonë.</p>

        <h3>3. Siguria</h3>
        <p>Ne përdorim enkriptim SSL për të siguruar që të dhënat tuaja janë të mbrojtura.</p>
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
