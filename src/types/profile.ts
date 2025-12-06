export type Role = 'client' | 'restaurant'

export interface Profile {
  id: string
  role: Role
  display_name: string | null
  created_at: string
  updated_at: string
}

export interface ClientProfile extends Profile {
  role: 'client'
}

export interface RestaurantProfile extends Profile {
  role: 'restaurant'
}

