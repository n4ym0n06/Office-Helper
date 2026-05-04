import { motion } from 'framer-motion';
import { Github, Globe, Heart } from 'lucide-react';

export default function Footer({ t }) {
  return (
    <motion.footer
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 1, duration: 0.5 }}
      className="text-center pb-10 pt-6 px-4"
    >

      <div className="flex items-center justify-center gap-4 mb-3">
        <a href="https://github.com/massgravel/Microsoft-Activation-Scripts" target="_blank" rel="noopener noreferrer" className="text-gray-700 hover:text-gray-400 transition-colors" aria-label="GitHub">
          <Github size={15} />
        </a>
        <a href="https://massgrave.dev" target="_blank" rel="noopener noreferrer" className="text-gray-700 hover:text-gray-400 transition-colors" aria-label="MAS">
          <Globe size={15} />
        </a>
      </div>

      <div className="flex flex-wrap justify-center gap-3 mb-4">
        <span className="text-[10px] text-gray-700">{t.footer.openSource}</span>
        <span className="text-[10px] text-gray-700">·</span>
        <span className="text-[10px] text-gray-700">{t.footer.automatic}</span>
        <span className="text-[10px] text-gray-700">·</span>
        <span className="text-[10px] text-gray-700">{t.footer.verified}</span>
      </div>

      <p className="text-[10px] text-gray-800">{t.footer.copyright}</p>
    </motion.footer>
  );
}