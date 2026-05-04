import { motion } from 'framer-motion';
import { Download, Wrench, Trash2, Clock, ArrowRight } from 'lucide-react';

const iconMap = { Download, Wrench, Trash2 };

export default function StepCard({ action, index, onClick }) {
  const Icon = iconMap[action.icon] || Download;

  return (
    <motion.article
      initial={{ opacity: 0, y: 30 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{
        delay: index * 0.08 + 0.4,
        duration: 0.5,
        ease: [0.22, 1, 0.36, 1],
      }}
      whileHover={{ y: -6 }}
      whileTap={{ scale: 0.985 }}
      onClick={onClick}
      className="group cursor-pointer relative overflow-hidden rounded-2xl border border-white/[0.05] bg-white/[0.01] hover:bg-white/[0.03] hover:border-white/[0.10] transition-all duration-500 p-6 sm:p-7"
    >
      {/* Glow sutil */}
      <div
        className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-700 rounded-2xl"
        style={{
          background: `radial-gradient(500px circle at 50% 0%, ${action.color}06, transparent 60%)`,
        }}
      />

      <div className="relative z-10 flex flex-col h-full">
        {/* Icono */}
        <div
          className="w-11 h-11 rounded-xl flex items-center justify-center mb-5 transition-all duration-300 group-hover:scale-105"
          style={{
            backgroundColor: `${action.color}12`,
            color: action.color,
          }}
        >
          <Icon size={22} strokeWidth={1.8} />
        </div>

        {/* Contenido */}
        <h3 className="text-lg font-semibold text-white mb-1.5 tracking-tight">
          {action.title}
        </h3>
        <p className="text-[13px] text-gray-500 leading-relaxed mb-6 flex-1">
          {action.description}
        </p>

        {/* Footer */}
        <div className="flex items-center justify-between pt-4 border-t border-white/[0.04]">
          <div className="flex items-center gap-1.5 text-[11px] text-gray-600">
            <Clock size={11} />
            <span>{action.time}</span>
          </div>
          <div
            className="flex items-center gap-1 text-[11px] font-medium transition-all duration-300 group-hover:gap-2"
            style={{ color: action.color }}
          >
            <span className="hidden sm:inline">Descargar</span>
            <ArrowRight size={13} />
          </div>
        </div>
      </div>
    </motion.article>
  );
}