import { motion, AnimatePresence } from 'framer-motion';
import { X, ChevronRight, ChevronLeft, Check } from 'lucide-react';
import { useState } from 'react';

export default function TutorialModal({ isOpen, onClose, t, steps }) {
  const [step, setStep] = useState(0);

  const next = () => step < steps.length - 1 && setStep(s => s + 1);
  const prev = () => step > 0 && setStep(s => s - 1);

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-[80] flex items-center justify-center bg-black/85 backdrop-blur-md p-4"
          onClick={onClose}
        >
          <motion.div
            initial={{ scale: 0.94, opacity: 0, y: 10 }}
            animate={{ scale: 1, opacity: 1, y: 0 }}
            exit={{ scale: 0.94, opacity: 0, y: 10 }}
            transition={{ type: 'spring', stiffness: 400, damping: 30 }}
            className="bg-[#0f0f0f] border border-white/[0.06] rounded-3xl w-full max-w-lg overflow-hidden shadow-2xl"
            onClick={e => e.stopPropagation()}
          >
            <div className="flex items-center justify-between p-5 border-b border-white/[0.04]">
              <div>
                <h3 className="text-lg font-semibold text-white">{t.tutorial.title}</h3>
                <p className="text-xs text-gray-600 mt-0.5">{t.tutorial.steps} {step + 1}/{steps.length}</p>
              </div>
              <button onClick={onClose} className="p-2 rounded-lg hover:bg-white/[0.04] transition-colors">
                <X size={18} className="text-gray-600" />
              </button>
            </div>

            <div className="p-6 sm:p-8">
              <motion.div
                key={step}
                initial={{ opacity: 0, x: 30 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.25 }}
                className="text-center"
              >
                <div className="w-20 h-20 rounded-3xl flex items-center justify-center mx-auto mb-5 text-4xl" style={{ backgroundColor: `${steps[step].color}10` }}>
                  {steps[step].icon}
                </div>
                <div className="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold mx-auto mb-3" style={{ backgroundColor: `${steps[step].color}20`, color: steps[step].color }}>
                  {steps[step].number}
                </div>
                <h4 className="text-xl font-bold text-white mb-2">{steps[step].title}</h4>
                <p className="text-sm text-gray-400 leading-relaxed max-w-sm mx-auto">{steps[step].description}</p>
              </motion.div>

              <div className="flex justify-center gap-1.5 mt-8">
                {steps.map((_, i) => (
                  <button key={i} onClick={() => setStep(i)} className={`h-1.5 rounded-full transition-all duration-300 ${i === step ? 'w-8 bg-emerald-500' : 'w-1.5 bg-white/08 hover:bg-white/15'}`} />
                ))}
              </div>

              <div className="flex justify-between mt-8">
                <button onClick={prev} disabled={step === 0} className={`flex items-center gap-1.5 px-4 py-2 rounded-xl text-sm transition-all ${step === 0 ? 'opacity-20 cursor-not-allowed text-gray-600' : 'text-gray-400 hover:text-white hover:bg-white/[0.03]'}`}>
                  <ChevronLeft size={16} />{t.tutorial.prev}
                </button>
                {step < steps.length - 1 ? (
                  <button onClick={next} className="flex items-center gap-1.5 px-4 py-2 rounded-xl bg-white/[0.04] border border-white/[0.06] text-sm text-gray-300 hover:bg-white/[0.08] transition-all">
                    {t.tutorial.next}<ChevronRight size={16} />
                  </button>
                ) : (
                  <button onClick={onClose} className="flex items-center gap-2 px-5 py-2 rounded-xl bg-emerald-600 text-white text-sm font-medium hover:bg-emerald-500 transition-colors">
                    <Check size={16} />{t.tutorial.done}
                  </button>
                )}
              </div>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}