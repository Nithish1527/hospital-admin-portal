import api from './api'

const patientService = {
  getAll: async () => {
    const response = await api.get('/api/patients')
    return response.data
  },

  getById: async (id) => {
    const response = await api.get(`/api/patients/${id}`)
    return response.data
  },

  create: async (patient) => {
    const response = await api.post('/api/patients', patient)
    return response.data
  },

  update: async (id, patient) => {
    const response = await api.put(`/api/patients/${id}`, patient)
    return response.data
  },

  delete: async (id) => {
    const response = await api.delete(`/api/patients/${id}`)
    return response.data
  },

  search: async (name) => {
    const response = await api.get(`/api/patients/search?name=${name}`)
    return response.data
  }
}

export default patientService
