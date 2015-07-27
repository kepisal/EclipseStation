/*
Navicat PGSQL Data Transfer

Source Server         : dbnorthwind
Source Server Version : 90303
Source Host           : localhost:5432
Source Database       : dbarticle
Source Schema         : public

Target Server Type    : PGSQL
Target Server Version : 90303
File Encoding         : 65001

Date: 2015-07-03 13:33:50
*/

-- ----------------------------
-- Sequence structure for user_id_seq
-- ----------------------------
CREATE SEQUENCE "user_id_seq"
 INCREMENT 1
 MINVALUE 0
 MAXVALUE 9223372036854775807
 START 0
 CACHE 1;
SELECT setval('"public"."user_id_seq"', 0, true);

-- ----------------------------
-- Table structure for tbuser
-- ----------------------------
CREATE TABLE "tbuser" (
"id" int4 DEFAULT nextval('user_id_seq'::regclass) NOT NULL,
"username" text COLLATE "default" NOT NULL,
"email" text COLLATE "default" NOT NULL,
"password" text COLLATE "default" NOT NULL
)
WITH (OIDS=FALSE)

;
-- ----------------------------
-- Records of tbuser
-- ----------------------------
BEGIN;
	INSERT INTO tbuser(username, email, password) VALUES('admin','admin@hrd.com', '12345678');
COMMIT;

-- ----------------------------
-- Sequence structure for art_id_seq
-- ----------------------------
CREATE SEQUENCE "art_id_seq"
 INCREMENT 1
 MINVALUE 0
 MAXVALUE 9223372036854775807
 START 0
 CACHE 1;
SELECT setval('"public"."art_id_seq"', 0, true);

-- ----------------------------
-- Table structure for tbarticle
-- ----------------------------

CREATE TABLE "tbarticle" (
"id" int4 DEFAULT nextval('art_id_seq'::regclass) NOT NULL,
"author" text COLLATE "default" NOT NULL,
"title" text COLLATE "default" NOT NULL,
"content" text COLLATE "default",
"published_date" text COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of tbarticle
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- View structure for vw_short_by_author_asc
-- ----------------------------
CREATE OR REPLACE VIEW "vw_short_by_author_asc" AS 
 SELECT tbarticle.id,
    tbarticle.author,
    tbarticle.title,
    tbarticle.content,
    tbarticle.published_date
   FROM tbarticle
  ORDER BY tbarticle.author;

-- ----------------------------
-- View structure for vw_short_by_author_desc
-- ----------------------------
CREATE OR REPLACE VIEW "vw_short_by_author_desc" AS 
 SELECT tbarticle.id,
    tbarticle.author,
    tbarticle.title,
    tbarticle.content,
    tbarticle.published_date
   FROM tbarticle
  ORDER BY tbarticle.author DESC;

-- ----------------------------
-- View structure for vw_short_by_content_asc
-- ----------------------------
CREATE OR REPLACE VIEW "vw_short_by_content_asc" AS 
 SELECT tbarticle.id,
    tbarticle.author,
    tbarticle.title,
    tbarticle.content,
    tbarticle.published_date
   FROM tbarticle
  ORDER BY tbarticle.content;

-- ----------------------------
-- View structure for vw_short_by_content_desc
-- ----------------------------
CREATE OR REPLACE VIEW "vw_short_by_content_desc" AS 
 SELECT tbarticle.id,
    tbarticle.author,
    tbarticle.title,
    tbarticle.content,
    tbarticle.published_date
   FROM tbarticle
  ORDER BY tbarticle.content DESC;

-- ----------------------------
-- View structure for vw_short_by_title_asc
-- ----------------------------
CREATE OR REPLACE VIEW "vw_short_by_title_asc" AS 
 SELECT tbarticle.id,
    tbarticle.author,
    tbarticle.title,
    tbarticle.content,
    tbarticle.published_date
   FROM tbarticle
  ORDER BY tbarticle.title;

-- ----------------------------
-- View structure for vw_short_by_title_desc
-- ----------------------------
CREATE OR REPLACE VIEW "vw_short_by_title_desc" AS 
 SELECT tbarticle.id,
    tbarticle.author,
    tbarticle.title,
    tbarticle.content,
    tbarticle.published_date
   FROM tbarticle
  ORDER BY tbarticle.title DESC;

-- ----------------------------
-- View structure for vw_show
-- ----------------------------
CREATE OR REPLACE VIEW "vw_show" AS 
 SELECT tbarticle.id,
    tbarticle.author,
    tbarticle.title,
    tbarticle.content,
    tbarticle.published_date
   FROM tbarticle;

-- ----------------------------
-- View structure for vw_show_by_id
-- ----------------------------
CREATE OR REPLACE VIEW "vw_show_by_id" AS 
 SELECT tbarticle.id,
    tbarticle.author,
    tbarticle.title,
    tbarticle.content,
    tbarticle.published_date
   FROM tbarticle
  ORDER BY tbarticle.id;

-- ----------------------------
-- View structure for vw_show_by_id_dsc
-- ----------------------------
CREATE OR REPLACE VIEW "vw_show_by_id_dsc" AS 
 SELECT tbarticle.id,
    tbarticle.author,
    tbarticle.title,
    tbarticle.content,
    tbarticle.published_date
   FROM tbarticle
  ORDER BY tbarticle.id DESC;

-- ----------------------------
-- Function structure for add_article
-- ----------------------------
CREATE OR REPLACE FUNCTION "add_article"(author text, title text, content text)
  RETURNS "pg_catalog"."void" AS $BODY$
BEGIN
	INSERT INTO tbarticle (
		author,
		title,
		content,
		published_date
	)
VALUES
	(
		author,
		title,
		content,
		to_char(
			now(),
			'YYYY-MM-DD HH24:MI:SS'
		)
	) ; -- RETURN $add;
END $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for delete_article
-- ----------------------------
CREATE OR REPLACE FUNCTION "delete_article"(i int4)
  RETURNS "pg_catalog"."bool" AS $BODY$
BEGIN
   delete from tbarticle where id =i;

   IF FOUND THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for next_page
-- ----------------------------
CREATE OR REPLACE FUNCTION "next_page"(r int4, o int4)
  RETURNS SETOF "public"."tbarticle" AS $BODY$

SELECT * FROM tbarticle LIMIT r OFFSET o;
-- RETURN $add;

$BODY$
  LANGUAGE 'sql' VOLATILE COST 100
 ROWS 1000
;

-- ----------------------------
-- Function structure for search_by_author
-- ----------------------------
CREATE OR REPLACE FUNCTION "search_by_author"(au varchar)
  RETURNS SETOF "public"."tbarticle" AS $BODY$ SELECT
	*
FROM
	tbarticle
WHERE
	author LIKE UPPER (au) || '%'
OR author LIKE "lower" (au) || '%'
ORDER BY
	ID ASC ; -- RETURN $add;
	$BODY$
  LANGUAGE 'sql' VOLATILE COST 100
 ROWS 1000
;

-- ----------------------------
-- Function structure for search_by_content
-- ----------------------------
CREATE OR REPLACE FUNCTION "search_by_content"(con varchar)
  RETURNS SETOF "public"."tbarticle" AS $BODY$ SELECT
	*
FROM
	tbarticle
WHERE
	CONTENT LIKE '%' || "upper" (con) || '%'
OR CONTENT LIKE '%' || "upper" (con) || '%'
ORDER BY
	ID ASC ; -- RETURN $add;
	$BODY$
  LANGUAGE 'sql' VOLATILE COST 100
 ROWS 1000
;

-- ----------------------------
-- Function structure for search_by_title
-- ----------------------------
CREATE OR REPLACE FUNCTION "search_by_title"(ti varchar)
  RETURNS SETOF "public"."tbarticle" AS $BODY$

SELECT
	*
FROM
	tbarticle
WHERE
	title LIKE "upper" (ti) || '%'
OR title LIKE "lower" (ti) || '%'
ORDER BY
	ID ASC ;
-- RETURN $add;

$BODY$
  LANGUAGE 'sql' VOLATILE COST 100
 ROWS 1000
;

-- ----------------------------
-- Function structure for search_id
-- ----------------------------
CREATE OR REPLACE FUNCTION "search_id"(i int4)
  RETURNS SETOF "public"."tbarticle" AS $BODY$

SELECT * FROM tbarticle WHERE id=i;
-- RETURN $add;

$BODY$
  LANGUAGE 'sql' VOLATILE COST 100
 ROWS 1000
;

-- ----------------------------
-- Function structure for set_row
-- ----------------------------
CREATE OR REPLACE FUNCTION "set_row"(r int4)
  RETURNS SETOF "public"."tbarticle" AS $BODY$

SELECT * FROM tbarticle LIMIT r;
-- RETURN $add;

$BODY$
  LANGUAGE 'sql' VOLATILE COST 100
 ROWS 1000
;

-- ----------------------------
-- Function structure for set_row
-- ----------------------------
CREATE OR REPLACE FUNCTION "set_row"(ro int4, pa int4)
  RETURNS SETOF "public"."tbarticle" AS $BODY$

SELECT * FROM tbarticle ORDER BY "id" ASC LIMIT ro OFFSET pa;
-- RETURN $add;

$BODY$
  LANGUAGE 'sql' VOLATILE COST 100
 ROWS 1000
;

-- ----------------------------
-- Function structure for total_record()
-- ----------------------------
CREATE OR REPLACE FUNCTION "total_record"()
  RETURNS "pg_catalog"."int4" AS $BODY$
DECLARE total INTEGER;
BEGIN
	SELECT count(*) INTO total FROM tbarticle;
	RETURN total;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for update_article
-- ----------------------------
CREATE OR REPLACE FUNCTION "update_article"(i int4, au text, ti text, con text)
  RETURNS "pg_catalog"."bool" AS $BODY$
BEGIN
	UPDATE tbarticle
SET author = au,
 title = ti,
 CONTENT = con,
 published_date = to_char(
	now(),
	'YYYY-MM-DD HH24:MI:SS'
)
WHERE
	"id" = i ;
IF FOUND THEN
	RETURN TRUE ;
ELSE
	RETURN FALSE ;
END
IF ;
END $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for update_article_author
-- ----------------------------
CREATE OR REPLACE FUNCTION "update_article_author"(i int4, au text)
  RETURNS "pg_catalog"."bool" AS $BODY$
BEGIN
	UPDATE tbarticle
SET author = au,
 published_date = to_char(
	now(),
	'YYYY-MM-DD HH24:MI:SS'
)
WHERE
	"id" = i ;
IF FOUND THEN
	RETURN TRUE ;
ELSE
	RETURN FALSE ;
END
IF ;
END $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for update_article_content
-- ----------------------------
CREATE OR REPLACE FUNCTION "update_article_content"(i int4, con text)
  RETURNS "pg_catalog"."bool" AS $BODY$
BEGIN
	UPDATE tbarticle
SET 
 content = con,
 published_date = to_char(
	now(),
	'YYYY-MM-DD HH24:MI:SS'
)
WHERE
	"id" = i ;
IF FOUND THEN
	RETURN TRUE ;
ELSE
	RETURN FALSE ;
END
IF ;
END $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for update_article_title
-- ----------------------------
CREATE OR REPLACE FUNCTION "update_article_title"(i int4, ti text)
  RETURNS "pg_catalog"."bool" AS $BODY$
BEGIN
	UPDATE tbarticle
SET 
 title = ti,
 published_date = to_char(
	now(),
	'YYYY-MM-DD HH24:MI:SS'
)
WHERE
	"id" = i;
IF FOUND THEN
	RETURN TRUE ;
ELSE
	RETURN FALSE ;
END
IF ;
END $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table tbarticle
-- ----------------------------
ALTER TABLE "tbarticle" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table tbarticle
-- ----------------------------
ALTER TABLE "tbuser" ADD PRIMARY KEY ("id");

-------------------------------
----- Function Last Record ----
-------------------------------
CREATE OR REPLACE FUNCTION last_record()
RETURNS INTEGER AS $$
DECLARE last_record INTEGER;
BEGIN
SELECT "id" FIRST_VALUE INTO last_record FROM tbarticle ORDER BY "id" DESC LIMIT 1;
RETURN last_record;
END
$$ LANGUAGE plpgsql;

--------------------------------
------- Trigger ----------------
-- Create Sequence
CREATE SEQUENCE insert_id_seq;
CREATE SEQUENCE delete_id_seq;
CREATE SEQUENCE update_id_seq;

-- Create table store for audit
CREATE TABLE tbarticle_audit_on_update(
	id INTEGER DEFAULT nextval('update_id_seq'), 
	art_id INTEGER NOT NULL,
	title TEXT NULL,
	author TEXT NULL,
	CONTENT TEXT null,
	modified_date TEXT NOT null
);

CREATE TABLE tbarticle_audit_on_delete(
	id INTEGER DEFAULT nextval('delete_id_seq'),
	art_id INTEGER NOT NULL,
	modified_date TEXT NOT null
);

CREATE TABLE tbarticle_audit_on_insert(
id INTEGER DEFAULT nextval('insert_id_seq'),
	art_id INTEGER NOT NULL,
		modified_date TEXT not null
);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- Create function return as trigger on add event
CREATE OR REPLACE FUNCTION tg_on_add() 
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO tbarticle_audit_on_insert(art_id,modified_date) VALUES (new.ID, to_char(
	now(),
	'YYYY-MM-DD HH24:MI:SS'));

	RETURN NEW;
END
$$ LANGUAGE plpgsql;

-- Create trigger on add
CREATE TRIGGER log_add AFTER INSERT ON tbarticle FOR EACH ROW EXECUTE PROCEDURE tg_on_add ();
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- Create function return as trigger on DELETE event 

CREATE OR REPLACE FUNCTION tg_on_delete() 
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO tbarticle_audit_on_delete(art_id,modified_date) VALUES (OLD.ID, to_char(
	now(),
	'YYYY-MM-DD HH24:MI:SS'));

	RETURN OLD;
END
$$ LANGUAGE plpgsql;

-- Create trigger on DELETE
CREATE TRIGGER log_delete AFTER DELETE ON tbarticle FOR EACH ROW EXECUTE PROCEDURE tg_on_delete ();

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

-- Create function return as trigger on UPDATE event
CREATE
OR REPLACE FUNCTION tg_on_update () RETURNS TRIGGER AS $$
BEGIN

IF NEW .title = OLD .title THEN
			OLD.title='null';
END IF;
IF NEW .author = OLD .author THEN
			OLD.author ='null';
end IF;
IF NEW . CONTENT = OLD . CONTENT THEN
	OLD.CONTENT='null';
end IF;
	INSERT INTO tbarticle_audit_on_update (
		art_id,
		title,
		author,
		CONTENT,
		modified_date
	)
VALUES
	(
		OLD . ID,
		OLD .title,
		OLD .author,
		OLD . CONTENT,
		to_char(
			now(),
			'YYYY-MM-DD HH24:MI:SS'
		)
	) ; RETURN OLD ;
END $$ LANGUAGE plpgsql;

-- Create trigger on UPDATE
CREATE TRIGGER log_update AFTER UPDATE ON tbarticle FOR EACH ROW EXECUTE PROCEDURE tg_on_update ();

-------------------------------
------ Check Exist Id ---------
-------------------------------
create or REPLACE FUNCTION bol_search_id(i INTEGER)
RETURNS BOOLEAN AS $$
DECLARE found_id INTEGER;
BEGIN
 SELECT id INTO found_id FROM tbarticle where id=i;
 IF found_id ISNULL THEN
	RETURN false;
 ELSE RETURN true;
 END if;

END
$$ LANGUAGE plpgsql; 


 

