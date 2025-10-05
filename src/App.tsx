import { useState } from 'react';
import { AuthProvider } from './contexts/AuthContext';
import { Navigation } from './components/Navigation';
import { AuthModal } from './components/AuthModal';
import { HomePage } from './pages/HomePage';
import { GalleryPage } from './pages/GalleryPage';
import { CollectionPage } from './pages/CollectionPage';
import { AboutPage } from './pages/AboutPage';

function App() {
  const [currentPage, setCurrentPage] = useState('home');
  const [showAuthModal, setShowAuthModal] = useState(false);

  const renderPage = () => {
    switch (currentPage) {
      case 'home':
        return <HomePage onNavigate={setCurrentPage} />;
      case 'gallery':
        return <GalleryPage />;
      case 'collection':
        return <CollectionPage />;
      case 'about':
        return <AboutPage />;
      default:
        return <HomePage onNavigate={setCurrentPage} />;
    }
  };

  return (
    <AuthProvider>
      <div className="min-h-screen bg-gray-50">
        <Navigation
          currentPage={currentPage}
          onNavigate={setCurrentPage}
          onAuthClick={() => setShowAuthModal(true)}
        />
        {renderPage()}
        <AuthModal isOpen={showAuthModal} onClose={() => setShowAuthModal(false)} />
      </div>
    </AuthProvider>
  );
}

export default App;
