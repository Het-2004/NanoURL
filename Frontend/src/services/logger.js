// Logging Service for NanoURL Frontend
// Replace console.log/error/warn with this service

const LOG_LEVELS = {
  DEBUG: 'DEBUG',
  INFO: 'INFO',
  WARN: 'WARN',
  ERROR: 'ERROR'
};

class Logger {
  constructor() {
    this.isDevelopment = import.meta.env.MODE === 'development';
    this.enableDebug = import.meta.env.VITE_ENABLE_DEBUG_MODE === 'true';
  }

  formatMessage(level, message, data) {
    const timestamp = new Date().toISOString();
    return {
      timestamp,
      level,
      message,
      data,
      userAgent: navigator.userAgent,
      url: window.location.href
    };
  }

  debug(message, ...data) {
    if (this.isDevelopment || this.enableDebug) {
      const logData = this.formatMessage(LOG_LEVELS.DEBUG, message, data);
      console.log(`[DEBUG] ${logData.timestamp} - ${message}`, ...data);
    }
  }

  info(message, ...data) {
    if (this.isDevelopment) {
      const logData = this.formatMessage(LOG_LEVELS.INFO, message, data);
      console.info(`[INFO] ${logData.timestamp} - ${message}`, ...data);
    }
  }

  warn(message, ...data) {
    const logData = this.formatMessage(LOG_LEVELS.WARN, message, data);
    console.warn(`[WARN] ${logData.timestamp} - ${message}`, ...data);
    
    // Send to monitoring service in production
    if (!this.isDevelopment) {
      this.sendToMonitoring(logData);
    }
  }

  error(message, error, ...additionalData) {
    const logData = this.formatMessage(LOG_LEVELS.ERROR, message, {
      error: error instanceof Error ? {
        name: error.name,
        message: error.message,
        stack: error.stack
      } : error,
      additionalData
    });

    console.error(`[ERROR] ${logData.timestamp} - ${message}`, error, ...additionalData);

    // Always send errors to monitoring service
    this.sendToMonitoring(logData);
  }

  sendToMonitoring(logData) {
    // TODO: Integrate with error tracking service
    // Example: Sentry, LogRocket, Datadog, etc.
    
    // Prevent unused parameter warning - will be used when integrated
    void logData;
    
    // Example for Sentry:
    // if (window.Sentry) {
    //   if (logData.level === LOG_LEVELS.ERROR) {
    //     Sentry.captureException(logData.data.error);
    //   } else {
    //     Sentry.captureMessage(logData.message, logData.level.toLowerCase());
    //   }
    // }

    // Example for custom endpoint:
    // if (!this.isDevelopment) {
    //   fetch('/api/logs', {
    //     method: 'POST',
    //     headers: { 'Content-Type': 'application/json' },
    //     body: JSON.stringify(logData)
    //   }).catch(() => {
    //     // Silently fail to avoid infinite loops
    //   });
    // }
  }

  // Performance logging
  time(label) {
    if (this.isDevelopment) {
      console.time(label);
    }
  }

  timeEnd(label) {
    if (this.isDevelopment) {
      console.timeEnd(label);
    }
  }

  // Table logging (useful for arrays/objects)
  table(data) {
    if (this.isDevelopment) {
      console.table(data);
    }
  }
}

// Export singleton instance
export const logger = new Logger();

// Usage examples:
// logger.debug('Component mounted', { componentName: 'UrlShortener' });
// logger.info('User action', { action: 'shorten_url', url: 'example.com' });
// logger.warn('Slow API response', { duration: 5000 });
// logger.error('Failed to fetch', error, { endpoint: '/api/shorten' });
