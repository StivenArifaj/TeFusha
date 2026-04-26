import React from 'react';
import { Typography, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, IconButton, Chip } from '@mui/material';
import { Delete as DeleteIcon, Edit as EditIcon } from '@mui/icons-material';
import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

export default function UsersPage() {
  const token = localStorage.getItem('adminToken');

  const { data: users, isLoading } = useQuery({
    queryKey: ['admin-users'],
    queryFn: async () => {
      const res = await axios.get('http://localhost:4000/api/admin/users', {
        headers: { Authorization: `Bearer ${token}` }
      });
      return res.data;
    }
  });

  return (
    <div>
      <Typography variant="h4" sx={{ fontWeight: 800, mb: 4 }}>Përdoruesit</Typography>
      
      <TableContainer component={Paper} sx={{ borderRadius: 3, boxShadow: '0 4px 20px rgba(0,0,0,0.05)' }}>
        <Table>
          <TableHead sx={{ bgcolor: '#fafafa' }}>
            <TableRow>
              <TableCell sx={{ fontWeight: 700 }}>ID</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Emri</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Email</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Roli</TableCell>
              <TableCell sx={{ fontWeight: 700 }}>Data Regjistrimit</TableCell>
              <TableCell sx={{ fontWeight: 700 }} align="right">Veprime</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {isLoading ? (
              <TableRow><TableCell colSpan={6} align="center">Duke ngarkuar...</TableCell></TableRow>
            ) : users?.map((user: any) => (
              <TableRow key={user.id} hover>
                <TableCell>{user.id}</TableCell>
                <TableCell sx={{ fontWeight: 600 }}>{user.emri}</TableCell>
                <TableCell>{user.email}</TableCell>
                <TableCell>
                  <Chip 
                    label={user.roli} 
                    size="small" 
                    color={user.roli === 'admin' ? 'secondary' : user.roli === 'pronar_fushe' ? 'primary' : 'default'}
                    sx={{ fontWeight: 700, textTransform: 'uppercase', fontSize: '10px' }}
                  />
                </TableCell>
                <TableCell>{new Date(user.data_regjistrimit).toLocaleDateString()}</TableCell>
                <TableCell align="right">
                  <IconButton size="small" color="primary"><EditIcon /></IconButton>
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
