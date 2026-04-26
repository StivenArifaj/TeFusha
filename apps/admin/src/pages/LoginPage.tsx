import React, { useState } from 'react';
import { Box, Paper, TextField, Button, Typography, Alert } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const res = await axios.post('http://localhost:4000/api/auth/login', { email, fjalekalimi: password });
      
      if (res.data.user.roli !== 'admin') {
        setError('Vetëm administratorët mund të hyjnë në këtë panel.');
        return;
      }

      localStorage.setItem('adminToken', res.data.access);
      localStorage.setItem('adminUser', JSON.stringify(res.data.user));
      navigate('/');
    } catch (err: any) {
      setError(err.response?.data?.error || 'Email ose fjalëkalim i pasaktë');
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box sx={{ height: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', bgcolor: '#f0f2f5' }}>
      <Paper elevation={4} sx={{ p: 6, width: '100%', maxWidth: 450, borderRadius: 4 }}>
        <Typography variant="h4" sx={{ fontWeight: 800, color: '#E8002D', mb: 1, textAlign: 'center' }}>TeFusha</Typography>
        <Typography variant="h6" sx={{ mb: 4, textAlign: 'center', color: 'text.secondary' }}>Admin Login</Typography>

        {error && <Alert severity="error" sx={{ mb: 3 }}>{error}</Alert>}

        <form onSubmit={handleLogin}>
          <TextField
            fullWidth
            label="Email Address"
            variant="outlined"
            margin="normal"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <TextField
            fullWidth
            label="Password"
            type="password"
            variant="outlined"
            margin="normal"
            required
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <Button
            fullWidth
            type="submit"
            variant="contained"
            size="large"
            disabled={loading}
            sx={{ 
              mt: 4, 
              py: 1.5, 
              bgcolor: '#E8002D', 
              '&:hover': { bgcolor: '#d00028' },
              fontWeight: 700,
              borderRadius: 2
            }}
          >
            {loading ? 'Duke hyrë...' : 'HYR'}
          </Button>
        </form>
      </Paper>
    </Box>
  );
}
