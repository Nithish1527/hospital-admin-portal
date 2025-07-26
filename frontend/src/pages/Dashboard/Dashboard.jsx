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
