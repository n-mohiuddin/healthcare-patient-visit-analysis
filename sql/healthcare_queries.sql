-- 1.1 Create Patients Table

CREATE TABLE patients (
  "Id"                  VARCHAR(100) PRIMARY KEY,
  "BIRTHDATE"            DATE,
  "DEATHDATE"            DATE,
  "SSN"                  VARCHAR(100),
  "DRIVERS"              VARCHAR(100),
  "PASSPORT"             VARCHAR(100),
  "PREFIX"               VARCHAR(100),
  "FIRST"                VARCHAR(100),
  "MIDDLE"               VARCHAR(100),
  "LAST"                 VARCHAR(100),
  "SUFFIX"               VARCHAR(100),
  "MAIDEN"               VARCHAR(100),
  "MARITAL"              VARCHAR(100),
  "RACE"                 VARCHAR(100),
  "ETHNICITY"            VARCHAR(100),
  "GENDER"               VARCHAR(100),
  "BIRTHPLACE"           VARCHAR(200),
  "ADDRESS"              VARCHAR(200),
  "CITY"                 VARCHAR(100),
  "STATE"                VARCHAR(100),
  "COUNTY"               VARCHAR(150),
  "FIPS"                 INT,
  "ZIP"                  VARCHAR(20),
  "LAT"                  DOUBLE PRECISION,
  "LON"                  DOUBLE PRECISION,
  "HEALTHCARE_EXPENSES"  DOUBLE PRECISION,
  "HEALTHCARE_COVERAGE"  DOUBLE PRECISION,
  "INCOME"               INT
);

SELECT * FROM patients LIMIT 10;

-- 1.2 Create Conditions Table

CREATE TABLE conditions (
  "START"        DATE,
  "STOP"         DATE,
  "PATIENT"      VARCHAR(100) REFERENCES patients("Id"),
  "ENCOUNTER"    VARCHAR(100),
  "SYSTEM"       VARCHAR(300),
  "CODE"         VARCHAR(50),
  "DESCRIPTION"  VARCHAR(500)
);

SELECT * FROM conditions LIMIT 10;

-- 1.3 Create Encounters Table

CREATE TABLE encounters (
  "Id"                VARCHAR(100) PRIMARY KEY,
  "START"             TIMESTAMPTZ,
  "STOP"              TIMESTAMPTZ,
  "PATIENT"           VARCHAR(100) REFERENCES patients("Id"),
  "ORGANIZATION"      VARCHAR(100),
  "PROVIDER"          VARCHAR(100),
  "PAYER"             VARCHAR(100),
  "ENCOUNTERCLASS"    VARCHAR(100),
  "CODE"              VARCHAR(50),
  "DESCRIPTION"       VARCHAR(500),
  "BASE_ENCOUNTER_COST" DOUBLE PRECISION,
  "TOTAL_CLAIM_COST"    DOUBLE PRECISION,
  "PAYER_COVERAGE"      DOUBLE PRECISION,
  "REASONCODE"        VARCHAR(50),
  "REASONDESCRIPTION" VARCHAR(500)
);

SELECT * FROM encounters LIMIT 10;

-- 1.4 Create Immunizations Table

CREATE TABLE immunizations (
  "DATE"        TIMESTAMPTZ,
  "PATIENT"     VARCHAR(100) REFERENCES patients("Id"),
  "ENCOUNTER"   VARCHAR(100),
  "CODE"        INT,
  "DESCRIPTION" VARCHAR(500),
  "BASE_COST"   DOUBLE PRECISION
);

SELECT * FROM immunizations LIMIT 10;

-- 2.1 Row Counts

SELECT COUNT(*) AS patients_count FROM patients;
SELECT COUNT(*) AS conditions_count FROM conditions;
SELECT COUNT(*) AS encounters_count FROM encounters;

-- 2.2 Encounter Date Range

SELECT MIN("START") AS min_start, MAX("START") AS max_start FROM encounters;

-- 3.1 Monthly Encounters (Last 15 Years)

SELECT
    DATE_TRUNC('month', "START") AS MONTH,
	COUNT (*) AS total_visits
FROM encounters
WHERE "START" >= CURRENT_DATE - INTERVAL '15 years'
GROUP BY MONTH
ORDER BY MONTH;

-- 3.2 Monthly Visits vs Unique Patients

SELECT 
  DATE_TRUNC('month', e."START") AS month,
  COUNT(*) AS total_visits,
  COUNT(DISTINCT e."PATIENT") AS unique_patients
FROM encounters e
WHERE e."START" >= CURRENT_DATE - INTERVAL '15 years'
GROUP BY month
ORDER BY month;


-- 4. Busiest Encounter Type

SELECT 
  "ENCOUNTERCLASS",
  COUNT(*) AS total_visits
FROM encounters
GROUP BY "ENCOUNTERCLASS"
ORDER BY total_visits DESC;

-- 5. Most Frequent Conditions

SELECT 
  "DESCRIPTION" AS condition,
  COUNT(*) AS frequency
FROM conditions
GROUP BY "DESCRIPTION"
ORDER BY frequency DESC
LIMIT 10;

-- 6. Top Conditions by Service Type (Conditions × Encounters JOIN)

SELECT
    e."ENCOUNTERCLASS" AS service_type,
    c."DESCRIPTION" AS condition,
    COUNT(*) AS frequency
FROM conditions c
JOIN encounters e
    ON c."ENCOUNTER" = e."Id"
GROUP BY e."ENCOUNTERCLASS", c."DESCRIPTION"
ORDER BY frequency DESC
LIMIT 15;




 
