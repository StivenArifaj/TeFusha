import React, { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { useField, useAvailability, useCreateBooking } from '../hooks/useFields';
import { useAuth } from '../context/AuthContext';

export default function FieldDetailPage() {
  const { id } = useParams<{ id: string }>();
  const fieldId = Number(id);
  const navigate = useNavigate();
  const { isLoggedIn } = useAuth();
  
  const [selectedDate, setSelectedDate] = useState(new Date().toISOString().split('T')[0]);
  const [selectedSlot, setSelectedSlot] = useState<string | null>(null);
  
  const { data: field, isLoading: isLoadingField } = useField(fieldId);
  const { data: availability, isLoading: isLoadingAvailability } = useAvailability(fieldId, selectedDate);
  const createBooking = useCreateBooking();

  const handleBooking = async () => {
    if (!isLoggedIn) {
      navigate('/login');
      return;
    }
    
    if (!selectedSlot) return;
    
    const startHour = parseInt(selectedSlot.split(':')[0]);
    const endHour = startHour + 1;
    const ora_mbarimit = `${endHour.toString().padStart(2, '0')}:00`;
    
    try {
      await createBooking.mutateAsync({
        fusha_id: fieldId,
        data_rezervimit: selectedDate,
        ora_fillimit: selectedSlot,
        ora_mbarimit: ora_mbarimit
      });
      alert('Rezervimi u krye me sukses!');
      navigate('/my-bookings');
    } catch (err: any) {
      alert(err.response?.data?.error || 'Gabim gjatë rezervimit');
    }
  };

  if (isLoadingField) return <div className="container p-40">Duke ngarkuar...</div>;
  if (!field) return <div className="container p-40">Fusha nuk u gjet.</div>;

  return (
    <div className="container field-detail-page">
      <div className="detail-layout">
        <div className="main-content">
          <div className="field-header">
            <span className="sport-tag">{field.lloji_fushes}</span>
            <h1>{field.emri_fushes}</h1>
            <p className="location">📍 {field.qyteti}, {field.vendndodhja}</p>
          </div>

          <div className="photo-placeholder card">
            {/* Image would go here */}
            <div className="empty-photo">
              ⚽ Foto e fushës
            </div>
          </div>

          <div className="info-section card">
            <h3>Detajet e Fushës</h3>
            <div className="details-grid">
              <div className="detail-item">
                <span className="label">Çmimi</span>
                <span className="value">{field.cmimi_orari} L / ora</span>
              </div>
              <div className="detail-item">
                <span className="label">Kapaciteti</span>
                <span className="value">{field.kapaciteti} persona</span>
              </div>
              <div className="detail-item">
                <span className="label">Lloji</span>
                <span className="value">{field.lloji_fushes}</span>
              </div>
            </div>
            
            {field.pajisjet && (
              <div className="pajisjet">
                <h4>Pajisjet & Shërbimet</h4>
                <div className="tags">
                  {field.pajisjet.split(',').map((p: string) => (
                    <span key={p} className="tag">{p.trim()}</span>
                  ))}
                </div>
              </div>
            )}
          </div>

          {field.lat && field.lng && (
            <div className="map-section card">
              <h3>Lokacioni</h3>
              <div className="map-container">
                <iframe
                  title="OpenStreetMap"
                  width="100%"
                  height="300"
                  frameBorder="0"
                  scrolling="no"
                  marginHeight={0}
                  marginWidth={0}
                  src={`https://www.openstreetmap.org/export/embed.html?bbox=${field.lng-0.005}%2C${field.lat-0.005}%2C${field.lng+0.005}%2C${field.lat+0.005}&layer=mapnik&marker=${field.lat}%2C${field.lng}`}
                ></iframe>
              </div>
              <a 
                href={`https://www.google.com/maps/dir/?api=1&destination=${field.lat},${field.lng}`} 
                target="_blank" 
                rel="noreferrer"
                className="btn btn-outline map-link"
              >
                Hap në Google Maps
              </a>
            </div>
          )}
        </div>

        <aside className="booking-sidebar">
          <div className="card booking-card">
            <h3>Rezervo fushën</h3>
            
            <div className="input-group">
              <label>Zgjidh Datën</label>
              <input 
                type="date" 
                value={selectedDate}
                min={new Date().toISOString().split('T')[0]}
                onChange={e => {
                  setSelectedDate(e.target.value);
                  setSelectedSlot(null);
                }}
              />
            </div>

            <div className="input-group">
              <label>Orari i disponueshëm</label>
              {isLoadingAvailability ? (
                <div className="loading-slots">Duke kërkuar oraret...</div>
              ) : (
                <div className="slots-grid">
                  {availability?.map(slot => (
                    <button
                      key={slot}
                      className={`slot-btn ${selectedSlot === slot ? 'selected' : ''}`}
                      onClick={() => setSelectedSlot(slot)}
                    >
                      {slot}
                    </button>
                  ))}
                  {availability?.length === 0 && <p className="no-slots">Nuk ka orare të lira.</p>}
                </div>
              )}
            </div>

            <button
              className="btn btn-primary w-full"
              onClick={handleBooking}
              disabled={!selectedSlot || createBooking.isPending}
            >
              {createBooking.isPending ? 'Duke rezervuar...' : 'Rezervo Tani'}
            </button>

            <p className="helper-text">Pas rezervimit, do të kontaktoheni nga pronari për konfirmim.</p>
          </div>
        </aside>
      </div>

      <style>{`
        .field-detail-page {
          padding: 40px 20px;
        }
        .detail-layout {
          display: grid;
          grid-template-columns: 1fr 350px;
          gap: 32px;
          align-items: start;
        }
        .field-header {
          margin-bottom: 32px;
        }
        .sport-tag {
          background: var(--primary-light);
          color: var(--primary);
          padding: 4px 12px;
          border-radius: 20px;
          font-weight: 800;
          font-size: 12px;
          text-transform: uppercase;
          display: inline-block;
          margin-bottom: 12px;
        }
        .field-header h1 {
          font-size: 36px;
          margin-bottom: 8px;
        }
        .location {
          font-size: 18px;
          color: var(--text-secondary);
        }
        .photo-placeholder {
          height: 400px;
          margin-bottom: 32px;
          display: flex;
          align-items: center;
          justify-content: center;
          background: #eee;
        }
        .empty-photo {
          font-size: 24px;
          color: var(--text-hint);
          font-weight: 700;
        }
        .info-section h3, .map-section h3 {
          margin-bottom: 24px;
        }
        .details-grid {
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          gap: 20px;
          margin-bottom: 32px;
        }
        .detail-item {
          display: flex;
          flex-direction: column;
          gap: 4px;
        }
        .detail-item .label {
          font-size: 12px;
          color: var(--text-hint);
          text-transform: uppercase;
          font-weight: 700;
        }
        .detail-item .value {
          font-size: 18px;
          font-weight: 700;
        }
        .pajisjet h4 {
          font-size: 15px;
          margin-bottom: 12px;
        }
        .tags {
          display: flex;
          flex-wrap: wrap;
          gap: 8px;
        }
        .tag {
          background: var(--background);
          padding: 6px 12px;
          border-radius: 8px;
          font-size: 13px;
          font-weight: 600;
        }
        .map-section {
          margin-top: 32px;
        }
        .map-container {
          border-radius: 12px;
          overflow: hidden;
          margin-bottom: 16px;
          border: 1px solid var(--border);
        }
        .map-link {
          display: inline-flex;
          align-items: center;
          gap: 8px;
          text-decoration: none;
        }
        .booking-card {
          position: sticky;
          top: 100px;
        }
        .booking-card h3 {
          margin-bottom: 24px;
        }
        .input-group {
          margin-bottom: 24px;
        }
        .input-group label {
          display: block;
          font-weight: 700;
          font-size: 14px;
          margin-bottom: 10px;
        }
        .input-group input {
          width: 100%;
          padding: 12px;
          border: 1px solid var(--border);
          border-radius: 8px;
        }
        .slots-grid {
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          gap: 8px;
        }
        .slot-btn {
          padding: 10px 4px;
          border: 1px solid var(--border);
          background: white;
          border-radius: 8px;
          font-weight: 700;
          font-size: 13px;
        }
        .slot-btn:hover {
          border-color: var(--primary);
          color: var(--primary);
        }
        .slot-btn.selected {
          background: var(--primary);
          border-color: var(--primary);
          color: white;
        }
        .w-full { width: 100%; }
        .helper-text {
          margin-top: 16px;
          font-size: 12px;
          color: var(--text-hint);
          text-align: center;
        }
        .p-40 { padding: 40px; }
        @media (max-width: 992px) {
          .detail-layout {
            grid-template-columns: 1fr;
          }
          .booking-sidebar {
            order: -1;
          }
        }
      `}</style>
    </div>
  );
}
