import { createSlice } from '@reduxjs/toolkit'

const departmentSlice = createSlice({
  name: 'departments',
  initialState: {
    departments: [],
    loading: false,
    error: null,
  },
  reducers: {
    setDepartments: (state, action) => {
      state.departments = action.payload
    }
  },
})

export const { setDepartments } = departmentSlice.actions
export default departmentSlice.reducer
