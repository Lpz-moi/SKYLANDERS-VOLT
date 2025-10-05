import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/database.types';

type Skylander = Database['public']['Tables']['skylanders']['Row'];

export const useSkylanders = () => {
  const [skylanders, setSkylanders] = useState<Skylander[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchSkylanders();
  }, []);

  const fetchSkylanders = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('skylanders')
        .select('*')
        .order('name');

      if (error) throw error;
      setSkylanders(data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch Skylanders');
    } finally {
      setLoading(false);
    }
  };

  return { skylanders, loading, error, refetch: fetchSkylanders };
};
