import express from 'express';

const app = express();
const { env } = process;
const options = {
  port: env.PORT || 3000
};

app.get('/', (req, res) => {
  return res.json({
    hello: env.HELLO || 'world'
  });
});

app.get('/howdy', (req, res) => {
  return res.json({
    howdy: env.HOWDY || 'texas'
  });
});

app.listen(options.port, () => {
  console.log(`listening on port ${options.port}`);
});
