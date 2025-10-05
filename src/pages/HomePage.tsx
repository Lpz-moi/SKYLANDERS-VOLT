import { Sparkles, BookMarked, Shield, Database } from 'lucide-react';

interface HomePageProps {
  onNavigate: (page: string) => void;
}

export const HomePage = ({ onNavigate }: HomePageProps) => {
  const features = [
    {
      icon: Database,
      title: 'Base de données complète',
      description: 'Tous les Skylanders de la franchise avec images et détails'
    },
    {
      icon: BookMarked,
      title: 'Gestion de collection',
      description: 'Suivez vos figurines possédées et manquantes facilement'
    },
    {
      icon: Shield,
      title: 'Synchronisation cloud',
      description: 'Connectez-vous pour sauvegarder votre collection en ligne'
    },
    {
      icon: Sparkles,
      title: 'Interface moderne',
      description: 'Design immersif et responsive pour tous les appareils'
    }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-900 via-blue-900 to-indigo-900">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div className="text-center space-y-8 mb-16">
          <h1 className="text-5xl md:text-7xl font-bold text-white mb-4 animate-fade-in">
            Bienvenue sur <span className="text-transparent bg-clip-text bg-gradient-to-r from-yellow-400 to-orange-500">Skylanders Vault</span>
          </h1>
          <p className="text-xl md:text-2xl text-white/90 max-w-3xl mx-auto">
            La plateforme ultime pour gérer votre collection de figurines Skylanders
          </p>
          <div className="flex gap-4 justify-center flex-wrap">
            <button
              onClick={() => onNavigate('gallery')}
              className="px-8 py-4 bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 text-white font-bold rounded-xl shadow-2xl transform hover:scale-110 transition-all duration-200 text-lg"
            >
              Explorer la Galerie
            </button>
            <button
              onClick={() => onNavigate('collection')}
              className="px-8 py-4 bg-white/10 backdrop-blur-sm hover:bg-white/20 text-white font-bold rounded-xl shadow-2xl transform hover:scale-110 transition-all duration-200 text-lg border-2 border-white/30"
            >
              Ma Collection
            </button>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-16">
          {features.map((feature, index) => {
            const Icon = feature.icon;
            return (
              <div
                key={index}
                className="bg-white/10 backdrop-blur-sm p-6 rounded-2xl border-2 border-white/20 hover:bg-white/20 transition-all duration-300 transform hover:scale-105 hover:shadow-2xl"
              >
                <Icon className="w-12 h-12 text-yellow-400 mb-4" />
                <h3 className="text-xl font-bold text-white mb-2">{feature.title}</h3>
                <p className="text-white/80">{feature.description}</p>
              </div>
            );
          })}
        </div>

        <div className="bg-white/10 backdrop-blur-sm rounded-3xl p-8 md:p-12 border-2 border-white/20">
          <div className="grid md:grid-cols-2 gap-8 items-center">
            <div className="space-y-4">
              <h2 className="text-3xl md:text-4xl font-bold text-white">
                Commencez votre aventure
              </h2>
              <p className="text-white/90 text-lg">
                Parcourez notre galerie complète de Skylanders, ajoutez vos figurines préférées à votre collection et suivez votre progression. Connectez-vous pour synchroniser votre collection sur tous vos appareils.
              </p>
              <ul className="space-y-3">
                {['Navigation intuitive', 'Filtres par élément et rareté', 'Suivi en temps réel', 'Sauvegarde automatique'].map((item, i) => (
                  <li key={i} className="flex items-center gap-2 text-white">
                    <Sparkles className="w-5 h-5 text-yellow-400" />
                    <span>{item}</span>
                  </li>
                ))}
              </ul>
            </div>
            <div className="relative">
              <div className="absolute inset-0 bg-gradient-to-r from-yellow-400 to-orange-500 rounded-2xl blur-2xl opacity-30 animate-pulse" />
              <div className="relative bg-gradient-to-br from-purple-500 to-blue-600 rounded-2xl p-8 shadow-2xl">
                <div className="text-center text-white space-y-4">
                  <Sparkles className="w-20 h-20 mx-auto text-yellow-400" />
                  <h3 className="text-2xl font-bold">Prêt à démarrer ?</h3>
                  <p className="text-white/90">
                    Explorez dès maintenant notre collection complète
                  </p>
                  <button
                    onClick={() => onNavigate('gallery')}
                    className="w-full px-6 py-3 bg-white text-purple-900 font-bold rounded-lg hover:bg-yellow-400 hover:text-white transition-all duration-200 transform hover:scale-105"
                  >
                    Découvrir maintenant
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
