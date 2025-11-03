import { writable } from 'svelte/store';

// Başlangıç temasını belirle
const getInitialTheme = () => {
  if (typeof window !== 'undefined') {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
      return savedTheme;
    }
    // Sistem temasını kontrol et
    if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    }
  }
  return 'light';
};

export const theme = writable<'light' | 'dark'>(getInitialTheme());
