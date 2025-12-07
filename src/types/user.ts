export interface User {
  id: string
  username: string
  email: string
  role: 'etudiant' | 'restaurant'
  points: number
  level: number
  badges: Badge[]
  createdAt: Date
}

export interface Badge {
  id: string
  name: string
  description: string
  icon: string
  unlockedAt: Date
}

export interface Level {
  level: number
  pointsRequired: number
  name: string
}



