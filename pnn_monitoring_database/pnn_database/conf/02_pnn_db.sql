-- Host: localhost    Database: pnn
-- ------------------------------------------------------


--
-- Table structure for table `Objective`
--

-- DROP TABLE IF EXISTS public."Objective";

CREATE TABLE IF NOT EXISTS public."Objective"
(
    id serial PRIMARY KEY,
    name character varying COLLATE pg_catalog."default",
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
    name character varying COLLATE pg_catalog."default",
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
    name character varying COLLATE pg_catalog."default",
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
    name character varying COLLATE pg_catalog."default",
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
    name character varying COLLATE pg_catalog."default",
    ext_id character varying(50) COLLATE pg_catalog."default" NULL
);



--
-- Table structure for table `Period`
--

-- DROP TABLE IF EXISTS public."Period";


CREATE TABLE IF NOT EXISTS public."Period"
(
    id serial PRIMARY KEY,
    name character varying COLLATE pg_catalog."default"
);


--
-- Table structure for table `Detail`
--

-- DROP TABLE IF EXISTS public."Detail";


CREATE TABLE IF NOT EXISTS public."Detail"
(
    id serial PRIMARY KEY,
    name character varying COLLATE pg_catalog."default",
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
    name character varying COLLATE pg_catalog."default",
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


-- CREATE VIEWS



CREATE VIEW public."view_years" AS
 SELECT g.sirap_id,
    s.name AS sirap_name,
    g.objective_id,
    o.name AS objective_name,
    g.name AS guideline_name,
    ac.name AS action_name,
    m.name AS milestone_name,
    m.action_id,
    d.id AS detail_id,
    d.name AS detail_name,
    d.amount,
    d.quantity,
    d.date,
    d.goal,
    d.milestone_id,
    d.implemented_value,
    d.period_id,
    p.name AS period_name,
    d.product_id,
    pr.name AS product_name,
    y.id AS year_id,
    y.value AS year_value
   FROM "Sirap" s
     LEFT JOIN "Guideline" g ON s.id = g.sirap_id
     LEFT JOIN "Objective" o ON g.objective_id = o.id
     LEFT JOIN "Action" ac ON g.id = ac.guideline_id
     LEFT JOIN "Milestone" m ON ac.id = m.action_id
     LEFT JOIN "Detail" d ON m.id = d.milestone_id
     LEFT JOIN "Product" pr ON d.product_id = pr.id
     LEFT JOIN "Period" p ON d.period_id = p.id
     LEFT JOIN "Time" t ON d.id = t.detail_id
     LEFT JOIN "Year" y ON t.year_id = y.id
  GROUP BY g.sirap_id, s.name, g.objective_id, o.name, o.description, o.ext_id, g.name, ac.name, p.name, pr.name, m.name, m.action_id, d.id, d.name, d.amount, d.quantity, d.date, d.goal, d.milestone_id, d.implemented_value, d.period_id, d.product_id, y.id, y.value
  ORDER BY d.id;




CREATE VIEW public."view_until_detail" AS
 SELECT s.id AS sirap_id,
    s.name AS sirap_name,
    g.id AS guideline_id,
    g.name AS guideline_name,
    g.objective_id,
    o.name AS objective_name,
    a.id AS action_id,
    a.name AS action_name,
    m.id AS milestone_id,
    m.name AS milestone_name,
    m.product_indc,
    m.obs,
    p.id AS period_id,
    p.name AS period_name,
    pr.id AS product_id,
    pr.name AS product_name,
    d.id AS detail_id,
    d.name AS detail_name,
    d.amount,
    d.quantity,
    d.date,
    d.goal,
    d.implemented_value,
    d.amount * d.quantity * d.goal as total_value
   FROM "Sirap" s
     JOIN "Guideline" g ON s.id = g.sirap_id
     JOIN "Objective" o ON g.objective_id = o.id
     JOIN "Action" a ON g.id = a.guideline_id
     JOIN "Milestone" m ON a.id = m.action_id
     JOIN "Detail" d ON m.id = d.milestone_id
     JOIN "Period" p ON d.period_id = p.id
     JOIN "Product" pr ON d.product_id = pr.id;


    



CREATE VIEW public."view_milestone" AS
 SELECT s.id AS sirap_id,
    s.name AS sirap_name,
    s.description AS sirap_description,
    s.region AS sirap_region,
    s.prot_areas AS sirap_protected_areas,
    s.ext_id AS sirap_ext_id,
    g.id AS guideline_id,
    g.name AS guideline_name,
    g.objective_id AS guideline_objectve_id,
    o.id AS objective_id,
    o.name AS objective_name,
    o.description AS objective_description,
    o.ext_id AS objective_ext_id,
    a.id AS action_id,
    a.name AS action_name,
    a.action_indc AS action_indicator,
    a.guideline_id AS action_guideline_id,
    m.id AS milestone_id,
    m.name AS milestone_name,
    m.action_id AS milestone_action_id,
    m.product_indc AS milestone_product_indicator
   FROM "Sirap" s
     LEFT JOIN "Guideline" g ON s.id = g.sirap_id
     LEFT JOIN "Objective" o ON g.objective_id = o.id
     LEFT JOIN "Action" a ON g.id = a.guideline_id
     LEFT JOIN "Milestone" m ON a.id = m.action_id;




CREATE VIEW public."view_all_data" AS
SELECT
    g.sirap_id,
    s.name AS sirap_name,
    s.description AS sirap_desc,
    s.region,
    s.prot_areas,
    s.ext_id AS sirap_ext_id,
    g.objective_id,
    o.name AS objective_name,
    o.description AS objective_desc,
    o.ext_id AS objective_ext_id,
	ac.guideline_id,
    g.name AS guideline_name,
	m.action_id,
    ac.name AS action_name,
    ac.action_indc,
    d.milestone_id,
    m.name AS milestone_name,
    m.product_indc,
    m.obs as milestone_obs,
    d.id as detail_id,
    d.name AS detail_name,
    d.amount,
    d.quantity,
	d.base_line,
    d.date,
    d.goal,
    d.period_id,
    p.name AS period_name,
    d.product_id,
    pr.name AS product_name,
    d.implemented_value,
    d.amount * d.quantity as value_per_insumo,
    d.amount * d.quantity * d.goal as value_per_goal,
    CASE
        WHEN COUNT(DISTINCT y.value) = 0 THEN NULL
        ELSE ARRAY_AGG(DISTINCT y.value)
    END AS year_values,
    CASE
        WHEN COUNT(DISTINCT y.id) = 0 THEN NULL
        ELSE ARRAY_AGG(DISTINCT y.id)
    END AS year_ids,
	CASE
        WHEN COUNT(DISTINCT CASE WHEN a.detail_id IS NOT NULL THEN a_i.name ELSE NULL END) = 0 THEN NULL
        ELSE STRING_AGG(DISTINCT CASE WHEN a.detail_id IS NOT NULL THEN a_i.name ELSE NULL END, ', ')
    END AS actor_institution_names,
    CASE
        WHEN COUNT(DISTINCT CASE WHEN a.detail_id IS NOT NULL THEN a_i.id ELSE NULL END) = 0 THEN NULL
        ELSE ARRAY_AGG(DISTINCT CASE WHEN a.detail_id IS NOT NULL THEN a_i.id ELSE NULL END)
    END AS actor_institution_ids,
    CASE
        WHEN COUNT(DISTINCT CASE WHEN r.detail_id IS NOT NULL THEN r_i.name ELSE NULL END) = 0 THEN NULL
        ELSE STRING_AGG(DISTINCT CASE WHEN r.detail_id IS NOT NULL THEN r_i.name ELSE NULL END, ', ')
    END AS responsible_institution_names,
    CASE
        WHEN COUNT(DISTINCT CASE WHEN r.detail_id IS NOT NULL THEN r_i.id ELSE NULL END) = 0 THEN NULL
        ELSE ARRAY_AGG(DISTINCT CASE WHEN r.detail_id IS NOT NULL THEN r_i.id ELSE NULL END)
    END AS responsible_institution_ids
FROM
    public."Sirap" s
LEFT JOIN public."Guideline" g ON s.id = g.sirap_id
LEFT JOIN public."Objective" o ON g.objective_id = o.id
LEFT JOIN public."Action" ac ON g.id = ac.guideline_id
LEFT JOIN public."Milestone" m ON ac.id = m.action_id
LEFT JOIN public."Detail" d ON m.id = d.milestone_id
LEFT JOIN public."Product" pr ON d.product_id = pr.id
LEFT JOIN public."Time" t ON d.id = t.detail_id
LEFT JOIN public."Year" y ON t.year_id = y.id
LEFT JOIN public."Period" p ON d.period_id = p.id
LEFT JOIN public."Responsible" r ON d.id = r.detail_id
LEFT JOIN public."Institution" r_i ON r.institution_id = r_i.id
LEFT JOIN public."Actor" a ON d.id = a.detail_id
LEFT JOIN public."Institution" a_i ON a.institution_id = a_i.id
GROUP BY
    d.id,
    d.name,
    d.amount,
    d.quantity,
    d.date,
    d.goal,
    d.period_id,
    d.product_id,
    d.milestone_id,
    d.implemented_value,
    p.name,
    pr.name,
    m.name,
    m.action_id,
    m.product_indc,
    m.obs,
    ac.name,
	ac.action_indc,
	ac.guideline_id,
    g.name,
    g.objective_id,
    g.sirap_id,
    o.name,
    o.description,
    o.ext_id,
    s.name,
    s.description,
    s.region,
    s.prot_areas,
    s.ext_id;



CREATE VIEW public."view_actors" AS
 SELECT g.sirap_id,
    s.name AS sirap_name,
    g.objective_id,
    o.name AS objective_name,
    g.name AS guideline_name,
    ac.name AS action_name,
    m.name AS milestone_name,
    m.action_id,
    d.id AS detail_id,
    d.name AS detail_name,
    d.amount,
    d.quantity,
    d.date,
    d.goal,
    d.milestone_id,
    d.implemented_value,
    d.period_id,
    p.name AS period_name,
    d.product_id,
    pr.name AS product_name,
    i.name AS institution_name,
    i.id AS institution_id
   FROM "Sirap" s
     LEFT JOIN "Guideline" g ON s.id = g.sirap_id
     LEFT JOIN "Objective" o ON g.objective_id = o.id
     LEFT JOIN "Action" ac ON g.id = ac.guideline_id
     LEFT JOIN "Milestone" m ON ac.id = m.action_id
     LEFT JOIN "Detail" d ON m.id = d.milestone_id
     LEFT JOIN "Product" pr ON d.product_id = pr.id
     LEFT JOIN "Period" p ON d.period_id = p.id
     LEFT JOIN "Actor" a ON d.id = a.detail_id
     LEFT JOIN "Institution" i ON a.institution_id = i.id
  GROUP BY g.sirap_id, s.name, g.objective_id, o.name, g.name, ac.name, m.name, m.action_id, d.id, d.name, d.amount, d.quantity, d.date, d.goal, d.milestone_id, d.implemented_value, p.name, pr.name, i.name, i.id;



CREATE VIEW public."view_responsible" AS
 SELECT g.sirap_id,
    s.name AS sirap_name,
    g.objective_id,
    o.name AS objective_name,
    g.name AS guideline_name,
    ac.name AS action_name,
    m.name AS milestone_name,
    m.action_id,
    d.id AS detail_id,
    d.name AS detail_name,
    d.amount,
    d.quantity,
    d.date,
    d.goal,
    d.milestone_id,
    d.implemented_value,
    d.period_id,
    p.name AS period_name,
    d.product_id,
    pr.name AS product_name,
    i.name AS institution_name,
    i.id AS institution_id
   FROM "Sirap" s
     LEFT JOIN "Guideline" g ON s.id = g.sirap_id
     LEFT JOIN "Objective" o ON g.objective_id = o.id
     LEFT JOIN "Action" ac ON g.id = ac.guideline_id
     LEFT JOIN "Milestone" m ON ac.id = m.action_id
     LEFT JOIN "Detail" d ON m.id = d.milestone_id
     LEFT JOIN "Product" pr ON d.product_id = pr.id
     LEFT JOIN "Period" p ON d.period_id = p.id
     LEFT JOIN "Responsible" r ON d.id = r.detail_id
     LEFT JOIN "Institution" i ON r.institution_id = i.id
  GROUP BY g.sirap_id, s.name, g.objective_id, o.name, g.name, ac.name, m.name, m.action_id, d.id, d.name, d.amount, d.quantity, d.date, d.goal, d.milestone_id, d.implemented_value, p.name, pr.name, i.name, i.id;



