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
