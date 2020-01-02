import { Article, ArticleHeader, Tag, Novel } from 'ntnv-models';
import INtnvDataStore, { ColumnName } from './INtnvDataStore';
export default class NtnvDataStore implements INtnvDataStore {
    connectionString: string;
    private pool;
    constructor(connectionString: string);
    getArticle(articleId: number): Promise<Article>;
    getArticleHeaders(articlesPerPage: number, page: number, sortKey: ColumnName): Promise<ArticleHeader[]>;
    getNovel(novelId: number): Promise<Novel>;
    getArticleTags(articleId: number): Promise<Tag[]>;
    getTags(): Promise<Tag[]>;
    searchTags(keywords: string[]): Promise<Tag[]>;
    searchArticleHeadersByTagIds(tagIds: number[], articlesPerPage: number, page: number, sortKey: ColumnName): Promise<ArticleHeader[]>;
    end(): Promise<void>;
    private static mapArticle;
    private static mapArticleHeader;
    private static mapNovel;
    private static mapTag;
    private static buildArticleQuery;
    private static buildArticleHeadersQuery;
    private static buildNovelQuery;
    private static buildArticleTagsQuery;
    private static buildTagsQuery;
    private static buildTaggedArticleHeadersQuery;
}
