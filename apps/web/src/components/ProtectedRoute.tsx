import React from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

export default function ProtectedRoute({ children, requiredRole }: {
  children: React.ReactNode;
  requiredRole?: 'admin' | 'pronar_fushe';
}) {
  const { isLoggedIn, user } = useAuth();
  
  if (!isLoggedIn) {
    return <Navigate to="/login" replace />;
  }
  
  if (requiredRole && user?.roli !== requiredRole && user?.roli !== 'admin') {
    return <Navigate to="/" replace />;
  }
  
  return <>{children}</>;
}
