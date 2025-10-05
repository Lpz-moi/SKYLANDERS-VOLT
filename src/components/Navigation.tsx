import { Home, Images, BookMarked, Info, LogIn, LogOut, User } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

interface NavigationProps {
  currentPage: string;
  onNavigate: (page: string) => void;
  onAuthClick: () => void;
}

export const Navigation = ({ currentPage, onNavigate, onAuthClick }: NavigationProps) => {
  const { user, signOut } = useAuth();

  const navItems = [
    { id: 'home', label: 'Accueil', icon: Home },
    { id: 'gallery', label: 'Galerie', icon: Images },
    { id: 'collection', label: 'Ma Collection', icon: BookMarked },
    { id: 'about', label: 'À propos', icon: Info }
  ];

  return (
    <nav className="bg-gradient-to-r from-purple-900 via-blue-900 to-indigo-900 shadow-xl">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center space-x-8">
            <div className="flex-shrink-0">
              <h1 className="text-2xl font-bold text-white flex items-center gap-2">
                <Images className="w-8 h-8" />
                Skylanders Vault
              </h1>
            </div>
            <div className="hidden md:flex space-x-1">
              {navItems.map(item => {
                const Icon = item.icon;
                return (
                  <button
                    key={item.id}
                    onClick={() => onNavigate(item.id)}
                    className={`px-4 py-2 rounded-lg text-sm font-medium transition-all duration-200 flex items-center gap-2 ${
                      currentPage === item.id
                        ? 'bg-white text-purple-900 shadow-lg transform scale-105'
                        : 'text-white hover:bg-white/10 hover:transform hover:scale-105'
                    }`}
                  >
                    <Icon className="w-4 h-4" />
                    {item.label}
                  </button>
                );
              })}
            </div>
          </div>

          <div className="flex items-center gap-3">
            {user ? (
              <>
                <div className="hidden md:flex items-center gap-2 text-white text-sm bg-white/10 px-3 py-2 rounded-lg">
                  <User className="w-4 h-4" />
                  <span>{user.email}</span>
                </div>
                <button
                  onClick={() => signOut()}
                  className="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg text-sm font-medium transition-all duration-200 flex items-center gap-2 transform hover:scale-105"
                >
                  <LogOut className="w-4 h-4" />
                  Déconnexion
                </button>
              </>
            ) : (
              <button
                onClick={onAuthClick}
                className="px-4 py-2 bg-green-500 hover:bg-green-600 text-white rounded-lg text-sm font-medium transition-all duration-200 flex items-center gap-2 transform hover:scale-105"
              >
                <LogIn className="w-4 h-4" />
                Connexion
              </button>
            )}
          </div>
        </div>

        <div className="md:hidden flex items-center justify-around pb-3">
          {navItems.map(item => {
            const Icon = item.icon;
            return (
              <button
                key={item.id}
                onClick={() => onNavigate(item.id)}
                className={`flex flex-col items-center gap-1 px-3 py-2 rounded-lg transition-all duration-200 ${
                  currentPage === item.id
                    ? 'bg-white text-purple-900'
                    : 'text-white hover:bg-white/10'
                }`}
              >
                <Icon className="w-5 h-5" />
                <span className="text-xs font-medium">{item.label}</span>
              </button>
            );
          })}
        </div>
      </div>
    </nav>
  );
};
