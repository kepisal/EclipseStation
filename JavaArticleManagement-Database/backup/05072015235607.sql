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

SELECT pg_catalog.setval('art_id_seq', 100, true);


--
-- Name: delete_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('delete_id_seq', 1, false);


--
-- Name: insert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('insert_id_seq', 100, true);


--
-- Data for Name: tbarticle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tbarticle (id, author, title, content, published_date) FROM stdin;
1	consequat purus. Maecenas	molestie arcu. Sed eu nibh	lobortis ultrices. Vivamus rhoncus. Donec est. Nunc	pede blandit congue. In scelerisque scelerisque dui. Suspendisse
2	arcu	mattis. Integer eu lacus. Quisque imperdiet, erat nonummy	enim	velit dui, semper et, lacinia vitae, sodales
3	turpis. Aliquam	id	ac mi eleifend egestas. Sed	a odio semper cursus. Integer mollis.
4	Nam tempor diam dictum sapien. Aenean massa.	lorem, vehicula et, rutrum eu, ultrices sit amet, risus.	sem	leo. Morbi neque tellus, imperdiet non,
5	egestas blandit. Nam nulla	diam	aliquet molestie tellus. Aenean egestas hendrerit neque. In ornare sagittis	interdum libero dui
6	fringilla purus mauris a nunc. In at	iaculis	Donec non justo. Proin non massa non ante bibendum ullamcorper.	pede, nonummy ut, molestie in, tempus eu,
7	sollicitudin commodo ipsum. Suspendisse non	nec, euismod in, dolor. Fusce feugiat. Lorem ipsum dolor sit	lectus justo eu	sapien, cursus
8	Maecenas malesuada fringilla est. Mauris eu turpis. Nulla aliquet. Proin	porttitor vulputate, posuere vulputate, lacus. Cras interdum. Nunc	Nam ac nulla. In tincidunt congue turpis. In condimentum. Donec	lacus. Aliquam rutrum lorem ac risus. Morbi metus.
9	Suspendisse tristique neque venenatis lacus. Etiam bibendum fermentum metus.	at, iaculis quis,	Phasellus fermentum convallis ligula. Donec luctus aliquet	vulputate dui, nec tempus mauris erat eget
10	a sollicitudin orci sem eget	penatibus et magnis dis parturient	non, sollicitudin a, malesuada	metus. Aliquam erat volutpat. Nulla facilisis.
11	Donec fringilla. Donec feugiat metus	vulputate, nisi	elit. Aliquam auctor,	aliquet diam. Sed diam
12	lobortis	dis parturient montes, nascetur ridiculus	dolor. Donec fringilla. Donec feugiat metus sit amet ante.	dui, semper et, lacinia vitae, sodales
13	nec, euismod in, dolor. Fusce feugiat. Lorem ipsum dolor	mauris id sapien. Cras	risus odio, auctor vitae,	orci. Phasellus dapibus quam quis diam. Pellentesque habitant
14	cursus luctus, ipsum	lorem, sit amet ultricies sem magna	urna. Ut tincidunt vehicula	hymenaeos. Mauris
15	Donec non justo. Proin non massa non ante bibendum ullamcorper.	orci luctus et ultrices posuere cubilia Curae; Donec	convallis est, vitae sodales nisi magna sed dui. Fusce aliquam,	velit. Quisque varius. Nam porttitor scelerisque neque. Nullam nisl.
16	ac tellus. Suspendisse sed dolor.	Proin vel nisl.	Cras lorem lorem, luctus	ligula elit, pretium et, rutrum non, hendrerit id, ante.
17	non leo. Vivamus nibh dolor, nonummy ac,	auctor, velit	justo. Praesent	Pellentesque habitant morbi tristique senectus
18	ullamcorper eu, euismod ac, fermentum vel, mauris. Integer	et	tincidunt nibh. Phasellus nulla. Integer vulputate, risus a ultricies adipiscing,	scelerisque scelerisque
19	et malesuada	vel pede blandit	Proin nisl sem, consequat nec, mollis vitae, posuere at,	amet,
20	lorem, sit amet ultricies sem magna nec quam. Curabitur vel	nascetur ridiculus mus. Aenean eget magna. Suspendisse	odio. Etiam ligula tortor, dictum	ut lacus. Nulla tincidunt, neque vitae semper
21	suscipit, est ac facilisis facilisis, magna tellus faucibus leo,	justo nec ante. Maecenas	interdum ligula eu enim. Etiam imperdiet dictum magna.	eu arcu. Morbi sit amet
22	lorem, auctor quis, tristique ac, eleifend vitae, erat. Vivamus nisi.	mattis. Integer eu lacus. Quisque imperdiet, erat	Quisque nonummy ipsum non arcu. Vivamus sit amet	eu erat semper rutrum.
23	egestas, urna justo faucibus lectus, a	per inceptos	libero lacus, varius et, euismod et, commodo at,	nonummy ut, molestie in,
24	gravida.	Phasellus elit pede, malesuada	augue porttitor interdum. Sed auctor odio a purus. Duis	Aliquam ornare, libero at auctor ullamcorper, nisl arcu
25	lacinia	fringilla mi lacinia	augue eu tellus. Phasellus elit pede, malesuada vel, venenatis vel,	diam vel arcu. Curabitur ut odio
26	Aenean	vulputate mauris sagittis placerat. Cras dictum ultricies	ac, fermentum vel, mauris. Integer sem elit, pharetra ut,	arcu.
27	felis ullamcorper	nisi. Mauris nulla. Integer urna. Vivamus molestie dapibus ligula. Aliquam	vulputate,	erat volutpat.
28	tellus	Nam interdum enim non nisi.	pede	ut ipsum
29	mollis lectus pede et risus. Quisque libero lacus,	Nullam velit dui,	euismod ac, fermentum vel, mauris. Integer sem	enim.
30	nec enim. Nunc ut	aliquam arcu. Aliquam ultrices iaculis odio. Nam interdum	ornare sagittis felis. Donec tempor,	tristique senectus et
31	eu sem. Pellentesque ut ipsum ac mi eleifend egestas.	Sed dictum. Proin eget odio.	Morbi vehicula. Pellentesque tincidunt tempus risus. Donec	lacinia orci, consectetuer euismod est arcu ac orci.
32	ante lectus convallis	amet ultricies sem magna nec quam. Curabitur vel lectus.	quis diam	venenatis lacus. Etiam bibendum fermentum
33	vitae	malesuada ut,	laoreet, libero et tristique pellentesque, tellus sem mollis	libero nec ligula
34	sed leo. Cras	libero	Aliquam rutrum lorem ac risus. Morbi metus. Vivamus euismod	posuere cubilia Curae;
35	risus. Donec egestas. Duis ac arcu. Nunc mauris. Morbi	at,	pede. Cras vulputate velit eu sem.	Nullam scelerisque neque sed sem egestas blandit. Nam
36	vitae, erat. Vivamus nisi. Mauris nulla. Integer urna.	Praesent interdum ligula	arcu. Curabitur ut odio vel est tempor bibendum.	mus. Proin vel
37	varius ultrices, mauris ipsum porta elit, a feugiat tellus lorem	nulla at sem	orci, adipiscing non, luctus sit amet, faucibus ut, nulla. Cras	felis. Nulla tempor augue
38	et nunc.	feugiat. Lorem ipsum	mi tempor lorem, eget mollis lectus	magna. Suspendisse tristique neque venenatis lacus. Etiam bibendum
39	Mauris quis turpis vitae purus gravida sagittis. Duis gravida. Praesent	placerat,	justo.	Etiam gravida molestie arcu. Sed eu
40	elit. Aliquam	dictum	nascetur ridiculus	nulla at
41	semper auctor. Mauris vel turpis. Aliquam adipiscing	nostra, per inceptos hymenaeos. Mauris ut	egestas ligula. Nullam feugiat placerat velit.	Duis volutpat nunc
42	dolor sit amet, consectetuer	lacus. Etiam bibendum fermentum metus. Aenean sed pede nec	urna. Nunc quis	lacus. Etiam bibendum fermentum metus. Aenean sed pede nec ante
43	eu nibh vulputate mauris sagittis placerat. Cras dictum	diam eu dolor egestas rhoncus. Proin nisl	dictum magna. Ut tincidunt orci quis lectus. Nullam	lacus.
44	Aliquam auctor,	eu, accumsan	in sodales elit erat vitae risus. Duis	dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum
45	litora torquent per	ac tellus. Suspendisse	eu	Vestibulum ante ipsum primis in faucibus orci luctus
46	orci. Donec nibh. Quisque nonummy	tortor. Integer aliquam	nunc interdum feugiat.	a, auctor
47	ante dictum	gravida nunc	pede, ultrices a, auctor non, feugiat nec, diam. Duis	pretium aliquet, metus urna
48	elementum sem, vitae aliquam	dui. Suspendisse	orci, consectetuer	dolor, nonummy ac, feugiat non, lobortis
49	pellentesque massa lobortis	elementum sem,	et ipsum cursus vestibulum. Mauris magna. Duis dignissim	dui. Suspendisse ac metus vitae velit egestas
50	lobortis augue scelerisque mollis. Phasellus libero	ante lectus convallis est, vitae	iaculis, lacus pede sagittis	quam quis diam. Pellentesque habitant morbi tristique senectus
51	In at pede. Cras vulputate velit eu sem. Pellentesque	cursus et, magna. Praesent interdum ligula eu enim. Etiam	Aliquam nec enim. Nunc ut erat. Sed nunc est,	adipiscing elit. Etiam laoreet, libero et tristique pellentesque,
52	gravida non, sollicitudin a, malesuada	fermentum fermentum arcu. Vestibulum ante ipsum primis in faucibus	Duis a mi fringilla mi lacinia mattis. Integer eu lacus.	molestie tellus. Aenean egestas
53	dictum augue malesuada malesuada.	Donec tempor,	ipsum sodales	vitae diam.
54	sociis natoque	lacus. Cras interdum. Nunc sollicitudin commodo ipsum.	Aliquam	elit fermentum risus, at fringilla purus mauris a nunc.
55	sed, facilisis vitae, orci. Phasellus dapibus	hendrerit id,	odio. Phasellus at augue id ante	aliquam eu, accumsan sed, facilisis vitae,
56	a odio semper cursus. Integer	dolor. Fusce mi lorem, vehicula et, rutrum eu,	consequat nec, mollis vitae, posuere at, velit.	lacus.
57	natoque penatibus	quam a felis ullamcorper viverra. Maecenas iaculis aliquet	nunc ac mattis ornare, lectus ante	elit sed consequat
58	Proin eget odio. Aliquam vulputate ullamcorper magna. Sed eu eros.	eget	amet, consectetuer adipiscing elit. Curabitur sed	faucibus orci luctus
59	laoreet ipsum. Curabitur consequat, lectus sit amet luctus vulputate,	et malesuada fames ac turpis	enim, gravida sit amet,	eros turpis non enim. Mauris quis
60	nisi a odio semper cursus.	congue. In scelerisque scelerisque dui. Suspendisse ac metus	felis eget varius ultrices, mauris ipsum porta elit,	pellentesque eget, dictum placerat, augue. Sed
61	euismod mauris eu elit. Nulla facilisi. Sed neque. Sed eget	elit, dictum eu, eleifend nec,	odio vel est	faucibus leo, in lobortis tellus justo sit
62	Integer urna. Vivamus molestie dapibus	sem elit, pharetra ut,	amet,	mi. Duis risus odio, auctor vitae,
63	non, luctus sit amet, faucibus ut,	quis lectus. Nullam suscipit, est	non,	vel arcu eu odio tristique pharetra. Quisque ac libero
64	amet orci. Ut sagittis lobortis	sem molestie sodales.	vel, convallis	natoque penatibus et
65	leo. Vivamus nibh dolor, nonummy ac, feugiat	nibh. Phasellus nulla. Integer	quis accumsan convallis, ante lectus convallis est, vitae sodales nisi	risus.
66	In ornare sagittis felis. Donec tempor, est ac mattis	malesuada	parturient montes, nascetur ridiculus	tempus mauris erat eget ipsum. Suspendisse sagittis. Nullam vitae diam.
67	Cras sed leo. Cras vehicula aliquet	lobortis mauris.	quis, pede. Praesent eu dui. Cum sociis natoque penatibus	In ornare
68	Etiam imperdiet dictum magna.	augue eu tellus. Phasellus elit pede, malesuada vel, venenatis	Sed eu nibh vulputate mauris sagittis	turpis non enim. Mauris
69	felis. Donec tempor, est ac mattis	iaculis enim, sit amet ornare lectus	Duis dignissim tempor arcu. Vestibulum ut eros non enim commodo	Aliquam nec enim. Nunc ut erat.
70	lectus justo eu	lobortis, nisi nibh lacinia orci, consectetuer euismod est arcu ac	Cras eget nisi dictum augue malesuada	lectus, a sollicitudin orci sem eget
71	dictum placerat,	tortor, dictum eu, placerat eget,	adipiscing fringilla, porttitor	nibh lacinia orci, consectetuer euismod est arcu ac orci. Ut
72	Aliquam gravida mauris ut mi. Duis risus odio, auctor vitae,	pulvinar arcu et	erat	diam luctus lobortis. Class aptent taciti sociosqu ad litora
73	massa. Suspendisse eleifend. Cras sed leo. Cras vehicula aliquet libero.	ipsum	Duis mi enim, condimentum eget, volutpat ornare, facilisis eget,	tellus faucibus leo, in lobortis tellus justo sit amet nulla.
74	fames ac turpis egestas. Aliquam fringilla cursus purus.	sit amet ante.	iaculis aliquet diam. Sed diam lorem, auctor quis,	arcu. Vestibulum ante
75	Curabitur vel lectus. Cum sociis natoque penatibus et	aliquet vel, vulputate eu, odio. Phasellus at augue	eu metus. In lorem. Donec elementum, lorem ut	et risus. Quisque
76	tristique	nec, leo. Morbi neque tellus, imperdiet non, vestibulum nec, euismod	ultricies adipiscing, enim mi tempor lorem, eget mollis lectus	augue scelerisque mollis. Phasellus libero
77	tincidunt pede ac	eget, volutpat ornare,	cursus. Integer mollis. Integer tincidunt	tellus. Aenean egestas hendrerit
78	vulputate, risus	tellus. Aenean egestas hendrerit neque. In ornare sagittis felis.	Cras sed leo. Cras vehicula aliquet libero. Integer in	tempus
79	egestas ligula.	egestas hendrerit neque. In ornare sagittis felis. Donec	montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla euismod	ac facilisis facilisis, magna tellus faucibus leo, in lobortis tellus
80	sem ut cursus luctus, ipsum	mauris elit, dictum	risus varius orci, in consequat enim diam vel arcu.	cursus et,
81	lorem.	erat,	a, facilisis non, bibendum sed, est. Nunc laoreet lectus	tempus mauris erat eget ipsum. Suspendisse sagittis. Nullam vitae
82	eu tellus. Phasellus elit pede, malesuada vel, venenatis	arcu. Aliquam ultrices	suscipit, est ac facilisis facilisis, magna tellus faucibus leo, in	placerat eget, venenatis a, magna. Lorem ipsum dolor sit
83	ante. Vivamus non lorem vitae odio sagittis semper. Nam tempor	feugiat nec, diam. Duis	gravida. Praesent eu nulla at sem molestie sodales.	Nulla semper tellus id nunc
84	massa. Mauris vestibulum, neque	gravida nunc sed pede. Cum sociis natoque penatibus	a, auctor	magna et ipsum cursus
85	non, lobortis	Sed dictum. Proin eget odio. Aliquam vulputate ullamcorper magna.	ipsum cursus vestibulum. Mauris magna. Duis dignissim tempor arcu. Vestibulum	sagittis felis. Donec tempor, est ac mattis semper,
86	nisi.	risus varius orci, in	commodo tincidunt nibh. Phasellus nulla.	purus. Duis elementum, dui quis accumsan convallis,
87	nulla. Donec non justo.	risus. Donec nibh enim, gravida sit amet,	eleifend non, dapibus rutrum, justo. Praesent	suscipit, est ac facilisis
88	sit amet ante.	ante.	natoque penatibus et magnis dis	tellus
89	sagittis augue, eu	velit dui, semper et, lacinia vitae, sodales at, velit. Pellentesque	urna.	mus.
90	condimentum. Donec at arcu.	Integer vulputate, risus a ultricies adipiscing, enim mi tempor	lectus ante dictum mi, ac mattis velit justo nec	nulla.
91	sem. Pellentesque ut ipsum ac mi eleifend	eu, ultrices sit amet, risus. Donec nibh enim, gravida sit	Sed pharetra, felis eget varius ultrices, mauris ipsum	nisl. Maecenas
92	et, rutrum eu, ultrices sit amet, risus. Donec	Donec tincidunt. Donec vitae erat vel	molestie tortor nibh sit amet	netus et malesuada fames ac turpis
93	tellus faucibus	ridiculus	facilisis	ac metus vitae velit
94	vestibulum massa	diam. Pellentesque habitant morbi tristique senectus et netus	vulputate ullamcorper magna. Sed eu eros. Nam consequat dolor	justo. Proin non massa non ante bibendum
95	velit. Aliquam nisl. Nulla eu	ligula. Aenean gravida nunc sed pede. Cum	consequat	lobortis risus. In mi pede, nonummy ut,
96	Etiam ligula	metus. Vivamus euismod urna. Nullam lobortis quam a felis ullamcorper	molestie pharetra nibh. Aliquam ornare, libero	Curae; Phasellus ornare. Fusce mollis. Duis sit amet diam eu
97	facilisis vitae, orci. Phasellus dapibus quam	inceptos hymenaeos. Mauris ut quam vel sapien imperdiet ornare. In	interdum ligula eu	Proin mi.
98	neque pellentesque massa	Vivamus nibh dolor, nonummy ac,	eu eros. Nam consequat dolor	gravida non, sollicitudin a, malesuada id, erat. Etiam
99	aliquet nec, imperdiet nec, leo. Morbi neque	Mauris blandit enim	porttitor scelerisque neque. Nullam nisl.	euismod est arcu ac orci. Ut semper
100	et ipsum cursus vestibulum.	ultrices. Vivamus rhoncus.	ligula. Aenean gravida nunc sed pede. Cum sociis	sem semper erat, in consectetuer ipsum nunc id
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
1	1	2015-07-05 23:45:48
2	2	2015-07-05 23:45:48
3	3	2015-07-05 23:45:48
4	4	2015-07-05 23:45:48
5	5	2015-07-05 23:45:48
6	6	2015-07-05 23:45:48
7	7	2015-07-05 23:45:48
8	8	2015-07-05 23:45:48
9	9	2015-07-05 23:45:48
10	10	2015-07-05 23:45:48
11	11	2015-07-05 23:45:48
12	12	2015-07-05 23:45:48
13	13	2015-07-05 23:45:48
14	14	2015-07-05 23:45:48
15	15	2015-07-05 23:45:48
16	16	2015-07-05 23:45:48
17	17	2015-07-05 23:45:48
18	18	2015-07-05 23:45:48
19	19	2015-07-05 23:45:48
20	20	2015-07-05 23:45:48
21	21	2015-07-05 23:45:48
22	22	2015-07-05 23:45:48
23	23	2015-07-05 23:45:48
24	24	2015-07-05 23:45:48
25	25	2015-07-05 23:45:48
26	26	2015-07-05 23:45:48
27	27	2015-07-05 23:45:48
28	28	2015-07-05 23:45:48
29	29	2015-07-05 23:45:48
30	30	2015-07-05 23:45:48
31	31	2015-07-05 23:45:48
32	32	2015-07-05 23:45:48
33	33	2015-07-05 23:45:48
34	34	2015-07-05 23:45:48
35	35	2015-07-05 23:45:48
36	36	2015-07-05 23:45:48
37	37	2015-07-05 23:45:48
38	38	2015-07-05 23:45:48
39	39	2015-07-05 23:45:48
40	40	2015-07-05 23:45:48
41	41	2015-07-05 23:45:48
42	42	2015-07-05 23:45:48
43	43	2015-07-05 23:45:48
44	44	2015-07-05 23:45:48
45	45	2015-07-05 23:45:48
46	46	2015-07-05 23:45:48
47	47	2015-07-05 23:45:48
48	48	2015-07-05 23:45:48
49	49	2015-07-05 23:45:48
50	50	2015-07-05 23:45:48
51	51	2015-07-05 23:45:48
52	52	2015-07-05 23:45:48
53	53	2015-07-05 23:45:48
54	54	2015-07-05 23:45:48
55	55	2015-07-05 23:45:48
56	56	2015-07-05 23:45:48
57	57	2015-07-05 23:45:48
58	58	2015-07-05 23:45:48
59	59	2015-07-05 23:45:48
60	60	2015-07-05 23:45:48
61	61	2015-07-05 23:45:48
62	62	2015-07-05 23:45:48
63	63	2015-07-05 23:45:48
64	64	2015-07-05 23:45:48
65	65	2015-07-05 23:45:48
66	66	2015-07-05 23:45:48
67	67	2015-07-05 23:45:48
68	68	2015-07-05 23:45:48
69	69	2015-07-05 23:45:48
70	70	2015-07-05 23:45:48
71	71	2015-07-05 23:45:48
72	72	2015-07-05 23:45:48
73	73	2015-07-05 23:45:48
74	74	2015-07-05 23:45:48
75	75	2015-07-05 23:45:48
76	76	2015-07-05 23:45:48
77	77	2015-07-05 23:45:48
78	78	2015-07-05 23:45:48
79	79	2015-07-05 23:45:48
80	80	2015-07-05 23:45:48
81	81	2015-07-05 23:45:48
82	82	2015-07-05 23:45:48
83	83	2015-07-05 23:45:48
84	84	2015-07-05 23:45:48
85	85	2015-07-05 23:45:48
86	86	2015-07-05 23:45:48
87	87	2015-07-05 23:45:48
88	88	2015-07-05 23:45:48
89	89	2015-07-05 23:45:48
90	90	2015-07-05 23:45:48
91	91	2015-07-05 23:45:48
92	92	2015-07-05 23:45:48
93	93	2015-07-05 23:45:48
94	94	2015-07-05 23:45:48
95	95	2015-07-05 23:45:48
96	96	2015-07-05 23:45:48
97	97	2015-07-05 23:45:48
98	98	2015-07-05 23:45:48
99	99	2015-07-05 23:45:48
100	100	2015-07-05 23:45:48
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

