import React from 'react';
import { Nav } from 'react-bootstrap';
import { useLocation, useNavigate } from 'react-router-dom';

const Sidebar = () => {
  const location = useLocation();
  const navigate = useNavigate();

  const menuItems = [
    { path: '/dashboard', icon: '📊', label: 'Dashboard' },
    { path: '/patients', icon: '👥', label: 'Patients' },
    { path: '/appointments', icon: '📅', label: 'Appointments' },
    { path: '/staff', icon: '👨‍⚕️', label: 'Staff' },
    { path: '/reports', icon: '📈', label: 'Reports' }
  ];

  return (
    <div className="sidebar p-3">
      <div className="text-center mb-4">
        <h5 className="text-white">Navigation</h5>
      </div>
      
      <Nav className="flex-column">
        {menuItems.map((item) => (
          <Nav.Link
            key={item.path}
            className={`d-flex align-items-center ${location.pathname === item.path ? 'active' : ''}`}
            onClick={() => navigate(item.path)}
            style={{ cursor: 'pointer' }}
          >
            <span className="me-3" style={{ fontSize: '1.2rem' }}>{item.icon}</span>
            {item.label}
          </Nav.Link>
        ))}
      </Nav>
      
      <div className="mt-auto pt-4">
        <div className="text-center">
          <small className="text-white-50">
            Hospital Admin Portal v1.0
          </small>
        </div>
      </div>
    </div>
  );
};

export default Sidebar;