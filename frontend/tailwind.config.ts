import forms from '@tailwindcss/forms';
import type { Config } from 'tailwindcss';
import defaultTheme from 'tailwindcss/defaultTheme';

export default {
  content: [
    './src/**/*.{html,js,svelte,ts}',
    './node_modules/layerchart/**/*.{svelte,js}'
  ],
  darkMode: ['selector', '[data-theme="dark"]'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['var(--font-sans)', ...defaultTheme.fontFamily.sans],
        mono: ['var(--font-mono)', ...defaultTheme.fontFamily.mono],
      },
      colors: {
        base: 'var(--base)',
        'base-alt': 'var(--base-alt)',
        surface: 'var(--surface)',
        text: 'var(--text)',
        'text-alt': 'var(--text-alt)',
        grey: 'var(--grey)',
        'dark-grey': 'var(--dark-grey)',
        red: 'var(--red)',
        orange: 'var(--orange)',
        green: 'var(--green)',
        teal: 'var(--teal)',
        yellow: 'var(--yellow)',
        blue: 'var(--blue)',
        magenta: 'var(--magenta)',
        violet: 'var(--violet)',
        cyan: 'var(--cyan)',
      },
      fontSize: {
        md: '0.9rem',
      },
    },
    container: {
      center: true,
    },
  },

  plugins: [forms]
} satisfies Config;
