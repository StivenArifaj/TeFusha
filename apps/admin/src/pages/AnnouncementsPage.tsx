import React from 'react';
import { Typography, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, IconButton, Box } from '@mui/material';
import { Delete as DeleteIcon } from '@mui/icons-material';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import axios from 'axios';

export default function AnnouncementsPage() {
  const token = localStorage.getItem('adminToken');
  const queryClient = useQueryClient();

  const { data: announcements, isLoading } = useQuery({
    queryKey: ['admin-announcements'],
    queryFn: async () => {
      const res = await axios.get('http://localhost:4000/api/announcements');
      return res.data.value;
    }
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => {
      return axios.delete(`http://localhost:4000/api/announcements/${id}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-announcements'] });
    }
  });

  const handleDelete = (id: number) => {
    if (window.confirm('A jeni të sigurt që dëshironi të fshini këtë njoftim?')) {
      deleteMutation.mutate(id);
    }
  };

  return (
    <div>
      <Typography variant="h4" sx={{ fontWeight: 800, mb: 4 }}>Njoftimet e Komunitetit</Typography>
      
      <TableContainer component={Paper} sx={{ borderRadius: 3, boxShadow: '0 4px 20px rgba(0,0,0,0.05)' }}>
        <Table>
          <TableHead sx={{ bgcolor: '#fafafa' }}>
            <TableRow>
              <TableCell sx={{ fontWeight: 700 }}>Titulli</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Përdoruesi</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Tipi</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Data</TableCell>
              <TableCell sx={{ fontWeight: 700 }} align="right">Veprime</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {isLoading ? (
              <TableRow><TableCell colSpan={5} align="center">Duke ngarkuar...</TableCell></TableRow>
            ) : announcements?.map((ann: any) => (
              <TableRow key={ann.id} hover>
                <TableCell sx={{ fontWeight: 600 }}>{ann.titull}</TableCell>
                <TableCell>{ann.perdoruesi.emri}</TableCell>
                <TableCell>{ann.tipi}</TableCell>
                <TableCell>{new Date(ann.created_at).toLocaleDateString()}</TableCell>
                <TableCell align="right">
                  <IconButton size="small" color="error" onClick={() => handleDelete(ann.id)}>
                    <DeleteIcon />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </div>
  );
}
