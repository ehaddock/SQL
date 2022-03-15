/****** Script for SelectTopNRows command from SSMS  ******/
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT pp.[PATIENTID]
      ,pp.[LAST_NAME]
      ,pp.[FIRST_NAME]
      ,pp.[SEX]
      ,pp.[DOB]
	  ,pp.[DECEASEDDATE]
      ,pp.[RESPONSIBLENAME] as PCP
	  ,dept.DEPARTMENTNAME as PCPHomeDepartment
      ,pp.[PCMHTEAM] as PatientsPCMHTeam
      ,isnull(pp.[Department], '*Unassigned*') as PatientsPrimaryDepartment
	  ,CASE WHEN PCMHTEAM = '*Unassigned*' THEN 'X ' END as FixPCMHTeam
	 , CASE WHEN department is null THEN 'X'
	 WHEN dept.DEPARTMENTNAME <> pp.[Department] AND dept.DEPARTMENTNAME NOT IN ('SBHC LHS Medical'
	,'SBHC Tech Medical','Shelters', 'Mobile Health Unit') THEN 'X'
	 WHEN department not in ('Shelters'
	,'Mobile Health Unit'
	,'Haverhill St Medical'
	,'LGH outpatient Medical'
	,'Main St Haverhill Medical'
	,'North Medical'
	,'Pelham St Medical'
	,'South Medical'
	,'West Medical'
	,'Haverhill St Residency') THEN 'X' END as FixPrimaryDepartment
FROM [MVGLFHC].[dbo].[GLFHCActivePatientPanel] pp
	left join [MV].[AthenaOne].[Provider] prv ON pp.RESPONSIBLENAME = prv.BILLEDNAME and prv.MDTermDate = '9999-12-31'
	left join [MV].[AthenaOne].[Department] dept ON prv.COMMUNICATORHOMEDEPTID = dept.DEPARTMENTID and dept.MDTermDate = '9999-12-31'

WHERE 
    (department is null 
    OR 
	department not in (
	'Shelters'
	,'Mobile Health Unit'
	,'Haverhill St Medical'
	,'LGH outpatient Medical'
	,'Main St Haverhill Medical'
	,'North Medical'
	,'Pelham St Medical'
	,'South Medical'
	,'West Medical'
	,'Haverhill St Residency'
	,'SBHC Tech Medical' --exclude for now
	,'SBHC LHS Medical') --exclude for now
	OR PCMHTEAM = '*Unassigned*'
	OR (dept.DEPARTMENTNAME <> pp.[Department] AND pp.[RESPONSIBLENAME] <> 'CHELSEA HARRIS, MD')
	)
	and RESPONSIBLENAME <> '*Unassigned*'
