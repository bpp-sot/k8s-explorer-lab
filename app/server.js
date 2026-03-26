const express = require('express');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 3000;
const VERSION = process.env.APP_VERSION || '1.0.0';

// Track request count (useful for demonstrating load balancing)
let requestCount = 0;

// -------------------------------------------------------------------
// Health check endpoints (Kubernetes probes)
// -------------------------------------------------------------------
app.get('/healthz', (_req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.get('/ready', (_req, res) => {
  res.status(200).json({ status: 'ready' });
});

// -------------------------------------------------------------------
// Main page — shows container/pod metadata
// -------------------------------------------------------------------
app.get('/', (_req, res) => {
  requestCount++;

  const info = {
    message: 'Hello from Kubernetes! 🚀',
    version: VERSION,
    hostname: os.hostname(),              // This will be the Pod name in K8s
    platform: os.platform(),
    uptime: `${Math.floor(process.uptime())}s`,
    requestCount,
    memoryUsage: `${Math.round(process.memoryUsage().rss / 1024 / 1024)}MB`,
    environment: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString(),
  };

  // Return HTML if requested from a browser, otherwise JSON
  if (_req.headers.accept && _req.headers.accept.includes('text/html')) {
    res.send(`
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <title>K8s Explorer App</title>
        <style>
          body { font-family: system-ui, sans-serif; max-width: 600px; margin: 40px auto; padding: 0 20px; background: #f8f9fa; }
          h1 { color: #326ce5; }
          table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,.1); }
          td, th { padding: 12px 16px; text-align: left; border-bottom: 1px solid #eee; }
          th { background: #326ce5; color: white; width: 40%; }
          .footer { margin-top: 20px; color: #666; font-size: 0.85em; }
        </style>
      </head>
      <body>
        <h1>🚀 K8s Explorer App</h1>
        <table>
          ${Object.entries(info).map(([k, v]) =>
            `<tr><th>${k}</th><td>${v}</td></tr>`
          ).join('')}
        </table>
        <p class="footer">Refresh the page to see the request count increase.
        When running multiple replicas, notice the <strong>hostname</strong> changing — that's Kubernetes load balancing!</p>
      </body>
      </html>
    `);
  } else {
    res.json(info);
  }
});

// -------------------------------------------------------------------
// Simulated heavy endpoint (useful for HPA / scaling exercises)
// -------------------------------------------------------------------
app.get('/compute', (_req, res) => {
  const start = Date.now();
  // Simulate CPU-intensive work
  let result = 0;
  for (let i = 0; i < 1e7; i++) {
    result += Math.sqrt(i);
  }
  res.json({
    hostname: os.hostname(),
    durationMs: Date.now() - start,
    result: Math.round(result),
  });
});

// -------------------------------------------------------------------
// Start server
// -------------------------------------------------------------------
app.listen(PORT, '0.0.0.0', () => {
  console.log(`K8s Explorer App v${VERSION} listening on port ${PORT}`);
  console.log(`Hostname: ${os.hostname()}`);
});
