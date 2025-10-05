import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// Configuration Vite optimisée pour Vercel
export default defineConfig({
  plugins: [react()],
  base: './', // ✅ essentiel pour éviter la page blanche
  optimizeDeps: {
    exclude: ['lucide-react'],
  },
});
