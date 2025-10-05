import { useState, useMemo } from 'react';
import { Search, Filter } from 'lucide-react';
import { SkylanderCard } from '../components/SkylanderCard';
import { useSkylanders } from '../hooks/useSkylanders';
import { useCollection } from '../hooks/useCollection';

export const GalleryPage = () => {
  const { skylanders, loading: loadingSkylanders } = useSkylanders();
  const { isInCollection, addToCollection, removeFromCollection } = useCollection();
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedElement, setSelectedElement] = useState<string>('all');
  const [selectedRarity, setSelectedRarity] = useState<string>('all');
  const [selectedGame, setSelectedGame] = useState<string>('all');

  const elements = ['all', ...Array.from(new Set(skylanders.map(s => s.element)))];
  const rarities = ['all', ...Array.from(new Set(skylanders.map(s => s.rarity)))];
  const games = ['all', ...Array.from(new Set(skylanders.map(s => s.game)))];

  const filteredSkylanders = useMemo(() => {
    return skylanders.filter(skylander => {
      const matchesSearch = skylander.name.toLowerCase().includes(searchTerm.toLowerCase());
      const matchesElement = selectedElement === 'all' || skylander.element === selectedElement;
      const matchesRarity = selectedRarity === 'all' || skylander.rarity === selectedRarity;
      const matchesGame = selectedGame === 'all' || skylander.game === selectedGame;

      return matchesSearch && matchesElement && matchesRarity && matchesGame;
    });
  }, [skylanders, searchTerm, selectedElement, selectedRarity, selectedGame]);

  const handleToggleOwned = (skylanderId: string) => {
    if (isInCollection(skylanderId)) {
      removeFromCollection(skylanderId);
    } else {
      addToCollection(skylanderId);
    }
  };

  if (loadingSkylanders) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-50 to-blue-50 flex items-center justify-center">
        <div className="text-center space-y-4">
          <div className="w-16 h-16 border-4 border-purple-600 border-t-transparent rounded-full animate-spin mx-auto" />
          <p className="text-xl text-gray-700 font-medium">Chargement des Skylanders...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 to-blue-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="mb-8">
          <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-2">
            Galerie Skylanders
          </h1>
          <p className="text-lg text-gray-600">
            {filteredSkylanders.length} Skylander{filteredSkylanders.length > 1 ? 's' : ''} disponible{filteredSkylanders.length > 1 ? 's' : ''}
          </p>
        </div>

        <div className="bg-white rounded-2xl shadow-lg p-6 mb-8 space-y-4">
          <div className="relative">
            <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
            <input
              type="text"
              placeholder="Rechercher un Skylander..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all text-lg"
            />
          </div>

          <div className="flex items-center gap-2 flex-wrap">
            <Filter className="text-gray-600 w-5 h-5" />
            <span className="font-medium text-gray-700">Filtres:</span>

            <select
              value={selectedElement}
              onChange={(e) => setSelectedElement(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all"
            >
              {elements.map(element => (
                <option key={element} value={element}>
                  {element === 'all' ? 'Tous les éléments' : element}
                </option>
              ))}
            </select>

            <select
              value={selectedRarity}
              onChange={(e) => setSelectedRarity(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all"
            >
              {rarities.map(rarity => (
                <option key={rarity} value={rarity}>
                  {rarity === 'all' ? 'Toutes les raretés' : rarity}
                </option>
              ))}
            </select>

            <select
              value={selectedGame}
              onChange={(e) => setSelectedGame(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all"
            >
              {games.map(game => (
                <option key={game} value={game}>
                  {game === 'all' ? 'Tous les jeux' : game}
                </option>
              ))}
            </select>

            {(searchTerm || selectedElement !== 'all' || selectedRarity !== 'all' || selectedGame !== 'all') && (
              <button
                onClick={() => {
                  setSearchTerm('');
                  setSelectedElement('all');
                  setSelectedRarity('all');
                  setSelectedGame('all');
                }}
                className="ml-auto px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg transition-colors font-medium"
              >
                Réinitialiser
              </button>
            )}
          </div>
        </div>

        {filteredSkylanders.length === 0 ? (
          <div className="text-center py-16">
            <p className="text-xl text-gray-600">Aucun Skylander trouvé</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {filteredSkylanders.map(skylander => (
              <SkylanderCard
                key={skylander.id}
                skylander={skylander}
                isOwned={isInCollection(skylander.id)}
                onToggleOwned={handleToggleOwned}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
