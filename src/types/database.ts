// Types générés depuis le schéma Supabase
export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          role: 'client' | 'restaurant'
          display_name: string | null
          avatar_url: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          role: 'client' | 'restaurant'
          display_name?: string | null
          avatar_url?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          role?: 'client' | 'restaurant'
          display_name?: string | null
          avatar_url?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      clients: {
        Row: {
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
        Insert: {
          id: string
          age?: number | null
          is_student?: boolean
          school_name?: string | null
          main_arrondissement?: string | null
          budget_range?: '€' | '€€' | '€€€' | null
          favorite_categories?: string[] | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          age?: number | null
          is_student?: boolean
          school_name?: string | null
          main_arrondissement?: string | null
          budget_range?: '€' | '€€' | '€€€' | null
          favorite_categories?: string[] | null
          created_at?: string
          updated_at?: string
        }
      }
      restaurants: {
        Row: {
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
        Insert: {
          id: string
          name: string
          description?: string | null
          address?: string | null
          arrondissement?: string | null
          lat?: number | null
          lng?: number | null
          phone?: string | null
          website?: string | null
          instagram?: string | null
          price_level?: '€' | '€€' | '€€€' | null
          cuisine_types?: string[] | null
          is_student_friendly?: boolean
          max_deals_per_day?: number
          image_url?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          description?: string | null
          address?: string | null
          arrondissement?: string | null
          lat?: number | null
          lng?: number | null
          phone?: string | null
          website?: string | null
          instagram?: string | null
          price_level?: '€' | '€€' | '€€€' | null
          cuisine_types?: string[] | null
          is_student_friendly?: boolean
          max_deals_per_day?: number
          image_url?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      deals: {
        Row: {
          id: number
          restaurant_id: string | null
          title: string
          description: string | null
          deal_type: string
          category: string | null
          min_group_size: number
          max_group_size: number | null
          valid_from: string | null
          valid_to: string | null
          days_of_week: string[] | null
          start_time: string | null
          end_time: string | null
          is_active: boolean
          badge: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: number
          restaurant_id?: string | null
          title: string
          description?: string | null
          deal_type?: string
          category?: string | null
          min_group_size?: number
          max_group_size?: number | null
          valid_from?: string | null
          valid_to?: string | null
          days_of_week?: string[] | null
          start_time?: string | null
          end_time?: string | null
          is_active?: boolean
          badge?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: number
          restaurant_id?: string | null
          title?: string
          description?: string | null
          deal_type?: string
          category?: string | null
          min_group_size?: number
          max_group_size?: number | null
          valid_from?: string | null
          valid_to?: string | null
          days_of_week?: string[] | null
          start_time?: string | null
          end_time?: string | null
          is_active?: boolean
          badge?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      favorites: {
        Row: {
          id: number
          client_id: string | null
          deal_id: number | null
          created_at: string
        }
        Insert: {
          id?: number
          client_id?: string | null
          deal_id?: number | null
          created_at?: string
        }
        Update: {
          id?: number
          client_id?: string | null
          deal_id?: number | null
          created_at?: string
        }
      }
    }
  }
}

