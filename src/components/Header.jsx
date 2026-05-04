import { motion } from 'framer-motion';
import { Terminal, Copy, Check, Sparkles, Shield } from 'lucide-react';
import { useState } from 'react';

export default function Header({ t }) {
  const [copied, setCopied] = useState(false);

  const copyCommand = async () => {
    try {
      await navigator.clipboard.writeText('irm https://get.activated.win | iex');
      setCopied(true);
      setTimeout(() => setCopied(false), 1800);
    } catch {}
  };

  return (
    <motion.header
      initial={{ opacity: 0, y: -20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6, ease: [0.22, 1, 0.36, 1] }}
      className="text-center mb-12 sm:mb-16 px-4"
    >
      <div className="flex flex-wrap items-center justify-center gap-2.5 mb-8">
        <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full border border-white/[0.06] bg-white/[0.01]">
          <div className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse" />
          <span className="text-[11px] text-gray-500 font-medium">{t.header.badge}</span>
        </div>
        <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full border border-white/[0.06] bg-white/[0.01]">
          <Shield size={11} className="text-emerald-400" />
          <span className="text-[11px] text-gray-500 font-medium">{t.header.security}</span>
        </div>
      </div>

      <h1 className="text-5xl sm:text-6xl md:text-7xl lg:text-8xl font-black tracking-tighter leading-none mb-4">
        <span className="text-white">{t.header.title}</span>
        <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 via-amber-400 to-red-400 animate-gradient">
          {t.header.subtitle}
        </span>
      </h1>

      <motion.div
        animate={{ y: [0, -8, 0] }}
        transition={{ duration: 3, repeat: Infinity, ease: 'easeInOut' }}
        className="mb-5"
      >
        <Sparkles size={22} className="text-amber-400/40 mx-auto" />
      </motion.div>

      <p className="text-base sm:text-lg text-gray-500 max-w-lg mx-auto font-light leading-relaxed">
        {t.header.description}
      </p>

      <motion.button
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.6 }}
        onClick={copyCommand}
        className="mt-6 inline-flex items-center gap-2.5 px-4 py-2.5 rounded-xl border border-white/[0.06] bg-white/[0.02] hover:bg-white/[0.04] hover:border-white/[0.10] transition-all group cursor-pointer"
      >
        <Terminal size={14} className="text-gray-600 group-hover:text-gray-400 transition-colors" />
        <code className="text-[13px] text-gray-500 group-hover:text-gray-300 transition-colors font-medium select-all">
          irm https://get.activated.win | iex
        </code>
        <div className="w-5 h-5 flex items-center justify-center rounded-md bg-white/[0.04] group-hover:bg-white/[0.08] transition-colors">
          {copied ? (
            <Check size={11} className="text-emerald-400" />
          ) : (
            <Copy size={11} className="text-gray-600 group-hover:text-gray-400 transition-colors" />
          )}
        </div>
      </motion.button>
    </motion.header>
  );
}