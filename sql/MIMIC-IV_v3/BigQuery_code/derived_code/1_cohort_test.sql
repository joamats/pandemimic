DROP TABLE IF EXISTS `mort-prediction-icu.data.cohort_test_baseline`;
CREATE TABLE `mort-prediction-icu.data.cohort_test_baseline` AS 
WITH cohort AS (
  SELECT 
  icu.*,
  pt.anchor_year_group,
  ROW_NUMBER() OVER(PARTITION BY icu.subject_id ORDER BY icu.intime) AS row_number
  FROM `lcp-internal.mimiciv_v3_icu.icustays` icu
  INNER JOIN `lcp-internal.mimiciv_v3_hosp.patients` pt
  ON icu.subject_id = pt.subject_id
)

SELECT * FROM cohort
WHERE anchor_year_group IN ('2017 - 2019')
AND row_number = 1;

DROP TABLE IF EXISTS `mort-prediction-icu.data.cohort_test_compare`;
CREATE TABLE `mort-prediction-icu.data.cohort_test_compare` AS 
WITH cohort AS (
  SELECT 
  icu.*,
  pt.anchor_year_group,
  ROW_NUMBER() OVER(PARTITION BY icu.subject_id ORDER BY icu.intime) AS row_number
  FROM `lcp-internal.mimiciv_v3_icu.icustays` icu
  INNER JOIN `lcp-internal.mimiciv_v3_hosp.patients` pt
  ON icu.subject_id = pt.subject_id
)

SELECT * FROM cohort
WHERE anchor_year_group IN ('2020 - 2022')
AND row_number = 1