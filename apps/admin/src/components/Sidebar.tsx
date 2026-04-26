import React from 'react';
import { Box, List, ListItem, ListItemButton, ListItemIcon, ListItemText, Typography, Divider } from '@mui/material';
import { 
  Dashboard as DashboardIcon, 
  People as PeopleIcon, 
  Stadium as FieldIcon, 
  Book as BookingIcon, 
  EmojiEvents as EventIcon, 
  Campaign as AnnouncementIcon,
  Settings as SettingsIcon,
  Logout as LogoutIcon
} from '@mui/icons-material';
import { useNavigate, useLocation } from 'react-router-dom';

const menuItems = [
  { text: 'Dashboard', icon: <DashboardIcon />, path: '/' },
  { text: 'Përdoruesit', icon: <PeopleIcon />, path: '/users' },
  { text: 'Fushat', icon: <FieldIcon />, path: '/fields' },
  { text: 'Rezervimet', icon: <BookingIcon />, path: '/bookings' },
  { text: 'Turnetë', icon: <EventIcon />, path: '/events' },
  { text: 'Njoftimet', icon: <AnnouncementIcon />, path: '/announcements' },
];

export default function Sidebar() {
  const navigate = useNavigate();
  const location = useLocation();

  return (
    <Box sx={{ width: 260, height: '100vh', bgcolor: 'white', borderRight: '1px solid #e0e0e0', display: 'flex', flexDirection: 'column' }}>
      <Box sx={{ p: 3 }}>
        <Typography variant="h5" sx={{ fontWeight: 800, color: '#E8002D' }}>TeFusha Admin</Typography>
        <Typography variant="caption" sx={{ color: 'text.secondary' }}>Paneli i Menaxhimit</Typography>
      </Box>
      
      <Divider />
      
      <List sx={{ flexGrow: 1, pt: 2 }}>
        {menuItems.map((item) => (
          <ListItem key={item.text} disablePadding>
            <ListItemButton 
              selected={location.pathname === item.path}
              onClick={() => navigate(item.path)}
              sx={{
                '&.Mui-selected': {
                  bgcolor: 'rgba(232, 0, 45, 0.08)',
                  borderRight: '4px solid #E8002D',
                  '& .MuiListItemIcon-root': { color: '#E8002D' },
                  '& .MuiListItemText-primary': { color: '#E8002D', fontWeight: 700 }
                }
              }}
            >
              <ListItemIcon>{item.icon}</ListItemIcon>
              <ListItemText primary={item.text} />
            </ListItemButton>
          </ListItem>
        ))}
      </List>

      <Divider />

      <List>
        <ListItem disablePadding>
          <ListItemButton onClick={() => navigate('/settings')}>
            <ListItemIcon><SettingsIcon /></ListItemIcon>
            <ListItemText primary="Settings" />
          </ListItemButton>
        </ListItem>
        <ListItem disablePadding>
          <ListItemButton onClick={() => { localStorage.clear(); window.location.href = '/login'; }}>
            <ListItemIcon><LogoutIcon /></ListItemIcon>
            <ListItemText primary="Dil" sx={{ '& .MuiListItemText-primary': { color: 'error.main' } }} />
          </ListItemButton>
        </ListItem>
      </List>
    </Box>
  );
}
