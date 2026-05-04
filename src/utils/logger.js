const PREFIX = '[OHP]';

export const logger = {
  info: (msg, ...args) => console.log(`${PREFIX} INFO  ›`, msg, ...args),
  warn: (msg, ...args) => console.warn(`${PREFIX} WARN  ›`, msg, ...args),
  error: (msg, ...args) => console.error(`${PREFIX} ERROR ›`, msg, ...args),
  debug: (msg, ...args) => {
    if (import.meta.env.DEV) console.debug(`${PREFIX} DEBUG ›`, msg, ...args);
  },
};