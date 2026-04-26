import React, { useState, useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';
import { useFields } from '../hooks/useFields';
import FieldCard from '../components/FieldCard';

const CITIES = ['Tiranë', 'Durrës', 'Vlorë', 'Shkodër', 'Elbasan', 'Korçë'];
const TYPES  = ['futboll', 'basketboll', 'tenis', 'volejboll'];

export default function FieldsPage() {
  const [searchParams] = useSearchParams();
  const initialQuery = searchParams.get('q') || '';
  
  const [city, setCity] = useState('');
  const [type, setType] = useState('');
  const [search, setSearch] = useState(initialQuery);

  const { data: fields, isLoading, error } = useFields({
    qyteti: city || undefined,
    lloji: type || undefined,
  });

  // Filter local results based on search text if needed
  const filteredFields = fields?.filter(f => 
    f.emri_fushes.toLowerCase().includes(search.toLowerCase()) ||
    f.vendndodhja.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="container fields-page">
      <div className="fields-layout">
        <aside className="filters card">
          <h3>Filtro Fushat</h3>
          
          <div className="filter-group">
            <label>Kërko me emër</label>
            <input 
              type="text" 
              placeholder="Emri i fushës..." 
              value={search}
              onChange={e => setSearch(e.target.value)}
            />
          </div>

          <div className="filter-group">
            <label>Qyteti</label>
            <select value={city} onChange={e => setCity(e.target.value)}>
              <option value="">Të gjitha qytetet</option>
              {CITIES.map(c => <option key={c} value={c}>{c}</option>)}
            </select>
          </div>

          <div className="filter-group">
            <label>Lloji i Sportit</label>
            <select value={type} onChange={e => setType(e.target.value)}>
              <option value="">Të gjitha sportet</option>
              {TYPES.map(t => <option key={t} value={t}>{t.charAt(0).toUpperCase() + t.slice(1)}</option>)}
            </select>
          </div>

          <button className="btn btn-outline w-full" onClick={() => { setCity(''); setType(''); setSearch(''); }}>
            Pastro Filtrat
          </button>
        </aside>

        <main className="results">
          <div className="results-header">
            <h1>Fushat Sportive</h1>
            <p>{filteredFields?.length || 0} fusha të gjetura</p>
          </div>

          {isLoading ? (
            <div className="loading">Duke ngarkuar fushat...</div>
          ) : error ? (
            <div className="error">Gabim gjatë ngarkimit. Provoni përsëri.</div>
          ) : filteredFields?.length === 0 ? (
            <div className="empty card">Nuk u gjet asnjë fushë me këto kritere.</div>
          ) : (
            <div className="fields-grid">
              {filteredFields?.map(f => <FieldCard key={f.id} field={f} />)}
            </div>
          )}
        </main>
      </div>

      <style>{`
        .fields-page {
          padding: 40px 20px;
        }
        .fields-layout {
          display: grid;
          grid-template-columns: 280px 1fr;
          gap: 32px;
          align-items: start;
        }
        .filters h3 {
          margin-bottom: 24px;
          font-size: 18px;
        }
        .filter-group {
          margin-bottom: 20px;
        }
        .filter-group label {
          display: block;
          font-weight: 700;
          font-size: 13px;
          margin-bottom: 8px;
          color: var(--text-secondary);
        }
        .filter-group input, .filter-group select {
          width: 100%;
          padding: 10px 12px;
          border: 1px solid var(--border);
          border-radius: 8px;
          font-size: 14px;
        }
        .w-full { width: 100%; }
        .results-header {
          display: flex;
          justify-content: space-between;
          align-items: baseline;
          margin-bottom: 24px;
        }
        .results-header h1 { font-size: 28px; }
        .results-header p { color: var(--text-secondary); font-weight: 600; }
        .fields-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
          gap: 24px;
        }
        @media (max-width: 992px) {
          .fields-layout {
            grid-template-columns: 1fr;
          }
          .filters {
            position: sticky;
            top: 90px;
            z-index: 10;
          }
        }
      `}</style>
    </div>
  );
}
