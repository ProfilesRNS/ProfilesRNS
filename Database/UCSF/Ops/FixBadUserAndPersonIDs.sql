-- remove old ones that were fixed
delete from [User.Session].[Session] where UserID in 
(select [UserID] from [User.Account].[User] where UserID != UCSF.fnGeneratePersonID(internalusername));

delete from [User.Account].[User] where UserID != UCSF.fnGeneratePersonID(internalusername) and InternalUserName in
(select internalusername FROM [User.Account].[User] where UserID = UCSF.fnGeneratePersonID(internalusername));

delete from [User.Account].[User] where PersonID is not null AND PersonID != UCSF.fnGeneratePersonID(internalusername) and InternalUserName in
(select internalusername FROM [User.Account].[User] where PersonID is not null AND PersonID = UCSF.fnGeneratePersonID(internalusername));

delete from [Profile.Data].[Person] where PersonID != UCSF.fnGeneratePersonID(internalusername) and InternalUserName in
(select internalusername FROM [Profile.Data].[Person] where PersonID = UCSF.fnGeneratePersonID(internalusername));

set IDENTITY_INSERT [Profile.Data].[Person] ON;

INSERT INTO [Profile.Data].[Person]
([PersonID]
      ,[UserID]
      ,[FirstName]
      ,[LastName]
      ,[MiddleName]
      ,[DisplayName]
      ,[Suffix]
      ,[IsActive]
      ,[EmailAddr]
      ,[Phone]
      ,[Fax]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[AddressLine3]
      ,[AddressLine4]
      ,[City]
      ,[State]
      ,[Zip]
      ,[Building]
      ,[Floor]
      ,[Room]
      ,[AddressString]
      ,[Latitude]
      ,[Longitude]
      ,[GeoScore]
      ,[FacultyRankID]
      ,[InternalUsername]
      ,[Visible] )
SELECT       
UCSF.fnGeneratePersonID(internalusername), UCSF.fnGeneratePersonID(internalusername)
      ,[FirstName]
      ,[LastName]
      ,[MiddleName]
      ,[DisplayName]
      ,[Suffix]
      ,[IsActive]
      ,[EmailAddr]
      ,[Phone]
      ,[Fax]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[AddressLine3]
      ,[AddressLine4]
      ,[City]
      ,[State]
      ,[Zip]
      ,[Building]
      ,[Floor]
      ,[Room]
      ,[AddressString]
      ,[Latitude]
      ,[Longitude]
      ,[GeoScore]
      ,[FacultyRankID]
      ,[InternalUsername]
      ,[Visible] FROM [Profile.Data].[Person] where PersonID != UCSF.fnGeneratePersonID(internalusername);
set IDENTITY_INSERT [Profile.Data].[Person] OFF;

-- rewire those that have a good userid but bad personid
UPDATE [User.Account].[User] set PersonID = UCSF.fnGeneratePersonID(internalusername)
where UserID = UCSF.fnGeneratePersonID(internalusername) and PersonID is not null AND 
personID != UCSF.fnGeneratePersonID(internalusername);

set IDENTITY_INSERT [User.Account].[User] ON;
-- add messed up UserIDs for users without profiles
INSERT INTO [User.Account].[User] 
	([UserID], [PersonID]
      ,[IsActive]
      ,[CanBeProxy]
      ,[FirstName]
      ,[LastName]
      ,[DisplayName]
      ,[Institution]
      ,[Department]
      ,[Division]
      ,[EmailAddr]
      ,[UserName]
      ,[Password]
      ,[CreateDate]
      ,[ApplicationName]
      ,[Comment]
      ,[IsApproved]
      ,[IsOnline]
      ,[InternalUserName]
      ,[NodeID])
SELECT UCSF.fnGeneratePersonID(internalusername)
      ,null
      ,[IsActive]
      ,[CanBeProxy]
      ,[FirstName]
      ,[LastName]
      ,[DisplayName]
      ,[Institution]
      ,[Department]
      ,[Division]
      ,[EmailAddr]
      ,[UserName]
      ,[Password]
      ,[CreateDate]
      ,[ApplicationName]
      ,[Comment]
      ,[IsApproved]
      ,[IsOnline]
      ,[InternalUserName]
      ,[NodeID]
  FROM [User.Account].[User] where UserID != UCSF.fnGeneratePersonID(internalusername) and PersonID is null;

-- add messed up UserIDs for users with profiles
INSERT INTO [User.Account].[User] 
	([UserID], [PersonID]
      ,[IsActive]
      ,[CanBeProxy]
      ,[FirstName]
      ,[LastName]
      ,[DisplayName]
      ,[Institution]
      ,[Department]
      ,[Division]
      ,[EmailAddr]
      ,[UserName]
      ,[Password]
      ,[CreateDate]
      ,[ApplicationName]
      ,[Comment]
      ,[IsApproved]
      ,[IsOnline]
      ,[InternalUserName]
      ,[NodeID])
SELECT UCSF.fnGeneratePersonID(internalusername)
      ,UCSF.fnGeneratePersonID(internalusername)
      ,[IsActive]
      ,[CanBeProxy]
      ,[FirstName]
      ,[LastName]
      ,[DisplayName]
      ,[Institution]
      ,[Department]
      ,[Division]
      ,[EmailAddr]
      ,[UserName]
      ,[Password]
      ,[CreateDate]
      ,[ApplicationName]
      ,[Comment]
      ,[IsApproved]
      ,[IsOnline]
      ,[InternalUserName]
      ,[NodeID]
  FROM [User.Account].[User] where (UserID != UCSF.fnGeneratePersonID(internalusername) 
  OR PersonID != UCSF.fnGeneratePersonID(internalusername) ) 
	and PersonID is not null;
set IDENTITY_INSERT [User.Account].[User] OFF;

-- 
-- now remove bad user accounts
delete from [User.Account].[User] where UserID != UCSF.fnGeneratePersonID(internalusername);

delete from [User.Account].[User] where PersonID != UCSF.fnGeneratePersonID(internalusername) AND PersonID is not null;

-- test user accounts, they should be clean now
select internalusername, COUNT(*) from [User.Account].[User] group by InternalUserName order by COUNT(*) desc;

-- now start fixing person data
-- pubs
UPDATE i set i.PersonID = UCSF.fnGeneratePersonID(p.internalusername)  
 FROM [Profile.Data].[Publication.Person.Include] i join [Profile.Data].Person p on 
 p.PersonID = i.PersonID where p.PersonID != UCSF.fnGeneratePersonID(internalusername); --1112
 
UPDATE a set a.PersonID = UCSF.fnGeneratePersonID(p.internalusername)  
 FROM [Profile.Data].[Publication.Person.Add] a join [Profile.Data].Person p on 
 p.PersonID = a.PersonID where p.PersonID != UCSF.fnGeneratePersonID(internalusername); --11

-- disambiguation 
UPDATE d set d.PersonID = UCSF.fnGeneratePersonID(p.internalusername)  
 FROM [Profile.Data].[Publication.PubMed.Disambiguation] d join [Profile.Data].Person p on 
 p.PersonID = d.PersonID where p.PersonID != UCSF.fnGeneratePersonID(internalusername); --1109
 
 -- pubs general 
UPDATE g set g.PersonID = UCSF.fnGeneratePersonID(p.internalusername)  
 FROM [Profile.Data].[Publication.MyPub.General] g join [Profile.Data].Person p on 
 p.PersonID = g.PersonID where p.PersonID != UCSF.fnGeneratePersonID(internalusername); --3
 
-- photo
UPDATE ph set ph.PersonID = UCSF.fnGeneratePersonID(p.internalusername)  
 FROM [Profile.Data].[Person.Photo] ph join [Profile.Data].Person p on 
 p.PersonID = ph.PersonID where p.PersonID != UCSF.fnGeneratePersonID(internalusername); --1
 
-- affiliation
UPDATE a set a.PersonID = UCSF.fnGeneratePersonID(p.internalusername)  
 FROM [Profile.Data].[Person.Affiliation] a join [Profile.Data].Person p on 
 p.PersonID = a.PersonID where p.PersonID != UCSF.fnGeneratePersonID(internalusername); --77
 
--delete from select * from [Profile.Data].[Person] where UserID != UCSF.fnGeneratePersonID(internalusername); --81
delete from [Profile.Data].[Person] where PersonID != UCSF.fnGeneratePersonID(internalusername); --81

-- test profiles, they should be clean now
select internalusername, COUNT(*) from [Profile.Data].[Person] group by InternalUserName order by COUNT(*) desc;
select internalusername, COUNT(*) from [User.Account].[User] group by InternalUserName order by COUNT(*) desc;

select * from [User.Account].[User] where PersonID is not null and PersonID not in 
(select PersonID from [Profile.Data].[Person]);

select * from [Profile.Data].[Person] where UserID not in 
(select UserID from [User.Account].[User]);

select * from [Profile.Data].[Person] where UserID != PersonID;

select * from [Profile.Data].[Person] where internalusername in (
'027271634',
'023346802',
'025844432',
'024266918',
'028236842',
'023558539',
'023537871',
'021595913',
'026788786',
'028214088',
'022368377',
'021779632',
'029754157',
'028787737',
'025404625',
'020939765',
'023675978',
'029338274',
'029027695',
'027047968',
'023126311',
'028055275',
'029418555',
'027641414',
'027082676',
'022125793',
'027967702',
'023448327',
'028708766',
'020416095',
'023918196',
'026716498',
'022884035',
'027508936',
'026556571',
'024301202',
'024070682',
'022594378',
'026489393',
'028105047',
'024633331',
'029352580',
'027527530',
'025810185',
'027641265',
'028189272',
'023066772',
'023506777',
'029791274',
'023255409',
'028532810',
'026277871',
'020199006',
'027311265',
'027708619',
'020667119',
'028909018',
'028823888',
'020169462',
'024128589',
'028245074',
'026389726',
'023240724',
'024727737',
'024507774',
'024037756',
'026570648',
'020321485',
'024628224',
'024064768',
'022302822',
'021600267',
'024079790',
'023670995',
'026121426',
'022895213',
'025854662',
'028748168',
'027491810',
'024084428',
'025291287');
