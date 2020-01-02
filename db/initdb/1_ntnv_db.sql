-- 更新日時設定関数
CREATE FUNCTION set_update_time() RETURNS trigger AS $$
  BEGIN
    new.updated_at = CURRENT_TIMESTAMP;
    RETURN new;
  END;
$$ LANGUAGE plpgsql;


-- タグ使用記事数の更新
CREATE FUNCTION set_tag_reference_count() RETURNS trigger AS $$
  BEGIN
    UPDATE tags 
    SET article_count = (
      SELECT COUNT(articles_tags.id)
      FROM articles_tags
      WHERE articles_tags.tag_id = new.tag_id
    )
    WHERE tags.id = new.tag_id;

    RETURN new;
  END;
$$ LANGUAGE plpgsql;


-- タグ大分類
CREATE SEQUENCE tag_categories_id_seq MINVALUE 0 START WITH 5;

CREATE TABLE "tag_categories" (
    "id" integer DEFAULT nextval('tag_categories_id_seq') PRIMARY KEY,
    "name" character varying(255) NOT NULL
);

INSERT INTO "tag_categories" ("id", "name") VALUES
(0,	'小説属性'),
(1,	'カテゴリ'),
(2,	'掲載サイト'),
(3,	'原作'),
(4,	'作者');


-- タグ中分類
CREATE SEQUENCE tag_subcategories_id_seq MINVALUE 0  START WITH 10;

CREATE TABLE "tag_subcategories" (
    "id" integer DEFAULT nextval('tag_subcategories_id_seq') PRIMARY KEY,
    "name" character varying(255) NOT NULL
);

INSERT INTO "tag_subcategories" ("id", "name") VALUES
(0,	''),
(1,	'ジャンル'),
(2,	'性向'),
(3,	'主人公属性'),
(4,	'キャラ属性'),
(5,	'時代'),
(6,	'雰囲気'),
(7,	'職業'),
(8,	'舞台'),
(9,	'アビリティ');


-- タグ
CREATE SEQUENCE tags_id_seq MINVALUE 1 START WITH 73;

CREATE TABLE "tags" (
    "id" integer DEFAULT nextval('tags_id_seq') PRIMARY KEY,
    "name" character varying(255) NOT NULL,
    "article_count" integer NOT NULL,
    "tag_category_id" integer NOT NULL REFERENCES "tag_categories" ("id"),
    "tag_subcategory_id" integer NOT NULL REFERENCES "tag_subcategories" ("id")
);

INSERT INTO "tags" ("id", "tag_category_id", "tag_subcategory_id", "article_count", "name") VALUES
( 1, 1, 0, 0, 'オリジナル'),
( 2, 1, 0, 0, '二次創作'),
( 3, 1, 0, 0, 'やる夫スレ'),
( 4, 1, 0, 0, '書籍'),
( 5, 2, 0, 0, '小説家になろう'),
( 6, 2, 0, 0, 'カクヨム'),
( 7, 2, 0, 0, 'Arcadia'),
( 8, 2, 0, 0, 'ハーメルン'),
( 9, 2, 0, 0, '暁'),
(10, 3, 0, 0, 'ゼロの使い魔'),
(11, 3, 0, 0, '銀河英雄伝説'),
(12, 4, 0, 0, 'そる'),
(13, 4, 0, 0, '理不尽な孫の手'),
(14, 4, 0, 0, '大橋和代'),
(15, 4, 0, 0, '棒の人'),
(16, 4, 0, 0, 'azuraiiru'),
(17, 4, 0, 0, '蝸牛くも'),
(18, 4, 0, 0, 'ばくだんいわ'),
(19, 4, 0, 0, '語り人'),
(20, 4, 0, 0, '茅田砂胡'),
(21, 4, 0, 0, '伊達将範'),
(22, 4, 0, 0, '川上稔'),
(23, 0, 2, 0, 'ボイーズラブ'),
(24, 0, 2, 0, 'ガールズラブ'),
(25, 0, 2, 0, 'TS'),
(26, 0, 3, 0, '転移'),
(27, 0, 3, 0, '転生'),
(28, 0, 3, 0, '憑依'),
(29, 0, 3, 0, '逆行'),
(30, 0, 3, 0, 'オリ主'),
(31, 0, 3, 0, '女主人公'),
(32, 0, 4, 0, 'オリジナルキャラ'),
(33, 0, 4, 0, 'ヤンデレ'),
(34, 0, 5, 0, '古代'),
(35, 0, 5, 0, '中世'),
(36, 0, 5, 0, '戦国'),
(37, 0, 5, 0, '近世'),
(38, 0, 5, 0, '現代'),
(39, 0, 5, 0, '未来'),
(40, 0, 6, 0, 'ダーク'),
(41, 0, 6, 0, 'シリアス'),
(42, 0, 6, 0, 'ほのぼの'),
(43, 0, 6, 0, 'コメディ'),
(44, 0, 1, 0, 'ファンタジー'),
(45, 0, 1, 0, 'SF'),
(46, 0, 1, 0, '歴史・時代'),
(47, 0, 1, 0, 'ミステリー'),
(48, 0, 1, 0, '恋愛'),
(49, 0, 1, 0, 'ホラー'),
(50, 0, 1, 0, 'エッセイ'),
(51, 0, 7, 0, '軍人'),
(52, 0, 7, 0, '海賊'),
(53, 0, 7, 0, '商人'),
(54, 0, 7, 0, '領主'),
(55, 0, 7, 0, '国王'),
(56, 0, 7, 0, '勇者'),
(57, 0, 7, 0, '魔王'),
(58, 0, 7, 0, '冒険者'),
(59, 0, 7, 0, '人外'),
(60, 0, 8, 0, '異世界'),
(61, 0, 8, 0, '学園'),
(62, 0, 8, 0, '西洋'),
(63, 0, 8, 0, '中華'),
(64, 0, 8, 0, '和風'),
(65, 0, 8, 0, '中東'),
(66, 0, 8, 0, '宇宙'),
(67, 0, 8, 0, 'ゲーム'),
(68, 0, 9, 0, '魔法'),
(69, 0, 9, 0, '超能力'),
(70, 0, 9, 0, 'ロボット'),
(71, 0, 9, 0, '知識'),
(72, 0, 9, 0, '武術');

-- 小説
CREATE SEQUENCE novels_id_seq MINVALUE 1 START WITH 13;

CREATE TABLE "novels" (
    "id" integer DEFAULT nextval('novels_id_seq') PRIMARY KEY,
    "title" character varying(255) NOT NULL,
    "author" character varying(255) NOT NULL,
    "story" text NOT NULL,
    "url" character varying(1023) NOT NULL
);

INSERT INTO "novels" ("id", "title", "author", "story", "url") VALUES
(1, '腕白関白', 'そる', E'朝起きたら戦国時代！　しかし農民。このまま農業で一生を終えるのもよいと思っていたら、なんと叔父が秀吉だった！\n史実で殺生関白と呼ばれた豊臣秀次、切腹回避のために今、戦国時代を駆け抜ける！', 'http://www.mai-net.net/bbs/sst/sst.php?act=dump&cate=original&all=4384'),
(2, '無職転生', '理不尽な孫の手', E'３４歳職歴無し住所不定無職童貞のニートは、ある日家を追い出され、人生を後悔している間にトラックに轢かれて死んでしまう。目覚めた時、彼は赤ん坊になっていた。どうやら異世界に転生したらしい。\n　彼は誓う、今度こそ本気だして後悔しない人生を送ると。', 'https://ncode.syosetu.com/n9669bk/'),
(3, 'シャルパンティエの雑貨屋さん', '大橋和代', E'「今日はジネットが店番かい？」「もうすぐ一人立ちしますから、最後のおつとめですよ」　500年続く雑貨屋の娘ジネットは、兄が手に入れてきた何処の物とも知れない営業許可証を手に旅立った。船に乗り馬車に乗り、辿り着いたその先で待っていたのは……。', 'https://ncode.syosetu.com/n4124bs/'),
(4, 'ハルケギニア南船北竜', '棒の人', E'有り体に言えば、現世での記憶を持ったままハルケギニアに転生した主人公が、あっちこっちでどたばたする物語です\nヒロインは多分きっとカトレアお嬢さまの予定です', 'http://bounohito.blog77.fc2.com/blog-entry-54.html'),
(5, 'ハルケギニア茨道霧中', '棒の人', E'有り体に言えば、現世での記憶を持ったままハルケギニアに転生した主人公が、あっちこっちでどたばたする物語です\nこちらは　ハルケギニア南船北竜　の続編になります', 'http://bounohito.blog77.fc2.com/blog-entry-165.html'),
(6, '銀河英雄伝説～新たなる潮流', 'azuraiiru', E'気がついたら銀河英雄伝説の世界に。これは夢、それとも現実？。', 'https://www.akatsuki-novels.com/stories/index/novel_id~103'),
(7, 'ゴブリンスレイヤー', '蝸牛くも', E'ゴブリンに村を滅ぼされた若者が、魔王とか邪神とか悪竜とか巨人とか一切ガン無視して、ひたすら無限にPOPしてくる小鬼を駆逐し続けるお話。', 'https://yaruok.blog.fc2.com/blog-entry-4317.html#more'),
(8, 'やる夫は狂えるオーク戦士であるようです', 'ばくだんいわ', E'三代国王の放蕩と悪政により混乱するヴィップ王国。人々は海賊ジャック・スパロウの元に集い反乱軍を結成し、王国が派遣した討伐軍と戦いを繰り広げている。全ての種族を平等に扱うスパロウ船長の船にはオークの戦士やる夫もいた。', 'https://yaruok.blog.fc2.com/blog-category-139.html'),
(9, '国際的な小咄', '語り人', E'世界各国に友人のいるやる夫による、友人たちとのエピソードや、彼等の母国を紹介するスレ。', 'https://yaruonichijou.blog.fc2.com/blog-entry-8977.html'),
(10, 'デルフィニア戦記', '茅田砂胡', E'男は剣を揮っていた。黒髪は乱れ日に灼けた逞しい長身のあちこちに返り血が飛んでいる。孤立無援の男が今まさに凶刃に倒れようとしたその時、助太刀を申し出たのは十二、三と見える少年であった…。二人の孤独な戦士の邂逅が、一国を、そして大陸全土の運命を変えていく―。', ''),
(11, 'DADDYFACE', '伊達将範', E'孤児院育ちの貧乏大学生である草刈鷲士、彼のつましい暮らしは実の娘を自称する美少女・美沙が現れた事により一変した。その美沙はトレジャーハンターとして活躍しており、鷲士は事件に巻き込まれ、世界中を引きずり回されるのだった。', ''),
(12, '終わりのクロニクル', '川上稔', E'かつて世界は、平行して存在する10個の異世界と戦闘を繰り広げていた。概念戦争と呼ばれるその戦争に勝利してから60年。全てが隠蔽され、一般の人々に知られることなく時が過ぎた現在…。高校生の佐山御言は祖父の死後、突然巨大企業IAIより呼び出しを受ける。そして、この世界がマイナス概念の加速により滅びの方向へ進みつつあること。それを防ぐには、各異世界の生き残り達と交渉し、彼らが持つ10個の概念を解放しなければならないことを伝えられる。かくして、佐山は多くの遺恨を残した概念戦争の戦後処理として、最後の闘いに巻き込まれていくが…。', '');

-- 記事
CREATE SEQUENCE articles_id_seq MINVALUE 1 START WITH 13;

CREATE TABLE "articles" (
    "id" integer DEFAULT nextval('articles_id_seq') PRIMARY KEY,
    "rating" real NOT NULL,
    "title" character varying(255) NOT NULL,
    "text" text NOT NULL,
    "created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updated_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "novel_id" integer NOT NULL REFERENCES "novels" ("id")
);

CREATE TRIGGER "article_headers_bu" BEFORE UPDATE ON "public"."articles" FOR EACH ROW EXECUTE FUNCTION set_update_time();

INSERT INTO "articles" ("id", "novel_id", "rating", "title", "text") VALUES
( 1,  1,   5, '腕白関白', ''),
( 2,  2,   5, '無職転生', ''),
( 3,  3, 3.5, 'シャルパンティエの雑貨屋さん', ''),
( 4,  4,   5, 'ハルケギニア南船北竜', ''),
( 5,  5, 4.5, 'ハルケギニア茨道霧中', ''),
( 6,  6, 4.5, '銀河英雄伝説～新たなる潮流', ''),
( 7,  7,   5, 'ゴブリンスレイヤー', ''),
( 8,  8,   5, 'やる夫は狂えるオーク戦士であるようです', ''),
( 9,  9,   5, '国際的な小咄', ''),
(10, 10, 4.5, 'デルフィニア戦記', ''),
(11, 11,   4, 'DADDYFACE', ''),
(12, 12,   4, '終わりのクロニクル', '');

-- 記事タグ
CREATE SEQUENCE articles_tags_id_seq MINVALUE 1 START WITH 111;

CREATE TABLE "public"."articles_tags" (
    "id" integer DEFAULT nextval('articles_tags_id_seq') PRIMARY KEY,
    "article_id" integer NOT NULL REFERENCES "articles" ("id"),
    "tag_id" integer NOT NULL REFERENCES "tags" ("id")
);

CREATE TRIGGER "articles_tags_bi"
AFTER INSERT ON "articles_tags"
FOR EACH ROW EXECUTE FUNCTION set_tag_reference_count();

INSERT INTO "articles_tags" ("id", "article_id", "tag_id") VALUES
( 1,  1,  1),
( 2,  1,  7),
( 3,  1, 12),
( 4,  1, 27),
( 5,  1, 29),
( 6,  1, 36),
( 7,  1, 46),
( 8,  1, 64),
( 9,  1, 71),
(10,  2,  1),
(11,  2,  5),
(12,  2, 13),
(13,  2, 27),
(14,  2, 43),
(15,  2, 41),
(16,  2, 44),
(17,  2, 58),
(18,  2, 68),
(19, 3, 1),
(20, 3, 5),
(21, 3, 14),
(22, 3, 31),
(23, 3, 42),
(24, 3, 44),
(25, 3, 48),
(26, 3, 53),
(27, 3, 54),
(28, 3, 60),
(29, 4, 2),
(30, 4, 10),
(31, 4, 15),
(32, 4, 14),
(33, 4, 27),
(34, 4, 42),
(35, 4, 41),
(36, 4, 44),
(37, 4, 48),
(38, 4, 53),
(39, 4, 54),
(40, 4, 60),
(41, 4, 68),
(42, 4, 71),
(43, 5, 2),
(44, 5, 10),
(45, 5, 15),
(46, 5, 14),
(47, 5, 27),
(48, 5, 42),
(49, 5, 41),
(50, 5, 44),
(51, 5, 54),
(52, 5, 55),
(53, 5, 60),
(54, 5, 68),
(55, 5, 71),
(56, 6, 2),
(57, 6, 11),
(58, 6, 16),
(59, 6, 27),
(60, 6, 41),
(61, 6, 45),
(62, 6, 51),
(63, 6, 66),
(64, 6, 71),
(65, 7, 3),
(66, 7, 17),
(67, 7, 40),
(68, 7, 41),
(69, 7, 58),
(70, 7, 60),
(71, 7, 71),
(72, 7, 68),
(73, 8, 3),
(74, 8, 18),
(75, 8, 41),
(76, 8, 42),
(77, 8, 44),
(78, 8, 52),
(79, 8, 59),
(80, 8, 60),
(81, 8, 72),
(82, 8, 68),
(83, 9, 3),
(84, 9, 19),
(85, 9, 38),
(86, 9, 50),
(87, 9, 71),
(88, 10, 4),
(89, 10, 20),
(90, 10, 26),
(91, 10, 35),
(92, 10, 41),
(93, 10, 44),
(94, 10, 55),
(95, 10, 60),
(96, 10, 72),
(97, 11, 4),
(98, 11, 21),
(99, 11, 38),
(100, 11, 42),
(101, 11, 41),
(102, 11, 45),
(103, 11, 72),
(104, 11, 69),
(105, 12, 4),
(106, 12, 22),
(107, 12, 38),
(108, 12, 43),
(109, 12, 41),
(110, 12, 45);