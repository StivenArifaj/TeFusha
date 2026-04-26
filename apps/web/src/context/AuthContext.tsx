import React, { createContext, useContext, useState, useEffect } from 'react';
import { User } from '../types';

interface AuthContextType {
  user: User | null;
  token: string | null;
  isLoggedIn: boolean;
  login: (data: { access: string; refresh: string; user: User }) => void;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType>({} as AuthContextType);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(localStorage.getItem('tf_access'));

  useEffect(() => {
    // Restore user from localStorage on mount
    const stored = localStorage.getItem('tf_user');
    if (stored) {
      try {
        setUser(JSON.parse(stored));
      } catch (e) {
        localStorage.removeItem('tf_user');
      }
    }
  }, []);

  const login = (data: { access: string; refresh: string; user: User }) => {
    localStorage.setItem('tf_access',  data.access);
    localStorage.setItem('tf_refresh', data.refresh);
    localStorage.setItem('tf_user',    JSON.stringify(data.user));
    setToken(data.access);
    setUser(data.user);
  };

  const logout = () => {
    localStorage.removeItem('tf_access');
    localStorage.removeItem('tf_refresh');
    localStorage.removeItem('tf_user');
    setToken(null);
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, token, isLoggedIn: !!user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
