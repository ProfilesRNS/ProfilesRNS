SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Person.UpdatePerson]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
 
 
	SELECT p2.*,
				 (SELECT CAST((SELECT p.personid                                                                                               "PersonID",
					displayname                                                                                              "Name/FullName",
					firstname                                                                                                "Name/FirstName",
					NULL                                                                                                     "Name/MiddleName",
					lastname                                                                                                 "Name/LastName",
					NULL                                                                                                     "Name/SuffixString", 
					addressline1                                                                                             "Address/Address1",
					addressline2                                                                                             "Address/Address2",
					addressline3                                                                                             "Address/Address3",
					addressline4                                                                                             "Address/Address4",
					phone                                                                                                    "Address/Telephone",
					LTRIM(RTRIM(fax))                                                                                        "Address/Fax",
					latitude                                                                                                 "Address/Latitude",
					longitude                                                                                                "Address/Longitude",
					(SELECT personfiltercategory "PersonFilter/@Category",
									personfilter         "PersonFilter"
						 FROM [Profile.Data].[Person.FilterRelationship]  ptr
					   JOIN [Profile.Data].[Person.Filter] pf ON pf.personfilterid = ptr.personfilterid
						WHERE ptr.personid = p.personid
						ORDER BY personfiltersort ASC
					 FOR XML PATH(''),TYPE) AS "PersonFilterList",
					'true'                                                                                                   "AffiliationList/@Visible",
					(SELECT CASE 
										WHEN isprimary = 1 THEN 'true'
										ELSE 'false'
									END "Affiliation/@Primary",
									ROW_NUMBER()
									OVER(PARTITION BY p.personid ORDER BY institutionname) "Affiliation/AffiliationID",
									institutionabbreviation                                "Affiliation/InstitutionAbbreviation",
									institutionname                                        "Affiliation/InstitutionName",
									departmentname                                         "Affiliation/DepartmentName",
									divisionname                                       "Affiliation/DivisionName",
									title                                                  "Affiliation/JobTitle",
									fr.facultyranksort										"Affiliation/FacultyType/@FacultyTypeSort",
									fr.facultyrank                                          "Affiliation/FacultyType"
						 FROM [Profile.Data].[Person.Affiliation] p2 
			  LEFT JOIN [Profile.Data].[Organization.Institution] ins ON p2.institutionid = ins.institutionid 
				LEFT JOIN [Profile.Data].[Organization.Department] dp 	ON dp.departmentid = p2.departmentid 
			  LEFT JOIN [Profile.Data].[Person.FacultyRank] fr 	ON fr.facultyrankid = p2.facultyrankid
						WHERE p2.personid = p.personid
						ORDER BY isprimary DESC
					 FOR XML		PATH(''),TYPE) AS "AffiliationList",
 
 
 
					(SELECT TOP 1 fr.facultyranksort
						FROM [Profile.Data].[Person.Affiliation] p2 
							INNER JOIN [Profile.Data].[Person.FacultyRank] fr
								ON fr.facultyrankid = p2.facultyrankid
						WHERE p2.personid = p.personid
						ORDER BY fr.facultyranksort)																		"AcademicRank/@AcademicRankSort",
					(SELECT TOP 1 fr.facultyrank 
						FROM [Profile.Data].[Person.Affiliation] p2 
							INNER JOIN [Profile.Data].[Person.FacultyRank] fr
								ON fr.facultyrankid = p2.facultyrankid
						WHERE p2.personid = p.personid
						ORDER BY fr.facultyranksort)																		"AcademicRank",
 
 
 
 
					'true'                                                                                                   "ProfileURL/@Visible",
					(SELECT VALUE
						 FROM [Framework.].[Parameter]
						WHERE value = 'ProfilesURL') +  CAST(p.personid AS VARCHAR(20)) "ProfileURL", 
					'true' "EmailImageUrl/@Visible",
					emailaddr                                                                                                "EmailImageUrl",
					CASE 
						WHEN showphoto = 'Y' THEN 'true'
						ELSE 'false'
					END                                             "PhotoUrl/@Visible",
					CASE 
						WHEN showphoto = 'Y' THEN ''
						ELSE ''
					END        
    FROM [Profile.Data].vwPerson p
		WHERE p.personid = p2.personid
		FOR XML  PATH(''),TYPE) AS XML)) person_xml,
		0 HasPublications, 0 HasSNA, 0 Reach1, 0 Reach2, cast(0 as float) Closeness, cast(0 as float) Betweenness
	into #cache_person
	FROM [Profile.Data].vwperson p2
 
	select p.personid, 
			isnull(i.n,0) NumPublications,
			(case when isnull(i.n,0) > 0 then 1 else 0 end) HasPublications,
			(case when isnull(s.clustersize,0)>1000 then 1 else 0 end) HasSNA,
			isnull(d.NumPeople,0) Reach1,
			isnull(r.NumPeople,0) Reach2,
			isnull(c.Closeness,0) Closeness,
			isnull(b.b,0) Betweenness
		into #cache_sna
		from #cache_person p
			left outer join (select personid, count(*) n from [Profile.Data].[Publication.Person.Include] group by personid) i on p.personid = i.personid
			left outer join (select * from [Profile.Cache].[SNA.Coauthor.Reach] where distance = 1) d on p.personid = d.personid
			left outer join (select * from [Profile.Cache].[SNA.Coauthor.Reach] where distance = 2) r on p.personid = r.personid
			left outer join (select personid, sum(cast(NumPeople as float)*Distance)/sum(cast(NumPeople as float)) closeness from [Profile.Cache].[SNA.Coauthor.Reach] where distance < 99 group by personid) c on p.personid = c.personid
			left outer join (select personid, sum(cast(NumPeople as int)) clustersize from [Profile.Cache].[SNA.Coauthor.Reach] where distance < 99 group by personid) s on p.personid = s.personid
			left outer join (select * from [Profile.Cache].[SNA.Coauthor.Betweenness]) b on p.personid = b.personid
	alter table #cache_sna add primary key (personid)
 
	update p
		set p.NumPublications = s.NumPublications,
			p.HasPublications = s.HasPublications,
			p.HasSNA = s.HasSNA,
			p.Reach1 = s.Reach1,
			p.Reach2 = s.Reach2,
			p.Closeness = s.Closeness,
			p.Betweenness = s.Betweenness
		from #cache_person p inner join #cache_sna s on p.personid = s.personid
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].Person
			INSERT INTO [Profile.Cache].Person
				SELECT * FROM #cache_person
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of 
 
SELECT	@ErrSeverity=ERROR_SEVERITY ()
RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
