DROP TABLE IF EXISTS `mort-prediction-icu.data.cohort_final`;
CREATE TABLE `mort-prediction-icu.data.cohort_final` AS
(
  SELECT cohort.*,
  var1.race,
  var1.language,
  var1.admittime,
  var1.dischtime,
  var1.insurance,
  var1.ED_duration,
  var1.preICU_time_adm,
  var1.preICU_time_ED,
  var1.ICU_duration,
  var1.hospital_expire_flag,
  var2.height,
  var3.weight_admit,
  var3.weight_max,
  var3.weight_min,
  var4.*except(stay_id),
  var5.*except(subject_id,stay_id),
  var6.*except(subject_id,stay_id),
  var7.dialysis_active,
  var8.urineoutput,
  var9.ventilation_firstday,
  var10.pressor_firstday
  FROM `mort-prediction-icu.data.cohort_all` cohort
  LEFT JOIN `mort-prediction-icu.data.var1_demographic_adm` var1
  ON cohort.stay_id = var1.stay_id
  LEFT JOIN `mort-prediction-icu.derived.first_day_height` var2
  ON cohort.stay_id = var2.stay_id
  LEFT JOIN `mort-prediction-icu.derived.first_day_weight` var3
  ON cohort.stay_id = var3.stay_id
  LEFT JOIN `mort-prediction-icu.data.sofa_component` var4
  ON cohort.stay_id = var4.stay_id
  LEFT JOIN `mort-prediction-icu.data.vitals` var5
  ON cohort.stay_id = var5.stay_id
  LEFT JOIN `mort-prediction-icu.derived.first_day_lab` var6
  ON cohort.stay_id = var6.stay_id
  LEFT JOIN `mort-prediction-icu.derived.first_day_rrt` var7
  ON cohort.stay_id = var7.stay_id
  LEFT JOIN `mort-prediction-icu.derived.first_day_urine_output` var8
  ON cohort.stay_id = var8.stay_id
  LEFT JOIN `mort-prediction-icu.data.ventilation` var9
  ON cohort.stay_id = var9.stay_id
  LEFT JOIN `mort-prediction-icu.data.pressor` var10
  ON cohort.stay_id = var10.stay_id
)
