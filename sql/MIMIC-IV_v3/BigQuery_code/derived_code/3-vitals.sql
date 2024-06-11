# Max of each compoment for each day
# Last value(h = 23) for each day

DROP TABLE IF EXISTS `mort-prediction-icu.data.sofa_component`;
CREATE TABLE `mort-prediction-icu.data.sofa_component` AS
WITH sofa_max AS (
  SELECT 
  stay_id,
  max(respiration_24hours) as resp_max,
  max(coagulation_24hours) as coagulation_max,
  max(liver_24hours) as liver_max,
  max(cardiovascular_24hours) as cardio_max,
  max(cns_24hours) as cns_max,
  max(renal_24hours) as renal_max
  FROM `mort-prediction-icu.derived.sofa`
  WHERE hr <=24
  GROUP BY stay_id
)
, sofa_last AS (
  SELECT
  stay_id,
  last_value(respiration_24hours) OVER(PARTITION BY stay_id ORDER BY hr) AS resp_last,
  last_value(coagulation_24hours) OVER(PARTITION BY stay_id ORDER BY hr) AS coagulation_last,
  last_value(liver_24hours) OVER(PARTITION BY stay_id ORDER BY hr) AS liver_last,
  last_value(cardiovascular_24hours) OVER(PARTITION BY stay_id ORDER BY hr) AS cardio_last,
  last_value(cns_24hours) OVER(PARTITION BY stay_id ORDER BY hr) AS cns_last,
  last_value(renal_24hours) OVER(PARTITION BY stay_id ORDER BY hr) AS rental_last,
  FROM `mort-prediction-icu.derived.sofa`
  WHERE hr <=24
)

SELECT sofa_max.*,sofa_last.*except(stay_id)
FROM sofa_max 
LEFT JOIN sofa_last
ON sofa_max.stay_id = sofa_last.stay_id

