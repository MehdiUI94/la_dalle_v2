export type Role = 'client' | 'restaurant'

export interface Profile {
  id: string
  role: Role
  display_name: string | null
  avatar_url: string | null
  created_at: string
  updated_at: string
}

export interface ClientProfile {
  id: string
  age: number | null
  is_student: boolean
  school_name: string | null
  main_arrondissement: string | null
  budget_range: '€' | '€€' | '€€€' | null
  favorite_categories: string[] | null
  created_at: string
  updated_at: string
}

export interface RestaurantProfile {
  id: string
  name: string
  description: string | null
  address: string | null
  arrondissement: string | null
  lat: number | null
  lng: number | null
  phone: string | null
  website: string | null
  instagram: string | null
  price_level: '€' | '€€' | '€€€' | null
  cuisine_types: string[] | null
  is_student_friendly: boolean
  max_deals_per_day: number
  image_url: string | null
  created_at: string
  updated_at: string
}

