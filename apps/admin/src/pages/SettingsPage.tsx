import React from 'react';
import { Typography, Paper, Box, Switch, FormControlLabel, Button, Divider, TextField } from '@mui/material';

export default function SettingsPage() {
  return (
    <div>
      <Typography variant="h4" sx={{ fontWeight: 800, mb: 4 }}>Settings</Typography>
      
      <Paper sx={{ p: 4, borderRadius: 3, maxWidth: 600 }}>
        <Typography variant="h6" sx={{ mb: 3 }}>Konfigurimi i Sistemit</Typography>
        
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
          <FormControlLabel 
            control={<Switch defaultChecked color="primary" />} 
            label="Mundëso rezervimet automatike" 
          />
          <FormControlLabel 
            control={<Switch defaultChecked color="primary" />} 
            label="Dërgo njoftime me email për rezervime të reja" 
          />
          
          <Divider sx={{ my: 1 }} />
          
          <TextField 
            label="Tarifa e mirëmbajtjes (%)" 
            type="number" 
            defaultValue="5"
            fullWidth
          />

          <TextField 
            label="Email-i i suportit" 
            defaultValue="suport@tefusha.al"
            fullWidth
          />

          <Box sx={{ mt: 2 }}>
            <Button variant="contained" sx={{ bgcolor: '#E8002D', px: 4 }}>Ruaj Ndryshimet</Button>
          </Box>
        </Box>
      </Paper>
    </div>
  );
}
