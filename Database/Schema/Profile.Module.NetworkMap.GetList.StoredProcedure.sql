SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Module].[NetworkMap.GetList]
	@UserID BIGINT=NULL,
	@which INT=0,
	@SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;
 
	DECLARE  @f  TABLE(
		PersonID INT,
		display_name NVARCHAR(255),
		latitude FLOAT,
		longitude FLOAT,
		address1 NVARCHAR(1000),
		address2 NVARCHAR(1000),
		URI VARCHAR(400)
	)
 
	INSERT INTO @f (PersonID, display_name, latitude, longitude, address1, address2, URI)
		SELECT t.PersonID, t.DisplayName, t.latitude, t.longitude, b.Addr, 
			'('+(CASE WHEN t.n=1 THEN '1 Person' 
					WHEN t.n>5 THEN '5 of '+CAST(n AS VARCHAR(10))+' People Shown' 
					ELSE CAST(n AS VARCHAR(10))+' People' 
					END)+')', 
			f.Value + cast(m.NodeID as varchar(50)) URI
		FROM (
			SELECT *, DENSE_RANK() OVER (ORDER BY n DESC, r DESC, p) k
			FROM (
				SELECT *, COUNT(*) OVER (PARTITION BY i) n, SUM(Reach1) OVER (PARTITION BY i) r, MIN(PersonID) OVER (PARTITION BY i) p
				FROM (
					SELECT	p.PersonID,
							p.displayname,
							p.latitude,
							p.longitude,
							p.AddressLine1,
							p.AddressLine2,
							p.AddressLine3,
							p.AddressLine4,
							p.AddressString,
							p.Reach1,
							p.NumPublications,
							DENSE_RANK() OVER (ORDER BY p.latitude, p.longitude) i,
							ROW_NUMBER() OVER (PARTITION BY p.latitude, p.longitude ORDER BY p.Reach1 DESC, p.NumPublications DESC, p.PersonID) j
					FROM [Profile.Cache].[Person] p
						INNER JOIN [Profile.Data].[List.Member] m
							ON p.PersonID = m.PersonID
					WHERE m.UserID = @UserID
						AND ISNULL(p.latitude,0)<>0
						AND ISNULL(p.longitude,0)<>0
				) t
			) t
		) t 
		INNER JOIN [RDF.Stage].[InternalNodeMap] m
			ON t.PersonID=m.InternalID AND m.class='http://xmlns.com/foaf/0.1/Person' AND m.InternalType='Person'
		CROSS JOIN [Framework.].[Parameter] f
		CROSS APPLY (
			SELECT LTRIM(RTRIM(ISNULL(AddressLine1,''))) a1, LTRIM(RTRIM(ISNULL(AddressLine2,''))) a2, LTRIM(RTRIM(ISNULL(AddressLine3,''))) a3, LTRIM(RTRIM(ISNULL(AddressLine4,''))) a4
		) a
		OUTER APPLY (
			SELECT TOP 1 addr
			FROM (
				SELECT 0 x, a3 + ', ' + a4 addr
					WHERE a3<>'' AND a4<>''
				UNION ALL SELECT 1 x, a1 + ', ' + a4
					WHERE a1<>'' AND a3='' AND a4<>'' AND (a2='' OR a2 LIKE 'Ste %' OR a2 LIKE 'Suite %')
				UNION ALL SELECT 2 x, a2 + ', ' + a4
					WHERE a3='' AND a4<>'' AND a2 LIKE '[0-9]%'
				UNION ALL SELECT 3 x, LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(AddressString,'  ',' '),'  ',' '),'  ',' ')))
			) t
			ORDER BY x
		) b
		WHERE t.k<=20 AND t.j<=5 AND f.ParameterID = 'baseURI'


	IF @which = 0
	BEGIN
		SELECT PersonID, 
			display_name,
			latitude,
			longitude,
			address1,
			address2,
			URI
		FROM @f
		ORDER BY address1,
			address2,
			display_name
	END
	ELSE
	BEGIN
		SELECT DISTINCT	a.latitude	x1,
						a.longitude	y1,
						d.latitude	x2,
						d.longitude	y2,
						a.PersonID	a,
						d.PersonID	b,
						0 is_person,
						a.URI u1,
						d.URI u2
			FROM @f a,
					 [Profile.Data].[Publication.Person.Include] b,
					 [Profile.Data].[Publication.Person.Include] c,
					 @f d
		 WHERE a.PersonID = b.PersonID
			 AND b.pmid = c.pmid
			 AND b.PersonID < c.PersonID
			 AND c.PersonID = d.PersonID
			 --AND 1=0
	END
		
END

GO
