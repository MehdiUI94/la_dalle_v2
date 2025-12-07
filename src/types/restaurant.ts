export interface Restaurant {
  id: string
  name: string
  email: string
  lat: number | null
  lng: number | null
  address: string | null
  phone: string | null
  created_at: string
  updated_at: string
}

export interface RestaurantProfile extends Restaurant {
  role: 'restaurant'
  display_name: string | null
}



