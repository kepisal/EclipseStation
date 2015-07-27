--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: add_article(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_article(author text, title text, content text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
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
END $_$;


ALTER FUNCTION public.add_article(author text, title text, content text) OWNER TO postgres;

--
-- Name: bol_search_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bol_search_id(i integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE found_id INTEGER;
BEGIN
 SELECT id INTO found_id FROM tbarticle where id=i;
 IF found_id ISNULL THEN
	RETURN false;
 ELSE RETURN true;
 END if;

END
$$;


ALTER FUNCTION public.bol_search_id(i integer) OWNER TO postgres;

--
-- Name: delete_article(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delete_article(i integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
   delete from tbarticle where id =i;

   IF FOUND THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END
$$;


ALTER FUNCTION public.delete_article(i integer) OWNER TO postgres;

--
-- Name: last_record(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION last_record() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE last_record INTEGER;
BEGIN
SELECT "id" FIRST_VALUE INTO last_record FROM tbarticle ORDER BY "id" DESC LIMIT 1;
RETURN last_record;
END
$$;


ALTER FUNCTION public.last_record() OWNER TO postgres;

--
-- Name: art_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE art_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.art_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: tbarticle; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbarticle (
    id integer DEFAULT nextval('art_id_seq'::regclass) NOT NULL,
    author text NOT NULL,
    title text NOT NULL,
    content text,
    published_date text
);


ALTER TABLE public.tbarticle OWNER TO postgres;

--
-- Name: next_page(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION next_page(r integer, o integer) RETURNS SETOF tbarticle
    LANGUAGE sql
    AS $_$

SELECT * FROM tbarticle LIMIT $1 OFFSET $2;
-- RETURN $add;

$_$;


ALTER FUNCTION public.next_page(r integer, o integer) OWNER TO postgres;

--
-- Name: search_by_author(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION search_by_author(au character varying) RETURNS SETOF tbarticle
    LANGUAGE sql
    AS $_$ SELECT
	*
FROM
	tbarticle
WHERE
	author LIKE UPPER ($1) || '%'
OR author LIKE "lower" ($1) || '%'
ORDER BY
	ID ASC ; -- RETURN $add;
	$_$;


ALTER FUNCTION public.search_by_author(au character varying) OWNER TO postgres;

--
-- Name: search_by_author(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION search_by_author(au text, ro integer, of integer) RETURNS SETOF tbarticle
    LANGUAGE sql
    AS $_$ 
SELECT
	*
FROM
	tbarticle
WHERE
	author LIKE UPPER ($1) || '%'
OR author LIKE "lower" ($1) || '%'
ORDER BY
	ID ASC LIMIT $2 OFFSET $3 ; -- RETURN $add;
	$_$;


ALTER FUNCTION public.search_by_author(au text, ro integer, of integer) OWNER TO postgres;

--
-- Name: search_by_content(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION search_by_content(con character varying) RETURNS SETOF tbarticle
    LANGUAGE sql
    AS $_$ SELECT
	*
FROM
	tbarticle
WHERE
	CONTENT LIKE '%' || "upper" ($1) || '%'
OR CONTENT LIKE '%' || "upper" ($1) || '%'
ORDER BY
	ID ASC ; -- RETURN $add;
	$_$;


ALTER FUNCTION public.search_by_content(con character varying) OWNER TO postgres;

--
-- Name: search_by_content(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION search_by_content(con text, ro integer, of integer) RETURNS SETOF tbarticle
    LANGUAGE sql
    AS $_$ 
SELECT
	*
FROM
	tbarticle
WHERE
	CONTENT LIKE '%' || "upper" ($1) || '%'
OR CONTENT LIKE '%' || "upper" ($1) || '%'
ORDER BY
	ID ASC LIMIT $2 OFFSET $3; -- RETURN $add;
	$_$;


ALTER FUNCTION public.search_by_content(con text, ro integer, of integer) OWNER TO postgres;

--
-- Name: search_by_title(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION search_by_title(ti character varying) RETURNS SETOF tbarticle
    LANGUAGE sql
    AS $_$

SELECT
	*
FROM
	tbarticle
WHERE
	title LIKE "upper" ($1) || '%'
OR title LIKE "lower" ($1) || '%'
ORDER BY
	ID ASC ;
-- RETURN $add;

$_$;


ALTER FUNCTION public.search_by_title(ti character varying) OWNER TO postgres;

--
-- Name: search_by_title(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION search_by_title(ti text, ro integer, of integer) RETURNS SETOF tbarticle
    LANGUAGE sql
    AS $_$

SELECT
	*
FROM
	tbarticle
WHERE
	title LIKE "upper" ($1) || '%'
OR title LIKE "lower" ($1) || '%'
ORDER BY
	ID ASC LIMIT $2 OFFSET $3;
-- RETURN $add;

$_$;


ALTER FUNCTION public.search_by_title(ti text, ro integer, of integer) OWNER TO postgres;

--
-- Name: search_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION search_id(i integer) RETURNS SETOF tbarticle
    LANGUAGE sql
    AS $_$

SELECT * FROM tbarticle WHERE id=$1;
-- RETURN $add;

$_$;


ALTER FUNCTION public.search_id(i integer) OWNER TO postgres;

--
-- Name: set_row(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION set_row(r integer) RETURNS SETOF tbarticle
    LANGUAGE sql
    AS $_$

SELECT * FROM tbarticle LIMIT $1;
-- RETURN $add;

$_$;


ALTER FUNCTION public.set_row(r integer) OWNER TO postgres;

--
-- Name: set_row(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION set_row(ro integer, pa integer) RETURNS SETOF tbarticle
    LANGUAGE sql
    AS $_$

SELECT * FROM tbarticle ORDER BY "id" ASC LIMIT $1 OFFSET $2;
-- RETURN $add;

$_$;


ALTER FUNCTION public.set_row(ro integer, pa integer) OWNER TO postgres;

--
-- Name: sort_id(integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sort_id(r integer, isasc boolean) RETURNS SETOF tbarticle
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
IF isAsc = TRUE THEN
	RETURN QUERY 
	SELECT * FROM tbarticle ORDER BY id ASC LIMIT r; 
ELSE 
	RETURN QUERY
	SELECT * FROM tbarticle ORDER BY id DESC LIMIT r; 
END IF; 
END $$;


ALTER FUNCTION public.sort_id(r integer, isasc boolean) OWNER TO postgres;

--
-- Name: sort_title(integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sort_title(r integer, isasc boolean) RETURNS SETOF tbarticle
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
IF isAsc = TRUE THEN 
RETURN QUERY 
	SELECT * FROM tbarticle ORDER BY title ASC LIMIT r; 
ELSE 
RETURN QUERY 
	SELECT * FROM tbarticle ORDER BY title DESC LIMIT r;
END IF; 
END $$;


ALTER FUNCTION public.sort_title(r integer, isasc boolean) OWNER TO postgres;

--
-- Name: tg_on_add(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tg_on_add() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO tbarticle_audit_on_insert(art_id,modified_date) VALUES (new.ID, to_char(
	now(),
	'YYYY-MM-DD HH24:MI:SS'));

	RETURN NEW;
END
$$;


ALTER FUNCTION public.tg_on_add() OWNER TO postgres;

--
-- Name: tg_on_delete(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tg_on_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO tbarticle_audit_on_delete(art_id,modified_date) VALUES (OLD.ID, to_char(
	now(),
	'YYYY-MM-DD HH24:MI:SS'));

	RETURN OLD;
END
$$;


ALTER FUNCTION public.tg_on_delete() OWNER TO postgres;

--
-- Name: tg_on_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tg_on_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
END $$;


ALTER FUNCTION public.tg_on_update() OWNER TO postgres;

--
-- Name: total_record(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION total_record() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE total INTEGER;
BEGIN
	SELECT count(*) INTO total FROM tbarticle;
	RETURN total;
END;
$$;


ALTER FUNCTION public.total_record() OWNER TO postgres;

--
-- Name: update_article(integer, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_article(i integer, au text, ti text, con text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
END $$;


ALTER FUNCTION public.update_article(i integer, au text, ti text, con text) OWNER TO postgres;

--
-- Name: update_article_author(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_article_author(i integer, au text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
END $$;


ALTER FUNCTION public.update_article_author(i integer, au text) OWNER TO postgres;

--
-- Name: update_article_content(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_article_content(i integer, con text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
END $$;


ALTER FUNCTION public.update_article_content(i integer, con text) OWNER TO postgres;

--
-- Name: update_article_title(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_article_title(i integer, ti text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
END $$;


ALTER FUNCTION public.update_article_title(i integer, ti text) OWNER TO postgres;

--
-- Name: delete_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE delete_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.delete_id_seq OWNER TO postgres;

--
-- Name: insert_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE insert_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insert_id_seq OWNER TO postgres;

--
-- Name: tbarticle_audit_on_delete; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbarticle_audit_on_delete (
    id integer DEFAULT nextval('delete_id_seq'::regclass),
    art_id integer NOT NULL,
    modified_date text NOT NULL
);


ALTER TABLE public.tbarticle_audit_on_delete OWNER TO postgres;

--
-- Name: tbarticle_audit_on_insert; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbarticle_audit_on_insert (
    id integer DEFAULT nextval('insert_id_seq'::regclass),
    art_id integer NOT NULL,
    modified_date text NOT NULL
);


ALTER TABLE public.tbarticle_audit_on_insert OWNER TO postgres;

--
-- Name: update_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE update_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.update_id_seq OWNER TO postgres;

--
-- Name: tbarticle_audit_on_update; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbarticle_audit_on_update (
    id integer DEFAULT nextval('update_id_seq'::regclass),
    art_id integer NOT NULL,
    title text,
    author text,
    content text,
    modified_date text NOT NULL
);


ALTER TABLE public.tbarticle_audit_on_update OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- Name: tbuser; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbuser (
    id integer DEFAULT nextval('user_id_seq'::regclass) NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    password text NOT NULL
);


ALTER TABLE public.tbuser OWNER TO postgres;

--
-- Name: vw_short_by_author_asc; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_short_by_author_asc AS
    SELECT tbarticle.id, tbarticle.author, tbarticle.title, tbarticle.content, tbarticle.published_date FROM tbarticle ORDER BY tbarticle.author;


ALTER TABLE public.vw_short_by_author_asc OWNER TO postgres;

--
-- Name: vw_short_by_author_desc; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_short_by_author_desc AS
    SELECT tbarticle.id, tbarticle.author, tbarticle.title, tbarticle.content, tbarticle.published_date FROM tbarticle ORDER BY tbarticle.author DESC;


ALTER TABLE public.vw_short_by_author_desc OWNER TO postgres;

--
-- Name: vw_short_by_content_asc; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_short_by_content_asc AS
    SELECT tbarticle.id, tbarticle.author, tbarticle.title, tbarticle.content, tbarticle.published_date FROM tbarticle ORDER BY tbarticle.content;


ALTER TABLE public.vw_short_by_content_asc OWNER TO postgres;

--
-- Name: vw_short_by_content_desc; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_short_by_content_desc AS
    SELECT tbarticle.id, tbarticle.author, tbarticle.title, tbarticle.content, tbarticle.published_date FROM tbarticle ORDER BY tbarticle.content DESC;


ALTER TABLE public.vw_short_by_content_desc OWNER TO postgres;

--
-- Name: vw_short_by_title_asc; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_short_by_title_asc AS
    SELECT tbarticle.id, tbarticle.author, tbarticle.title, tbarticle.content, tbarticle.published_date FROM tbarticle ORDER BY tbarticle.title;


ALTER TABLE public.vw_short_by_title_asc OWNER TO postgres;

--
-- Name: vw_short_by_title_desc; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_short_by_title_desc AS
    SELECT tbarticle.id, tbarticle.author, tbarticle.title, tbarticle.content, tbarticle.published_date FROM tbarticle ORDER BY tbarticle.title DESC;


ALTER TABLE public.vw_short_by_title_desc OWNER TO postgres;

--
-- Name: vw_show; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_show AS
    SELECT tbarticle.id, tbarticle.author, tbarticle.title, tbarticle.content, tbarticle.published_date FROM tbarticle;


ALTER TABLE public.vw_show OWNER TO postgres;

--
-- Name: vw_show_by_id; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_show_by_id AS
    SELECT tbarticle.id, tbarticle.author, tbarticle.title, tbarticle.content, tbarticle.published_date FROM tbarticle ORDER BY tbarticle.id;


ALTER TABLE public.vw_show_by_id OWNER TO postgres;

--
-- Name: vw_show_by_id_dsc; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW vw_show_by_id_dsc AS
    SELECT tbarticle.id, tbarticle.author, tbarticle.title, tbarticle.content, tbarticle.published_date FROM tbarticle ORDER BY tbarticle.id DESC;


ALTER TABLE public.vw_show_by_id_dsc OWNER TO postgres;

--
-- Name: art_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('art_id_seq', 0, true);


--
-- Name: delete_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('delete_id_seq', 1, false);


--
-- Name: insert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('insert_id_seq', 1, false);


--
-- Data for Name: tbarticle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tbarticle (id, author, title, content, published_date) FROM stdin;
\.


--
-- Data for Name: tbarticle_audit_on_delete; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tbarticle_audit_on_delete (id, art_id, modified_date) FROM stdin;
\.


--
-- Data for Name: tbarticle_audit_on_insert; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tbarticle_audit_on_insert (id, art_id, modified_date) FROM stdin;
\.


--
-- Data for Name: tbarticle_audit_on_update; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tbarticle_audit_on_update (id, art_id, title, author, content, modified_date) FROM stdin;
\.


--
-- Data for Name: tbuser; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tbuser (id, username, email, password) FROM stdin;
1	admin	admin@hrd.com	12345678
\.


--
-- Name: update_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('update_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_id_seq', 1, true);


--
-- Name: tbarticle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbarticle
    ADD CONSTRAINT tbarticle_pkey PRIMARY KEY (id);


--
-- Name: tbuser_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbuser
    ADD CONSTRAINT tbuser_pkey PRIMARY KEY (id);


--
-- Name: log_add; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER log_add AFTER INSERT ON tbarticle FOR EACH ROW EXECUTE PROCEDURE tg_on_add();


--
-- Name: log_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER log_delete AFTER DELETE ON tbarticle FOR EACH ROW EXECUTE PROCEDURE tg_on_delete();


--
-- Name: log_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER log_update AFTER UPDATE ON tbarticle FOR EACH ROW EXECUTE PROCEDURE tg_on_update();


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

