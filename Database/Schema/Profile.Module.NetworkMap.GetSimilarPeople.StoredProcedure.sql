SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[NetworkMap.GetSimilarPeople]
	@NodeID BIGINT,
	@show_connections BIT=0,
	@SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN
 
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;
 
 
 
	DECLARE @PersonID INT
 
	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
 
	DECLARE  @f  TABLE(
		personid INT,
		internalldapusername NVARCHAR(50),
		display_name NVARCHAR(255),
		latitude FLOAT,
		longitude FLOAT,
		address1 NVARCHAR(1000),
		address2 NVARCHAR(1000),
		URI VARCHAR(400)
	)
 
	INSERT INTO @f
						 (personid, 
							display_name,
							latitude,
							longitude,
							address1,
							address2)
	SELECT p.personid, 
				 p.displayname,
				 l.latitude,
				 l.longitude,
				 CASE WHEN p.addressstring LIKE '%,%' THEN LEFT(p.addressstring,CHARINDEX(',',p.addressstring) - 1)ELSE p.addressstring END  address1,
				 REPLACE(SUBSTRING(p.addressstring,CHARINDEX(',',p.addressstring) + 1,
													 LEN(p.addressstring)),', USA','') address2
		FROM [Profile.Cache].Person p,  
				 (SELECT @PersonID personid,
								 0         latitude
					UNION ALL
					SELECT SimilarPersonID, 0 FROM [Profile.Cache].[Person.SimilarPerson] WHERE PersonID = @PersonID
					--SELECT *
					--FROM fn_GetTopSimilarPeople(@PersonID) s
					) t,
				[Profile.Cache].Person l  
	 WHERE p.personid = t.personid
		 AND p.personid = l.personid 
		 AND l.latitude IS NOT NULL
		 AND l.longitude IS NOT NULL
	 ORDER BY latitude DESC,
				 p.lastname,
				 p.firstname
 
 
	UPDATE @f
		SET URI = p.Value + cast(m.NodeID as varchar(50))
		FROM @f, [RDF.Stage].InternalNodeMap m, [Framework.].Parameter p
		WHERE p.ParameterID = 'baseURI' AND m.InternalHash = [RDF.].fnValueHash(null,null,'http://xmlns.com/foaf/0.1/Person^^Person^^'+cast(PersonID as  varchar(50)))
 
	DELETE FROM @f WHERE URI IS NULL
 
 
	IF @show_connections = 0
	BEGIN
		SELECT personid,
					 internalldapusername,
					 display_name,
					 latitude,
					 longitude,
					 address1,
					 address2,
					 uri
			FROM @f
		 ORDER BY address1,
					 address2,
					 display_name
	END
	ELSE
	BEGIN
		SELECT DISTINCT a.latitude        x1,
						a.longitude        y1,
						d.latitude        x2,
						d.longitude        y2,
						a.personid a,
						d.personid b,
						(CASE 
							 WHEN a.personid = @PersonID
										 OR d.personid= @PersonID THEN 1
							 ELSE 0
						 END) is_person,
						a.URI u1,
						d.URI u2
			FROM @f a,
					 [Profile.Data].[Publication.Person.Include] b,
					 [Profile.Data].[Publication.Person.Include] c,
					 @f d
		 WHERE a.personid = b.personid
			 AND b.pmid = c.pmid
			 AND b.personid < c.personid
			 AND c.personid = d.personid
	END
		
 
END
GO
