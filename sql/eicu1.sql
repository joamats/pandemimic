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
  `physionet-data.eicu_crd.apachepatientresult` ap

LEFT JOIN 
  `physionet-data.eicu_crd.patient` pat
  ON ap.patientunitstayid = pat.patientunitstayid