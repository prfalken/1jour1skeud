--
-- PostgreSQL database dump
--

\restrict G6M362OPoIekIT6vjinTlIwEjLQnYA1fRJmzBjt6MwwNQuYpSJUYduKKfdpOves

-- Dumped from database version 16.3 (Debian 16.3-1.pgdg120+1)
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: cover_art_archive; Type: SCHEMA; Schema: -; Owner: musicbrainz
--

CREATE SCHEMA cover_art_archive;


ALTER SCHEMA cover_art_archive OWNER TO musicbrainz;

--
-- Name: dbmirror2; Type: SCHEMA; Schema: -; Owner: musicbrainz
--

CREATE SCHEMA dbmirror2;


ALTER SCHEMA dbmirror2 OWNER TO musicbrainz;

--
-- Name: documentation; Type: SCHEMA; Schema: -; Owner: musicbrainz
--

CREATE SCHEMA documentation;


ALTER SCHEMA documentation OWNER TO musicbrainz;

--
-- Name: event_art_archive; Type: SCHEMA; Schema: -; Owner: musicbrainz
--

CREATE SCHEMA event_art_archive;


ALTER SCHEMA event_art_archive OWNER TO musicbrainz;

--
-- Name: json_dump; Type: SCHEMA; Schema: -; Owner: musicbrainz
--

CREATE SCHEMA json_dump;


ALTER SCHEMA json_dump OWNER TO musicbrainz;

--
-- Name: musicbrainz; Type: SCHEMA; Schema: -; Owner: musicbrainz
--

CREATE SCHEMA musicbrainz;


ALTER SCHEMA musicbrainz OWNER TO musicbrainz;

--
-- Name: report; Type: SCHEMA; Schema: -; Owner: musicbrainz
--

CREATE SCHEMA report;


ALTER SCHEMA report OWNER TO musicbrainz;

--
-- Name: sitemaps; Type: SCHEMA; Schema: -; Owner: musicbrainz
--

CREATE SCHEMA sitemaps;


ALTER SCHEMA sitemaps OWNER TO musicbrainz;

--
-- Name: statistics; Type: SCHEMA; Schema: -; Owner: musicbrainz
--

CREATE SCHEMA statistics;


ALTER SCHEMA statistics OWNER TO musicbrainz;

--
-- Name: wikidocs; Type: SCHEMA; Schema: -; Owner: musicbrainz
--

CREATE SCHEMA wikidocs;


ALTER SCHEMA wikidocs OWNER TO musicbrainz;

--
-- Name: musicbrainz; Type: COLLATION; Schema: musicbrainz; Owner: musicbrainz
--

CREATE COLLATION musicbrainz.musicbrainz (provider = icu, locale = 'und-u-kf-lower-kn');


ALTER COLLATION musicbrainz.musicbrainz OWNER TO musicbrainz;

--
-- Name: cube; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS cube WITH SCHEMA public;


--
-- Name: EXTENSION cube; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION cube IS 'data type for multidimensional cubes';


--
-- Name: earthdistance; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS earthdistance WITH SCHEMA public;


--
-- Name: EXTENSION earthdistance; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION earthdistance IS 'calculate great-circle distances on the surface of the Earth';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: cover_art_presence; Type: TYPE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TYPE musicbrainz.cover_art_presence AS ENUM (
    'absent',
    'present',
    'darkened'
);


ALTER TYPE musicbrainz.cover_art_presence OWNER TO musicbrainz;

--
-- Name: edit_note_status; Type: TYPE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TYPE musicbrainz.edit_note_status AS ENUM (
    'deleted',
    'edited'
);


ALTER TYPE musicbrainz.edit_note_status OWNER TO musicbrainz;

--
-- Name: event_art_presence; Type: TYPE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TYPE musicbrainz.event_art_presence AS ENUM (
    'absent',
    'present',
    'darkened'
);


ALTER TYPE musicbrainz.event_art_presence OWNER TO musicbrainz;

--
-- Name: fluency; Type: TYPE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TYPE musicbrainz.fluency AS ENUM (
    'basic',
    'intermediate',
    'advanced',
    'native'
);


ALTER TYPE musicbrainz.fluency OWNER TO musicbrainz;

--
-- Name: oauth_code_challenge_method; Type: TYPE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TYPE musicbrainz.oauth_code_challenge_method AS ENUM (
    'plain',
    'S256'
);


ALTER TYPE musicbrainz.oauth_code_challenge_method OWNER TO musicbrainz;

--
-- Name: ratable_entity_type; Type: TYPE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TYPE musicbrainz.ratable_entity_type AS ENUM (
    'artist',
    'event',
    'label',
    'place',
    'recording',
    'release_group',
    'work'
);


ALTER TYPE musicbrainz.ratable_entity_type OWNER TO musicbrainz;

--
-- Name: taggable_entity_type; Type: TYPE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TYPE musicbrainz.taggable_entity_type AS ENUM (
    'area',
    'artist',
    'event',
    'instrument',
    'label',
    'place',
    'recording',
    'release',
    'release_group',
    'series',
    'work'
);


ALTER TYPE musicbrainz.taggable_entity_type OWNER TO musicbrainz;

--
-- Name: ll_to_earth(double precision, double precision); Type: FUNCTION; Schema: musicbrainz; Owner: musicbrainz
--

CREATE FUNCTION musicbrainz.ll_to_earth(double precision, double precision) RETURNS public.earth
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$SELECT public.cube(public.cube(public.cube(public.earth()*cos(radians($1))*cos(radians($2))),public.earth()*cos(radians($1))*sin(radians($2))),public.earth()*sin(radians($1)))::public.earth$_$;


ALTER FUNCTION musicbrainz.ll_to_earth(double precision, double precision) OWNER TO musicbrainz;

--
-- Name: musicbrainz_unaccent(text); Type: FUNCTION; Schema: musicbrainz; Owner: musicbrainz
--

CREATE FUNCTION musicbrainz.musicbrainz_unaccent(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$
    SELECT public.immutable_unaccent(regdictionary 'public.unaccent', $1)
  $_$;


ALTER FUNCTION musicbrainz.musicbrainz_unaccent(text) OWNER TO musicbrainz;

--
-- Name: immutable_unaccent(regdictionary, text); Type: FUNCTION; Schema: public; Owner: musicbrainz
--

CREATE FUNCTION public.immutable_unaccent(regdictionary, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT PARALLEL SAFE
    AS '$libdir/unaccent', 'unaccent_dict';


ALTER FUNCTION public.immutable_unaccent(regdictionary, text) OWNER TO musicbrainz;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: art_type; Type: TABLE; Schema: cover_art_archive; Owner: musicbrainz
--

CREATE TABLE cover_art_archive.art_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE cover_art_archive.art_type OWNER TO musicbrainz;

--
-- Name: art_type_id_seq; Type: SEQUENCE; Schema: cover_art_archive; Owner: musicbrainz
--

CREATE SEQUENCE cover_art_archive.art_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE cover_art_archive.art_type_id_seq OWNER TO musicbrainz;

--
-- Name: art_type_id_seq; Type: SEQUENCE OWNED BY; Schema: cover_art_archive; Owner: musicbrainz
--

ALTER SEQUENCE cover_art_archive.art_type_id_seq OWNED BY cover_art_archive.art_type.id;


--
-- Name: cover_art; Type: TABLE; Schema: cover_art_archive; Owner: musicbrainz
--

CREATE TABLE cover_art_archive.cover_art (
    id bigint NOT NULL,
    release integer NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    edit integer NOT NULL,
    ordering integer NOT NULL,
    date_uploaded timestamp with time zone DEFAULT now() NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    mime_type text NOT NULL,
    filesize integer,
    thumb_250_filesize integer,
    thumb_500_filesize integer,
    thumb_1200_filesize integer,
    CONSTRAINT cover_art_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT cover_art_ordering_check CHECK ((ordering > 0))
);


ALTER TABLE cover_art_archive.cover_art OWNER TO musicbrainz;

--
-- Name: cover_art_type; Type: TABLE; Schema: cover_art_archive; Owner: musicbrainz
--

CREATE TABLE cover_art_archive.cover_art_type (
    id bigint NOT NULL,
    type_id integer NOT NULL
);


ALTER TABLE cover_art_archive.cover_art_type OWNER TO musicbrainz;

--
-- Name: image_type; Type: TABLE; Schema: cover_art_archive; Owner: musicbrainz
--

CREATE TABLE cover_art_archive.image_type (
    mime_type text NOT NULL,
    suffix text NOT NULL
);


ALTER TABLE cover_art_archive.image_type OWNER TO musicbrainz;

--
-- Name: release_group_cover_art; Type: TABLE; Schema: cover_art_archive; Owner: musicbrainz
--

CREATE TABLE cover_art_archive.release_group_cover_art (
    release_group integer NOT NULL,
    release integer NOT NULL
);


ALTER TABLE cover_art_archive.release_group_cover_art OWNER TO musicbrainz;

--
-- Name: l_area_area_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_area_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_area_example OWNER TO musicbrainz;

--
-- Name: l_area_artist_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_artist_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_artist_example OWNER TO musicbrainz;

--
-- Name: l_area_event_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_event_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_event_example OWNER TO musicbrainz;

--
-- Name: l_area_genre_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_genre_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_genre_example OWNER TO musicbrainz;

--
-- Name: l_area_instrument_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_instrument_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_instrument_example OWNER TO musicbrainz;

--
-- Name: l_area_label_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_label_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_label_example OWNER TO musicbrainz;

--
-- Name: l_area_mood_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_mood_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_mood_example OWNER TO musicbrainz;

--
-- Name: l_area_place_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_place_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_place_example OWNER TO musicbrainz;

--
-- Name: l_area_recording_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_recording_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_recording_example OWNER TO musicbrainz;

--
-- Name: l_area_release_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_release_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_release_example OWNER TO musicbrainz;

--
-- Name: l_area_release_group_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_release_group_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_release_group_example OWNER TO musicbrainz;

--
-- Name: l_area_series_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_series_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_series_example OWNER TO musicbrainz;

--
-- Name: l_area_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_url_example OWNER TO musicbrainz;

--
-- Name: l_area_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_area_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_area_work_example OWNER TO musicbrainz;

--
-- Name: l_artist_artist_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_artist_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_artist_example OWNER TO musicbrainz;

--
-- Name: l_artist_event_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_event_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_event_example OWNER TO musicbrainz;

--
-- Name: l_artist_genre_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_genre_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_genre_example OWNER TO musicbrainz;

--
-- Name: l_artist_instrument_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_instrument_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_instrument_example OWNER TO musicbrainz;

--
-- Name: l_artist_label_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_label_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_label_example OWNER TO musicbrainz;

--
-- Name: l_artist_mood_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_mood_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_mood_example OWNER TO musicbrainz;

--
-- Name: l_artist_place_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_place_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_place_example OWNER TO musicbrainz;

--
-- Name: l_artist_recording_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_recording_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_recording_example OWNER TO musicbrainz;

--
-- Name: l_artist_release_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_release_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_release_example OWNER TO musicbrainz;

--
-- Name: l_artist_release_group_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_release_group_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_release_group_example OWNER TO musicbrainz;

--
-- Name: l_artist_series_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_series_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_series_example OWNER TO musicbrainz;

--
-- Name: l_artist_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_url_example OWNER TO musicbrainz;

--
-- Name: l_artist_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_artist_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_artist_work_example OWNER TO musicbrainz;

--
-- Name: l_event_event_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_event_event_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_event_event_example OWNER TO musicbrainz;

--
-- Name: l_event_genre_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_event_genre_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_event_genre_example OWNER TO musicbrainz;

--
-- Name: l_event_instrument_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_event_instrument_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_event_instrument_example OWNER TO musicbrainz;

--
-- Name: l_event_label_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_event_label_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_event_label_example OWNER TO musicbrainz;

--
-- Name: l_event_mood_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_event_mood_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_event_mood_example OWNER TO musicbrainz;

--
-- Name: l_event_place_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_event_place_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_event_place_example OWNER TO musicbrainz;

--
-- Name: l_event_recording_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_event_recording_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_event_recording_example OWNER TO musicbrainz;

--
-- Name: l_event_release_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_event_release_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_event_release_example OWNER TO musicbrainz;

--
-- Name: l_event_release_group_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_event_release_group_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_event_release_group_example OWNER TO musicbrainz;

--
-- Name: l_event_series_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_event_series_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_event_series_example OWNER TO musicbrainz;

--
-- Name: l_event_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_event_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_event_url_example OWNER TO musicbrainz;

--
-- Name: l_event_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_event_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_event_work_example OWNER TO musicbrainz;

--
-- Name: l_genre_genre_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_genre_genre_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_genre_genre_example OWNER TO musicbrainz;

--
-- Name: l_genre_instrument_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_genre_instrument_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_genre_instrument_example OWNER TO musicbrainz;

--
-- Name: l_genre_label_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_genre_label_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_genre_label_example OWNER TO musicbrainz;

--
-- Name: l_genre_mood_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_genre_mood_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_genre_mood_example OWNER TO musicbrainz;

--
-- Name: l_genre_place_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_genre_place_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_genre_place_example OWNER TO musicbrainz;

--
-- Name: l_genre_recording_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_genre_recording_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_genre_recording_example OWNER TO musicbrainz;

--
-- Name: l_genre_release_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_genre_release_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_genre_release_example OWNER TO musicbrainz;

--
-- Name: l_genre_release_group_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_genre_release_group_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_genre_release_group_example OWNER TO musicbrainz;

--
-- Name: l_genre_series_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_genre_series_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_genre_series_example OWNER TO musicbrainz;

--
-- Name: l_genre_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_genre_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_genre_url_example OWNER TO musicbrainz;

--
-- Name: l_genre_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_genre_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_genre_work_example OWNER TO musicbrainz;

--
-- Name: l_instrument_instrument_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_instrument_instrument_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_instrument_instrument_example OWNER TO musicbrainz;

--
-- Name: l_instrument_label_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_instrument_label_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_instrument_label_example OWNER TO musicbrainz;

--
-- Name: l_instrument_mood_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_instrument_mood_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_instrument_mood_example OWNER TO musicbrainz;

--
-- Name: l_instrument_place_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_instrument_place_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_instrument_place_example OWNER TO musicbrainz;

--
-- Name: l_instrument_recording_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_instrument_recording_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_instrument_recording_example OWNER TO musicbrainz;

--
-- Name: l_instrument_release_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_instrument_release_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_instrument_release_example OWNER TO musicbrainz;

--
-- Name: l_instrument_release_group_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_instrument_release_group_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_instrument_release_group_example OWNER TO musicbrainz;

--
-- Name: l_instrument_series_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_instrument_series_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_instrument_series_example OWNER TO musicbrainz;

--
-- Name: l_instrument_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_instrument_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_instrument_url_example OWNER TO musicbrainz;

--
-- Name: l_instrument_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_instrument_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_instrument_work_example OWNER TO musicbrainz;

--
-- Name: l_label_label_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_label_label_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_label_label_example OWNER TO musicbrainz;

--
-- Name: l_label_mood_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_label_mood_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_label_mood_example OWNER TO musicbrainz;

--
-- Name: l_label_place_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_label_place_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_label_place_example OWNER TO musicbrainz;

--
-- Name: l_label_recording_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_label_recording_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_label_recording_example OWNER TO musicbrainz;

--
-- Name: l_label_release_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_label_release_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_label_release_example OWNER TO musicbrainz;

--
-- Name: l_label_release_group_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_label_release_group_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_label_release_group_example OWNER TO musicbrainz;

--
-- Name: l_label_series_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_label_series_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_label_series_example OWNER TO musicbrainz;

--
-- Name: l_label_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_label_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_label_url_example OWNER TO musicbrainz;

--
-- Name: l_label_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_label_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_label_work_example OWNER TO musicbrainz;

--
-- Name: l_mood_mood_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_mood_mood_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_mood_mood_example OWNER TO musicbrainz;

--
-- Name: l_mood_place_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_mood_place_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_mood_place_example OWNER TO musicbrainz;

--
-- Name: l_mood_recording_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_mood_recording_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_mood_recording_example OWNER TO musicbrainz;

--
-- Name: l_mood_release_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_mood_release_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_mood_release_example OWNER TO musicbrainz;

--
-- Name: l_mood_release_group_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_mood_release_group_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_mood_release_group_example OWNER TO musicbrainz;

--
-- Name: l_mood_series_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_mood_series_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_mood_series_example OWNER TO musicbrainz;

--
-- Name: l_mood_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_mood_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_mood_url_example OWNER TO musicbrainz;

--
-- Name: l_mood_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_mood_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_mood_work_example OWNER TO musicbrainz;

--
-- Name: l_place_place_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_place_place_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_place_place_example OWNER TO musicbrainz;

--
-- Name: l_place_recording_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_place_recording_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_place_recording_example OWNER TO musicbrainz;

--
-- Name: l_place_release_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_place_release_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_place_release_example OWNER TO musicbrainz;

--
-- Name: l_place_release_group_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_place_release_group_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_place_release_group_example OWNER TO musicbrainz;

--
-- Name: l_place_series_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_place_series_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_place_series_example OWNER TO musicbrainz;

--
-- Name: l_place_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_place_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_place_url_example OWNER TO musicbrainz;

--
-- Name: l_place_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_place_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_place_work_example OWNER TO musicbrainz;

--
-- Name: l_recording_recording_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_recording_recording_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_recording_recording_example OWNER TO musicbrainz;

--
-- Name: l_recording_release_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_recording_release_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_recording_release_example OWNER TO musicbrainz;

--
-- Name: l_recording_release_group_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_recording_release_group_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_recording_release_group_example OWNER TO musicbrainz;

--
-- Name: l_recording_series_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_recording_series_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_recording_series_example OWNER TO musicbrainz;

--
-- Name: l_recording_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_recording_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_recording_url_example OWNER TO musicbrainz;

--
-- Name: l_recording_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_recording_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_recording_work_example OWNER TO musicbrainz;

--
-- Name: l_release_group_release_group_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_release_group_release_group_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_release_group_release_group_example OWNER TO musicbrainz;

--
-- Name: l_release_group_series_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_release_group_series_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_release_group_series_example OWNER TO musicbrainz;

--
-- Name: l_release_group_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_release_group_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_release_group_url_example OWNER TO musicbrainz;

--
-- Name: l_release_group_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_release_group_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_release_group_work_example OWNER TO musicbrainz;

--
-- Name: l_release_release_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_release_release_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_release_release_example OWNER TO musicbrainz;

--
-- Name: l_release_release_group_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_release_release_group_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_release_release_group_example OWNER TO musicbrainz;

--
-- Name: l_release_series_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_release_series_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_release_series_example OWNER TO musicbrainz;

--
-- Name: l_release_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_release_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_release_url_example OWNER TO musicbrainz;

--
-- Name: l_release_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_release_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_release_work_example OWNER TO musicbrainz;

--
-- Name: l_series_series_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_series_series_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_series_series_example OWNER TO musicbrainz;

--
-- Name: l_series_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_series_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_series_url_example OWNER TO musicbrainz;

--
-- Name: l_series_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_series_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_series_work_example OWNER TO musicbrainz;

--
-- Name: l_url_url_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_url_url_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_url_url_example OWNER TO musicbrainz;

--
-- Name: l_url_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_url_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_url_work_example OWNER TO musicbrainz;

--
-- Name: l_work_work_example; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.l_work_work_example (
    id integer NOT NULL,
    published boolean NOT NULL,
    name text NOT NULL
);


ALTER TABLE documentation.l_work_work_example OWNER TO musicbrainz;

--
-- Name: link_type_documentation; Type: TABLE; Schema: documentation; Owner: musicbrainz
--

CREATE TABLE documentation.link_type_documentation (
    id integer NOT NULL,
    documentation text NOT NULL,
    examples_deleted smallint DEFAULT 0 NOT NULL
);


ALTER TABLE documentation.link_type_documentation OWNER TO musicbrainz;

--
-- Name: art_type; Type: TABLE; Schema: event_art_archive; Owner: musicbrainz
--

CREATE TABLE event_art_archive.art_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE event_art_archive.art_type OWNER TO musicbrainz;

--
-- Name: art_type_id_seq; Type: SEQUENCE; Schema: event_art_archive; Owner: musicbrainz
--

CREATE SEQUENCE event_art_archive.art_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE event_art_archive.art_type_id_seq OWNER TO musicbrainz;

--
-- Name: art_type_id_seq; Type: SEQUENCE OWNED BY; Schema: event_art_archive; Owner: musicbrainz
--

ALTER SEQUENCE event_art_archive.art_type_id_seq OWNED BY event_art_archive.art_type.id;


--
-- Name: event_art; Type: TABLE; Schema: event_art_archive; Owner: musicbrainz
--

CREATE TABLE event_art_archive.event_art (
    id bigint NOT NULL,
    event integer NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    edit integer NOT NULL,
    ordering integer NOT NULL,
    date_uploaded timestamp with time zone DEFAULT now() NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    mime_type text NOT NULL,
    filesize integer,
    thumb_250_filesize integer,
    thumb_500_filesize integer,
    thumb_1200_filesize integer,
    CONSTRAINT event_art_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT event_art_ordering_check CHECK ((ordering > 0))
);


ALTER TABLE event_art_archive.event_art OWNER TO musicbrainz;

--
-- Name: event_art_type; Type: TABLE; Schema: event_art_archive; Owner: musicbrainz
--

CREATE TABLE event_art_archive.event_art_type (
    id bigint NOT NULL,
    type_id integer NOT NULL
);


ALTER TABLE event_art_archive.event_art_type OWNER TO musicbrainz;

--
-- Name: area_json; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.area_json (
    id integer NOT NULL,
    replication_sequence integer NOT NULL,
    "json" jsonb NOT NULL,
    last_modified timestamp with time zone
);


ALTER TABLE json_dump.area_json OWNER TO musicbrainz;

--
-- Name: artist_json; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.artist_json (
    id integer NOT NULL,
    replication_sequence integer NOT NULL,
    "json" jsonb NOT NULL,
    last_modified timestamp with time zone
);


ALTER TABLE json_dump.artist_json OWNER TO musicbrainz;

--
-- Name: control; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.control (
    last_processed_replication_sequence integer,
    full_json_dump_replication_sequence integer
);


ALTER TABLE json_dump.control OWNER TO musicbrainz;

--
-- Name: deleted_entities; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.deleted_entities (
    entity_type character varying(50) NOT NULL,
    id integer NOT NULL,
    replication_sequence integer NOT NULL
);


ALTER TABLE json_dump.deleted_entities OWNER TO musicbrainz;

--
-- Name: event_json; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.event_json (
    id integer NOT NULL,
    replication_sequence integer NOT NULL,
    "json" jsonb NOT NULL,
    last_modified timestamp with time zone
);


ALTER TABLE json_dump.event_json OWNER TO musicbrainz;

--
-- Name: instrument_json; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.instrument_json (
    id integer NOT NULL,
    replication_sequence integer NOT NULL,
    "json" jsonb NOT NULL,
    last_modified timestamp with time zone
);


ALTER TABLE json_dump.instrument_json OWNER TO musicbrainz;

--
-- Name: label_json; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.label_json (
    id integer NOT NULL,
    replication_sequence integer NOT NULL,
    "json" jsonb NOT NULL,
    last_modified timestamp with time zone
);


ALTER TABLE json_dump.label_json OWNER TO musicbrainz;

--
-- Name: place_json; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.place_json (
    id integer NOT NULL,
    replication_sequence integer NOT NULL,
    "json" jsonb NOT NULL,
    last_modified timestamp with time zone
);


ALTER TABLE json_dump.place_json OWNER TO musicbrainz;

--
-- Name: recording_json; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.recording_json (
    id integer NOT NULL,
    replication_sequence integer NOT NULL,
    "json" jsonb NOT NULL,
    last_modified timestamp with time zone
);


ALTER TABLE json_dump.recording_json OWNER TO musicbrainz;

--
-- Name: release_group_json; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.release_group_json (
    id integer NOT NULL,
    replication_sequence integer NOT NULL,
    "json" jsonb NOT NULL,
    last_modified timestamp with time zone
);


ALTER TABLE json_dump.release_group_json OWNER TO musicbrainz;

--
-- Name: release_json; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.release_json (
    id integer NOT NULL,
    replication_sequence integer NOT NULL,
    "json" jsonb NOT NULL,
    last_modified timestamp with time zone
);


ALTER TABLE json_dump.release_json OWNER TO musicbrainz;

--
-- Name: series_json; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.series_json (
    id integer NOT NULL,
    replication_sequence integer NOT NULL,
    "json" jsonb NOT NULL,
    last_modified timestamp with time zone
);


ALTER TABLE json_dump.series_json OWNER TO musicbrainz;

--
-- Name: tmp_checked_entities; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.tmp_checked_entities (
    id integer NOT NULL,
    entity_type character varying(50) NOT NULL
);


ALTER TABLE json_dump.tmp_checked_entities OWNER TO musicbrainz;

--
-- Name: work_json; Type: TABLE; Schema: json_dump; Owner: musicbrainz
--

CREATE TABLE json_dump.work_json (
    id integer NOT NULL,
    replication_sequence integer NOT NULL,
    "json" jsonb NOT NULL,
    last_modified timestamp with time zone
);


ALTER TABLE json_dump.work_json OWNER TO musicbrainz;

--
-- Name: alternative_medium; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.alternative_medium (
    id integer NOT NULL,
    medium integer NOT NULL,
    alternative_release integer NOT NULL,
    name character varying,
    CONSTRAINT alternative_medium_name_check CHECK (((name)::text <> ''::text))
);


ALTER TABLE musicbrainz.alternative_medium OWNER TO musicbrainz;

--
-- Name: alternative_medium_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.alternative_medium_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.alternative_medium_id_seq OWNER TO musicbrainz;

--
-- Name: alternative_medium_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.alternative_medium_id_seq OWNED BY musicbrainz.alternative_medium.id;


--
-- Name: alternative_medium_track; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.alternative_medium_track (
    alternative_medium integer NOT NULL,
    track integer NOT NULL,
    alternative_track integer NOT NULL
);


ALTER TABLE musicbrainz.alternative_medium_track OWNER TO musicbrainz;

--
-- Name: alternative_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.alternative_release (
    id integer NOT NULL,
    gid uuid NOT NULL,
    release integer NOT NULL,
    name character varying,
    artist_credit integer,
    type integer NOT NULL,
    language integer NOT NULL,
    script integer NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    CONSTRAINT alternative_release_name_check CHECK (((name)::text <> ''::text))
);


ALTER TABLE musicbrainz.alternative_release OWNER TO musicbrainz;

--
-- Name: alternative_release_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.alternative_release_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.alternative_release_id_seq OWNER TO musicbrainz;

--
-- Name: alternative_release_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.alternative_release_id_seq OWNED BY musicbrainz.alternative_release.id;


--
-- Name: alternative_release_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.alternative_release_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.alternative_release_type OWNER TO musicbrainz;

--
-- Name: alternative_release_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.alternative_release_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.alternative_release_type_id_seq OWNER TO musicbrainz;

--
-- Name: alternative_release_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.alternative_release_type_id_seq OWNED BY musicbrainz.alternative_release_type.id;


--
-- Name: alternative_track; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.alternative_track (
    id integer NOT NULL,
    name character varying,
    artist_credit integer,
    ref_count integer DEFAULT 0 NOT NULL,
    CONSTRAINT alternative_track_check CHECK ((((name)::text <> ''::text) AND ((name IS NOT NULL) OR (artist_credit IS NOT NULL))))
);


ALTER TABLE musicbrainz.alternative_track OWNER TO musicbrainz;

--
-- Name: alternative_track_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.alternative_track_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.alternative_track_id_seq OWNER TO musicbrainz;

--
-- Name: alternative_track_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.alternative_track_id_seq OWNED BY musicbrainz.alternative_track.id;


--
-- Name: annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.annotation (
    id integer NOT NULL,
    editor integer NOT NULL,
    text text,
    changelog character varying(255),
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.annotation OWNER TO musicbrainz;

--
-- Name: annotation_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.annotation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.annotation_id_seq OWNER TO musicbrainz;

--
-- Name: annotation_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.annotation_id_seq OWNED BY musicbrainz.annotation.id;


--
-- Name: application; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.application (
    id integer NOT NULL,
    owner integer NOT NULL,
    name text NOT NULL,
    oauth_id text NOT NULL,
    oauth_secret text NOT NULL,
    oauth_redirect_uri text
);


ALTER TABLE musicbrainz.application OWNER TO musicbrainz;

--
-- Name: application_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.application_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.application_id_seq OWNER TO musicbrainz;

--
-- Name: application_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.application_id_seq OWNED BY musicbrainz.application.id;


--
-- Name: area; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.area (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    type integer,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    ended boolean DEFAULT false NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    CONSTRAINT area_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT area_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.area OWNER TO musicbrainz;

--
-- Name: area_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.area_alias (
    id integer NOT NULL,
    area integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT area_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT area_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL)))
);


ALTER TABLE musicbrainz.area_alias OWNER TO musicbrainz;

--
-- Name: area_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.area_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.area_alias_id_seq OWNER TO musicbrainz;

--
-- Name: area_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.area_alias_id_seq OWNED BY musicbrainz.area_alias.id;


--
-- Name: area_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.area_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.area_alias_type OWNER TO musicbrainz;

--
-- Name: area_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.area_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.area_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: area_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.area_alias_type_id_seq OWNED BY musicbrainz.area_alias_type.id;


--
-- Name: area_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.area_annotation (
    area integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.area_annotation OWNER TO musicbrainz;

--
-- Name: area_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.area_attribute (
    id integer NOT NULL,
    area integer NOT NULL,
    area_attribute_type integer NOT NULL,
    area_attribute_type_allowed_value integer,
    area_attribute_text text,
    CONSTRAINT area_attribute_check CHECK ((((area_attribute_type_allowed_value IS NULL) AND (area_attribute_text IS NOT NULL)) OR ((area_attribute_type_allowed_value IS NOT NULL) AND (area_attribute_text IS NULL))))
);


ALTER TABLE musicbrainz.area_attribute OWNER TO musicbrainz;

--
-- Name: area_attribute_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.area_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.area_attribute_id_seq OWNER TO musicbrainz;

--
-- Name: area_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.area_attribute_id_seq OWNED BY musicbrainz.area_attribute.id;


--
-- Name: area_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.area_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.area_attribute_type OWNER TO musicbrainz;

--
-- Name: area_attribute_type_allowed_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.area_attribute_type_allowed_value (
    id integer NOT NULL,
    area_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.area_attribute_type_allowed_value OWNER TO musicbrainz;

--
-- Name: area_attribute_type_allowed_value_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.area_attribute_type_allowed_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.area_attribute_type_allowed_value_id_seq OWNER TO musicbrainz;

--
-- Name: area_attribute_type_allowed_value_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.area_attribute_type_allowed_value_id_seq OWNED BY musicbrainz.area_attribute_type_allowed_value.id;


--
-- Name: area_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.area_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.area_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: area_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.area_attribute_type_id_seq OWNED BY musicbrainz.area_attribute_type.id;


--
-- Name: area_containment; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.area_containment (
    descendant integer NOT NULL,
    parent integer NOT NULL,
    depth smallint NOT NULL
);


ALTER TABLE musicbrainz.area_containment OWNER TO musicbrainz;

--
-- Name: area_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.area_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.area_gid_redirect OWNER TO musicbrainz;

--
-- Name: area_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.area_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.area_id_seq OWNER TO musicbrainz;

--
-- Name: area_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.area_id_seq OWNED BY musicbrainz.area.id;


--
-- Name: area_tag; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.area_tag (
    area integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.area_tag OWNER TO musicbrainz;

--
-- Name: area_tag_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.area_tag_raw (
    area integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);


ALTER TABLE musicbrainz.area_tag_raw OWNER TO musicbrainz;

--
-- Name: area_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.area_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.area_type OWNER TO musicbrainz;

--
-- Name: area_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.area_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.area_type_id_seq OWNER TO musicbrainz;

--
-- Name: area_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.area_type_id_seq OWNED BY musicbrainz.area_type.id;


--
-- Name: artist; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    type integer,
    area integer,
    gender integer,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    ended boolean DEFAULT false NOT NULL,
    begin_area integer,
    end_area integer,
    CONSTRAINT artist_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT artist_ended_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL))))
);


ALTER TABLE musicbrainz.artist OWNER TO musicbrainz;

--
-- Name: artist_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_alias (
    id integer NOT NULL,
    artist integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT artist_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT artist_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 3) OR ((type = 3) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL))))
);


ALTER TABLE musicbrainz.artist_alias OWNER TO musicbrainz;

--
-- Name: artist_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.artist_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.artist_alias_id_seq OWNER TO musicbrainz;

--
-- Name: artist_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.artist_alias_id_seq OWNED BY musicbrainz.artist_alias.id;


--
-- Name: artist_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.artist_alias_type OWNER TO musicbrainz;

--
-- Name: artist_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.artist_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.artist_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: artist_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.artist_alias_type_id_seq OWNED BY musicbrainz.artist_alias_type.id;


--
-- Name: artist_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_annotation (
    artist integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.artist_annotation OWNER TO musicbrainz;

--
-- Name: artist_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_attribute (
    id integer NOT NULL,
    artist integer NOT NULL,
    artist_attribute_type integer NOT NULL,
    artist_attribute_type_allowed_value integer,
    artist_attribute_text text,
    CONSTRAINT artist_attribute_check CHECK ((((artist_attribute_type_allowed_value IS NULL) AND (artist_attribute_text IS NOT NULL)) OR ((artist_attribute_type_allowed_value IS NOT NULL) AND (artist_attribute_text IS NULL))))
);


ALTER TABLE musicbrainz.artist_attribute OWNER TO musicbrainz;

--
-- Name: artist_attribute_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.artist_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.artist_attribute_id_seq OWNER TO musicbrainz;

--
-- Name: artist_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.artist_attribute_id_seq OWNED BY musicbrainz.artist_attribute.id;


--
-- Name: artist_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.artist_attribute_type OWNER TO musicbrainz;

--
-- Name: artist_attribute_type_allowed_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_attribute_type_allowed_value (
    id integer NOT NULL,
    artist_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.artist_attribute_type_allowed_value OWNER TO musicbrainz;

--
-- Name: artist_attribute_type_allowed_value_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.artist_attribute_type_allowed_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.artist_attribute_type_allowed_value_id_seq OWNER TO musicbrainz;

--
-- Name: artist_attribute_type_allowed_value_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.artist_attribute_type_allowed_value_id_seq OWNED BY musicbrainz.artist_attribute_type_allowed_value.id;


--
-- Name: artist_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.artist_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.artist_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: artist_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.artist_attribute_type_id_seq OWNED BY musicbrainz.artist_attribute_type.id;


--
-- Name: artist_credit; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_credit (
    id integer NOT NULL,
    name character varying NOT NULL,
    artist_count smallint NOT NULL,
    ref_count integer DEFAULT 0,
    created timestamp with time zone DEFAULT now(),
    edits_pending integer DEFAULT 0 NOT NULL,
    gid uuid NOT NULL,
    CONSTRAINT artist_credit_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.artist_credit OWNER TO musicbrainz;

--
-- Name: artist_credit_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_credit_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.artist_credit_gid_redirect OWNER TO musicbrainz;

--
-- Name: artist_credit_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.artist_credit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.artist_credit_id_seq OWNER TO musicbrainz;

--
-- Name: artist_credit_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.artist_credit_id_seq OWNED BY musicbrainz.artist_credit.id;


--
-- Name: artist_credit_name; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_credit_name (
    artist_credit integer NOT NULL,
    "position" smallint NOT NULL,
    artist integer NOT NULL,
    name character varying NOT NULL,
    join_phrase text DEFAULT ''::text NOT NULL
);


ALTER TABLE musicbrainz.artist_credit_name OWNER TO musicbrainz;

--
-- Name: artist_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.artist_gid_redirect OWNER TO musicbrainz;

--
-- Name: artist_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.artist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.artist_id_seq OWNER TO musicbrainz;

--
-- Name: artist_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.artist_id_seq OWNED BY musicbrainz.artist.id;


--
-- Name: artist_ipi; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_ipi (
    artist integer NOT NULL,
    ipi character(11) NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT artist_ipi_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT artist_ipi_ipi_check CHECK ((ipi ~ '^\d{11}$'::text))
);


ALTER TABLE musicbrainz.artist_ipi OWNER TO musicbrainz;

--
-- Name: artist_isni; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_isni (
    artist integer NOT NULL,
    isni character(16) NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT artist_isni_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT artist_isni_isni_check CHECK ((isni ~ '^\d{15}[\dX]$'::text))
);


ALTER TABLE musicbrainz.artist_isni OWNER TO musicbrainz;

--
-- Name: artist_meta; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_meta (
    id integer NOT NULL,
    rating smallint,
    rating_count integer,
    CONSTRAINT artist_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.artist_meta OWNER TO musicbrainz;

--
-- Name: artist_rating_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_rating_raw (
    artist integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT artist_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.artist_rating_raw OWNER TO musicbrainz;

--
-- Name: artist_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_release (
    is_track_artist boolean NOT NULL,
    artist integer NOT NULL,
    first_release_date integer,
    catalog_numbers text[],
    country_code character(2),
    barcode bigint,
    name character varying NOT NULL COLLATE musicbrainz.musicbrainz,
    release integer NOT NULL
)
PARTITION BY LIST (is_track_artist);


ALTER TABLE musicbrainz.artist_release OWNER TO musicbrainz;

--
-- Name: artist_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_release_group (
    is_track_artist boolean NOT NULL,
    artist integer NOT NULL,
    unofficial boolean NOT NULL,
    primary_type_child_order smallint,
    primary_type smallint,
    secondary_type_child_orders smallint[],
    secondary_types smallint[],
    first_release_date integer,
    name character varying NOT NULL COLLATE musicbrainz.musicbrainz,
    release_group integer NOT NULL
)
PARTITION BY LIST (is_track_artist);


ALTER TABLE musicbrainz.artist_release_group OWNER TO musicbrainz;

--
-- Name: artist_release_group_nonva; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_release_group_nonva (
    is_track_artist boolean NOT NULL,
    artist integer NOT NULL,
    unofficial boolean NOT NULL,
    primary_type_child_order smallint,
    primary_type smallint,
    secondary_type_child_orders smallint[],
    secondary_types smallint[],
    first_release_date integer,
    name character varying NOT NULL COLLATE musicbrainz.musicbrainz,
    release_group integer NOT NULL
);


ALTER TABLE musicbrainz.artist_release_group_nonva OWNER TO musicbrainz;

--
-- Name: artist_release_group_pending_update; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_release_group_pending_update (
    release_group integer NOT NULL
);


ALTER TABLE musicbrainz.artist_release_group_pending_update OWNER TO musicbrainz;

--
-- Name: artist_release_group_va; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_release_group_va (
    is_track_artist boolean NOT NULL,
    artist integer NOT NULL,
    unofficial boolean NOT NULL,
    primary_type_child_order smallint,
    primary_type smallint,
    secondary_type_child_orders smallint[],
    secondary_types smallint[],
    first_release_date integer,
    name character varying NOT NULL COLLATE musicbrainz.musicbrainz,
    release_group integer NOT NULL
);


ALTER TABLE musicbrainz.artist_release_group_va OWNER TO musicbrainz;

--
-- Name: artist_release_nonva; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_release_nonva (
    is_track_artist boolean NOT NULL,
    artist integer NOT NULL,
    first_release_date integer,
    catalog_numbers text[],
    country_code character(2),
    barcode bigint,
    name character varying NOT NULL COLLATE musicbrainz.musicbrainz,
    release integer NOT NULL
);


ALTER TABLE musicbrainz.artist_release_nonva OWNER TO musicbrainz;

--
-- Name: artist_release_pending_update; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_release_pending_update (
    release integer NOT NULL
);


ALTER TABLE musicbrainz.artist_release_pending_update OWNER TO musicbrainz;

--
-- Name: artist_release_va; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_release_va (
    is_track_artist boolean NOT NULL,
    artist integer NOT NULL,
    first_release_date integer,
    catalog_numbers text[],
    country_code character(2),
    barcode bigint,
    name character varying NOT NULL COLLATE musicbrainz.musicbrainz,
    release integer NOT NULL
);


ALTER TABLE musicbrainz.artist_release_va OWNER TO musicbrainz;

--
-- Name: artist_tag; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_tag (
    artist integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.artist_tag OWNER TO musicbrainz;

--
-- Name: artist_tag_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_tag_raw (
    artist integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);


ALTER TABLE musicbrainz.artist_tag_raw OWNER TO musicbrainz;

--
-- Name: artist_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.artist_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.artist_type OWNER TO musicbrainz;

--
-- Name: artist_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.artist_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.artist_type_id_seq OWNER TO musicbrainz;

--
-- Name: artist_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.artist_type_id_seq OWNED BY musicbrainz.artist_type.id;


--
-- Name: autoeditor_election; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.autoeditor_election (
    id integer NOT NULL,
    candidate integer NOT NULL,
    proposer integer NOT NULL,
    seconder_1 integer,
    seconder_2 integer,
    status integer DEFAULT 1 NOT NULL,
    yes_votes integer DEFAULT 0 NOT NULL,
    no_votes integer DEFAULT 0 NOT NULL,
    propose_time timestamp with time zone DEFAULT now() NOT NULL,
    open_time timestamp with time zone,
    close_time timestamp with time zone,
    CONSTRAINT autoeditor_election_status_check CHECK ((status = ANY (ARRAY[1, 2, 3, 4, 5, 6])))
);


ALTER TABLE musicbrainz.autoeditor_election OWNER TO musicbrainz;

--
-- Name: autoeditor_election_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.autoeditor_election_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.autoeditor_election_id_seq OWNER TO musicbrainz;

--
-- Name: autoeditor_election_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.autoeditor_election_id_seq OWNED BY musicbrainz.autoeditor_election.id;


--
-- Name: autoeditor_election_vote; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.autoeditor_election_vote (
    id integer NOT NULL,
    autoeditor_election integer NOT NULL,
    voter integer NOT NULL,
    vote integer NOT NULL,
    vote_time timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT autoeditor_election_vote_vote_check CHECK ((vote = ANY (ARRAY['-1'::integer, 0, 1])))
);


ALTER TABLE musicbrainz.autoeditor_election_vote OWNER TO musicbrainz;

--
-- Name: autoeditor_election_vote_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.autoeditor_election_vote_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.autoeditor_election_vote_id_seq OWNER TO musicbrainz;

--
-- Name: autoeditor_election_vote_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.autoeditor_election_vote_id_seq OWNED BY musicbrainz.autoeditor_election_vote.id;


--
-- Name: cdtoc; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.cdtoc (
    id integer NOT NULL,
    discid character(28) NOT NULL,
    freedb_id character(8) NOT NULL,
    track_count integer NOT NULL,
    leadout_offset integer NOT NULL,
    track_offset integer[] NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.cdtoc OWNER TO musicbrainz;

--
-- Name: cdtoc_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.cdtoc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.cdtoc_id_seq OWNER TO musicbrainz;

--
-- Name: cdtoc_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.cdtoc_id_seq OWNED BY musicbrainz.cdtoc.id;


--
-- Name: cdtoc_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.cdtoc_raw (
    id integer NOT NULL,
    release integer NOT NULL,
    discid character(28) NOT NULL,
    track_count integer NOT NULL,
    leadout_offset integer NOT NULL,
    track_offset integer[] NOT NULL
);


ALTER TABLE musicbrainz.cdtoc_raw OWNER TO musicbrainz;

--
-- Name: cdtoc_raw_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.cdtoc_raw_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.cdtoc_raw_id_seq OWNER TO musicbrainz;

--
-- Name: cdtoc_raw_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.cdtoc_raw_id_seq OWNED BY musicbrainz.cdtoc_raw.id;


--
-- Name: country_area; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.country_area (
    area integer
);


ALTER TABLE musicbrainz.country_area OWNER TO musicbrainz;

--
-- Name: deleted_entity; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.deleted_entity (
    gid uuid NOT NULL,
    data jsonb NOT NULL,
    deleted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE musicbrainz.deleted_entity OWNER TO musicbrainz;

--
-- Name: edit; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit (
    id integer NOT NULL,
    editor integer NOT NULL,
    type smallint NOT NULL,
    status smallint NOT NULL,
    autoedit smallint DEFAULT 0 NOT NULL,
    open_time timestamp with time zone DEFAULT now(),
    close_time timestamp with time zone,
    expire_time timestamp with time zone NOT NULL,
    language integer,
    quality smallint DEFAULT 1 NOT NULL
);


ALTER TABLE musicbrainz.edit OWNER TO musicbrainz;

--
-- Name: edit_area; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_area (
    edit integer NOT NULL,
    area integer NOT NULL
);


ALTER TABLE musicbrainz.edit_area OWNER TO musicbrainz;

--
-- Name: edit_artist; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_artist (
    edit integer NOT NULL,
    artist integer NOT NULL,
    status smallint NOT NULL
);


ALTER TABLE musicbrainz.edit_artist OWNER TO musicbrainz;

--
-- Name: edit_data; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_data (
    edit integer NOT NULL,
    data jsonb NOT NULL
);


ALTER TABLE musicbrainz.edit_data OWNER TO musicbrainz;

--
-- Name: edit_event; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_event (
    edit integer NOT NULL,
    event integer NOT NULL
);


ALTER TABLE musicbrainz.edit_event OWNER TO musicbrainz;

--
-- Name: edit_genre; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_genre (
    edit integer NOT NULL,
    genre integer NOT NULL
);


ALTER TABLE musicbrainz.edit_genre OWNER TO musicbrainz;

--
-- Name: edit_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.edit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.edit_id_seq OWNER TO musicbrainz;

--
-- Name: edit_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.edit_id_seq OWNED BY musicbrainz.edit.id;


--
-- Name: edit_instrument; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_instrument (
    edit integer NOT NULL,
    instrument integer NOT NULL
);


ALTER TABLE musicbrainz.edit_instrument OWNER TO musicbrainz;

--
-- Name: edit_label; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_label (
    edit integer NOT NULL,
    label integer NOT NULL,
    status smallint NOT NULL
);


ALTER TABLE musicbrainz.edit_label OWNER TO musicbrainz;

--
-- Name: edit_mood; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_mood (
    edit integer NOT NULL,
    mood integer NOT NULL
);


ALTER TABLE musicbrainz.edit_mood OWNER TO musicbrainz;

--
-- Name: edit_note; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_note (
    id integer NOT NULL,
    editor integer NOT NULL,
    edit integer NOT NULL,
    text text NOT NULL,
    post_time timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.edit_note OWNER TO musicbrainz;

--
-- Name: edit_note_change; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_note_change (
    id integer NOT NULL,
    status musicbrainz.edit_note_status,
    edit_note integer NOT NULL,
    change_editor integer NOT NULL,
    change_time timestamp with time zone DEFAULT now(),
    old_note text NOT NULL,
    new_note text NOT NULL,
    reason text DEFAULT ''::text NOT NULL
);


ALTER TABLE musicbrainz.edit_note_change OWNER TO musicbrainz;

--
-- Name: edit_note_change_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.edit_note_change_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.edit_note_change_id_seq OWNER TO musicbrainz;

--
-- Name: edit_note_change_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.edit_note_change_id_seq OWNED BY musicbrainz.edit_note_change.id;


--
-- Name: edit_note_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.edit_note_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.edit_note_id_seq OWNER TO musicbrainz;

--
-- Name: edit_note_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.edit_note_id_seq OWNED BY musicbrainz.edit_note.id;


--
-- Name: edit_note_recipient; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_note_recipient (
    recipient integer NOT NULL,
    edit_note integer NOT NULL
);


ALTER TABLE musicbrainz.edit_note_recipient OWNER TO musicbrainz;

--
-- Name: edit_place; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_place (
    edit integer NOT NULL,
    place integer NOT NULL
);


ALTER TABLE musicbrainz.edit_place OWNER TO musicbrainz;

--
-- Name: edit_recording; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_recording (
    edit integer NOT NULL,
    recording integer NOT NULL
);


ALTER TABLE musicbrainz.edit_recording OWNER TO musicbrainz;

--
-- Name: edit_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_release (
    edit integer NOT NULL,
    release integer NOT NULL
);


ALTER TABLE musicbrainz.edit_release OWNER TO musicbrainz;

--
-- Name: edit_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_release_group (
    edit integer NOT NULL,
    release_group integer NOT NULL
);


ALTER TABLE musicbrainz.edit_release_group OWNER TO musicbrainz;

--
-- Name: edit_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_series (
    edit integer NOT NULL,
    series integer NOT NULL
);


ALTER TABLE musicbrainz.edit_series OWNER TO musicbrainz;

--
-- Name: edit_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_url (
    edit integer NOT NULL,
    url integer NOT NULL
);


ALTER TABLE musicbrainz.edit_url OWNER TO musicbrainz;

--
-- Name: edit_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.edit_work (
    edit integer NOT NULL,
    work integer NOT NULL
);


ALTER TABLE musicbrainz.edit_work OWNER TO musicbrainz;

--
-- Name: editor; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    privs integer DEFAULT 0,
    email character varying(64) DEFAULT NULL::character varying,
    website character varying(255) DEFAULT NULL::character varying,
    bio text,
    member_since timestamp with time zone DEFAULT now(),
    email_confirm_date timestamp with time zone,
    last_login_date timestamp with time zone DEFAULT now(),
    last_updated timestamp with time zone DEFAULT now(),
    birth_date date,
    gender integer,
    area integer,
    password character varying(128) NOT NULL,
    ha1 character(32) NOT NULL,
    deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE musicbrainz.editor OWNER TO musicbrainz;

--
-- Name: editor_collection; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection (
    id integer NOT NULL,
    gid uuid NOT NULL,
    editor integer NOT NULL,
    name character varying NOT NULL,
    public boolean DEFAULT false NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    type integer NOT NULL
);


ALTER TABLE musicbrainz.editor_collection OWNER TO musicbrainz;

--
-- Name: editor_collection_area; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_area (
    collection integer NOT NULL,
    area integer NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_area_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_area OWNER TO musicbrainz;

--
-- Name: editor_collection_artist; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_artist (
    collection integer NOT NULL,
    artist integer NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_artist_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_artist OWNER TO musicbrainz;

--
-- Name: editor_collection_collaborator; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_collaborator (
    collection integer NOT NULL,
    editor integer NOT NULL
);


ALTER TABLE musicbrainz.editor_collection_collaborator OWNER TO musicbrainz;

--
-- Name: editor_collection_deleted_entity; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_deleted_entity (
    collection integer NOT NULL,
    gid uuid NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_deleted_entity_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_deleted_entity OWNER TO musicbrainz;

--
-- Name: editor_collection_event; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_event (
    collection integer NOT NULL,
    event integer NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_event_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_event OWNER TO musicbrainz;

--
-- Name: editor_collection_genre; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_genre (
    collection integer NOT NULL,
    genre integer NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_genre_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_genre OWNER TO musicbrainz;

--
-- Name: editor_collection_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.editor_collection_gid_redirect OWNER TO musicbrainz;

--
-- Name: editor_collection_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.editor_collection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.editor_collection_id_seq OWNER TO musicbrainz;

--
-- Name: editor_collection_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.editor_collection_id_seq OWNED BY musicbrainz.editor_collection.id;


--
-- Name: editor_collection_instrument; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_instrument (
    collection integer NOT NULL,
    instrument integer NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_instrument_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_instrument OWNER TO musicbrainz;

--
-- Name: editor_collection_label; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_label (
    collection integer NOT NULL,
    label integer NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_label_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_label OWNER TO musicbrainz;

--
-- Name: editor_collection_place; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_place (
    collection integer NOT NULL,
    place integer NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_place_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_place OWNER TO musicbrainz;

--
-- Name: editor_collection_recording; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_recording (
    collection integer NOT NULL,
    recording integer NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_recording_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_recording OWNER TO musicbrainz;

--
-- Name: editor_collection_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_release (
    collection integer NOT NULL,
    release integer NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_release_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_release OWNER TO musicbrainz;

--
-- Name: editor_collection_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_release_group (
    collection integer NOT NULL,
    release_group integer NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_release_group_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_release_group OWNER TO musicbrainz;

--
-- Name: editor_collection_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_series (
    collection integer NOT NULL,
    series integer NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_series_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_series OWNER TO musicbrainz;

--
-- Name: editor_collection_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    entity_type character varying(50) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.editor_collection_type OWNER TO musicbrainz;

--
-- Name: editor_collection_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.editor_collection_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.editor_collection_type_id_seq OWNER TO musicbrainz;

--
-- Name: editor_collection_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.editor_collection_type_id_seq OWNED BY musicbrainz.editor_collection_type.id;


--
-- Name: editor_collection_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_collection_work (
    collection integer NOT NULL,
    work integer NOT NULL,
    added timestamp with time zone DEFAULT now(),
    "position" integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    CONSTRAINT editor_collection_work_position_check CHECK (("position" >= 0))
);


ALTER TABLE musicbrainz.editor_collection_work OWNER TO musicbrainz;

--
-- Name: editor_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.editor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.editor_id_seq OWNER TO musicbrainz;

--
-- Name: editor_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.editor_id_seq OWNED BY musicbrainz.editor.id;


--
-- Name: editor_language; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_language (
    editor integer NOT NULL,
    language integer NOT NULL,
    fluency musicbrainz.fluency NOT NULL
);


ALTER TABLE musicbrainz.editor_language OWNER TO musicbrainz;

--
-- Name: editor_oauth_token; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_oauth_token (
    id integer NOT NULL,
    editor integer NOT NULL,
    application integer NOT NULL,
    authorization_code text,
    refresh_token text,
    access_token text,
    expire_time timestamp with time zone NOT NULL,
    scope integer DEFAULT 0 NOT NULL,
    granted timestamp with time zone DEFAULT now() NOT NULL,
    code_challenge text,
    code_challenge_method musicbrainz.oauth_code_challenge_method,
    CONSTRAINT valid_code_challenge CHECK ((((code_challenge IS NULL) = (code_challenge_method IS NULL)) AND ((code_challenge IS NULL) OR (code_challenge ~ '^[A-Za-z0-9.~_-]{43,128}$'::text))))
);


ALTER TABLE musicbrainz.editor_oauth_token OWNER TO musicbrainz;

--
-- Name: editor_oauth_token_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.editor_oauth_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.editor_oauth_token_id_seq OWNER TO musicbrainz;

--
-- Name: editor_oauth_token_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.editor_oauth_token_id_seq OWNED BY musicbrainz.editor_oauth_token.id;


--
-- Name: editor_preference; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_preference (
    id integer NOT NULL,
    editor integer NOT NULL,
    name character varying(50) NOT NULL,
    value character varying(100) NOT NULL
);


ALTER TABLE musicbrainz.editor_preference OWNER TO musicbrainz;

--
-- Name: editor_preference_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.editor_preference_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.editor_preference_id_seq OWNER TO musicbrainz;

--
-- Name: editor_preference_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.editor_preference_id_seq OWNED BY musicbrainz.editor_preference.id;


--
-- Name: editor_subscribe_artist; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_subscribe_artist (
    id integer NOT NULL,
    editor integer NOT NULL,
    artist integer NOT NULL,
    last_edit_sent integer NOT NULL
);


ALTER TABLE musicbrainz.editor_subscribe_artist OWNER TO musicbrainz;

--
-- Name: editor_subscribe_artist_deleted; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_subscribe_artist_deleted (
    editor integer NOT NULL,
    gid uuid NOT NULL,
    deleted_by integer NOT NULL
);


ALTER TABLE musicbrainz.editor_subscribe_artist_deleted OWNER TO musicbrainz;

--
-- Name: editor_subscribe_artist_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.editor_subscribe_artist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.editor_subscribe_artist_id_seq OWNER TO musicbrainz;

--
-- Name: editor_subscribe_artist_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.editor_subscribe_artist_id_seq OWNED BY musicbrainz.editor_subscribe_artist.id;


--
-- Name: editor_subscribe_collection; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_subscribe_collection (
    id integer NOT NULL,
    editor integer NOT NULL,
    collection integer NOT NULL,
    last_edit_sent integer NOT NULL,
    available boolean DEFAULT true NOT NULL,
    last_seen_name character varying(255)
);


ALTER TABLE musicbrainz.editor_subscribe_collection OWNER TO musicbrainz;

--
-- Name: editor_subscribe_collection_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.editor_subscribe_collection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.editor_subscribe_collection_id_seq OWNER TO musicbrainz;

--
-- Name: editor_subscribe_collection_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.editor_subscribe_collection_id_seq OWNED BY musicbrainz.editor_subscribe_collection.id;


--
-- Name: editor_subscribe_editor; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_subscribe_editor (
    id integer NOT NULL,
    editor integer NOT NULL,
    subscribed_editor integer NOT NULL,
    last_edit_sent integer NOT NULL
);


ALTER TABLE musicbrainz.editor_subscribe_editor OWNER TO musicbrainz;

--
-- Name: editor_subscribe_editor_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.editor_subscribe_editor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.editor_subscribe_editor_id_seq OWNER TO musicbrainz;

--
-- Name: editor_subscribe_editor_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.editor_subscribe_editor_id_seq OWNED BY musicbrainz.editor_subscribe_editor.id;


--
-- Name: editor_subscribe_label; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_subscribe_label (
    id integer NOT NULL,
    editor integer NOT NULL,
    label integer NOT NULL,
    last_edit_sent integer NOT NULL
);


ALTER TABLE musicbrainz.editor_subscribe_label OWNER TO musicbrainz;

--
-- Name: editor_subscribe_label_deleted; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_subscribe_label_deleted (
    editor integer NOT NULL,
    gid uuid NOT NULL,
    deleted_by integer NOT NULL
);


ALTER TABLE musicbrainz.editor_subscribe_label_deleted OWNER TO musicbrainz;

--
-- Name: editor_subscribe_label_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.editor_subscribe_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.editor_subscribe_label_id_seq OWNER TO musicbrainz;

--
-- Name: editor_subscribe_label_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.editor_subscribe_label_id_seq OWNED BY musicbrainz.editor_subscribe_label.id;


--
-- Name: editor_subscribe_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_subscribe_series (
    id integer NOT NULL,
    editor integer NOT NULL,
    series integer NOT NULL,
    last_edit_sent integer NOT NULL
);


ALTER TABLE musicbrainz.editor_subscribe_series OWNER TO musicbrainz;

--
-- Name: editor_subscribe_series_deleted; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.editor_subscribe_series_deleted (
    editor integer NOT NULL,
    gid uuid NOT NULL,
    deleted_by integer NOT NULL
);


ALTER TABLE musicbrainz.editor_subscribe_series_deleted OWNER TO musicbrainz;

--
-- Name: editor_subscribe_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.editor_subscribe_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.editor_subscribe_series_id_seq OWNER TO musicbrainz;

--
-- Name: editor_subscribe_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.editor_subscribe_series_id_seq OWNED BY musicbrainz.editor_subscribe_series.id;


--
-- Name: event; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    "time" time without time zone,
    type integer,
    cancelled boolean DEFAULT false NOT NULL,
    setlist text,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT event_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT event_ended_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL))))
);


ALTER TABLE musicbrainz.event OWNER TO musicbrainz;

--
-- Name: event_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event_alias (
    id integer NOT NULL,
    event integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT event_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT event_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL))))
);


ALTER TABLE musicbrainz.event_alias OWNER TO musicbrainz;

--
-- Name: event_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.event_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.event_alias_id_seq OWNER TO musicbrainz;

--
-- Name: event_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.event_alias_id_seq OWNED BY musicbrainz.event_alias.id;


--
-- Name: event_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.event_alias_type OWNER TO musicbrainz;

--
-- Name: event_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.event_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.event_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: event_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.event_alias_type_id_seq OWNED BY musicbrainz.event_alias_type.id;


--
-- Name: event_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event_annotation (
    event integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.event_annotation OWNER TO musicbrainz;

--
-- Name: event_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event_attribute (
    id integer NOT NULL,
    event integer NOT NULL,
    event_attribute_type integer NOT NULL,
    event_attribute_type_allowed_value integer,
    event_attribute_text text,
    CONSTRAINT event_attribute_check CHECK ((((event_attribute_type_allowed_value IS NULL) AND (event_attribute_text IS NOT NULL)) OR ((event_attribute_type_allowed_value IS NOT NULL) AND (event_attribute_text IS NULL))))
);


ALTER TABLE musicbrainz.event_attribute OWNER TO musicbrainz;

--
-- Name: event_attribute_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.event_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.event_attribute_id_seq OWNER TO musicbrainz;

--
-- Name: event_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.event_attribute_id_seq OWNED BY musicbrainz.event_attribute.id;


--
-- Name: event_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.event_attribute_type OWNER TO musicbrainz;

--
-- Name: event_attribute_type_allowed_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event_attribute_type_allowed_value (
    id integer NOT NULL,
    event_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.event_attribute_type_allowed_value OWNER TO musicbrainz;

--
-- Name: event_attribute_type_allowed_value_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.event_attribute_type_allowed_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.event_attribute_type_allowed_value_id_seq OWNER TO musicbrainz;

--
-- Name: event_attribute_type_allowed_value_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.event_attribute_type_allowed_value_id_seq OWNED BY musicbrainz.event_attribute_type_allowed_value.id;


--
-- Name: event_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.event_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.event_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: event_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.event_attribute_type_id_seq OWNED BY musicbrainz.event_attribute_type.id;


--
-- Name: event_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.event_gid_redirect OWNER TO musicbrainz;

--
-- Name: event_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.event_id_seq OWNER TO musicbrainz;

--
-- Name: event_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.event_id_seq OWNED BY musicbrainz.event.id;


--
-- Name: event_meta; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event_meta (
    id integer NOT NULL,
    rating smallint,
    rating_count integer,
    event_art_presence musicbrainz.event_art_presence DEFAULT 'absent'::musicbrainz.event_art_presence NOT NULL,
    CONSTRAINT event_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.event_meta OWNER TO musicbrainz;

--
-- Name: event_rating_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event_rating_raw (
    event integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT event_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.event_rating_raw OWNER TO musicbrainz;

--
-- Name: event_tag; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event_tag (
    event integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.event_tag OWNER TO musicbrainz;

--
-- Name: event_tag_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event_tag_raw (
    event integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);


ALTER TABLE musicbrainz.event_tag_raw OWNER TO musicbrainz;

--
-- Name: event_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.event_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.event_type OWNER TO musicbrainz;

--
-- Name: event_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.event_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.event_type_id_seq OWNER TO musicbrainz;

--
-- Name: event_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.event_type_id_seq OWNED BY musicbrainz.event_type.id;


--
-- Name: gender; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.gender (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.gender OWNER TO musicbrainz;

--
-- Name: gender_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.gender_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.gender_id_seq OWNER TO musicbrainz;

--
-- Name: gender_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.gender_id_seq OWNED BY musicbrainz.gender.id;


--
-- Name: genre; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.genre (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT genre_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.genre OWNER TO musicbrainz;

--
-- Name: genre_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.genre_alias (
    id integer NOT NULL,
    genre integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT genre_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT genre_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL))))
);


ALTER TABLE musicbrainz.genre_alias OWNER TO musicbrainz;

--
-- Name: genre_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.genre_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.genre_alias_id_seq OWNER TO musicbrainz;

--
-- Name: genre_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.genre_alias_id_seq OWNED BY musicbrainz.genre_alias.id;


--
-- Name: genre_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.genre_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.genre_alias_type OWNER TO musicbrainz;

--
-- Name: genre_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.genre_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.genre_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: genre_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.genre_alias_type_id_seq OWNED BY musicbrainz.genre_alias_type.id;


--
-- Name: genre_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.genre_annotation (
    genre integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.genre_annotation OWNER TO musicbrainz;

--
-- Name: genre_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.genre_id_seq OWNER TO musicbrainz;

--
-- Name: genre_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.genre_id_seq OWNED BY musicbrainz.genre.id;


--
-- Name: instrument; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.instrument (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    type integer,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    CONSTRAINT instrument_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.instrument OWNER TO musicbrainz;

--
-- Name: instrument_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.instrument_alias (
    id integer NOT NULL,
    instrument integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT instrument_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT instrument_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL))))
);


ALTER TABLE musicbrainz.instrument_alias OWNER TO musicbrainz;

--
-- Name: instrument_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.instrument_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.instrument_alias_id_seq OWNER TO musicbrainz;

--
-- Name: instrument_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.instrument_alias_id_seq OWNED BY musicbrainz.instrument_alias.id;


--
-- Name: instrument_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.instrument_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.instrument_alias_type OWNER TO musicbrainz;

--
-- Name: instrument_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.instrument_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.instrument_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: instrument_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.instrument_alias_type_id_seq OWNED BY musicbrainz.instrument_alias_type.id;


--
-- Name: instrument_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.instrument_annotation (
    instrument integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.instrument_annotation OWNER TO musicbrainz;

--
-- Name: instrument_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.instrument_attribute (
    id integer NOT NULL,
    instrument integer NOT NULL,
    instrument_attribute_type integer NOT NULL,
    instrument_attribute_type_allowed_value integer,
    instrument_attribute_text text,
    CONSTRAINT instrument_attribute_check CHECK ((((instrument_attribute_type_allowed_value IS NULL) AND (instrument_attribute_text IS NOT NULL)) OR ((instrument_attribute_type_allowed_value IS NOT NULL) AND (instrument_attribute_text IS NULL))))
);


ALTER TABLE musicbrainz.instrument_attribute OWNER TO musicbrainz;

--
-- Name: instrument_attribute_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.instrument_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.instrument_attribute_id_seq OWNER TO musicbrainz;

--
-- Name: instrument_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.instrument_attribute_id_seq OWNED BY musicbrainz.instrument_attribute.id;


--
-- Name: instrument_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.instrument_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.instrument_attribute_type OWNER TO musicbrainz;

--
-- Name: instrument_attribute_type_allowed_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.instrument_attribute_type_allowed_value (
    id integer NOT NULL,
    instrument_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.instrument_attribute_type_allowed_value OWNER TO musicbrainz;

--
-- Name: instrument_attribute_type_allowed_value_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.instrument_attribute_type_allowed_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.instrument_attribute_type_allowed_value_id_seq OWNER TO musicbrainz;

--
-- Name: instrument_attribute_type_allowed_value_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.instrument_attribute_type_allowed_value_id_seq OWNED BY musicbrainz.instrument_attribute_type_allowed_value.id;


--
-- Name: instrument_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.instrument_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.instrument_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: instrument_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.instrument_attribute_type_id_seq OWNED BY musicbrainz.instrument_attribute_type.id;


--
-- Name: instrument_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.instrument_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.instrument_gid_redirect OWNER TO musicbrainz;

--
-- Name: instrument_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.instrument_id_seq OWNER TO musicbrainz;

--
-- Name: instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.instrument_id_seq OWNED BY musicbrainz.instrument.id;


--
-- Name: instrument_tag; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.instrument_tag (
    instrument integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.instrument_tag OWNER TO musicbrainz;

--
-- Name: instrument_tag_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.instrument_tag_raw (
    instrument integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);


ALTER TABLE musicbrainz.instrument_tag_raw OWNER TO musicbrainz;

--
-- Name: instrument_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.instrument_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.instrument_type OWNER TO musicbrainz;

--
-- Name: instrument_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.instrument_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.instrument_type_id_seq OWNER TO musicbrainz;

--
-- Name: instrument_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.instrument_type_id_seq OWNED BY musicbrainz.instrument_type.id;


--
-- Name: iso_3166_1; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.iso_3166_1 (
    area integer NOT NULL,
    code character(2)
);


ALTER TABLE musicbrainz.iso_3166_1 OWNER TO musicbrainz;

--
-- Name: iso_3166_2; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.iso_3166_2 (
    area integer NOT NULL,
    code character varying(10)
);


ALTER TABLE musicbrainz.iso_3166_2 OWNER TO musicbrainz;

--
-- Name: iso_3166_3; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.iso_3166_3 (
    area integer NOT NULL,
    code character(4)
);


ALTER TABLE musicbrainz.iso_3166_3 OWNER TO musicbrainz;

--
-- Name: isrc; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.isrc (
    id integer NOT NULL,
    recording integer NOT NULL,
    isrc character(12) NOT NULL,
    source smallint,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT isrc_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT isrc_isrc_check CHECK ((isrc ~ '^[A-Z]{2}[A-Z0-9]{3}[0-9]{7}$'::text))
);


ALTER TABLE musicbrainz.isrc OWNER TO musicbrainz;

--
-- Name: isrc_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.isrc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.isrc_id_seq OWNER TO musicbrainz;

--
-- Name: isrc_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.isrc_id_seq OWNED BY musicbrainz.isrc.id;


--
-- Name: iswc; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.iswc (
    id integer NOT NULL,
    work integer NOT NULL,
    iswc character(15),
    source smallint,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT iswc_iswc_check CHECK ((iswc ~ '^T-?\d{3}.?\d{3}.?\d{3}[-.]?\d$'::text))
);


ALTER TABLE musicbrainz.iswc OWNER TO musicbrainz;

--
-- Name: iswc_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.iswc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.iswc_id_seq OWNER TO musicbrainz;

--
-- Name: iswc_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.iswc_id_seq OWNED BY musicbrainz.iswc.id;


--
-- Name: l_area_area; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_area (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_area_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_area_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_area OWNER TO musicbrainz;

--
-- Name: l_area_area_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_area_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_area_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_area_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_area_id_seq OWNED BY musicbrainz.l_area_area.id;


--
-- Name: l_area_artist; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_artist (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_artist_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_artist_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_artist OWNER TO musicbrainz;

--
-- Name: l_area_artist_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_artist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_artist_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_artist_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_artist_id_seq OWNED BY musicbrainz.l_area_artist.id;


--
-- Name: l_area_event; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_event (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_event_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_event_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_event OWNER TO musicbrainz;

--
-- Name: l_area_event_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_event_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_event_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_event_id_seq OWNED BY musicbrainz.l_area_event.id;


--
-- Name: l_area_genre; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_genre (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_genre_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_genre_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_genre OWNER TO musicbrainz;

--
-- Name: l_area_genre_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_genre_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_genre_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_genre_id_seq OWNED BY musicbrainz.l_area_genre.id;


--
-- Name: l_area_instrument; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_instrument (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_instrument_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_instrument_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_instrument OWNER TO musicbrainz;

--
-- Name: l_area_instrument_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_instrument_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_instrument_id_seq OWNED BY musicbrainz.l_area_instrument.id;


--
-- Name: l_area_label; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_label (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_label_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_label OWNER TO musicbrainz;

--
-- Name: l_area_label_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_label_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_label_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_label_id_seq OWNED BY musicbrainz.l_area_label.id;


--
-- Name: l_area_mood; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_mood (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_mood_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_mood_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_mood OWNER TO musicbrainz;

--
-- Name: l_area_mood_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_mood_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_mood_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_mood_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_mood_id_seq OWNED BY musicbrainz.l_area_mood.id;


--
-- Name: l_area_place; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_place_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_place OWNER TO musicbrainz;

--
-- Name: l_area_place_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_place_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_place_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_place_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_place_id_seq OWNED BY musicbrainz.l_area_place.id;


--
-- Name: l_area_recording; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_recording_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_recording OWNER TO musicbrainz;

--
-- Name: l_area_recording_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_recording_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_recording_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_recording_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_recording_id_seq OWNED BY musicbrainz.l_area_recording.id;


--
-- Name: l_area_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_release_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_release OWNER TO musicbrainz;

--
-- Name: l_area_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_release_group_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_release_group OWNER TO musicbrainz;

--
-- Name: l_area_release_group_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_release_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_release_group_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_release_group_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_release_group_id_seq OWNED BY musicbrainz.l_area_release_group.id;


--
-- Name: l_area_release_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_release_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_release_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_release_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_release_id_seq OWNED BY musicbrainz.l_area_release.id;


--
-- Name: l_area_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_series_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_series OWNER TO musicbrainz;

--
-- Name: l_area_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_series_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_series_id_seq OWNED BY musicbrainz.l_area_series.id;


--
-- Name: l_area_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_url OWNER TO musicbrainz;

--
-- Name: l_area_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_url_id_seq OWNED BY musicbrainz.l_area_url.id;


--
-- Name: l_area_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_area_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_area_work OWNER TO musicbrainz;

--
-- Name: l_area_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_area_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_area_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_area_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_area_work_id_seq OWNED BY musicbrainz.l_area_work.id;


--
-- Name: l_artist_artist; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_artist (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_artist_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_artist_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_artist OWNER TO musicbrainz;

--
-- Name: l_artist_artist_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_artist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_artist_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_artist_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_artist_id_seq OWNED BY musicbrainz.l_artist_artist.id;


--
-- Name: l_artist_event; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_event (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_event_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_event_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_event OWNER TO musicbrainz;

--
-- Name: l_artist_event_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_event_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_event_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_event_id_seq OWNED BY musicbrainz.l_artist_event.id;


--
-- Name: l_artist_genre; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_genre (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_genre_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_genre_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_genre OWNER TO musicbrainz;

--
-- Name: l_artist_genre_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_genre_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_genre_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_genre_id_seq OWNED BY musicbrainz.l_artist_genre.id;


--
-- Name: l_artist_instrument; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_instrument (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_instrument_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_instrument_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_instrument OWNER TO musicbrainz;

--
-- Name: l_artist_instrument_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_instrument_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_instrument_id_seq OWNED BY musicbrainz.l_artist_instrument.id;


--
-- Name: l_artist_label; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_label (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_label_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_label OWNER TO musicbrainz;

--
-- Name: l_artist_label_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_label_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_label_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_label_id_seq OWNED BY musicbrainz.l_artist_label.id;


--
-- Name: l_artist_mood; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_mood (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_mood_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_mood_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_mood OWNER TO musicbrainz;

--
-- Name: l_artist_mood_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_mood_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_mood_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_mood_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_mood_id_seq OWNED BY musicbrainz.l_artist_mood.id;


--
-- Name: l_artist_place; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_place_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_place OWNER TO musicbrainz;

--
-- Name: l_artist_place_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_place_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_place_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_place_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_place_id_seq OWNED BY musicbrainz.l_artist_place.id;


--
-- Name: l_artist_recording; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_recording_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_recording OWNER TO musicbrainz;

--
-- Name: l_artist_recording_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_recording_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_recording_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_recording_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_recording_id_seq OWNED BY musicbrainz.l_artist_recording.id;


--
-- Name: l_artist_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_release_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_release OWNER TO musicbrainz;

--
-- Name: l_artist_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_release_group_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_release_group OWNER TO musicbrainz;

--
-- Name: l_artist_release_group_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_release_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_release_group_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_release_group_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_release_group_id_seq OWNED BY musicbrainz.l_artist_release_group.id;


--
-- Name: l_artist_release_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_release_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_release_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_release_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_release_id_seq OWNED BY musicbrainz.l_artist_release.id;


--
-- Name: l_artist_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_series_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_series OWNER TO musicbrainz;

--
-- Name: l_artist_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_series_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_series_id_seq OWNED BY musicbrainz.l_artist_series.id;


--
-- Name: l_artist_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_url OWNER TO musicbrainz;

--
-- Name: l_artist_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_url_id_seq OWNED BY musicbrainz.l_artist_url.id;


--
-- Name: l_artist_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_artist_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_artist_work OWNER TO musicbrainz;

--
-- Name: l_artist_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_artist_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_artist_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_artist_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_artist_work_id_seq OWNED BY musicbrainz.l_artist_work.id;


--
-- Name: l_event_event; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_event_event (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_event_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_event_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_event_event OWNER TO musicbrainz;

--
-- Name: l_event_event_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_event_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_event_event_id_seq OWNER TO musicbrainz;

--
-- Name: l_event_event_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_event_event_id_seq OWNED BY musicbrainz.l_event_event.id;


--
-- Name: l_event_genre; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_event_genre (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_genre_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_genre_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_event_genre OWNER TO musicbrainz;

--
-- Name: l_event_genre_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_event_genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_event_genre_id_seq OWNER TO musicbrainz;

--
-- Name: l_event_genre_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_event_genre_id_seq OWNED BY musicbrainz.l_event_genre.id;


--
-- Name: l_event_instrument; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_event_instrument (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_instrument_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_instrument_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_event_instrument OWNER TO musicbrainz;

--
-- Name: l_event_instrument_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_event_instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_event_instrument_id_seq OWNER TO musicbrainz;

--
-- Name: l_event_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_event_instrument_id_seq OWNED BY musicbrainz.l_event_instrument.id;


--
-- Name: l_event_label; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_event_label (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_label_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_event_label OWNER TO musicbrainz;

--
-- Name: l_event_label_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_event_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_event_label_id_seq OWNER TO musicbrainz;

--
-- Name: l_event_label_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_event_label_id_seq OWNED BY musicbrainz.l_event_label.id;


--
-- Name: l_event_mood; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_event_mood (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_mood_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_mood_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_event_mood OWNER TO musicbrainz;

--
-- Name: l_event_mood_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_event_mood_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_event_mood_id_seq OWNER TO musicbrainz;

--
-- Name: l_event_mood_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_event_mood_id_seq OWNED BY musicbrainz.l_event_mood.id;


--
-- Name: l_event_place; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_event_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_place_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_event_place OWNER TO musicbrainz;

--
-- Name: l_event_place_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_event_place_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_event_place_id_seq OWNER TO musicbrainz;

--
-- Name: l_event_place_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_event_place_id_seq OWNED BY musicbrainz.l_event_place.id;


--
-- Name: l_event_recording; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_event_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_recording_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_event_recording OWNER TO musicbrainz;

--
-- Name: l_event_recording_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_event_recording_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_event_recording_id_seq OWNER TO musicbrainz;

--
-- Name: l_event_recording_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_event_recording_id_seq OWNED BY musicbrainz.l_event_recording.id;


--
-- Name: l_event_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_event_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_release_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_event_release OWNER TO musicbrainz;

--
-- Name: l_event_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_event_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_release_group_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_event_release_group OWNER TO musicbrainz;

--
-- Name: l_event_release_group_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_event_release_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_event_release_group_id_seq OWNER TO musicbrainz;

--
-- Name: l_event_release_group_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_event_release_group_id_seq OWNED BY musicbrainz.l_event_release_group.id;


--
-- Name: l_event_release_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_event_release_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_event_release_id_seq OWNER TO musicbrainz;

--
-- Name: l_event_release_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_event_release_id_seq OWNED BY musicbrainz.l_event_release.id;


--
-- Name: l_event_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_event_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_series_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_event_series OWNER TO musicbrainz;

--
-- Name: l_event_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_event_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_event_series_id_seq OWNER TO musicbrainz;

--
-- Name: l_event_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_event_series_id_seq OWNED BY musicbrainz.l_event_series.id;


--
-- Name: l_event_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_event_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_event_url OWNER TO musicbrainz;

--
-- Name: l_event_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_event_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_event_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_event_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_event_url_id_seq OWNED BY musicbrainz.l_event_url.id;


--
-- Name: l_event_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_event_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_event_work OWNER TO musicbrainz;

--
-- Name: l_event_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_event_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_event_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_event_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_event_work_id_seq OWNED BY musicbrainz.l_event_work.id;


--
-- Name: l_genre_genre; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_genre_genre (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_genre_genre_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_genre_genre_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_genre_genre OWNER TO musicbrainz;

--
-- Name: l_genre_genre_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_genre_genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_genre_genre_id_seq OWNER TO musicbrainz;

--
-- Name: l_genre_genre_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_genre_genre_id_seq OWNED BY musicbrainz.l_genre_genre.id;


--
-- Name: l_genre_instrument; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_genre_instrument (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_genre_instrument_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_genre_instrument_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_genre_instrument OWNER TO musicbrainz;

--
-- Name: l_genre_instrument_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_genre_instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_genre_instrument_id_seq OWNER TO musicbrainz;

--
-- Name: l_genre_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_genre_instrument_id_seq OWNED BY musicbrainz.l_genre_instrument.id;


--
-- Name: l_genre_label; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_genre_label (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_genre_label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_genre_label_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_genre_label OWNER TO musicbrainz;

--
-- Name: l_genre_label_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_genre_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_genre_label_id_seq OWNER TO musicbrainz;

--
-- Name: l_genre_label_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_genre_label_id_seq OWNED BY musicbrainz.l_genre_label.id;


--
-- Name: l_genre_mood; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_genre_mood (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_genre_mood_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_genre_mood_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_genre_mood OWNER TO musicbrainz;

--
-- Name: l_genre_mood_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_genre_mood_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_genre_mood_id_seq OWNER TO musicbrainz;

--
-- Name: l_genre_mood_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_genre_mood_id_seq OWNED BY musicbrainz.l_genre_mood.id;


--
-- Name: l_genre_place; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_genre_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_genre_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_genre_place_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_genre_place OWNER TO musicbrainz;

--
-- Name: l_genre_place_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_genre_place_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_genre_place_id_seq OWNER TO musicbrainz;

--
-- Name: l_genre_place_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_genre_place_id_seq OWNED BY musicbrainz.l_genre_place.id;


--
-- Name: l_genre_recording; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_genre_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_genre_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_genre_recording_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_genre_recording OWNER TO musicbrainz;

--
-- Name: l_genre_recording_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_genre_recording_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_genre_recording_id_seq OWNER TO musicbrainz;

--
-- Name: l_genre_recording_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_genre_recording_id_seq OWNED BY musicbrainz.l_genre_recording.id;


--
-- Name: l_genre_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_genre_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_genre_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_genre_release_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_genre_release OWNER TO musicbrainz;

--
-- Name: l_genre_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_genre_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_genre_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_genre_release_group_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_genre_release_group OWNER TO musicbrainz;

--
-- Name: l_genre_release_group_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_genre_release_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_genre_release_group_id_seq OWNER TO musicbrainz;

--
-- Name: l_genre_release_group_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_genre_release_group_id_seq OWNED BY musicbrainz.l_genre_release_group.id;


--
-- Name: l_genre_release_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_genre_release_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_genre_release_id_seq OWNER TO musicbrainz;

--
-- Name: l_genre_release_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_genre_release_id_seq OWNED BY musicbrainz.l_genre_release.id;


--
-- Name: l_genre_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_genre_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_genre_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_genre_series_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_genre_series OWNER TO musicbrainz;

--
-- Name: l_genre_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_genre_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_genre_series_id_seq OWNER TO musicbrainz;

--
-- Name: l_genre_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_genre_series_id_seq OWNED BY musicbrainz.l_genre_series.id;


--
-- Name: l_genre_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_genre_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_genre_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_genre_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_genre_url OWNER TO musicbrainz;

--
-- Name: l_genre_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_genre_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_genre_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_genre_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_genre_url_id_seq OWNED BY musicbrainz.l_genre_url.id;


--
-- Name: l_genre_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_genre_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_genre_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_genre_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_genre_work OWNER TO musicbrainz;

--
-- Name: l_genre_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_genre_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_genre_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_genre_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_genre_work_id_seq OWNED BY musicbrainz.l_genre_work.id;


--
-- Name: l_instrument_instrument; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_instrument_instrument (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_instrument_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_instrument_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_instrument_instrument OWNER TO musicbrainz;

--
-- Name: l_instrument_instrument_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_instrument_instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_instrument_instrument_id_seq OWNER TO musicbrainz;

--
-- Name: l_instrument_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_instrument_instrument_id_seq OWNED BY musicbrainz.l_instrument_instrument.id;


--
-- Name: l_instrument_label; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_instrument_label (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_label_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_instrument_label OWNER TO musicbrainz;

--
-- Name: l_instrument_label_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_instrument_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_instrument_label_id_seq OWNER TO musicbrainz;

--
-- Name: l_instrument_label_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_instrument_label_id_seq OWNED BY musicbrainz.l_instrument_label.id;


--
-- Name: l_instrument_mood; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_instrument_mood (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_mood_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_mood_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_instrument_mood OWNER TO musicbrainz;

--
-- Name: l_instrument_mood_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_instrument_mood_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_instrument_mood_id_seq OWNER TO musicbrainz;

--
-- Name: l_instrument_mood_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_instrument_mood_id_seq OWNED BY musicbrainz.l_instrument_mood.id;


--
-- Name: l_instrument_place; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_instrument_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_place_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_instrument_place OWNER TO musicbrainz;

--
-- Name: l_instrument_place_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_instrument_place_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_instrument_place_id_seq OWNER TO musicbrainz;

--
-- Name: l_instrument_place_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_instrument_place_id_seq OWNED BY musicbrainz.l_instrument_place.id;


--
-- Name: l_instrument_recording; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_instrument_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_recording_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_instrument_recording OWNER TO musicbrainz;

--
-- Name: l_instrument_recording_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_instrument_recording_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_instrument_recording_id_seq OWNER TO musicbrainz;

--
-- Name: l_instrument_recording_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_instrument_recording_id_seq OWNED BY musicbrainz.l_instrument_recording.id;


--
-- Name: l_instrument_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_instrument_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_release_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_instrument_release OWNER TO musicbrainz;

--
-- Name: l_instrument_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_instrument_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_release_group_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_instrument_release_group OWNER TO musicbrainz;

--
-- Name: l_instrument_release_group_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_instrument_release_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_instrument_release_group_id_seq OWNER TO musicbrainz;

--
-- Name: l_instrument_release_group_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_instrument_release_group_id_seq OWNED BY musicbrainz.l_instrument_release_group.id;


--
-- Name: l_instrument_release_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_instrument_release_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_instrument_release_id_seq OWNER TO musicbrainz;

--
-- Name: l_instrument_release_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_instrument_release_id_seq OWNED BY musicbrainz.l_instrument_release.id;


--
-- Name: l_instrument_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_instrument_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_series_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_instrument_series OWNER TO musicbrainz;

--
-- Name: l_instrument_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_instrument_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_instrument_series_id_seq OWNER TO musicbrainz;

--
-- Name: l_instrument_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_instrument_series_id_seq OWNED BY musicbrainz.l_instrument_series.id;


--
-- Name: l_instrument_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_instrument_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_instrument_url OWNER TO musicbrainz;

--
-- Name: l_instrument_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_instrument_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_instrument_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_instrument_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_instrument_url_id_seq OWNED BY musicbrainz.l_instrument_url.id;


--
-- Name: l_instrument_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_instrument_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_instrument_work OWNER TO musicbrainz;

--
-- Name: l_instrument_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_instrument_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_instrument_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_instrument_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_instrument_work_id_seq OWNED BY musicbrainz.l_instrument_work.id;


--
-- Name: l_label_label; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_label_label (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_label_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_label_label OWNER TO musicbrainz;

--
-- Name: l_label_label_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_label_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_label_label_id_seq OWNER TO musicbrainz;

--
-- Name: l_label_label_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_label_label_id_seq OWNED BY musicbrainz.l_label_label.id;


--
-- Name: l_label_mood; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_label_mood (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_mood_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_mood_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_label_mood OWNER TO musicbrainz;

--
-- Name: l_label_mood_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_label_mood_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_label_mood_id_seq OWNER TO musicbrainz;

--
-- Name: l_label_mood_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_label_mood_id_seq OWNED BY musicbrainz.l_label_mood.id;


--
-- Name: l_label_place; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_label_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_place_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_label_place OWNER TO musicbrainz;

--
-- Name: l_label_place_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_label_place_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_label_place_id_seq OWNER TO musicbrainz;

--
-- Name: l_label_place_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_label_place_id_seq OWNED BY musicbrainz.l_label_place.id;


--
-- Name: l_label_recording; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_label_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_recording_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_label_recording OWNER TO musicbrainz;

--
-- Name: l_label_recording_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_label_recording_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_label_recording_id_seq OWNER TO musicbrainz;

--
-- Name: l_label_recording_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_label_recording_id_seq OWNED BY musicbrainz.l_label_recording.id;


--
-- Name: l_label_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_label_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_release_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_label_release OWNER TO musicbrainz;

--
-- Name: l_label_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_label_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_release_group_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_label_release_group OWNER TO musicbrainz;

--
-- Name: l_label_release_group_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_label_release_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_label_release_group_id_seq OWNER TO musicbrainz;

--
-- Name: l_label_release_group_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_label_release_group_id_seq OWNED BY musicbrainz.l_label_release_group.id;


--
-- Name: l_label_release_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_label_release_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_label_release_id_seq OWNER TO musicbrainz;

--
-- Name: l_label_release_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_label_release_id_seq OWNED BY musicbrainz.l_label_release.id;


--
-- Name: l_label_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_label_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_series_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_label_series OWNER TO musicbrainz;

--
-- Name: l_label_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_label_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_label_series_id_seq OWNER TO musicbrainz;

--
-- Name: l_label_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_label_series_id_seq OWNED BY musicbrainz.l_label_series.id;


--
-- Name: l_label_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_label_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_label_url OWNER TO musicbrainz;

--
-- Name: l_label_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_label_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_label_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_label_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_label_url_id_seq OWNED BY musicbrainz.l_label_url.id;


--
-- Name: l_label_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_label_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_label_work OWNER TO musicbrainz;

--
-- Name: l_label_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_label_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_label_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_label_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_label_work_id_seq OWNED BY musicbrainz.l_label_work.id;


--
-- Name: l_mood_mood; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_mood_mood (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_mood_mood_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_mood_mood_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_mood_mood OWNER TO musicbrainz;

--
-- Name: l_mood_mood_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_mood_mood_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_mood_mood_id_seq OWNER TO musicbrainz;

--
-- Name: l_mood_mood_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_mood_mood_id_seq OWNED BY musicbrainz.l_mood_mood.id;


--
-- Name: l_mood_place; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_mood_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_mood_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_mood_place_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_mood_place OWNER TO musicbrainz;

--
-- Name: l_mood_place_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_mood_place_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_mood_place_id_seq OWNER TO musicbrainz;

--
-- Name: l_mood_place_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_mood_place_id_seq OWNED BY musicbrainz.l_mood_place.id;


--
-- Name: l_mood_recording; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_mood_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_mood_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_mood_recording_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_mood_recording OWNER TO musicbrainz;

--
-- Name: l_mood_recording_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_mood_recording_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_mood_recording_id_seq OWNER TO musicbrainz;

--
-- Name: l_mood_recording_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_mood_recording_id_seq OWNED BY musicbrainz.l_mood_recording.id;


--
-- Name: l_mood_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_mood_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_mood_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_mood_release_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_mood_release OWNER TO musicbrainz;

--
-- Name: l_mood_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_mood_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_mood_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_mood_release_group_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_mood_release_group OWNER TO musicbrainz;

--
-- Name: l_mood_release_group_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_mood_release_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_mood_release_group_id_seq OWNER TO musicbrainz;

--
-- Name: l_mood_release_group_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_mood_release_group_id_seq OWNED BY musicbrainz.l_mood_release_group.id;


--
-- Name: l_mood_release_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_mood_release_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_mood_release_id_seq OWNER TO musicbrainz;

--
-- Name: l_mood_release_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_mood_release_id_seq OWNED BY musicbrainz.l_mood_release.id;


--
-- Name: l_mood_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_mood_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_mood_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_mood_series_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_mood_series OWNER TO musicbrainz;

--
-- Name: l_mood_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_mood_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_mood_series_id_seq OWNER TO musicbrainz;

--
-- Name: l_mood_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_mood_series_id_seq OWNED BY musicbrainz.l_mood_series.id;


--
-- Name: l_mood_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_mood_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_mood_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_mood_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_mood_url OWNER TO musicbrainz;

--
-- Name: l_mood_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_mood_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_mood_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_mood_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_mood_url_id_seq OWNED BY musicbrainz.l_mood_url.id;


--
-- Name: l_mood_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_mood_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_mood_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_mood_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_mood_work OWNER TO musicbrainz;

--
-- Name: l_mood_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_mood_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_mood_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_mood_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_mood_work_id_seq OWNED BY musicbrainz.l_mood_work.id;


--
-- Name: l_place_place; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_place_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_place_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_place_place OWNER TO musicbrainz;

--
-- Name: l_place_place_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_place_place_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_place_place_id_seq OWNER TO musicbrainz;

--
-- Name: l_place_place_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_place_place_id_seq OWNED BY musicbrainz.l_place_place.id;


--
-- Name: l_place_recording; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_place_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_recording_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_place_recording OWNER TO musicbrainz;

--
-- Name: l_place_recording_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_place_recording_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_place_recording_id_seq OWNER TO musicbrainz;

--
-- Name: l_place_recording_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_place_recording_id_seq OWNED BY musicbrainz.l_place_recording.id;


--
-- Name: l_place_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_place_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_release_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_place_release OWNER TO musicbrainz;

--
-- Name: l_place_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_place_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_release_group_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_place_release_group OWNER TO musicbrainz;

--
-- Name: l_place_release_group_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_place_release_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_place_release_group_id_seq OWNER TO musicbrainz;

--
-- Name: l_place_release_group_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_place_release_group_id_seq OWNED BY musicbrainz.l_place_release_group.id;


--
-- Name: l_place_release_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_place_release_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_place_release_id_seq OWNER TO musicbrainz;

--
-- Name: l_place_release_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_place_release_id_seq OWNED BY musicbrainz.l_place_release.id;


--
-- Name: l_place_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_place_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_series_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_place_series OWNER TO musicbrainz;

--
-- Name: l_place_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_place_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_place_series_id_seq OWNER TO musicbrainz;

--
-- Name: l_place_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_place_series_id_seq OWNED BY musicbrainz.l_place_series.id;


--
-- Name: l_place_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_place_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_place_url OWNER TO musicbrainz;

--
-- Name: l_place_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_place_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_place_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_place_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_place_url_id_seq OWNED BY musicbrainz.l_place_url.id;


--
-- Name: l_place_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_place_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_place_work OWNER TO musicbrainz;

--
-- Name: l_place_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_place_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_place_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_place_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_place_work_id_seq OWNED BY musicbrainz.l_place_work.id;


--
-- Name: l_recording_recording; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_recording_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_recording_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_recording_recording_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_recording_recording OWNER TO musicbrainz;

--
-- Name: l_recording_recording_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_recording_recording_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_recording_recording_id_seq OWNER TO musicbrainz;

--
-- Name: l_recording_recording_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_recording_recording_id_seq OWNED BY musicbrainz.l_recording_recording.id;


--
-- Name: l_recording_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_recording_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_recording_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_recording_release_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_recording_release OWNER TO musicbrainz;

--
-- Name: l_recording_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_recording_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_recording_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_recording_release_group_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_recording_release_group OWNER TO musicbrainz;

--
-- Name: l_recording_release_group_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_recording_release_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_recording_release_group_id_seq OWNER TO musicbrainz;

--
-- Name: l_recording_release_group_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_recording_release_group_id_seq OWNED BY musicbrainz.l_recording_release_group.id;


--
-- Name: l_recording_release_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_recording_release_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_recording_release_id_seq OWNER TO musicbrainz;

--
-- Name: l_recording_release_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_recording_release_id_seq OWNED BY musicbrainz.l_recording_release.id;


--
-- Name: l_recording_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_recording_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_recording_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_recording_series_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_recording_series OWNER TO musicbrainz;

--
-- Name: l_recording_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_recording_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_recording_series_id_seq OWNER TO musicbrainz;

--
-- Name: l_recording_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_recording_series_id_seq OWNED BY musicbrainz.l_recording_series.id;


--
-- Name: l_recording_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_recording_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_recording_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_recording_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_recording_url OWNER TO musicbrainz;

--
-- Name: l_recording_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_recording_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_recording_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_recording_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_recording_url_id_seq OWNED BY musicbrainz.l_recording_url.id;


--
-- Name: l_recording_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_recording_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_recording_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_recording_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_recording_work OWNER TO musicbrainz;

--
-- Name: l_recording_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_recording_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_recording_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_recording_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_recording_work_id_seq OWNED BY musicbrainz.l_recording_work.id;


--
-- Name: l_release_group_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_release_group_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_group_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_group_release_group_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_release_group_release_group OWNER TO musicbrainz;

--
-- Name: l_release_group_release_group_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_release_group_release_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_release_group_release_group_id_seq OWNER TO musicbrainz;

--
-- Name: l_release_group_release_group_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_release_group_release_group_id_seq OWNED BY musicbrainz.l_release_group_release_group.id;


--
-- Name: l_release_group_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_release_group_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_group_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_group_series_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_release_group_series OWNER TO musicbrainz;

--
-- Name: l_release_group_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_release_group_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_release_group_series_id_seq OWNER TO musicbrainz;

--
-- Name: l_release_group_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_release_group_series_id_seq OWNED BY musicbrainz.l_release_group_series.id;


--
-- Name: l_release_group_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_release_group_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_group_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_group_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_release_group_url OWNER TO musicbrainz;

--
-- Name: l_release_group_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_release_group_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_release_group_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_release_group_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_release_group_url_id_seq OWNED BY musicbrainz.l_release_group_url.id;


--
-- Name: l_release_group_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_release_group_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_group_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_group_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_release_group_work OWNER TO musicbrainz;

--
-- Name: l_release_group_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_release_group_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_release_group_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_release_group_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_release_group_work_id_seq OWNED BY musicbrainz.l_release_group_work.id;


--
-- Name: l_release_release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_release_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_release_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_release_release OWNER TO musicbrainz;

--
-- Name: l_release_release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_release_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_release_group_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_release_release_group OWNER TO musicbrainz;

--
-- Name: l_release_release_group_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_release_release_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_release_release_group_id_seq OWNER TO musicbrainz;

--
-- Name: l_release_release_group_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_release_release_group_id_seq OWNED BY musicbrainz.l_release_release_group.id;


--
-- Name: l_release_release_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_release_release_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_release_release_id_seq OWNER TO musicbrainz;

--
-- Name: l_release_release_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_release_release_id_seq OWNED BY musicbrainz.l_release_release.id;


--
-- Name: l_release_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_release_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_series_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_release_series OWNER TO musicbrainz;

--
-- Name: l_release_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_release_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_release_series_id_seq OWNER TO musicbrainz;

--
-- Name: l_release_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_release_series_id_seq OWNED BY musicbrainz.l_release_series.id;


--
-- Name: l_release_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_release_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_release_url OWNER TO musicbrainz;

--
-- Name: l_release_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_release_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_release_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_release_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_release_url_id_seq OWNED BY musicbrainz.l_release_url.id;


--
-- Name: l_release_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_release_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_release_work OWNER TO musicbrainz;

--
-- Name: l_release_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_release_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_release_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_release_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_release_work_id_seq OWNED BY musicbrainz.l_release_work.id;


--
-- Name: l_series_series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_series_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_series_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_series_series_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_series_series OWNER TO musicbrainz;

--
-- Name: l_series_series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_series_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_series_series_id_seq OWNER TO musicbrainz;

--
-- Name: l_series_series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_series_series_id_seq OWNED BY musicbrainz.l_series_series.id;


--
-- Name: l_series_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_series_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_series_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_series_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_series_url OWNER TO musicbrainz;

--
-- Name: l_series_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_series_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_series_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_series_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_series_url_id_seq OWNED BY musicbrainz.l_series_url.id;


--
-- Name: l_series_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_series_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_series_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_series_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_series_work OWNER TO musicbrainz;

--
-- Name: l_series_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_series_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_series_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_series_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_series_work_id_seq OWNED BY musicbrainz.l_series_work.id;


--
-- Name: l_url_url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_url_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_url_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_url_url_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_url_url OWNER TO musicbrainz;

--
-- Name: l_url_url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_url_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_url_url_id_seq OWNER TO musicbrainz;

--
-- Name: l_url_url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_url_url_id_seq OWNED BY musicbrainz.l_url_url.id;


--
-- Name: l_url_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_url_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_url_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_url_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_url_work OWNER TO musicbrainz;

--
-- Name: l_url_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_url_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_url_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_url_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_url_work_id_seq OWNED BY musicbrainz.l_url_work.id;


--
-- Name: l_work_work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.l_work_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_work_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_work_work_link_order_check CHECK ((link_order >= 0))
);


ALTER TABLE musicbrainz.l_work_work OWNER TO musicbrainz;

--
-- Name: l_work_work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.l_work_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.l_work_work_id_seq OWNER TO musicbrainz;

--
-- Name: l_work_work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.l_work_work_id_seq OWNED BY musicbrainz.l_work_work.id;


--
-- Name: label; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    label_code integer,
    type integer,
    area integer,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT label_ended_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL))))
);


ALTER TABLE musicbrainz.label OWNER TO musicbrainz;

--
-- Name: label_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_alias (
    id integer NOT NULL,
    label integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT label_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT label_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL))))
);


ALTER TABLE musicbrainz.label_alias OWNER TO musicbrainz;

--
-- Name: label_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.label_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.label_alias_id_seq OWNER TO musicbrainz;

--
-- Name: label_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.label_alias_id_seq OWNED BY musicbrainz.label_alias.id;


--
-- Name: label_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.label_alias_type OWNER TO musicbrainz;

--
-- Name: label_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.label_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.label_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: label_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.label_alias_type_id_seq OWNED BY musicbrainz.label_alias_type.id;


--
-- Name: label_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_annotation (
    label integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.label_annotation OWNER TO musicbrainz;

--
-- Name: label_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_attribute (
    id integer NOT NULL,
    label integer NOT NULL,
    label_attribute_type integer NOT NULL,
    label_attribute_type_allowed_value integer,
    label_attribute_text text,
    CONSTRAINT label_attribute_check CHECK ((((label_attribute_type_allowed_value IS NULL) AND (label_attribute_text IS NOT NULL)) OR ((label_attribute_type_allowed_value IS NOT NULL) AND (label_attribute_text IS NULL))))
);


ALTER TABLE musicbrainz.label_attribute OWNER TO musicbrainz;

--
-- Name: label_attribute_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.label_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.label_attribute_id_seq OWNER TO musicbrainz;

--
-- Name: label_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.label_attribute_id_seq OWNED BY musicbrainz.label_attribute.id;


--
-- Name: label_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.label_attribute_type OWNER TO musicbrainz;

--
-- Name: label_attribute_type_allowed_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_attribute_type_allowed_value (
    id integer NOT NULL,
    label_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.label_attribute_type_allowed_value OWNER TO musicbrainz;

--
-- Name: label_attribute_type_allowed_value_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.label_attribute_type_allowed_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.label_attribute_type_allowed_value_id_seq OWNER TO musicbrainz;

--
-- Name: label_attribute_type_allowed_value_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.label_attribute_type_allowed_value_id_seq OWNED BY musicbrainz.label_attribute_type_allowed_value.id;


--
-- Name: label_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.label_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.label_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: label_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.label_attribute_type_id_seq OWNED BY musicbrainz.label_attribute_type.id;


--
-- Name: label_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.label_gid_redirect OWNER TO musicbrainz;

--
-- Name: label_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.label_id_seq OWNER TO musicbrainz;

--
-- Name: label_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.label_id_seq OWNED BY musicbrainz.label.id;


--
-- Name: label_ipi; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_ipi (
    label integer NOT NULL,
    ipi character(11) NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT label_ipi_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT label_ipi_ipi_check CHECK ((ipi ~ '^\d{11}$'::text))
);


ALTER TABLE musicbrainz.label_ipi OWNER TO musicbrainz;

--
-- Name: label_isni; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_isni (
    label integer NOT NULL,
    isni character(16) NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT label_isni_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT label_isni_isni_check CHECK ((isni ~ '^\d{15}[\dX]$'::text))
);


ALTER TABLE musicbrainz.label_isni OWNER TO musicbrainz;

--
-- Name: label_meta; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_meta (
    id integer NOT NULL,
    rating smallint,
    rating_count integer,
    CONSTRAINT label_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.label_meta OWNER TO musicbrainz;

--
-- Name: label_rating_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_rating_raw (
    label integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT label_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.label_rating_raw OWNER TO musicbrainz;

--
-- Name: label_tag; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_tag (
    label integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.label_tag OWNER TO musicbrainz;

--
-- Name: label_tag_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_tag_raw (
    label integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);


ALTER TABLE musicbrainz.label_tag_raw OWNER TO musicbrainz;

--
-- Name: label_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.label_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.label_type OWNER TO musicbrainz;

--
-- Name: label_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.label_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.label_type_id_seq OWNER TO musicbrainz;

--
-- Name: label_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.label_type_id_seq OWNED BY musicbrainz.label_type.id;


--
-- Name: language; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.language (
    id integer NOT NULL,
    iso_code_2t character(3),
    iso_code_2b character(3),
    iso_code_1 character(2),
    name character varying(100) NOT NULL,
    frequency smallint DEFAULT 0 NOT NULL,
    iso_code_3 character(3),
    CONSTRAINT iso_code_check CHECK (((iso_code_2t IS NOT NULL) OR (iso_code_3 IS NOT NULL)))
);


ALTER TABLE musicbrainz.language OWNER TO musicbrainz;

--
-- Name: language_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.language_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.language_id_seq OWNER TO musicbrainz;

--
-- Name: language_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.language_id_seq OWNED BY musicbrainz.language.id;


--
-- Name: link; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.link (
    id integer NOT NULL,
    link_type integer NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    attribute_count integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT link_ended_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL))))
);


ALTER TABLE musicbrainz.link OWNER TO musicbrainz;

--
-- Name: link_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.link_attribute (
    link integer NOT NULL,
    attribute_type integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.link_attribute OWNER TO musicbrainz;

--
-- Name: link_attribute_credit; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.link_attribute_credit (
    link integer NOT NULL,
    attribute_type integer NOT NULL,
    credited_as text NOT NULL
);


ALTER TABLE musicbrainz.link_attribute_credit OWNER TO musicbrainz;

--
-- Name: link_attribute_text_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.link_attribute_text_value (
    link integer NOT NULL,
    attribute_type integer NOT NULL,
    text_value text NOT NULL
);


ALTER TABLE musicbrainz.link_attribute_text_value OWNER TO musicbrainz;

--
-- Name: link_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.link_attribute_type (
    id integer NOT NULL,
    parent integer,
    root integer NOT NULL,
    child_order integer DEFAULT 0 NOT NULL,
    gid uuid NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.link_attribute_type OWNER TO musicbrainz;

--
-- Name: link_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.link_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.link_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: link_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.link_attribute_type_id_seq OWNED BY musicbrainz.link_attribute_type.id;


--
-- Name: link_creditable_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.link_creditable_attribute_type (
    attribute_type integer NOT NULL
);


ALTER TABLE musicbrainz.link_creditable_attribute_type OWNER TO musicbrainz;

--
-- Name: link_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.link_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.link_id_seq OWNER TO musicbrainz;

--
-- Name: link_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.link_id_seq OWNED BY musicbrainz.link.id;


--
-- Name: link_text_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.link_text_attribute_type (
    attribute_type integer NOT NULL
);


ALTER TABLE musicbrainz.link_text_attribute_type OWNER TO musicbrainz;

--
-- Name: link_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.link_type (
    id integer NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    gid uuid NOT NULL,
    entity_type0 character varying(50) NOT NULL,
    entity_type1 character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    link_phrase character varying(255) NOT NULL,
    reverse_link_phrase character varying(255) NOT NULL,
    long_link_phrase character varying(255) NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    is_deprecated boolean DEFAULT false NOT NULL,
    has_dates boolean DEFAULT true NOT NULL,
    entity0_cardinality smallint DEFAULT 0 NOT NULL,
    entity1_cardinality smallint DEFAULT 0 NOT NULL
);


ALTER TABLE musicbrainz.link_type OWNER TO musicbrainz;

--
-- Name: link_type_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.link_type_attribute_type (
    link_type integer NOT NULL,
    attribute_type integer NOT NULL,
    min smallint,
    max smallint,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.link_type_attribute_type OWNER TO musicbrainz;

--
-- Name: link_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.link_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.link_type_id_seq OWNER TO musicbrainz;

--
-- Name: link_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.link_type_id_seq OWNED BY musicbrainz.link_type.id;


--
-- Name: medium; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.medium (
    id integer NOT NULL,
    release integer NOT NULL,
    "position" integer NOT NULL,
    format integer,
    name character varying DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    track_count integer DEFAULT 0 NOT NULL,
    gid uuid NOT NULL,
    CONSTRAINT medium_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.medium OWNER TO musicbrainz;

--
-- Name: medium_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.medium_attribute (
    id integer NOT NULL,
    medium integer NOT NULL,
    medium_attribute_type integer NOT NULL,
    medium_attribute_type_allowed_value integer,
    medium_attribute_text text,
    CONSTRAINT medium_attribute_check CHECK ((((medium_attribute_type_allowed_value IS NULL) AND (medium_attribute_text IS NOT NULL)) OR ((medium_attribute_type_allowed_value IS NOT NULL) AND (medium_attribute_text IS NULL))))
);


ALTER TABLE musicbrainz.medium_attribute OWNER TO musicbrainz;

--
-- Name: medium_attribute_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.medium_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.medium_attribute_id_seq OWNER TO musicbrainz;

--
-- Name: medium_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.medium_attribute_id_seq OWNED BY musicbrainz.medium_attribute.id;


--
-- Name: medium_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.medium_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.medium_attribute_type OWNER TO musicbrainz;

--
-- Name: medium_attribute_type_allowed_format; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.medium_attribute_type_allowed_format (
    medium_format integer NOT NULL,
    medium_attribute_type integer NOT NULL
);


ALTER TABLE musicbrainz.medium_attribute_type_allowed_format OWNER TO musicbrainz;

--
-- Name: medium_attribute_type_allowed_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.medium_attribute_type_allowed_value (
    id integer NOT NULL,
    medium_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.medium_attribute_type_allowed_value OWNER TO musicbrainz;

--
-- Name: medium_attribute_type_allowed_value_allowed_format; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.medium_attribute_type_allowed_value_allowed_format (
    medium_format integer NOT NULL,
    medium_attribute_type_allowed_value integer NOT NULL
);


ALTER TABLE musicbrainz.medium_attribute_type_allowed_value_allowed_format OWNER TO musicbrainz;

--
-- Name: medium_attribute_type_allowed_value_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.medium_attribute_type_allowed_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.medium_attribute_type_allowed_value_id_seq OWNER TO musicbrainz;

--
-- Name: medium_attribute_type_allowed_value_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.medium_attribute_type_allowed_value_id_seq OWNED BY musicbrainz.medium_attribute_type_allowed_value.id;


--
-- Name: medium_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.medium_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.medium_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: medium_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.medium_attribute_type_id_seq OWNED BY musicbrainz.medium_attribute_type.id;


--
-- Name: medium_cdtoc; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.medium_cdtoc (
    id integer NOT NULL,
    medium integer NOT NULL,
    cdtoc integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT medium_cdtoc_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.medium_cdtoc OWNER TO musicbrainz;

--
-- Name: medium_cdtoc_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.medium_cdtoc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.medium_cdtoc_id_seq OWNER TO musicbrainz;

--
-- Name: medium_cdtoc_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.medium_cdtoc_id_seq OWNED BY musicbrainz.medium_cdtoc.id;


--
-- Name: medium_format; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.medium_format (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    year smallint,
    has_discids boolean DEFAULT false NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.medium_format OWNER TO musicbrainz;

--
-- Name: medium_format_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.medium_format_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.medium_format_id_seq OWNER TO musicbrainz;

--
-- Name: medium_format_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.medium_format_id_seq OWNED BY musicbrainz.medium_format.id;


--
-- Name: medium_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.medium_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.medium_gid_redirect OWNER TO musicbrainz;

--
-- Name: medium_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.medium_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.medium_id_seq OWNER TO musicbrainz;

--
-- Name: medium_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.medium_id_seq OWNED BY musicbrainz.medium.id;


--
-- Name: medium_index; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.medium_index (
    medium integer,
    toc public.cube
);


ALTER TABLE musicbrainz.medium_index OWNER TO musicbrainz;

--
-- Name: mood; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.mood (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT mood_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.mood OWNER TO musicbrainz;

--
-- Name: mood_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.mood_alias (
    id integer NOT NULL,
    mood integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT mood_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT mood_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL))))
);


ALTER TABLE musicbrainz.mood_alias OWNER TO musicbrainz;

--
-- Name: mood_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.mood_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.mood_alias_id_seq OWNER TO musicbrainz;

--
-- Name: mood_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.mood_alias_id_seq OWNED BY musicbrainz.mood_alias.id;


--
-- Name: mood_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.mood_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.mood_alias_type OWNER TO musicbrainz;

--
-- Name: mood_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.mood_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.mood_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: mood_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.mood_alias_type_id_seq OWNED BY musicbrainz.mood_alias_type.id;


--
-- Name: mood_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.mood_annotation (
    mood integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.mood_annotation OWNER TO musicbrainz;

--
-- Name: mood_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.mood_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.mood_id_seq OWNER TO musicbrainz;

--
-- Name: mood_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.mood_id_seq OWNED BY musicbrainz.mood.id;


--
-- Name: old_editor_name; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.old_editor_name (
    name character varying(64) NOT NULL
);


ALTER TABLE musicbrainz.old_editor_name OWNER TO musicbrainz;

--
-- Name: orderable_link_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.orderable_link_type (
    link_type integer NOT NULL,
    direction smallint DEFAULT 1 NOT NULL,
    CONSTRAINT orderable_link_type_direction_check CHECK (((direction = 1) OR (direction = 2)))
);


ALTER TABLE musicbrainz.orderable_link_type OWNER TO musicbrainz;

--
-- Name: place; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    type integer,
    address character varying DEFAULT ''::character varying NOT NULL,
    area integer,
    coordinates point,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT place_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT place_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.place OWNER TO musicbrainz;

--
-- Name: place_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place_alias (
    id integer NOT NULL,
    place integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT place_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT place_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL))))
);


ALTER TABLE musicbrainz.place_alias OWNER TO musicbrainz;

--
-- Name: place_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.place_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.place_alias_id_seq OWNER TO musicbrainz;

--
-- Name: place_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.place_alias_id_seq OWNED BY musicbrainz.place_alias.id;


--
-- Name: place_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.place_alias_type OWNER TO musicbrainz;

--
-- Name: place_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.place_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.place_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: place_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.place_alias_type_id_seq OWNED BY musicbrainz.place_alias_type.id;


--
-- Name: place_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place_annotation (
    place integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.place_annotation OWNER TO musicbrainz;

--
-- Name: place_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place_attribute (
    id integer NOT NULL,
    place integer NOT NULL,
    place_attribute_type integer NOT NULL,
    place_attribute_type_allowed_value integer,
    place_attribute_text text,
    CONSTRAINT place_attribute_check CHECK ((((place_attribute_type_allowed_value IS NULL) AND (place_attribute_text IS NOT NULL)) OR ((place_attribute_type_allowed_value IS NOT NULL) AND (place_attribute_text IS NULL))))
);


ALTER TABLE musicbrainz.place_attribute OWNER TO musicbrainz;

--
-- Name: place_attribute_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.place_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.place_attribute_id_seq OWNER TO musicbrainz;

--
-- Name: place_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.place_attribute_id_seq OWNED BY musicbrainz.place_attribute.id;


--
-- Name: place_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.place_attribute_type OWNER TO musicbrainz;

--
-- Name: place_attribute_type_allowed_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place_attribute_type_allowed_value (
    id integer NOT NULL,
    place_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.place_attribute_type_allowed_value OWNER TO musicbrainz;

--
-- Name: place_attribute_type_allowed_value_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.place_attribute_type_allowed_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.place_attribute_type_allowed_value_id_seq OWNER TO musicbrainz;

--
-- Name: place_attribute_type_allowed_value_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.place_attribute_type_allowed_value_id_seq OWNED BY musicbrainz.place_attribute_type_allowed_value.id;


--
-- Name: place_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.place_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.place_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: place_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.place_attribute_type_id_seq OWNED BY musicbrainz.place_attribute_type.id;


--
-- Name: place_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.place_gid_redirect OWNER TO musicbrainz;

--
-- Name: place_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.place_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.place_id_seq OWNER TO musicbrainz;

--
-- Name: place_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.place_id_seq OWNED BY musicbrainz.place.id;


--
-- Name: place_meta; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place_meta (
    id integer NOT NULL,
    rating smallint,
    rating_count integer,
    CONSTRAINT place_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.place_meta OWNER TO musicbrainz;

--
-- Name: place_rating_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place_rating_raw (
    place integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT place_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.place_rating_raw OWNER TO musicbrainz;

--
-- Name: place_tag; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place_tag (
    place integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.place_tag OWNER TO musicbrainz;

--
-- Name: place_tag_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place_tag_raw (
    place integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);


ALTER TABLE musicbrainz.place_tag_raw OWNER TO musicbrainz;

--
-- Name: place_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.place_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.place_type OWNER TO musicbrainz;

--
-- Name: place_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.place_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.place_type_id_seq OWNER TO musicbrainz;

--
-- Name: place_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.place_type_id_seq OWNED BY musicbrainz.place_type.id;


--
-- Name: recording; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    artist_credit integer NOT NULL,
    length integer,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    video boolean DEFAULT false NOT NULL,
    CONSTRAINT recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT recording_length_check CHECK (((length IS NULL) OR (length > 0)))
);


ALTER TABLE musicbrainz.recording OWNER TO musicbrainz;

--
-- Name: recording_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording_alias (
    id integer NOT NULL,
    recording integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT recording_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT recording_alias_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.recording_alias OWNER TO musicbrainz;

--
-- Name: recording_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.recording_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.recording_alias_id_seq OWNER TO musicbrainz;

--
-- Name: recording_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.recording_alias_id_seq OWNED BY musicbrainz.recording_alias.id;


--
-- Name: recording_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.recording_alias_type OWNER TO musicbrainz;

--
-- Name: recording_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.recording_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.recording_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: recording_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.recording_alias_type_id_seq OWNED BY musicbrainz.recording_alias_type.id;


--
-- Name: recording_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording_annotation (
    recording integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.recording_annotation OWNER TO musicbrainz;

--
-- Name: recording_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording_attribute (
    id integer NOT NULL,
    recording integer NOT NULL,
    recording_attribute_type integer NOT NULL,
    recording_attribute_type_allowed_value integer,
    recording_attribute_text text,
    CONSTRAINT recording_attribute_check CHECK ((((recording_attribute_type_allowed_value IS NULL) AND (recording_attribute_text IS NOT NULL)) OR ((recording_attribute_type_allowed_value IS NOT NULL) AND (recording_attribute_text IS NULL))))
);


ALTER TABLE musicbrainz.recording_attribute OWNER TO musicbrainz;

--
-- Name: recording_attribute_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.recording_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.recording_attribute_id_seq OWNER TO musicbrainz;

--
-- Name: recording_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.recording_attribute_id_seq OWNED BY musicbrainz.recording_attribute.id;


--
-- Name: recording_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.recording_attribute_type OWNER TO musicbrainz;

--
-- Name: recording_attribute_type_allowed_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording_attribute_type_allowed_value (
    id integer NOT NULL,
    recording_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.recording_attribute_type_allowed_value OWNER TO musicbrainz;

--
-- Name: recording_attribute_type_allowed_value_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.recording_attribute_type_allowed_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.recording_attribute_type_allowed_value_id_seq OWNER TO musicbrainz;

--
-- Name: recording_attribute_type_allowed_value_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.recording_attribute_type_allowed_value_id_seq OWNED BY musicbrainz.recording_attribute_type_allowed_value.id;


--
-- Name: recording_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.recording_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.recording_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: recording_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.recording_attribute_type_id_seq OWNED BY musicbrainz.recording_attribute_type.id;


--
-- Name: recording_first_release_date; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording_first_release_date (
    recording integer NOT NULL,
    year smallint,
    month smallint,
    day smallint
);


ALTER TABLE musicbrainz.recording_first_release_date OWNER TO musicbrainz;

--
-- Name: recording_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.recording_gid_redirect OWNER TO musicbrainz;

--
-- Name: recording_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.recording_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.recording_id_seq OWNER TO musicbrainz;

--
-- Name: recording_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.recording_id_seq OWNED BY musicbrainz.recording.id;


--
-- Name: recording_meta; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording_meta (
    id integer NOT NULL,
    rating smallint,
    rating_count integer,
    CONSTRAINT recording_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.recording_meta OWNER TO musicbrainz;

--
-- Name: recording_rating_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording_rating_raw (
    recording integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT recording_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.recording_rating_raw OWNER TO musicbrainz;

--
-- Name: recording_tag; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording_tag (
    recording integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.recording_tag OWNER TO musicbrainz;

--
-- Name: recording_tag_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.recording_tag_raw (
    recording integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);


ALTER TABLE musicbrainz.recording_tag_raw OWNER TO musicbrainz;

--
-- Name: release; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    artist_credit integer NOT NULL,
    release_group integer NOT NULL,
    status integer,
    packaging integer,
    language integer,
    script integer,
    barcode character varying(255),
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    quality smallint DEFAULT '-1'::integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT release_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.release OWNER TO musicbrainz;

--
-- Name: release_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_alias (
    id integer NOT NULL,
    release integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT release_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT release_alias_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.release_alias OWNER TO musicbrainz;

--
-- Name: release_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_alias_id_seq OWNER TO musicbrainz;

--
-- Name: release_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_alias_id_seq OWNED BY musicbrainz.release_alias.id;


--
-- Name: release_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.release_alias_type OWNER TO musicbrainz;

--
-- Name: release_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: release_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_alias_type_id_seq OWNED BY musicbrainz.release_alias_type.id;


--
-- Name: release_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_annotation (
    release integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.release_annotation OWNER TO musicbrainz;

--
-- Name: release_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_attribute (
    id integer NOT NULL,
    release integer NOT NULL,
    release_attribute_type integer NOT NULL,
    release_attribute_type_allowed_value integer,
    release_attribute_text text,
    CONSTRAINT release_attribute_check CHECK ((((release_attribute_type_allowed_value IS NULL) AND (release_attribute_text IS NOT NULL)) OR ((release_attribute_type_allowed_value IS NOT NULL) AND (release_attribute_text IS NULL))))
);


ALTER TABLE musicbrainz.release_attribute OWNER TO musicbrainz;

--
-- Name: release_attribute_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_attribute_id_seq OWNER TO musicbrainz;

--
-- Name: release_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_attribute_id_seq OWNED BY musicbrainz.release_attribute.id;


--
-- Name: release_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.release_attribute_type OWNER TO musicbrainz;

--
-- Name: release_attribute_type_allowed_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_attribute_type_allowed_value (
    id integer NOT NULL,
    release_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.release_attribute_type_allowed_value OWNER TO musicbrainz;

--
-- Name: release_attribute_type_allowed_value_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_attribute_type_allowed_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_attribute_type_allowed_value_id_seq OWNER TO musicbrainz;

--
-- Name: release_attribute_type_allowed_value_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_attribute_type_allowed_value_id_seq OWNED BY musicbrainz.release_attribute_type_allowed_value.id;


--
-- Name: release_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: release_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_attribute_type_id_seq OWNED BY musicbrainz.release_attribute_type.id;


--
-- Name: release_country; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_country (
    release integer NOT NULL,
    country integer NOT NULL,
    date_year smallint,
    date_month smallint,
    date_day smallint
);


ALTER TABLE musicbrainz.release_country OWNER TO musicbrainz;

--
-- Name: release_first_release_date; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_first_release_date (
    release integer NOT NULL,
    year smallint,
    month smallint,
    day smallint
);


ALTER TABLE musicbrainz.release_first_release_date OWNER TO musicbrainz;

--
-- Name: release_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.release_gid_redirect OWNER TO musicbrainz;

--
-- Name: release_group; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    artist_credit integer NOT NULL,
    type integer,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT release_group_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.release_group OWNER TO musicbrainz;

--
-- Name: release_group_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_alias (
    id integer NOT NULL,
    release_group integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT release_group_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT release_group_alias_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.release_group_alias OWNER TO musicbrainz;

--
-- Name: release_group_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_group_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_group_alias_id_seq OWNER TO musicbrainz;

--
-- Name: release_group_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_group_alias_id_seq OWNED BY musicbrainz.release_group_alias.id;


--
-- Name: release_group_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.release_group_alias_type OWNER TO musicbrainz;

--
-- Name: release_group_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_group_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_group_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: release_group_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_group_alias_type_id_seq OWNED BY musicbrainz.release_group_alias_type.id;


--
-- Name: release_group_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_annotation (
    release_group integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.release_group_annotation OWNER TO musicbrainz;

--
-- Name: release_group_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_attribute (
    id integer NOT NULL,
    release_group integer NOT NULL,
    release_group_attribute_type integer NOT NULL,
    release_group_attribute_type_allowed_value integer,
    release_group_attribute_text text,
    CONSTRAINT release_group_attribute_check CHECK ((((release_group_attribute_type_allowed_value IS NULL) AND (release_group_attribute_text IS NOT NULL)) OR ((release_group_attribute_type_allowed_value IS NOT NULL) AND (release_group_attribute_text IS NULL))))
);


ALTER TABLE musicbrainz.release_group_attribute OWNER TO musicbrainz;

--
-- Name: release_group_attribute_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_group_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_group_attribute_id_seq OWNER TO musicbrainz;

--
-- Name: release_group_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_group_attribute_id_seq OWNED BY musicbrainz.release_group_attribute.id;


--
-- Name: release_group_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.release_group_attribute_type OWNER TO musicbrainz;

--
-- Name: release_group_attribute_type_allowed_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_attribute_type_allowed_value (
    id integer NOT NULL,
    release_group_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.release_group_attribute_type_allowed_value OWNER TO musicbrainz;

--
-- Name: release_group_attribute_type_allowed_value_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_group_attribute_type_allowed_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_group_attribute_type_allowed_value_id_seq OWNER TO musicbrainz;

--
-- Name: release_group_attribute_type_allowed_value_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_group_attribute_type_allowed_value_id_seq OWNED BY musicbrainz.release_group_attribute_type_allowed_value.id;


--
-- Name: release_group_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_group_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_group_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: release_group_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_group_attribute_type_id_seq OWNED BY musicbrainz.release_group_attribute_type.id;


--
-- Name: release_group_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.release_group_gid_redirect OWNER TO musicbrainz;

--
-- Name: release_group_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_group_id_seq OWNER TO musicbrainz;

--
-- Name: release_group_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_group_id_seq OWNED BY musicbrainz.release_group.id;


--
-- Name: release_group_meta; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_meta (
    id integer NOT NULL,
    release_count integer DEFAULT 0 NOT NULL,
    first_release_date_year smallint,
    first_release_date_month smallint,
    first_release_date_day smallint,
    rating smallint,
    rating_count integer,
    CONSTRAINT release_group_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.release_group_meta OWNER TO musicbrainz;

--
-- Name: release_group_primary_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_primary_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.release_group_primary_type OWNER TO musicbrainz;

--
-- Name: release_group_primary_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_group_primary_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_group_primary_type_id_seq OWNER TO musicbrainz;

--
-- Name: release_group_primary_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_group_primary_type_id_seq OWNED BY musicbrainz.release_group_primary_type.id;


--
-- Name: release_group_rating_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_rating_raw (
    release_group integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT release_group_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.release_group_rating_raw OWNER TO musicbrainz;

--
-- Name: release_group_secondary_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_secondary_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.release_group_secondary_type OWNER TO musicbrainz;

--
-- Name: release_group_secondary_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_group_secondary_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_group_secondary_type_id_seq OWNER TO musicbrainz;

--
-- Name: release_group_secondary_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_group_secondary_type_id_seq OWNED BY musicbrainz.release_group_secondary_type.id;


--
-- Name: release_group_secondary_type_join; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_secondary_type_join (
    release_group integer NOT NULL,
    secondary_type integer NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE musicbrainz.release_group_secondary_type_join OWNER TO musicbrainz;

--
-- Name: release_group_tag; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_tag (
    release_group integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.release_group_tag OWNER TO musicbrainz;

--
-- Name: release_group_tag_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_group_tag_raw (
    release_group integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);


ALTER TABLE musicbrainz.release_group_tag_raw OWNER TO musicbrainz;

--
-- Name: release_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_id_seq OWNER TO musicbrainz;

--
-- Name: release_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_id_seq OWNED BY musicbrainz.release.id;


--
-- Name: release_label; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_label (
    id integer NOT NULL,
    release integer NOT NULL,
    label integer,
    catalog_number character varying(255),
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.release_label OWNER TO musicbrainz;

--
-- Name: release_label_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_label_id_seq OWNER TO musicbrainz;

--
-- Name: release_label_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_label_id_seq OWNED BY musicbrainz.release_label.id;


--
-- Name: release_meta; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_meta (
    id integer NOT NULL,
    date_added timestamp with time zone DEFAULT now(),
    info_url character varying(255),
    amazon_asin character varying(10),
    cover_art_presence musicbrainz.cover_art_presence DEFAULT 'absent'::musicbrainz.cover_art_presence NOT NULL
);


ALTER TABLE musicbrainz.release_meta OWNER TO musicbrainz;

--
-- Name: release_packaging; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_packaging (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.release_packaging OWNER TO musicbrainz;

--
-- Name: release_packaging_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_packaging_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_packaging_id_seq OWNER TO musicbrainz;

--
-- Name: release_packaging_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_packaging_id_seq OWNED BY musicbrainz.release_packaging.id;


--
-- Name: release_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_raw (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    artist character varying(255),
    added timestamp with time zone DEFAULT now(),
    last_modified timestamp with time zone DEFAULT now(),
    lookup_count integer DEFAULT 0,
    modify_count integer DEFAULT 0,
    source integer DEFAULT 0,
    barcode character varying(255),
    comment character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE musicbrainz.release_raw OWNER TO musicbrainz;

--
-- Name: release_raw_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_raw_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_raw_id_seq OWNER TO musicbrainz;

--
-- Name: release_raw_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_raw_id_seq OWNED BY musicbrainz.release_raw.id;


--
-- Name: release_status; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_status (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.release_status OWNER TO musicbrainz;

--
-- Name: release_status_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.release_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.release_status_id_seq OWNER TO musicbrainz;

--
-- Name: release_status_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.release_status_id_seq OWNED BY musicbrainz.release_status.id;


--
-- Name: release_tag; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_tag (
    release integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.release_tag OWNER TO musicbrainz;

--
-- Name: release_tag_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_tag_raw (
    release integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);


ALTER TABLE musicbrainz.release_tag_raw OWNER TO musicbrainz;

--
-- Name: release_unknown_country; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.release_unknown_country (
    release integer NOT NULL,
    date_year smallint,
    date_month smallint,
    date_day smallint
);


ALTER TABLE musicbrainz.release_unknown_country OWNER TO musicbrainz;

--
-- Name: replication_control; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.replication_control (
    id integer NOT NULL,
    current_schema_sequence integer NOT NULL,
    current_replication_sequence integer,
    last_replication_date timestamp with time zone
);


ALTER TABLE musicbrainz.replication_control OWNER TO musicbrainz;

--
-- Name: replication_control_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.replication_control_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.replication_control_id_seq OWNER TO musicbrainz;

--
-- Name: replication_control_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.replication_control_id_seq OWNED BY musicbrainz.replication_control.id;


--
-- Name: script; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.script (
    id integer NOT NULL,
    iso_code character(4) NOT NULL,
    iso_number character(3) NOT NULL,
    name character varying(100) NOT NULL,
    frequency smallint DEFAULT 0 NOT NULL
);


ALTER TABLE musicbrainz.script OWNER TO musicbrainz;

--
-- Name: script_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.script_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.script_id_seq OWNER TO musicbrainz;

--
-- Name: script_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.script_id_seq OWNED BY musicbrainz.script.id;


--
-- Name: series; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.series (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    type integer NOT NULL,
    ordering_type integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT series_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.series OWNER TO musicbrainz;

--
-- Name: series_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.series_alias (
    id integer NOT NULL,
    series integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL)))),
    CONSTRAINT series_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT series_alias_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.series_alias OWNER TO musicbrainz;

--
-- Name: series_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.series_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.series_alias_id_seq OWNER TO musicbrainz;

--
-- Name: series_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.series_alias_id_seq OWNED BY musicbrainz.series_alias.id;


--
-- Name: series_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.series_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.series_alias_type OWNER TO musicbrainz;

--
-- Name: series_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.series_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.series_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: series_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.series_alias_type_id_seq OWNED BY musicbrainz.series_alias_type.id;


--
-- Name: series_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.series_annotation (
    series integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.series_annotation OWNER TO musicbrainz;

--
-- Name: series_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.series_attribute (
    id integer NOT NULL,
    series integer NOT NULL,
    series_attribute_type integer NOT NULL,
    series_attribute_type_allowed_value integer,
    series_attribute_text text,
    CONSTRAINT series_attribute_check CHECK ((((series_attribute_type_allowed_value IS NULL) AND (series_attribute_text IS NOT NULL)) OR ((series_attribute_type_allowed_value IS NOT NULL) AND (series_attribute_text IS NULL))))
);


ALTER TABLE musicbrainz.series_attribute OWNER TO musicbrainz;

--
-- Name: series_attribute_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.series_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.series_attribute_id_seq OWNER TO musicbrainz;

--
-- Name: series_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.series_attribute_id_seq OWNED BY musicbrainz.series_attribute.id;


--
-- Name: series_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.series_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.series_attribute_type OWNER TO musicbrainz;

--
-- Name: series_attribute_type_allowed_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.series_attribute_type_allowed_value (
    id integer NOT NULL,
    series_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.series_attribute_type_allowed_value OWNER TO musicbrainz;

--
-- Name: series_attribute_type_allowed_value_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.series_attribute_type_allowed_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.series_attribute_type_allowed_value_id_seq OWNER TO musicbrainz;

--
-- Name: series_attribute_type_allowed_value_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.series_attribute_type_allowed_value_id_seq OWNED BY musicbrainz.series_attribute_type_allowed_value.id;


--
-- Name: series_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.series_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.series_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: series_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.series_attribute_type_id_seq OWNED BY musicbrainz.series_attribute_type.id;


--
-- Name: series_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.series_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.series_gid_redirect OWNER TO musicbrainz;

--
-- Name: series_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.series_id_seq OWNER TO musicbrainz;

--
-- Name: series_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.series_id_seq OWNED BY musicbrainz.series.id;


--
-- Name: series_ordering_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.series_ordering_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.series_ordering_type OWNER TO musicbrainz;

--
-- Name: series_ordering_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.series_ordering_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.series_ordering_type_id_seq OWNER TO musicbrainz;

--
-- Name: series_ordering_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.series_ordering_type_id_seq OWNED BY musicbrainz.series_ordering_type.id;


--
-- Name: series_tag; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.series_tag (
    series integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.series_tag OWNER TO musicbrainz;

--
-- Name: series_tag_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.series_tag_raw (
    series integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);


ALTER TABLE musicbrainz.series_tag_raw OWNER TO musicbrainz;

--
-- Name: series_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.series_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    entity_type character varying(50) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.series_type OWNER TO musicbrainz;

--
-- Name: series_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.series_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.series_type_id_seq OWNER TO musicbrainz;

--
-- Name: series_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.series_type_id_seq OWNED BY musicbrainz.series_type.id;


--
-- Name: tag; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.tag (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    ref_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE musicbrainz.tag OWNER TO musicbrainz;

--
-- Name: tag_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.tag_id_seq OWNER TO musicbrainz;

--
-- Name: tag_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.tag_id_seq OWNED BY musicbrainz.tag.id;


--
-- Name: tag_relation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.tag_relation (
    tag1 integer NOT NULL,
    tag2 integer NOT NULL,
    weight integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT tag_relation_check CHECK ((tag1 < tag2))
);


ALTER TABLE musicbrainz.tag_relation OWNER TO musicbrainz;

--
-- Name: track; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.track (
    id integer NOT NULL,
    gid uuid NOT NULL,
    recording integer NOT NULL,
    medium integer NOT NULL,
    "position" integer NOT NULL,
    number text NOT NULL,
    name character varying NOT NULL,
    artist_credit integer NOT NULL,
    length integer,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    is_data_track boolean DEFAULT false NOT NULL,
    CONSTRAINT track_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT track_length_check CHECK (((length IS NULL) OR (length > 0)))
);


ALTER TABLE musicbrainz.track OWNER TO musicbrainz;

--
-- Name: track_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.track_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.track_gid_redirect OWNER TO musicbrainz;

--
-- Name: track_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.track_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.track_id_seq OWNER TO musicbrainz;

--
-- Name: track_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.track_id_seq OWNED BY musicbrainz.track.id;


--
-- Name: track_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.track_raw (
    id integer NOT NULL,
    release integer NOT NULL,
    title character varying(255) NOT NULL,
    artist character varying(255),
    sequence integer NOT NULL
);


ALTER TABLE musicbrainz.track_raw OWNER TO musicbrainz;

--
-- Name: track_raw_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.track_raw_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.track_raw_id_seq OWNER TO musicbrainz;

--
-- Name: track_raw_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.track_raw_id_seq OWNED BY musicbrainz.track_raw.id;


--
-- Name: unreferenced_row_log; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.unreferenced_row_log (
    table_name character varying NOT NULL,
    row_id integer NOT NULL,
    inserted timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.unreferenced_row_log OWNER TO musicbrainz;

--
-- Name: url; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.url (
    id integer NOT NULL,
    gid uuid NOT NULL,
    url text NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT url_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.url OWNER TO musicbrainz;

--
-- Name: url_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.url_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.url_gid_redirect OWNER TO musicbrainz;

--
-- Name: url_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.url_id_seq OWNER TO musicbrainz;

--
-- Name: url_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.url_id_seq OWNED BY musicbrainz.url.id;


--
-- Name: vote; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.vote (
    id integer NOT NULL,
    editor integer NOT NULL,
    edit integer NOT NULL,
    vote smallint NOT NULL,
    vote_time timestamp with time zone DEFAULT now(),
    superseded boolean DEFAULT false NOT NULL
);


ALTER TABLE musicbrainz.vote OWNER TO musicbrainz;

--
-- Name: vote_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.vote_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.vote_id_seq OWNER TO musicbrainz;

--
-- Name: vote_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.vote_id_seq OWNED BY musicbrainz.vote.id;


--
-- Name: work; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    type integer,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT work_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.work OWNER TO musicbrainz;

--
-- Name: work_alias; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_alias (
    id integer NOT NULL,
    work integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL)))),
    CONSTRAINT work_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT work_alias_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.work_alias OWNER TO musicbrainz;

--
-- Name: work_alias_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.work_alias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.work_alias_id_seq OWNER TO musicbrainz;

--
-- Name: work_alias_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.work_alias_id_seq OWNED BY musicbrainz.work_alias.id;


--
-- Name: work_alias_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.work_alias_type OWNER TO musicbrainz;

--
-- Name: work_alias_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.work_alias_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.work_alias_type_id_seq OWNER TO musicbrainz;

--
-- Name: work_alias_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.work_alias_type_id_seq OWNED BY musicbrainz.work_alias_type.id;


--
-- Name: work_annotation; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_annotation (
    work integer NOT NULL,
    annotation integer NOT NULL
);


ALTER TABLE musicbrainz.work_annotation OWNER TO musicbrainz;

--
-- Name: work_attribute; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_attribute (
    id integer NOT NULL,
    work integer NOT NULL,
    work_attribute_type integer NOT NULL,
    work_attribute_type_allowed_value integer,
    work_attribute_text text,
    CONSTRAINT work_attribute_check CHECK ((((work_attribute_type_allowed_value IS NULL) AND (work_attribute_text IS NOT NULL)) OR ((work_attribute_type_allowed_value IS NOT NULL) AND (work_attribute_text IS NULL))))
);


ALTER TABLE musicbrainz.work_attribute OWNER TO musicbrainz;

--
-- Name: work_attribute_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.work_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.work_attribute_id_seq OWNER TO musicbrainz;

--
-- Name: work_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.work_attribute_id_seq OWNED BY musicbrainz.work_attribute.id;


--
-- Name: work_attribute_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.work_attribute_type OWNER TO musicbrainz;

--
-- Name: work_attribute_type_allowed_value; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_attribute_type_allowed_value (
    id integer NOT NULL,
    work_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.work_attribute_type_allowed_value OWNER TO musicbrainz;

--
-- Name: work_attribute_type_allowed_value_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.work_attribute_type_allowed_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.work_attribute_type_allowed_value_id_seq OWNER TO musicbrainz;

--
-- Name: work_attribute_type_allowed_value_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.work_attribute_type_allowed_value_id_seq OWNED BY musicbrainz.work_attribute_type_allowed_value.id;


--
-- Name: work_attribute_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.work_attribute_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.work_attribute_type_id_seq OWNER TO musicbrainz;

--
-- Name: work_attribute_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.work_attribute_type_id_seq OWNED BY musicbrainz.work_attribute_type.id;


--
-- Name: work_gid_redirect; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.work_gid_redirect OWNER TO musicbrainz;

--
-- Name: work_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.work_id_seq OWNER TO musicbrainz;

--
-- Name: work_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.work_id_seq OWNED BY musicbrainz.work.id;


--
-- Name: work_language; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_language (
    work integer NOT NULL,
    language integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT work_language_edits_pending_check CHECK ((edits_pending >= 0))
);


ALTER TABLE musicbrainz.work_language OWNER TO musicbrainz;

--
-- Name: work_meta; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_meta (
    id integer NOT NULL,
    rating smallint,
    rating_count integer,
    CONSTRAINT work_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.work_meta OWNER TO musicbrainz;

--
-- Name: work_rating_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_rating_raw (
    work integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT work_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);


ALTER TABLE musicbrainz.work_rating_raw OWNER TO musicbrainz;

--
-- Name: work_tag; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_tag (
    work integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE musicbrainz.work_tag OWNER TO musicbrainz;

--
-- Name: work_tag_raw; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_tag_raw (
    work integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);


ALTER TABLE musicbrainz.work_tag_raw OWNER TO musicbrainz;

--
-- Name: work_type; Type: TABLE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE TABLE musicbrainz.work_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);


ALTER TABLE musicbrainz.work_type OWNER TO musicbrainz;

--
-- Name: work_type_id_seq; Type: SEQUENCE; Schema: musicbrainz; Owner: musicbrainz
--

CREATE SEQUENCE musicbrainz.work_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE musicbrainz.work_type_id_seq OWNER TO musicbrainz;

--
-- Name: work_type_id_seq; Type: SEQUENCE OWNED BY; Schema: musicbrainz; Owner: musicbrainz
--

ALTER SEQUENCE musicbrainz.work_type_id_seq OWNED BY musicbrainz.work_type.id;


--
-- Name: index; Type: TABLE; Schema: report; Owner: musicbrainz
--

CREATE TABLE report.index (
    report_name text NOT NULL,
    generated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE report.index OWNER TO musicbrainz;

--
-- Name: artist_lastmod; Type: TABLE; Schema: sitemaps; Owner: musicbrainz
--

CREATE TABLE sitemaps.artist_lastmod (
    id integer NOT NULL,
    url character varying(128) NOT NULL,
    paginated boolean NOT NULL,
    sitemap_suffix_key character varying(50) NOT NULL,
    jsonld_sha1 bytea NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    replication_sequence integer NOT NULL
);


ALTER TABLE sitemaps.artist_lastmod OWNER TO musicbrainz;

--
-- Name: control; Type: TABLE; Schema: sitemaps; Owner: musicbrainz
--

CREATE TABLE sitemaps.control (
    last_processed_replication_sequence integer,
    overall_sitemaps_replication_sequence integer,
    building_overall_sitemaps boolean NOT NULL
);


ALTER TABLE sitemaps.control OWNER TO musicbrainz;

--
-- Name: label_lastmod; Type: TABLE; Schema: sitemaps; Owner: musicbrainz
--

CREATE TABLE sitemaps.label_lastmod (
    id integer NOT NULL,
    url character varying(128) NOT NULL,
    paginated boolean NOT NULL,
    sitemap_suffix_key character varying(50) NOT NULL,
    jsonld_sha1 bytea NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    replication_sequence integer NOT NULL
);


ALTER TABLE sitemaps.label_lastmod OWNER TO musicbrainz;

--
-- Name: place_lastmod; Type: TABLE; Schema: sitemaps; Owner: musicbrainz
--

CREATE TABLE sitemaps.place_lastmod (
    id integer NOT NULL,
    url character varying(128) NOT NULL,
    paginated boolean NOT NULL,
    sitemap_suffix_key character varying(50) NOT NULL,
    jsonld_sha1 bytea NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    replication_sequence integer NOT NULL
);


ALTER TABLE sitemaps.place_lastmod OWNER TO musicbrainz;

--
-- Name: recording_lastmod; Type: TABLE; Schema: sitemaps; Owner: musicbrainz
--

CREATE TABLE sitemaps.recording_lastmod (
    id integer NOT NULL,
    url character varying(128) NOT NULL,
    paginated boolean NOT NULL,
    sitemap_suffix_key character varying(50) NOT NULL,
    jsonld_sha1 bytea NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    replication_sequence integer NOT NULL
);


ALTER TABLE sitemaps.recording_lastmod OWNER TO musicbrainz;

--
-- Name: release_group_lastmod; Type: TABLE; Schema: sitemaps; Owner: musicbrainz
--

CREATE TABLE sitemaps.release_group_lastmod (
    id integer NOT NULL,
    url character varying(128) NOT NULL,
    paginated boolean NOT NULL,
    sitemap_suffix_key character varying(50) NOT NULL,
    jsonld_sha1 bytea NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    replication_sequence integer NOT NULL
);


ALTER TABLE sitemaps.release_group_lastmod OWNER TO musicbrainz;

--
-- Name: release_lastmod; Type: TABLE; Schema: sitemaps; Owner: musicbrainz
--

CREATE TABLE sitemaps.release_lastmod (
    id integer NOT NULL,
    url character varying(128) NOT NULL,
    paginated boolean NOT NULL,
    sitemap_suffix_key character varying(50) NOT NULL,
    jsonld_sha1 bytea NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    replication_sequence integer NOT NULL
);


ALTER TABLE sitemaps.release_lastmod OWNER TO musicbrainz;

--
-- Name: tmp_checked_entities; Type: TABLE; Schema: sitemaps; Owner: musicbrainz
--

CREATE TABLE sitemaps.tmp_checked_entities (
    id integer NOT NULL,
    entity_type character varying(50) NOT NULL
);


ALTER TABLE sitemaps.tmp_checked_entities OWNER TO musicbrainz;

--
-- Name: work_lastmod; Type: TABLE; Schema: sitemaps; Owner: musicbrainz
--

CREATE TABLE sitemaps.work_lastmod (
    id integer NOT NULL,
    url character varying(128) NOT NULL,
    paginated boolean NOT NULL,
    sitemap_suffix_key character varying(50) NOT NULL,
    jsonld_sha1 bytea NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    replication_sequence integer NOT NULL
);


ALTER TABLE sitemaps.work_lastmod OWNER TO musicbrainz;

--
-- Name: statistic; Type: TABLE; Schema: statistics; Owner: musicbrainz
--

CREATE TABLE statistics.statistic (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    value integer NOT NULL,
    date_collected date DEFAULT now() NOT NULL
);


ALTER TABLE statistics.statistic OWNER TO musicbrainz;

--
-- Name: statistic_event; Type: TABLE; Schema: statistics; Owner: musicbrainz
--

CREATE TABLE statistics.statistic_event (
    date date NOT NULL,
    title text NOT NULL,
    link text NOT NULL,
    description text NOT NULL,
    CONSTRAINT statistic_event_date_check CHECK ((date >= '2000-01-01'::date))
);


ALTER TABLE statistics.statistic_event OWNER TO musicbrainz;

--
-- Name: statistic_id_seq; Type: SEQUENCE; Schema: statistics; Owner: musicbrainz
--

CREATE SEQUENCE statistics.statistic_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE statistics.statistic_id_seq OWNER TO musicbrainz;

--
-- Name: statistic_id_seq; Type: SEQUENCE OWNED BY; Schema: statistics; Owner: musicbrainz
--

ALTER SEQUENCE statistics.statistic_id_seq OWNED BY statistics.statistic.id;


--
-- Name: wikidocs_index; Type: TABLE; Schema: wikidocs; Owner: musicbrainz
--

CREATE TABLE wikidocs.wikidocs_index (
    page_name text NOT NULL,
    revision integer NOT NULL
);


ALTER TABLE wikidocs.wikidocs_index OWNER TO musicbrainz;

--
-- Name: artist_release_group_nonva; Type: TABLE ATTACH; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.artist_release_group ATTACH PARTITION musicbrainz.artist_release_group_nonva FOR VALUES IN (false);


--
-- Name: artist_release_group_va; Type: TABLE ATTACH; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.artist_release_group ATTACH PARTITION musicbrainz.artist_release_group_va FOR VALUES IN (true);


--
-- Name: artist_release_nonva; Type: TABLE ATTACH; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.artist_release ATTACH PARTITION musicbrainz.artist_release_nonva FOR VALUES IN (false);


--
-- Name: artist_release_va; Type: TABLE ATTACH; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.artist_release ATTACH PARTITION musicbrainz.artist_release_va FOR VALUES IN (true);


--
-- Name: art_type id; Type: DEFAULT; Schema: cover_art_archive; Owner: musicbrainz
--

ALTER TABLE ONLY cover_art_archive.art_type ALTER COLUMN id SET DEFAULT nextval('cover_art_archive.art_type_id_seq'::regclass);


--
-- Name: art_type id; Type: DEFAULT; Schema: event_art_archive; Owner: musicbrainz
--

ALTER TABLE ONLY event_art_archive.art_type ALTER COLUMN id SET DEFAULT nextval('event_art_archive.art_type_id_seq'::regclass);


--
-- Name: alternative_medium id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.alternative_medium ALTER COLUMN id SET DEFAULT nextval('musicbrainz.alternative_medium_id_seq'::regclass);


--
-- Name: alternative_release id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.alternative_release ALTER COLUMN id SET DEFAULT nextval('musicbrainz.alternative_release_id_seq'::regclass);


--
-- Name: alternative_release_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.alternative_release_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.alternative_release_type_id_seq'::regclass);


--
-- Name: alternative_track id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.alternative_track ALTER COLUMN id SET DEFAULT nextval('musicbrainz.alternative_track_id_seq'::regclass);


--
-- Name: annotation id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.annotation ALTER COLUMN id SET DEFAULT nextval('musicbrainz.annotation_id_seq'::regclass);


--
-- Name: application id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.application ALTER COLUMN id SET DEFAULT nextval('musicbrainz.application_id_seq'::regclass);


--
-- Name: area id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.area ALTER COLUMN id SET DEFAULT nextval('musicbrainz.area_id_seq'::regclass);


--
-- Name: area_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.area_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.area_alias_id_seq'::regclass);


--
-- Name: area_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.area_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.area_alias_type_id_seq'::regclass);


--
-- Name: area_attribute id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.area_attribute ALTER COLUMN id SET DEFAULT nextval('musicbrainz.area_attribute_id_seq'::regclass);


--
-- Name: area_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.area_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.area_attribute_type_id_seq'::regclass);


--
-- Name: area_attribute_type_allowed_value id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.area_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('musicbrainz.area_attribute_type_allowed_value_id_seq'::regclass);


--
-- Name: area_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.area_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.area_type_id_seq'::regclass);


--
-- Name: artist id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.artist ALTER COLUMN id SET DEFAULT nextval('musicbrainz.artist_id_seq'::regclass);


--
-- Name: artist_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.artist_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.artist_alias_id_seq'::regclass);


--
-- Name: artist_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.artist_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.artist_alias_type_id_seq'::regclass);


--
-- Name: artist_attribute id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.artist_attribute ALTER COLUMN id SET DEFAULT nextval('musicbrainz.artist_attribute_id_seq'::regclass);


--
-- Name: artist_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.artist_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.artist_attribute_type_id_seq'::regclass);


--
-- Name: artist_attribute_type_allowed_value id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.artist_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('musicbrainz.artist_attribute_type_allowed_value_id_seq'::regclass);


--
-- Name: artist_credit id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.artist_credit ALTER COLUMN id SET DEFAULT nextval('musicbrainz.artist_credit_id_seq'::regclass);


--
-- Name: artist_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.artist_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.artist_type_id_seq'::regclass);


--
-- Name: autoeditor_election id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.autoeditor_election ALTER COLUMN id SET DEFAULT nextval('musicbrainz.autoeditor_election_id_seq'::regclass);


--
-- Name: autoeditor_election_vote id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.autoeditor_election_vote ALTER COLUMN id SET DEFAULT nextval('musicbrainz.autoeditor_election_vote_id_seq'::regclass);


--
-- Name: cdtoc id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.cdtoc ALTER COLUMN id SET DEFAULT nextval('musicbrainz.cdtoc_id_seq'::regclass);


--
-- Name: cdtoc_raw id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.cdtoc_raw ALTER COLUMN id SET DEFAULT nextval('musicbrainz.cdtoc_raw_id_seq'::regclass);


--
-- Name: edit id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.edit ALTER COLUMN id SET DEFAULT nextval('musicbrainz.edit_id_seq'::regclass);


--
-- Name: edit_note id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.edit_note ALTER COLUMN id SET DEFAULT nextval('musicbrainz.edit_note_id_seq'::regclass);


--
-- Name: edit_note_change id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.edit_note_change ALTER COLUMN id SET DEFAULT nextval('musicbrainz.edit_note_change_id_seq'::regclass);


--
-- Name: editor id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.editor ALTER COLUMN id SET DEFAULT nextval('musicbrainz.editor_id_seq'::regclass);


--
-- Name: editor_collection id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.editor_collection ALTER COLUMN id SET DEFAULT nextval('musicbrainz.editor_collection_id_seq'::regclass);


--
-- Name: editor_collection_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.editor_collection_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.editor_collection_type_id_seq'::regclass);


--
-- Name: editor_oauth_token id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.editor_oauth_token ALTER COLUMN id SET DEFAULT nextval('musicbrainz.editor_oauth_token_id_seq'::regclass);


--
-- Name: editor_preference id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.editor_preference ALTER COLUMN id SET DEFAULT nextval('musicbrainz.editor_preference_id_seq'::regclass);


--
-- Name: editor_subscribe_artist id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.editor_subscribe_artist ALTER COLUMN id SET DEFAULT nextval('musicbrainz.editor_subscribe_artist_id_seq'::regclass);


--
-- Name: editor_subscribe_collection id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.editor_subscribe_collection ALTER COLUMN id SET DEFAULT nextval('musicbrainz.editor_subscribe_collection_id_seq'::regclass);


--
-- Name: editor_subscribe_editor id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.editor_subscribe_editor ALTER COLUMN id SET DEFAULT nextval('musicbrainz.editor_subscribe_editor_id_seq'::regclass);


--
-- Name: editor_subscribe_label id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.editor_subscribe_label ALTER COLUMN id SET DEFAULT nextval('musicbrainz.editor_subscribe_label_id_seq'::regclass);


--
-- Name: editor_subscribe_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.editor_subscribe_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.editor_subscribe_series_id_seq'::regclass);


--
-- Name: event id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.event ALTER COLUMN id SET DEFAULT nextval('musicbrainz.event_id_seq'::regclass);


--
-- Name: event_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.event_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.event_alias_id_seq'::regclass);


--
-- Name: event_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.event_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.event_alias_type_id_seq'::regclass);


--
-- Name: event_attribute id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.event_attribute ALTER COLUMN id SET DEFAULT nextval('musicbrainz.event_attribute_id_seq'::regclass);


--
-- Name: event_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.event_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.event_attribute_type_id_seq'::regclass);


--
-- Name: event_attribute_type_allowed_value id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.event_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('musicbrainz.event_attribute_type_allowed_value_id_seq'::regclass);


--
-- Name: event_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.event_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.event_type_id_seq'::regclass);


--
-- Name: gender id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.gender ALTER COLUMN id SET DEFAULT nextval('musicbrainz.gender_id_seq'::regclass);


--
-- Name: genre id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.genre ALTER COLUMN id SET DEFAULT nextval('musicbrainz.genre_id_seq'::regclass);


--
-- Name: genre_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.genre_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.genre_alias_id_seq'::regclass);


--
-- Name: genre_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.genre_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.genre_alias_type_id_seq'::regclass);


--
-- Name: instrument id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.instrument ALTER COLUMN id SET DEFAULT nextval('musicbrainz.instrument_id_seq'::regclass);


--
-- Name: instrument_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.instrument_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.instrument_alias_id_seq'::regclass);


--
-- Name: instrument_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.instrument_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.instrument_alias_type_id_seq'::regclass);


--
-- Name: instrument_attribute id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.instrument_attribute ALTER COLUMN id SET DEFAULT nextval('musicbrainz.instrument_attribute_id_seq'::regclass);


--
-- Name: instrument_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.instrument_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.instrument_attribute_type_id_seq'::regclass);


--
-- Name: instrument_attribute_type_allowed_value id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.instrument_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('musicbrainz.instrument_attribute_type_allowed_value_id_seq'::regclass);


--
-- Name: instrument_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.instrument_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.instrument_type_id_seq'::regclass);


--
-- Name: isrc id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.isrc ALTER COLUMN id SET DEFAULT nextval('musicbrainz.isrc_id_seq'::regclass);


--
-- Name: iswc id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.iswc ALTER COLUMN id SET DEFAULT nextval('musicbrainz.iswc_id_seq'::regclass);


--
-- Name: l_area_area id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_area ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_area_id_seq'::regclass);


--
-- Name: l_area_artist id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_artist ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_artist_id_seq'::regclass);


--
-- Name: l_area_event id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_event ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_event_id_seq'::regclass);


--
-- Name: l_area_genre id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_genre ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_genre_id_seq'::regclass);


--
-- Name: l_area_instrument id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_instrument ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_instrument_id_seq'::regclass);


--
-- Name: l_area_label id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_label ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_label_id_seq'::regclass);


--
-- Name: l_area_mood id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_mood ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_mood_id_seq'::regclass);


--
-- Name: l_area_place id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_place ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_place_id_seq'::regclass);


--
-- Name: l_area_recording id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_recording ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_recording_id_seq'::regclass);


--
-- Name: l_area_release id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_release ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_release_id_seq'::regclass);


--
-- Name: l_area_release_group id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_release_group ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_release_group_id_seq'::regclass);


--
-- Name: l_area_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_series_id_seq'::regclass);


--
-- Name: l_area_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_url_id_seq'::regclass);


--
-- Name: l_area_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_area_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_area_work_id_seq'::regclass);


--
-- Name: l_artist_artist id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_artist ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_artist_id_seq'::regclass);


--
-- Name: l_artist_event id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_event ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_event_id_seq'::regclass);


--
-- Name: l_artist_genre id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_genre ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_genre_id_seq'::regclass);


--
-- Name: l_artist_instrument id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_instrument ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_instrument_id_seq'::regclass);


--
-- Name: l_artist_label id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_label ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_label_id_seq'::regclass);


--
-- Name: l_artist_mood id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_mood ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_mood_id_seq'::regclass);


--
-- Name: l_artist_place id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_place ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_place_id_seq'::regclass);


--
-- Name: l_artist_recording id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_recording ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_recording_id_seq'::regclass);


--
-- Name: l_artist_release id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_release ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_release_id_seq'::regclass);


--
-- Name: l_artist_release_group id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_release_group ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_release_group_id_seq'::regclass);


--
-- Name: l_artist_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_series_id_seq'::regclass);


--
-- Name: l_artist_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_url_id_seq'::regclass);


--
-- Name: l_artist_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_artist_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_artist_work_id_seq'::regclass);


--
-- Name: l_event_event id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_event_event ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_event_event_id_seq'::regclass);


--
-- Name: l_event_genre id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_event_genre ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_event_genre_id_seq'::regclass);


--
-- Name: l_event_instrument id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_event_instrument ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_event_instrument_id_seq'::regclass);


--
-- Name: l_event_label id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_event_label ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_event_label_id_seq'::regclass);


--
-- Name: l_event_mood id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_event_mood ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_event_mood_id_seq'::regclass);


--
-- Name: l_event_place id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_event_place ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_event_place_id_seq'::regclass);


--
-- Name: l_event_recording id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_event_recording ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_event_recording_id_seq'::regclass);


--
-- Name: l_event_release id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_event_release ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_event_release_id_seq'::regclass);


--
-- Name: l_event_release_group id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_event_release_group ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_event_release_group_id_seq'::regclass);


--
-- Name: l_event_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_event_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_event_series_id_seq'::regclass);


--
-- Name: l_event_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_event_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_event_url_id_seq'::regclass);


--
-- Name: l_event_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_event_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_event_work_id_seq'::regclass);


--
-- Name: l_genre_genre id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_genre_genre ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_genre_genre_id_seq'::regclass);


--
-- Name: l_genre_instrument id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_genre_instrument ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_genre_instrument_id_seq'::regclass);


--
-- Name: l_genre_label id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_genre_label ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_genre_label_id_seq'::regclass);


--
-- Name: l_genre_mood id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_genre_mood ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_genre_mood_id_seq'::regclass);


--
-- Name: l_genre_place id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_genre_place ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_genre_place_id_seq'::regclass);


--
-- Name: l_genre_recording id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_genre_recording ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_genre_recording_id_seq'::regclass);


--
-- Name: l_genre_release id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_genre_release ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_genre_release_id_seq'::regclass);


--
-- Name: l_genre_release_group id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_genre_release_group ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_genre_release_group_id_seq'::regclass);


--
-- Name: l_genre_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_genre_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_genre_series_id_seq'::regclass);


--
-- Name: l_genre_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_genre_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_genre_url_id_seq'::regclass);


--
-- Name: l_genre_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_genre_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_genre_work_id_seq'::regclass);


--
-- Name: l_instrument_instrument id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_instrument_instrument ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_instrument_instrument_id_seq'::regclass);


--
-- Name: l_instrument_label id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_instrument_label ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_instrument_label_id_seq'::regclass);


--
-- Name: l_instrument_mood id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_instrument_mood ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_instrument_mood_id_seq'::regclass);


--
-- Name: l_instrument_place id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_instrument_place ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_instrument_place_id_seq'::regclass);


--
-- Name: l_instrument_recording id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_instrument_recording ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_instrument_recording_id_seq'::regclass);


--
-- Name: l_instrument_release id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_instrument_release ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_instrument_release_id_seq'::regclass);


--
-- Name: l_instrument_release_group id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_instrument_release_group ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_instrument_release_group_id_seq'::regclass);


--
-- Name: l_instrument_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_instrument_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_instrument_series_id_seq'::regclass);


--
-- Name: l_instrument_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_instrument_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_instrument_url_id_seq'::regclass);


--
-- Name: l_instrument_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_instrument_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_instrument_work_id_seq'::regclass);


--
-- Name: l_label_label id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_label_label ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_label_label_id_seq'::regclass);


--
-- Name: l_label_mood id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_label_mood ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_label_mood_id_seq'::regclass);


--
-- Name: l_label_place id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_label_place ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_label_place_id_seq'::regclass);


--
-- Name: l_label_recording id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_label_recording ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_label_recording_id_seq'::regclass);


--
-- Name: l_label_release id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_label_release ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_label_release_id_seq'::regclass);


--
-- Name: l_label_release_group id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_label_release_group ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_label_release_group_id_seq'::regclass);


--
-- Name: l_label_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_label_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_label_series_id_seq'::regclass);


--
-- Name: l_label_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_label_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_label_url_id_seq'::regclass);


--
-- Name: l_label_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_label_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_label_work_id_seq'::regclass);


--
-- Name: l_mood_mood id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_mood_mood ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_mood_mood_id_seq'::regclass);


--
-- Name: l_mood_place id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_mood_place ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_mood_place_id_seq'::regclass);


--
-- Name: l_mood_recording id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_mood_recording ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_mood_recording_id_seq'::regclass);


--
-- Name: l_mood_release id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_mood_release ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_mood_release_id_seq'::regclass);


--
-- Name: l_mood_release_group id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_mood_release_group ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_mood_release_group_id_seq'::regclass);


--
-- Name: l_mood_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_mood_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_mood_series_id_seq'::regclass);


--
-- Name: l_mood_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_mood_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_mood_url_id_seq'::regclass);


--
-- Name: l_mood_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_mood_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_mood_work_id_seq'::regclass);


--
-- Name: l_place_place id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_place_place ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_place_place_id_seq'::regclass);


--
-- Name: l_place_recording id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_place_recording ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_place_recording_id_seq'::regclass);


--
-- Name: l_place_release id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_place_release ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_place_release_id_seq'::regclass);


--
-- Name: l_place_release_group id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_place_release_group ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_place_release_group_id_seq'::regclass);


--
-- Name: l_place_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_place_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_place_series_id_seq'::regclass);


--
-- Name: l_place_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_place_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_place_url_id_seq'::regclass);


--
-- Name: l_place_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_place_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_place_work_id_seq'::regclass);


--
-- Name: l_recording_recording id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_recording_recording ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_recording_recording_id_seq'::regclass);


--
-- Name: l_recording_release id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_recording_release ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_recording_release_id_seq'::regclass);


--
-- Name: l_recording_release_group id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_recording_release_group ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_recording_release_group_id_seq'::regclass);


--
-- Name: l_recording_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_recording_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_recording_series_id_seq'::regclass);


--
-- Name: l_recording_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_recording_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_recording_url_id_seq'::regclass);


--
-- Name: l_recording_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_recording_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_recording_work_id_seq'::regclass);


--
-- Name: l_release_group_release_group id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_release_group_release_group ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_release_group_release_group_id_seq'::regclass);


--
-- Name: l_release_group_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_release_group_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_release_group_series_id_seq'::regclass);


--
-- Name: l_release_group_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_release_group_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_release_group_url_id_seq'::regclass);


--
-- Name: l_release_group_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_release_group_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_release_group_work_id_seq'::regclass);


--
-- Name: l_release_release id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_release_release ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_release_release_id_seq'::regclass);


--
-- Name: l_release_release_group id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_release_release_group ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_release_release_group_id_seq'::regclass);


--
-- Name: l_release_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_release_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_release_series_id_seq'::regclass);


--
-- Name: l_release_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_release_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_release_url_id_seq'::regclass);


--
-- Name: l_release_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_release_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_release_work_id_seq'::regclass);


--
-- Name: l_series_series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_series_series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_series_series_id_seq'::regclass);


--
-- Name: l_series_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_series_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_series_url_id_seq'::regclass);


--
-- Name: l_series_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_series_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_series_work_id_seq'::regclass);


--
-- Name: l_url_url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_url_url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_url_url_id_seq'::regclass);


--
-- Name: l_url_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_url_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_url_work_id_seq'::regclass);


--
-- Name: l_work_work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.l_work_work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.l_work_work_id_seq'::regclass);


--
-- Name: label id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.label ALTER COLUMN id SET DEFAULT nextval('musicbrainz.label_id_seq'::regclass);


--
-- Name: label_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.label_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.label_alias_id_seq'::regclass);


--
-- Name: label_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.label_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.label_alias_type_id_seq'::regclass);


--
-- Name: label_attribute id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.label_attribute ALTER COLUMN id SET DEFAULT nextval('musicbrainz.label_attribute_id_seq'::regclass);


--
-- Name: label_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.label_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.label_attribute_type_id_seq'::regclass);


--
-- Name: label_attribute_type_allowed_value id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.label_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('musicbrainz.label_attribute_type_allowed_value_id_seq'::regclass);


--
-- Name: label_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.label_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.label_type_id_seq'::regclass);


--
-- Name: language id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.language ALTER COLUMN id SET DEFAULT nextval('musicbrainz.language_id_seq'::regclass);


--
-- Name: link id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.link ALTER COLUMN id SET DEFAULT nextval('musicbrainz.link_id_seq'::regclass);


--
-- Name: link_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.link_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.link_attribute_type_id_seq'::regclass);


--
-- Name: link_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.link_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.link_type_id_seq'::regclass);


--
-- Name: medium id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.medium ALTER COLUMN id SET DEFAULT nextval('musicbrainz.medium_id_seq'::regclass);


--
-- Name: medium_attribute id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.medium_attribute ALTER COLUMN id SET DEFAULT nextval('musicbrainz.medium_attribute_id_seq'::regclass);


--
-- Name: medium_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.medium_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.medium_attribute_type_id_seq'::regclass);


--
-- Name: medium_attribute_type_allowed_value id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.medium_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('musicbrainz.medium_attribute_type_allowed_value_id_seq'::regclass);


--
-- Name: medium_cdtoc id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.medium_cdtoc ALTER COLUMN id SET DEFAULT nextval('musicbrainz.medium_cdtoc_id_seq'::regclass);


--
-- Name: medium_format id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.medium_format ALTER COLUMN id SET DEFAULT nextval('musicbrainz.medium_format_id_seq'::regclass);


--
-- Name: mood id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.mood ALTER COLUMN id SET DEFAULT nextval('musicbrainz.mood_id_seq'::regclass);


--
-- Name: mood_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.mood_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.mood_alias_id_seq'::regclass);


--
-- Name: mood_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.mood_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.mood_alias_type_id_seq'::regclass);


--
-- Name: place id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.place ALTER COLUMN id SET DEFAULT nextval('musicbrainz.place_id_seq'::regclass);


--
-- Name: place_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.place_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.place_alias_id_seq'::regclass);


--
-- Name: place_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.place_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.place_alias_type_id_seq'::regclass);


--
-- Name: place_attribute id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.place_attribute ALTER COLUMN id SET DEFAULT nextval('musicbrainz.place_attribute_id_seq'::regclass);


--
-- Name: place_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.place_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.place_attribute_type_id_seq'::regclass);


--
-- Name: place_attribute_type_allowed_value id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.place_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('musicbrainz.place_attribute_type_allowed_value_id_seq'::regclass);


--
-- Name: place_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.place_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.place_type_id_seq'::regclass);


--
-- Name: recording id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.recording ALTER COLUMN id SET DEFAULT nextval('musicbrainz.recording_id_seq'::regclass);


--
-- Name: recording_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.recording_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.recording_alias_id_seq'::regclass);


--
-- Name: recording_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.recording_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.recording_alias_type_id_seq'::regclass);


--
-- Name: recording_attribute id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.recording_attribute ALTER COLUMN id SET DEFAULT nextval('musicbrainz.recording_attribute_id_seq'::regclass);


--
-- Name: recording_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.recording_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.recording_attribute_type_id_seq'::regclass);


--
-- Name: recording_attribute_type_allowed_value id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.recording_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('musicbrainz.recording_attribute_type_allowed_value_id_seq'::regclass);


--
-- Name: release id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_id_seq'::regclass);


--
-- Name: release_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_alias_id_seq'::regclass);


--
-- Name: release_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_alias_type_id_seq'::regclass);


--
-- Name: release_attribute id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_attribute ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_attribute_id_seq'::regclass);


--
-- Name: release_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_attribute_type_id_seq'::regclass);


--
-- Name: release_attribute_type_allowed_value id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_attribute_type_allowed_value_id_seq'::regclass);


--
-- Name: release_group id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_group ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_group_id_seq'::regclass);


--
-- Name: release_group_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_group_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_group_alias_id_seq'::regclass);


--
-- Name: release_group_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_group_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_group_alias_type_id_seq'::regclass);


--
-- Name: release_group_attribute id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_group_attribute ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_group_attribute_id_seq'::regclass);


--
-- Name: release_group_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_group_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_group_attribute_type_id_seq'::regclass);


--
-- Name: release_group_attribute_type_allowed_value id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_group_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_group_attribute_type_allowed_value_id_seq'::regclass);


--
-- Name: release_group_primary_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_group_primary_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_group_primary_type_id_seq'::regclass);


--
-- Name: release_group_secondary_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_group_secondary_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_group_secondary_type_id_seq'::regclass);


--
-- Name: release_label id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_label ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_label_id_seq'::regclass);


--
-- Name: release_packaging id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_packaging ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_packaging_id_seq'::regclass);


--
-- Name: release_raw id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_raw ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_raw_id_seq'::regclass);


--
-- Name: release_status id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.release_status ALTER COLUMN id SET DEFAULT nextval('musicbrainz.release_status_id_seq'::regclass);


--
-- Name: replication_control id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.replication_control ALTER COLUMN id SET DEFAULT nextval('musicbrainz.replication_control_id_seq'::regclass);


--
-- Name: script id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.script ALTER COLUMN id SET DEFAULT nextval('musicbrainz.script_id_seq'::regclass);


--
-- Name: series id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.series ALTER COLUMN id SET DEFAULT nextval('musicbrainz.series_id_seq'::regclass);


--
-- Name: series_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.series_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.series_alias_id_seq'::regclass);


--
-- Name: series_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.series_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.series_alias_type_id_seq'::regclass);


--
-- Name: series_attribute id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.series_attribute ALTER COLUMN id SET DEFAULT nextval('musicbrainz.series_attribute_id_seq'::regclass);


--
-- Name: series_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.series_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.series_attribute_type_id_seq'::regclass);


--
-- Name: series_attribute_type_allowed_value id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.series_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('musicbrainz.series_attribute_type_allowed_value_id_seq'::regclass);


--
-- Name: series_ordering_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.series_ordering_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.series_ordering_type_id_seq'::regclass);


--
-- Name: series_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.series_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.series_type_id_seq'::regclass);


--
-- Name: tag id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.tag ALTER COLUMN id SET DEFAULT nextval('musicbrainz.tag_id_seq'::regclass);


--
-- Name: track id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.track ALTER COLUMN id SET DEFAULT nextval('musicbrainz.track_id_seq'::regclass);


--
-- Name: track_raw id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.track_raw ALTER COLUMN id SET DEFAULT nextval('musicbrainz.track_raw_id_seq'::regclass);


--
-- Name: url id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.url ALTER COLUMN id SET DEFAULT nextval('musicbrainz.url_id_seq'::regclass);


--
-- Name: vote id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.vote ALTER COLUMN id SET DEFAULT nextval('musicbrainz.vote_id_seq'::regclass);


--
-- Name: work id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.work ALTER COLUMN id SET DEFAULT nextval('musicbrainz.work_id_seq'::regclass);


--
-- Name: work_alias id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.work_alias ALTER COLUMN id SET DEFAULT nextval('musicbrainz.work_alias_id_seq'::regclass);


--
-- Name: work_alias_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.work_alias_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.work_alias_type_id_seq'::regclass);


--
-- Name: work_attribute id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.work_attribute ALTER COLUMN id SET DEFAULT nextval('musicbrainz.work_attribute_id_seq'::regclass);


--
-- Name: work_attribute_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.work_attribute_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.work_attribute_type_id_seq'::regclass);


--
-- Name: work_attribute_type_allowed_value id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.work_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('musicbrainz.work_attribute_type_allowed_value_id_seq'::regclass);


--
-- Name: work_type id; Type: DEFAULT; Schema: musicbrainz; Owner: musicbrainz
--

ALTER TABLE ONLY musicbrainz.work_type ALTER COLUMN id SET DEFAULT nextval('musicbrainz.work_type_id_seq'::regclass);


--
-- Name: statistic id; Type: DEFAULT; Schema: statistics; Owner: musicbrainz
--

ALTER TABLE ONLY statistics.statistic ALTER COLUMN id SET DEFAULT nextval('statistics.statistic_id_seq'::regclass);


--
-- Name: index index_pkey; Type: CONSTRAINT; Schema: report; Owner: musicbrainz
--

ALTER TABLE ONLY report.index
    ADD CONSTRAINT index_pkey PRIMARY KEY (report_name);


--
-- PostgreSQL database dump complete
--

\unrestrict G6M362OPoIekIT6vjinTlIwEjLQnYA1fRJmzBjt6MwwNQuYpSJUYduKKfdpOves

