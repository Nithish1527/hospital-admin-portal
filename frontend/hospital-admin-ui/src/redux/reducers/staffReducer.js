import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  staff: [],
  currentStaff: null,
  loading: false,
  error: null,
  totalPages: 0,
  currentPage: 1
};

const staffSlice = createSlice({
  name: 'staff',
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
    setStaff: (state, action) => {
      state.staff = action.payload;
    },
    addStaff: (state, action) => {
      state.staff.push(action.payload);
    },
    updateStaff: (state, action) => {
      const index = state.staff.findIndex(s => s.id === action.payload.id);
      if (index !== -1) {
        state.staff[index] = action.payload;
      }
    },
    deleteStaff: (state, action) => {
      state.staff = state.staff.filter(s => s.id !== action.payload);
    },
    setCurrentStaff: (state, action) => {
      state.currentStaff = action.payload;
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
  setStaff,
  addStaff,
  updateStaff,
  deleteStaff,
  setCurrentStaff,
  setCurrentPage
} = staffSlice.actions;

export default staffSlice.reducer;