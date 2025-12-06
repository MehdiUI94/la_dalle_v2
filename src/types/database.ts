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
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          role: 'client' | 'restaurant'
          display_name?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          role?: 'client' | 'restaurant'
          display_name?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      clients: {
        Row: {
          id: string
          email: string
          password: string
          firstname: string | null
          lastname: string | null
          age: number | null
          address: string | null
          phone: string | null
          ine: string | null
          is_student: boolean | null
          notifications_email: boolean | null
          notifications_phone: boolean | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          email: string
          password: string
          firstname?: string | null
          lastname?: string | null
          age?: number | null
          address?: string | null
          phone?: string | null
          ine?: string | null
          is_student?: boolean | null
          notifications_email?: boolean | null
          notifications_phone?: boolean | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          email?: string
          password?: string
          firstname?: string | null
          lastname?: string | null
          age?: number | null
          address?: string | null
          phone?: string | null
          ine?: string | null
          is_student?: boolean | null
          notifications_email?: boolean | null
          notifications_phone?: boolean | null
          created_at?: string
          updated_at?: string
        }
      }
      restaurants: {
        Row: {
          id: string
          name: string
          email: string
          password: string
          owner_firstname: string | null
          owner_lastname: string | null
          address: string | null
          description: string | null
          logo: string | null
          siren: string | null
          siret: string | null
          social_media: string | null
          lat: number | null
          lng: number | null
          phone: string | null
          notifications_email: boolean | null
          notifications_phone: boolean | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          name: string
          email: string
          password: string
          owner_firstname?: string | null
          owner_lastname?: string | null
          address?: string | null
          description?: string | null
          logo?: string | null
          siren?: string | null
          siret?: string | null
          social_media?: string | null
          lat?: number | null
          lng?: number | null
          phone?: string | null
          notifications_email?: boolean | null
          notifications_phone?: boolean | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          email?: string
          password?: string
          owner_firstname?: string | null
          owner_lastname?: string | null
          address?: string | null
          description?: string | null
          logo?: string | null
          siren?: string | null
          siret?: string | null
          social_media?: string | null
          lat?: number | null
          lng?: number | null
          phone?: string | null
          notifications_email?: boolean | null
          notifications_phone?: boolean | null
          created_at?: string
          updated_at?: string
        }
      }
      deals: {
        Row: {
          id: string
          restaurant_id: string
          title: string
          description: string | null
          category: string | null
          is_active: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          restaurant_id: string
          title: string
          description?: string | null
          category?: string | null
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          restaurant_id?: string
          title?: string
          description?: string | null
          category?: string | null
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      favorites: {
        Row: {
          id: string
          client_id: string
          deal_id: string
          created_at: string
        }
        Insert: {
          id?: string
          client_id: string
          deal_id: string
          created_at?: string
        }
        Update: {
          id?: string
          client_id?: string
          deal_id?: string
          created_at?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
  }
}

