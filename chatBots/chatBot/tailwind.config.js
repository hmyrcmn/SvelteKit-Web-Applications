/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        // Kul Elektronik renkleri
        primary: '#0066CC',
        secondary: '#00A3FF',
        accent: '#40B8FF',
        // Chatbot UI renkleri
        bot: {
          'blue': '#2196F3',
          'light': '#E3F2FD',
          'dark': '#1A237E'
        },
        dark: {
          bg: '#121212',
          surface: '#1E1E1E'
        }
      },
      fontFamily: {
        sans: ['Poppins', 'sans-serif'], // Kul Elektronik'in kullandığı font
      },
    },
  },
  plugins: [],
} 