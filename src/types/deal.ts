export type DealCategory = 'pizza' | 'burger' | 'sushi' | 'bar' | 'cafe' | 'all'

export interface Deal {
  id: number
  restaurant: string
  description: string
  deal: string
  arrondissement: string
  hours: string
  category: DealCategory
  badge?: string
  groupSize?: number
  coordinates?: {
    lat: number
    lng: number
  }
}

