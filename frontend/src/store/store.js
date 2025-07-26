import { configureStore } from '@reduxjs/toolkit'
import authSlice from './slices/authSlice'
import patientSlice from './slices/patientSlice'
import appointmentSlice from './slices/appointmentSlice'
import departmentSlice from './slices/departmentSlice'

export const store = configureStore({
  reducer: {
    auth: authSlice,
    patients: patientSlice,
    appointments: appointmentSlice,
    departments: departmentSlice,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: ['persist/PERSIST'],
      },
    }),
})