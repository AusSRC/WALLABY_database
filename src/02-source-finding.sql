\connect wallabydb

CREATE EXTENSION postgis;
CREATE EXTENSION pg_sphere;

CREATE SCHEMA "wallaby" AUTHORIZATION "admin";


CREATE TABLE wallaby.run (
  "id" BIGSERIAL PRIMARY KEY
);
ALTER TABLE wallaby.run ADD COLUMN "name" varchar NOT NULL;
ALTER TABLE wallaby.run ADD COLUMN "sanity_thresholds" jsonb NOT NULL;
ALTER TABLE wallaby.run ADD CONSTRAINT run_name_sanity_threshold_key UNIQUE (name, sanity_thresholds);


CREATE TABLE wallaby.instance (
  "id" BIGSERIAL PRIMARY KEY
);
ALTER TABLE wallaby.instance ADD COLUMN "run_id" BIGINT NOT NULL;
ALTER TABLE wallaby.instance ADD COLUMN "filename" varchar NOT NULL;
ALTER TABLE wallaby.instance ADD COLUMN "boundary" integer[] NOT NULL;
ALTER TABLE wallaby.instance ADD COLUMN "run_date" timestamp without time zone NOT NULL;
ALTER TABLE wallaby.instance ADD COLUMN "flag_log" bytea;
ALTER TABLE wallaby.instance ADD COLUMN "reliability_plot" bytea;
ALTER TABLE wallaby.instance ADD COLUMN "log" bytea;
ALTER TABLE wallaby.instance ADD COLUMN "parameters" jsonb NOT NULL;
ALTER TABLE wallaby.instance ADD COLUMN "version" varchar;
ALTER TABLE wallaby.instance ADD COLUMN "return_code" integer;
ALTER TABLE wallaby.instance ADD COLUMN "stdout" bytea;
ALTER TABLE wallaby.instance ADD COLUMN "stderr" bytea;
ALTER TABLE wallaby.instance ADD FOREIGN KEY ("run_id") REFERENCES wallaby.run ("id") ON DELETE CASCADE;
ALTER TABLE wallaby.instance ADD CONSTRAINT instance_run_id_filename_boundary_key UNIQUE (run_id, filename, boundary);


CREATE TABLE wallaby.detection (
  "id" BIGSERIAL PRIMARY KEY
);
ALTER TABLE wallaby.detection ADD COLUMN "instance_id" BIGINT NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "run_id" BIGINT NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "name" varchar NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "access_url" varchar NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "access_format" varchar DEFAULT 'application/x-votable+xml;content=datalink' NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "x" double precision NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "y" double precision NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "z" double precision NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "x_min" numeric NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "x_max" numeric NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "y_min" numeric NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "y_max" numeric NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "z_min" numeric NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "z_max" numeric NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "n_pix" numeric NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "f_min" double precision NULL;
ALTER TABLE wallaby.detection ADD COLUMN "f_max" double precision NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "f_sum" double precision NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "rel" double precision;
ALTER TABLE wallaby.detection ADD COLUMN "rms" double precision NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "w20" double precision NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "w50" double precision NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "ell_maj" double precision NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "ell_min" double precision NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "ell_pa" double precision NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "ell3s_maj" double precision NULL;
ALTER TABLE wallaby.detection ADD COLUMN "ell3s_min" double precision NULL;
ALTER TABLE wallaby.detection ADD COLUMN "ell3s_pa" double precision NULL;
ALTER TABLE wallaby.detection ADD COLUMN "kin_pa" double precision;
ALTER TABLE wallaby.detection ADD COLUMN "ra" double precision;
ALTER TABLE wallaby.detection ADD COLUMN "dec" double precision;
ALTER TABLE wallaby.detection ADD COLUMN "l" double precision;
ALTER TABLE wallaby.detection ADD COLUMN "b" double precision;
ALTER TABLE wallaby.detection ADD COLUMN "v_rad" double precision;
ALTER TABLE wallaby.detection ADD COLUMN "v_opt" double precision;
ALTER TABLE wallaby.detection ADD COLUMN "v_app" double precision;
ALTER TABLE wallaby.detection ADD COLUMN "err_x" double precision NULL;
ALTER TABLE wallaby.detection ADD COLUMN "err_y" double precision NULL;
ALTER TABLE wallaby.detection ADD COLUMN "err_z" double precision NULL;
ALTER TABLE wallaby.detection ADD COLUMN "err_f_sum" double precision NULL;
ALTER TABLE wallaby.detection ADD COLUMN "freq" double precision;
ALTER TABLE wallaby.detection ADD COLUMN "flag" int;
ALTER TABLE wallaby.detection ADD COLUMN "unresolved" boolean DEFAULT False NOT NULL;
ALTER TABLE wallaby.detection ADD COLUMN "wm50" numeric NULL;
ALTER TABLE wallaby.detection ADD COLUMN "x_peak" integer NULL;
ALTER TABLE wallaby.detection ADD COLUMN "y_peak" integer NULL;
ALTER TABLE wallaby.detection ADD COLUMN "z_peak" integer NULL;
ALTER TABLE wallaby.detection ADD COLUMN "ra_peak" numeric NULL;
ALTER TABLE wallaby.detection ADD COLUMN "dec_peak" numeric NULL;
ALTER TABLE wallaby.detection ADD COLUMN "freq_peak" numeric NULL;
ALTER TABLE wallaby.detection ADD COLUMN "l_peak" numeric NULL;
ALTER TABLE wallaby.detection ADD COLUMN "b_peak" numeric NULL;
ALTER TABLE wallaby.detection ADD COLUMN "v_rad_peak" numeric NULL;
ALTER TABLE wallaby.detection ADD COLUMN "v_opt_peak" numeric NULL;
ALTER TABLE wallaby.detection ADD COLUMN "v_app_peak" numeric NULL;
ALTER TABLE wallaby.detection ADD COLUMN "sofia_id" bigint NULL;
ALTER TABLE wallaby.detection ADD FOREIGN KEY ("instance_id") REFERENCES wallaby.instance ("id") ON DELETE CASCADE;
ALTER TABLE wallaby.detection ADD FOREIGN KEY ("run_id") REFERENCES wallaby.run ("id") ON DELETE CASCADE;
ALTER TABLE wallaby.detection ADD CONSTRAINT detection_constraints UNIQUE (name, x, y, z, x_min, x_max, y_min, y_max, z_min, z_max, n_pix, f_min, f_max, f_sum, instance_id, run_id);


CREATE TABLE wallaby.product (
  "id" BIGSERIAL PRIMARY KEY
);
ALTER TABLE wallaby.product ADD COLUMN "detection_id" BIGINT NOT NULL UNIQUE;
ALTER TABLE wallaby.product ADD COLUMN "cube" bytea;
ALTER TABLE wallaby.product ADD COLUMN "mask" bytea;
ALTER TABLE wallaby.product ADD COLUMN "mom0" bytea;
ALTER TABLE wallaby.product ADD COLUMN "mom1" bytea;
ALTER TABLE wallaby.product ADD COLUMN "mom2" bytea;
ALTER TABLE wallaby.product ADD COLUMN "snr" bytea NULL;
ALTER TABLE wallaby.product ADD COLUMN "chan" bytea NULL;
ALTER TABLE wallaby.product ADD COLUMN "spec" bytea;
ALTER TABLE wallaby.product ADD COLUMN "summary" bytea NULL;
ALTER TABLE wallaby.product ADD COLUMN "plot" bytea NULL;
ALTER TABLE wallaby.product ADD FOREIGN KEY ("detection_id") REFERENCES wallaby.detection ("id") ON DELETE CASCADE;


CREATE TABLE wallaby.source (
  "id" BIGSERIAL PRIMARY KEY
);
ALTER TABLE wallaby.source ADD COLUMN "name" varchar NOT NULL UNIQUE;


CREATE TABLE wallaby.source_detection (
  "id" BIGSERIAL PRIMARY KEY
);
ALTER TABLE wallaby.source_detection ADD COLUMN "source_id" BIGINT NOT NULL;
ALTER TABLE wallaby.source_detection ADD COLUMN "detection_id" BIGINT NOT NULL UNIQUE;
ALTER TABLE wallaby.source_detection ADD COLUMN "added_at" timestamp without time zone;
ALTER TABLE wallaby.source_detection ALTER COLUMN added_at SET DEFAULT now();
ALTER TABLE wallaby.source_detection ADD FOREIGN KEY ("detection_id") REFERENCES wallaby.detection ("id") ON DELETE CASCADE;
ALTER TABLE wallaby.source_detection ADD FOREIGN KEY ("source_id") REFERENCES wallaby.source ("id") ON DELETE CASCADE;


CREATE TABLE wallaby.comment (
  "id" BIGSERIAL PRIMARY KEY
);
ALTER TABLE wallaby.comment ADD COLUMN "comment" text NOT NULL;
ALTER TABLE wallaby.comment ADD COLUMN "author" text NOT NULL;
ALTER TABLE wallaby.comment ADD COLUMN "detection_id" bigint NOT NULL;
ALTER TABLE wallaby.comment ADD COLUMN "updated_at" timestamp without time zone NOT NULL;
ALTER TABLE wallaby.comment ADD FOREIGN KEY ("detection_id") REFERENCES wallaby.detection ("id") ON UPDATE CASCADE ON DELETE CASCADE;


CREATE TABLE wallaby.tag (
  "id" BIGSERIAL PRIMARY KEY
);
ALTER TABLE wallaby.tag ADD COLUMN "name" varchar NOT NULL UNIQUE;
ALTER TABLE wallaby.tag ADD COLUMN "description" text;
ALTER TABLE wallaby.tag ADD COLUMN "type" text NULL;
ALTER TABLE wallaby.tag ADD COLUMN "added_at" timestamp without time zone;
ALTER TABLE wallaby.tag ALTER COLUMN added_at SET DEFAULT now();


-- Tag source detection for release data
CREATE TABLE wallaby.tag_source_detection (
  "id" BIGSERIAL PRIMARY KEY
);
ALTER TABLE wallaby.tag_source_detection ADD COLUMN "tag_id" bigint NOT NULL;
ALTER TABLE wallaby.tag_source_detection ADD COLUMN "source_detection_id" bigint NOT NULL;
ALTER TABLE wallaby.tag_source_detection ADD COLUMN "author" text NOT NULL;
ALTER TABLE wallaby.tag_source_detection ADD COLUMN "added_at" timestamp without time zone;
ALTER TABLE wallaby.tag_source_detection ALTER COLUMN added_at SET DEFAULT now();
ALTER TABLE wallaby.tag_source_detection ADD FOREIGN KEY ("tag_id") REFERENCES wallaby.tag ("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE wallaby.tag_source_detection ADD FOREIGN KEY ("source_detection_id") REFERENCES wallaby.source_detection ("id") ON UPDATE CASCADE ON DELETE CASCADE;


-- External conflicts
CREATE TABLE wallaby.external_conflict (
    "id" BIGSERIAL PRIMARY KEY
);
ALTER TABLE wallaby.external_conflict ADD COLUMN "run_id" bigint NOT NULL;
ALTER TABLE wallaby.external_conflict ADD COLUMN "detection_id" bigint NOT NULL;
ALTER TABLE wallaby.external_conflict ADD COLUMN "conflict_source_detection_ids" integer[] NOT NULL;
ALTER TABLE wallaby.external_conflict ADD FOREIGN KEY ("run_id") REFERENCES wallaby.run ("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE wallaby.external_conflict ADD FOREIGN KEY ("detection_id") REFERENCES wallaby.detection ("id") ON UPDATE CASCADE ON DELETE CASCADE;
