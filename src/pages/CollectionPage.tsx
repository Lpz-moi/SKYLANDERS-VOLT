import { useMemo, useState } from 'react';
import { Trophy, TrendingUp, Package, CreditCard as Edit2, Save, X } from 'lucide-react';
import { SkylanderCard } from '../components/SkylanderCard';
import { useSkylanders } from '../hooks/useSkylanders';
import { useCollection } from '../hooks/useCollection';
import { useAuth } from '../contexts/AuthContext';

export const CollectionPage = () => {
  const { skylanders } = useSkylanders();
  const { collection, removeFromCollection, updateNotes, isInCollection } = useCollection();
  const { user } = useAuth();
  const [editingNotes, setEditingNotes] = useState<string | null>(null);
  const [noteText, setNoteText] = useState('');

  const ownedSkylanders = useMemo(() => {
    const ownedIds = collection.filter(c => c.owned).map(c => c.skylander_id);
    return skylanders.filter(s => ownedIds.includes(s.id));
  }, [skylanders, collection]);

  const stats = useMemo(() => {
    const total = skylanders.length;
    const owned = ownedSkylanders.length;
    const percentage = total > 0 ? Math.round((owned / total) * 100) : 0;

    const elementCounts = ownedSkylanders.reduce((acc, s) => {
      acc[s.element] = (acc[s.element] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    const rarityCounts = ownedSkylanders.reduce((acc, s) => {
      acc[s.rarity] = (acc[s.rarity] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    return { total, owned, percentage, elementCounts, rarityCounts };
  }, [skylanders, ownedSkylanders]);

  const handleToggleOwned = (skylanderId: string) => {
    removeFromCollection(skylanderId);
  };

  const handleEditNotes = (skylanderId: string) => {
    const collectionItem = collection.find(c => c.skylander_id === skylanderId);
    setEditingNotes(skylanderId);
    setNoteText(collectionItem?.notes || '');
  };

  const handleSaveNotes = async (skylanderId: string) => {
    await updateNotes(skylanderId, noteText);
    setEditingNotes(null);
    setNoteText('');
  };

  const handleCancelEdit = () => {
    setEditingNotes(null);
    setNoteText('');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 to-blue-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="mb-8">
          <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-2">
            Ma Collection
          </h1>
          <p className="text-lg text-gray-600">
            {user ? 'Collection synchronisée en ligne' : 'Collection locale (connectez-vous pour synchroniser)'}
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="bg-gradient-to-br from-purple-500 to-purple-700 rounded-2xl p-6 text-white shadow-xl">
            <div className="flex items-center justify-between mb-4">
              <Trophy className="w-12 h-12" />
              <div className="text-right">
                <p className="text-3xl font-bold">{stats.owned}</p>
                <p className="text-purple-200">sur {stats.total}</p>
              </div>
            </div>
            <p className="text-lg font-semibold">Skylanders possédés</p>
            <div className="mt-4 bg-white/20 rounded-full h-3 overflow-hidden">
              <div
                className="bg-white h-full transition-all duration-500 rounded-full"
                style={{ width: `${stats.percentage}%` }}
              />
            </div>
            <p className="text-sm text-purple-200 mt-2">{stats.percentage}% de complétion</p>
          </div>

          <div className="bg-gradient-to-br from-blue-500 to-blue-700 rounded-2xl p-6 text-white shadow-xl">
            <div className="flex items-center justify-between mb-4">
              <TrendingUp className="w-12 h-12" />
              <div className="text-right">
                <p className="text-3xl font-bold">{Object.keys(stats.elementCounts).length}</p>
                <p className="text-blue-200">éléments</p>
              </div>
            </div>
            <p className="text-lg font-semibold mb-3">Éléments collectés</p>
            <div className="space-y-1 text-sm">
              {Object.entries(stats.elementCounts).slice(0, 3).map(([element, count]) => (
                <div key={element} className="flex justify-between">
                  <span>{element}</span>
                  <span className="font-bold">{count}</span>
                </div>
              ))}
            </div>
          </div>

          <div className="bg-gradient-to-br from-green-500 to-green-700 rounded-2xl p-6 text-white shadow-xl">
            <div className="flex items-center justify-between mb-4">
              <Package className="w-12 h-12" />
              <div className="text-right">
                <p className="text-3xl font-bold">{Object.keys(stats.rarityCounts).length}</p>
                <p className="text-green-200">raretés</p>
              </div>
            </div>
            <p className="text-lg font-semibold mb-3">Raretés collectées</p>
            <div className="space-y-1 text-sm">
              {Object.entries(stats.rarityCounts).map(([rarity, count]) => (
                <div key={rarity} className="flex justify-between">
                  <span>{rarity}</span>
                  <span className="font-bold">{count}</span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {ownedSkylanders.length === 0 ? (
          <div className="bg-white rounded-2xl shadow-lg p-12 text-center">
            <Package className="w-20 h-20 text-gray-400 mx-auto mb-4" />
            <h2 className="text-2xl font-bold text-gray-900 mb-2">
              Votre collection est vide
            </h2>
            <p className="text-gray-600 mb-6">
              Commencez à ajouter des Skylanders depuis la galerie
            </p>
          </div>
        ) : (
          <div>
            <h2 className="text-2xl font-bold text-gray-900 mb-6">
              Mes Skylanders ({ownedSkylanders.length})
            </h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {ownedSkylanders.map(skylander => {
                const collectionItem = collection.find(c => c.skylander_id === skylander.id);
                const isEditing = editingNotes === skylander.id;

                return (
                  <div key={skylander.id} className="space-y-3">
                    <SkylanderCard
                      skylander={skylander}
                      isOwned={isInCollection(skylander.id)}
                      onToggleOwned={handleToggleOwned}
                    />

                    <div className="bg-white rounded-lg p-3 shadow">
                      {isEditing ? (
                        <div className="space-y-2">
                          <textarea
                            value={noteText}
                            onChange={(e) => setNoteText(e.target.value)}
                            placeholder="Ajoutez une note..."
                            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent resize-none"
                            rows={3}
                          />
                          <div className="flex gap-2">
                            <button
                              onClick={() => handleSaveNotes(skylander.id)}
                              className="flex-1 px-3 py-2 bg-green-500 hover:bg-green-600 text-white rounded-lg text-sm font-medium transition-colors flex items-center justify-center gap-1"
                            >
                              <Save className="w-4 h-4" />
                              Sauvegarder
                            </button>
                            <button
                              onClick={handleCancelEdit}
                              className="flex-1 px-3 py-2 bg-gray-300 hover:bg-gray-400 text-gray-700 rounded-lg text-sm font-medium transition-colors flex items-center justify-center gap-1"
                            >
                              <X className="w-4 h-4" />
                              Annuler
                            </button>
                          </div>
                        </div>
                      ) : (
                        <div>
                          <div className="flex items-start justify-between gap-2 mb-2">
                            <p className="text-sm text-gray-600 flex-1">
                              {collectionItem?.notes || 'Aucune note'}
                            </p>
                            <button
                              onClick={() => handleEditNotes(skylander.id)}
                              className="text-purple-600 hover:text-purple-700 transition-colors"
                            >
                              <Edit2 className="w-4 h-4" />
                            </button>
                          </div>
                        </div>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
