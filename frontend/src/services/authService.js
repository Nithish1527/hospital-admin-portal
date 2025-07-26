import api from './api'

const authService = {
  login: async (credentials) => {
    const response = await api.post('/api/auth/login', credentials)
    return response.data
  },

  logout: () => {
    localStorage.removeItem('token')
  },

  validateToken: async (token) => {
    const response = await api.post('/api/auth/validate', { token })
    return response.data
  }
}

export default authService
