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
      skylanders: {
        Row: {
          id: string
          name: string
          element: string
          game: string
          rarity: string
          image_url: string
          type: string
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          element: string
          game: string
          rarity?: string
          image_url: string
          type?: string
          created_at?: string
        }
        Update: {
          id?: string
          name?: string
          element?: string
          game?: string
          rarity?: string
          image_url?: string
          type?: string
          created_at?: string
        }
      }
      user_collections: {
        Row: {
          id: string
          user_id: string
          skylander_id: string
          owned: boolean
          notes: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          skylander_id: string
          owned?: boolean
          notes?: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          skylander_id?: string
          owned?: boolean
          notes?: string
          created_at?: string
          updated_at?: string
        }
      }
    }
  }
}
