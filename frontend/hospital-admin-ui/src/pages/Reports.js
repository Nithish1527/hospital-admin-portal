import React, { useState, useEffect } from 'react';
import { Row, Col, Card, Table, Form, Button } from 'react-bootstrap';
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, LineElement, PointElement, Title, Tooltip, Legend, ArcElement } from 'chart.js';
import { Bar, Line, Doughnut } from 'react-chartjs-2';
import api from '../services/api';

ChartJS.register(CategoryScale, LinearScale, BarElement, LineElement, PointElement, Title, Tooltip, Legend, ArcElement);

const Reports = () => {
  const [reportData, setReportData] = useState({
    patientStats: {},
    appointmentStats: {},
    staffStats: {},
    monthlyTrends: {}
  });
  const [loading, setLoading] = useState(true);
  const [dateRange, setDateRange] = useState({
    startDate: new Date(new Date().getFullYear(), new Date().getMonth(), 1).toISOString().split('T')[0],
    endDate: new Date().toISOString().split('T')[0]
  });

  useEffect(() => {
    fetchReportData();
  }, [dateRange]);

  const fetchReportData = async () => {
    try {
      setLoading(true);
      
      // Fetch all data
      const [patientsRes, appointmentsRes, staffRes] = await Promise.all([
        api.get('/patients'),
        api.get('/appointments'),
        api.get('/staff')
      ]);

      const patients = patientsRes.data;
      const appointments = appointmentsRes.data;
      const staff = staffRes.data;

      // Process patient statistics
      const patientStats = {
        total: patients.length,
        byGender: patients.reduce((acc, patient) => {
          acc[patient.gender] = (acc[patient.gender] || 0) + 1;
          return acc;
        }, {}),
        byBloodType: patients.reduce((acc, patient) => {
          if (patient.bloodType) {
            acc[patient.bloodType] = (acc[patient.bloodType] || 0) + 1;
          }
          return acc;
        }, {}),
        newThisMonth: patients.filter(p => {
          const createdDate = new Date(p.createdAt);
          const currentMonth = new Date().getMonth();
          const currentYear = new Date().getFullYear();
          return createdDate.getMonth() === currentMonth && createdDate.getFullYear() === currentYear;
        }).length
      };

      // Process appointment statistics
      const appointmentStats = {
        total: appointments.length,
        byStatus: appointments.reduce((acc, appointment) => {
          acc[appointment.status] = (acc[appointment.status] || 0) + 1;
          return acc;
        }, {}),
        thisMonth: appointments.filter(a => {
          const appointmentDate = new Date(a.appointmentDate);
          const currentMonth = new Date().getMonth();
          const currentYear = new Date().getFullYear();
          return appointmentDate.getMonth() === currentMonth && appointmentDate.getFullYear() === currentYear;
        }).length,
        completed: appointments.filter(a => a.status === 'COMPLETED').length
      };

      // Process staff statistics
      const staffStats = {
        total: staff.length,
        byDepartment: staff.reduce((acc, member) => {
          if (member.department) {
            acc[member.department] = (acc[member.department] || 0) + 1;
          }
          return acc;
        }, {}),
        available: staff.filter(s => s.isAvailable).length
      };

      // Generate monthly trends (last 6 months)
      const monthlyTrends = generateMonthlyTrends(appointments);

      setReportData({
        patientStats,
        appointmentStats,
        staffStats,
        monthlyTrends
      });

    } catch (error) {
      console.error('Error fetching report data:', error);
    } finally {
      setLoading(false);
    }
  };

  const generateMonthlyTrends = (appointments) => {
    const months = [];
    const appointmentCounts = [];
    
    for (let i = 5; i >= 0; i--) {
      const date = new Date();
      date.setMonth(date.getMonth() - i);
      const monthName = date.toLocaleDateString('en-US', { month: 'short' });
      months.push(monthName);
      
      const monthAppointments = appointments.filter(a => {
        const appointmentDate = new Date(a.appointmentDate);
        return appointmentDate.getMonth() === date.getMonth() && 
               appointmentDate.getFullYear() === date.getFullYear();
      }).length;
      
      appointmentCounts.push(monthAppointments);
    }
    
    return { months, appointmentCounts };
  };

  const handleDateRangeChange = (e) => {
    setDateRange({
      ...dateRange,
      [e.target.name]: e.target.value
    });
  };

  const exportReport = () => {
    // Simple CSV export
    const csvData = [
      ['Report Type', 'Value'],
      ['Total Patients', reportData.patientStats.total],
      ['Total Appointments', reportData.appointmentStats.total],
      ['Total Staff', reportData.staffStats.total],
      ['Completed Appointments', reportData.appointmentStats.completed],
      ['Available Staff', reportData.staffStats.available]
    ];

    const csvContent = csvData.map(row => row.join(',')).join('\n');
    const blob = new Blob([csvContent], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `hospital-report-${new Date().toISOString().split('T')[0]}.csv`;
    a.click();
    window.URL.revokeObjectURL(url);
  };

  // Chart configurations
  const patientGenderData = {
    labels: Object.keys(reportData.patientStats.byGender || {}),
    datasets: [{
      data: Object.values(reportData.patientStats.byGender || {}),
      backgroundColor: ['#667eea', '#764ba2', '#f093fb'],
      borderWidth: 0
    }]
  };

  const appointmentStatusData = {
    labels: Object.keys(reportData.appointmentStats.byStatus || {}),
    datasets: [{
      data: Object.values(reportData.appointmentStats.byStatus || {}),
      backgroundColor: ['#17a2b8', '#28a745', '#ffc107', '#6c757d', '#dc3545'],
      borderWidth: 0
    }]
  };

  const monthlyTrendsData = {
    labels: reportData.monthlyTrends.months || [],
    datasets: [{
      label: 'Appointments',
      data: reportData.monthlyTrends.appointmentCounts || [],
      borderColor: '#667eea',
      backgroundColor: 'rgba(102, 126, 234, 0.1)',
      tension: 0.4,
      fill: true
    }]
  };

  const departmentData = {
    labels: Object.keys(reportData.staffStats.byDepartment || {}),
    datasets: [{
      label: 'Staff Count',
      data: Object.values(reportData.staffStats.byDepartment || {}),
      backgroundColor: 'rgba(102, 126, 234, 0.8)',
      borderColor: '#667eea',
      borderWidth: 1
    }]
  };

  const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'top'
      }
    }
  };

  if (loading) {
    return (
      <div className="d-flex justify-content-center align-items-center" style={{ height: '400px' }}>
        <div className="spinner-border text-primary" role="status">
          <span className="visually-hidden">Loading...</span>
        </div>
      </div>
    );
  }

  return (
    <div className="fade-in">
      <Row className="mb-4">
        <Col>
          <h2>Reports & Analytics</h2>
        </Col>
        <Col xs="auto">
          <Button variant="success" onClick={exportReport}>
            Export Report
          </Button>
        </Col>
      </Row>

      {/* Date Range Filter */}
      <Card className="mb-4">
        <Card.Body>
          <Row>
            <Col md={3}>
              <Form.Group>
                <Form.Label>Start Date</Form.Label>
                <Form.Control
                  type="date"
                  name="startDate"
                  value={dateRange.startDate}
                  onChange={handleDateRangeChange}
                />
              </Form.Group>
            </Col>
            <Col md={3}>
              <Form.Group>
                <Form.Label>End Date</Form.Label>
                <Form.Control
                  type="date"
                  name="endDate"
                  value={dateRange.endDate}
                  onChange={handleDateRangeChange}
                />
              </Form.Group>
            </Col>
          </Row>
        </Card.Body>
      </Card>

      {/* Summary Cards */}
      <Row className="mb-4">
        <Col md={3}>
          <Card className="stats-card">
            <Card.Body>
              <h3>{reportData.patientStats.total}</h3>
              <p>Total Patients</p>
              <small>+{reportData.patientStats.newThisMonth} this month</small>
            </Card.Body>
          </Card>
        </Col>
        <Col md={3}>
          <Card className="stats-card">
            <Card.Body>
              <h3>{reportData.appointmentStats.total}</h3>
              <p>Total Appointments</p>
              <small>{reportData.appointmentStats.thisMonth} this month</small>
            </Card.Body>
          </Card>
        </Col>
        <Col md={3}>
          <Card className="stats-card">
            <Card.Body>
              <h3>{reportData.staffStats.total}</h3>
              <p>Total Staff</p>
              <small>{reportData.staffStats.available} available</small>
            </Card.Body>
          </Card>
        </Col>
        <Col md={3}>
          <Card className="stats-card">
            <Card.Body>
              <h3>{reportData.appointmentStats.completed}</h3>
              <p>Completed Appointments</p>
              <small>Success rate: {reportData.appointmentStats.total > 0 ? Math.round((reportData.appointmentStats.completed / reportData.appointmentStats.total) * 100) : 0}%</small>
            </Card.Body>
          </Card>
        </Col>
      </Row>

      {/* Charts */}
      <Row className="mb-4">
        <Col md={8}>
          <Card>
            <Card.Header>
              <h5>Monthly Appointment Trends</h5>
            </Card.Header>
            <Card.Body>
              <div className="chart-container">
                <Line data={monthlyTrendsData} options={chartOptions} />
              </div>
            </Card.Body>
          </Card>
        </Col>
        <Col md={4}>
          <Card>
            <Card.Header>
              <h5>Patient Gender Distribution</h5>
            </Card.Header>
            <Card.Body>
              <div className="chart-container">
                <Doughnut data={patientGenderData} options={chartOptions} />
              </div>
            </Card.Body>
          </Card>
        </Col>
      </Row>

      <Row className="mb-4">
        <Col md={6}>
          <Card>
            <Card.Header>
              <h5>Staff by Department</h5>
            </Card.Header>
            <Card.Body>
              <div className="chart-container">
                <Bar data={departmentData} options={chartOptions} />
              </div>
            </Card.Body>
          </Card>
        </Col>
        <Col md={6}>
          <Card>
            <Card.Header>
              <h5>Appointment Status Distribution</h5>
            </Card.Header>
            <Card.Body>
              <div className="chart-container">
                <Doughnut data={appointmentStatusData} options={chartOptions} />
              </div>
            </Card.Body>
          </Card>
        </Col>
      </Row>

      {/* Detailed Tables */}
      <Row>
        <Col md={6}>
          <Card>
            <Card.Header>
              <h5>Blood Type Distribution</h5>
            </Card.Header>
            <Card.Body>
              <Table responsive>
                <thead>
                  <tr>
                    <th>Blood Type</th>
                    <th>Count</th>
                    <th>Percentage</th>
                  </tr>
                </thead>
                <tbody>
                  {Object.entries(reportData.patientStats.byBloodType || {}).map(([bloodType, count]) => (
                    <tr key={bloodType}>
                      <td>{bloodType}</td>
                      <td>{count}</td>
                      <td>{Math.round((count / reportData.patientStats.total) * 100)}%</td>
                    </tr>
                  ))}
                </tbody>
              </Table>
            </Card.Body>
          </Card>
        </Col>
        <Col md={6}>
          <Card>
            <Card.Header>
              <h5>Department Statistics</h5>
            </Card.Header>
            <Card.Body>
              <Table responsive>
                <thead>
                  <tr>
                    <th>Department</th>
                    <th>Staff Count</th>
                    <th>Percentage</th>
                  </tr>
                </thead>
                <tbody>
                  {Object.entries(reportData.staffStats.byDepartment || {}).map(([department, count]) => (
                    <tr key={department}>
                      <td>{department}</td>
                      <td>{count}</td>
                      <td>{Math.round((count / reportData.staffStats.total) * 100)}%</td>
                    </tr>
                  ))}
                </tbody>
              </Table>
            </Card.Body>
          </Card>
        </Col>
      </Row>
    </div>
  );
};

export default Reports;