import React, { useState, useCallback, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  Download, Check, Sparkles, Play, Clock, Shield, Wrench, Trash2, Search, Info, 
  RefreshCw, Package, Heart, Globe, ArrowRight, MousePointer, Monitor, Zap,
  AlertTriangle, FileWarning
} from 'lucide-react';
import HeroBackground from './components/HeroBackground';
import Header from './components/Header';
import FAQ from './components/FAQ';
import Footer from './components/Footer';
import Toast from './components/Toast';
import TutorialModal from './components/TutorialModal';
import { useToast } from './hooks/useToast';
import { useLanguage } from './hooks/useLanguage';

const iconMap = { Download, Wrench, Trash2, Zap, Monitor, Search, RefreshCw, Info, Globe, Package, AlertTriangle, FileWarning };

export default function App() {
  const [selectedFeature, setSelectedFeature] = useState(null);
  const [isGenerating, setIsGenerating] = useState(false);
  const [generationStep, setGenerationStep] = useState(0);
  const [hasDownloaded, setHasDownloaded] = useState(false);
  const [showTutorial, setShowTutorial] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [showLangMenu, setShowLangMenu] = useState(false);
  const [showWarning, setShowWarning] = useState(false);
  const { toast, showToast, hideToast } = useToast();
  const { language, t, changeLanguage } = useLanguage();

  const getFeatures = () => [
    { key: 'install', icon: 'Package', title: t.features.install.title, description: t.features.install.description, details: t.features.install.details, color: '#22c55e', time: t.features.install.time, step: t.features.install.step },
    { key: 'activateOffice', icon: 'Zap', title: t.features.activateOffice.title, description: t.features.activateOffice.description, details: t.features.activateOffice.details, color: '#16a34a', time: t.features.activateOffice.time, step: t.features.activateOffice.step },
    { key: 'activateWindows', icon: 'Monitor', title: t.features.activateWindows.title, description: t.features.activateWindows.description, details: t.features.activateWindows.details, color: '#8b5cf6', time: t.features.activateWindows.time, step: t.features.activateWindows.step },
    { key: 'repair', icon: 'Wrench', title: t.features.repair.title, description: t.features.repair.description, details: t.features.repair.details, color: '#f59e0b', time: t.features.repair.time, step: t.features.repair.step },
    { key: 'uninstall', icon: 'Trash2', title: t.features.uninstall.title, description: t.features.uninstall.description, details: t.features.uninstall.details, color: '#ef4444', time: t.features.uninstall.time, step: t.features.uninstall.step },
    { key: 'checkStatus', icon: 'Search', title: t.features.checkStatus.title, description: t.features.checkStatus.description, details: t.features.checkStatus.details, color: '#06b6d4', time: t.features.checkStatus.time, step: t.features.checkStatus.step },
    { key: 'troubleshoot', icon: 'RefreshCw', title: t.features.troubleshoot.title, description: t.features.troubleshoot.description, details: t.features.troubleshoot.details, color: '#6366f1', time: t.features.troubleshoot.time, step: t.features.troubleshoot.step },
    { key: 'systemInfo', icon: 'Info', title: t.features.systemInfo.title, description: t.features.systemInfo.description, details: t.features.systemInfo.details, color: '#9ca3af', time: t.features.systemInfo.time, step: t.features.systemInfo.step },
  ];

  const getSteps = () => [
    { number: '1', title: t.tutorial.step1Title, description: t.tutorial.step1Desc, icon: '📥', color: '#22c55e' },
    { number: '2', title: t.tutorial.step2Title, description: t.tutorial.step2Desc, icon: '📂', color: '#3b82f6' },
    { number: '3', title: t.tutorial.step3Title, description: t.tutorial.step3Desc, icon: '🛡️', color: '#f59e0b' },
    { number: '4', title: t.tutorial.step4Title, description: t.tutorial.step4Desc, icon: '🔢', color: '#8b5cf6' },
    { number: '5', title: t.tutorial.step5Title, description: t.tutorial.step5Desc, icon: '✅', color: '#22c55e' },
  ];

  const features = getFeatures();
  const steps = getSteps();

  useEffect(() => { const timer = setTimeout(() => setIsLoading(false), 1000); return () => clearTimeout(timer); }, []);

  const downloadExe = useCallback(async () => {
    setIsGenerating(true); setGenerationStep(0); setHasDownloaded(false);
    for (let i = 0; i < 3; i++) { setGenerationStep(i); await new Promise(r => setTimeout(r, 700)); }
    try {
      const scriptUrl = `${window.location.origin}/office-tool.ps1`;
      

      const cmdContent = `@echo off\r\ntitle Office Helper - By Naymon Dominguez\r\ncolor 0A\r\nmode con: cols=80 lines=28\r\ncls\r\necho.\r\necho ================================================\r\necho         OFFICE HELPER\r\necho         By Naymon Dominguez\r\necho ================================================\r\necho.\r\necho   [!]  Este archivo es SEGURO.\r\necho   [!]  Puede que Windows SmartScreen muestre un aviso.\r\necho   [!]  Haz clic en "Mas informacion" y luego "Ejecutar de todos modos".\r\necho.\r\necho   [i]  Este script abrira PowerShell como Admin.\r\necho   [i]  ACEPTA el aviso de seguridad (UAC).\r\necho   [i]  NO cierres la ventana de PowerShell.\r\necho.\r\necho ================================================\r\necho.\r\necho   Presiona cualquier tecla para comenzar...\r\npause >nul\r\n\r\ncls\r\necho.\r\necho ================================================\r\necho      DESCARGANDO HERRAMIENTAS...\r\necho ================================================\r\necho.\r\necho   Obteniendo la version mas reciente...\r\necho.\r\n\r\npowershell -NoProfile -ExecutionPolicy Bypass -Command "try { Write-Host 'Descargando Office Helper...' -ForegroundColor Yellow; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $tempFile = [System.IO.Path]::GetTempPath() + 'office-helper.ps1'; Invoke-WebRequest -Uri '${scriptUrl}' -OutFile $tempFile; Write-Host 'Abriendo como Administrador...' -ForegroundColor Green; Write-Host 'ACEPTA el aviso de UAC que aparecera.' -ForegroundColor Cyan; Start-Sleep -Seconds 2; Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File', $tempFile -Wait; Remove-Item $tempFile -ErrorAction SilentlyContinue; Write-Host 'Proceso finalizado.' -ForegroundColor Green; Read-Host 'Presiona Enter para salir' } catch { Write-Host 'ERROR: ' $_.Exception.Message -ForegroundColor Red; Write-Host 'Verifica tu conexion a internet.' -ForegroundColor Yellow; Read-Host 'Presiona Enter para salir' }"\r\n\r\ncls\r\necho.\r\necho ================================================\r\necho      PROCESO FINALIZADO\r\necho ================================================\r\necho.\r\necho   La ventana de PowerShell se ha cerrado.\r\necho   Si todo salio bien, la accion se completo.\r\necho.\r\necho   Puedes cerrar esta ventana.\r\necho.\r\npause\r\nexit\r\n`;


      const blob = new Blob([cmdContent], { type: 'application/octet-stream' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'Office-Helper.cmd';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);

      setGenerationStep(3); setHasDownloaded(true);
      showToast(t.toast.success, 'success');
      
      // Mostrar advertencia después de descargar
      setTimeout(() => setShowWarning(true), 1500);
      
    } catch (err) { showToast(t.toast.error, 'error'); }
    setTimeout(() => { setIsGenerating(false); setHasDownloaded(false); }, 4000);
  }, [showToast, t]);

  if (isLoading) {
    return (
      <div className="fixed inset-0 z-[200] bg-[#0a0a0a] flex items-center justify-center">
        <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} transition={{ duration: 0.4 }} className="text-center">
          <motion.div animate={{ rotate: 360 }} transition={{ duration: 2, repeat: Infinity, ease: 'linear' }} className="w-14 h-14 mx-auto mb-5 rounded-full border-2 border-emerald-500/20 border-t-emerald-400" />
          <p className="text-sm text-gray-500 font-medium">{t.loading.text}</p>
          <p className="text-xs text-gray-700 mt-2">{t.loading.by}</p>
        </motion.div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#0a0a0a] text-white relative selection:bg-emerald-500/20">
      <HeroBackground />
      <Toast toast={toast} onClose={hideToast} />

      {/* Modal de advertencia post-descarga */}
      <AnimatePresence>
        {showWarning && (
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            className="fixed inset-0 z-[200] flex items-center justify-center bg-black/85 backdrop-blur-md p-4"
            onClick={() => setShowWarning(false)}>
            <motion.div initial={{ scale: 0.9, opacity: 0, y: 20 }} animate={{ scale: 1, opacity: 1, y: 0 }} exit={{ scale: 0.9, opacity: 0, y: 20 }}
              className="bg-[#0f0f0f] border border-yellow-500/30 rounded-3xl w-full max-w-md overflow-hidden shadow-2xl shadow-yellow-500/10"
              onClick={e => e.stopPropagation()}>
              <div className="p-6 sm:p-7">
                <div className="flex items-center gap-4 mb-5">
                  <div className="w-12 h-12 rounded-2xl bg-yellow-500/15 flex items-center justify-center flex-shrink-0">
                    <AlertTriangle size={24} className="text-yellow-400" />
                  </div>
                  <div>
                    <h2 className="text-xl font-bold text-white">⚠️ Aviso Importante</h2>
                    <p className="text-xs text-gray-500 mt-0.5">Lee esto antes de ejecutar el archivo</p>
                  </div>
                </div>

                <div className="bg-yellow-500/5 border border-yellow-500/20 rounded-2xl p-4 mb-4">
                  <p className="text-sm text-yellow-300 font-medium mb-2">Windows SmartScreen</p>
                  <p className="text-xs text-gray-400 leading-relaxed">
                    Windows puede mostrar un aviso de "Windows protegio tu PC" porque el archivo no tiene firma digital. 
                    Esto es <span className="text-white font-medium">normal y seguro</span>.
                  </p>
                </div>

                <div className="bg-white/[0.02] border border-white/[0.06] rounded-2xl p-4 mb-5">
                  <p className="text-xs text-gray-400 font-medium mb-2">📋 Pasos para ejecutarlo:</p>
                  <div className="space-y-2">
                    <div className="flex items-start gap-2">
                      <span className="w-5 h-5 rounded-full bg-yellow-500/20 text-yellow-400 flex items-center justify-center text-[10px] font-bold flex-shrink-0 mt-0.5">1</span>
                      <span className="text-xs text-gray-400">Haz clic en <span className="text-white font-medium">"Mas informacion"</span></span>
                    </div>
                    <div className="flex items-start gap-2">
                      <span className="w-5 h-5 rounded-full bg-yellow-500/20 text-yellow-400 flex items-center justify-center text-[10px] font-bold flex-shrink-0 mt-0.5">2</span>
                      <span className="text-xs text-gray-400">Haz clic en <span className="text-white font-medium">"Ejecutar de todos modos"</span></span>
                    </div>
                    <div className="flex items-start gap-2">
                      <span className="w-5 h-5 rounded-full bg-yellow-500/20 text-yellow-400 flex items-center justify-center text-[10px] font-bold flex-shrink-0 mt-0.5">3</span>
                      <span className="text-xs text-gray-400">Acepta el aviso de <span className="text-white font-medium">Administrador (UAC)</span></span>
                    </div>
                    <div className="flex items-start gap-2">
                      <span className="w-5 h-5 rounded-full bg-yellow-500/20 text-yellow-400 flex items-center justify-center text-[10px] font-bold flex-shrink-0 mt-0.5">4</span>
                      <span className="text-xs text-gray-400">Elige una opcion del menu y <span className="text-white font-medium">¡listo!</span></span>
                    </div>
                  </div>
                </div>

                <div className="bg-green-500/5 border border-green-500/20 rounded-2xl p-3 mb-5">
                  <div className="flex items-center gap-2">
                    <Shield size={14} className="text-green-400" />
                    <p className="text-xs text-green-400">
                      El codigo es 100% abierto. Puedes revisarlo en nuestro GitHub.
                    </p>
                  </div>
                </div>

                <button onClick={() => setShowWarning(false)}
                  className="w-full py-3 rounded-2xl bg-gradient-to-r from-yellow-600 to-amber-500 text-white font-semibold text-sm hover:brightness-110 transition-all flex items-center justify-center gap-2">
                  <Check size={18} />Entendido, gracias
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Selector de idioma */}
      <div className="fixed top-4 right-4 z-[100]">
        <motion.button whileHover={{ scale: 1.05 }} whileTap={{ scale: 0.95 }} onClick={() => setShowLangMenu(!showLangMenu)}
          className="flex items-center gap-2 px-3.5 py-2 rounded-xl bg-white/[0.03] border border-white/[0.08] hover:bg-white/[0.06] transition-all text-sm">
          <Globe size={14} className="text-gray-400" />
          <span className="text-gray-300 font-medium">{language === 'es' ? '🇪🇸 ES' : '🇺🇸 EN'}</span>
        </motion.button>
        <AnimatePresence>
          {showLangMenu && (
            <motion.div initial={{ opacity: 0, y: -5 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -5 }}
              className="absolute top-full right-0 mt-2 w-40 bg-[#1a1a1f] border border-white/[0.08] rounded-xl overflow-hidden shadow-xl backdrop-blur-xl">
              <button onClick={() => { changeLanguage('es'); setShowLangMenu(false); }} className={`w-full px-4 py-2.5 text-left text-sm hover:bg-white/[0.04] transition-colors flex items-center gap-2 ${language === 'es' ? 'text-emerald-400 bg-emerald-500/5' : 'text-gray-400'}`}>🇪🇸 Español</button>
              <button onClick={() => { changeLanguage('en'); setShowLangMenu(false); }} className={`w-full px-4 py-2.5 text-left text-sm hover:bg-white/[0.04] transition-colors flex items-center gap-2 ${language === 'en' ? 'text-emerald-400 bg-emerald-500/5' : 'text-gray-400'}`}>🇺🇸 English</button>
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      <main className="relative z-10 flex flex-col items-center justify-center min-h-screen px-4 pt-12 pb-8">
        <Header t={t} />

        <motion.button initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.8 }} onClick={() => setShowTutorial(true)}
          className="mb-8 inline-flex items-center gap-2 px-5 py-2.5 rounded-full border border-white/[0.06] bg-white/[0.02] hover:bg-white/[0.04] hover:border-white/[0.10] transition-all text-[13px] text-gray-400 hover:text-gray-200">
          <Play size={13} className="text-emerald-400" /><span>{t.tutorial.watch}</span>
        </motion.button>

        {/* Cómo funciona */}
        <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.9 }} className="w-full max-w-4xl mb-10">
          <div className="text-center mb-6"><h2 className="text-2xl font-bold text-white">{t.download.title}</h2><p className="text-sm text-gray-500 mt-1">{t.download.subtitle}</p></div>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            {steps.slice(0, 3).map((step, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 1 + i * 0.1 }} className="relative p-5 rounded-2xl bg-white/[0.02] border border-white/[0.05] text-center">
                <div className="text-3xl mb-3">{step.icon}</div>
                <div className="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold mx-auto mb-2" style={{ backgroundColor: `${step.color}20`, color: step.color }}>{step.number}</div>
                <h3 className="text-white font-semibold mb-1">{step.title}</h3>
                <p className="text-xs text-gray-500 leading-relaxed">{step.description}</p>
              </motion.div>
            ))}
          </div>
          
          {/* Advertencia de SmartScreen */}
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 1.3 }}
            className="mt-6 p-4 rounded-2xl bg-yellow-500/5 border border-yellow-500/20 text-center">
            <div className="flex items-center justify-center gap-2 mb-2">
              <FileWarning size={16} className="text-yellow-400" />
              <span className="text-sm text-yellow-300 font-medium">Aviso de Windows SmartScreen</span>
            </div>
            <p className="text-xs text-gray-400 leading-relaxed max-w-lg mx-auto">
              Windows puede mostrar un aviso de seguridad porque el archivo no tiene firma digital. 
              Haz clic en <span className="text-white font-medium">"Mas informacion"</span> y luego en 
              <span className="text-white font-medium"> "Ejecutar de todos modos"</span>. El codigo es 100% seguro y auditable.
            </p>
          </motion.div>
        </motion.div>

        {/* Botón descarga */}
        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 1.2 }} className="mb-12">
          <motion.button whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.97 }} onClick={downloadExe}
            className="group relative px-10 py-5 rounded-3xl bg-gradient-to-r from-emerald-600 to-green-500 text-white font-bold text-xl shadow-2xl hover:brightness-110 transition-all flex items-center gap-4 overflow-hidden"
            style={{ boxShadow: '0 0 60px rgba(34, 197, 94, 0.3)' }}>
            <motion.div animate={{ scale: [1, 1.2, 1] }} transition={{ duration: 2, repeat: Infinity }}><Download size={28} /></motion.div>
            <span>{t.download.button}</span><ArrowRight size={22} className="group-hover:translate-x-1 transition-transform" />
            <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent -skew-x-45 translate-x-[-200%] group-hover:translate-x-[200%] transition-transform duration-1000" />
          </motion.button>
          <p className="text-center text-[11px] text-gray-600 mt-3">{t.download.buttonSub}</p>
        </motion.div>

        {/* Tarjetas */}
        <div className="w-full max-w-6xl mb-16">
          <div className="text-center mb-6"><h2 className="text-xl font-bold text-white">{t.features.title}</h2><p className="text-sm text-gray-500 mt-1">{t.features.subtitle}</p></div>
          <div className="grid gap-4 grid-cols-1 sm:grid-cols-2 lg:grid-cols-4">
            {features.map((feature, i) => {
              const IconComponent = iconMap[feature.icon] || Zap;
              return (
                <motion.div key={i} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 1.3 + i * 0.05, duration: 0.4 }}
                  whileHover={{ y: -4 }} onClick={() => setSelectedFeature(feature)}
                  className="group cursor-pointer relative overflow-hidden rounded-2xl border border-white/[0.05] bg-white/[0.01] hover:bg-white/[0.03] hover:border-white/[0.10] transition-all duration-500 p-5">
                  <div className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-500 rounded-2xl" style={{ background: `radial-gradient(400px circle at 50% 0%, ${feature.color}06, transparent 60%)` }} />
                  <div className="relative z-10">
                    <div className="flex items-center gap-3 mb-3">
                      <div className="w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0 transition-transform duration-300 group-hover:scale-110" style={{ backgroundColor: `${feature.color}15`, color: feature.color }}><IconComponent size={18} strokeWidth={1.8} /></div>
                      <div><h3 className="text-sm font-semibold text-white">{feature.title}</h3><div className="flex items-center gap-1.5 text-[10px] text-gray-600"><Clock size={9} /><span>{feature.time}</span></div></div>
                      <span className="ml-auto text-[9px] font-medium px-2 py-0.5 rounded-full border" style={{ color: feature.color, borderColor: `${feature.color}20`, backgroundColor: `${feature.color}08` }}>{feature.step}</span>
                    </div>
                    <p className="text-[11px] text-gray-500 leading-relaxed">{feature.description}</p>
                    <div className="mt-3 flex items-center gap-1 text-[10px] font-medium opacity-0 group-hover:opacity-100 transition-opacity duration-300" style={{ color: feature.color }}><MousePointer size={9} /><span>{t.features.moreInfo}</span></div>
                  </div>
                </motion.div>
              );
            })}
          </div>
        </div>

        {/* Créditos */}
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 2 }} className="text-center mb-10">
          <div className="inline-flex items-center gap-2 px-5 py-3 rounded-2xl bg-white/[0.02] border border-white/[0.06]">
            <span className="text-sm text-gray-400">{t.credits.developed}</span><span className="text-sm font-semibold text-white">Naymon Dominguez</span>
          </div>
          <p className="text-[11px] text-gray-600 mt-2">{t.credits.based} · massgrave.dev</p>
        </motion.div>

        <FAQ t={t} language={language} />
      </main>

      <Footer t={t} />

      {/* Modal detalle */}
      <AnimatePresence>
        {selectedFeature && (
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} className="fixed inset-0 z-50 flex items-center justify-center bg-black/75 backdrop-blur-sm p-4" onClick={() => setSelectedFeature(null)}>
            <motion.div initial={{ scale: 0.95, opacity: 0, y: 10 }} animate={{ scale: 1, opacity: 1, y: 0 }} exit={{ scale: 0.95, opacity: 0, y: 10 }} transition={{ type: 'spring', stiffness: 400, damping: 30 }}
              className="bg-[#0f0f0f] border border-white/[0.06] rounded-3xl w-full max-w-md overflow-hidden shadow-2xl shadow-black/50" onClick={e => e.stopPropagation()}>
              <div className="p-6 sm:p-7">
                {(() => { const IconComponent = iconMap[selectedFeature.icon] || Zap; return (<>
                  <div className="flex items-center gap-4 mb-5">
                    <div className="w-12 h-12 rounded-2xl flex items-center justify-center flex-shrink-0" style={{ backgroundColor: `${selectedFeature.color}15`, color: selectedFeature.color }}><IconComponent size={24} strokeWidth={1.8} /></div>
                    <div>
                      <span className="text-[10px] font-medium px-2.5 py-0.5 rounded-full border inline-block mb-1" style={{ color: selectedFeature.color, borderColor: `${selectedFeature.color}20`, backgroundColor: `${selectedFeature.color}08` }}>{selectedFeature.step}</span>
                      <h2 className="text-xl font-bold text-white">{selectedFeature.title}</h2>
                      <div className="flex items-center gap-1.5 text-[11px] text-gray-600 mt-0.5"><Clock size={10} /><span>{selectedFeature.time}</span></div>
                    </div>
                  </div>
                  <p className="text-sm text-gray-400 leading-relaxed mb-5">{selectedFeature.details}</p>
                  <div className="bg-white/[0.015] border border-white/[0.04] rounded-2xl p-4 mb-5"><p className="text-[11px] text-gray-600 mb-2 font-medium">{t.modal.included}</p><p className="text-xs text-gray-500">{t.modal.includedDesc}</p></div>
                  <motion.button whileHover={{ scale: 1.01 }} whileTap={{ scale: 0.98 }} onClick={() => { setSelectedFeature(null); downloadExe(); }}
                    className="w-full py-3 rounded-2xl text-white font-semibold text-sm hover:brightness-110 transition-all flex items-center justify-center gap-2.5"
                    style={{ background: `linear-gradient(135deg, ${selectedFeature.color}, ${selectedFeature.color}cc)` }}><Download size={18} />{t.modal.download}</motion.button>
                  <button onClick={() => setSelectedFeature(null)} className="w-full mt-3 py-2.5 text-[13px] text-gray-600 hover:text-gray-400 transition-colors">{t.modal.close}</button>
                </>); })()}
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Modal generación */}
      <AnimatePresence>
        {isGenerating && (
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} className="fixed inset-0 z-[150] flex items-center justify-center bg-black/90 backdrop-blur-md" style={{ pointerEvents: 'all' }}>
            <motion.div initial={{ scale: 0.95 }} animate={{ scale: 1 }} className="text-center max-w-xs w-full">
              <div className="relative w-20 h-20 mx-auto mb-5">
                <svg className="w-full h-full -rotate-90" viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="none" stroke="rgba(255,255,255,0.03)" strokeWidth="3" /><motion.circle cx="50" cy="50" r="40" fill="none" stroke={hasDownloaded ? '#22c55e' : '#eab308'} strokeWidth="3" strokeLinecap="round" initial={{ pathLength: 0 }} animate={{ pathLength: hasDownloaded ? 1 : (generationStep + 1) / 3 }} transition={{ duration: 0.5 }} style={{ strokeDasharray: 251 }} /></svg>
                <div className="absolute inset-0 flex items-center justify-center">{hasDownloaded ? <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ type: 'spring', stiffness: 500 }}><Check size={24} className="text-emerald-400" /></motion.div> : <Sparkles size={22} className="text-amber-400 animate-pulse" />}</div>
              </div>
              <h3 className="text-sm font-semibold text-white mb-1">{hasDownloaded ? t.generating.ready : t.generating.preparing}</h3>
              <p className="text-xs text-gray-500">{hasDownloaded ? t.generating.step4 : [t.generating.step1, t.generating.step2, t.generating.step3][generationStep]}</p>
              {hasDownloaded && (
                <motion.div initial={{ opacity: 0, y: 5 }} animate={{ opacity: 1, y: 0 }} className="mt-5 bg-emerald-500/[0.04] border border-emerald-500/[0.10] rounded-xl p-4 text-left">
                  <p className="text-sm text-emerald-400 font-medium mb-2">{t.generating.fileReady}</p>
                  <div className="text-xs text-gray-400 space-y-1">
                    <p>{t.generating.instruct1}</p>
                    <p>{t.generating.instruct2}</p>
                    <p>{t.generating.instruct3}</p>
                    <p>{t.generating.instruct4}</p>
                  </div>
                </motion.div>
              )}
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      <TutorialModal isOpen={showTutorial} onClose={() => setShowTutorial(false)} t={t} steps={steps} />
    </div>
  );
}