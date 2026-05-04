export default function HeroBackground() {
  return (
    <div className="fixed inset-0 pointer-events-none overflow-hidden -z-10">
      <div className="absolute top-0 -left-20 w-[600px] h-[600px] bg-emerald-500/[0.03] rounded-full blur-[200px]" />
      <div className="absolute bottom-0 right-0 w-[500px] h-[500px] bg-amber-500/[0.02] rounded-full blur-[200px]" />
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[700px] h-[700px] bg-purple-500/[0.02] rounded-full blur-[250px]" />
      <div
        className="absolute inset-0 opacity-[0.015]"
        style={{
          backgroundImage: `radial-gradient(circle at 0.5px 0.5px, rgba(255,255,255,0.3) 0.5px, transparent 0)`,
          backgroundSize: '48px 48px',
        }}
      />
    </div>
  );
}