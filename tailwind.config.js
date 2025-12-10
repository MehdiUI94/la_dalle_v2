/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        background: 'var(--background)',
        foreground: 'var(--foreground)',
        primary: {
          DEFAULT: 'var(--primary)',
          light: '#FF8C33',
          dark: '#CC5500',
        },
        lime: 'var(--lime)',
        yellow: 'var(--yellow)',
        black: 'var(--black)',
        white: 'var(--white)',
        gray: {
          100: 'var(--gray-100)',
          500: 'var(--gray-500)',
        },
        // Anciennes couleurs conservées pour compatibilité
        accent: {
          DEFAULT: '#764ba2',
          50: '#faf5ff',
          100: '#f3e8ff',
          200: '#e9d5ff',
          300: '#d8b4fe',
          400: '#c084fc',
          500: '#764ba2',
          600: '#9333ea',
          700: '#7e22ce',
          800: '#6b21a8',
          900: '#581c87',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        display: ['Poppins', 'sans-serif'],
      },
      fontSize: {
        'hero-mobile': ['3rem', { lineHeight: '1.1', fontWeight: '900' }], // 48px
        'hero-desktop': ['4.5rem', { lineHeight: '1.1', fontWeight: '900' }], // 72px
        'section-mobile': ['2rem', { lineHeight: '1.1', fontWeight: '900' }], // 32px
        'section-desktop': ['2rem', { lineHeight: '1.1', fontWeight: '900' }], // 32px
        'body-mobile': ['1rem', { lineHeight: '1.4', fontWeight: '400' }], // 16px
        'body-desktop': ['1.125rem', { lineHeight: '1.4', fontWeight: '400' }], // 18px
      },
      fontWeight: {
        black: '900',
        bold: '700',
        medium: '500',
        normal: '400',
      },
    },
  },
  plugins: [],
}



