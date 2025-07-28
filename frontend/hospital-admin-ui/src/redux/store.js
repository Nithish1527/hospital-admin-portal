import { configureStore } from '@reduxjs/toolkit';
import authReducer from './reducers/authReducer';
import patientReducer from './reducers/patientReducer';
import appointmentReducer from './reducers/appointmentReducer';
import staffReducer from './reducers/staffReducer';

const store = configureStore({
  reducer: {
    auth: authReducer,
    patients: patientReducer,
    appointments: appointmentReducer,
    staff: staffReducer
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: ['persist/PERSIST']
      }
    })
});

export default store;