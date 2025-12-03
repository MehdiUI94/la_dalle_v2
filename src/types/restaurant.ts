import type { Deal } from './deal'

export interface Restaurant {
  id: number
  name: string
  description: string
  address: string
  arrondissement: string
  coordinates: {
    lat: number
    lng: number
  }
  phone?: string
  website?: string
  deals: Deal[]
  rating?: number
  imageUrl?: string
}

