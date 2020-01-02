try {
  const NtnvAPI = require('./dist/NtnvAPI.js').default;

  const user = process.env.DB_USER;
  const password = process.env.DB_PASSWORD;
  const host = process.env.DB_HOST;
  const port = process.env.DB_PORT;
  const dbName = process.env.DB_NAME;

  const api = new NtnvAPI(`postgres://${user}:${password}@${host}:${port}/${dbName}`);

  api.listen(process.env.NTNV_API_PORT);
} catch(err) {
  console.log(err);
}

