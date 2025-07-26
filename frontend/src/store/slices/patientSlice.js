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
