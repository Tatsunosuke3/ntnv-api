import { Application, Request, Response, NextFunction } from 'express';
import INtnvDataStore, { ColumnName } from './INtnvDataStore';
import NtnvDataStore from './NtnvDataStore';

const express = require('express');

export default class NtnvAPI {
  private app: Application;
  private dataStore: INtnvDataStore;
  
  constructor(public connectionString: string) {
    this.dataStore = new NtnvDataStore(connectionString);
    
    this.app = express();
    this.app.use(this.allowCros);
    
    this.app.get('/tags/:keywords', this.searchArticleHeadersByTags.bind(this));
    
    this.app.get('/articles', this.getArticleHeaders.bind(this));
    this.app.get('/', this.getArticleHeaders.bind(this));
    
    this.app.get('/article/:id(\\d+)', this.getArticle.bind(this));

    this.app.use(this.errorHandler.bind(this));
  }
  
  listen(port: number) {
    this.app.listen(port, () => {
      console.log(`NtnvAPI listening on port ${port}`)
    });
  }
  
  private allowCros(req: Request, res: Response, next: NextFunction) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  }
  
  private async getArticleHeaders(req: Request, res: Response, next: NextFunction) {
    try {
      const articlesPerPage = 10;
      const page = Number(req.query.page || 1);
      const sortKey = req.query.order as ColumnName || 'updated_at';
    
      const headers = await this.dataStore.getArticleHeaders(articlesPerPage, page, sortKey);
      res.json(headers);
    } catch (err) {
      next(err);
    }
  }
  
  private async getArticle(req: Request, res: Response, next: NextFunction) {
    try {
      const id = Number(req.params.id);
      const article = await this.dataStore.getArticle(id);
      res.json(article);
      
    } catch(err) {
      next(err);
    }
  }
  
  private async searchArticleHeadersByTags(req: Request, res: Response, next: NextFunction) {
    try {
      const keywords = req.params.keywords.split('+');
      const articlesPerPage = 10;
      const page = Number(req.query.page || 1);
      const sortKey = req.query.order as ColumnName || 'updated_at';
      
      const tags = await this.dataStore.searchTags(keywords);
      const headers = await this.dataStore.searchArticleHeadersByTagIds(
        tags.map((tag) => tag.id), 
        articlesPerPage,
        page,
        sortKey
      );
      res.json(headers);
    } catch(err) {
      next(err);
    }
  }

  private errorHandler(err: any, req: Request, res: Response, next: NextFunction) {
    res.status(500).json({
      error: {
        message: '不正なリクエスト',
      }
    });
  }
}

