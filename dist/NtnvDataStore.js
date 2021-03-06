"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const pg_1 = require("pg");
const ntnv_models_1 = require("ntnv-models");
class NtnvDataStore {
    constructor(connectionString) {
        this.connectionString = connectionString;
        this.pool = new pg_1.Pool({
            connectionString: connectionString,
            max: 20,
            idleTimeoutMillis: 30000,
            connectionTimeoutMillis: 2000,
        });
    }
    async getArticle(articleId) {
        const res = await this.pool.query(NtnvDataStore.buildArticleQuery(articleId));
        if (res.rowCount === 0)
            return null;
        const article = NtnvDataStore.mapArticle(res.rows[0]);
        article.novel = await this.getNovel(article.novelId);
        article.tags = await this.getArticleTags(article.id);
        return article;
    }
    async getArticleHeaders(articlesPerPage, page, sortKey) {
        const res = await this.pool.query(NtnvDataStore.buildArticleHeadersQuery(articlesPerPage, page, sortKey));
        return await Promise.all(res.rows.map(async (row, index) => {
            const header = NtnvDataStore.mapArticleHeader(row);
            header.tags = await this.getArticleTags(header.id);
            return header;
        }));
    }
    async getNovel(novelId) {
        const novelRes = await this.pool.query(NtnvDataStore.buildNovelQuery(novelId));
        return NtnvDataStore.mapNovel(novelRes.rows[0]);
    }
    async getArticleTags(articleId) {
        const res = await this.pool.query(NtnvDataStore.buildArticleTagsQuery(articleId));
        return res.rows.map((row, index) => {
            return NtnvDataStore.mapTag(row);
        });
    }
    async getTags() {
        return null;
    }
    async searchTags(keywords) {
        const res = await this.pool.query(NtnvDataStore.buildTagsQuery(keywords));
        return res.rows.map((row) => {
            return NtnvDataStore.mapTag(row);
        });
    }
    async searchArticleHeadersByTagIds(tagIds, articlesPerPage, page, sortKey) {
        const res = await this.pool.query(NtnvDataStore.buildTaggedArticleHeadersQuery(tagIds, articlesPerPage, page, sortKey));
        return await Promise.all(res.rows.map(async (row) => {
            const header = NtnvDataStore.mapArticleHeader(row);
            header.tags = await this.getArticleTags(header.id);
            return header;
        }));
    }
    async end() {
        await this.pool.end();
    }
    static mapArticle(row) {
        return new ntnv_models_1.Article(row.id, row.title, row.rating, row.text, row.created_at, row.updated_at, row.novel_id, undefined, undefined);
    }
    static mapArticleHeader(row) {
        return new ntnv_models_1.ArticleHeader(row.id, row.title, row.rating, row.created_at, row.updated_at, undefined);
    }
    static mapNovel(row) {
        return new ntnv_models_1.Novel(row.id, row.title, row.author, row.story, row.url);
    }
    static mapTag(row) {
        return new ntnv_models_1.Tag(row.id, row.name, row.category, row.subcategory, 1);
    }
    static buildArticleQuery(articleId) {
        return {
            text: `
          SELECT id, title, rating, text, created_at, updated_at, novel_id
          FROM articles 
          WHERE id = $1;`,
            values: [articleId]
        };
    }
    static buildArticleHeadersQuery(articlesPerPage, page, sortKey) {
        return {
            text: `
          SELECT id, title, rating, created_at, updated_at
          FROM articles 
          ORDER BY ${sortKey} DESC
          OFFSET $1 LIMIT $2;`,
            values: [
                articlesPerPage * (page - 1),
                articlesPerPage
            ]
        };
    }
    static buildNovelQuery(novelId) {
        return {
            text: `
        SELECT id, title, author, story, url
        FROM novels 
        WHERE id = $1;`,
            values: [novelId]
        };
    }
    static buildArticleTagsQuery(articleId) {
        return {
            text: `
          SELECT t.id AS "id", t.name AS "name", c.name AS "category", sc.name AS "subcategory"
          FROM (
            SELECT tag_id
            FROM articles_tags
            WHERE article_id = $1
          ) AS at
          JOIN tags AS t ON t.id = at.tag_id
          JOIN tag_categories AS c ON c.id = t.tag_category_id
          JOIN tag_subcategories AS sc ON sc.id = t.tag_subcategory_id`,
            values: [
                articleId
            ]
        };
    }
    static buildTagsQuery(keywords) {
        return {
            text: `
          SELECT t.id AS "id", t.name AS "name", c.name AS "category", sc.name AS "subcategory"
          FROM (
            SELECT id, name, tag_category_id, tag_subcategory_id
            FROM tags
            WHERE name = ANY($1)
          ) AS t
          JOIN tag_categories AS c ON c.id = t.tag_category_id
          JOIN tag_subcategories AS sc ON sc.id = t.tag_subcategory_id
        `,
            values: [
                keywords
            ]
        };
    }
    static buildTaggedArticleHeadersQuery(tagIds, articlesPerPage, page, sortKey) {
        return {
            text: `
          SELECT id, title, rating, created_at, updated_at
          FROM articles AS a
          WHERE $1 = (
            SELECT COUNT(at.id)
            FROM articles_tags AS at
            WHERE a.id = at.article_id
            AND at.tag_id = ANY($2)
          )
          ORDER BY ${sortKey} DESC
          OFFSET $3 LIMIT $4;`,
            values: [
                tagIds.length,
                tagIds,
                articlesPerPage * (page - 1),
                articlesPerPage
            ]
        };
    }
}
exports.default = NtnvDataStore;
//# sourceMappingURL=NtnvDataStore.js.map