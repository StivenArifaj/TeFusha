import React from 'react';
import { Link } from 'react-router-dom';
import { Field } from '../types';

interface FieldCardProps {
  field: Field;
}

export default function FieldCard({ field }: FieldCardProps) {
  return (
    <div style={{
      border: '1px solid #ddd',
      borderRadius: '8px',
      overflow: 'hidden',
      boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
      display: 'flex',
      flexDirection: 'column'
    }}>
      <div style={{
        height: '180px',
        backgroundColor: '#f0f0f0',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        color: '#888'
      }}>
        {/* Placeholder for image */}
        [ Foto e fushës ]
      </div>
      <div style={{ padding: '16px' }}>
        <h3 style={{ margin: '0 0 8px 0', color: '#333' }}>{field.emri_fushes}</h3>
        <p style={{ margin: '0 0 4px 0', fontSize: '14px', color: '#666' }}>
          📍 {field.qyteti}, {field.vendndodhja}
        </p>
        <p style={{ margin: '0 0 12px 0', fontSize: '14px', color: '#666' }}>
          ⚽ {field.lloji_fushes.charAt(0).toUpperCase() + field.lloji_fushes.slice(1)}
        </p>
        <div style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          marginTop: 'auto'
        }}>
          <span style={{ fontWeight: 'bold', color: '#E8002D' }}>{field.cmimi_orari} L/ora</span>
          <Link to={`/fields/${field.id}`} style={{
            backgroundColor: '#E8002D',
            color: 'white',
            textDecoration: 'none',
            padding: '8px 16px',
            borderRadius: '4px',
            fontSize: '14px'
          }}>
            Detaje
          </Link>
        </div>
      </div>
    </div>
  );
}
