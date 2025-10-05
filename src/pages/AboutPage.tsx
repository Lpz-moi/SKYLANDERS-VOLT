import { Heart, Github, Mail, Sparkles } from 'lucide-react';

export const AboutPage = () => {
  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 to-blue-50 py-8">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="mb-8">
          <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-2">
            À propos
          </h1>
          <p className="text-lg text-gray-600">
            Découvrez Skylanders Vault
          </p>
        </div>

        <div className="space-y-6">
          <div className="bg-white rounded-2xl shadow-lg p-8">
            <div className="flex items-center gap-3 mb-4">
              <Sparkles className="w-8 h-8 text-purple-600" />
              <h2 className="text-2xl font-bold text-gray-900">Notre Mission</h2>
            </div>
            <p className="text-gray-700 leading-relaxed mb-4">
              Skylanders Vault est une application web moderne et intuitive conçue pour aider les collectionneurs de figurines Skylanders à gérer leur collection facilement et efficacement.
            </p>
            <p className="text-gray-700 leading-relaxed">
              Notre objectif est de fournir la meilleure expérience possible pour suivre, organiser et apprécier votre collection de Skylanders, avec une interface élégante et des fonctionnalités puissantes.
            </p>
          </div>

          <div className="bg-white rounded-2xl shadow-lg p-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">Fonctionnalités</h2>
            <div className="grid md:grid-cols-2 gap-6">
              {[
                {
                  title: 'Base de données complète',
                  description: 'Accédez à tous les Skylanders de la franchise avec des informations détaillées et des images de qualité.'
                },
                {
                  title: 'Gestion de collection',
                  description: 'Suivez facilement vos figurines possédées et identifiez celles qui manquent à votre collection.'
                },
                {
                  title: 'Synchronisation cloud',
                  description: 'Connectez-vous avec Discord ou un compte local pour sauvegarder votre collection en ligne.'
                },
                {
                  title: 'Interface responsive',
                  description: 'Profitez d\'une expérience optimale sur mobile, tablette et ordinateur de bureau.'
                },
                {
                  title: 'Filtres avancés',
                  description: 'Recherchez et filtrez par élément, rareté, jeu et nom pour trouver rapidement vos Skylanders.'
                },
                {
                  title: 'Notes personnelles',
                  description: 'Ajoutez des notes à chaque figurine pour garder une trace de vos souvenirs et observations.'
                }
              ].map((feature, index) => (
                <div key={index} className="space-y-2">
                  <h3 className="text-lg font-semibold text-purple-600">{feature.title}</h3>
                  <p className="text-gray-600 text-sm">{feature.description}</p>
                </div>
              ))}
            </div>
          </div>

          <div className="bg-white rounded-2xl shadow-lg p-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">Technologies utilisées</h2>
            <div className="flex flex-wrap gap-3">
              {[
                'React',
                'TypeScript',
                'Tailwind CSS',
                'Supabase',
                'Vite',
                'PostgreSQL'
              ].map((tech, index) => (
                <span
                  key={index}
                  className="px-4 py-2 bg-gradient-to-r from-purple-100 to-blue-100 text-purple-900 rounded-lg font-medium"
                >
                  {tech}
                </span>
              ))}
            </div>
          </div>

          <div className="bg-gradient-to-r from-purple-600 to-blue-600 rounded-2xl shadow-lg p-8 text-white">
            <div className="flex items-center gap-3 mb-4">
              <Heart className="w-8 h-8" />
              <h2 className="text-2xl font-bold">Fait avec passion</h2>
            </div>
            <p className="text-white/90 leading-relaxed mb-6">
              Cette application a été créée avec amour pour la communauté des collectionneurs de Skylanders. Nous espérons qu\'elle vous aidera à profiter encore plus de votre collection.
            </p>
            <div className="flex flex-wrap gap-4">
              <a
                href="https://github.com"
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-2 px-6 py-3 bg-white/10 hover:bg-white/20 rounded-lg transition-all duration-200 backdrop-blur-sm"
              >
                <Github className="w-5 h-5" />
                <span>GitHub</span>
              </a>
              <a
                href="mailto:contact@example.com"
                className="flex items-center gap-2 px-6 py-3 bg-white/10 hover:bg-white/20 rounded-lg transition-all duration-200 backdrop-blur-sm"
              >
                <Mail className="w-5 h-5" />
                <span>Contact</span>
              </a>
            </div>
          </div>

          <div className="bg-white rounded-2xl shadow-lg p-8 text-center">
            <p className="text-gray-600">
              <strong>Note:</strong> Skylanders est une marque déposée d'Activision. Cette application est un projet de fans non officiel créé à des fins éducatives et de collection personnelle.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};
