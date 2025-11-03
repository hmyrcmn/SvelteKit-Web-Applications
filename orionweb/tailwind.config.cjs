// tailwind.config.js

/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {
      // Özel renk paletimizi buraya ekliyoruz
      colors: {
        'brand-dark': '#060a24',     // Ana arka plan rengi
        'brand-card': '#10163a',     // Kartların arka plan rengi
        'brand-border': '#202956',   // Kartların kenarlık rengi
        'brand-accent': '#60a5fa',   // İkonlar ve vurgular için mavi renk (Tailwind'in blue-400'ü)
        'brand-text': '#e2e8f0',      // Ana metin rengi (Tailwind'in slate-200'ü)
        'brand-text-light': '#94a3b8' // İkincil metin rengi (Tailwind'in slate-400'ü)
      },
     
    },
  },
  plugins: [],
}