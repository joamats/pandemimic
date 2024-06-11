# Variables
# Demographic: race, language, 
# Admissions: ED(binary), Pre ICU time. Options: admission types, admission locations (main value is ED)
# Hospital mortality comment

DROP TABLE IF EXISTS `mort-prediction-icu.data.var1_demographic_adm`;
CREATE TABLE `mort-prediction-icu.data.var1_demographic_adm` AS
(
  SELECT icu.stay_id,icu.hadm_id,
  adm.race, adm.language,adm.insurance,
  adm.admittime,adm.dischtime,
  icu.intime,icu.outtime,
  DATETIME_DIFF(adm.edouttime,adm.edregtime,hour) AS ED_duration,
  DATETIME_DIFF(icu.intime,adm.edouttime,hour) AS preICU_time_ED,
  DATETIME_DIFF(icu.intime,adm.admittime,hour) AS preICU_time_adm,
  DATETIME_DIFF(icu.outtime,icu.intime,hour) AS ICU_duration,
  adm.admission_type,adm.admission_location,
  adm.hospital_expire_flag
  FROM `lcp-internal.mimiciv_v3_hosp.admissions`adm
  LEFT JOIN `lcp-internal.mimiciv_v3_icu.icustays`icu
  ON adm.hadm_id = icu.hadm_id
  WHERE icu.stay_id in (SELECT stay_id FROM `mort-prediction-icu.data.cohort_all`)
) 