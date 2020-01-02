"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const NtnvDataStore_1 = require("./NtnvDataStore");
const express = require('express');
class NtnvAPI {
    constructor(connectionString) {
        this.connectionString = connectionString;
        this.dataStore = new NtnvDataStore_1.default(connectionString);
        this.app = express();
        this.app.use(this.allowCros);
        this.app.get('/tags/:keywords', this.searchArticleHeadersByTags.bind(this));
        this.app.get('/articles', this.getArticleHeaders.bind(this));
        this.app.get('/', this.getArticleHeaders.bind(this));
        this.app.get('/article/:id(\\d+)', this.getArticle.bind(this));
        this.app.use(this.errorHandler.bind(this));
    }
    listen(port) {
        this.app.listen(port, () => {
            console.log(`NtnvAPI listening on port ${port}`);
        });
    }
    allowCros(req, res, next) {
        res.header('Access-Control-Allow-Origin', '*');
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        next();
    }
    async getArticleHeaders(req, res, next) {
        try {
            const articlesPerPage = 10;
            const page = Number(req.query.page || 1);
            const sortKey = req.query.order || 'updated_at';
            const headers = await this.dataStore.getArticleHeaders(articlesPerPage, page, sortKey);
            res.json(headers);
        }
        catch (err) {
            next(err);
        }
    }
    async getArticle(req, res, next) {
        try {
            const id = Number(req.params.id);
            const article = await this.dataStore.getArticle(id);
            res.json(article);
        }
        catch (err) {
            next(err);
        }
    }
    async searchArticleHeadersByTags(req, res, next) {
        try {
            const keywords = req.params.keywords.split('+');
            const articlesPerPage = 10;
            const page = Number(req.query.page || 1);
            const sortKey = req.query.order || 'updated_at';
            const tags = await this.dataStore.searchTags(keywords);
            const headers = await this.dataStore.searchArticleHeadersByTagIds(tags.map((tag) => tag.id), articlesPerPage, page, sortKey);
            res.json(headers);
        }
        catch (err) {
            next(err);
        }
    }
    errorHandler(err, req, res, next) {
        res.status(500).json({
            error: {
                message: '不正なリクエスト',
            }
        });
    }
}
exports.default = NtnvAPI;
//# sourceMappingURL=NtnvAPI.js.map