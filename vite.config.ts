import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

<<<<<<< HEAD
// Configuration Vite optimisée pour Vercel
export default defineConfig({
  plugins: [react()],
  base: './', // ✅ essentiel pour éviter la page blanche
  optimizeDeps: {
    exclude: ['lucide-react'],
=======
export default defineConfig({
  plugins: [react()],
  base: '/',
  build: {
    outDir: 'dist',
>>>>>>> e4b75633e568576d2189024d4a112e5cc40b903c
  },
});
