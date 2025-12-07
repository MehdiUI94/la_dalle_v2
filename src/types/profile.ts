export type Role = 'etudiant' | 'restaurant'

export interface Profile {
  id: string
  role: Role
  display_name: string | null
  created_at: string
  updated_at: string
}

export interface EtudiantProfile extends Profile {
  role: 'etudiant'
}

export interface RestaurantProfile extends Profile {
  role: 'restaurant'
}



