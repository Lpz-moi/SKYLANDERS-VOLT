import { Star, CheckCircle, Circle } from 'lucide-react';
import type { Database } from '../lib/database.types';

type Skylander = Database['public']['Tables']['skylanders']['Row'];

interface SkylanderCardProps {
  skylander: Skylander;
  isOwned: boolean;
  onToggleOwned: (id: string) => void;
  showCheckbox?: boolean;
}

const elementColors: Record<string, string> = {
  Fire: 'from-red-500 to-orange-600',
  Water: 'from-blue-500 to-cyan-600',
  Earth: 'from-green-600 to-lime-600',
  Air: 'from-sky-400 to-blue-400',
  Life: 'from-green-400 to-emerald-500',
  Magic: 'from-purple-500 to-pink-600',
  Tech: 'from-yellow-500 to-amber-600',
  Undead: 'from-purple-700 to-indigo-900',
  Dark: 'from-gray-800 to-black'
};

const rarityStars: Record<string, number> = {
  Common: 1,
  Rare: 2,
  'Ultra Rare': 3,
  Legendary: 4
};

export const SkylanderCard = ({
  skylander,
  isOwned,
  onToggleOwned,
  showCheckbox = true
}: SkylanderCardProps) => {
  const gradientClass = elementColors[skylander.element] || 'from-gray-500 to-gray-700';
  const stars = rarityStars[skylander.rarity] || 1;

  return (
    <div
      className={`group relative bg-white rounded-xl shadow-lg overflow-hidden transform transition-all duration-300 hover:scale-105 hover:shadow-2xl cursor-pointer ${
        isOwned ? 'ring-2 ring-green-500' : ''
      }`}
      onClick={() => showCheckbox && onToggleOwned(skylander.id)}
    >
      <div className={`absolute inset-0 bg-gradient-to-br ${gradientClass} opacity-0 group-hover:opacity-20 transition-opacity duration-300`} />

      <div className="relative">
        <div className={`h-48 bg-gradient-to-br ${gradientClass} flex items-center justify-center overflow-hidden`}>
          <img
            src={skylander.image_url}
            alt={skylander.name}
            className="w-full h-full object-cover transform group-hover:scale-110 transition-transform duration-500"
          />
        </div>

        {showCheckbox && (
          <div className="absolute top-3 right-3 z-10">
            {isOwned ? (
              <CheckCircle className="w-8 h-8 text-green-500 drop-shadow-lg bg-white rounded-full" />
            ) : (
              <Circle className="w-8 h-8 text-gray-300 drop-shadow-lg bg-white rounded-full" />
            )}
          </div>
        )}

        <div className="absolute top-3 left-3 flex gap-1">
          {[...Array(stars)].map((_, i) => (
            <Star key={i} className="w-4 h-4 text-yellow-400 fill-yellow-400 drop-shadow-lg" />
          ))}
        </div>
      </div>

      <div className="p-4 space-y-2">
        <h3 className="text-lg font-bold text-gray-900 group-hover:text-purple-600 transition-colors duration-200">
          {skylander.name}
        </h3>

        <div className="flex items-center justify-between text-sm">
          <span className={`px-3 py-1 rounded-full bg-gradient-to-r ${gradientClass} text-white font-medium`}>
            {skylander.element}
          </span>
          <span className="text-gray-600 font-medium">{skylander.type}</span>
        </div>

        <div className="flex items-center justify-between text-xs text-gray-500">
          <span>{skylander.game}</span>
          <span className="font-semibold">{skylander.rarity}</span>
        </div>
      </div>
    </div>
  );
};
