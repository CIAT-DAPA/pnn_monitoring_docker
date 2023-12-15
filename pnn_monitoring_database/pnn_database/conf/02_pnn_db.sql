-- Host: localhost    Database: pnn
-- ------------------------------------------------------


--
-- Table structure for table `Objective`
--

-- DROP TABLE IF EXISTS public."Objective";

CREATE TABLE IF NOT EXISTS public."Objective"
(
    id serial PRIMARY KEY,
    name character varying(255) COLLATE pg_catalog."default",
    description character varying COLLATE pg_catalog."default" NULL,
    ext_id character varying(50) COLLATE pg_catalog."default" NULL
);


--
-- Table structure for table `Sirap`
--

-- DROP TABLE IF EXISTS public."Sirap";

CREATE TABLE IF NOT EXISTS public."Sirap"
(
    id serial PRIMARY KEY,
    name character varying(255) COLLATE pg_catalog."default",
    description character varying COLLATE pg_catalog."default" NULL,
    region character varying(50) COLLATE pg_catalog."default" NULL,
    prot_areas character varying COLLATE pg_catalog."default" NULL,
    ext_id character varying(50) COLLATE pg_catalog."default" NULL
);


--
-- Table structure for table `Guideline`
--

-- DROP TABLE IF EXISTS public."Guideline";

CREATE TABLE IF NOT EXISTS public."Guideline"
(
    id serial PRIMARY KEY,
    name character varying(255) COLLATE pg_catalog."default",
    objective_id integer,
    sirap_id integer,
    CONSTRAINT "Guideline_objective_id_fkey" FOREIGN KEY (objective_id)
        REFERENCES public."Objective" (id) MATCH SIMPLE
        ON DELETE CASCADE,
    CONSTRAINT "Guideline_sirap_id_fkey" FOREIGN KEY (sirap_id)
        REFERENCES public."Sirap" (id) MATCH SIMPLE
        ON DELETE CASCADE
);


--
-- Table structure for table `Action`
--

-- DROP TABLE IF EXISTS public."Action";


CREATE TABLE IF NOT EXISTS public."Action"
(
    id serial PRIMARY KEY,
    name character varying(255) COLLATE pg_catalog."default",
    action_indc character varying COLLATE pg_catalog."default" NULL,
    guideline_id integer,
    CONSTRAINT "Action_guideline_id_fkey" FOREIGN KEY (guideline_id)
        REFERENCES public."Guideline" (id) MATCH SIMPLE
        ON DELETE CASCADE
);


--
-- Table structure for table `Milestone`
--

-- DROP TABLE IF EXISTS public."Milestone";



CREATE TABLE IF NOT EXISTS public."Milestone"
(
    id serial PRIMARY KEY,
    name character varying(255) COLLATE pg_catalog."default",
    product_indc character varying COLLATE pg_catalog."default" NULL,
    obs character varying COLLATE pg_catalog."default" NULL, 
    action_id integer,
    CONSTRAINT "Milestone_action_id_fkey" FOREIGN KEY (action_id)
        REFERENCES public."Action" (id) MATCH SIMPLE
        ON DELETE CASCADE
);


--
-- Table structure for table `Product`
--

-- DROP TABLE IF EXISTS public."Product";


CREATE TABLE IF NOT EXISTS public."Product"
(
    id serial PRIMARY KEY,
    name character varying(255) COLLATE pg_catalog."default",
    ext_id character varying(50) COLLATE pg_catalog."default" NULL
);



--
-- Table structure for table `Period`
--

-- DROP TABLE IF EXISTS public."Period";


CREATE TABLE IF NOT EXISTS public."Period"
(
    id serial PRIMARY KEY,
    name character varying(255) COLLATE pg_catalog."default"
);


--
-- Table structure for table `Detail`
--

-- DROP TABLE IF EXISTS public."Detail";


CREATE TABLE IF NOT EXISTS public."Detail"
(
    id serial PRIMARY KEY,
    name character varying(255) COLLATE pg_catalog."default",
    amount double precision,
    quantity integer,
    date date,
    goal integer,
    base_line integer,
    period_id integer,
    product_id integer,
    milestone_id integer,
    implemented_value double precision,
    CONSTRAINT "Detail_period_id_fkey" FOREIGN KEY (period_id)
        REFERENCES public."Period" (id) MATCH SIMPLE
        ON DELETE CASCADE,
    CONSTRAINT "Detail_product_id_fkey" FOREIGN KEY (product_id)
        REFERENCES public."Product" (id) MATCH SIMPLE
        ON DELETE CASCADE,
    CONSTRAINT "Detail_milestone_id_fkey" FOREIGN KEY (milestone_id)
        REFERENCES public."Milestone" (id) MATCH SIMPLE
        ON DELETE CASCADE
);



--
-- Table structure for table `Institution`
--

-- DROP TABLE IF EXISTS public."Institution";


CREATE TABLE IF NOT EXISTS public."Institution"
(
    id serial PRIMARY KEY,
    name character varying(255) COLLATE pg_catalog."default",
    ext_id character varying(50) COLLATE pg_catalog."default" NULL

);


--
-- Table structure for table `Actor`
--

-- DROP TABLE IF EXISTS public."Actor";


CREATE TABLE IF NOT EXISTS public."Actor"
(
    id serial PRIMARY KEY,
    institution_id integer,
    detail_id integer,
    CONSTRAINT "Actor_detail_id_fkey" FOREIGN KEY (detail_id)
        REFERENCES public."Detail" (id) MATCH SIMPLE
        ON DELETE CASCADE,
    CONSTRAINT "Actor_institution_id_fkey" FOREIGN KEY (institution_id)
        REFERENCES public."Institution" (id) MATCH SIMPLE
        ON DELETE CASCADE
);





--
-- Table structure for table `Responsible`
--

-- DROP TABLE IF EXISTS public."Responsible";


CREATE TABLE IF NOT EXISTS public."Responsible"
(
    id serial PRIMARY KEY,
    institution_id integer,
    detail_id integer,
    CONSTRAINT "Responsible_detail_id_fkey" FOREIGN KEY (detail_id)
        REFERENCES public."Detail" (id) MATCH SIMPLE
        ON DELETE CASCADE,
    CONSTRAINT "Responsible_institution_id_fkey" FOREIGN KEY (institution_id)
        REFERENCES public."Institution" (id) MATCH SIMPLE
        ON DELETE CASCADE
);



--
-- Table structure for table `Year`
--

-- DROP TABLE IF EXISTS public."Year";


CREATE TABLE IF NOT EXISTS public."Year"
(
    id serial PRIMARY KEY,
    value integer NOT NULL
);


--
-- Table structure for table `Time`
--

-- DROP TABLE IF EXISTS public."Time";


CREATE TABLE IF NOT EXISTS public."Time"
(
    id serial PRIMARY KEY,
    detail_id integer,
    year_id integer,
    CONSTRAINT "Time_detail_id_fkey" FOREIGN KEY (detail_id)
        REFERENCES public."Detail" (id) MATCH SIMPLE
        ON DELETE CASCADE,
    CONSTRAINT "Time_year_id_fkey" FOREIGN KEY (year_id)
        REFERENCES public."Year" (id) MATCH SIMPLE
        ON DELETE CASCADE
);





