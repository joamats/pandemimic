SELECT
  ap.patientunitstayid,
  pat.ethnicity,
  apacheversion,
  predictedicumortality,
  actualicumortality,
  predictedhospitalmortality,
  actualhospitalmortality,
  predictedhospitallos,
  actualhospitallos
FROM
  `aiwonglab.eicu_crd_ii_v0_1_0.apachepatientresults` ap

LEFT JOIN 
  `aiwonglab.eicu_crd_ii_v0_1_0.patient` pat
  ON ap.patientunitstayid = pat.patientunitstayid