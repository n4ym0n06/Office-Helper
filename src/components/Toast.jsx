import { motion, AnimatePresence } from 'framer-motion';
import { Check, X } from 'lucide-react';

export default function Toast({ toast, onClose }) {
  return (
    <AnimatePresence>
      {toast && (
        <motion.div
          initial={{ opacity: 0, y: 40, scale: 0.95 }}
          animate={{ opacity: 1, y: 0, scale: 1 }}
          exit={{ opacity: 0, y: 20, scale: 0.95 }}
          transition={{ type: 'spring', stiffness: 400, damping: 30 }}
          className="fixed bottom-6 right-6 z-[100] flex items-center gap-3 px-5 py-3.5 rounded-2xl bg-[#111] border border-white/[0.08] shadow-2xl shadow-black/50 backdrop-blur-xl min-w-[300px]"
        >
          <div className="w-7 h-7 rounded-full bg-emerald-500/15 flex items-center justify-center flex-shrink-0">
            <Check size={14} className="text-emerald-400" />
          </div>
          <p className="text-sm text-gray-300 flex-1 font-medium">{toast.message}</p>
          <button onClick={onClose} className="text-gray-600 hover:text-gray-400 transition-colors flex-shrink-0">
            <X size={14} />
          </button>
        </motion.div>
      )}
    </AnimatePresence>
  );
}