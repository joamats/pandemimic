DROP TABLE IF EXISTS `mort-prediction-icu.data.pressor`;
CREATE TABLE `mort-prediction-icu.data.pressor` AS 

SELECT cohort.stay_id,
    CASE WHEN SUM(norepinephrine_equivalent_dose) >0 THEN 1
    ELSE 0 END AS pressor_firstday
  FROM `mort-prediction-icu.data.cohort_all` cohort
  LEFT JOIN `mort-prediction-icu.derived.norepinephrine_equivalent_dose` pressor
  ON cohort.stay_id = pressor.stay_id
  GROUP BY stay_id





