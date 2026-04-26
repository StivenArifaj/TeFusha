import React from 'react';
import { Typography, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Chip } from '@mui/material';
import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

export default function BookingsPage() {
  const token = localStorage.getItem('adminToken');

  const { data: bookings, isLoading } = useQuery({
    queryKey: ['admin-bookings'],
    queryFn: async () => {
      const res = await axios.get('http://localhost:4000/api/admin/bookings', {
        headers: { Authorization: `Bearer ${token}` }
      });
      return res.data;
    }
  });

  return (
    <div>
      <Typography variant="h4" sx={{ fontWeight: 800, mb: 4 }}>Rezervimet</Typography>
      
      <TableContainer component={Paper} sx={{ borderRadius: 3, boxShadow: '0 4px 20px rgba(0,0,0,0.05)' }}>
        <Table>
          <TableHead sx={{ bgcolor: '#fafafa' }}>
            <TableRow>
              <TableCell sx={{ fontWeight: 700 }}>Përdoruesi</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Fusha</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Data</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Ora</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Shuma</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Statusi</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {isLoading ? (
              <TableRow><TableCell colSpan={6} align="center">Duke ngarkuar...</TableCell></TableRow>
            ) : bookings?.map((booking: any) => (
              <TableRow key={booking.id} hover>
                <TableCell sx={{ fontWeight: 600 }}>{booking.perdoruesi.emri}</TableCell>
                <TableCell>{booking.fusha.emri_fushes}</TableCell>
                <TableCell>{new Date(booking.data_rezervimit).toLocaleDateString()}</TableCell>
                <TableCell>{booking.ora_fillimit} - {booking.ora_mbarimit}</TableCell>
                <TableCell>{booking.cmimi_total} L</TableCell>
                <TableCell>
                  <Chip 
                    label={booking.statusi} 
                    size="small" 
                    color={booking.statusi === 'konfirmuar' ? 'success' : 'warning'}
                    sx={{ fontWeight: 700, textTransform: 'uppercase', fontSize: '10px' }}
                  />
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </div>
  );
}
