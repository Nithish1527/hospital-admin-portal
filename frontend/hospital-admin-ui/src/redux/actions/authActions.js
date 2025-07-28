import { createAsyncThunk } from '@reduxjs/toolkit';
import authService from '../../services/auth';
import { toast } from 'react-toastify';

// Login action
export const login = createAsyncThunk(
  'auth/login',
  async (credentials, { rejectWithValue }) => {
    try {
      const response = await authService.login(credentials);
      toast.success('Login successful!');
      return response;
    } catch (error) {
      const message = error.response?.data?.message || 'Login failed';
      toast.error(message);
      return rejectWithValue(message);
    }
  }
);

// Register action
export const register = createAsyncThunk(
  'auth/register',
  async (userData, { rejectWithValue }) => {
    try {
      const response = await authService.register(userData);
      toast.success('User registered successfully!');
      return response;
    } catch (error) {
      const message = error.response?.data?.message || 'Registration failed';
      toast.error(message);
      return rejectWithValue(message);
    }
  }
);

// Logout action
export const logout = createAsyncThunk(
  'auth/logout',
  async () => {
    authService.logout();
    toast.info('Logged out successfully');
    return null;
  }
);

// Check auth status
export const checkAuthStatus = createAsyncThunk(
  'auth/checkStatus',
  async (_, { rejectWithValue }) => {
    try {
      const isValid = await authService.validateToken();
      if (isValid) {
        const user = authService.getCurrentUser();
        return { user, token: localStorage.getItem('token') };
      } else {
        authService.logout();
        return rejectWithValue('Token invalid');
      }
    } catch (error) {
      authService.logout();
      return rejectWithValue('Auth check failed');
    }
  }
);

// Get all users
export const getUsers = createAsyncThunk(
  'auth/getUsers',
  async (_, { rejectWithValue }) => {
    try {
      const users = await authService.getUsers();
      return users;
    } catch (error) {
      const message = error.response?.data?.message || 'Failed to fetch users';
      return rejectWithValue(message);
    }
  }
);

// Update user
export const updateUser = createAsyncThunk(
  'auth/updateUser',
  async ({ id, userData }, { rejectWithValue }) => {
    try {
      const user = await authService.updateUser(id, userData);
      toast.success('User updated successfully!');
      return user;
    } catch (error) {
      const message = error.response?.data?.message || 'Failed to update user';
      toast.error(message);
      return rejectWithValue(message);
    }
  }
);

// Delete user
export const deleteUser = createAsyncThunk(
  'auth/deleteUser',
  async (id, { rejectWithValue }) => {
    try {
      await authService.deleteUser(id);
      toast.success('User deleted successfully!');
      return id;
    } catch (error) {
      const message = error.response?.data?.message || 'Failed to delete user';
      toast.error(message);
      return rejectWithValue(message);
    }
  }
);