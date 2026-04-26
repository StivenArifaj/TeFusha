import React from 'react';
import { Typography, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, IconButton, Switch, Box } from '@mui/material';
import { Delete as DeleteIcon, Visibility as ViewIcon } from '@mui/icons-material';
import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

export default function FieldsPage() {
  const token = localStorage.getItem('adminToken');

  const { data: fields, isLoading } = useQuery({
    queryKey: ['admin-fields'],
    queryFn: async () => {
      const res = await axios.get('http://localhost:4000/api/admin/fields', {
        headers: { Authorization: `Bearer ${token}` }
      });
      return res.data;
    }
  });

  return (
    <div>
      <Typography variant="h4" sx={{ fontWeight: 800, mb: 4 }}>Fushat Sportive</Typography>
      
      <TableContainer component={Paper} sx={{ borderRadius: 3, boxShadow: '0 4px 20px rgba(0,0,0,0.05)' }}>
        <Table>
          <TableHead sx={{ bgcolor: '#fafafa' }}>
            <TableRow>
              <TableCell sx={{ fontWeight: 700 }}>Emri</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Vendndodhja</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Lloji</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Çmimi/Orë</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Aktiv</TableCell>
              <TableCell sx={{ fontWeight: 700 }} align="right">Veprime</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {isLoading ? (
              <TableRow><TableCell colSpan={6} align="center">Duke ngarkuar...</TableCell></TableRow>
            ) : fields?.map((field: any) => (
              <TableRow key={field.id} hover>
                <TableCell sx={{ fontWeight: 600 }}>{field.emri_fushes}</TableCell>
                <TableCell>{field.qyteti}, {field.vendndodhja}</TableCell>
                <TableCell>{field.lloji_fushes}</TableCell>
                <TableCell>{field.cmimi_orari} L</TableCell>
                <TableCell>
                  <Switch checked={field.statusi === 'aktiv'} color="success" />
                </TableCell>
                <TableCell align="right">
                  <IconButton size="small"><ViewIcon /></IconButton>
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
