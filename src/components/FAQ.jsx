import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ChevronDown } from 'lucide-react';
import { faqsES, faqsEN } from '../data/faqs';

export default function FAQ({ t, language }) {
  const [openIndex, setOpenIndex] = useState(null);
  const faqs = language === 'en' ? faqsEN : faqsES;

  return (
    <section className="max-w-3xl mx-auto px-4 py-24 sm:py-32">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.5 }}
        className="text-center mb-14"
      >
        <h2 className="text-3xl sm:text-4xl font-bold text-white mb-3">{t.faq.title}</h2>
        <p className="text-gray-500">{t.faq.subtitle}</p>
      </motion.div>

      <div className="space-y-2">
        {faqs.map((faq, i) => (
          <motion.div
            key={i}
            initial={{ opacity: 0, y: 10 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: i * 0.04 }}
            className={`rounded-xl border transition-all duration-300 ${
              openIndex === i ? 'bg-white/[0.03] border-white/[0.10]' : 'bg-transparent border-white/[0.03] hover:border-white/[0.06]'
            }`}
          >
            <button
              onClick={() => setOpenIndex(openIndex === i ? null : i)}
              className="w-full flex items-center justify-between gap-4 p-4 sm:p-5 text-left"
            >
              <div className="flex items-center gap-3.5">
                <span className="text-xl flex-shrink-0">{faq.icon}</span>
                <span className={`text-sm sm:text-base font-medium transition-colors ${openIndex === i ? 'text-white' : 'text-gray-400'}`}>
                  {faq.question}
                </span>
              </div>
              <motion.div animate={{ rotate: openIndex === i ? 180 : 0 }} transition={{ duration: 0.25 }}>
                <ChevronDown size={18} className={openIndex === i ? 'text-emerald-400' : 'text-gray-600'} />
              </motion.div>
            </button>
            <AnimatePresence>
              {openIndex === i && (
                <motion.div
                  initial={{ height: 0, opacity: 0 }}
                  animate={{ height: 'auto', opacity: 1 }}
                  exit={{ height: 0, opacity: 0 }}
                  transition={{ duration: 0.25 }}
                  className="overflow-hidden"
                >
                  <p className="text-sm text-gray-500 leading-relaxed px-5 pb-5 pl-14">{faq.answer}</p>
                </motion.div>
              )}
            </AnimatePresence>
          </motion.div>
        ))}
      </div>
    </section>
  );
}