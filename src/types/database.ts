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
          role: 'etudiant' | 'restaurant'
          display_name: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          role: 'etudiant' | 'restaurant'
          display_name?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          role?: 'etudiant' | 'restaurant'
          display_name?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      etudiants: {
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
      etudiant_addresses: {
        Row: {
          id: string
          etudiant_id: string
          address: string
          lat: number | null
          lng: number | null
          is_default: boolean
          label: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          etudiant_id: string
          address: string
          lat?: number | null
          lng?: number | null
          is_default?: boolean
          label?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          etudiant_id?: string
          address?: string
          lat?: number | null
          lng?: number | null
          is_default?: boolean
          label?: string | null
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
          etudiant_id: string
          deal_id: string
          created_at: string
        }
        Insert: {
          id?: string
          etudiant_id: string
          deal_id: string
          created_at?: string
        }
        Update: {
          id?: string
          etudiant_id?: string
          deal_id?: string
          created_at?: string
        }
      }
      restaurant_ratings: {
        Row: {
          id: string
          etudiant_id: string
          restaurant_id: string
          rating: number
          comment: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          etudiant_id: string
          restaurant_id: string
          rating: number
          comment?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          etudiant_id?: string
          restaurant_id?: string
          rating?: number
          comment?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      restaurant_visits: {
        Row: {
          id: string
          etudiant_id: string
          restaurant_id: string
          scanned_at: string
          qr_code_data: string
          created_at: string
        }
        Insert: {
          id?: string
          etudiant_id: string
          restaurant_id: string
          scanned_at?: string
          qr_code_data: string
          created_at?: string
        }
        Update: {
          id?: string
          etudiant_id?: string
          restaurant_id?: string
          scanned_at?: string
          qr_code_data?: string
          created_at?: string
        }
      }
      rating_notifications: {
        Row: {
          id: string
          etudiant_id: string
          restaurant_id: string
          visit_id: string
          notification_sent_at: string
          notification_type: string
          is_read: boolean
          created_at: string
        }
        Insert: {
          id?: string
          etudiant_id: string
          restaurant_id: string
          visit_id: string
          notification_sent_at?: string
          notification_type?: string
          is_read?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          etudiant_id?: string
          restaurant_id?: string
          visit_id?: string
          notification_sent_at?: string
          notification_type?: string
          is_read?: boolean
          created_at?: string
        }
      }
      restaurant_orders: {
        Row: {
          id: string
          etudiant_id: string
          restaurant_id: string
          visit_id: string
          order_date: string
          created_at: string
        }
        Insert: {
          id?: string
          etudiant_id: string
          restaurant_id: string
          visit_id: string
          order_date?: string
          created_at?: string
        }
        Update: {
          id?: string
          etudiant_id?: string
          restaurant_id?: string
          visit_id?: string
          order_date?: string
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

