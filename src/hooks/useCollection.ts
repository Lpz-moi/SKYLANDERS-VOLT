import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import type { Database } from '../lib/database.types';

type UserCollection = Database['public']['Tables']['user_collections']['Row'];

const LOCAL_STORAGE_KEY = 'skylanders_collection';

export const useCollection = () => {
  const { user } = useAuth();
  const [collection, setCollection] = useState<UserCollection[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (user) {
      fetchCollection();
    } else {
      loadLocalCollection();
    }
  }, [user]);

  const fetchCollection = async () => {
    if (!user) return;

    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('user_collections')
        .select('*')
        .eq('user_id', user.id);

      if (error) throw error;
      setCollection(data || []);

      syncLocalToCloud(data || []);
    } catch (err) {
      console.error('Error fetching collection:', err);
    } finally {
      setLoading(false);
    }
  };

  const loadLocalCollection = () => {
    try {
      const stored = localStorage.getItem(LOCAL_STORAGE_KEY);
      if (stored) {
        setCollection(JSON.parse(stored));
      }
    } catch (err) {
      console.error('Error loading local collection:', err);
    } finally {
      setLoading(false);
    }
  };

  const saveLocalCollection = (data: UserCollection[]) => {
    try {
      localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(data));
    } catch (err) {
      console.error('Error saving local collection:', err);
    }
  };

  const syncLocalToCloud = async (cloudData: UserCollection[]) => {
    const localStored = localStorage.getItem(LOCAL_STORAGE_KEY);
    if (!localStored || !user) return;

    try {
      const localData: UserCollection[] = JSON.parse(localStored);
      const cloudIds = new Set(cloudData.map(item => item.skylander_id));

      const toSync = localData.filter(item => !cloudIds.has(item.skylander_id));

      if (toSync.length > 0) {
        const insertData = toSync.map(item => ({
          user_id: user.id,
          skylander_id: item.skylander_id,
          owned: item.owned,
          notes: item.notes
        }));

        await supabase.from('user_collections').insert(insertData);
        fetchCollection();
      }

      localStorage.removeItem(LOCAL_STORAGE_KEY);
    } catch (err) {
      console.error('Error syncing local to cloud:', err);
    }
  };

  const addToCollection = async (skylanderId: string) => {
    if (user) {
      const { data, error } = await supabase
        .from('user_collections')
        .insert({
          user_id: user.id,
          skylander_id: skylanderId,
          owned: true
        })
        .select()
        .maybeSingle();

      if (!error && data) {
        setCollection(prev => [...prev, data]);
      }
    } else {
      const newItem: UserCollection = {
        id: crypto.randomUUID(),
        user_id: 'local',
        skylander_id: skylanderId,
        owned: true,
        notes: '',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      };
      const updated = [...collection, newItem];
      setCollection(updated);
      saveLocalCollection(updated);
    }
  };

  const removeFromCollection = async (skylanderId: string) => {
    if (user) {
      await supabase
        .from('user_collections')
        .delete()
        .eq('user_id', user.id)
        .eq('skylander_id', skylanderId);

      setCollection(prev => prev.filter(item => item.skylander_id !== skylanderId));
    } else {
      const updated = collection.filter(item => item.skylander_id !== skylanderId);
      setCollection(updated);
      saveLocalCollection(updated);
    }
  };

  const updateNotes = async (skylanderId: string, notes: string) => {
    if (user) {
      await supabase
        .from('user_collections')
        .update({ notes })
        .eq('user_id', user.id)
        .eq('skylander_id', skylanderId);

      setCollection(prev =>
        prev.map(item =>
          item.skylander_id === skylanderId ? { ...item, notes } : item
        )
      );
    } else {
      const updated = collection.map(item =>
        item.skylander_id === skylanderId ? { ...item, notes } : item
      );
      setCollection(updated);
      saveLocalCollection(updated);
    }
  };

  const isInCollection = (skylanderId: string) => {
    return collection.some(item => item.skylander_id === skylanderId && item.owned);
  };

  return {
    collection,
    loading,
    addToCollection,
    removeFromCollection,
    updateNotes,
    isInCollection,
    refetch: fetchCollection
  };
};
