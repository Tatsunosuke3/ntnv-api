export default class NtnvAPI {
    connectionString: string;
    private app;
    private dataStore;
    constructor(connectionString: string);
    listen(port: number): void;
    private allowCros;
    private getArticleHeaders;
    private getArticle;
    private searchArticleHeadersByTags;
    private errorHandler;
}
