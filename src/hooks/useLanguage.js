import { useState, useCallback } from 'react';
import { translations } from '../data/translations';

export function useLanguage() {
  const [language, setLanguage] = useState(() => {
    return localStorage.getItem('oh-lang') || 'es';
  });

  const t = translations[language] || translations.es;

  const changeLanguage = useCallback((lang) => {
    setLanguage(lang);
    localStorage.setItem('oh-lang', lang);
  }, []);

  return { language, t, changeLanguage };
}