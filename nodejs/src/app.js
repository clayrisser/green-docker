import express from 'express';

const app = express();
const { env } = process;
const port = env.PORT || 3000;

app.get('/', (_req, res) => {
  res.json({
    hello: env.HELLO || 'world'
  });
});

app.get('/howdy', (_req, res) => {
  res.json({
    howdy: env.HOWDY || 'texas'
  });
});

const server = app.listen(port, () => {
  console.log(`listening on port ${port}`);
});

// Graceful shutdown: tini forwards SIGTERM/SIGINT; close the listener so
// in-flight requests finish before the process exits.
const shutdown = () => server.close(() => process.exit(0));
process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);
