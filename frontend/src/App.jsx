import React from 'react'
import { Routes, Route, Navigate } from 'react-router-dom'
import { Box } from '@mui/material'
import { useSelector } from 'react-redux'

import Layout from './components/Layout/Layout'
import Login from './pages/Login/Login'
import Dashboard from './pages/Dashboard/Dashboard'
import Patients from './pages/Patients/Patients'
import Appointments from './pages/Appointments/Appointments'
import Departments from './pages/Departments/Departments'
import MedicalRecords from './pages/MedicalRecords/MedicalRecords'
import ProtectedRoute from './components/ProtectedRoute/ProtectedRoute'

function App() {
  const { isAuthenticated } = useSelector((state) => state.auth)

  return (
    <Box sx={{ display: 'flex' }}>
      <Routes>
        <Route 
          path="/login" 
          element={
            !isAuthenticated ? <Login /> : <Navigate to="/dashboard" replace />
          } 
        />
        <Route 
          path="/" 
          element={
            <ProtectedRoute>
              <Layout />
            </ProtectedRoute>
          }
        >
          <Route index element={<Navigate to="/dashboard" replace />} />
          <Route path="dashboard" element={<Dashboard />} />
          <Route path="patients" element={<Patients />} />
          <Route path="appointments" element={<Appointments />} />
          <Route path="departments" element={<Departments />} />
          <Route path="medical-records" element={<MedicalRecords />} />
        </Route>
      </Routes>
    </Box>
  )
}

export default App