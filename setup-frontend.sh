#!/bin/bash

echo "Setting up Hospital Admin Portal Frontend..."

# Create Redux slices
cat > frontend/src/store/slices/patientSlice.js << 'EOF'
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit'
import patientService from '../../services/patientService'

export const fetchPatients = createAsyncThunk(
  'patients/fetchPatients',
  async (_, { rejectWithValue }) => {
    try {
      return await patientService.getAll()
    } catch (error) {
      return rejectWithValue(error.message)
    }
  }
)

const patientSlice = createSlice({
  name: 'patients',
  initialState: {
    patients: [],
    loading: false,
    error: null,
  },
  reducers: {
    clearError: (state) => {
      state.error = null
    }
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchPatients.pending, (state) => {
        state.loading = true
      })
      .addCase(fetchPatients.fulfilled, (state, action) => {
        state.loading = false
        state.patients = action.payload
      })
      .addCase(fetchPatients.rejected, (state, action) => {
        state.loading = false
        state.error = action.payload
      })
  },
})

export const { clearError } = patientSlice.actions
export default patientSlice.reducer
EOF

cat > frontend/src/store/slices/appointmentSlice.js << 'EOF'
import { createSlice } from '@reduxjs/toolkit'

const appointmentSlice = createSlice({
  name: 'appointments',
  initialState: {
    appointments: [],
    loading: false,
    error: null,
  },
  reducers: {
    setAppointments: (state, action) => {
      state.appointments = action.payload
    }
  },
})

export const { setAppointments } = appointmentSlice.actions
export default appointmentSlice.reducer
EOF

cat > frontend/src/store/slices/departmentSlice.js << 'EOF'
import { createSlice } from '@reduxjs/toolkit'

const departmentSlice = createSlice({
  name: 'departments',
  initialState: {
    departments: [],
    loading: false,
    error: null,
  },
  reducers: {
    setDepartments: (state, action) => {
      state.departments = action.payload
    }
  },
})

export const { setDepartments } = departmentSlice.actions
export default departmentSlice.reducer
EOF

# Create Services
cat > frontend/src/services/api.js << 'EOF'
import axios from 'axios'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor to handle errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export default api
EOF

cat > frontend/src/services/authService.js << 'EOF'
import api from './api'

const authService = {
  login: async (credentials) => {
    const response = await api.post('/api/auth/login', credentials)
    return response.data
  },

  logout: () => {
    localStorage.removeItem('token')
  },

  validateToken: async (token) => {
    const response = await api.post('/api/auth/validate', { token })
    return response.data
  }
}

export default authService
EOF

cat > frontend/src/services/patientService.js << 'EOF'
import api from './api'

const patientService = {
  getAll: async () => {
    const response = await api.get('/api/patients')
    return response.data
  },

  getById: async (id) => {
    const response = await api.get(`/api/patients/${id}`)
    return response.data
  },

  create: async (patient) => {
    const response = await api.post('/api/patients', patient)
    return response.data
  },

  update: async (id, patient) => {
    const response = await api.put(`/api/patients/${id}`, patient)
    return response.data
  },

  delete: async (id) => {
    const response = await api.delete(`/api/patients/${id}`)
    return response.data
  },

  search: async (name) => {
    const response = await api.get(`/api/patients/search?name=${name}`)
    return response.data
  }
}

export default patientService
EOF

# Create Components
mkdir -p frontend/src/components/{Layout,ProtectedRoute}
mkdir -p frontend/src/pages/{Login,Dashboard,Patients,Appointments,Departments,MedicalRecords}

cat > frontend/src/components/ProtectedRoute/ProtectedRoute.jsx << 'EOF'
import React from 'react'
import { Navigate } from 'react-router-dom'
import { useSelector } from 'react-redux'

const ProtectedRoute = ({ children }) => {
  const { isAuthenticated } = useSelector((state) => state.auth)

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />
  }

  return children
}

export default ProtectedRoute
EOF

cat > frontend/src/components/Layout/Layout.jsx << 'EOF'
import React, { useState } from 'react'
import { Outlet, useNavigate } from 'react-router-dom'
import { useDispatch } from 'react-redux'
import {
  Box,
  Drawer,
  AppBar,
  Toolbar,
  List,
  Typography,
  Divider,
  IconButton,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Menu,
  MenuItem,
} from '@mui/material'
import {
  Menu as MenuIcon,
  Dashboard as DashboardIcon,
  People as PeopleIcon,
  Event as EventIcon,
  Business as BusinessIcon,
  MedicalServices as MedicalIcon,
  AccountCircle,
  Logout,
} from '@mui/icons-material'
import { logoutUser } from '../../store/slices/authSlice'

const drawerWidth = 240

const menuItems = [
  { text: 'Dashboard', icon: <DashboardIcon />, path: '/dashboard' },
  { text: 'Patients', icon: <PeopleIcon />, path: '/patients' },
  { text: 'Appointments', icon: <EventIcon />, path: '/appointments' },
  { text: 'Departments', icon: <BusinessIcon />, path: '/departments' },
  { text: 'Medical Records', icon: <MedicalIcon />, path: '/medical-records' },
]

const Layout = () => {
  const [mobileOpen, setMobileOpen] = useState(false)
  const [anchorEl, setAnchorEl] = useState(null)
  const navigate = useNavigate()
  const dispatch = useDispatch()

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen)
  }

  const handleProfileMenuOpen = (event) => {
    setAnchorEl(event.currentTarget)
  }

  const handleMenuClose = () => {
    setAnchorEl(null)
  }

  const handleLogout = () => {
    dispatch(logoutUser())
    navigate('/login')
    handleMenuClose()
  }

  const drawer = (
    <div>
      <Toolbar>
        <Typography variant="h6" noWrap component="div">
          Hospital Portal
        </Typography>
      </Toolbar>
      <Divider />
      <List>
        {menuItems.map((item) => (
          <ListItem key={item.text} disablePadding>
            <ListItemButton onClick={() => navigate(item.path)}>
              <ListItemIcon>
                {item.icon}
              </ListItemIcon>
              <ListItemText primary={item.text} />
            </ListItemButton>
          </ListItem>
        ))}
      </List>
    </div>
  )

  return (
    <Box sx={{ display: 'flex' }}>
      <AppBar
        position="fixed"
        sx={{
          width: { sm: `calc(100% - ${drawerWidth}px)` },
          ml: { sm: `${drawerWidth}px` },
        }}
      >
        <Toolbar>
          <IconButton
            color="inherit"
            aria-label="open drawer"
            edge="start"
            onClick={handleDrawerToggle}
            sx={{ mr: 2, display: { sm: 'none' } }}
          >
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" noWrap component="div" sx={{ flexGrow: 1 }}>
            Hospital Admin Portal
          </Typography>
          <IconButton
            size="large"
            edge="end"
            aria-label="account of current user"
            onClick={handleProfileMenuOpen}
            color="inherit"
          >
            <AccountCircle />
          </IconButton>
          <Menu
            anchorEl={anchorEl}
            open={Boolean(anchorEl)}
            onClose={handleMenuClose}
          >
            <MenuItem onClick={handleLogout}>
              <Logout sx={{ mr: 1 }} />
              Logout
            </MenuItem>
          </Menu>
        </Toolbar>
      </AppBar>
      <Box
        component="nav"
        sx={{ width: { sm: drawerWidth }, flexShrink: { sm: 0 } }}
      >
        <Drawer
          variant="temporary"
          open={mobileOpen}
          onClose={handleDrawerToggle}
          ModalProps={{
            keepMounted: true,
          }}
          sx={{
            display: { xs: 'block', sm: 'none' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
        >
          {drawer}
        </Drawer>
        <Drawer
          variant="permanent"
          sx={{
            display: { xs: 'none', sm: 'block' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
          open
        >
          {drawer}
        </Drawer>
      </Box>
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          p: 3,
          width: { sm: `calc(100% - ${drawerWidth}px)` },
        }}
      >
        <Toolbar />
        <Outlet />
      </Box>
    </Box>
  )
}

export default Layout
EOF

# Create Login Page
cat > frontend/src/pages/Login/Login.jsx << 'EOF'
import React, { useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { useNavigate } from 'react-router-dom'
import {
  Container,
  Paper,
  TextField,
  Button,
  Typography,
  Box,
  Alert,
  CircularProgress,
} from '@mui/material'
import { LocalHospital } from '@mui/icons-material'
import { loginUser, clearError } from '../../store/slices/authSlice'

const Login = () => {
  const [formData, setFormData] = useState({
    username: '',
    password: '',
  })
  
  const dispatch = useDispatch()
  const navigate = useNavigate()
  const { loading, error } = useSelector((state) => state.auth)

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    dispatch(clearError())
    
    const result = await dispatch(loginUser(formData))
    if (result.type === 'auth/login/fulfilled') {
      navigate('/dashboard')
    }
  }

  return (
    <Container component="main" maxWidth="xs">
      <Box
        sx={{
          marginTop: 8,
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
        }}
      >
        <Paper elevation={3} sx={{ padding: 4, width: '100%' }}>
          <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
            <LocalHospital sx={{ fontSize: 40, color: 'primary.main', mb: 2 }} />
            <Typography component="h1" variant="h5">
              Hospital Admin Portal
            </Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mb: 3 }}>
              Sign in to your account
            </Typography>
            
            {error && (
              <Alert severity="error" sx={{ width: '100%', mb: 2 }}>
                {error}
              </Alert>
            )}
            
            <Box component="form" onSubmit={handleSubmit} sx={{ width: '100%' }}>
              <TextField
                margin="normal"
                required
                fullWidth
                id="username"
                label="Username"
                name="username"
                autoComplete="username"
                autoFocus
                value={formData.username}
                onChange={handleChange}
              />
              <TextField
                margin="normal"
                required
                fullWidth
                name="password"
                label="Password"
                type="password"
                id="password"
                autoComplete="current-password"
                value={formData.password}
                onChange={handleChange}
              />
              <Button
                type="submit"
                fullWidth
                variant="contained"
                sx={{ mt: 3, mb: 2 }}
                disabled={loading}
              >
                {loading ? <CircularProgress size={24} /> : 'Sign In'}
              </Button>
            </Box>
            
            <Box sx={{ mt: 2, p: 2, bgcolor: 'grey.100', borderRadius: 1, width: '100%' }}>
              <Typography variant="caption" display="block" gutterBottom>
                Demo Credentials:
              </Typography>
              <Typography variant="caption" display="block">
                Username: admin | Password: admin123
              </Typography>
            </Box>
          </Box>
        </Paper>
      </Box>
    </Container>
  )
}

export default Login
EOF

# Create Dashboard Page
cat > frontend/src/pages/Dashboard/Dashboard.jsx << 'EOF'
import React from 'react'
import {
  Box,
  Grid,
  Paper,
  Typography,
  Card,
  CardContent,
  CardActions,
  Button,
} from '@mui/material'
import {
  People as PeopleIcon,
  Event as EventIcon,
  Business as BusinessIcon,
  MedicalServices as MedicalIcon,
} from '@mui/icons-material'

const Dashboard = () => {
  const stats = [
    { title: 'Total Patients', value: '1,234', icon: <PeopleIcon />, color: '#1976d2' },
    { title: 'Today\'s Appointments', value: '45', icon: <EventIcon />, color: '#388e3c' },
    { title: 'Departments', value: '12', icon: <BusinessIcon />, color: '#f57c00' },
    { title: 'Medical Records', value: '5,678', icon: <MedicalIcon />, color: '#d32f2f' },
  ]

  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        Dashboard
      </Typography>
      
      <Grid container spacing={3}>
        {stats.map((stat, index) => (
          <Grid item xs={12} sm={6} md={3} key={index}>
            <Card>
              <CardContent>
                <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
                  <Box sx={{ color: stat.color, mr: 2 }}>
                    {stat.icon}
                  </Box>
                  <Box>
                    <Typography variant="h4">
                      {stat.value}
                    </Typography>
                    <Typography color="text.secondary">
                      {stat.title}
                    </Typography>
                  </Box>
                </Box>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>

      <Grid container spacing={3} sx={{ mt: 2 }}>
        <Grid item xs={12} md={6}>
          <Paper sx={{ p: 2 }}>
            <Typography variant="h6" gutterBottom>
              Recent Activities
            </Typography>
            <Typography variant="body2" color="text.secondary">
              Recent patient registrations and appointments will appear here.
            </Typography>
          </Paper>
        </Grid>
        
        <Grid item xs={12} md={6}>
          <Paper sx={{ p: 2 }}>
            <Typography variant="h6" gutterBottom>
              Quick Actions
            </Typography>
            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
              <Button variant="outlined" fullWidth>
                Add New Patient
              </Button>
              <Button variant="outlined" fullWidth>
                Schedule Appointment
              </Button>
              <Button variant="outlined" fullWidth>
                View Reports
              </Button>
            </Box>
          </Paper>
        </Grid>
      </Grid>
    </Box>
  )
}

export default Dashboard
EOF

# Create simple placeholder pages
for page in Patients Appointments Departments MedicalRecords; do
cat > frontend/src/pages/$page/$page.jsx << EOF
import React from 'react'
import { Typography, Box } from '@mui/material'

const $page = () => {
  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        $page
      </Typography>
      <Typography variant="body1">
        This is the $page management page. Features will be implemented here.
      </Typography>
    </Box>
  )
}

export default $page
EOF
done

# Create Dockerfile for Frontend
cat > frontend/Dockerfile << 'EOF'
FROM node:18-alpine as builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
EOF

# Create nginx configuration
cat > frontend/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    server {
        listen 3000;
        server_name localhost;
        root /usr/share/nginx/html;
        index index.html;

        location / {
            try_files $uri $uri/ /index.html;
        }

        location /api {
            proxy_pass http://api-gateway:8080;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
EOF

echo "Frontend setup completed!"