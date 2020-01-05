import log from './log';
import NtnvDataStore from '~/NtnvDataStore';

describe('NtnvDataStoreクラス', (): void => {
  let dataStore: NtnvDataStore;
  
  beforeAll(() => {
    const user = process.env.DB_USER;
    const password = process.env.DB_PASSWORD;
    const host = process.env.DB_HOST;
    const port = process.env.DB_PORT;
    const dbName = process.env.DB_NAME;
    const connectionString = `postgres://${user}:${password}@${host}:${port}/${dbName}`;
    dataStore = new NtnvDataStore(connectionString);
  });

  afterAll(async () => {
    await dataStore.end();
  });
  
  test('getArticleメソッド 正常', async () => {
    const article = await dataStore.getArticle(1);
    expect(article.title).toBe('腕白関白');
    // log(article);
  });
  
  test('getArticleHeadersメソッド 正常', async () => {
    const headers = await dataStore.getArticleHeaders(10, 1, 'updated_at');
    expect(headers.length).toBe(10);
    // log(headers);
  });
  
  test('searchArticleHeadersByTagsメソッド 正常', async () => {
    //const headers = await dataStore.searchArticleHeadersByTags([1, 58], 10, 1, 'updated_at');
    // log(headers);
    
  });

  test('searchTagsメソッド 正常', async () => {
    const tags = await dataStore.searchTags(['オリジナル']);

    log(tags);
  })
});