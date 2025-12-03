export interface Badge {
  id: string
  name: string
  icon: string
  description: string
  unlockedAt?: Date
}

export interface User {
  id: string
  username: string
  email?: string
  role?: 'client' | 'restaurant'
  points: number
  level: number
  badges: Badge[]
  createdAt: Date
}

export interface Level {
  level: number
  name: string
  pointsRequired: number
  color: string
}

