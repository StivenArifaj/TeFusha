import React from 'react';
import { Typography, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, IconButton, Button, Box } from '@mui/material';
import { Delete as DeleteIcon, EmojiEvents as TrophyIcon } from '@mui/icons-material';
import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

export default function EventsPage() {
  const token = localStorage.getItem('adminToken');

  const { data: events, isLoading } = useQuery({
    queryKey: ['admin-events'],
    queryFn: async () => {
      const res = await axios.get('http://localhost:4000/api/admin/events', {
        headers: { Authorization: `Bearer ${token}` }
      });
      return res.data;
    }
  });

  return (
    <div>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 4 }}>
        <Typography variant="h4" sx={{ fontWeight: 800 }}>Turnetë</Typography>
        <Button variant="contained" sx={{ bgcolor: '#E8002D' }}>Krijo Event +</Button>
      </Box>
      
      <TableContainer component={Paper} sx={{ borderRadius: 3, boxShadow: '0 4px 20px rgba(0,0,0,0.05)' }}>
        <Table>
          <TableHead sx={{ bgcolor: '#fafafa' }}>
            <TableRow>
              <TableCell sx={{ fontWeight: 700 }}>Emri i Eventit</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Fusha</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Data</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Ekipe</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Statusi</TableCell>
              <TableCell sx={{ fontWeight: 700 }} align="right">Veprime</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {isLoading ? (
              <TableRow><TableCell colSpan={6} align="center">Duke ngarkuar...</TableCell></TableRow>
            ) : events?.map((event: any) => (
              <TableRow key={event.id} hover>
                <TableCell sx={{ fontWeight: 600 }}>{event.emri_eventit}</TableCell>
                <TableCell>{event.fusha.emri_fushes}</TableCell>
                <TableCell>{new Date(event.data_fillimit).toLocaleDateString()}</TableCell>
                <TableCell>{event._count?.ekipet}/{event.nr_max_ekipesh}</TableCell>
                <TableCell>{event.statusi}</TableCell>
                <TableCell align="right">
                  <IconButton size="small" color="secondary"><TrophyIcon /></IconButton>
                  <IconButton size="small" color="error"><DeleteIcon /></IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </div>
  );
}
