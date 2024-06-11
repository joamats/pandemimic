DROP TABLE IF EXISTS `mort-prediction-icu.data.cohort_all`;
CREATE TABLE `mort-prediction-icu.data.cohort_all` AS 
WITH cohort AS (
  SELECT 
  icu.*,
  pt.anchor_year_group,
  pt.anchor_age as age,
  ROW_NUMBER() OVER(PARTITION BY icu.subject_id ORDER BY icu.intime) AS row_number
  FROM `lcp-internal.mimiciv_v3_icu.icustays` icu
  INNER JOIN `lcp-internal.mimiciv_v3_hosp.patients` pt
  ON icu.subject_id = pt.subject_id
)

SELECT * FROM cohort
WHERE row_number = 1;