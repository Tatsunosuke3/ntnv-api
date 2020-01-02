import { Article, ArticleHeader, Tag } from 'ntnv-models';

export type ColumnName = 'updated_at' | 'rating';
export default interface INtnvDataStore {
  getArticle(id: number): Promise<Article>;
  getArticleHeaders(articlesPerPage: number, page: number, sortKey: ColumnName): Promise<ArticleHeader[]>;
  getTags(): Promise<Tag[]>;
  searchTags(keywords: string[]): Promise<Tag[]>;
  searchArticleHeadersByTagIds(tagIds: number[], articlesPerPage: number, page: number, sortKey: ColumnName): Promise<ArticleHeader[]>;
}