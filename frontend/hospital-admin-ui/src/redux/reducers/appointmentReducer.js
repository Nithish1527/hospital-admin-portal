import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  appointments: [],
  currentAppointment: null,
  loading: false,
  error: null,
  totalPages: 0,
  currentPage: 1
};

const appointmentSlice = createSlice({
  name: 'appointments',
  initialState,
  reducers: {
    setLoading: (state, action) => {
      state.loading = action.payload;
    },
    setError: (state, action) => {
      state.error = action.payload;
    },
    clearError: (state) => {
      state.error = null;
    },
    setAppointments: (state, action) => {
      state.appointments = action.payload;
    },
    addAppointment: (state, action) => {
      state.appointments.push(action.payload);
    },
    updateAppointment: (state, action) => {
      const index = state.appointments.findIndex(a => a.id === action.payload.id);
      if (index !== -1) {
        state.appointments[index] = action.payload;
      }
    },
    deleteAppointment: (state, action) => {
      state.appointments = state.appointments.filter(a => a.id !== action.payload);
    },
    setCurrentAppointment: (state, action) => {
      state.currentAppointment = action.payload;
    },
    setCurrentPage: (state, action) => {
      state.currentPage = action.payload;
    }
  }
});

export const {
  setLoading,
  setError,
  clearError,
  setAppointments,
  addAppointment,
  updateAppointment,
  deleteAppointment,
  setCurrentAppointment,
  setCurrentPage
} = appointmentSlice.actions;

export default appointmentSlice.reducer;