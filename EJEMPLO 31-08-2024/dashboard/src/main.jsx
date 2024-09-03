import React from 'react';
import ReactDOM from 'react-dom/client';


import './styles.css';
import { AppRouter } from './router/AppRouter';
import { AuthProvider } from './auth';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <AuthProvider>
      <AppRouter />
    </AuthProvider>
  </React.StrictMode>,
)
