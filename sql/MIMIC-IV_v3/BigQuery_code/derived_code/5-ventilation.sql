#Part-1: Get Invasive and non-invasive data from procedure events; high-flow data from chartevents.
DROP TABLE IF EXISTS `mort-prediction-icu.data.ventilation`;
CREATE TABLE `mort-prediction-icu.data.ventilation` AS 
WITH procedure_derived AS
(
    SELECT stay_id, starttime,endtime,
    case itemid WHEN 225792 THEN 'Invasive'
                WHEN 225794 THEN 'Noninvasive' END AS ventilation_status
    FROM `lcp-internal.mimiciv_v3_icu.procedureevents`
    WHERE itemid IN
    (
         225792  
        ,225794 
    )
),
highflow AS (
    SELECT stay_id, charttime,
CASE
WHEN value = 'High flow nasal cannula' THEN 'HighFlow'
ELSE NULL END AS ventilation_status
FROM `lcp-internal.mimiciv_v3_icu.chartevents`
WHERE itemid = 226732
AND value = 'High flow nasal cannula'
)

,hf AS (
    SELECT cohort.stay_id,
    CASE WHEN MAX(ventilation_status) = 'HighFlow' THEN 1
    ELSE 0 END AS HF_firstday
    FROM `mort-prediction-icu.data.cohort_all` cohort
    LEFT JOIN highflow 
    ON cohort.stay_id = highflow.stay_id
    AND cohort.intime <= DATETIME_SUB(
        highflow.charttime, INTERVAL '24' HOUR
    )
    GROUP BY cohort.stay_id
)

, mech_vent AS (
    SELECT cohort.stay_id,
    CASE WHEN MAX(ventilation_status) = 'Invasive' THEN 1 ELSE 0 END AS INV_firstday,
    CASE WHEN MAX(ventilation_status) = 'Noninvasive' THEN 1 ELSE 0 END AS NIV_firstday
    FROM `mort-prediction-icu.data.cohort_all` cohort
    LEFT JOIN procedure_derived pd
    ON cohort.stay_id = pd.stay_id
    AND cohort.intime <= DATETIME_SUB(
        pd.starttime, INTERVAL '24' HOUR
    )
    GROUP BY stay_id,ventilation_status
)

SELECT mech_vent.stay_id,
CASE WHEN INV_firstday = 1 THEN "INV"
WHEN INV_firstday = 0 AND NIV_firstday = 1 THEN "Non-INV"
WHEN INV_firstday = 0 AND NIV_firstday = 0 and HF_firstday =1 THEN "HF"
ELSE "Other" END AS ventilation_firstday
FROM mech_vent 
LEFT JOIN hf
ON mech_vent.stay_id = hf.stay_id

