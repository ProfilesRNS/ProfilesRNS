/*

Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD., and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the National Center for Research Resources and Harvard University.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name "Harvard" nor the names of its contributors nor the name "Harvard Catalyst" may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER (PRESIDENT AND FELLOWS OF HARVARD COLLEGE) AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


*/
exec sp_fulltext_database 'enable'

go
CREATE SCHEMA [Direct.] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Direct.Framework] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Edit.Framework] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Edit.Module] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Framework.] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Login.Framework] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Module.Beta] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Module.Edit] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Module.Profile] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Ontology.] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Ontology.Import] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Ontology.Presentation] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Profile.Cache] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Profile.Data] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Profile.Framework] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Profile.Import] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Profile.Module] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [RDF.] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [RDF.Cache] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [RDF.Search] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [RDF.Security] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [RDF.SemWeb] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [RDF.Stage] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Search.] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Search.Cache] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Search.Framework] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [User.Account] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [User.Session] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Utility.Application] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Utility.Math] AUTHORIZATION [dbo]
GO
CREATE SCHEMA [Utility.NLP] AUTHORIZATION [dbo]
GO
CREATE FULLTEXT CATALOG [ft]
WITH ACCENT_SENSITIVITY = ON
AS DEFAULT
AUTHORIZATION [dbo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[History.TopSearchPhrase](
	[TimePeriod] [char](1) NOT NULL,
	[Phrase] [varchar](100) NOT NULL,
	[NumberOfQueries] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TimePeriod] ASC,
	[Phrase] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [User.Session].[History.ResolveURL](
	[HistoryID] [int] IDENTITY(0,1) NOT NULL,
	[RequestDate] [datetime] NULL,
	[ApplicationName] [varchar](1000) NULL,
	[param1] [varchar](1000) NULL,
	[param2] [varchar](1000) NULL,
	[param3] [varchar](1000) NULL,
	[param4] [varchar](1000) NULL,
	[param5] [varchar](1000) NULL,
	[param6] [varchar](1000) NULL,
	[param7] [varchar](1000) NULL,
	[param8] [varchar](1000) NULL,
	[param9] [varchar](1000) NULL,
	[SessionID] [uniqueidentifier] NULL,
	[RestURL] [varchar](max) NULL,
	[UserAgent] [varchar](255) NULL,
	[ContentType] [varchar](255) NULL,
	[CustomResolver] [varchar](1000) NULL,
	[Resolved] [bit] NULL,
	[ErrorDescription] [varchar](max) NULL,
	[ResponseURL] [varchar](1000) NULL,
	[ResponseContentType] [varchar](255) NULL,
	[ResponseStatusCode] [int] NULL,
	[ResponseRedirect] [bit] NULL,
	[ResponseIncludePostData] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_Session_Date] ON [User.Session].[History.ResolveURL] 
(
	[SessionID] ASC,
	[RequestDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.].[History.Query](
	[SearchHistoryQueryID] [int] IDENTITY(0,1) NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[DurationMS] [int] NULL,
	[SessionID] [uniqueidentifier] NULL,
	[IsBot] [bit] NULL,
	[NumberOfConnections] [int] NULL,
	[SearchOptions] [xml] NULL,
PRIMARY KEY CLUSTERED 
(
	[SearchHistoryQueryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.].[History.Phrase](
	[SearchHistoryPhraseID] [int] IDENTITY(0,1) NOT NULL,
	[SearchHistoryQueryID] [int] NULL,
	[PhraseID] [int] NULL,
	[ThesaurusMatch] [bit] NULL,
	[Phrase] [varchar](max) NULL,
	[EndDate] [datetime] NULL,
	[IsBot] [bit] NULL,
	[NumberOfConnections] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SearchHistoryPhraseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_QueryID] ON [Search.].[History.Phrase] 
(
	[SearchHistoryQueryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.Security].[Group](
	[SecurityGroupID] [bigint] NOT NULL,
	[Label] [varchar](255) NOT NULL,
	[HasSpecialViewAccess] [bit] NULL,
	[HasSpecialEditAccess] [bit] NULL,
	[Description] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[SecurityGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [RDF.].[fnTripleHash] (
	@Subject	bigint,
	@Predicate	bigint,
	@Object		bigint
) 
RETURNS binary(20)
AS
BEGIN
	DECLARE @result binary(20)
	SELECT @result = convert(binary(20),HashBytes('sha1',
						convert(nvarchar(max),
							+N'"'
							+N'<#'+convert(nvarchar(max),@Subject)+N'> '
							+N'<#'+convert(nvarchar(max),@Predicate)+N'> '
							+N'<#'+convert(nvarchar(max),@Object)+N'> .'
							+N'"'
							+N'^^http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement'
						)
					))
	RETURN @result
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [Utility.Application].[fnText2Bool] (@bool VARCHAR(5))
RETURNS varchar(5) 
begin
	return CASE WHEN @bool = 'true' THEN 1 ELSE 0 END
	
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Framework.].[LICENCE]
AS
BEGIN
PRINT 
'
Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD., and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the National Center for Research Resources and Harvard University.
 
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
	* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	* Neither the name "Harvard" nor the names of its contributors nor the name "Harvard Catalyst" may be used to endorse or promote products derived from this software without specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER (PRESIDENT AND FELLOWS OF HARVARD COLLEGE) AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Framework.].[JobGroup](
	[JobGroup] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[Description] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[JobGroup] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Framework.].[Job](
	[JobID] [int] NOT NULL,
	[JobGroup] [int] NULL,
	[Step] [int] NULL,
	[IsActive] [bit] NULL,
	[Script] [nvarchar](max) NULL,
	[Status] [varchar](50) NULL,
	[LastStart] [datetime] NULL,
	[LastEnd] [datetime] NULL,
	[ErrorCode] [int] NULL,
	[ErrorMsg] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[JobID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.Stage].[InternalNodeMap](
	[InternalNodeMapID] [bigint] IDENTITY(1,1) NOT NULL,
	[Class] [nvarchar](400) NOT NULL,
	[InternalType] [nvarchar](300) NOT NULL,
	[InternalID] [nvarchar](100) NOT NULL,
	[ViewSecurityGroup] [bigint] NULL,
	[EditSecurityGroup] [bigint] NULL,
	[InternalHash] [binary](20) NOT NULL,
	[NodeID] [bigint] NULL,
	[ValueHash] [binary](20) NULL,
	[Status] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[InternalNodeMapID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_ClassInternalTypeID] ON [RDF.Stage].[InternalNodeMap] 
(
	[Class] ASC,
	[InternalType] ASC,
	[InternalID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_InternalHash] ON [RDF.Stage].[InternalNodeMap] 
(
	[InternalHash] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_InternalNodeMapStatus] ON [RDF.Stage].[InternalNodeMap] 
(
	[Status] ASC
)
INCLUDE ( [InternalNodeMapID],
[InternalHash],
[NodeID],
[Class],
[InternalType],
[InternalID],
[ValueHash]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_StageInternalNodeMap] ON [RDF.Stage].[InternalNodeMap] 
(
	[NodeID] ASC
)
INCLUDE ( [Class],
[InternalType]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_StatusValueHash] ON [RDF.Stage].[InternalNodeMap] 
(
	[Status] ASC,
	[ValueHash] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_1] ON [RDF.Stage].[InternalNodeMap] 
(
	[NodeID] ASC
)
INCLUDE ( [Class],
[InternalType]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_72997] ON [RDF.Stage].[InternalNodeMap] 
(
	[Status] ASC
)
INCLUDE ( [InternalNodeMapID],
[InternalHash],
[NodeID],
[Class],
[InternalType],
[InternalID],
[ValueHash]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Framework.].[InstallData](
	[InstallDataID] [int] IDENTITY(0,1) NOT NULL,
	[Data] [xml] NULL,
 CONSTRAINT [PK__InstallData__7CA47C3F] PRIMARY KEY CLUSTERED 
(
	[InstallDataID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Organization.Division](
	[DivisionID] [int] IDENTITY(1,1) NOT NULL,
	[DivisionName] [nvarchar](500) NULL,
 CONSTRAINT [PK__division] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Organization.Department](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [nvarchar](500) NULL,
	[Visible] [bit] NULL,
 CONSTRAINT [PK__department] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.Security].[NodeProperty](
	[NodeID] [bigint] NOT NULL,
	[Property] [bigint] NOT NULL,
	[ViewSecurityGroup] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC,
	[Property] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.].[Node](
	[NodeID] [bigint] IDENTITY(1,1) NOT NULL,
	[ValueHash] [binary](20) NOT NULL,
	[Language] [nvarchar](255) NULL,
	[DataType] [nvarchar](255) NULL,
	[Value] [nvarchar](max) NOT NULL,
	[InternalNodeMapID] [int] NULL,
	[ObjectType] [bit] NULL,
	[ViewSecurityGroup] [bigint] NULL,
	[EditSecurityGroup] [bigint] NULL,
 CONSTRAINT [PK__Node__72C60C4A] PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_ValueHash] ON [RDF.].[Node] 
(
	[ValueHash] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE FULLTEXT INDEX ON [RDF.].[Node](
[Value] LANGUAGE [English])
KEY INDEX [PK__Node__72C60C4A] ON [ft]
WITH CHANGE_TRACKING AUTO
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[Person](
	[internalusername] [nvarchar](1000) NULL,
	[firstname] [nvarchar](1000) NULL,
	[middlename] [nvarchar](1000) NULL,
	[lastname] [nvarchar](1000) NULL,
	[displayname] [nvarchar](1000) NULL,
	[suffix] [nvarchar](1000) NULL,
	[addressline1] [nvarchar](1000) NULL,
	[addressline2] [nvarchar](1000) NULL,
	[addressline3] [nvarchar](1000) NULL,
	[addressline4] [nvarchar](1000) NULL,
	[addressstring] [nvarchar](1000) NULL,
	[City] [nvarchar](1000) NULL,
	[State] [nvarchar](1000) NULL,
	[Zip] [nvarchar](1000) NULL,
	[building] [nvarchar](1000) NULL,
	[room] [nvarchar](1000) NULL,
	[floor] [nvarchar](100) NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[phone] [nvarchar](1000) NULL,
	[fax] [nvarchar](1000) NULL,
	[emailaddr] [nvarchar](1000) NULL,
	[isactive] [bit] NULL,
	[isvisible] [bit] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Person](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[DisplayName] [nvarchar](255) NULL,
	[Suffix] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
	[EmailAddr] [nvarchar](255) NULL,
	[Phone] [nvarchar](35) NULL,
	[Fax] [nvarchar](25) NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[AddressLine3] [nvarchar](255) NULL,
	[AddressLine4] [nvarchar](255) NULL,
	[City] [nvarchar](55) NULL,
	[State] [nvarchar](50) NULL,
	[Zip] [nvarchar](50) NULL,
	[Building] [nvarchar](255) NULL,
	[Floor] [int] NULL,
	[Room] [nvarchar](255) NULL,
	[AddressString] [nvarchar](1000) NULL,
	[Latitude] [decimal](18, 14) NULL,
	[Longitude] [decimal](18, 14) NULL,
	[GeoScore] [tinyint] NULL,
	[FacultyRankID] [int] NULL,
	[InternalUsername] [nvarchar](50) NULL,
	[Visible] [bit] NULL,
 CONSTRAINT [PK__person] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Person](
	[PersonID] [int] NOT NULL,
	[UserID] [int] NULL,
	[InternalUsername] [nvarchar](100) NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[DisplayName] [nvarchar](510) NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[AddressLine3] [nvarchar](255) NULL,
	[AddressLine4] [nvarchar](255) NULL,
	[AddressString] [nvarchar](2000) NULL,
	[Building] [nvarchar](510) NULL,
	[Room] [nvarchar](510) NULL,
	[Floor] [int] NULL,
	[Latitude] [decimal](18, 14) NULL,
	[Longitude] [decimal](18, 14) NULL,
	[Phone] [nvarchar](70) NULL,
	[Fax] [nvarchar](50) NULL,
	[EmailAddr] [nvarchar](510) NULL,
	[InstitutionName] [nvarchar](1000) NULL,
	[InstitutionAbbreviation] [nvarchar](100) NULL,
	[DepartmentName] [nvarchar](1000) NULL,
	[DivisionFullName] [nvarchar](1000) NULL,
	[FacultyRank] [varchar](100) NULL,
	[FacultyRankSort] [tinyint] NULL,
	[IsActive] [bit] NULL,
	[ShowAddress] [char](1) NULL,
	[ShowPhone] [char](1) NULL,
	[Showfax] [char](1) NULL,
	[ShowEmail] [char](1) NULL,
	[ShowPhoto] [char](1) NULL,
	[ShowAwards] [char](1) NULL,
	[ShowNarrative] [char](1) NULL,
	[ShowPublications] [char](1) NULL,
	[Visible] [bit] NULL,
	[NumPublications] [int] NULL,
	[PersonXML] [xml] NULL,
	[HasPublications] [bit] NULL,
	[HasSNA] [bit] NULL,
	[Reach1] [int] NULL,
	[Reach2] [int] NULL,
	[Closeness] [float] NULL,
	[Betweenness] [float] NULL,
 CONSTRAINT [PK_cache_person] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Person_Department] ON [Profile.Cache].[Person] 
(
	[DepartmentName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Person.Affiliation](
	[PersonAffiliationID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
	[IsPrimary] [bit] NULL,
	[InstitutionID] [int] NULL,
	[DepartmentID] [int] NULL,
	[DivisionID] [int] NULL,
	[Title] [nvarchar](200) NULL,
	[EmailAddress] [nvarchar](200) NULL,
	[FacultyRankID] [int] NULL,
 CONSTRAINT [PK__person_affiliations] PRIMARY KEY CLUSTERED 
(
	[PersonAffiliationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PersonAffiliationSortOrder] ON [Profile.Data].[Person.Affiliation] 
(
	[SortOrder] ASC
)
INCLUDE ( [PersonAffiliationID],
[PersonID],
[Title]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_73248] ON [Profile.Data].[Person.Affiliation] 
(
	[SortOrder] ASC
)
INCLUDE ( [PersonAffiliationID],
[PersonID],
[Title]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Person.Affiliation](
	[PersonID] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsPrimary] [bit] NULL,
	[Title] [varchar](max) NULL,
	[InstititutionName] [varchar](200) NULL,
	[InstitutionAbbreviation] [varchar](100) NULL,
	[DepartmentName] [varchar](200) NULL,
	[DivisionName] [varchar](200) NULL,
	[FacultyRank] [varchar](200) NULL,
 CONSTRAINT [PK_cache_person_affiliations] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Person.Filter](
	[PersonFilterID] [int] IDENTITY(1,1) NOT NULL,
	[PersonFilter] [varchar](200) NULL,
	[PersonFilterCategory] [varchar](200) NULL,
	[PersonFilterSort] [int] NULL,
 CONSTRAINT [PK__PersonFilter__1CF15040] PRIMARY KEY CLUSTERED 
(
	[PersonFilterID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Person.FacultyRank](
	[FacultyRankID] [int] IDENTITY(1,1) NOT NULL,
	[FacultyRank] [varchar](100) NULL,
	[FacultyRankSort] [tinyint] NULL,
	[Visible] [bit] NULL,
 CONSTRAINT [PK_faculty_rank] PRIMARY KEY CLUSTERED 
(
	[FacultyRankID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Person.SimilarPerson](
	[PersonID] [int] NOT NULL,
	[SimilarPersonID] [int] NOT NULL,
	[Weight] [float] NULL,
	[CoAuthor] [bit] NULL,
	[numberOfSubjectAreas] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[SimilarPersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Person.PhysicalNeighbor](
	[PersonID] [int] NOT NULL,
	[NeighborID] [int] NOT NULL,
	[Distance] [tinyint] NULL,
	[DisplayName] [nvarchar](255) NULL,
	[MyNeighbors] [nvarchar](100) NULL,
 CONSTRAINT [PK__cache_physical_n__39D17EC3] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[NeighborID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.].[Namespace](
	[URI] [varchar](500) NOT NULL,
	[Prefix] [varchar](50) NOT NULL,
 CONSTRAINT [PK__Namespaces__07C12930] PRIMARY KEY CLUSTERED 
(
	[URI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Utility.Math].[N](
	[n] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[n] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.Security].[Member](
	[UserID] [int] NOT NULL,
	[SecurityGroupID] [bigint] NOT NULL,
	[IsVisible] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[SecurityGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_su] ON [RDF.Security].[Member] 
(
	[SecurityGroupID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Direct.].[LogOutgoing](
	[FSID] [uniqueidentifier] NULL,
	[SiteID] [int] NULL,
	[Details] [bit] NULL,
	[SentDate] [datetime] NULL,
	[ResponseTime] [float] NULL,
	[ResponseState] [int] NULL,
	[ResponseStatus] [int] NULL,
	[ResultText] [varchar](4000) NULL,
	[ResultCount] [varchar](10) NULL,
	[ResultDetailsURL] [varchar](1000) NULL,
	[QueryString] [varchar](1000) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Direct.].[LogIncoming](
	[Details] [bit] NULL,
	[ReceivedDate] [datetime] NULL,
	[RequestIP] [varchar](16) NULL,
	[QueryString] [varchar](1000) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.Stage].[Log.Triple](
	[LogID] [bigint] IDENTITY(0,1) NOT NULL,
	[CompleteDate] [datetime] NULL,
	[NewNodes] [bigint] NULL,
	[NewTriples] [bigint] NULL,
	[FoundRecords] [bigint] NULL,
	[ProcessedRecords] [bigint] NULL,
	[TimeElapsed] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Framework.].[Log.Job](
	[LogID] [int] IDENTITY(0,1) NOT NULL,
	[JobID] [int] NULL,
	[JobGroup] [int] NULL,
	[Step] [int] NULL,
	[Script] [nvarchar](max) NULL,
	[JobStart] [datetime] NULL,
	[JobEnd] [datetime] NULL,
	[Status] [varchar](50) NULL,
	[ErrorCode] [int] NULL,
	[ErrorMsg] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.Stage].[Log.DataMap](
	[LogID] [bigint] IDENTITY(0,1) NOT NULL,
	[DataMapID] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[RunTimeMS] [int] NULL,
	[DataMapType] [tinyint] NULL,
	[NewNodes] [bigint] NULL,
	[UpdatedNodes] [bigint] NULL,
	[ExistingNodes] [bigint] NULL,
	[DeletedNodes] [bigint] NULL,
	[TotalNodes] [bigint] NULL,
	[NewTriples] [bigint] NULL,
	[UpdatedTriples] [bigint] NULL,
	[ExistingTriples] [bigint] NULL,
	[DeletedTriples] [bigint] NULL,
	[TotalTriples] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_73290] ON [RDF.Stage].[Log.DataMap] 
(
	[DataMapID] ASC,
	[LogID] ASC
)
INCLUDE ( [RunTimeMS]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Framework.].[LoadXMLFile](@FilePath varchar(max), @TableDestination VARCHAR(MAX), @DestinationColumn VARCHAR(MAX), @NameValue VARCHAR(MAX)=NULL )
AS
BEGIN
	 
	SET NOCOUNT ON;

	/*

	This stored procedure imports the contents of an xml file into the 
	specified table and column from a supplied filepath. 

	Input parameters:
		@FilePath				Path where xml data file exists, relative to the sql server.		  
		@TableDestination		Table where data is to be stored
		@DestinationColumn		Column where data is to be stored
		@NameValue				Name of the file (optional)

	Test Call:
		[Framework.].[uspLoadXMLFile] 'c:\InstallData.xml', '[Framework.].[InstallData]', 'Data', 'VIVO_1.4'
		
	*/

	DECLARE @sql NVARCHAR(MAX)
	 
	SELECT @SQL = 'INSERT INTO ' + @TableDestination + '(' + @DestinationColumn + CASE WHEN @NameValue IS NOT NULL THEN ',Name' ELSE '' END +  ') 
									 SELECT  xXML' + CASE WHEN @NameValue IS NOT NULL THEN ',''' + @NameValue + '''' ELSE '' END + ' FROM   ( SELECT CONVERT(xml, BulkColumn, 2) FROM OPENROWSET(BULK ''' + @FilePath + ''', SINGLE_BLOB) AS T ) AS x ( xXML )'  
	 
	EXEC SP_EXECUTESQL @SQL 

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Utility.NLP].[ParsePorterStemming](
	[Step] [int] NOT NULL,
	[Ordering] [int] NOT NULL,
	[phrase1] [nvarchar](15) NOT NULL,
	[phrase2] [nvarchar](15) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Framework.].[Parameter](
	[ParameterID] [varchar](50) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK__Parameters__498EEC8D] PRIMARY KEY CLUSTERED 
(
	[ParameterID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.Presentation].[Panel](
	[PresentationID] [int] NOT NULL,
	[Type] [varchar](100) NOT NULL,
	[TabSort] [int] NOT NULL,
	[TabType] [varchar](100) NULL,
	[Alias] [varchar](max) NULL,
	[Name] [varchar](max) NULL,
	[Icon] [varchar](max) NULL,
	[DisplayRule] [varchar](max) NULL,
	[ModuleXML] [xml] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.Import].[OWL](
	[Name] [nvarchar](100) NOT NULL,
	[Data] [xml] NULL,
	[Graph] [bigint] NULL,
 CONSTRAINT [PK__owl__656C112C] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Organization.Institution](
	[InstitutionID] [int] IDENTITY(1,1) NOT NULL,
	[InstitutionName] [nvarchar](500) NULL,
	[InstitutionAbbreviation] [nvarchar](50) NULL,
 CONSTRAINT [PK__institution] PRIMARY KEY CLUSTERED 
(
	[InstitutionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [Utility.Application].[fnBool2Text] (@bool BIT)
RETURNS varchar(5) 
begin
	return CASE WHEN @bool = 1 THEN 'true' ELSE 'false' END
	
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.Application].[fnBinaryToBase64] (@Binary VARBINARY(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN CAST(N'' AS XML).value('xs:base64Binary(xs:hexBinary(sql:variable("@Binary")))', 'VARCHAR(MAX)')
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.Application].[fnBase64ToBinary] (@Base64 VARCHAR(MAX))
RETURNS VARBINARY(MAX)
AS
BEGIN
	RETURN CAST(N'' AS XML).value('xs:base64Binary(sql:variable("@Base64"))', 'VARBINARY(MAX)')
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [User.Account].[DesignatedProxy](
	[UserID] [int] NOT NULL,
	[ProxyForUserID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[ProxyForUserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_pu] ON [User.Account].[DesignatedProxy] 
(
	[ProxyForUserID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [User.Account].[DefaultProxy](
	[DefaultProxyID] [int] IDENTITY(0,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ProxyForInstitution] [nvarchar](500) NULL,
	[ProxyForDepartment] [nvarchar](500) NULL,
	[ProxyForDivision] [nvarchar](500) NULL,
	[IsVisible] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[DefaultProxyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_u] ON [User.Account].[DefaultProxy] 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.].[DataMap](
	[DataMapID] [int] NOT NULL,
	[DataMapGroup] [int] NULL,
	[IsAutoFeed] [bit] NULL,
	[Graph] [bigint] NULL,
	[Class] [varchar](400) NULL,
	[NetworkProperty] [varchar](400) NULL,
	[Property] [varchar](1000) NULL,
	[MapTable] [varchar](max) NULL,
	[sInternalType] [varchar](1000) NULL,
	[sInternalID] [varchar](1000) NULL,
	[cClass] [varchar](400) NULL,
	[cInternalType] [varchar](1000) NULL,
	[cInternalID] [varchar](1000) NULL,
	[oClass] [varchar](400) NULL,
	[oInternalType] [varchar](1000) NULL,
	[oInternalID] [varchar](1000) NULL,
	[oValue] [varchar](1000) NULL,
	[oDataType] [varchar](1000) NULL,
	[oLanguage] [varchar](1000) NULL,
	[oStartDate] [varchar](1000) NULL,
	[oStartDatePrecision] [varchar](1000) NULL,
	[oEndDate] [varchar](1000) NULL,
	[oEndDatePrecision] [varchar](1000) NULL,
	[oObjectType] [bit] NULL,
	[Weight] [varchar](1000) NULL,
	[OrderBy] [varchar](1000) NULL,
	[ViewSecurityGroup] [varchar](1000) NULL,
	[EditSecurityGroup] [varchar](1000) NULL,
	[_ClassNode] [bigint] NULL,
	[_NetworkPropertyNode] [bigint] NULL,
	[_PropertyNode] [bigint] NULL,
 CONSTRAINT [PK__DataMap__966C304141713BA7] PRIMARY KEY CLUSTERED 
(
	[DataMapID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_cnps] ON [Ontology.].[DataMap] 
(
	[Class] ASC,
	[NetworkProperty] ASC,
	[Property] ASC,
	[sInternalType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [Utility.NLP].[fnNormalize]
	(
		@InWord nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN
    DECLARE @Temp nvarchar(4000)
	DECLARE @Norm nvarchar(4000)
	DECLARE @i int
	DECLARE @c varchar(1)
	DECLARE @lastc varchar(1)

    SELECT @Temp = LOWER(ISNULL(RTRIM(LTRIM(@InWord)),N''))

	SET @Norm = ''
	SET @i = 1
	SET @lastc = ''

	WHILE @i <= LEN(@Temp)
	BEGIN
		SET @c = (select substring(@Temp,@i,1))
		IF not ((ascii(@c) between 48 and 57) or (ascii(@c) between 97 and 122))
			SET @c = ' '
		IF (@c <> '') or (@lastc <> ' ')
			SET @Norm = @Norm + @c
		SET @lastc = @c
		SET @i = @i + 1
	END

    RETURN RTRIM(LTRIM(@Norm))
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [Utility.NLP].[fnNamePart1]
(
	@s nvarchar(500)
)
RETURNS nvarchar(500)
AS
BEGIN

	set @s = (
		select
			replace(replace((case when charindex(' ',x) = 0 then x else left(x,charindex(' ',x)-1) end),'^$',' '),'^#','-')
		from (
			select
				substring(
					replace(replace(replace(
					replace(replace(replace(replace(replace(replace(replace(replace(
					replace(replace(replace(replace(replace(replace(replace(replace(
					replace(replace(replace(replace(
					' '+ltrim(rtrim(replace(
					@s
					,'.',' ')))
					,' de la ',' de^$la^$'),' de-la ',' de^#la^$'),' de la-',' de^$la^#'),' de-la-',' de^#la^#')
					,' da ',' da^$'),' de ',' de^$'),' del ',' del^$'),' do ',' do^$'),' dos ',' dos^$'),' du ',' du^$'),' el ',' el^$'),' le ',' le^$')
					,' da-',' da^#'),' de-',' de^#'),' del-',' del^#'),' do-',' do^#'),' dos-',' dos^#'),' du-',' du^#'),' el-',' el^#'),' le-',' le^#')
					,' -',' ^#'),'-',' '),'  ',' ')
				,2,999) x
		) t
	)

	RETURN @s

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [RDF.SemWeb].[fnHash2Base64]
(
	@hash char(20)
)
RETURNS nchar(28)
WITH SCHEMABINDING
AS
BEGIN

	declare @SemWebHash as nchar(28)

	-- base64 encode hashed string
	declare @alphabet64 varchar(100)
	declare @s64 varchar(1000)
	declare @pad1 bit
	declare @pad2 bit
	declare @pos int
	declare @d3 int
	declare @b1 int
	declare @b2 int
	declare @b3 int
	declare @b4 int
	set @alphabet64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='
	set @s64 = ''
	set @pad1 = 0
	set @pad2 = 0
	set @pos = 1
	while @pos <= 20 --len(@hash)
	begin
		set @d3 = ascii(substring(@hash,@pos,1))*256*256
		if @pos+1 <= 20 --len(@hash)
		  set @d3 = @d3 + ascii(substring(@hash,@pos+1,1))*256
		else
		  set @pad1 = 1
		if @pos+2 <= 20 --len(@hash)
		  set @d3 = @d3 + ascii(substring(@hash,@pos+2,1))
		else
		  set @pad2 = 1
		set @b1 = floor(@d3/(64*64*64))
		set @b2 = floor(@d3/(64*64)) - @b1*64
		set @b3 = floor(@d3/64) - @b1*64*64 - @b2*64
		set @b4 = @d3 - @b1*64*64*64 - @b2*64*64 - @b3*64
		set @s64 = @s64 + substring(@alphabet64,@b1+1,1)
		set @s64 = @s64 + substring(@alphabet64,@b2+1,1)
		if @pad1=1
		  set @s64 = @s64 + '='
		else
		  set @s64 = @s64 + substring(@alphabet64,@b3+1,1)
		if @pad2=1
		  set @s64 = @s64 + '='
		else
		  set @s64 = @s64 + substring(@alphabet64,@b4+1,1)
		set @pos = @pos + 3
	end

	select @SemWebHash = cast(@s64 as nchar(28))

	-- return result
	RETURN @SemWebHash

	-- select [RDF.SemWeb].[fnHash2Base64] ( [RDF.].[fnValueHash](null,null,'Griffin') )

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION  [Utility.NLP].[fnPorterCVCpattern]
	(
		@Word nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN

--local variables
    DECLARE @Ret nvarchar(4000), @i int

--checking each character to see if it is a consonent or a vowel. also inputs the information in const_vowel
SELECT @i = 1, @Ret = N''
WHILE @i <= LEN(@Word)
    BEGIN
	IF CHARINDEX(SUBSTRING(@Word,@i,1), N'aeiou') > 0
	    BEGIN
		SELECT @Ret = @Ret + N'v'
	    END
	-- if y is not the first character, only then check the previous character
	ELSE IF SUBSTRING(@Word,@i,1) = N'y' AND @i > 1
	    BEGIN
            	--check to see if previous character is a consonent
		IF CHARINDEX(SUBSTRING(@Word,@i-1,1), N'aeiou') = 0
		     SELECT @Ret = @Ret + N'v'
		ELSE
		     SELECT @Ret = @Ret + N'c'
	    END
        Else
	    BEGIN
	     SELECT @Ret = @Ret + N'c'
	    END
	SELECT @i = @i + 1
    END
    RETURN @Ret
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [Profile.Data].[fnPublication.Pubmed.GetPubDate]
(
	@MedlineDate varchar(255),
	@JournalYear varchar(50),
	@JournalMonth varchar(50),	
	@JournalDay varchar(50),	
	@ArticleYear varchar(10),
	@ArticleMonth varchar(10),	
	@ArticleDay varchar(10)
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PubDate datetime


	declare @MedlineMonth varchar(10)
	declare @MedlineYear varchar(10)

	set @MedlineYear = left(@MedlineDate,4)

	set @JournalMonth = (select case left(@JournalMonth,3)
								when 'Jan' then '1'
								when 'Feb' then '2'
								when 'Mar' then '3'
								when 'Apr' then '4'
								when 'May' then '5'
								when 'Jun' then '6'
								when 'Jul' then '7'
								when 'Aug' then '8'
								when 'Sep' then '9'
								when 'Oct' then '10'
								when 'Nov' then '11'
								when 'Dec' then '12'
								when 'Win' then '1'
								when 'Spr' then '4'
								when 'Sum' then '7'
								when 'Fal' then '10'
								when '1' then '1'
								when '2' then '2'
								when '3' then '3'
								when '4' then '4'
								when '5' then '5'
								when '6' then '6'
								when '7' then '7'
								when '8' then '8'
								when '9' then '9'
								when '01' then '1'
								when '02' then '2'
								when '03' then '3'
								when '04' then '4'
								when '05' then '5'
								when '06' then '6'
								when '07' then '7'
								when '08' then '8'
								when '09' then '9'
								when '10' then '10'
								when '11' then '11'
								when '12' then '12'
								else null end)
	set @MedlineMonth = (select case substring(replace(@MedlineDate,' ',''),5,3)
								when 'Jan' then '1'
								when 'Feb' then '2'
								when 'Mar' then '3'
								when 'Apr' then '4'
								when 'May' then '5'
								when 'Jun' then '6'
								when 'Jul' then '7'
								when 'Aug' then '8'
								when 'Sep' then '9'
								when 'Oct' then '10'
								when 'Nov' then '11'
								when 'Dec' then '12'
								when 'Win' then '1'
								when 'Spr' then '4'
								when 'Sum' then '7'
								when 'Fal' then '10'
								else null end)
	set @ArticleMonth = (select case @ArticleMonth
								when 'Jan' then '1'
								when 'Feb' then '2'
								when 'Mar' then '3'
								when 'Apr' then '4'
								when 'May' then '5'
								when 'Jun' then '6'
								when 'Jul' then '7'
								when 'Aug' then '8'
								when 'Sep' then '9'
								when 'Oct' then '10'
								when 'Nov' then '11'
								when 'Dec' then '12'
								when 'Win' then '1'
								when 'Spr' then '4'
								when 'Sum' then '7'
								when 'Fal' then '10'
								when '1' then '1'
								when '2' then '2'
								when '3' then '3'
								when '4' then '4'
								when '5' then '5'
								when '6' then '6'
								when '7' then '7'
								when '8' then '8'
								when '9' then '9'
								when '01' then '1'
								when '02' then '2'
								when '03' then '3'
								when '04' then '4'
								when '05' then '5'
								when '06' then '6'
								when '07' then '7'
								when '08' then '8'
								when '09' then '9'
								when '10' then '10'
								when '11' then '11'
								when '12' then '12'
								else null end)
	declare @jd datetime
	declare @ad datetime


	set @jd = (select case when @JournalYear is not null and (@MedlineYear is null or @JournalMonth is not null) then
							cast(coalesce(@JournalMonth,'1') + '/' + coalesce(@JournalDay,'1') + '/' + @JournalYear as datetime)
						when @MedlineYear is not null then
							cast(coalesce(@MedlineMonth,'1') + '/1/' + @MedlineYear as datetime)
						else
							null
						end)

	set @ad = (select case when @ArticleYear is not null then
							cast(coalesce(@ArticleMonth,'1') + '/' + coalesce(@ArticleDay,'1') + '/' + @ArticleYear as datetime)
						else
							null
						end)

	declare @jdx int
	declare @adx int

	set @jdx = (select case when @jd is null then 0
							when @JournalDay is not null then 3
							when @JournalMonth is not null then 2
							else 1
							end)
	set @adx = (select case when @ad is null then 0
							when @ArticleDay is not null then 3
							when @ArticleMonth is not null then 2
							else 1
							end)

	set @PubDate = (select case when @jdx + @adx = 0 then cast('1/1/1900' as datetime)
								when @jdx > @adx then @jd
								when @adx > @jdx then @ad
								when @ad < @jd then @ad
								else @jd
								end)

	-- Return the result of the function
	RETURN @PubDate

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [Profile.Cache].[fnPublication.Pubmed.General2Reference]	(
	@pmid int,
	@ArticleDay varchar(10),
	@ArticleMonth varchar(10),
	@ArticleYear varchar(10),
	@ArticleTitle varchar(4000),
	@Authors varchar(4000),
	@AuthorListCompleteYN varchar(1),
	@Issue varchar(255),
	@JournalDay varchar(50),
	@JournalMonth varchar(50),
	@JournalYear varchar(50),
	@MedlineDate varchar(255),
	@MedlinePgn varchar(255),
	@MedlineTA varchar(1000),
	@Volume varchar(255),
	@encode_html bit=0
)

RETURNS NVARCHAR(MAX) 
AS 
BEGIN

	DECLARE @Reference NVARCHAR(MAX)

	SET @Reference = (case when right(@Authors,5) = 'et al' then @Authors+'. '
								when @AuthorListCompleteYN = 'N' then @Authors+', et al. '
								when @Authors <> '' then @Authors+'. '
								else '' end)
					+ CASE WHEN @encode_html=1 THEN '<a href="'+'http'+'://www.ncbi.nlm.nih.gov/pubmed/'+cast(@pmid as varchar(50))+'" target="_blank">'+coalesce(@ArticleTitle,'')+'</a>' + ' '
								 ELSE coalesce(@ArticleTitle,'') + ' '
						END
					+ coalesce(@MedlineTA,'') + '. '
					+ (case when @JournalYear is not null then rtrim(@JournalYear + ' ' + coalesce(@JournalMonth,'') + ' ' + coalesce(@JournalDay,''))
							when @MedlineDate is not null then @MedlineDate
							when @ArticleYear is not null then rtrim(@ArticleYear + ' ' + coalesce(@ArticleMonth,'') + ' ' + coalesce(@ArticleDay,''))
						else '' end)
					+ (case when coalesce(@JournalYear,@MedlineDate,@ArticleYear) is not null
								and (coalesce(@Volume,'')+coalesce(@Issue,'')+coalesce(@MedlinePgn,'') <> '')
							then '; ' else '' end)
					+ coalesce(@Volume,'')
					+ (case when coalesce(@Issue,'') <> '' then '('+@Issue+')' else '' end)
					+ (case when (coalesce(@MedlinePgn,'') <> '') and (coalesce(@Volume,'')+coalesce(@Issue,'') <> '') then ':' else '' end)
					+ coalesce(@MedlinePgn,'')
					+ '.'

	RETURN @Reference

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [Utility.Application].[fnExecDynamicXQuery] (
	@XML xml, -- XML value
	@Method varchar(10), -- Method to be executed. Must be one of: query, value, exist, nodes.
	@XQuery varchar(max), -- XQuery string to be executed against the XML value.
	@SQLType varchar(128) = NULL -- Used only for the value method.
)
RETURNS XML
begin
	declare	@Stmt nvarchar(max),
			@ParamDefinition nvarchar(max),
			@Output xml
	select @Stmt = 
N'declare @XML xml, @Output xml
set @XML = @XMLValue
set @Output = @XML.' + @Method + '(''' + @XQuery + '''' + CASE @Method WHEN 'value' THEN ', ''' + @SQLType + '''' ELSE '' END + ')',
			@ParamDefinition = N'@XMLValue xml, @Output xml OUTPUT'

	exec @Stmt--sp_executesql @Stmt, @ParamDefinition, @XMLValue = @XML, @Output = @Output

	return @Output
	
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.Application].[fnEncryptRC4]( @strInput VARCHAR(max), @strPassword VARCHAR(100) ) 
RETURNS VARCHAR(MAX)
AS
BEGIN
    --Returns a string encrypted with key k 
    --     ( RC4 encryption )
    --Original code: Eric Hodges http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=29691&lngWId=1
    --Originally translated to TSQL by Joseph Gama
    DECLARE @i int, @j int, @n int, @t int, @s VARCHAR(256), @k VARCHAR(256),
     @tmp1 CHAR(1), @tmp2 CHAR(1), @result VARCHAR(max)
    SET @i=0 SET @s='' SET @k='' SET @result=''
    SET @strPassword = 'PRNS'+@strPassword
    WHILE @i<=255--127--255
    	BEGIN
    	SET @s=@s+CHAR(@i)
    	SET @k=@k+CHAR(ASCII(SUBSTRING(@strPassword, 1+@i % LEN(@strPassword),1)))
    	SET @i=@i+1
    	END
    SET @i=0 SET @j=0
    WHILE @i<=255--127--255
    	BEGIN
    	SET @j=(@j+ ASCII(SUBSTRING(@s,@i+1,1))+ASCII(SUBSTRING(@k,@i+1,1)))% 128--256
    	SET @tmp1=SUBSTRING(@s,@i+1,1)
    	SET @tmp2=SUBSTRING(@s,@j+1,1)
    	SET @s=STUFF(@s,@i+1,1,@tmp2)
    	SET @s=STUFF(@s,@j+1,1,@tmp1)
    	SET @i=@i+1
    	END
    SET @i=0 SET @j=0
    SET @n=1
    WHILE @n<=LEN(@strInput)
    	BEGIN
    	SET @i=(@i+1) % 256--128--256
    	SET @j=(@j+ASCII(SUBSTRING(@s,@i+1,1))) % 256--128--256
    	SET @tmp1=SUBSTRING(@s,@i+1,1)
    	SET @tmp2=SUBSTRING(@s,@j+1,1)
    	SET @s=STUFF(@s,@i+1,1,@tmp2)
    	SET @s=STUFF(@s,@j+1,1,@tmp1)
    	SET @t=((ASCII(SUBSTRING(@s,@i+1,1))+ASCII(SUBSTRING(@s,@j+1,1))) % 256)--128)	--256)
    	IF ASCII(SUBSTRING(@s,@t+1,1))=ASCII(SUBSTRING(@strInput,@n,1))
    		SET @result=@result+SUBSTRING(@strInput,@n,1)
    	ELSE	
    		SET @result=@result+CHAR(ASCII(SUBSTRING(@s,@t+1,1)) ^ ASCII(SUBSTRING(@strInput,@n,1)))
    	SET @n=@n+1
    	END
    RETURN @result
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION  [Utility.NLP].[fnPorterEndsDoubleConsonant]
	(
		@Word nvarchar(4000)
	)
RETURNS bit
AS
BEGIN

--checking whether word ends with a double consonant (e.g. -TT, -SS).

--declaring local variables
DECLARE @holds_ends NVARCHAR(2), @ret bit, @hold_third_last NCHAR(1)

SET @ret = 0
--first check whether the size of the word is >= 2
If Len(@Word) >= 2
    BEGIN
	-- extract 2 characters from right of str
	SELECT @holds_ends = Right(@Word, 2)
	-- checking if both the characters are same and not double vowel
    	IF SUBSTRING(@holds_ends,1,1) = SUBSTRING(@holds_ends,2,1) AND
	   CHARINDEX(@holds_ends, N'aaeeiioouu') = 0
	    BEGIN
            	--if the second last character is y, and there are atleast three letters in str
            	If @holds_ends = N'yy' AND Len(@Word) > 2 
		    BEGIN
			-- extracting the third last character
			SELECT @hold_third_last = LEFT(Right(@Word, 3),1)
                	IF CHARINDEX(@hold_third_last, N'aaeeiioouu') > 0
			    SET @ret = 1
		    END            
            	ELSE
		    SET @ret = 1
	    END            
    END            
            
RETURN @Ret
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.Presentation].[General](
	[PresentationID] [int] NOT NULL,
	[Type] [char](1) NOT NULL,
	[Subject] [nvarchar](400) NULL,
	[Predicate] [nvarchar](400) NULL,
	[Object] [nvarchar](400) NULL,
	[PageColumns] [int] NULL,
	[WindowName] [varchar](max) NULL,
	[PageTitle] [varchar](max) NULL,
	[PageBackLinkName] [varchar](max) NULL,
	[PageBackLinkURL] [varchar](max) NULL,
	[PageSubTitle] [varchar](max) NULL,
	[PageDescription] [varchar](max) NULL,
	[PanelTabType] [varchar](max) NULL,
	[ExpandRDFList] [xml] NULL,
PRIMARY KEY CLUSTERED 
(
	[PresentationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [RDF.].[fnValueHash] (
	@Language	nvarchar(255),
	@DataType	nvarchar(255),
	@Value		nvarchar(max)
) 
RETURNS binary(20)
AS
BEGIN
	DECLARE @result binary(20)
	SELECT @result = CONVERT(binary(20),
						HASHBYTES('sha1',
							CONVERT(nvarchar(4000),
									N'"'+replace(isnull(@Value,N''),N'"',N'\"')+N'"'
									+IsNull(N'@'+replace(@Language,N'@',N''),N'')
									+IsNull(N'^^'+replace(@DataType,N'^',N''),N'')
							)
						)
					)
	RETURN @result
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Concept.Mesh.XML](
	[DescriptorUI] [varchar](10) NOT NULL,
	[MeSH] [xml] NULL,
PRIMARY KEY CLUSTERED 
(
	[DescriptorUI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Word2meshAll](
	[word] [varchar](255) NOT NULL,
	[mesh_header] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[word] ASC,
	[mesh_header] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Word2Mesh3All](
	[word] [varchar](255) NOT NULL,
	[mesh_term] [varchar](255) NOT NULL,
	[mesh_header] [varchar](255) NOT NULL,
	[num_words] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[word] ASC,
	[mesh_term] ASC,
	[mesh_header] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Word2mesh3](
	[word] [varchar](255) NOT NULL,
	[MeshTerm] [varchar](255) NOT NULL,
	[MeshHeader] [varchar](255) NOT NULL,
	[NumWords] [int] NULL,
 CONSTRAINT [PK_cache_word2mesh3] PRIMARY KEY CLUSTERED 
(
	[word] ASC,
	[MeshTerm] ASC,
	[MeshHeader] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Word2mesh2All](
	[word] [varchar](255) NOT NULL,
	[mesh_header] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[word] ASC,
	[mesh_header] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Word2mesh2](
	[word] [varchar](255) NOT NULL,
	[mesh_header] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[word] ASC,
	[mesh_header] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Word2mesh](
	[word] [varchar](255) NOT NULL,
	[MeshHeader] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_cache_word2mesh] PRIMARY KEY CLUSTERED 
(
	[word] ASC,
	[MeshHeader] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [User.Session].[Bot](
	[UserAgent] [varchar](500) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserAgent] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[Beta.Narrative](
	[PersonID] [int] NOT NULL,
	[NarrativeMain] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Journal](
	[MeshHeader] [nvarchar](255) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[Journal] [varchar](1000) NULL,
	[JournalTitle] [varchar](1000) NULL,
	[Weight] [float] NULL,
	[NumJournals] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MeshHeader] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Concept.Mesh.TreeTop](
	[TreeNumber] [varchar](255) NOT NULL,
	[DescriptorName] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[TreeNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Concept.Mesh.Tree](
	[DescriptorUI] [varchar](10) NOT NULL,
	[TreeNumber] [varchar](255) NOT NULL,
 CONSTRAINT [pk_mesh_tree] PRIMARY KEY CLUSTERED 
(
	[DescriptorUI] ASC,
	[TreeNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Tree](
	[MeshCode] [nvarchar](255) NOT NULL,
	[MeshHeader] [nvarchar](255) NULL,
	[NumPublications] [int] NULL,
	[NumFaculty] [int] NULL,
	[Weight] [float] NULL,
	[TotPublications] [int] NULL,
	[TotWeight] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[MeshCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Concept.Mesh.Term](
	[DescriptorUI] [varchar](10) NOT NULL,
	[ConceptUI] [varchar](10) NOT NULL,
	[TermUI] [varchar](10) NOT NULL,
	[TermName] [varchar](255) NOT NULL,
	[DescriptorName] [varchar](255) NULL,
	[PreferredConceptYN] [varchar](1) NULL,
	[RelationName] [varchar](3) NULL,
	[ConceptName] [varchar](255) NULL,
	[ConceptPreferredTermYN] [varchar](1) NULL,
	[IsPermutedTermYN] [varchar](1) NULL,
	[LexicalTag] [varchar](3) NULL,
 CONSTRAINT [pk_mesh_terms] PRIMARY KEY CLUSTERED 
(
	[DescriptorUI] ASC,
	[ConceptUI] ASC,
	[TermUI] ASC,
	[TermName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.SimilarConcept](
	[MeshHeader] [nvarchar](255) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[SimilarConcept] [nvarchar](255) NULL,
	[Weight] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[MeshHeader] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Concept.Mesh.SemanticType](
	[DescriptorUI] [varchar](10) NOT NULL,
	[SemanticTypeUI] [varchar](10) NOT NULL,
	[SemanticTypeName] [varchar](50) NULL,
 CONSTRAINT [pk_mesh_semantic_types] PRIMARY KEY CLUSTERED 
(
	[DescriptorUI] ASC,
	[SemanticTypeUI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Concept.Mesh.SemanticGroupType](
	[SemanticGroupUI] [varchar](10) NOT NULL,
	[SemanticGroupName] [varchar](50) NULL,
	[SemanticTypeUI] [varchar](10) NOT NULL,
	[SemanticTypeName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[SemanticTypeUI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Concept.Mesh.SemanticGroup](
	[DescriptorUI] [varchar](10) NOT NULL,
	[SemanticGroupUI] [varchar](10) NOT NULL,
	[SemanticGroupName] [varchar](50) NULL,
 CONSTRAINT [pk_mesh_semantic_groups] PRIMARY KEY CLUSTERED 
(
	[DescriptorUI] ASC,
	[SemanticGroupUI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Concept.Mesh.Qualifier](
	[DescriptorUI] [varchar](10) NOT NULL,
	[QualifierUI] [varchar](10) NOT NULL,
	[DescriptorName] [varchar](255) NULL,
	[QualifierName] [varchar](255) NULL,
	[Abbreviation] [varchar](2) NULL,
 CONSTRAINT [pk_mesh_qualifiers] PRIMARY KEY CLUSTERED 
(
	[DescriptorUI] ASC,
	[QualifierUI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.PersonPublication](
	[PersonID] [int] NOT NULL,
	[MeshHeader] [nvarchar](255) NOT NULL,
	[PMID] [int] NOT NULL,
	[NumPubsAll] [int] NOT NULL,
	[NumPubsThis] [int] NULL,
	[TopicWeight] [decimal](7, 5) NULL,
	[AuthorWeight] [decimal](7, 5) NULL,
	[YearWeight] [decimal](7, 5) NULL,
	[UniquenessWeight] [float] NULL,
	[MeshWeight] [float] NULL,
	[AuthorPosition] [char](1) NULL,
	[PubYear] [int] NULL,
	[NumPeopleAll] [int] NULL,
	[PubDate] [datetime] NULL,
 CONSTRAINT [PK_cache_pub_mesh] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[MeshHeader] ASC,
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_pmid] ON [Profile.Cache].[Concept.Mesh.PersonPublication] 
(
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_ump] ON [Profile.Cache].[Concept.Mesh.PersonPublication] 
(
	[PersonID] ASC,
	[MeshHeader] ASC,
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Person](
	[PersonID] [int] NOT NULL,
	[MeshHeader] [nvarchar](255) NOT NULL,
	[NumPubsAll] [int] NULL,
	[NumPubsThis] [int] NULL,
	[Weight] [float] NULL,
	[FirstPublicationYear] [float] NULL,
	[LastPublicationYear] [float] NULL,
	[MaxAuthorWeight] [float] NULL,
	[WeightCategory] [tinyint] NULL,
	[FirstPubDate] [datetime] NULL,
	[LastPubDate] [datetime] NULL,
 CONSTRAINT [PK__UserMesh__5A846E65] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[MeshHeader] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.].[ClassTreeDepth](
	[Class] [varchar](400) NOT NULL,
	[_TreeDepth] [int] NULL,
	[_ClassNode] [bigint] NULL,
	[_ClassName] [varchar](400) NULL,
PRIMARY KEY CLUSTERED 
(
	[Class] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_n] ON [Ontology.].[ClassTreeDepth] 
(
	[_ClassNode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.].[ClassProperty](
	[ClassPropertyID] [int] NOT NULL,
	[Class] [varchar](400) NOT NULL,
	[NetworkProperty] [varchar](400) NULL,
	[Property] [varchar](400) NOT NULL,
	[IsDetail] [bit] NULL,
	[Limit] [int] NULL,
	[IncludeDescription] [bit] NULL,
	[IncludeNetwork] [bit] NULL,
	[SearchWeight] [float] NULL,
	[CustomDisplay] [bit] NULL,
	[CustomEdit] [bit] NULL,
	[ViewSecurityGroup] [bigint] NULL,
	[EditSecurityGroup] [bigint] NULL,
	[EditPermissionsSecurityGroup] [bigint] NULL,
	[EditExistingSecurityGroup] [bigint] NULL,
	[EditAddNewSecurityGroup] [bigint] NULL,
	[EditAddExistingSecurityGroup] [bigint] NULL,
	[EditDeleteSecurityGroup] [bigint] NULL,
	[MinCardinality] [int] NULL,
	[MaxCardinality] [int] NULL,
	[CustomDisplayModule] [xml] NULL,
	[CustomEditModule] [xml] NULL,
	[_ClassNode] [bigint] NULL,
	[_NetworkPropertyNode] [bigint] NULL,
	[_PropertyNode] [bigint] NULL,
	[_TagName] [nvarchar](1000) NULL,
	[_PropertyLabel] [nvarchar](400) NULL,
	[_ObjectType] [bit] NULL,
	[_NumberOfNodes] [bigint] NULL,
	[_NumberOfTriples] [bigint] NULL,
 CONSTRAINT [PK__ClassPro__D65A4C562D3171E7] PRIMARY KEY CLUSTERED 
(
	[ClassPropertyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx__cndp] ON [Ontology.].[ClassProperty] 
(
	[_ClassNode] ASC,
	[_NetworkPropertyNode] ASC,
	[IsDetail] ASC,
	[_PropertyNode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx__cnp] ON [Ontology.].[ClassProperty] 
(
	[_ClassNode] ASC,
	[_NetworkPropertyNode] ASC,
	[_PropertyNode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_cndp] ON [Ontology.].[ClassProperty] 
(
	[Class] ASC,
	[NetworkProperty] ASC,
	[IsDetail] ASC,
	[Property] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.].[ClassGroupClass](
	[ClassGroupURI] [varchar](400) NOT NULL,
	[ClassURI] [varchar](400) NOT NULL,
	[SortOrder] [int] NULL,
	[_ClassLabel] [nvarchar](400) NULL,
	[_ClassGroupNode] [bigint] NULL,
	[_ClassNode] [bigint] NULL,
	[_NumberOfNodes] [bigint] NULL,
 CONSTRAINT [PK__ClassGroupClass__31B75ECD] PRIMARY KEY CLUSTERED 
(
	[ClassGroupURI] ASC,
	[ClassURI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ClassNode] ON [Ontology.].[ClassGroupClass] 
(
	[_ClassNode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.].[ClassGroup](
	[ClassGroupURI] [varchar](400) NOT NULL,
	[SortOrder] [int] NULL,
	[_ClassGroupLabel] [nvarchar](400) NULL,
	[_ClassGroupNode] [bigint] NULL,
	[_NumberOfNodes] [bigint] NULL,
 CONSTRAINT [PK__ClassGroup__2DE6CDE9] PRIMARY KEY CLUSTERED 
(
	[ClassGroupURI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Concept.Mesh.File](
	[Name] [varchar](100) NOT NULL,
	[Data] [xml] NULL,
 CONSTRAINT [PK__Concept.Mesh.Fil__047AA831] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Concept.Mesh.Descriptor](
	[DescriptorUI] [varchar](10) NOT NULL,
	[DescriptorName] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[DescriptorUI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Count](
	[MeshHeader] [nvarchar](255) NOT NULL,
	[NumPublications] [int] NULL,
	[NumFaculty] [int] NULL,
	[Weight] [float] NULL,
	[RawWeight] [float] NULL,
 CONSTRAINT [PK__MeshCount__2B3F6F97] PRIMARY KEY CLUSTERED 
(
	[MeshHeader] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.].[Alias](
	[AliasType] [varchar](100) NOT NULL,
	[AliasID] [varchar](100) NOT NULL,
	[NodeID] [bigint] NOT NULL,
	[Preferred] [bit] NULL,
 CONSTRAINT [PK__Alias__456951BF] PRIMARY KEY CLUSTERED 
(
	[AliasType] ASC,
	[AliasID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_na] ON [RDF.].[Alias] 
(
	[NodeID] ASC,
	[Preferred] ASC,
	[AliasType] ASC,
	[AliasID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[Beta.DisplayPreference](
	[PersonID] [int] NOT NULL,
	[ShowPhoto] [char](1) NULL,
	[ShowPublications] [char](1) NULL,
	[ShowAwards] [char](1) NULL,
	[ShowNarrative] [char](1) NULL,
	[ShowAddress] [char](1) NULL,
	[ShowEmail] [char](1) NULL,
	[ShowPhone] [char](1) NULL,
	[ShowFax] [char](1) NULL,
	[PhotoPreference] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[Beta.Award](
	[AwardID] [int] NOT NULL,
	[PersonID] [int] NULL,
	[Yr] [int] NULL,
	[Yr2] [int] NULL,
	[AwardNM] [varchar](100) NULL,
	[AwardingInst] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[AwardID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [User.Account].[Relationship](
	[RelationshipID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[RelationshipType] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RelationshipID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.Type](
	[pubidtype_id] [varchar](20) NOT NULL,
	[name] [varchar](100) NULL,
	[sort_order] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Framework].[ResolveURL]
	@ApplicationName varchar(1000) = '',
	@param1 varchar(1000) = '',
	@param2 varchar(1000) = '',
	@param3 varchar(1000) = '',
	@param4 varchar(1000) = '',
	@param5 varchar(1000) = '',
	@param6 varchar(1000) = '',
	@param7 varchar(1000) = '',
	@param8 varchar(1000) = '',
	@param9 varchar(1000) = '',
	@SessionID uniqueidentifier = null,
	@ContentType varchar(255) = null,
	@Resolved bit OUTPUT,
	@ErrorDescription varchar(max) OUTPUT,
	@ResponseURL varchar(1000) OUTPUT,
	@ResponseContentType varchar(255) OUTPUT,
	@ResponseStatusCode int OUTPUT,
	@ResponseRedirect bit OUTPUT,
	@ResponseIncludePostData bit OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	-- By default we were not able to resolve the URL
	SELECT @Resolved = 0

	-- Load param values into a table
	DECLARE @params TABLE (id int, val varchar(1000))
	INSERT INTO @params (id, val) VALUES (1, @param1)
	INSERT INTO @params (id, val) VALUES (2, @param2)
	INSERT INTO @params (id, val) VALUES (3, @param3)
	INSERT INTO @params (id, val) VALUES (4, @param4)
	INSERT INTO @params (id, val) VALUES (5, @param5)
	INSERT INTO @params (id, val) VALUES (6, @param6)
	INSERT INTO @params (id, val) VALUES (7, @param7)
	INSERT INTO @params (id, val) VALUES (8, @param8)
	INSERT INTO @params (id, val) VALUES (9, @param9)

	DECLARE @MaxParam int
	SELECT @MaxParam = 0
	SELECT @MaxParam = MAX(id) FROM @params WHERE val > ''

	DECLARE @TabParam int
	SELECT @TabParam = 3

	DECLARE @REDIRECTPAGE VARCHAR(255)
	
	SELECT @REDIRECTPAGE = '~/edit/default.aspx'


--this is for the display of the people search results if a queryID exists.
		if(@Param1	<>	'' and IsNumeric(@Param1)=1)
		BEGIN

			SELECT @Resolved = 1,
				@ErrorDescription = '',
				@ResponseURL = @REDIRECTPAGE  + '?subject=' + @Param1							
				
					
		END		


set	@ResponseContentType =''
set	@ResponseStatusCode  =''
set	@ResponseRedirect =0
set	@ResponseIncludePostData =0








END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
declare @resolved bit
declare @t uniqueidentifier
set @t = '719491AF-F4B2-48C0-B264-465D46730AB1';
	declare @ErrorDescription varchar(max) 
	declare @ResponseURL varchar(1000) 
	declare @ResponseContentType varchar(255) 
	declare @ResponseStatusCode int 
	declare @ResponseRedirect bit 
	declare @ResponseIncludePostData bit 



exec [Direct.Framework].[ResolveDirectURL] 'direct','directservice.aspx', 'asdf','','','','','','','',@t,'', @resolved output, 
	 @ErrorDescription output,
	 @ResponseURL output,
	 @ResponseContentType output,
	 @ResponseStatusCode output,
	 @ResponseRedirect output,
	 @ResponseIncludePostData output



select @ResponseURL

*/
CREATE PROCEDURE [Direct.Framework].[ResolveURL]
	@ApplicationName varchar(1000) = '',
	@param1 varchar(1000) = '',
	@param2 varchar(1000) = '',
	@param3 varchar(1000) = '',
	@param4 varchar(1000) = '',
	@param5 varchar(1000) = '',
	@param6 varchar(1000) = '',
	@param7 varchar(1000) = '',
	@param8 varchar(1000) = '',
	@param9 varchar(1000) = '',
	@SessionID uniqueidentifier = null,
	@ContentType varchar(255) = null,
	@Resolved bit OUTPUT,
	@ErrorDescription varchar(max) OUTPUT,
	@ResponseURL varchar(1000) OUTPUT,
	@ResponseContentType varchar(255) OUTPUT,
	@ResponseStatusCode int OUTPUT,
	@ResponseRedirect bit OUTPUT,
	@ResponseIncludePostData bit OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	-- By default we were not able to resolve the URL
	SELECT @Resolved = 0

	-- Load param values into a table
	DECLARE @params TABLE (id int, val varchar(1000))
	INSERT INTO @params (id, val) VALUES (1, @param1)
	INSERT INTO @params (id, val) VALUES (2, @param2)
	INSERT INTO @params (id, val) VALUES (3, @param3)
	INSERT INTO @params (id, val) VALUES (4, @param4)
	INSERT INTO @params (id, val) VALUES (5, @param5)
	INSERT INTO @params (id, val) VALUES (6, @param6)
	INSERT INTO @params (id, val) VALUES (7, @param7)
	INSERT INTO @params (id, val) VALUES (8, @param8)
	INSERT INTO @params (id, val) VALUES (9, @param9)

	DECLARE @MaxParam int
	SELECT @MaxParam = 0
	SELECT @MaxParam = MAX(id) FROM @params WHERE val > ''

	DECLARE @TabParam int
	SELECT @TabParam = 3

	DECLARE @REDIRECTPAGE VARCHAR(255)
	
	SELECT @REDIRECTPAGE = '~/direct/default.aspx'

	-- Return results
	IF (@ErrorDescription IS NULL)
	BEGIN

		if(@ApplicationName = 'direct' and @param1 <> '' and @param2 = '')
		BEGIN
			SELECT @Resolved = 1,
				@ErrorDescription = '',
				@ResponseURL = @REDIRECTPAGE + '?queryid=' + @param1
					
		END


		if(@ApplicationName = 'direct' and @param1 <> '' and @param2 <> '')
		BEGIN
			SELECT @Resolved = 1,
				@ErrorDescription = '',
				@ResponseURL = @REDIRECTPAGE + '?queryid=' + @param1 + '&stop=true'
					
		END
	
		set	@ResponseContentType =''
		set	@ResponseStatusCode  =''
		set	@ResponseRedirect =0
		set	@ResponseIncludePostData =0
				
	END

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Framework.].[RestPath](
	[ApplicationName] [varchar](255) NOT NULL,
	[Resolver] [varchar](255) NULL,
 CONSTRAINT [PK__RestPath__239E4DCF] PRIMARY KEY CLUSTERED 
(
	[ApplicationName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.Framework].[ResolveURL]
@ApplicationName VARCHAR (1000)='', @param1 VARCHAR (1000)='', @param2 VARCHAR (1000)='', @param3 VARCHAR (1000)='', @param4 VARCHAR (1000)='', @param5 VARCHAR (1000)='', @param6 VARCHAR (1000)='', @param7 VARCHAR (1000)='', @param8 VARCHAR (1000)='', @param9 VARCHAR (1000)='', @SessionID UNIQUEIDENTIFIER=null, @ContentType VARCHAR (255)=null, @Resolved BIT OUTPUT, @ErrorDescription VARCHAR (MAX) OUTPUT, @ResponseURL VARCHAR (1000) OUTPUT, @ResponseContentType VARCHAR (255) OUTPUT, @ResponseStatusCode INT OUTPUT, @ResponseRedirect BIT OUTPUT, @ResponseIncludePostData BIT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	-- By default we were not able to resolve the URL
	SELECT @Resolved = 0

	-- Load param values into a table
	DECLARE @params TABLE (id int, val varchar(1000))
	INSERT INTO @params (id, val) VALUES (1, @param1)
	INSERT INTO @params (id, val) VALUES (2, @param2)
	INSERT INTO @params (id, val) VALUES (3, @param3)
	INSERT INTO @params (id, val) VALUES (4, @param4)
	INSERT INTO @params (id, val) VALUES (5, @param5)
	INSERT INTO @params (id, val) VALUES (6, @param6)
	INSERT INTO @params (id, val) VALUES (7, @param7)
	INSERT INTO @params (id, val) VALUES (8, @param8)
	INSERT INTO @params (id, val) VALUES (9, @param9)

	DECLARE @MaxParam int
	SELECT @MaxParam = 0
	SELECT @MaxParam = MAX(id) FROM @params WHERE val > ''

	DECLARE @TabParam int
	SELECT @TabParam = 3

	DECLARE @REDIRECTPAGE VARCHAR(255)
	
	SELECT @REDIRECTPAGE = '~/search/default.aspx'

	-- Return results
	IF (@ErrorDescription IS NULL)
	BEGIN


		if(@Param1='all' and @Param2='')
		BEGIN
			SELECT @Resolved = 1,
				@ErrorDescription = '',
				@ResponseURL = @REDIRECTPAGE + '?tab=all'
		END		


		if(@Param1='all' and @Param2='results')
		BEGIN          
		
			SELECT @Resolved = 1,
				@ErrorDescription = '',
				@ResponseURL = @REDIRECTPAGE + '?tab=all&action=results'
							
		END


		if(@Param1='people' and @Param2='')
		BEGIN
			SELECT @Resolved = 1,
				@ErrorDescription = '',
				@ResponseURL = @REDIRECTPAGE  + '?tab=people'				
					
		END		
		if(@Param1='people' and @Param2='results')
		BEGIN
			SELECT @Resolved = 1,
				@ErrorDescription = '',
				@ResponseURL = @REDIRECTPAGE  + '?tab=people&action=results'				
					
		END		


set	@ResponseContentType =''
set	@ResponseStatusCode  =''
set	@ResponseRedirect =0
set	@ResponseIncludePostData =0



				
	END





END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.AllXML](
	[PMID] [int] NOT NULL,
	[X] [xml] NULL,
	[ParseDT] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.MyPub.Category](
	[HmsPubCategory] [varchar](50) NOT NULL,
	[CategoryName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[HmsPubCategory] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Publication.PubMed.AuthorPosition](
	[PersonID] [int] NOT NULL,
	[PMID] [int] NOT NULL,
	[AuthorPosition] [char](1) NULL,
	[AuthorWeight] [float] NULL,
	[PubDate] [datetime] NULL,
	[PubYear] [int] NULL,
	[YearWeight] [float] NULL,
	[authorRank] [int] NULL,
	[numberOfAuthors] [int] NULL,
	[authorNameAsListed] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.Pubmed.Journal](
	[JournalID] [int] IDENTITY(1,1) NOT NULL,
	[MedlineTA] [varchar](1000) NULL,
	[JournalTitlesXML] [xml] NULL,
 CONSTRAINT [PK__Publication.Jour__7BFA6C9A] PRIMARY KEY CLUSTERED 
(
	[JournalID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.General](
	[PMID] [int] NOT NULL,
	[Owner] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[PubModel] [varchar](50) NULL,
	[Volume] [varchar](255) NULL,
	[Issue] [varchar](255) NULL,
	[MedlineDate] [varchar](255) NULL,
	[JournalYear] [varchar](50) NULL,
	[JournalMonth] [varchar](50) NULL,
	[JournalDay] [varchar](50) NULL,
	[JournalTitle] [varchar](1000) NULL,
	[ISOAbbreviation] [varchar](100) NULL,
	[MedlineTA] [varchar](1000) NULL,
	[ArticleTitle] [varchar](4000) NULL,
	[MedlinePgn] [varchar](255) NULL,
	[AbstractText] [text] NULL,
	[ArticleDateType] [varchar](50) NULL,
	[ArticleYear] [varchar](10) NULL,
	[ArticleMonth] [varchar](10) NULL,
	[ArticleDay] [varchar](10) NULL,
	[Affiliation] [varchar](4000) NULL,
	[AuthorListCompleteYN] [varchar](1) NULL,
	[GrantListCompleteYN] [varchar](1) NULL,
	[PubDate] [datetime] NULL,
	[Authors] [varchar](4000) NULL,
PRIMARY KEY CLUSTERED 
(
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.DisambiguationAudit](
	[BatchID] [uniqueidentifier] NULL,
	[BatchCount] [int] NULL,
	[PersonID] [int] NULL,
	[ServiceCallStart] [datetime] NULL,
	[ServiceCallEnd] [datetime] NULL,
	[ServiceCallPubsFound] [int] NULL,
	[ServiceCallNewPubs] [int] NULL,
	[ServiceCallExistingPubs] [int] NULL,
	[ServiceCallPubsAdded] [int] NULL,
	[ProcessEnd] [datetime] NULL,
	[Success] [bit] NULL,
	[ErrorText] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.DisambiguationAffiliation](
	[affiliation] [varchar](1000) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Disambiguation](
	[PersonID] [int] NOT NULL,
	[PMID] [int] NOT NULL,
	[K] [float] NULL,
	[P] [float] NULL,
 CONSTRAINT [PK_disambiguation_pubmed] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.ISI.PubGeneral](
	[RecID] [int] NOT NULL,
	[InstId] [int] NULL,
	[Hot] [varchar](3) NULL,
	[SortKey] [bigint] NULL,
	[TimesCited] [int] NULL,
	[ItemIssue] [int] NULL,
	[CoverDate] [varchar](10) NULL,
	[RefKey] [int] NULL,
	[DBYear] [int] NULL,
	[Ut] [varchar](20) NULL,
	[ICKey] [varchar](50) NULL,
	[ICID] [varchar](20) NULL,
	[SourceTitle] [varchar](1000) NULL,
	[SourceAbbrev] [varchar](100) NULL,
	[ItemTitle] [varchar](4000) NULL,
	[BibId] [varchar](100) NULL,
	[BibPagesBegin] [varchar](20) NULL,
	[BibPagesEnd] [varchar](20) NULL,
	[BibPagesPages] [int] NULL,
	[BibPages] [varchar](255) NULL,
	[BibIssueYear] [int] NULL,
	[BibIssueVol] [varchar](10) NULL,
	[DocTypeCode] [varchar](3) NULL,
	[DocType] [varchar](100) NULL,
	[EditionsFull] [varchar](50) NULL,
	[LanguagesCount] [int] NULL,
	[AuthorsCount] [int] NULL,
	[EmailsCount] [int] NULL,
	[KeywordsCount] [int] NULL,
	[KeywordsPlusCount] [int] NULL,
	[RPAuthor] [varchar](100) NULL,
	[RPAddress] [varchar](1000) NULL,
	[RPOrganization] [varchar](1000) NULL,
	[RPCity] [varchar](255) NULL,
	[RPState] [varchar](50) NULL,
	[RPCountry] [varchar](50) NULL,
	[RPZipsCount] [int] NULL,
	[ResearchAddrsCount] [int] NULL,
	[AbstractAvail] [varchar](1) NULL,
	[AbstractCount] [int] NULL,
	[Abstract] [varchar](max) NULL,
	[RefsCount] [int] NULL,
	[PubDate] [datetime] NULL,
	[Authors] [varchar](4000) NULL,
	[DOI] [varchar](100) NULL,
 CONSTRAINT [PK__isi_pubs_general__6FF8854A] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.ISI.MPID](
	[MPID] [varchar](50) NOT NULL,
	[PersonID] [int] NULL,
	[RecID] [int] NULL,
 CONSTRAINT [PK__isi2mpid__71E0CDBC] PRIMARY KEY CLUSTERED 
(
	[MPID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[Public.NodeSummary](
	[NodeID] [bigint] NOT NULL,
	[ShortLabel] [varchar](500) NULL,
	[ClassName] [varchar](255) NULL,
	[SortOrder] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[Public.NodeRDF](
	[NodeID] [bigint] NOT NULL,
	[RDF] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[Public.NodePrefix](
	[Prefix] [varchar](800) NOT NULL,
	[NodeID] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Prefix] ASC,
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_NodeID] ON [Search.Cache].[Public.NodePrefix] 
(
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[Public.NodeMap](
	[NodeID] [bigint] NOT NULL,
	[MatchedByNodeID] [bigint] NOT NULL,
	[Distance] [int] NULL,
	[Paths] [int] NULL,
	[Weight] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC,
	[MatchedByNodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_ms] ON [Search.Cache].[Public.NodeMap] 
(
	[MatchedByNodeID] ASC,
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[Public.NodeExpand](
	[NodeID] [bigint] NOT NULL,
	[ExpandNodeID] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC,
	[ExpandNodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[Public.NodeClass](
	[NodeID] [bigint] NOT NULL,
	[Class] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC,
	[Class] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.Entity.InformationResource](
	[EntityID] [int] IDENTITY(1,1) NOT NULL,
	[PMID] [int] NULL,
	[MPID] [nvarchar](50) NULL,
	[EntityName] [varchar](4000) NULL,
	[EntityDate] [datetime] NULL,
	[Reference] [varchar](max) NULL,
	[Source] [varchar](25) NULL,
	[URL] [varchar](1000) NULL,
	[PubYear] [int] NULL,
	[YearWeight] [float] NULL,
	[SummaryXML] [xml] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Publication.Enti__6892926B] PRIMARY KEY CLUSTERED 
(
	[EntityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_mpid] ON [Profile.Data].[Publication.Entity.InformationResource] 
(
	[MPID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_pmid] ON [Profile.Data].[Publication.Entity.InformationResource] 
(
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PublicationEntityInformationResourceIsActive] ON [Profile.Data].[Publication.Entity.InformationResource] 
(
	[IsActive] ASC
)
INCLUDE ( [EntityID],
[PubYear],
[PMID],
[EntityDate],
[Reference]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_73031] ON [Profile.Data].[Publication.Entity.InformationResource] 
(
	[IsActive] ASC
)
INCLUDE ( [EntityID],
[PubYear],
[PMID],
[EntityDate],
[Reference]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.Entity.Authorship](
	[EntityID] [int] IDENTITY(1,1) NOT NULL,
	[EntityName] [varchar](4000) NULL,
	[EntityDate] [datetime] NULL,
	[authorRank] [int] NULL,
	[numberOfAuthors] [int] NULL,
	[authorNameAsListed] [varchar](255) NULL,
	[authorWeight] [float] NULL,
	[authorPosition] [varchar](1) NULL,
	[PubYear] [int] NULL,
	[YearWeight] [float] NULL,
	[PersonID] [int] NULL,
	[InformationResourceID] [int] NULL,
	[SummaryXML] [xml] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Publication.Enti__6B6EFF16] PRIMARY KEY CLUSTERED 
(
	[EntityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PIR] ON [Profile.Data].[Publication.Entity.Authorship] 
(
	[PersonID] ASC,
	[InformationResourceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PublicationEntityAuthorshipIsActive] ON [Profile.Data].[Publication.Entity.Authorship] 
(
	[IsActive] ASC
)
INCLUDE ( [EntityID],
[EntityName],
[EntityDate],
[authorPosition],
[authorRank],
[PersonID],
[numberOfAuthors],
[authorWeight],
[YearWeight],
[InformationResourceID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_73175] ON [Profile.Data].[Publication.Entity.Authorship] 
(
	[IsActive] ASC
)
INCLUDE ( [EntityID],
[EntityName],
[EntityDate],
[authorPosition],
[authorRank],
[PersonID],
[numberOfAuthors],
[authorWeight],
[YearWeight],
[InformationResourceID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.DSpace.PubGeneral](
	[DashId] [int] NOT NULL,
	[Label] [varchar](max) NULL,
	[IssueDate] [smallint] NULL,
	[BibliographicCitation] [varchar](max) NULL,
	[Abstract] [varchar](max) NULL,
 CONSTRAINT [PK_dash_pubs_general] PRIMARY KEY CLUSTERED 
(
	[DashId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.DSpace.MPID](
	[MPID] [varchar](50) NOT NULL,
	[PersonID] [int] NULL,
	[DashID] [int] NULL,
 CONSTRAINT [PK__dash2mpid__6E103CD8] PRIMARY KEY CLUSTERED 
(
	[MPID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[Private.NodeSummary](
	[NodeID] [bigint] NOT NULL,
	[ShortLabel] [varchar](500) NULL,
	[ClassName] [varchar](255) NULL,
	[SortOrder] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[Private.NodeRDF](
	[NodeID] [bigint] NOT NULL,
	[RDF] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[Private.NodePrefix](
	[Prefix] [varchar](800) NOT NULL,
	[NodeID] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Prefix] ASC,
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_NodeID] ON [Search.Cache].[Private.NodePrefix] 
(
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[Private.NodeMap](
	[NodeID] [bigint] NOT NULL,
	[MatchedByNodeID] [bigint] NOT NULL,
	[Distance] [int] NULL,
	[Paths] [int] NULL,
	[Weight] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC,
	[MatchedByNodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_ms] ON [Search.Cache].[Private.NodeMap] 
(
	[MatchedByNodeID] ASC,
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[Private.NodeExpand](
	[NodeID] [bigint] NOT NULL,
	[ExpandNodeID] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC,
	[ExpandNodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.Cache].[Private.NodeClass](
	[NodeID] [bigint] NOT NULL,
	[Class] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC,
	[Class] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Process.Audit](
	[AuditID] [uniqueidentifier] NOT NULL,
	[ProcessName] [varchar](1000) NULL,
	[ProcessStartDate] [datetime] NULL,
	[ProcessEndDate] [datetime] NULL,
	[ProcessedRows] [int] NULL,
	[Error] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Proxy.Search]
	@LastName nvarchar(100) = NULL,
	@FirstName nvarchar(100) = NULL,
	@Institution nvarchar(500) = NULL,
	@Department nvarchar(500) = NULL,
	@Division nvarchar(500) = NULL,
	@offset INT = 0,
	@limit INT = 20
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;

	SELECT @offset = IsNull(@offset,0), @limit = IsNull(@limit,1000)
	SELECT @limit = 1000 WHERE @limit > 1000
	
	SELECT	@LastName = (CASE WHEN @LastName = '' THEN NULL ELSE @LastName END),
			@FirstName = (CASE WHEN @FirstName = '' THEN NULL ELSE @FirstName END),
			@Institution = (CASE WHEN @Institution = '' THEN NULL ELSE @Institution END),
			@Department = (CASE WHEN @Department = '' THEN NULL ELSE @Department END),
			@Division = (CASE WHEN @Division = '' THEN NULL ELSE @Division END)

	DECLARE @sql NVARCHAR(MAX)
	
	SELECT @sql = '
		SELECT UserID, DisplayName, Institution, Department, EmailAddr
			FROM (
				SELECT UserID, DisplayName, Institution, Department, EmailAddr, 
					row_number() over (order by LastName, FirstName, UserID) k
				FROM [User.Account].[User]
				WHERE IsActive = 1
					AND CanBeProxy = 1
					' + IsNull('AND FirstName LIKE '''+replace(@FirstName,'''','''''')+'%''','') + '
					' + IsNull('AND LastName LIKE '''+replace(@LastName,'''','''''')+'%''','') + '
					' + IsNull('AND Institution = '''+replace(@Institution,'''','''''')+'''','') + '
					' + IsNull('AND Department = '''+replace(@Department,'''','''''')+'''','') + '
					' + IsNull('AND Division = '''+replace(@Division,'''','''''')+'''','') + '
			) t
			WHERE (k >= ' + cast(@offset+1 as varchar(50)) + ') AND (k < ' + cast(@offset+@limit+1 as varchar(50)) + ')
			ORDER BY k
		'

	EXEC sp_executesql @sql

END
GO
CREATE ASSEMBLY [PresentationXML]
AUTHORIZATION [dbo]
FROM 0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000800000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000504500004C0103008A167A4E0000000000000000E00002210B010800000600000006000000000000CE250000002000000040000000004000002000000002000004000000000000000400000000000000008000000002000000000000030040850000100000100000000010000010000000000000100000000000000000000000742500005700000000400000B003000000000000000000000000000000000000006000000C000000D42400001C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000080000000000000000000000082000004800000000000000000000002E74657874000000D4050000002000000006000000020000000000000000000000000000200000602E72737263000000B0030000004000000004000000080000000000000000000000000000400000402E72656C6F6300000C0000000060000000020000000C00000000000000000000000000004000004200000000000000000000000000000000B02500000000000048000000020005005020000084040000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000042534A4201000100000000000C00000076322E302E35303732370000000005006C0000005C010000237E0000C80100000402000023537472696E677300000000CC0300000800000023555300D4030000100000002347554944000000E4030000A000000023426C6F620000000000000002000001071400000900000000FA013300160000010000000E000000010000000D0000000B000000010000000100000000000A000100000000000600390027000600560027000600730027000600920027000600AB0027000600C40027000600DF0027000600FA002700060032011301060046012700060072015F012F00860100000600B50195010600D50195010000000001000000000001000100090050000A00110050000A00190050000A00210050000A00290050000A00310050000A00390050000A00410050000A00490050000F00510050000A00590050001400690050001A00710050001F002E000B0023002E00130038002E001B0038002E0023003E002E002B0023002E0033004D002E003B0038002E004B0038002E005B006E002E00630077002E006B0080000480000001000000B9109D53000000000000F301000002000000000000000000000001001E00000000000000003C4D6F64756C653E0050726573656E746174696F6E584D4C2E646C6C006D73636F726C69620053797374656D2E5265666C656374696F6E00417373656D626C795469746C65417474726962757465002E63746F7200417373656D626C794465736372697074696F6E41747472696275746500417373656D626C79436F6E66696775726174696F6E41747472696275746500417373656D626C79436F6D70616E7941747472696275746500417373656D626C7950726F6475637441747472696275746500417373656D626C79436F7079726967687441747472696275746500417373656D626C7954726164656D61726B41747472696275746500417373656D626C7943756C747572654174747269627574650053797374656D2E52756E74696D652E496E7465726F70536572766963657300436F6D56697369626C6541747472696275746500417373656D626C7956657273696F6E4174747269627574650053797374656D2E446961676E6F73746963730044656275676761626C6541747472696275746500446562756767696E674D6F6465730053797374656D2E52756E74696D652E436F6D70696C6572536572766963657300436F6D70696C6174696F6E52656C61786174696F6E734174747269627574650052756E74696D65436F6D7061746962696C6974794174747269627574650050726573656E746174696F6E584D4C00000003200000000000F67D6ED3C2D04E43AD37B1B3C3A4BCBC0008B77A5C561934E089042001010E04200101020520010111310420010108032000011401000F50726573656E746174696F6E584D4C00000501000000000E0100094D6963726F736F667400002001001B436F7079726967687420C2A9204D6963726F736F6674203230313100000801000701000000000801000800000000001E01000100540216577261704E6F6E457863657074696F6E5468726F77730100000000008A167A4E000000000200000082000000F0240000F006000052534453D64790F04C0C6444B189B7D57DE892F102000000433A5C56697375616C2053747564696F20323030385C50726F6A656374735C50726F66696C65732E4F70656E536F757263655C50726F66696C65735C50726573656E746174696F6E584D4C5C6F626A5C44656275675C50726573656E746174696F6E584D4C2E7064620000009C2500000000000000000000BE250000002000000000000000000000000000000000000000000000B02500000000000000000000000000000000000000005F436F72446C6C4D61696E006D73636F7265652E646C6C0000000000FF2500204000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100100000001800008000000000000000000000000000000100010000003000008000000000000000000000000000000100000000004800000058400000580300000000000000000000580334000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE00000100000001009D53B910000001009D53B9103F000000000000000400000002000000000000000000000000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000000B004B8020000010053007400720069006E006700460069006C00650049006E0066006F00000094020000010030003000300030003000340062003000000034000A00010043006F006D00700061006E0079004E0061006D006500000000004D006900630072006F0073006F00660074000000480010000100460069006C0065004400650073006300720069007000740069006F006E0000000000500072006500730065006E0074006100740069006F006E0058004D004C00000040000F000100460069006C006500560065007200730069006F006E000000000031002E0030002E0034003200380031002E00320031003400300035000000000048001400010049006E007400650072006E0061006C004E0061006D0065000000500072006500730065006E0074006100740069006F006E0058004D004C002E0064006C006C0000005C001B0001004C006500670061006C0043006F007000790072006900670068007400000043006F0070007900720069006700680074002000A90020004D006900630072006F0073006F006600740020003200300031003100000000005000140001004F0072006900670069006E0061006C00460069006C0065006E0061006D0065000000500072006500730065006E0074006100740069006F006E0058004D004C002E0064006C006C000000400010000100500072006F0064007500630074004E0061006D00650000000000500072006500730065006E0074006100740069006F006E0058004D004C00000044000F000100500072006F006400750063007400560065007200730069006F006E00000031002E0030002E0034003200380031002E00320031003400300035000000000048000F00010041007300730065006D0062006C0079002000560065007200730069006F006E00000031002E0030002E0034003200380031002E0032003100340030003500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000C000000D03500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
WITH PERMISSION_SET = SAFE
GO
ALTER ASSEMBLY [PresentationXML]
ADD FILE FROM 0x4D6963726F736F667420432F432B2B204D534620372E30300D0A1A445300000000020000010000000F0000004C000000000000000D00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF30E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0BCA3101380000000010000000100000000000000900FFFF0400000003800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FFFFFFFF1A092FF1000000000000000065000000000000001900000000000000100000002C000000000000000C00000003000000060000000900000007000000080000000A0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FFFFFFFF77093101020000000A000088070027C608003F1300000000040000000400000004000000000000000000000000000000190000000000EEC0000000002DBA2EF10000000000000000FEEFFEEF0100000001000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000BCA310138000000001000000010000000000000FFFFFFFF040000000380000000000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FEEFFEEF0100000001000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000004000000000024303030FFFFFFFF1A092FF10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000942E310141117A4E02000000D64790F04C0C6444B189B7D57DE892F1220000002F4C696E6B496E666F002F6E616D6573002F7372632F686561646572626C6F636B000300000006000000010000001A0000000000000011000000060000000A0000000500000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000B000000300000007200000038000000650000000000000019000000000000002C00000000000000FFFFFFFF100000000B0000000900000006000000050000000700000008000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000480000007200000038000000FFFFFFFF00000000190000000000000004000000030000000600000007000000002F7372632F686561646572626C6F636B000300000006000000010000001A0000000000000011000000060000000A0000000500000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000B00000018000000720000003800000065000000000000001900000000000000100000002C00000000000000030000000B000000060000000900000007000000080000000A00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000A000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
AS N'PresentationXML.pdb'
GO
ALTER ASSEMBLY [PresentationXML]
ADD FILE FROM 0xEFBBBF7573696E672053797374656D2E5265666C656374696F6E3B0D0A7573696E672053797374656D2E52756E74696D652E436F6D70696C657253657276696365733B0D0A7573696E672053797374656D2E52756E74696D652E496E7465726F7053657276696365733B0D0A7573696E672053797374656D2E446174612E53716C3B0D0A0D0A2F2F2047656E6572616C20496E666F726D6174696F6E2061626F757420616E20617373656D626C7920697320636F6E74726F6C6C6564207468726F7567682074686520666F6C6C6F77696E670D0A2F2F20736574206F6620617474726962757465732E204368616E6765207468657365206174747269627574652076616C75657320746F206D6F646966792074686520696E666F726D6174696F6E0D0A2F2F206173736F636961746564207769746820616E20617373656D626C792E0D0A5B617373656D626C793A20417373656D626C795469746C65282250726573656E746174696F6E584D4C22295D0D0A5B617373656D626C793A20417373656D626C794465736372697074696F6E282222295D0D0A5B617373656D626C793A20417373656D626C79436F6E66696775726174696F6E282222295D0D0A5B617373656D626C793A20417373656D626C79436F6D70616E7928224D6963726F736F667422295D0D0A5B617373656D626C793A20417373656D626C7950726F64756374282250726573656E746174696F6E584D4C22295D0D0A5B617373656D626C793A20417373656D626C79436F707972696768742822436F7079726967687420C2A9204D6963726F736F6674203230313122295D0D0A5B617373656D626C793A20417373656D626C7954726164656D61726B282222295D0D0A5B617373656D626C793A20417373656D626C7943756C74757265282222295D0D0A0D0A5B617373656D626C793A20436F6D56697369626C652866616C7365295D0D0A0D0A2F2F0D0A2F2F2056657273696F6E20696E666F726D6174696F6E20666F7220616E20617373656D626C7920636F6E7369737473206F662074686520666F6C6C6F77696E6720666F75722076616C7565733A0D0A2F2F0D0A2F2F2020202020204D616A6F722056657273696F6E0D0A2F2F2020202020204D696E6F722056657273696F6E0D0A2F2F2020202020204275696C64204E756D6265720D0A2F2F2020202020205265766973696F6E0D0A2F2F0D0A2F2F20596F752063616E207370656369667920616C6C207468652076616C756573206F7220796F752063616E2064656661756C7420746865205265766973696F6E20616E64204275696C64204E756D626572730D0A2F2F206279207573696E672074686520272A272061732073686F776E2062656C6F773A0D0A5B617373656D626C793A20417373656D626C7956657273696F6E2822312E302E2A22295D0D0A0D0A
AS N'Properties\AssemblyInfo.cs'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[PersonFilterFlag](
	[internalusername] [varchar](50) NULL,
	[personfilter] [varchar](50) NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_2042_2041] ON [Profile.Import].[PersonFilterFlag] 
(
	[personfilter] ASC
)
INCLUDE ( [internalusername]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[PersonAffiliation](
	[internalusername] [nvarchar](1000) NULL,
	[title] [nvarchar](1000) NULL,
	[emailaddr] [nvarchar](1000) NULL,
	[primaryaffiliation] [bit] NULL,
	[affiliationorder] [tinyint] NULL,
	[institutionname] [nvarchar](1000) NULL,
	[institutionabbreviation] [nvarchar](1000) NULL,
	[departmentname] [nvarchar](1000) NULL,
	[departmentvisible] [bit] NULL,
	[divisionname] [nvarchar](1000) NULL,
	[facultyrank] [varchar](1000) NULL,
	[facultyrankorder] [tinyint] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_152] ON [Profile.Import].[PersonAffiliation] 
(
	[facultyrankorder] ASC
)
INCLUDE ( [facultyrank]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_158] ON [Profile.Import].[PersonAffiliation] 
(
	[facultyrankorder] ASC
)
INCLUDE ( [facultyrank]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_1811_1810] ON [Profile.Import].[PersonAffiliation] 
(
	[facultyrankorder] ASC
)
INCLUDE ( [facultyrank]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.].[PropertyGroupProperty](
	[PropertyGroupURI] [varchar](400) NOT NULL,
	[PropertyURI] [nvarchar](400) NOT NULL,
	[SortOrder] [int] NULL,
	[CustomDisplayModule] [xml] NULL,
	[CustomEditModule] [xml] NULL,
	[_PropertyGroupNode] [bigint] NULL,
	[_PropertyNode] [bigint] NULL,
	[_TagName] [nvarchar](1000) NULL,
	[_PropertyLabel] [nvarchar](400) NULL,
	[_NumberOfNodes] [bigint] NULL,
 CONSTRAINT [PK__Property__1F57AE744D6D97C5] PRIMARY KEY CLUSTERED 
(
	[PropertyURI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.].[PropertyGroup](
	[PropertyGroupURI] [varchar](400) NOT NULL,
	[SortOrder] [int] NULL,
	[_PropertyGroupLabel] [nvarchar](400) NULL,
	[_PropertyGroupNode] [bigint] NULL,
	[_NumberOfNodes] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[PropertyGroupURI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[SNA.Coauthor.Reach](
	[PersonID] [int] NOT NULL,
	[Distance] [tinyint] NOT NULL,
	[NumPeople] [smallint] NULL,
 CONSTRAINT [PK_sna_reach] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[Distance] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[SNA.Coauthor.DistanceLog](
	[x] [varchar](50) NULL,
	[d] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[SNA.Coauthor.Distance](
	[PersonID1] [int] NOT NULL,
	[PersonID2] [int] NOT NULL,
	[Distance] [tinyint] NULL,
	[NumPaths] [smallint] NULL,
 CONSTRAINT [PK__sna_distance__6BDD104C] PRIMARY KEY CLUSTERED 
(
	[PersonID1] ASC,
	[PersonID2] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[SNA.Coauthor.Betweenness](
	[PersonID] [int] NOT NULL,
	[i] [smallint] NULL,
	[b] [float] NULL,
 CONSTRAINT [PK_sna_betweenness] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[SNA.Coauthor](
	[PersonID1] [int] NOT NULL,
	[PersonID2] [int] NOT NULL,
	[i] [smallint] NULL,
	[j] [smallint] NULL,
	[w] [float] NULL,
	[FirstPubDate] [datetime] NULL,
	[LastPubDate] [datetime] NULL,
	[n] [int] NULL,
 CONSTRAINT [PK_sna_coauthors] PRIMARY KEY CLUSTERED 
(
	[PersonID1] ASC,
	[PersonID2] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Direct.].[Sites](
	[SiteID] [int] NOT NULL,
	[BootstrapURL] [varchar](255) NULL,
	[SiteName] [varchar](500) NULL,
	[QueryURL] [varchar](255) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Utility.NLP].[StopWord](
	[word] [varchar](50) NOT NULL,
	[stem] [varchar](50) NULL,
	[scope] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[word] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.Stage].[Triple.Map](
	[StageTripleID] [bigint] NOT NULL,
	[TripleID] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StageTripleID] ASC,
	[TripleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.Stage].[Triple](
	[StageTripleID] [bigint] IDENTITY(0,1) NOT NULL,
	[sCategory] [tinyint] NULL,
	[sURI] [nvarchar](400) NULL,
	[sValueHash] [binary](20) NULL,
	[sNodeType] [nvarchar](400) NULL,
	[sInternalType] [nvarchar](100) NULL,
	[sInternalID] [nvarchar](100) NULL,
	[sTripleID] [bigint] NULL,
	[sStageTripleID] [bigint] NULL,
	[sNodeID] [bigint] NULL,
	[sViewSecurityGroup] [bigint] NULL,
	[sEditSecurityGroup] [bigint] NULL,
	[pCategory] [tinyint] NULL,
	[pProperty] [nvarchar](400) NULL,
	[pValueHash] [binary](20) NULL,
	[pNodeID] [bigint] NULL,
	[pViewSecurityGroup] [bigint] NULL,
	[pEditSecurityGroup] [bigint] NULL,
	[oCategory] [tinyint] NULL,
	[oValue] [nvarchar](max) NULL,
	[oLanguage] [nvarchar](255) NULL,
	[oDataType] [nvarchar](255) NULL,
	[oObjectType] [bit] NULL,
	[oValueHash] [binary](20) NULL,
	[oNodeType] [nvarchar](400) NULL,
	[oInternalType] [nvarchar](100) NULL,
	[oInternalID] [nvarchar](100) NULL,
	[oTripleID] [bigint] NULL,
	[oStageTripleID] [bigint] NULL,
	[oStartTime] [nvarchar](100) NULL,
	[oEndTime] [nvarchar](100) NULL,
	[oTimePrecision] [nvarchar](100) NULL,
	[oNodeID] [bigint] NULL,
	[oViewSecurityGroup] [bigint] NULL,
	[oEditSecurityGroup] [bigint] NULL,
	[TripleHash] [binary](20) NULL,
	[TripleID] [bigint] NULL,
	[tViewSecurityGroup] [bigint] NULL,
	[Weight] [float] NULL,
	[SortOrder] [int] NULL,
	[Reitification] [bigint] NULL,
	[DataMapID] [int] NULL,
	[DataMapLink] [nvarchar](400) NULL,
	[Status] [int] NULL,
	[Graph] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[StageTripleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.].[Triple](
	[TripleID] [bigint] IDENTITY(1,1) NOT NULL,
	[Subject] [bigint] NOT NULL,
	[Predicate] [bigint] NOT NULL,
	[Object] [bigint] NOT NULL,
	[TripleHash] [binary](20) NOT NULL,
	[Weight] [float] NOT NULL,
	[Reitification] [bigint] NULL,
	[ObjectType] [bit] NULL,
	[SortOrder] [int] NULL,
	[ViewSecurityGroup] [bigint] NULL,
	[Graph] [bigint] NULL,
 CONSTRAINT [PK_Triple] PRIMARY KEY NONCLUSTERED 
(
	[TripleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [idx_SPO] ON [RDF.].[Triple] 
(
	[Subject] ASC,
	[Predicate] ASC,
	[Object] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_O] ON [RDF.].[Triple] 
(
	[Object] ASC
)
INCLUDE ( [ViewSecurityGroup],
[Subject],
[Predicate],
[Weight]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_POS] ON [RDF.].[Triple] 
(
	[Predicate] ASC,
	[Object] ASC,
	[Subject] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Reitification] ON [RDF.].[Triple] 
(
	[Reitification] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_triple_nc_predicate] ON [RDF.].[Triple] 
(
	[Predicate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_TripleHash] ON [RDF.].[Triple] 
(
	[TripleHash] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TripleObjectType] ON [RDF.].[Triple] 
(
	[ObjectType] ASC
)
INCLUDE ( [TripleID],
[Subject],
[Predicate],
[Object],
[TripleHash],
[Weight],
[Reitification],
[SortOrder],
[ViewSecurityGroup],
[Graph]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TriplePredicate] ON [RDF.].[Triple] 
(
	[Predicate] ASC
)
INCLUDE ( [TripleID],
[Subject],
[Object],
[TripleHash],
[Weight],
[Reitification],
[ObjectType],
[SortOrder],
[ViewSecurityGroup],
[Graph]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_TriplePredicateReitification] ON [RDF.].[Triple] 
(
	[Predicate] ASC,
	[Reitification] ASC
)
INCLUDE ( [Subject],
[Object]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_73037] ON [RDF.].[Triple] 
(
	[Predicate] ASC,
	[Reitification] ASC
)
INCLUDE ( [Subject],
[Object]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_73079] ON [RDF.].[Triple] 
(
	[Predicate] ASC
)
INCLUDE ( [TripleID],
[Subject],
[Object],
[TripleHash],
[Weight],
[Reitification],
[ObjectType],
[SortOrder],
[ViewSecurityGroup],
[Graph]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_73181] ON [RDF.].[Triple] 
(
	[ObjectType] ASC
)
INCLUDE ( [TripleID],
[Subject],
[Predicate],
[Object],
[TripleHash],
[Weight],
[Reitification],
[SortOrder],
[ViewSecurityGroup],
[Graph]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.Import].[Triple](
	[OntologyTripleID] [int] IDENTITY(1,1) NOT NULL,
	[OWL] [nvarchar](100) NULL,
	[Graph] [bigint] NULL,
	[Subject] [nvarchar](max) NULL,
	[Predicate] [nvarchar](max) NULL,
	[Object] [nvarchar](max) NULL,
	[_SubjectNode] [bigint] NULL,
	[_PredicateNode] [bigint] NULL,
	[_ObjectNode] [bigint] NULL,
	[_TripleID] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[OntologyTripleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Utility.NLP].[Thesaurus.Source](
	[Source] [int] NOT NULL,
	[SourceName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Source] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Utility.NLP].[Thesaurus](
	[Source] [int] NOT NULL,
	[ConceptID] [int] NOT NULL,
	[TermName] [nvarchar](400) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Source] ASC,
	[ConceptID] ASC,
	[TermName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_term] ON [Utility.NLP].[Thesaurus] 
(
	[TermName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Module].[Support.Map](
	[SupportMapID] [int] NOT NULL,
	[SupportID] [int] NULL,
	[Institution] [varchar](255) NULL,
	[Department] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[SupportMapID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Module].[Support.HTML](
	[SupportID] [int] NOT NULL,
	[HTML] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[SupportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [User.Account].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[IsActive] [bit] NULL,
	[CanBeProxy] [bit] NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[DisplayName] [nvarchar](255) NULL,
	[Institution] [nvarchar](500) NULL,
	[Department] [nvarchar](500) NULL,
	[Division] [nvarchar](500) NULL,
	[EmailAddr] [nvarchar](255) NULL,
	[UserName] [nvarchar](50) NULL,
	[Password] [varchar](128) NULL,
	[CreateDate] [datetime] NULL,
	[ApplicationName] [varchar](255) NULL,
	[Comment] [varchar](255) NULL,
	[IsApproved] [bit] NULL,
	[IsOnline] [bit] NULL,
	[InternalUserName] [nvarchar](50) NULL,
	[NodeID] [bigint] NULL,
 CONSTRAINT [PK__user] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[User](
	[internalusername] [nvarchar](1000) NULL,
	[firstname] [nvarchar](1000) NULL,
	[lastname] [nvarchar](1000) NULL,
	[displayname] [nvarchar](1000) NULL,
	[institution] [nvarchar](1000) NULL,
	[department] [nvarchar](1000) NULL,
	[emailaddr] [nvarchar](1000) NULL,
	[canbeproxy] [bit] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Person.DoesPersonExist](	@PersonID INT,@exists BIT OUTPUT)
AS
BEGIN
	SET NOCOUNT ON;

  SELECT @exists=0
  SELECT TOP 1 @exists=0, @exists = CASE WHEN PersonID	  IS NULL THEN 0 ELSE 1 END  
		FROM [Profile.Data].vw_person 
	 WHERE PersonID	  = @PersonID
		 AND IsActive=1
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Framework.].[vwDatabaseObjects] AS
	SELECT o.type, o.type_desc, '['+s.name+'].['+o.name+']' full_name, s.name schema_name, o.name, 
			o.object_id, o.principal_id, o.schema_id, o.parent_object_id, 
			o.create_date, o.modify_date, o.is_ms_shipped, o.is_published, o.is_schema_published
		FROM sys.objects o, sys.schemas s
		WHERE o.schema_id = s.schema_id
	UNION ALL
	SELECT '@', 'SCHEMA', '['+name+']', name, name,
			NULL, principal_id, schema_id, null, 
			null, null, null, null, null
		FROM sys.schemas
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.Presentation].[XML](
	[PresentationID] [int] NOT NULL,
	[Type] [char](1) NOT NULL,
	[Subject] [nvarchar](400) NULL,
	[Predicate] [nvarchar](400) NULL,
	[Object] [nvarchar](400) NULL,
	[PresentationXML] [xml] NULL,
	[_SubjectNode] [bigint] NULL,
	[_PredicateNode] [bigint] NULL,
	[_ObjectNode] [bigint] NULL,
 CONSTRAINT [PK__Presenta__B3613E3C635F3AE9] PRIMARY KEY CLUSTERED 
(
	[PresentationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_spo] ON [Ontology.Presentation].[XML] 
(
	[Type] ASC,
	[Subject] ASC,
	[Predicate] ASC,
	[Object] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.SemWeb].[vwPublic_Entities] AS
	SELECT NodeID id, value
	FROM [RDF.].Node
	WHERE ObjectType = 0 AND ViewSecurityGroup = -1
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [RDF.].[vwTripleValue] as
	select t.TripleID, t.ViewSecurityGroup, t.Subject, t.Predicate, t.Object, t.TripleHash, 
		t.SortOrder, t.Weight, t.Reitification, 
		s.value SubjectValue, p.value PredicateValue, 
		o.value ObjectValue, o.Language, o.DataType, 
		s.ViewSecurityGroup sViewSecurityGroup, p.ViewSecurityGroup pViewSecurityGroup, o.ViewSecurityGroup oViewSecurityGroup
	from [RDF.].Triple t, [RDF.].Node s, [RDF.].Node p, [RDF.].Node o
	where t.subject=s.nodeid and t.predicate=p.nodeid and t.object=o.nodeid
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [Profile.Data].[vwPerson.Affiliation] as
	select PersonAffiliationID,
		a.PersonID,
		a.SortOrder,
		a.IsActive,
		a.IsPrimary,
		a.InstitutionID,
		a.DepartmentID,
		a.DivisionID,
		coalesce(a.Title,'') Title,
		coalesce(a.EmailAddress,'') EmailAddress,
		coalesce(i.InstitutionName,'') InstitutionName,
		coalesce(i.InstitutionAbbreviation,'') InstitutionAbbreviation, 
		coalesce(d.DepartmentName,'') DepartmentName, 
		coalesce(v.DivisionName,'') DivisionName 
	from [Profile.Data].[Person.Affiliation] a 
		left outer join [Profile.Data].[Organization.Institution] i on a.institutionid = i.institutionid 
		left outer join [Profile.Data].[Organization.Department] d on a.departmentid = d.departmentid 
		left outer join [Profile.Data].[Organization.Division] v on a.divisionid = v.divisionid
	where a.IsActive = 1
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [Profile.Data].[vwPerson]
as
		SELECT p.personid,
					 p.userid,
					 p.internalusername,
					 p.firstname,
					 p.lastname,
					 p.displayname, 
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.addressline1 END addressline1,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.addressline2 END addressline2,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.addressline3 END addressline3,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.addressline4 END addressline4,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.addressstring END addressstring, 
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN  p.building END building,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN  p.room END room,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN  p.floor END floor, 
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN  p.latitude END latitude, 
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN  p.longitude END longitude,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.phone END phone,
					 CASE WHEN ISNULL(dp.ShowAddress,'Y')='Y' THEN p.fax END fax,  
					 CASE WHEN ISNULL(dp.ShowEmail,'Y') = 'Y' THEN p.emailaddr END emailaddr,
					 i2.institutionname,
					 i2.institutionabbreviation, 
					 de.departmentname,
					 dv.divisionname,  
					 A.facultyrank, 
					 A.facultyranksort, 
					 p.isactive,
					 ISNULL(dp.ShowAddress,'Y')ShowAddress,
					 ISNULL(dp.ShowPhone,'Y')ShowPhone,
					 ISNULL(dp.Showfax,'Y')Showfax,
					 ISNULL(dp.ShowEmail,'Y')ShowEmail,
					 ISNULL(dp.ShowPhoto,'N')ShowPhoto,
					 ISNULL(dp.ShowAwards,'N')ShowAwards,
					 ISNULL(dp.ShowNarrative,'N')ShowNarrative,
					 ISNULL(dp.ShowPublications,'Y')ShowPublications, 
					 ISNULL(p.visible,1)visible,
					 0 numpublications
			FROM [Profile.Data].Person p
 LEFT JOIN [Profile.Cache].Person ps				 ON ps.personid = p.personid
 LEFT JOIN [Profile.Data].[Person.Affiliation] pa				 ON pa.personid = p.personid
																				AND pa.isprimary=1 
 LEFT JOIN [Profile.Data].[Organization.Institution] i2				 ON pa.institutionid = i2.institutionid 
 LEFT JOIN [Profile.Data].[Organization.Department] de				 ON de.departmentid = pa.departmentid
 LEFT JOIN [Profile.Data].[Organization.Division] dv				 ON dv.divisionid = pa.divisionid
 LEFT JOIN [Profile.Import].[Beta.DisplayPreference] dp on dp.PersonID=p.PersonID 
 OUTER APPLY(SELECT TOP 1 facultyrank ,facultyranksort from [Profile.Data].[Person.Affiliation] pa JOIN [Profile.Data].[Person.FacultyRank] fr on fr.facultyrankid = pa.facultyrankid  where personid = p.personid order by facultyranksort asc)a
 WHERE p.isactive = 1
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Ontology.Import].[vwOwlTriple] AS
	WITH xmlnamespaces (
		'http://aims.fao.org/aos/geopolitical.owl#' AS geo,
		'http://www.w3.org/2004/02/skos/core#' AS skco,
		'http://purl.org/NET/c4dm/event.owl#' AS event,
		'http://vivoweb.org/ontology/provenance-support#' AS pvs,
		'http://purl.org/dc/elements/1.1/' AS dcelem,
		'http://www.w3.org/2006/12/owl2-xml#' AS owl2,
		'http://vivoweb.org/ontology/scientific-research-resource#' AS scirr,
		'http://vivoweb.org/ontology/core#' AS vivo,
		'http://purl.org/vocab/vann/' AS vann,
		'http://vitro.mannlib.cornell.edu/ns/vitro/0.7#' AS vitro,
		'http://www.w3.org/2008/05/skos#' AS skos,
		'http://www.w3.org/1999/02/22-rdf-syntax-ns#' AS rdf,
		'http://jena.hpl.hp.com/ARQ/function#' AS afn,
		'http://purl.org/ontology/bibo/' AS bibo,
		'http://xmlns.com/foaf/0.1/' AS foaf,
		'http://www.w3.org/2003/06/sw-vocab-status/ns#' AS swvs,
		'http://www.w3.org/2002/07/owl#' AS owl,
		'http://purl.org/dc/terms/' AS dcterms,
		'http://www.w3.org/2001/XMLSchema#' AS xsd,
		'http://www.w3.org/2000/01/rdf-schema#' AS rdfs
	), d as (
		SELECT x.name OWL, x.Graph, d.query('.') d, isnull(d.value('@rdf:about','nvarchar(max)'),'http://profiles.catalyst.harvard.edu/ontology/nodeID#'+d.value('@rdf:nodeID','nvarchar(max)')) a
		FROM [Ontology.Import].[OWL] x CROSS APPLY data.nodes('//rdf:Description') AS R(d)
	)
	SELECT d.OWL,
		d.Graph,
		d.a Subject,
		d.d.value('namespace-uri((/rdf:Description/*[sql:column("n.n")])[1])','nvarchar(max)') 
				+ d.d.value('local-name((/rdf:Description/*[sql:column("n.n")])[1])','nvarchar(max)') Predicate,
		coalesce(d.d.value('(/rdf:Description/*[sql:column("n.n")]/@rdf:resource)[1]','nvarchar(max)'), 
				'http://profiles.catalyst.harvard.edu/ontology/nodeID#'
					+d.d.value('(/rdf:Description/*[sql:column("n.n")]/@rdf:nodeID)[1]','nvarchar(max)'), 
				d.d.value('(/rdf:Description/*[sql:column("n.n")])[1]','nvarchar(max)')) Object,
		d.d.value('count(rdf:Description/*)','nvarchar(max)') n, 
		n.n i
	FROM d, [Utility.Math].N n
	WHERE n.n between 1 and cast(d.d.value('count(rdf:Description/*)','nvarchar(max)') as int)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Framework.].[RunJobGroup]
	@JobGroup INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Exit if there is an error
	IF EXISTS (SELECT * FROM [Framework.].[Job] WHERE IsActive = 1 AND Status = 'ERROR')
	BEGIN
		RETURN
	END
	
	CREATE TABLE #Job (
		Step INT IDENTITY(0,1) PRIMARY KEY,
		JobID INT,
		Script NVARCHAR(MAX)
	)
	
	-- Get the list of job steps
	INSERT INTO #Job (JobID, Script)
		SELECT JobID, Script
			FROM [Framework.].[Job]
			WHERE JobGroup = @JobGroup AND IsActive = 1
			ORDER BY Step, JobID

	DECLARE @Step INT
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @LogID INT
	DECLARE @JobStart DATETIME
	DECLARE @JobEnd DATETIME
	DECLARE @JobID INT
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	DECLARE @date DATETIME,@auditid UNIQUEIDENTIFIER, @rows INT
	SELECT @date=GETDATE() 
	
	-- Loop through all steps
	WHILE EXISTS (SELECT * FROM #Job)
	BEGIN
		-- Get the next step
		SELECT @Step = (SELECT MIN(Step) FROM #Job)
		
		-- Get the SQL
		SELECT @SQL = Script, @JobID = JobID
			FROM #Job
			WHERE Step = @Step

		-- Wait until other jobs are complete
		WHILE EXISTS (SELECT *
						FROM [Framework.].[Job] o, #Job j
						WHERE o.JobID = j.JobID AND o.Status = 'PROCESSING')
		BEGIN
			WAITFOR DELAY '00:00:30'
		END

		-- Update the status
		SELECT @JobStart = GetDate()
		UPDATE o
			SET o.Status = 'PROCESSING', o.LastStart = @JobStart, o.LastEnd = NULL, o.ErrorCode = NULL, o.ErrorMsg = NULL
			FROM [Framework.].[Job] o, #Job j
			WHERE o.JobID = j.JobID AND j.Step = @Step
		INSERT INTO [Framework.].[Log.Job] (JobID, JobGroup, Step, Script, JobStart, Status)
			SELECT @JobID, @JobGroup, @Step, @SQL, @JobStart, 'PROCESSING'
		SELECT @LogID = @@IDENTITY
			
		
		-- Log Step Execution
		--SELECT @date=GETDATE()
		--EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@SQL,@ProcessStartDate=@date,@insert_new_record=1
		
		BEGIN TRY 
			-- Run the step
			EXEC sp_executesql @SQL
		END TRY 
		BEGIN CATCH
			--Check success
			IF @@TRANCOUNT > 0
				ROLLBACK
				
			--SELECT @date=GETDATE()
			--EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@SQL,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
			-- Log error 
			-- Update the status
			SELECT @JobEnd = GetDate()
			UPDATE o
				SET o.Status = 'JOB FAILED', o.LastEnd = GetDate(), o.ErrorCode = NULL, o.ErrorMsg = NULL
				FROM [Framework.].[Job] o, #Job j
				WHERE o.JobID = j.JobID AND j.Step = @Step
			UPDATE [Framework.].[Log.Job]
				SET JobEnd = @JobEnd, Status = 'JOB FAILED'
				WHERE LogID = @LogID
			--Raise an error with the details of the exception
			SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
			RAISERROR(@ErrMsg, @ErrSeverity, 1)
		END CATCH
		
		-- Log Step Execution
		--SELECT @date=GETDATE()
		--EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@SQL,@ProcessStartDate=@date,@insert_new_record=0
		
		
		-- Update the status
		SELECT @JobEnd = GetDate()
		UPDATE o
			SET o.Status = 'COMPLETED', o.LastEnd = GetDate(), o.ErrorCode = NULL, o.ErrorMsg = NULL
			FROM [Framework.].[Job] o, #Job j
			WHERE o.JobID = j.JobID AND j.Step = @Step
		UPDATE [Framework.].[Log.Job]
			SET JobEnd = @JobEnd, Status = 'COMPLETED'
			WHERE LogID = @LogID

		-- Remove the first step from the list
		DELETE j
			FROM #Job j
			WHERE Step = @Step
	END

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[SNA.Coauthor.UpdateBetweenness]  
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @date DATETIME,@auditid UNIQUEIDENTIFIER, @rows int
	 
	CREATE TABLE #neighbors (i INT NOT NULL, j INT NOT NULL)
	INSERT INTO #neighbors (i,j)
		SELECT DISTINCT PersonID1, PersonID2
			FROM [Profile.Cache].[SNA.Coauthor] 
			WHERE PersonID1 <> PersonID2

	ALTER TABLE #neighbors ADD PRIMARY KEY (i,j)

	CREATE TABLE #c(v INT PRIMARY KEY, c FLOAT)
	CREATE TABLE #p(w INT, v INT)
	CREATE CLUSTERED INDEX idx_w ON #p(w)
	CREATE TABLE #e(t INT PRIMARY KEY, e FLOAT)
	CREATE TABLE #d(j int primary key, distance INT, numpaths FLOAT)
	CREATE UNIQUE NONCLUSTERED INDEX idx_d ON #d(distance,j)

	DECLARE @s INT, @d INT, @AuthCount INT, @MaxS INT

	INSERT INTO #c SELECT DISTINCT i, 0 FROM #neighbors
	INSERT INTO #e SELECT DISTINCT i, 0 FROM #neighbors
	INSERT INTO #d SELECT DISTINCT i, 0, 0 FROM #neighbors
 
	SELECT @AuthCount = COUNT(DISTINCT i ) FROM [Profile.Cache].[SNA.Coauthor]

	SELECT @MaxS = (SELECT MAX(PersonID1) FROM [Profile.Cache].[SNA.Coauthor.Distance])

	SET @s = 1
	WHILE @s <= @MaxS
	BEGIN
		IF EXISTS (SELECT top 1 * FROM [Profile.Cache].[SNA.Coauthor] WHERE PersonID1 = @s)
		BEGIN

			DROP INDEX #d.idx_d
			UPDATE	d 
				SET	d.distance = s.distance, 
							d.numpaths = s.numpaths
				FROM	#d d
					JOIN  [Profile.Cache].[SNA.Coauthor.Distance] s ON s.PersonID1 = @s AND s.PersonID2 = d.j

			CREATE UNIQUE NONCLUSTERED INDEX idx_d ON #d(distance,j)

			TRUNCATE TABLE #p
			DROP INDEX #p.idx_w

			INSERT INTO #p(w,v)
				SELECT w.j, v.j
					FROM #d v
					JOIN #neighbors n ON v.j = n.i
					JOIN #d w on n.j = w.j
								 AND w.distance = v.distance + 1
				WHERE v.distance <= 99   
				 
			CREATE CLUSTERED INDEX idx_w ON #p(w)

			UPDATE #e 
				 SET e = 0

			SELECT @d = (SELECT MAX(distance) FROM #d WHERE distance < 99)
			WHILE @d > -1
			BEGIN
				UPDATE e 
					SET e.e = e.e + t.e
					FROM #e e, (
						SELECT	ev.t, SUM((bv.numpaths/bw.numpaths)*(1+ew.e)) e
							FROM	#p p
								JOIN  #e ev ON p.v = ev.t 
								JOIN  #e ew ON p.w = ew.t 
								JOIN  #d d ON d.distance = @d AND d.j = p.w
								JOIN  #d bv ON p.v = bv.j
								JOIN  #d bw ON  p.w = bw.j 										 
							GROUP BY ev.t
						) t
					WHERE e.t = t.t

				 SELECT @d = @d - 1
			END

			UPDATE c 
				SET c.c = c.c + e.e 
				FROM #c c
					JOIN #e e ON c.v = e.t
				WHERE c.v <> @s

		END

		SET @s = @s + 1
	END
	 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[SNA.Coauthor.Betweenness]
			INSERT INTO [Profile.Cache].[SNA.Coauthor.Betweenness] (personid,b)
				SELECT v, c FROM #c							 
		COMMIT 
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK

		 
		 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

	 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Framework.].[vwDatabaseCode] AS
	SELECT o.type, o.type_desc, o.full_name, 
		o.object_id, o.create_date, o.modify_date,
		c.number, c.colid, c.text,
		o.schema_name, o.name,
		o.principal_id, o.schema_id, o.parent_object_id,
		o.is_ms_shipped, o.is_published, o.is_schema_published
	FROM [Framework.].vwDatabaseObjects o, syscomments c
	WHERE c.id = o.object_id
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    view [Profile.Cache].[vwConcept.Mesh.Person]
with schemabinding
as
SELECT meshheader,
			 personid,
			 MAX(ISNULL(numpubsall,0))numpubsall,
			 MAX(ISNULL(NumPubsThis,0))NumPubsThis,
			 SUM(ISNULL(TopicWeight,0))TopicWeight,
			 SUM(ISNULL(AuthorWeight,0))AuthorWeight,
			 SUM(ISNULL(YearWeight,0))YearWeight,
			 MAX(ISNULL(UniquenessWeight,0))UniquenessWeight,
			 MAX(ISNULL(MeshWeight,0))MeshWeight,
			 COUNT_BIG(*)countbig
from [Profile.Cache].[Concept.Mesh.PersonPublication]
group by meshheader,
			 personid
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.SemWeb].[vwPrivate_Entities] AS
	SELECT NodeID id, Value value
	FROM [RDF.].Node
	WHERE ObjectType = 0
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [Profile.Data].[vwPerson.SecurityGroup]
as
select p.PersonID, p.IsActive, p.Visible, u.UserID, m.NodeID,
	(case	when p.IsActive = 1 and p.Visible = 1 then -1
			when p.IsActive = 1 then IsNull(m.NodeID,-40)
			else -50 end) ViewSecurityGroup,
	(case	when p.IsActive = 1 then IsNull(m.NodeID,-40)
			else -50 end) EditSecurityGroup
from [Profile.Data].Person p 
	left outer join [User.Account].[User] u
		on p.PersonID = u.PersonID
	left outer join [RDF.Stage].InternalNodeMap m
		on m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User' and m.InternalType = 'User' and m.InternalID = cast(u.UserID as varchar(50))
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.SemWeb].[vwHash2Base64]
	WITH SCHEMABINDING
	AS
	SELECT NodeID, [RDF.SemWeb].[fnHash2Base64](ValueHash) SemWebHash
		FROM [RDF.].Node

	/*

	-- This version of the view allows truncation / modification to [RDF.].Node	
	AS
	SELECT NodeID, [RDF.SemWeb].[fnHash2Base64](ValueHash) SemWebHash
		FROM [RDF.].Node

	-- This version of the view allows indexes
	WITH SCHEMABINDING
	AS
	SELECT NodeID, [RDF.SemWeb].[fnHash2Base64](ValueHash) SemWebHash
		FROM [RDF.].Node
	
	--Run after creating this view
	CREATE UNIQUE CLUSTERED INDEX [idx_SemWebHash] ON [RDF.SemWeb].[vwHash2Base64]([SemWebHash] ASC)
	CREATE UNIQUE NONCLUSTERED INDEX [idx_NodeID] ON [RDF.SemWeb].[vwHash2Base64]([NodeID] ASC)

	*/
GO
SET ARITHABORT ON
GO
SET CONCAT_NULL_YIELDS_NULL ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET ANSI_PADDING ON
GO
SET ANSI_WARNINGS ON
GO
SET NUMERIC_ROUNDABORT OFF
GO
CREATE UNIQUE CLUSTERED INDEX [idx_SemWebHash] ON [RDF.SemWeb].[vwHash2Base64] 
(
	[SemWebHash] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ARITHABORT ON
GO
SET CONCAT_NULL_YIELDS_NULL ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET ANSI_PADDING ON
GO
SET ANSI_WARNINGS ON
GO
SET NUMERIC_ROUNDABORT OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_NodeID] ON [RDF.SemWeb].[vwHash2Base64] 
(
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.SemWeb].[vwPrivate_Statements] AS
	SELECT t.subject, t.predicate, t.objecttype, t.object, 1 meta
	FROM [RDF.].Triple t
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Profile.Data].[vwPublication.Entity.InformationResource]
AS
SELECT EntityID, PMID, MPID, EntityName, EntityDate, Reference, Source, URL, PubYear, YearWeight, SummaryXML, IsActive
	FROM [Profile.Data].[Publication.Entity.InformationResource]
	WHERE IsActive = 1
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Profile.Data].[vwPublication.Entity.Authorship]
AS
SELECT EntityID, EntityName, EntityDate, authorRank, numberOfAuthors, authorNameAsListed, authorWeight, authorPosition, PubYear, YearWeight, PersonID, InformationResourceID, SummaryXML, IsActive
	FROM [Profile.Data].[Publication.Entity.Authorship]
	WHERE IsActive = 1
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.SemWeb].[vwPublic_Statements] AS
	SELECT t.subject, t.predicate, t.objecttype, t.object, 1 meta
	FROM [RDF.].Triple t, [RDF.].Node s, [RDF.].Node p, [RDF.].Node o
	WHERE t.ViewSecurityGroup = -1
		AND t.Subject=s.NodeID AND t.Predicate=p.NodeID AND t.Object=o.NodeID
		AND s.ViewSecurityGroup = -1 AND p.ViewSecurityGroup = -1 AND o.ViewSecurityGroup = -1
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Import].[ValidateProfilesImportTables]	 
AS
BEGIN
	SET NOCOUNT ON;	

	BEGIN TRY

		DECLARE @errorstring VARCHAR(2000), @ErrMsg VARCHAR(2000),@errSeverity VARCHAR(20)

		CREATE TABLE #Msg (MsgStr NVARCHAR(2000))
		DECLARE @sql NVARCHAR(max)


		--*************************************************************************************************************
		--*************************************************************************************************************
		--*** Validate column lengths and use of null values.
		--*************************************************************************************************************
		--*************************************************************************************************************

		-- Create a list of all the loading table columns and their valid lengths and types
		DECLARE @columns TABLE (
			tableName VARCHAR(50),
			columnName VARCHAR(50),
			dataType VARCHAR(50),
			maxLength INT,
			columnType VARCHAR(50)
		)
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','internalusername','string',50,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','firstname','string',50,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','middlename','string',50,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','lastname','string',50,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','displayname','string',255,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','suffix','string',50,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','addressline1','string',55,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','addressline2','string',55,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','addressline3','string',55,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','addressline4','string',55,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','addressstring','string',1000,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','city','string',100,'Not Used')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','state','string',2,'Not Used')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','zip','string',10,'Not Used')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','building','string',255,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','room','string',255,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','floor','int',null,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','latitude','decimal',null,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','longitude','decimal',null,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','phone','string',35,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','fax','string',25,'Optional') 
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','emailaddr','string',255,'Optional') 
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','isactive','bit',null,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[Person] ','isvisible','bit',null,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','internalusername','string',50,'Required') 
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','title','string',200,'Optional') 
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','emailaddr','string',200,'Dont Use')
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','primaryaffiliation','bit',null,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','affiliationorder','int',null,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','institutionname','string',500,'Optional') 
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','institutionabbreviation','string',50,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','departmentname','string',500,'Optional')  
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','departmentvisible','bit',null,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','divisionname','string',500,'Optional')  
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','facultyrank','string',100,'Optional') 
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonAffiliation]  ','facultyrankorder','tinyint',null,'Optional')  
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonFilterFlag]  ','internalusername','string',50,'Required') 
		INSERT INTO @columns VALUES ('[Profile.Import].[PersonFilterFlag]  ','personfilter','string',50,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','internalusername','string',50,'Required') 
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','firstname','string',100,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','lastname','string',100,'Required')
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','displayname','string',255,'Required') 
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','institution','string',500,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','department','string',500,'Optional')
		INSERT INTO @columns VALUES ('[Profile.Import].[User]','canbeproxy','bit',null,'Required')

		-- Check for values that are too long
		SELECT @sql = ''
		SELECT @sql = @sql + '
				INSERT INTO #Msg 
					SELECT ''ERROR: '+tableName+'.'+columnName+' has values longer than '+cast(maxLength as nvarchar(50))+' characters.''
					FROM '+tableName+'
					HAVING MAX(LEN(ISNULL('+columnName+',''''))) > '+cast(maxLength as nvarchar(50))+';'
			FROM @columns
			WHERE dataType = 'string'
		EXEC sp_executesql @sql 			 

		-- Check for values that should be numeric but are not
		SELECT @sql = ''
		SELECT @sql = @sql + '
				INSERT INTO #Msg 
					SELECT ''ERROR: '+tableName+'.'+columnName+' has values that are not numeric.''
					FROM '+tableName+' where '+tableName+'.'+columnName+' <>''''
					HAVING MIN(ISNUMERIC(ISNULL('+columnName+',0))) = 0;'
			FROM @columns
			WHERE columnName IN ('floor','assistantuserid')
		EXEC sp_executesql @sql 			 
  
		-- Check that Required columns do not have any NULLs
		SELECT @sql = ''
		SELECT @sql = @sql + '
				INSERT INTO #Msg 
					SELECT ''ERROR: '+tableName+'.'+columnName+' must contain only NULL values. It currently has at least one NOT NULL value.''
					FROM '+tableName+'
					HAVING MAX(CASE WHEN '+columnName+' IS NULL THEN 1 ELSE 0 END)=1;'
			FROM @columns
			WHERE columnType = 'Required'
		EXEC sp_executesql @sql 			 

		-- Check that Dont Use columns only have NULLs
		SELECT @sql = ''
		SELECT @sql = @sql + '
				INSERT INTO #Msg 
					SELECT ''ERROR: '+tableName+'.'+columnName+' must contain only NULL values. It currently has at least one NOT NULL value.''
					FROM '+tableName+' where '+tableName+'.'+columnName+' <>''''
					HAVING MIN(CASE WHEN '+columnName+' IS NULL THEN 1 ELSE 0 END)=0;'
			FROM @columns
			WHERE columnType = 'Dont Use'
		EXEC sp_executesql @sql 			 

		-- Check that columns do not mix NULLs and NOT NULLs
		SELECT @sql = ''
		SELECT @sql = @sql + '
				INSERT INTO #Msg 
					SELECT ''ERROR: '+tableName+'.'+columnName+' contains both null and not null values.''
					FROM '+tableName+'
					HAVING MAX(CASE WHEN '+columnName+' IS NULL THEN 1 ELSE 0 END) <> MIN(CASE WHEN '+columnName+' IS NULL THEN 1 ELSE 0 END);'
			FROM @columns
		EXEC sp_executesql @sql 			 


		--*************************************************************************************************************
		--*************************************************************************************************************
		--*** Validate data logic (duplicate values, cross-column consistency, invalid mapping, etc).
		--*************************************************************************************************************
		--*************************************************************************************************************

		-- Check for internalusername duplicates

		INSERT INTO #Msg
			SELECT 'ERROR: An internalusername is used more than once in [Profile.Import].[Person] .'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[Person]  GROUP BY internalusername HAVING COUNT(*)>1)

		INSERT INTO #Msg
			SELECT 'ERROR: An internalusername is used more than once in [Profile.Import].[User].'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[User] GROUP BY internalusername HAVING COUNT(*)>1)

		-- Check that primaryaffiliation and affiliationsort are being used correctly

		INSERT INTO #Msg
			SELECT 'ERROR: A person in [Profile.Import].[PersonAffiliation] does not have a record with primaryaffiliation=1.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] GROUP BY internalusername HAVING SUM(primaryaffiliation*1)=0)

		INSERT INTO #Msg
			SELECT 'ERROR: A person in [Profile.Import].[PersonAffiliation] has more than one record with primaryaffiliation=1.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] GROUP BY internalusername HAVING SUM(primaryaffiliation*1)>1)

		INSERT INTO #Msg
			SELECT 'ERROR: A person in [Profile.Import].[PersonAffiliation] has more than one affiliationorder values that are the same.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] GROUP BY internalusername HAVING COUNT(DISTINCT affiliationorder)<>COUNT(affiliationorder))

		-- Check that institutions are being defined correctly

	
		INSERT INTO #Msg
			SELECT 'ERROR: An institutionname in [Profile.Import].[PersonAffiliation] is NULL when either institutionfullname or institutionabbreviation is defined.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE COALESCE(institutionname,institutionabbreviation) IS NOT NULL AND institutionname IS NULL)

		INSERT INTO #Msg
			SELECT 'ERROR: An institutionabbreviation in [Profile.Import].[PersonAffiliation] is NULL when either institutionfullname or institutionname is defined.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE institutionname IS NOT NULL AND institutionabbreviation IS NULL)

		INSERT INTO #Msg
			SELECT 'ERROR: An institutionname in [Profile.Import].[PersonAffiliation] is being mapped to more than one institutionabbreviation.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE institutionname IS NOT NULL GROUP BY institutionname HAVING COUNT(DISTINCT institutionabbreviation)>1)

		INSERT INTO #Msg
			SELECT 'ERROR: An institutionabbreviation in [Profile.Import].[PersonAffiliation] is being mapped to more than one institutionname.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE institutionabbreviation IS NOT NULL GROUP BY institutionabbreviation HAVING COUNT(DISTINCT institutionname)>1)

		-- Check that departments are being defined correctly
				
		INSERT INTO #Msg
			SELECT 'ERROR: A departmentvisible in [Profile.Import].[PersonAffiliation] is NULL when a departmentname is defined.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE departmentname IS NOT NULL AND departmentvisible IS NULL)

		-- Check that divisions are being defined correctly

		-- Check that faculty ranks are being defined correctly
		INSERT INTO #Msg
			SELECT 'ERROR: A facultyrank in [Profile.Import].[PersonAffiliation] has a NULL facultyrankorder.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE facultyrank IS NOT NULL AND facultyrankorder IS NULL)

		INSERT INTO #Msg
			SELECT 'ERROR: A facultyrank in [Profile.Import].[PersonAffiliation] is being mapped to more than one facultyrankorder.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE facultyrank IS NOT NULL GROUP BY facultyrank HAVING COUNT(DISTINCT facultyrankorder)>1)

		INSERT INTO #Msg
			SELECT 'ERROR: A facultyrankorder in [Profile.Import].[PersonAffiliation] is being mapped to more than one facultyrank.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE facultyrankorder IS NOT NULL GROUP BY facultyrankorder HAVING COUNT(DISTINCT facultyrank)>1)



		--*************************************************************************************************************
		--*************************************************************************************************************
		--*** Identify items that are not errors, but might produce unexpected behavior.
		--*************************************************************************************************************
		--*************************************************************************************************************

		INSERT INTO #Msg
			SELECT 'WARNING: All records in [Profile.Import].[Person]  have isactive=0 (or IS NULL). As a result, no people will appear on the website.'
				WHERE NOT EXISTS (SELECT 1 FROM [Profile.Import].[Person]  WHERE isactive=1)

		INSERT INTO #Msg
			SELECT 'WARNING: All records in [Profile.Import].[Person]  have isvisible=0 (or IS NULL). As a result, all profile pages will show an ''Under Construction'' message.'
				WHERE NOT EXISTS (SELECT 1 FROM [Profile.Import].[Person]  WHERE isvisible=1)

		INSERT INTO #Msg
			SELECT 'WARNING: All records in [Profile.Import].[User] have canbeproxy=0 (or IS NULL). As a result, people will not be able to select any of these users to be their proxies.'
				WHERE NOT EXISTS (SELECT 1 FROM [Profile.Import].[User] WHERE canbeproxy=1)

		INSERT INTO #Msg
			SELECT 'WARNING: All [Profile.Import].[Person] .addresslineN values are NULL. As a result, no addresses will be displayed on the website.'
				FROM [Profile.Import].[Person] 
				HAVING MIN(CASE WHEN COALESCE(addressline1,addressline2,addressline3,addressline4) IS NULL THEN 1 ELSE 0 END) = 1

		INSERT INTO #Msg
			SELECT 'WARNING: All [Profile.Import].[Person] .addressstring values are NULL. As a result, geocoding will not work, and people will not be displayed on maps.'
				FROM [Profile.Import].[Person] 
				HAVING MIN(CASE WHEN addressstring IS NULL AND (latitude IS NULL or longitude IS NULL) THEN 1 ELSE 0 END) = 1

		INSERT INTO #Msg
			SELECT 'WARNING: All departments in [Profile.Import].[PersonAffiliation] have departmentvisible=0 (or IS NULL). As a result, no departments will be listed in the website search form.'
				FROM [Profile.Import].[PersonAffiliation]
				HAVING MAX(IsNull(departmentvisible*1,-1))=0

		INSERT INTO #Msg
			SELECT 'WARNING: A departmentname in [Profile.Import].[PersonAffiliation] has records with departmentvisible=0 (or IS NULL) and departmentvisible=1. The department will be visible on the website.'
				WHERE EXISTS (SELECT 1 FROM [Profile.Import].[PersonAffiliation] WHERE departmentname IS NOT NULL GROUP BY departmentname HAVING MAX(departmentvisible*1)<>MIN(departmentvisible*1))


		--*************************************************************************************************************
		--*************************************************************************************************************
		--*** Display the list of errors and warnings that were found.
		--*************************************************************************************************************
		--*************************************************************************************************************

		INSERT INTO #Msg
			SELECT 'No problems were found.'
				WHERE NOT EXISTS (SELECT 1 FROM #Msg)

		SELECT * FROM #Msg 


	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK

		-- Raise an error with the details of the exception
		SELECT @ErrMsg = '[usp_ValidateProfilesLoaderTables] Failed with : ' + ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH	
				
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Utility.NLP].[UpdateThesaurus]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- MeSH
	delete from [Utility.NLP].[Thesaurus] where Source = 1
	insert into [Utility.NLP].[Thesaurus] (Source, ConceptID, TermName)
		select 1, dense_rank() over (order by ConceptUI) ConceptID, TermName
		from (
			select ConceptUI, replace(TermName,',','') TermName
				from [Profile.Data].[Concept.Mesh.Term]
			union
			select ConceptUI, replace(DescriptorName,',','') DescriptorName
				from [Profile.Data].[Concept.Mesh.Term]
				where PreferredConceptYN = 'N' and ConceptPreferredTermYN = 'Y'
		) t

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[Support.GetHTML]
	@NodeID BIGINT,
	@EditMode BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @str VARCHAR(MAX)

	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
			AND m.Class = 'http://xmlns.com/foaf/0.1/Person' AND m.InternalType = 'Person'

	IF @PersonID IS NOT NULL
	BEGIN

		if @editMode = 0
			set @str = 'Local representatives can answer questions about the Profiles website or help with editing a profile or issues with profile data. For assistance with this profile:'
		else
			set @str = 'Local representatives can help you modify your basic information above, including title and contact information, or answer general questions about Profiles. For assistance with this profile:'

		select @str = @str + (
				select ' '+s.html
					from [Profile.Module].[Support.HTML] s, (
						select m.SupportID, min(SortOrder) x 
							from [Profile.Cache].[Person.Affiliation] a, [Profile.Module].[Support.Map] m
							where a.instititutionname = m.institution and (a.departmentname = m.department or m.department = '')
								and a.PersonID = 176
							group by m.SupportID
					) t
					where s.SupportID = t.SupportID
					order by t.x
					for xml path(''), type
			).value('(./text())[1]','nvarchar(max)')

	END

	SELECT @str HTML WHERE @str IS NOT NULL

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [User.Session].[Session](
	[SessionID] [uniqueidentifier] NOT NULL,
	[SessionSequence] [int] IDENTITY(0,1) NOT NULL,
	[CreateDate] [datetime] NULL,
	[LastUsedDate] [datetime] NULL,
	[LoginDate] [datetime] NULL,
	[LogoutDate] [datetime] NULL,
	[RequestIP] [varchar](16) NULL,
	[UserID] [int] NULL,
	[PersonID] [int] NULL,
	[EntityID] [int] NULL,
	[UserRoleSetID] [uniqueidentifier] NULL,
	[NodeID] [bigint] NULL,
	[UserNode] [bigint] NULL,
	[ImpersonateUserNode] [bigint] NULL,
	[UserAgent] [varchar](500) NULL,
	[IsBot] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[SessionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [SessionSequence] ON [User.Session].[Session] 
(
	[SessionSequence] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[SNA.Coauthor.UpdateSummary]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	DECLARE @date DATETIME,@auditid UNIQUEIDENTIFIER, @rows int
	 
	select p.personid, --(case when numpublications > 0 then 1 else 0 end) 
	0 HasPublications,
			(case when isnull(s.clustersize,0)>1000 then 1 else 0 end) HasSNA,
			isnull(d.NumPeople,0) Reach1,
			isnull(r.NumPeople,0) Reach2,
			isnull(c.Closeness,0) Closeness,
			isnull(b.b,0) Betweenness
		into #cache_sna
		from [Profile.Cache].Person p
			left outer join (select * from [Profile.Cache].[SNA.Coauthor.Reach] where distance = 1) d on p.personid = d.personid
			left outer join (select * from [Profile.Cache].[SNA.Coauthor.Reach] where distance = 2) r on p.personid = r.personid
			left outer join (select personid, sum(cast(NumPeople as float)*Distance)/sum(cast(NumPeople as float)) closeness from [Profile.Cache].[SNA.Coauthor.Reach] where distance < 99 group by personid) c on p.personid = c.personid
			left outer join (select personid, sum(cast(NumPeople as int)) clustersize from [Profile.Cache].[SNA.Coauthor.Reach] where distance < 99 group by personid) s on p.personid = s.personid
			left outer join (select * from [Profile.Cache].[SNA.Coauthor.Betweenness]) b on p.personid = b.personid
	alter table #cache_sna add primary key (personid)

	BEGIN TRY
		BEGIN TRAN
			update p
				set p.HasPublications = s.HasPublications,
					p.HasSNA = s.HasSNA,
					p.Reach1 = s.Reach1,
					p.Reach2 = s.Reach2,
					p.Closeness = s.Closeness,
					p.Betweenness = s.Betweenness
				from [Profile.Cache].Person p inner join #cache_sna s on p.personid = s.personid
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
	 
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

	 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [RDF.Stage].[ProcessTriples]
	@ProcessAll bit = 1,
	@ShowCounts bit = 0,
	@ProcessLimit bigint = 1000000,
	@IsRunningInLoop bit = 0
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	/* 
 
	This stored procedure converts triples defined in [RDF.Stage].Triple into 
	records in [RDF.].Node and [RDF.].Triple and updates IsPublic and other attributes
	on existing records.
 
	The subject, predicate, and object of a triple can be defined in different ways:
		Subject
			Cat 0: sNodeID (from [RDF.].Node)
			Cat 1: sURI
			Cat 2: sNodeType (primary VIVO type, http://xmlns.com/foaf/0.1/Person), sInternalType (Profiles10 type, such as "Person"), sInternalID (personID=32213)
			Cat 3: sTripleID (from [RDF.].Triple -- a reitification)
			Cat 4: sStageTripleID (from [RDF.Stage.].Triple -- a reitification of a triple not yet loaded)
		Predicate
			Cat 0: pNodeID (from [RDF.].Node)
			Cat 1: pProperty (a VIVO property, such as http://www.w3.org/1999/02/22-rdf-syntax-ns#type or http://xmlns.com/foaf/0.1/firstName)
		Object
			Cat 0: oNodeID (from [RDF.].Node)
			Cat 1: oValue, oLanguage, oDataType, oObjectType (standard RDF literal [oObjectType=1], or just oValue if URI [oObjectType=0])
			Cat 2: oNodeType (primary VIVO type, http://xmlns.com/foaf/0.1/Person), oInternalType (Profiles10 type, such as "Person"), oInternalID (personID=32213)
			Cat 3: oTripleID (from [RDF.].Triple -- a reitification)
			Cat 4: oStageTripleID (from [RDF.Stage.].Triple -- a reitification of a triple not yet loaded)
			Cat 5: oStartTime, oEndTime, oTimePrecision (VIVO's DateTimeInterval, DateTimeValue, and DateTimeValuePrecision classes)
			Cat 6: oStartTime, oTimePrecision (VIVO's DateTimeValue, and DateTimeValuePrecision classes)
 
	The following are also related to a triple:
		sIsPublic = 1 (security of subject)
		pIsPublic = 1 (security of predicate)
		oIsPublic = 1 (security of object)
		tIsPublic = 1 (security of triple)
		Weight = 1 (float, strength of connection)
		SortOrder = 1 (should be a row_number() over (partition by subject, predicate order by ...))
 
	These field s are to help with processing:
		StageTripleID
		sValueHash
		pValueHash
		oValueHash
		TripleID
		TripleHash
		Reitification
		Status
 
	1. Determine the input categories for subject, predicate, and object in [RDF.Stage].Triple
	2. Create a distinct list of node definitions from [RDF.Stage].Triple
	3. Map each node definition to an existing NodeID or create a new node and get its NodeID
	4. Lookup the NodeID for each node definition in [RDF.Stage].Triple
	5. Update or insert triples
	6. Update node attributes
	7. Save a list of which stage triples were processed
 
	*/
 

	-- Turn off real-time indexing
	IF @IsRunningInLoop = 0
		ALTER FULLTEXT INDEX ON [RDF.].Node SET CHANGE_TRACKING OFF 


	--*******************************************************************************************
	--*******************************************************************************************
	-- Iterate through multiple calls to this procedure until all triples are processed
	--*******************************************************************************************
	--*******************************************************************************************


	if @ProcessAll = 1
	begin

		truncate table [RDF.Stage].[Triple.Map]
		
		declare @IterationResults table (NewNodes bigint, NewTriples bigint, FoundRecords bigint, ProcessedRecords bigint)
		declare @IterationCount int
		declare @IterationStart datetime
		declare @IterationMax int
		select @IterationCount = 0, @IterationMax = 1000
		while @IterationCount < @IterationMax
		begin
			select @IterationStart = getdate()
			insert into @IterationResults
				exec [RDF.Stage].[ProcessTriples] @ProcessAll = 0, @ShowCounts = 1, @ProcessLimit = @ProcessLimit, @IsRunningInLoop = 1
			if @ShowCounts = 1
				select * from @IterationResults
			if ((select count(*) from @IterationResults) = 0) or ((select ProcessedRecords from @IterationResults) = 0)
				select @IterationCount = @IterationMax
			insert into [rdf.stage].[Log.Triple] (CompleteDate, NewNodes, NewTriples, FoundRecords, ProcessedRecords, TimeElapsed)
				select getdate(), *, datediff(ms,@IterationStart,getdate())/1000.00000 from @IterationResults
			delete from @IterationResults
			set @IterationCount = @IterationCount + 1
		end

		-- Turn on real-time indexing
		ALTER FULLTEXT INDEX ON [RDF.].Node SET CHANGE_TRACKING AUTO;
		-- Kick off population FT Catalog and index
		ALTER FULLTEXT INDEX ON [RDF.].Node START FULL POPULATION 

		return

	end


	--*******************************************************************************************
	--*******************************************************************************************
	-- Start a single iteration
	--*******************************************************************************************
	--*******************************************************************************************

	declare @NewNodes bigint
	declare @NewTriples bigint
	declare @FoundRecords bigint
	declare @ProcessedRecords bigint
	select @NewNodes = 0, @NewTriples = 0, @FoundRecords = 0, @ProcessedRecords = 0
 
	create table #Debug (i int identity(0,1) primary key, x varchar(100), d datetime)

	--*******************************************************************************************
	--*******************************************************************************************
	-- 1. Determine the input categories for subject, predicate, and object in [RDF.Stage].Triple
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select '1',GetDate()

	select top (@ProcessLimit)
			t.StageTripleID,
				(case	when sNodeID is not null then 0
						when sURI is not null then 1
						when sNodeType is not null and sInternalType is not null and sInternalID is not null then 2
						when sTripleID is not null then 3
						when sStageTripleID is not null then 4
						else null end) sCategory,
				(case	when pNodeID is not null then 0
						when pProperty is not null then 1
						else null end) pCategory,
				(case	when oNodeID is not null then 0
						when oValue is not null and oObjectType is not null then 1
						when oNodeType is not null and oInternalType is not null and oInternalID is not null then 2
						when oTripleID is not null then 3
						when oStageTripleID is not null then 4
						when oStartTime is not null and oEndTime is not null and oTimePrecision is not null then 5
						when oStartTime is not null and oTimePrecision is not null then 6
						else null end) oCategory,
				(case	when sNodeID is not null then null
						when sURI is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull(sURI,N''),N'"',N'\"')+N'"'))) 
						when sNodeType is not null and sInternalType is not null and sInternalID is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull(sNodeType+'^^'+sInternalType+'^^'+sInternalID,N''),N'"',N'\"')+N'"'))) 
						when sTripleID is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull('#TRIPLE'+cast(sTripleID as varchar(50)),N''),N'"',N'\"')+N'"')))
						when sStageTripleID is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull('#STAGETRIPLE'+cast(sStageTripleID as varchar(50)),N''),N'"',N'\"')+N'"')))
						else null end) sValueHash,
				(case	when pNodeID is not null then null
						when pProperty is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull(pProperty,N''),N'"',N'\"')+N'"')))
						else null end) pValueHash,
				(case	when oNodeID is not null then null
						when oValue is not null and oObjectType is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull(oValue,N''),N'"',N'\"')+'"'+IsNull(N'"@'+replace(oLanguage,N'@',N''),N'')+IsNull(N'"^^'+replace(oDataType,N'^',N''),N''))))
						when oNodeType is not null and oInternalType is not null and oInternalID is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull(oNodeType+'^^'+oInternalType+'^^'+oInternalID,N''),N'"',N'\"')+N'"'))) 
						when oTripleID is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull('#TRIPLE'+cast(oTripleID as varchar(50)),N''),N'"',N'\"')+N'"')))
						when oStageTripleID is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull('#STAGETRIPLE'+cast(oStageTripleID as varchar(50)),N''),N'"',N'\"')+N'"')))
						else null end) oValueHash,
			sNodeID, sViewSecurityGroup, sEditSecurityGroup,
			pNodeID, pViewSecurityGroup, pEditSecurityGroup,
			oNodeID, oViewSecurityGroup, oEditSecurityGroup,
			oObjectType, TripleHash, 
			TripleID, tViewSecurityGroup,
			Weight, SortOrder, Reitification, Graph, 0 Status
		into #TripleHash
		from [RDF.Stage].Triple t
		where status is null
		order by StageTripleID

	select @FoundRecords = @@ROWCOUNT
 
 
	--***************************************************************** **************************
	--*******************************************************************************************
	-- 2. Create a distinct list of node definitions from [RDF.Stage].Triple
	--*******************************************************************************************
	--*******************************************************************************************
 
	insert into #Debug (x,d) select '2',GetDate()

	create table #nodes (
		Category tinyint,
		NodeType nvarchar(400),
		InternalType nvarchar(100),
		InternalID nvarchar(100),
		InternalHash binary(20),
		Value nvarchar(max),
		Language nvarchar(255),
		DataType nvarchar(255),
		ObjectType bit,
		ValueHash binary(20),
		StartTime datetime,
		EndTime datetime,
		TimePrecision nvarchar(255),
		TripleID bigint,
		StageTripleID bigint,
		NodeID bigint,
		Status tinyint
	)

	select ValueHash, Category, StageTripleID, maxObjectType ObjectType, n
		into #ntemp
		from (
			select *, row_number() over (partition by ValueHash order by StageTripleID, n) k,
				max(ObjectType) over (partition by ValueHash) maxObjectType
			from (
				select (case when n in (0,1,2) then 1 when n in (3,4) then 2 when n in (5,6) then 3 when n in (7,8) then 4 else null end) Category,
					(case when n in (0,3,5,7) then sValueHash when n=1 then pValueHash when n in (2,4,6,8) then oValueHash else null end) ValueHash, 
					StageTripleID, 
					(case when n=2 then cast(oObjectType as tinyint) else 0 end) ObjectType,
					n
				from #TripleHash t, [Utility.Math].N n
				where n <= 8
					and (	(n=0 and sCategory=1) or 
							(n=1 and pCategory=1) or 
							(n=2 and oCategory=1) or
							(n=3 and sCategory=2) or
							(n=4 and oCategory=2) or
							(n=5 and sCategory=3) or
							(n=6 and oCategory=3) or
							(n=7 and sCategory=4) or
							(n=8 and oCategory=4)
						)
			) t
		) t
		where k = 1

	insert into #Debug (x,d) select '2.2',GetDate()

	-- Use the pointers to create a distinct list of nodes.
	insert into #nodes (Category, NodeType, InternalType, InternalID, InternalHash, Value, Language, DataType, ObjectType, ValueHash, TripleID, StageTripleID, Status)
		select n.Category, 
			(case when n=3 then sNodeType when n=4 then oNodeType else null end),
			(case when n=3 then sInternalType when n=4 then oInternalType else null end),
			(case when n=3 then sInternalID when n=4 then oInternalID else null end),
			n.ValueHash,
			(case when n=0 then sURI when n=1 then pProperty when n=2 then oValue else null end),
			(case when n=2 then oLanguage else null end),
			(case when n=2 then oDataType else null end),
			n.ObjectType, 
			(case when n.Category=1 then n.ValueHash else null end),
			(case when n=5 then sTripleID when n=6 then oTripleID else null end),
			(case when n=7 then sStageTripleID when n=8 then oStageTripleID else null end)m,
			0
		from [RDF.Stage].Triple t, #ntemp n
		where t.StageTripleID = n.StageTripleID
	--create nonclustered index idx_ValueHash on #nodes(Category,ValueHash) include (NodeID)
	--create nonclustered index idx_InternalHash on #nodes(Category,InternalHash) include (NodeID)

	insert into #Debug (x,d) select '2.3',GetDate()

	create nonclustered index idx_ValueHash on #nodes(Category,ValueHash)
	create nonclustered index idx_InternalHash on #nodes(Category,InternalHash)
	create nonclustered index idx_node on #nodes(Category,NodeID)
 
 
	--*******************************************************************************************
	--*******************************************************************************************
	-- 3. Map each node definition to an existing NodeID or create a new node and get its NodeID
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select '3',GetDate()

	-- Lookup the base URI
	declare @baseURI nvarchar(400)
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'
 
	--------------------------------------------------
	-- Category 1 (URI, Property, or Value)
	--------------------------------------------------

	insert into #Debug (x,d) select '3.1',GetDate()

	-- Find existing NodeIDs
	update n
		set n.NodeID = m.NodeID
		from #nodes n, [RDF.].Node m
		where n.Category = 1
			and n.ValueHash = m.ValueHash
 
	-- Create new nodes
	insert into [RDF.].Node (ViewSecurityGroup, EditSecurityGroup, ValueHash, Language, DataType, Value, ObjectType)
		select 0, 0, ValueHash, Language, DataType, Value, ObjectType
		from #nodes
		where Category = 1 and NodeID is null
	select @NewNodes = @NewNodes + @@ROWCOUNT
	update n
		set n.NodeID = m.NodeID
		from #nodes n, [RDF.].Node m
		where n.Category = 1 and n.NodeID is null
			and n.ValueHash = m.ValueHash
 
	--------------------------------------------------
	-- Category 2 (InternalID)
	--------------------------------------------------

	insert into #Debug (x,d) select '3.2',GetDate()
 
	-- Find existing NodeIDs
	update n
		set n.NodeID = m.NodeID
		from #nodes n, [RDF.Stage].InternalNodeMap m
		where n.Category = 2
			and n.InternalHash = m.InternalHash

	insert into #Debug (x,d) select '3.2.2',GetDate()
 
	-- Create new nodes for new internal IDs
	insert into [RDF.Stage].InternalNodeMap (Class, InternalType, InternalID, Status, InternalHash)
		select NodeType, InternalType, InternalID, 0, InternalHash
		from #nodes
		where Category = 2 and NodeID is null

	insert into #Debug (x,d) select '3.2.3',GetDate()

	update [RDF.Stage].InternalNodeMap
		set ValueHash = CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"#INM'+cast(InternalNodeMapID as nvarchar(50))+N'"'))), 
			status = 1
		where status = 0

	insert into #Debug (x,d) select '3.2.4',GetDate()

	insert into [RDF.].Node (ViewSecurityGroup, EditSecurityGroup, ValueHash, Value, InternalNodeMapID, ObjectType)
		select 0, 0, ValueHash,
			'#INM'+cast(InternalNodeMapID as nvarchar(50)),
			InternalNodeMapID, 0
		from [RDF.Stage].InternalNodeMap
		where status = 1
	select @NewNodes = @NewNodes + @@ROWCOUNT

	insert into #Debug (x,d) select '3.2.5',GetDate()

	update i
		set i.NodeID = n.NodeID, i.Status = 2,
			i.ValueHash = CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+@baseURI+cast(n.NodeID as nvarchar(50))+N'"'))) 
		from [RDF.Stage].InternalNodeMap i, [RDF.].Node n
		where i.Status = 1 and i.ValueHash = n.ValueHash

	insert into #Debug (x,d) select '3.2.6',GetDate()

	update n
		set n.Value = @baseURI+cast(n.NodeID as nvarchar(50)),
			n.ValueHash = i.ValueHash
		from [RDF.Stage].InternalNodeMap i, [RDF.].Node n
		where i.Status = 2 and i.NodeID = n.NodeID

	insert into #Debug (x,d) select '3.2.7',GetDate()

	update [RDF.Stage].InternalNodeMap
		set Status = 3
		where Status = 2

	insert into #Debug (x,d) select '3.2.8',GetDate()

	update n
		set n.NodeID = m.NodeID
		from #nodes n, [RDF.Stage].InternalNodeMap m
		where n.Category = 2 and n.NodeID is null
			and n.InternalHash = m.InternalHash

	--------------------------------------------------
	-- Category 4 (StageTripleID - Map to TripleID)
	--------------------------------------------------

	insert into #Debug (x,d) select '3.4',GetDate()
 
	update n
		set	n.TripleID = IsNull(m.TripleID,n.TripleID), 
			--n.InternalHash = (case when m.TripleID IS NULL then n.InternalHash else CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"#TRIPLE'+cast(m.TripleID as varchar(50))+N'"'))) end),
			n.Category = (case when m.TripleID IS NULL then 99 else 4 end)
		from #nodes n LEFT OUTER JOIN [RDF.Stage].[Triple.Map] m ON n.StageTripleID = m.StageTripleID
		where n.Category = 4

	--------------------------------------------------
	-- Category 3 (TripleID - Reitification)
	--------------------------------------------------

	insert into #Debug (x,d) select '3.3',GetDate()
 
	-- Find existing NodeIDs
	update n
		set n.NodeID = t.Reitification, n.Status = 2
		from #nodes n, [RDF.].Triple t
		where n.Category IN (3,4) and n.TripleID = t.TripleID and t.Reitification is not null

	insert into #Debug (x,d) select '3.3.2',GetDate()
 
	-- Create new nodes for new triples
	insert into [RDF.].Node (ViewSecurityGroup, EditSecurityGroup, ValueHash, Value, ObjectType)
		select 0, 0, InternalHash,
			'#TRIPLE'+cast(TripleID as nvarchar(50)),
			0
		from #nodes
		where Category IN (3,4) and Status = 0
	select @NewNodes = @NewNodes + @@ROWCOUNT

	insert into #Debug (x,d) select '3.3.3',GetDate()

	update i
		set i.NodeID = n.NodeID,
			i.ValueHash = CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+@baseURI+cast(n.NodeID as nvarchar(50))+N'"'))),
			i.Status = 1
		from #nodes i, [RDF.].Node n
		where i.Category IN (3,4) and i.Status = 0 and i.InternalHash = n.ValueHash

	insert into #Debug (x,d) select '3.3.4',GetDate()

	update n
		set n.Value = @baseURI+cast(n.NodeID as nvarchar(50)),
			n.ValueHash = i.ValueHash
		from #nodes i, [RDF.].Node n
		where i.Category IN (3,4) and i.Status = 1 and i.NodeID = n.NodeID

	insert into #Debug (x,d) select '3.3.5',GetDate()

	update t
		set t.Reitification = i.NodeID
		from #nodes i, [RDF.].Triple t
		where i.Category IN (3,4) and i.Status = 1 and i.TripleID = t.TripleID

	insert into #Debug (x,d) select '3.3.6',GetDate()

	update #nodes
		set Status = 2
		where Category IN (3,4) and Status = 1
 
 
	--*******************************************************************************************
	--*******************************************************************************************
	-- 4. Lookup the NodeID for each node definition
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select '4',GetDate()

	select t.StageTripleID,
			t.sCategory, t.sNodeID, t.sViewSecurityGroup, t.sEditSecurityGroup,
			t.pCategory, t.pNodeID, t.pViewSecurityGroup, t.pEditSecurityGroup,
			t.oCategory, t.oNodeID, t.oViewSecurityGroup, t.oEditSecurityGroup, t.oObjectType,
			convert(binary(20),NULL) TripleHash,
			t.TripleID, t.tViewSecurityGroup, t.Weight, t.SortOrder, t.Reitification,
			t.sValueHash, t.pValueHash, t.oValueHash, t.Graph,
			1 Status
		into #TripleCompact
		from #TripleHash t
	update t
		set t.sNodeID = IsNull(t.sNodeID,s.NodeID),
			t.pNodeID = IsNull(t.pNodeID,p.NodeID),
			t.oNodeID = IsNull(t.oNodeID,o.NodeID)
		from #TripleCompact t
			left outer join #nodes s on t.sNodeID is null and t.sCategory = s.Category and t.sValueHash = s.InternalHash
			left outer join #nodes p on t.pNodeID is null and t.pCategory = p.Category and t.pValueHash = p.InternalHash
			left outer join #nodes o on t.oNodeID is null and t.oCategory = o.Category and t.oValueHash = o.InternalHash
	delete
		from #TripleCompact
		where sNodeID IS NULL OR pNodeID IS NULL OR oNodeID IS NULL
	update #TripleCompact
		set TripleHash = 			
			convert(binary(20),HashBytes('sha1',
				convert(nvarchar(max),
					+N'"'
					+N'<#'+convert(nvarchar(max),sNodeID)+N'> '
					+N'<#'+convert(nvarchar(max),pNodeID)+N'> '
					+N'<#'+convert(nvarchar(max),oNodeID)+N'> .'
					+N'"'
					+N'^^http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement'
				)
			))
	create nonclustered index idx_status on #TripleCompact (status)

 
	--*******************************************************************************************
	--*******************************************************************************************
	-- 5. Update or insert triples
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select '5',GetDate()

	-------------------------------------
	-- Existing triples
	-------------------------------------

	insert into #Debug (x,d) select '5.1',GetDate()

	-- Find existing TripleIDs
	update t
		set t.TripleID = v.TripleID, t.status = 2
		from #TripleCompact t, [RDF.].Triple v
		where t.TripleHash = v.TripleHash and t.status = 1
	-- Update attributes of existing TripleIDs
	update v
		set v.ViewSecurityGroup = t.ViewSecurityGroup, v.Weight = t.Weight, v.SortOrder = t.SortOrder
		from [RDF.].Triple v, (
			select TripleID, min(tViewSecurityGroup) ViewSecurityGroup, max(Weight) Weight, min(SortOrder) SortOrder
			from #TripleCompact
			where status = 2
			group by TripleID
		) t
		where v.TripleID = t.TripleID
			and (v.ViewSecurityGroup <> t.ViewSecurityGroup OR v.Weight <> t.Weight OR v.SortOrder <> t.SortOrder)

	-------------------------------------
	-- New triples without dependencies
	-------------------------------------

	insert into #Debug (x,d) select '5.2',GetDate()

	-- Create new triples
	insert into [RDF.].Triple (ViewSecurityGroup, Subject, Predicate, Object, TripleHash, Weight, ObjectType, SortOrder, Graph)
		select min(tViewSecurityGroup), sNodeID, pNodeID, oNodeID, TripleHash, max(Weight), max(cast(oObjectType as tinyint)), min(SortOrder), min(Graph)
			from #TripleCompact
			where status = 1
			group by sNodeID, pNodeID, oNodeID, TripleHash
	select @NewTriples = @NewTriples + @@ROWCOUNT

	insert into #Debug (x,d) select '5.2.1',GetDate()

	update t
		set t.TripleID = v.TripleID, t.status = 2
		from #TripleCompact t, [RDF.].Triple v
		where t.status = 1 and t.TripleHash = v.TripleHash


	--*******************************************************************************************
	--*******************************************************************************************
	-- 6. Update node attributes
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select '6',GetDate()
 
	create table #nAttributes (
		NodeID bigint primary key,
		ViewSecurityGroup bigint,
		EditSecurityGroup bigint,
		ObjectType bit
	)
	insert into #nAttributes (NodeID, ViewSecurityGroup, EditSecurityGroup, ObjectType)
		select NodeID, min(ViewSecurityGroup), min(EditSecurityGroup), max(ObjectType)
		from (
			select	(case when n=0 then sNodeID when n=1 then pNodeID else oNodeID end) NodeID, 
					(case when n=0 then sViewSecurityGroup when n=1 then pViewSecurityGroup else oViewSecurityGroup end) ViewSecurityGroup, 
					(case when n=0 then sEditSecurityGroup when n=1 then pEditSecurityGroup else oEditSecurityGroup end) EditSecurityGroup, 
					(case when n=2 then cast(oObjectType as tinyint) else 0 end) ObjectType
			from #TripleCompact t, [Utility.Math].N n
			where n <= 2
				and ((n=0 and sNodeID is not null) or (n=1 and pNodeID is not null) or (n=2 and oNodeID is not null))
		) t
		group by NodeID
	update n
		set n.ViewSecurityGroup = a.ViewSecurityGroup, n.EditSecurityGroup = a.EditSecurityGroup, n.ObjectType = a.ObjectType
		from [RDF.].Node n, #nAttributes a
		where n.NodeID = a.NodeID
			and (n.ViewSecurityGroup <> a.ViewSecurityGroup OR n.EditSecurityGroup <> a.EditSecurityGroup OR n.ObjectType <> a.ObjectType)
	update t
		set t.ObjectType = a.ObjectType
		from [RDF.].Triple t, #nAttributes a
		where t.Object = a.NodeID 
			and (t.ObjectType <> a.ObjectType)


	--*******************************************************************************************
	--*******************************************************************************************
	-- 7. Save a list of which stage triples were processed
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select '7.1',GetDate()

	insert into [RDF.Stage].[Triple.Map] (StageTripleID, TripleID)
		select StageTripleID, TripleID
			from #TripleCompact
			where status = 2

	insert into #Debug (x,d) select '7.2',GetDate()

	update t
		set t.Status = (case when c.status = 2 then 2 else null end)
		from [rdf.stage].triple t
			INNER JOIN #TripleHash p ON t.StageTripleID = p.StageTripleID
			LEFT OUTER JOIN #TripleCompact c ON t.StageTripleID = c.StageTripleID


	--*******************************************************************************************
	--*******************************************************************************************
	-- Wrap up
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select 'X',GetDate()

	/*
		select q.*, datediff(ms,q.d,r.d)
		from #Debug q, #Debug r
		where q.i = r.i-1
	*/

	if @ShowCounts = 1
	begin
		select @ProcessedRecords = (select count(*) from #TripleCompact where status = 2)
		select @NewNodes NewNodes, @NewTriples NewTriples, @FoundRecords FoundRecords, @ProcessedRecords RecordsProcessed
	end

	IF @IsRunningInLoop = 0
	BEGIN
		-- Turn on real-time indexing
		ALTER FULLTEXT INDEX ON [RDF.].Node SET CHANGE_TRACKING AUTO;
	 
		-- Kick off population FT Catalog and index
		ALTER FULLTEXT INDEX ON [RDF.].Node START FULL POPULATION 
	END
	 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.Stage].[ProcessDataMap]
	@DataMapID INT = NULL,
	@DataMapGroupMin INT = NULL,
	@DataMapGroupMax INT = NULL,
	@AutoFeedOnly BIT = 1,
	@InternalIdIn NVARCHAR(MAX) = NULL,
	@ShowCounts BIT = 0,
	@SaveLog BIT = 1,
	@TurnOffIndexing BIT = 1
AS
 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--*******************************************************************************************
	--*******************************************************************************************
	-- Create a queue of DataMap items to process
	--*******************************************************************************************
	--*******************************************************************************************

	CREATE TABLE #Queue(DataMapID  INT )
	IF @DataMapID IS NULL
	BEGIN
		INSERT INTO #Queue
		SELECT DataMapID			
			FROM [Ontology.].DataMap
			WHERE DataMapGroup >= IsNull(@DataMapGroupMin,DataMapGroup)
				AND DataMapGroup <= IsNull(@DataMapGroupMax,DataMapGroup)
				AND (@AutoFeedOnly = 0 OR IsAutoFeed = 1)
			ORDER BY DataMapID
	END 
	ELSE 
	BEGIN
		INSERT INTO #Queue
		SELECT @DataMapID  
	END

	--*******************************************************************************************
	--*******************************************************************************************
	-- Loop through each DataMap item in the queue
	--*******************************************************************************************
	--*******************************************************************************************

	-- Turn off real-time indexing
	IF @TurnOffIndexing = 1
		ALTER FULLTEXT INDEX ON [RDF.].Node SET CHANGE_TRACKING OFF 

	-- Do the loop	
	WHILE (SELECT COUNT(*) FROM #Queue) > 0
	BEGIN
		
		SELECT @DataMapID = (SELECT TOP 1 DataMapID FROM #Queue)
		
		DECLARE @StartDate DATETIME
		SELECT @StartDate = GetDate()

		DECLARE @NewNodes BIGINT
		DECLARE @UpdatedNodes BIGINT
		DECLARE @ExistingNodes BIGINT
		DECLARE @DeletedNodes BIGINT
		DECLARE @TotalNodes BIGINT
		DECLARE @NewTriples BIGINT
		DECLARE @UpdatedTriples BIGINT
		DECLARE @ExistingTriples BIGINT
		DECLARE @DeletedTriples BIGINT
		DECLARE @TotalTriples BIGINT

		SELECT	@NewNodes=0, @UpdatedNodes=0, @ExistingNodes=0, @DeletedNodes=0, @TotalNodes=0,
				@NewTriples=0, @UpdatedTriples=0, @ExistingTriples=0, @DeletedTriples=0, @TotalTriples=0

		DECLARE @s nvarchar(max)

		DECLARE @baseURI NVARCHAR(400)
		SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

		-- Determine the DataMapType and validate the record
		DECLARE @DataMapType INT
		SELECT @DataMapType = (CASE	WHEN (MapTable IS NULL) OR (Class IS NULL) OR (sInternalType IS NULL) OR (sInternalID IS NULL) THEN NULL
									WHEN Property IS NULL THEN 1
									WHEN (NetworkProperty IS NULL) 
											AND (oClass IS NOT NULL) AND (oInternalID IS NOT NULL) AND (oInternalID IS NOT NULL) THEN 2
									WHEN (NetworkProperty IS NULL) 
											AND (oValue IS NOT NULL) THEN 3
									WHEN (NetworkProperty IS NOT NULL) 
											AND (cInternalID IS NOT NULL) AND (cInternalID IS NOT NULL) AND (cInternalID IS NOT NULL) 
											AND (oClass IS NOT NULL) AND (oInternalID IS NOT NULL) AND (oInternalID IS NOT NULL) THEN 4
									WHEN (NetworkProperty IS NOT NULL) 
											AND (cInternalID IS NOT NULL) AND (cInternalID IS NOT NULL) AND (cInternalID IS NOT NULL) 
											AND (oValue IS NOT NULL) THEN 5
									ELSE NULL END)
			FROM [Ontology.].DataMap
			WHERE DataMapID = @DataMapID


		--*******************************************************************************************
		--*******************************************************************************************
		-- DataMapType = 1 (Nodes)
		--*******************************************************************************************
		--*******************************************************************************************

		IF @DataMapType = 1
		BEGIN

			SELECT @s = ''
					+'SELECT Class, InternalType, InternalID, '
					+'		coalesce(max(case when ViewSecurityGroup < 0 then ViewSecurityGroup else null end),max(ViewSecurityGroup),-1) ViewSecurityGroup, '
					+'		coalesce(max(case when EditSecurityGroup < 0 then EditSecurityGroup else null end),max(EditSecurityGroup),-40) EditSecurityGroup, '
					+'		NULL InternalHash '
					--+'		HASHBYTES(''sha1'',N''"''+CAST(replace(Class+N''^^''+InternalType+N''^^''+InternalID,N''"'',N''\"'') AS NVARCHAR(MAX))+N''"'') InternalHash '
					+'	FROM ('
					+'		SELECT '
					+'			'''+replace(Class,'''','')+''' Class,'
					+'			'''+replace(sInternalType,'''','')+''' InternalType,'
					+'			CAST('+sInternalID+' AS NVARCHAR(300)) InternalID,'
					+'			'+IsNull(ViewSecurityGroup,'NULL')+' ViewSecurityGroup,'
					+'			'+IsNull(EditSecurityGroup,'NULL')+' EditSecurityGroup'
					+'		FROM '+MapTable
					+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'WHERE '+sInternalID+' IN ('+@InternalIdIn+')' ELSE '' END)
					+'	) t'
					+'	WHERE Class IS NOT NULL AND InternalType IS NOT NULL AND InternalID IS NOT NULL '
					+'	GROUP BY Class, InternalType, InternalID '
				FROM [Ontology.].DataMap
				WHERE DataMapID = @DataMapID

			-- Get the nodes
			CREATE TABLE #Node (
				Class nvarchar(400),
				InternalType nvarchar(300),
				InternalID nvarchar(100),
				ViewSecurityGroup bigint,
				EditSecurityGroup bigint,
				InternalHash binary(20)
			)
			INSERT INTO #Node (Class, InternalType, InternalID, ViewSecurityGroup, EditSecurityGroup, InternalHash)
				EXEC sp_executesql @s
			SELECT @TotalNodes = @@ROWCOUNT

			CREATE NONCLUSTERED INDEX idx_ClassTypeID on #Node(Class,InternalType,InternalID)

			-- Update security groups of deleted nodes
			IF @InternalIdIn IS NULL
			BEGIN
				UPDATE n
					SET	n.ViewSecurityGroup = 0,
						n.EditSecurityGroup = -50
					FROM [RDF.Stage].InternalNodeMap m 
						INNER JOIN [Ontology.].DataMap o ON m.Class = o.Class AND m.InternalType = o.sInternalType and o.DataMapID = @DataMapID
						INNER JOIN [RDF.].Node n ON m.NodeID = n.NodeID
						LEFT OUTER JOIN #Node x ON m.Class = x.Class AND m.InternalType = x.InternalType and m.InternalID = x.InternalID
					WHERE x.Class IS NULL
			END
			SELECT @DeletedNodes = @@ROWCOUNT

			-- Update security groups of existing nodes if needed
			UPDATE n
				SET	n.ViewSecurityGroup = IsNull(x.ViewSecurityGroup,n.ViewSecurityGroup),
					n.EditSecurityGroup = IsNull(x.EditSecurityGroup,n.EditSecurityGroup)
				FROM [RDF.Stage].InternalNodeMap m 
					INNER JOIN #Node x ON m.Class = x.Class AND m.InternalType = x.InternalType and m.InternalID = x.InternalID
					INNER JOIN [RDF.].Node n ON m.NodeID = n.NodeID
						AND (n.ViewSecurityGroup <> IsNull(x.ViewSecurityGroup,n.ViewSecurityGroup)
								OR n.EditSecurityGroup <> IsNull(x.EditSecurityGroup,n.EditSecurityGroup))
			SELECT @UpdatedNodes = @@ROWCOUNT

			-- Create new nodes
			INSERT INTO [RDF.Stage].InternalNodeMap (Class, InternalType, InternalID, ViewSecurityGroup, EditSecurityGroup, Status, InternalHash)
				SELECT Class, InternalType, InternalID, IsNull(ViewSecurityGroup,-1), IsNull(EditSecurityGroup,-40), 0 Status,
						HASHBYTES('sha1',N'"'+CAST(replace(Class+N'^^'+InternalType+N'^^'+InternalID,N'"',N'\"') AS NVARCHAR(4000))+N'"') InternalHash
					FROM #Node x
					WHERE NOT EXISTS (
						SELECT *
						FROM [RDF.Stage].InternalNodeMap m
						WHERE m.Class = x.Class AND m.InternalType = x.InternalType and m.InternalID = x.InternalID
					)
			INSERT INTO [RDF.].Node (ValueHash, Language, DataType, Value, InternalNodeMapID, ObjectType, ViewSecurityGroup, EditSecurityGroup)
				SELECT InternalHash, NULL, NULL, Class+N'^^'+InternalType+N'^^'+InternalID, InternalNodeMapID, 0, ViewSecurityGroup, EditSecurityGroup
					FROM [RDF.Stage].InternalNodeMap
					WHERE Status = 0
			UPDATE m
				SET	m.NodeID = n.NodeID, 
					m.ValueHash = HASHBYTES('sha1',N'"'+@baseURI+CAST(n.NodeID AS NVARCHAR(50))+N'"')
				FROM [RDF.Stage].InternalNodeMap m, [RDF.].Node n
				WHERE m.Status = 0 AND m.InternalHash = n.ValueHash
			UPDATE n
				SET n.ValueHash = m.ValueHash, n.Value = @baseURI+CAST(n.NodeID AS NVARCHAR(50))
				FROM [RDF.Stage].InternalNodeMap m, [RDF.].Node n
				WHERE m.Status = 0 AND m.NodeID = n.NodeID
			UPDATE [RDF.Stage].InternalNodeMap
				SET ViewSecurityGroup = NULL, EditSecurityGroup = NULL, Status = 3
				WHERE Status = 0
			SELECT @NewNodes = @@ROWCOUNT
			
			SELECT @ExistingNodes = @TotalNodes - @NewNodes

			DROP TABLE #Node

		END

		--*******************************************************************************************
		--*******************************************************************************************
		-- DataMapType IN (2,3,4,5) (Triples)
		--*******************************************************************************************
		--*******************************************************************************************

		IF @DataMapType IN (2,3,4,5)
		BEGIN
			CREATE TABLE #Triple (
				Subject bigint,
				Predicate bigint,
				Object bigint,
				TripleID bigint,
				Language nvarchar(255),
				DataType nvarchar(255),
				Value nvarchar(max),
				ValueHash binary(20),
				Weight float,
				SortOrder int,
				ObjectType bit,
				ViewSecurityGroup bigint,
				EditSecurityGroup bigint,
				ReitificationTripleID bigint,
				Reitification bigint,
				TripleHash binary(20),
				Graph bigint,
				Status tinyint
			)
			CREATE NONCLUSTERED INDEX idx_status on #Triple(Status)

			/*
			Statuses:
			0 - Update triple
			1 - Delete triple
			2 - New triple from entity
			3 - New triple from value
			4 - New triple from reitification and entity
			5 - New triple from reitification and value
			*/		

			DECLARE @ObjectType BIT
			DECLARE @PropertyNode BIGINT
			SELECT @ObjectType = oObjectType, @PropertyNode = _PropertyNode
				FROM [Ontology.].DataMap
				WHERE DataMapID = @DataMapID
		
			SELECT @s = '
						SELECT 
							'''+replace(Class,'''','')+''' sClass,
							'''+replace(sInternalType,'''','')+''' sInternalType,
							CAST('+sInternalID+' AS NVARCHAR(300)) sInternalID,
							'+IsNull(cast(_NetworkPropertyNode as nvarchar(50)),'NULL')+' NetworkPredicate,
							'+cast(_PropertyNode as nvarchar(50))+' predicate,
							'+IsNull(''''+replace(cClass,'''','')+'''','NULL')+' cClass,
							'+IsNull(''''+replace(cInternalType,'''','')+'''','NULL')+' cInternalType,
							CAST('+IsNull(cInternalID,'NULL')+' AS NVARCHAR(300)) cInternalID,
							'+IsNull(''''+replace(oClass,'''','')+'''','NULL')+' oClass,
							'+IsNull(''''+replace(oInternalType,'''','')+'''','NULL')+' oInternalType,
							CAST('+IsNull(oInternalID,'NULL')+' AS NVARCHAR(300)) oInternalID,
							CAST('+IsNull(''''+replace(oLanguage,'''','')+'''','NULL')+' AS NVARCHAR(255)) Language,
							CAST('+IsNull(''''+replace(oDataType,'''','')+'''','NULL')+' AS NVARCHAR(255)) DataType,
							CAST('+IsNull(oValue,'NULL')+' AS NVARCHAR(MAX)) Value,
							'+IsNull(ViewSecurityGroup,'NULL')+' ViewSecurityGroup,
							'+IsNull(EditSecurityGroup,'NULL')+' EditSecurityGroup,
							IsNull('+IsNull(Weight,1)+',1) Weight,
							'+IsNull(cast(Graph as varchar(50)),'NULL')+' Graph,
							'+(CASE WHEN @DataMapType IN (3,5) THEN 'HASHBYTES(''sha1'',CONVERT(nvarchar(4000),N''"''+replace(isnull(CAST('+IsNull(oValue,'NULL')+' AS NVARCHAR(MAX)),N''''),N''"'',N''\"'')+''"''+IsNull(N''"@''+replace(CAST('+IsNull(''''+replace(oLanguage,'''','')+'''','NULL')+' AS NVARCHAR(255)),N''@'',N''''),N'''')+IsNull(N''"^^''+replace(CAST('+IsNull(''''+replace(oDataType,'''','')+'''','NULL')+' AS NVARCHAR(255)),N''^'',N''''),N''''))) ValueHash, ' ELSE '' END)+'
							ROW_NUMBER() OVER (PARTITION BY '+sInternalID+'
								ORDER BY '+IsNull(OrderBy+',','')+coalesce(oInternalID+',','IsNull('+oValue+',NULL),','')+sInternalID+IsNull(','+cInternalID,'')+') SortOrder
						FROM '+MapTable
						+(CASE	WHEN @InternalIdIn IS NOT NULL AND @DataMapType IN (3,5) 
									THEN ' WHERE ('+sInternalID+' IN ('+@InternalIdIn+')) AND (IsNull(CAST('+IsNull(oValue,'NULL')+' AS NVARCHAR(MAX)),'''') <> '''') ' 
								WHEN @InternalIdIn IS NOT NULL
									THEN ' WHERE '+sInternalID+' IN ('+@InternalIdIn+')'
								WHEN @DataMapType IN (3,5)
									THEN ' WHERE IsNull(CAST('+IsNull(oValue,'NULL')+' AS NVARCHAR(MAX)),'''') <> '''' '
								ELSE '' 
							END)
				FROM [Ontology.].DataMap
				WHERE DataMapID = @DataMapID


			IF @DataMapType = 200
				SELECT @s = '
					CREATE TABLE #Temp (
											sClass NVARCHAR(400),
											sInternalType NVARCHAR(300),
											sInternalID NVARCHAR(100),
											NetworkPredicate BIGINT,
											predicate BIGINT,
											cClass NVARCHAR(400),
											cInternalType NVARCHAR(300),
											cInternalID NVARCHAR(100),
											oClass NVARCHAR(400),
											oInternalType NVARCHAR(300),
											oInternalID NVARCHAR(100),
											Language NVARCHAR(255),
											DataType NVARCHAR(255),
											Value NVARCHAR(MAX),
											ViewSecurityGroup BIGINT,
											EditSecurityGroup BIGINT,
											Weight FLOAT,
											Graph BIGINT, 
											SortOrder INT
										)
					INSERT INTO #Temp
						' + @s + ' ;
					'+(CASE WHEN @InternalIdIn IS NOT NULL THEN '
					CREATE TABLE #Temp2 (NodeID BIGINT Primary Key)
					INSERT INTO #Temp2
						SELECT NodeID
							FROM [RDF.Stage].InternalNodeMap s
							WHERE s.Class='''+Class+''' AND s.InternalType='''+sInternalType+''' AND s.NodeID IS NOT NULL
								AND s.InternalID IN ('+@InternalIdIn+')
					' ELSE '' END)+'
					;WITH a AS (
						SELECT s.NodeID Subject, x.Predicate, o.NodeID Object, x.Weight, x.SortOrder, 
								IsNull(p.ViewSecurityGroup,x.ViewSecurityGroup) ViewSecurityGroup, x.Graph
						FROM #Temp x
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=x.sClass AND s.InternalType=x.sInternalType AND s.InternalID=x.sInternalID AND s.NodeID IS NOT NULL
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class=x.oClass AND o.InternalType=x.oInternalType AND o.InternalID=x.oInternalID AND o.NodeID IS NOT NULL
							LEFT OUTER JOIN [RDF.Security].NodeProperty p
								ON p.NodeID = s.NodeID AND p.Property = '+CAST(@PropertyNode as varchar(50))+'
					), b AS (
						SELECT t.*
						FROM '+(CASE WHEN @InternalIdIn IS NOT NULL THEN '#Temp2' ELSE '[RDF.Stage].InternalNodeMap' END)+' s
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class='''+oClass+''' AND o.InternalType='''+oInternalType+''' AND o.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = '+cast(_PropertyNode as varchar(50))+' AND t.Object = o.NodeID
						'+(CASE WHEN @InternalIdIn IS NOT NULL THEN '' ELSE 'WHERE s.Class='''+Class+''' AND s.InternalType='''+sInternalType+''' AND s.NodeID IS NOT NULL' END)+'
					)
					SELECT a.Subject, a.Predicate, a.Object, b.TripleID, 
							null Language, null DataType, null Value, null ValueHash,
							a.Weight, a.SortOrder, 0 ObjectType, a.ViewSecurityGroup, null EditSecurityGroup,
							null ReitificationTripleID, b.Reitification, b.TripleHash, a.Graph,
							(CASE	WHEN b.TripleID IS NULL THEN 2 
									WHEN a.Subject IS NULL THEN 1 
									ELSE 0 END) Status
						FROM a FULL OUTER JOIN b
								ON a.Subject = b.Subject AND a.Object = b.Object
						WHERE	a.Subject IS NULL
								OR b.TripleID IS NULL
								OR a.Weight <> b.Weight
								OR a.SortOrder <> b.SortOrder
								OR a.ViewSecurityGroup <> b.ViewSecurityGroup
					UNION ALL
					SELECT COUNT(*),NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,100 FROM #Temp
					'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'OPTION (FORCE ORDER)' ELSE '' END)	 
				FROM [Ontology.].DataMap
				WHERE DataMapID = @DataMapID



	 
			IF @DataMapType = 2
				SELECT @s = '
					CREATE TABLE #Temp (
											sClass NVARCHAR(400),
											sInternalType NVARCHAR(300),
											sInternalID NVARCHAR(100),
											NetworkPredicate BIGINT,
											predicate BIGINT,
											cClass NVARCHAR(400),
											cInternalType NVARCHAR(300),
											cInternalID NVARCHAR(100),
											oClass NVARCHAR(400),
											oInternalType NVARCHAR(300),
											oInternalID NVARCHAR(100),
											Language NVARCHAR(255),
											DataType NVARCHAR(255),
											Value NVARCHAR(MAX),
											ViewSecurityGroup BIGINT,
											EditSecurityGroup BIGINT,
											Weight FLOAT,
											Graph BIGINT, 
											SortOrder INT
										)
					INSERT INTO #Temp
						' + @s + ' ;
					;WITH a AS (
						SELECT s.NodeID Subject, x.Predicate, o.NodeID Object, x.Weight, x.SortOrder, 
								IsNull(p.ViewSecurityGroup,x.ViewSecurityGroup) ViewSecurityGroup, x.Graph
						FROM #Temp x
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=x.sClass AND s.InternalType=x.sInternalType AND s.InternalID=x.sInternalID AND s.NodeID IS NOT NULL
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class=x.oClass AND o.InternalType=x.oInternalType AND o.InternalID=x.oInternalID AND o.NodeID IS NOT NULL
							LEFT OUTER JOIN [RDF.Security].NodeProperty p
								ON p.NodeID = s.NodeID AND p.Property = '+CAST(@PropertyNode as varchar(50))+'
					), b AS (
						SELECT t.*
						FROM [RDF.Stage].InternalNodeMap s
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class='''+oClass+''' AND o.InternalType='''+oInternalType+''' AND o.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = '+cast(_PropertyNode as varchar(50))+' AND t.Object = o.NodeID
						WHERE s.Class='''+Class+''' AND s.InternalType='''+sInternalType+''' AND s.NodeID IS NOT NULL
							'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'
					)
					SELECT a.Subject, a.Predicate, a.Object, b.TripleID, 
							null Language, null DataType, null Value, null ValueHash,
							a.Weight, a.SortOrder, 0 ObjectType, a.ViewSecurityGroup, null EditSecurityGroup,
							null ReitificationTripleID, b.Reitification, b.TripleHash, a.Graph,
							(CASE	WHEN b.TripleID IS NULL THEN 2 
									WHEN a.Subject IS NULL THEN 1 
									ELSE 0 END) Status
						FROM a FULL OUTER JOIN b
								ON a.Subject = b.Subject AND a.Object = b.Object
						WHERE	a.Subject IS NULL
								OR b.TripleID IS NULL
								OR a.Weight <> b.Weight
								OR a.SortOrder <> b.SortOrder
								OR a.ViewSecurityGroup <> b.ViewSecurityGroup
					UNION ALL
					SELECT COUNT(*),NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,100 FROM #Temp
					'	 
				FROM [Ontology.].DataMap
				WHERE DataMapID = @DataMapID

/*
						SELECT t.*
						FROM [Ontology.].DataMap m
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=m.Class AND s.InternalType=m.sInternalType AND s.NodeID IS NOT NULL
									'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class=m.oClass AND o.InternalType=m.oInternalType AND o.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = m._PropertyNode AND t.Object = o.NodeID
						WHERE m.DataMapID = '+CAST(@DataMapID as varchar(50))+'
*/
	  
			IF @DataMapType = 3
				SELECT @s = '
					CREATE TABLE #Temp (
											sClass NVARCHAR(400),
											sInternalType NVARCHAR(300),
											sInternalID NVARCHAR(100),
											NetworkPredicate BIGINT,
											predicate BIGINT,
											cClass NVARCHAR(400),
											cInternalType NVARCHAR(300),
											cInternalID NVARCHAR(100),
											oClass NVARCHAR(400),
											oInternalType NVARCHAR(300),
											oInternalID NVARCHAR(100),
											Language NVARCHAR(255),
											DataType NVARCHAR(255),
											Value NVARCHAR(MAX),
											ViewSecurityGroup BIGINT,
											EditSecurityGroup BIGINT,
											Weight FLOAT,
											Graph BIGINT, 
											ValueHash BINARY(20), 
											SortOrder INT
										)
					INSERT INTO #Temp 
						' + @s + ';
					;WITH a AS (
						SELECT s.NodeID Subject, x.Predicate, o.NodeID Object, x.Weight, x.SortOrder, 
								IsNull(p.ViewSecurityGroup,x.ViewSecurityGroup) ViewSecurityGroup, x.Graph,
								x.Value, x.Language, x.DataType, x.ValueHash, x.EditSecurityGroup
						FROM #Temp x
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=x.sClass AND s.InternalType=x.sInternalType AND s.InternalID=x.sInternalID AND s.NodeID IS NOT NULL
							LEFT OUTER JOIN [RDF.].Node o
								ON o.ValueHash=x.ValueHash
							LEFT OUTER JOIN [RDF.Security].NodeProperty p
								ON p.NodeID = s.NodeID AND p.Property = '+CAST(@PropertyNode as varchar(50))+'
					), b AS (
						SELECT t.*
						FROM [Ontology.].DataMap m
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class='''+Class+''' AND s.InternalType='''+sInternalType+''' AND s.NodeID IS NOT NULL
									'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = m._PropertyNode AND t.ObjectType = '+CAST(@ObjectType as varchar(50))+'
						WHERE m.DataMapID = '+CAST(@DataMapID as varchar(50))+'
					)
					SELECT a.Subject, a.Predicate, a.Object, b.TripleID, 
							a.Language, a.DataType, a.Value, a.ValueHash,
							a.Weight, a.SortOrder, '+CAST(@ObjectType as varchar(50))+' ObjectType, a.ViewSecurityGroup, a.EditSecurityGroup,
							null ReitificationTripleID, b.Reitification, b.TripleHash, a.Graph,
							(CASE	WHEN b.TripleID IS NULL AND a.Object IS NULL THEN 3 
									WHEN b.TripleID IS NULL THEN 2 
									WHEN a.Subject IS NULL THEN 1
									ELSE 0 END) Status
						FROM a FULL OUTER JOIN b
								ON a.Subject = b.Subject AND a.Object = b.Object AND a.Object IS NOT NULL
						WHERE	a.Subject IS NULL
								OR b.TripleID IS NULL
								OR a.Weight <> b.Weight
								OR a.SortOrder <> b.SortOrder
								OR a.ViewSecurityGroup <> b.ViewSecurityGroup
					UNION ALL
					SELECT COUNT(*),NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,100 FROM #Temp
					'
				FROM [Ontology.].DataMap
				WHERE DataMapID = @DataMapID

/*
						SELECT t.*
						FROM [Ontology.].DataMap m
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=m.Class AND s.InternalType=m.sInternalType AND s.NodeID IS NOT NULL
									'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = m._PropertyNode AND t.ObjectType = '+CAST(@ObjectType as varchar(50))+'
						WHERE m.DataMapID = '+CAST(@DataMapID as varchar(50))+'

						SELECT t.*
						FROM [RDF.Stage].InternalNodeMap s
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = '+cast(_PropertyNode as varchar(50))+' AND t.ObjectType = '+CAST(@ObjectType as varchar(50))+'
						WHERE s.Class='''+Class+''' AND s.InternalType='''+sInternalType+''' AND s.NodeID IS NOT NULL
							'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'

*/
				 
			IF @DataMapType = 4
				SELECT @s = '
					WITH x AS (
						'+@s+'
					), a AS (
						SELECT t.Reitification Subject, x.Predicate, o.NodeID Object, x.Weight, x.SortOrder, 
								x.ViewSecurityGroup, x.Graph,
								x.NetworkPredicate, t.TripleID, v.TripleID ExistingTripleID
						FROM x
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=x.sClass AND s.InternalType=x.sInternalType AND s.InternalID=x.sInternalID AND s.NodeID IS NOT NULL
							INNER JOIN [RDF.Stage].InternalNodeMap c
								ON c.Class=x.cClass AND c.InternalType=x.cInternalType AND c.InternalID=x.cInternalID AND c.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = x.NetworkPredicate AND t.Object = c.NodeID
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class=x.oClass AND o.InternalType=x.oInternalType AND o.InternalID=x.oInternalID AND o.NodeID IS NOT NULL
							LEFT OUTER JOIN [RDF.].Triple v
								ON v.Subject = t.Reitification AND v.Predicate = x.Predicate AND v.Object = o.NodeID
									AND t.Reitification IS NOT NULL AND o.NodeID IS NOT NULL
					), b AS (
						SELECT v.*
						FROM [Ontology.].DataMap m
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=m.Class AND s.InternalType=m.sInternalType AND s.NodeID IS NOT NULL
									'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'
							INNER JOIN [RDF.Stage].InternalNodeMap c
								ON c.Class=m.cClass AND c.InternalType=m.cInternalType AND c.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = m._NetworkPropertyNode AND t.Object = c.NodeID AND t.Reitification IS NOT NULL
							INNER JOIN [RDF.Stage].InternalNodeMap o
								ON o.Class=m.oClass AND o.InternalType=m.oInternalType AND o.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple v
								ON v.Subject = t.Reitification AND v.Predicate = m._PropertyNode AND v.Object = o.NodeID
						WHERE m.DataMapID = '+CAST(@DataMapID as varchar(50))+'
					)
					SELECT a.Subject, a.Predicate, a.Object, b.TripleID, 
							null Language, null DataType, null Value, null ValueHash,
							a.Weight, a.SortOrder, 0 ObjectType, a.ViewSecurityGroup, null EditSecurityGroup,
							a.TripleID ReitificationTripleID, b.Reitification, b.TripleHash, a.Graph,
							(CASE	WHEN (b.TripleID IS NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NOT NULL) AND (a.ExistingTripleID IS NULL) AND (a.Subject IS NULL) THEN 4
									WHEN (b.TripleID IS NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NOT NULL) AND (a.ExistingTripleID IS NULL) AND (a.Subject IS NOT NULL) THEN 2
									WHEN (b.TripleID IS NOT NULL) AND ((a.TripleID IS NULL) OR (a.Object IS NULL)) THEN 1
									WHEN (b.TripleID IS NOT NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NOT NULL) AND (a.ExistingTripleID IS NOT NULL) THEN 0
									ELSE -1 END) Status
						FROM a FULL OUTER JOIN b
								ON a.Subject = b.Subject AND a.Object = b.Object
						WHERE	b.TripleID IS NULL
								OR a.TripleID IS NULL
								OR a.Object IS NULL
								OR a.Subject IS NULL
								OR a.ExistingTripleID IS NULL
								OR a.Weight <> b.Weight
								OR a.SortOrder <> b.SortOrder
								OR a.ViewSecurityGroup <> b.ViewSecurityGroup
					UNION ALL
					SELECT COUNT(*),NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,100 FROM x
					'

			IF @DataMapType = 5
				SELECT @s = ' CREATE TABLE #Temp (
											sClass NVARCHAR(400),
											sInternalType NVARCHAR(300),
											sInternalID NVARCHAR(100),
											NetworkPredicate BIGINT,
											predicate BIGINT,
											cClass NVARCHAR(400),
											cInternalType NVARCHAR(300),
											cInternalID NVARCHAR(100),
											oClass NVARCHAR(400),
											oInternalType NVARCHAR(300),
											oInternalID NVARCHAR(100),
											Language NVARCHAR(255),
											DataType NVARCHAR(255),
											Value NVARCHAR(MAX),
											ViewSecurityGroup BIGINT,
											EditSecurityGroup BIGINT,
											Weight FLOAT,
											Graph BIGINT, 
											ValueHash BINARY(20), 
											SortOrder INT
										)
					INSERT INTO #Temp 
						' + @s + ';
					 
						SELECT t.Reitification Subject, x.Predicate, o.NodeID Object, x.Weight, x.SortOrder, 
								x.ViewSecurityGroup, x.Graph,
								x.NetworkPredicate, t.TripleID, v.TripleID ExistingTripleID,
								x.Value, x.Language, x.DataType, x.ValueHash, x.EditSecurityGroup
						into #a
						FROM #Temp x
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=x.sClass AND s.InternalType=x.sInternalType AND s.InternalID=x.sInternalID AND s.NodeID IS NOT NULL
							INNER JOIN [RDF.Stage].InternalNodeMap c
								ON c.Class=x.cClass AND c.InternalType=x.cInternalType AND c.InternalID=x.cInternalID AND c.NodeID IS NOT NULL
							INNER hash JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = x.NetworkPredicate AND t.Object = c.NodeID
							LEFT OUTER JOIN [RDF.].Node o
								ON o.ValueHash=x.ValueHash
							LEFT OUTER JOIN [RDF.].Triple v
								ON v.Subject = t.Reitification AND v.Predicate = x.Predicate AND v.Object = o.NodeID
									AND t.Reitification IS NOT NULL AND o.NodeID IS NOT NULL
					 
						SELECT v.* INTO #b
						FROM [Ontology.].DataMap m
							INNER JOIN [RDF.Stage].InternalNodeMap s
								ON s.Class=m.Class AND s.InternalType=m.sInternalType AND s.NodeID IS NOT NULL
									'+(CASE WHEN @InternalIdIn IS NOT NULL THEN 'AND s.InternalID IN ('+@InternalIdIn+')' ELSE '' END)+'
							INNER JOIN [RDF.Stage].InternalNodeMap c
								ON c.Class=m.cClass AND c.InternalType=m.cInternalType AND c.NodeID IS NOT NULL
							INNER JOIN [RDF.].Triple t
								ON t.Subject = s.NodeID AND t.Predicate = m._NetworkPropertyNode AND t.Object = c.NodeID AND t.Reitification IS NOT NULL
							INNER JOIN [RDF.].Triple v
								ON v.Subject = t.Reitification AND v.Predicate = m._PropertyNode AND v.ObjectType = '+CAST(@ObjectType as varchar(50))+'
						WHERE m.DataMapID = '+CAST(@DataMapID as varchar(50))+'
					 
					SELECT a.Subject, a.Predicate, a.Object, b.TripleID, 
							a.Language, a.DataType, a.Value, a.ValueHash,
							a.Weight, a.SortOrder, '+CAST(@ObjectType as varchar(50))+' ObjectType, a.ViewSecurityGroup, a.EditSecurityGroup,
							a.TripleID ReitificationTripleID, b.Reitification, b.TripleHash, a.Graph,
							(CASE	WHEN (b.TripleID IS NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NULL) AND (a.ExistingTripleID IS NULL) AND (a.Subject IS NULL) THEN 5
									WHEN (b.TripleID IS NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NOT NULL) AND (a.ExistingTripleID IS NULL) AND (a.Subject IS NULL) THEN 4
									WHEN (b.TripleID IS NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NULL) AND (a.ExistingTripleID IS NULL) AND (a.Subject IS NOT NULL) THEN 3
									WHEN (b.TripleID IS NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NOT NULL) AND (a.ExistingTripleID IS NULL) AND (a.Subject IS NOT NULL) THEN 2
									WHEN (b.TripleID IS NOT NULL) AND (a.TripleID IS NULL) THEN 1
									WHEN (b.TripleID IS NOT NULL) AND (a.TripleID IS NOT NULL) AND (a.Object IS NOT NULL) AND (a.ExistingTripleID IS NOT NULL) THEN 0
									ELSE -1 END) Status
						FROM #a a FULL OUTER JOIN #b b
								ON a.Subject = b.Subject AND a.Object = b.Object AND a.Object IS NOT NULL
						WHERE	b.TripleID IS NULL
								OR a.TripleID IS NULL
								OR a.Object IS NULL
								OR a.Subject IS NULL
								OR a.ExistingTripleID IS NULL
								OR a.Weight <> b.Weight
								OR a.SortOrder <> b.SortOrder
								OR a.ViewSecurityGroup <> b.ViewSecurityGroup
					UNION ALL
					SELECT COUNT(*),NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,100 FROM #temp x
					'
--print @s return
			--declare @d datetime
			--select @d = getdate()					
			--select @datamapid, replace(@s,char(10),'NEWLINE')
			--return
			--select @DataMapType, @s
			
			INSERT INTO #Triple
				EXEC sp_executesql @s
			--select @datamapid, datediff(ms,@d,getdate()), (select count(*) from #Triple), replace(@s,char(10),'NEWLINE')
			--select * from #Triple
			--retrun
				
			SELECT @TotalTriples = IsNull((SELECT MAX(Subject) FROM #Triple WHERE Status = 100),0)
			
			---------------------------------------------------------------------
			-- Status 0 - Update triple
			---------------------------------------------------------------------
			
			UPDATE t
				SET	t.Weight = IsNull(x.Weight,t.Weight),
					t.SortOrder = IsNull(x.SortOrder,t.SortOrder),
					t.ObjectType = IsNull(x.ObjectType,t.ObjectType)
				FROM [RDF.].Triple t, #Triple x
				WHERE x.Status = 0
					AND t.TripleID = x.TripleID
			SELECT @UpdatedTriples = @@ROWCOUNT

			---------------------------------------------------------------------
			-- Status 1 - Delete triple
			---------------------------------------------------------------------

			CREATE TABLE #DeleteTriples (TripleID BIGINT PRIMARY KEY)
			CREATE TABLE #DeleteNodes (NodeID BIGINT PRIMARY KEY)
			CREATE TABLE #NewDeleteTriples (TripleID BIGINT PRIMARY KEY, Reitification BIGINT)
			CREATE TABLE #NewDeleteNodes (NodeID BIGINT PRIMARY KEY)
			DECLARE @NewDeletedTriples BIGINT
			-- Get triples that should be deleted
			INSERT INTO #NewDeleteTriples (TripleID, Reitification)
				SELECT TripleID, Reitification
					FROM #Triple
					WHERE Status = 1
			SELECT @NewDeletedTriples = @@ROWCOUNT
			WHILE @NewDeletedTriples > 0
			BEGIN
				-- Get reitification nodes
				INSERT INTO #DeleteNodes(NodeID)
					SELECT NodeID FROM #NewDeleteNodes
				TRUNCATE TABLE #NewDeleteNodes
				INSERT INTO #NewDeleteNodes (NodeID)
					SELECT DISTINCT Reitification 
						FROM #NewDeleteTriples 
						WHERE Reitification IS NOT NULL AND Reitification NOT IN (SELECT NodeID FROM #DeleteNodes)
				-- Get triples using reitification nodes
				INSERT INTO #DeleteTriples (TripleID)
					SELECT TripleID FROM #NewDeleteTriples
				TRUNCATE TABLE #NewDeleteTriples
				INSERT INTO #NewDeleteTriples (TripleID, Reitification)
					SELECT t.TripleID, t.Reitification
						FROM [RDF.].Triple t
						join  #NewDeleteNodes n on t.subject = n.NodeID 
											    or t.predicate = n.NodeID 
											    or t.object = n.NodeID
							where t.TripleID NOT IN (SELECT TripleID FROM #DeleteTriples)
					--SELECT t.TripleID, t.Reitification
					--	FROM [RDF.].Triple t, #NewDeleteNodes n
					--	WHERE t.subject = n.NodeID 
					--	   or t.predicate = n.NodeID 
					--	   or t.object = n.NodeID
					--		AND t.TripleID NOT IN (SELECT TripleID FROM #DeleteTriples)
				SELECT @NewDeletedTriples = @@ROWCOUNT
			END
			-- Delete triples and reitification nodes and triples
			DELETE 
				FROM [RDF.].Triple
				WHERE TripleID IN (SELECT TripleID FROM #DeleteTriples)
			SELECT @DeletedTriples = @@ROWCOUNT
			DELETE 
				FROM [RDF.].Node
				WHERE NodeID IN (SELECT NodeID FROM #DeleteNodes)
			SELECT @DeletedNodes = @@ROWCOUNT


			---------------------------------------------------------------------
			-- Status 4 & 5 - Create new reitifications
			---------------------------------------------------------------------

			UPDATE #Triple
				SET TripleHash = HASHBYTES('sha1',N'"#TRIPLE'+cast(ReitificationTripleID as nvarchar(50))+N'"')
				WHERE Status IN (4,5)
			INSERT INTO [RDF.].Node (ValueHash, Language, DataType, Value, ObjectType, ViewSecurityGroup, EditSecurityGroup)
				SELECT DISTINCT TripleHash, NULL, NULL, '#TRIPLE'+CAST(ReitificationTripleID AS VARCHAR(50)), 0, -1, -50
					FROM #Triple
					WHERE Status IN (4,5)
			SELECT @NewNodes = @NewNodes + @@ROWCOUNT
			UPDATE t
				SET	t.Subject = n.NodeID,
					t.TripleHash = (CASE WHEN t.Object IS NULL THEN t.TripleHash ELSE HASHBYTES('sha1',N'"<#'+convert(nvarchar(4000),n.NodeID)+N'> <#'+convert(nvarchar(4000),t.Predicate)+N'> <#'+convert(nvarchar(max),t.Object)+N'> ."^^http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement') END)
				FROM #Triple t, [RDF.].Node n
				WHERE t.Status IN (4,5) AND t.TripleHash = n.ValueHash
			UPDATE v
				SET v.Reitification = t.Subject
				FROM #Triple t, [RDF.].Triple v
				WHERE t.Status IN (4,5) AND t.ReitificationTripleID = v.TripleID
			UPDATE n
				SET n.Value = @baseURI+cast(n.NodeID as nvarchar(50)),
					n.ValueHash = HASHBYTES('sha1',N'"' + @baseURI + cast(n.NodeID as nvarchar(50)) + N'"')
				FROM #Triple t, [RDF.].Node n
				WHERE t.Status IN (4,5) AND t.Subject = n.NodeID
				
			---------------------------------------------------------------------
			-- Status 3 & 5 - Create new literals
			---------------------------------------------------------------------

			-- Create the new literals
			INSERT INTO [RDF.].Node (ValueHash, Language, DataType, Value, ObjectType, ViewSecurityGroup, EditSecurityGroup)
				SELECT ValueHash, MAX(Language), MAX(DataType), MAX(Value), MAX(ObjectType*1),
						IsNull(Min(ViewSecurityGroup),-1), IsNull(Min(EditSecurityGroup),-40)
					FROM #Triple
					WHERE Status IN (3,5)
					GROUP BY ValueHash
			SELECT @NewNodes = @NewNodes + @@ROWCOUNT
			-- Update #Triple with the NodeID of the new literals
			UPDATE t
				SET t.Object = n.NodeID
				FROM #Triple t, [RDF.].Node n
				WHERE t.Status IN (3,5)
					AND t.ValueHash = n.ValueHash
					
			---------------------------------------------------------------------
			-- Status 2, 3, 4, and 5 - Create new triple
			---------------------------------------------------------------------

			-- Create the new triples
			INSERT INTO [RDF.].Triple (Subject, Predicate, Object, TripleHash, Weight, ObjectType, SortOrder, ViewSecurityGroup, Graph)
				SELECT Subject, Predicate, Object, TripleHash, Max(Weight), Max(cast(ObjectType as Tinyint)), Min(SortOrder), Max(ViewSecurityGroup), Min(Graph)
					FROM (
						SELECT Subject, Predicate, Object,
							HASHBYTES('sha1',N'"<#'+convert(nvarchar(4000),Subject)+N'> <#'+convert(nvarchar(4000),Predicate)+N'> <#'+convert(nvarchar(4000),Object)+N'> ."^^http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement') TripleHash,
							IsNull(Weight,1) Weight, IsNull(ObjectType,1) ObjectType, IsNull(SortOrder,1) SortOrder, IsNull(ViewSecurityGroup,-1) ViewSecurityGroup,
							Graph
						FROM #Triple
						WHERE Status IN (2,3,4,5)
					) t
					GROUP BY Subject, Predicate, Object, TripleHash
			SELECT @NewTriples = @@ROWCOUNT

			DROP TABLE #DeleteTriples 
			DROP TABLE #DeleteNodes 
			DROP TABLE #NewDeleteTriples 
			DROP TABLE #NewDeleteNodes   
			
			DROP TABLE #Triple
			
		END


		--*******************************************************************************************
		--*******************************************************************************************
		-- Save Log
		--*******************************************************************************************
		--*******************************************************************************************

		INSERT INTO [RDF.Stage].[Log.DataMap] (DataMapID, StartDate, EndDate, RunTimeMS, DataMapType,
												NewNodes, UpdatedNodes, ExistingNodes, DeletedNodes, TotalNodes,
												NewTriples, UpdatedTriples, ExistingTriples, DeletedTriples, TotalTriples)
			SELECT	@DataMapID, @StartDate, GetDate(), DateDiff(ms,@StartDate,GetDate()), @DataMapType,
					@NewNodes, @UpdatedNodes, @ExistingNodes, @DeletedNodes, @TotalNodes,
					@NewTriples, @UpdatedTriples, @ExistingTriples, @DeletedTriples, @TotalTriples
				WHERE @SaveLog = 1

		IF @ShowCounts = 1
			SELECT * FROM [RDF.Stage].[Log.DataMap] WHERE LogID = @@IDENTITY

		DELETE FROM #Queue WHERE DataMapID = @DataMapID
			 
	END

	IF @TurnOffIndexing = 1
	BEGIN
		-- Turn on real-time indexing
		ALTER FULLTEXT INDEX ON [RDF.].Node SET CHANGE_TRACKING AUTO;
		-- Kick off population FT Catalog and index
		ALTER FULLTEXT INDEX ON [RDF.].Node START FULL POPULATION 
	END
	
	-- select * from [Ontology.].DataMap

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [Profile.Data].[Person.UpdateUnGeocodedAddress]	 (@latitude VARCHAR(20),
												  @longitude VARCHAR(20),
												  @geoscore VARCHAR(10),
												  @addressstring VARCHAR(2000))
AS
BEGIN
	SET NOCOUNT ON;	

UPDATE [Profile.Data].Person
   SET latitude=@latitude,
	   longitude=@longitude,
	   geoscore=@geoscore
 WHERE addressstring=@addressstring
 

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Framework.].[LoadInstallData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 DECLARE @x XML
 SELECT @x = ( SELECT TOP 1
                        Data
               FROM     [Framework.].[InstallData]
               ORDER BY InstallDataID DESC
             ) 


---------------------------------------------------------------
-- [Framework.]
---------------------------------------------------------------
 
             
-- [Framework.].[Parameter]
TRUNCATE TABLE [Framework.].[Parameter]
INSERT INTO [Framework.].Parameter
	( ParameterID, Value )        
SELECT	R.x.value('ParameterID[1]', 'varchar(max)') ,
		R.x.value('Value[1]', 'varchar(max)')
FROM    ( SELECT
			@x.query
			('Import[1]/Table[@Name=''[Framework.].[Parameter]'']')
			x
		) t
CROSS APPLY x.nodes('//Row') AS R ( x )

  
       
--  [Framework.].[RestPath] 
INSERT INTO [Framework.].RestPath
        ( ApplicationName, Resolver )   
SELECT  R.x.value('ApplicationName[1]', 'varchar(max)') ,
        R.x.value('Resolver[1]', 'varchar(max)') 
FROM    ( SELECT
                    @x.query
                    ('Import[1]/Table[@Name=''[Framework.].[RestPath]'']')
                    x
        ) t
CROSS APPLY x.nodes('//Row') AS R ( x )

   
--[Framework.].[Job]
INSERT INTO [Framework.].Job
        ( JobID,
		  JobGroup ,
          Step ,
          IsActive ,
          Script ,
          Status ,
          LastStart ,
          LastEnd ,
          ErrorCode ,
          ErrorMsg
        ) 
SELECT	R.x.value('JobID[1]','varchar(max)'),
		R.x.value('JobGroup[1]','varchar(max)'),
		R.x.value('Step[1]','varchar(max)'),
		R.x.value('IsActive[1]','varchar(max)'),
		R.x.value('Script[1]','varchar(max)'),
		R.x.value('Status[1]','varchar(max)'),
		R.x.value('LastStart[1]','varchar(max)'),
		R.x.value('LastEnd[1]','varchar(max)'),
		R.x.value('ErrorCode[1]','varchar(max)'),
		R.x.value('ErrorMsg[1]','varchar(max)')
FROM    ( SELECT
                  @x.query
                  ('Import[1]/Table[@Name=''[Framework.].[Job]'']')
                  x
      ) t
CROSS APPLY x.nodes('//Row') AS R ( x )

	
--[Framework.].[JobGroup]
INSERT INTO [Framework.].JobGroup
        ( JobGroup, Name, Type, Description ) 
SELECT	R.x.value('JobGroup[1]','varchar(max)'),
		R.x.value('Name[1]','varchar(max)'),
		R.x.value('Type[1]','varchar(max)'),
		R.x.value('Description[1]','varchar(max)')
FROM    ( SELECT
                  @x.query
                  ('Import[1]/Table[@Name=''[Framework.].[JobGroup]'']')
                  x
      ) t
CROSS APPLY x.nodes('//Row') AS R ( x )
       
  

---------------------------------------------------------------
-- [Ontology.]
---------------------------------------------------------------
 
 --[Ontology.].[ClassGroup]
 TRUNCATE TABLE [Ontology.].[ClassGroup]
 INSERT INTO [Ontology.].ClassGroup
         ( ClassGroupURI ,
           _ClassGroupLabel ,
           SortOrder ,
           _ClassGroupNode ,
           _NumberOfNodes
         )
  SELECT  R.x.value('ClassGroupURI[1]', 'varchar(max)') ,
          R.x.value('_ClassGroupLabel[1]', 'varchar(max)'),
          R.x.value('SortOrder[1]', 'varchar(max)'),
          R.x.value('_ClassGroupNode[1]', 'varchar(max)'),
          R.x.value('_NumberOfNodes[1]', 'varchar(max)')
  FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.].[ClassGroup]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x ) 
 
 --[Ontology.].[ClassGroupClass]
 TRUNCATE TABLE [Ontology.].[ClassGroupClass]
 INSERT INTO [Ontology.].ClassGroupClass
         ( ClassGroupURI ,
           ClassURI ,
           _ClassLabel ,
           SortOrder ,
           _ClassGroupNode ,
           _ClassNode ,
           _NumberOfNodes
         )
  SELECT  R.x.value('ClassGroupURI[1]', 'varchar(max)') ,
          R.x.value('ClassURI[1]', 'varchar(max)'),
          R.x.value('_ClassLabel[1]', 'varchar(max)'),
          R.x.value('SortOrder[1]', 'varchar(max)'),
          R.x.value('_ClassGroupNode[1]', 'varchar(max)'),
          R.x.value('_ClassNode[1]', 'varchar(max)'),
          R.x.value('_NumberOfNodes[1]', 'varchar(max)') 
  FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.].[ClassGroupClass]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )

  
--[Ontology.].[ClassProperty]
INSERT INTO [Ontology.].ClassProperty
        ( ClassPropertyID,
          Class ,
          NetworkProperty ,
          Property ,
          IsDetail ,
          Limit ,
          IncludeDescription ,
          IncludeNetwork ,
          SearchWeight ,
          CustomDisplay ,
          CustomEdit ,
          ViewSecurityGroup ,
          EditSecurityGroup ,
          EditPermissionsSecurityGroup ,
          EditExistingSecurityGroup ,
          EditAddNewSecurityGroup ,
          EditAddExistingSecurityGroup ,
          EditDeleteSecurityGroup ,
          MinCardinality ,
          MaxCardinality ,
          CustomDisplayModule ,
          CustomEditModule ,
          [_ClassNode] ,
          [_NetworkPropertyNode] ,
          [_PropertyNode] ,
          [_TagName] ,
          [_PropertyLabel] ,
          [_NumberOfNodes] ,
          [_NumberOfTriples]
        )
SELECT  R.x.value('ClassPropertyID[1]','varchar(max)'),
		R.x.value('Class[1]','varchar(max)'),
		R.x.value('NetworkProperty[1]','varchar(max)'),
		R.x.value('Property[1]','varchar(max)'),
		R.x.value('IsDetail[1]','varchar(max)'),
		R.x.value('Limit[1]','varchar(max)'),
		R.x.value('IncludeDescription[1]','varchar(max)'),
		R.x.value('IncludeNetwork[1]','varchar(max)'),
		R.x.value('SearchWeight[1]','varchar(max)'),
		R.x.value('CustomDisplay[1]','varchar(max)'),
		R.x.value('CustomEdit[1]','varchar(max)'),
		R.x.value('ViewSecurityGroup[1]','varchar(max)'),
		R.x.value('EditSecurityGroup[1]','varchar(max)'),
		R.x.value('EditPermissionsSecurityGroup[1]','varchar(max)'),
		R.x.value('EditExistingSecurityGroup[1]','varchar(max)'),
		R.x.value('EditAddNewSecurityGroup[1]','varchar(max)'),
		R.x.value('EditAddExistingSecurityGroup[1]','varchar(max)'),
		R.x.value('EditDeleteSecurityGroup[1]','varchar(max)'),
		R.x.value('MinCardinality[1]','varchar(max)'),
		R.x.value('MaxCardinality[1]','varchar(max)'),
		(case when CAST(R.x.query('CustomDisplayModule[1]/*') AS NVARCHAR(MAX))<>'' then R.x.query('CustomDisplayModule[1]/*') else NULL end),
		(case when CAST(R.x.query('CustomEditModule[1]/*') AS NVARCHAR(MAX))<>'' then R.x.query('CustomEditModule[1]/*') else NULL end) ,
		R.x.value('_ClassNode[1]','varchar(max)'),
		R.x.value('_NetworkPropertyNode[1]','varchar(max)'),
		R.x.value('_PropertyNode[1]','varchar(max)'),
		R.x.value('_TagName[1]','varchar(max)'),
		R.x.value('_PropertyLabel[1]','varchar(max)'), 
		R.x.value('_NumberOfNodes[1]','varchar(max)'),
		R.x.value('_NumberOfTriples[1]','varchar(max)')
  FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.].[ClassProperty]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )

  
  --[Ontology.].[DataMap]
  TRUNCATE TABLE [Ontology.].DataMap
  INSERT INTO [Ontology.].DataMap
          ( DataMapID,
			DataMapGroup ,
            IsAutoFeed ,
            Graph ,
            Class ,
            NetworkProperty ,
            Property ,
            MapTable ,
            sInternalType ,
            sInternalID ,
            cClass ,
            cInternalType ,
            cInternalID ,
            oClass ,
            oInternalType ,
            oInternalID ,
            oValue ,
            oDataType ,
            oLanguage ,
            oStartDate ,
            oStartDatePrecision ,
            oEndDate ,
            oEndDatePrecision ,
            oObjectType ,
            Weight ,
            OrderBy ,
            ViewSecurityGroup ,
            EditSecurityGroup ,
            [_ClassNode] ,
            [_NetworkPropertyNode] ,
            [_PropertyNode]
          )
  SELECT    R.x.value('DataMapID[1]','varchar(max)'),
			R.x.value('DataMapGroup[1]','varchar(max)'),
			R.x.value('IsAutoFeed[1]','varchar(max)'),
			R.x.value('Graph[1]','varchar(max)'),
			R.x.value('Class[1]','varchar(max)'),
			R.x.value('NetworkProperty[1]','varchar(max)'),
			R.x.value('Property[1]','varchar(max)'),
			R.x.value('MapTable[1]','varchar(max)'),
			R.x.value('sInternalType[1]','varchar(max)'),
			R.x.value('sInternalID[1]','varchar(max)'),
			R.x.value('cClass[1]','varchar(max)'),
			R.x.value('cInternalType[1]','varchar(max)'),
			R.x.value('cInternalID[1]','varchar(max)'),
			R.x.value('oClass[1]','varchar(max)'),
			R.x.value('oInternalType[1]','varchar(max)'),
			R.x.value('oInternalID[1]','varchar(max)'),
			R.x.value('oValue[1]','varchar(max)'),
			R.x.value('oDataType[1]','varchar(max)'),
			R.x.value('oLanguage[1]','varchar(max)'),
			R.x.value('oStartDate[1]','varchar(max)'),
			R.x.value('oStartDatePrecision[1]','varchar(max)'),
			R.x.value('oEndDate[1]','varchar(max)'),
			R.x.value('oEndDatePrecision[1]','varchar(max)'),
			R.x.value('oObjectType[1]','varchar(max)'),
			R.x.value('Weight[1]','varchar(max)'),
			R.x.value('OrderBy[1]','varchar(max)'),
			R.x.value('ViewSecurityGroup[1]','varchar(max)'),
			R.x.value('EditSecurityGroup[1]','varchar(max)'),
			R.x.value('_ClassNode[1]','varchar(max)'),
			R.x.value('_NetworkPropertyNode[1]','varchar(max)'),
			R.x.value('_PropertyNode[1]','varchar(max)')
  FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.].[DataMap]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )
  
  
 -- [Ontology.].[Namespace]
 TRUNCATE TABLE [Ontology.].[Namespace]
 INSERT INTO [Ontology.].[Namespace]
        ( URI ,
          Prefix
        )
  SELECT  R.x.value('URI[1]', 'varchar(max)') ,
          R.x.value('Prefix[1]', 'varchar(max)')
  FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.].[Namespace]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )
  

   --[Ontology.].[PropertyGroup]
   INSERT INTO [Ontology.].PropertyGroup
           ( PropertyGroupURI ,
             SortOrder ,
             [_PropertyGroupLabel] ,
             [_PropertyGroupNode] ,
             [_NumberOfNodes]
           ) 
	SELECT	R.x.value('PropertyGroupURI[1]','varchar(max)'),
			R.x.value('SortOrder[1]','varchar(max)'),
			R.x.value('_PropertyGroupLabel[1]','varchar(max)'), 
			R.x.value('_PropertyGroupNode[1]','varchar(max)'),
			R.x.value('_NumberOfNodes[1]','varchar(max)')
	 FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.].[PropertyGroup]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )
  
  
	--[Ontology.].[PropertyGroupProperty]
	INSERT INTO [Ontology.].PropertyGroupProperty
	        ( PropertyGroupURI ,
	          PropertyURI ,
	          SortOrder ,
	          CustomDisplayModule ,
	          CustomEditModule ,
	          [_PropertyGroupNode] ,
	          [_PropertyNode] ,
	          [_TagName] ,
	          [_PropertyLabel] ,
	          [_NumberOfNodes]
	        ) 
	SELECT	R.x.value('PropertyGroupURI[1]','varchar(max)'),
			R.x.value('PropertyURI[1]','varchar(max)'),
			R.x.value('SortOrder[1]','varchar(max)'),
			(case when CAST(R.x.query('CustomDisplayModule[1]/*') AS NVARCHAR(MAX))<>'' then R.x.query('CustomDisplayModule[1]/*') else NULL end),
			(case when CAST(R.x.query('CustomEditModule[1]/*') AS NVARCHAR(MAX))<>'' then R.x.query('CustomEditModule[1]/*') else NULL end),
			R.x.value('_PropertyGroupNode[1]','varchar(max)'),
			R.x.value('_PropertyNode[1]','varchar(max)'),
			R.x.value('_TagName[1]','varchar(max)'),
			R.x.value('_PropertyLabel[1]','varchar(max)'),
			R.x.value('_NumberOfNodes[1]','varchar(max)')
	 FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.].[PropertyGroupProperty]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )
  

---------------------------------------------------------------
-- [Ontology.Presentation]
---------------------------------------------------------------


 --[Ontology.Presentation].[XML]
 INSERT INTO [Ontology.Presentation].[XML]
         ( PresentationID,
			type ,
           subject ,
           predicate ,
           object ,
           presentationXML ,
           _SubjectNode ,
           _PredicateNode ,
           _ObjectNode
         )       
  SELECT  R.x.value('PresentationID[1]', 'varchar(max)') ,
		  R.x.value('type[1]', 'varchar(max)') ,
          R.x.value('subject[1]', 'varchar(max)'),
          R.x.value('predicate[1]', 'varchar(max)'),
          R.x.value('object[1]', 'varchar(max)'),
          (case when CAST(R.x.query('presentationXML[1]/*') AS NVARCHAR(MAX))<>'' then R.x.query('presentationXML[1]/*') else NULL end) , 
          R.x.value('_SubjectNode[1]', 'varchar(max)'),
          R.x.value('_PredicateNode[1]', 'varchar(max)'),
          R.x.value('_ObjectNode[1]', 'varchar(max)')
  FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Ontology.Presentation].[XML]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )

  
---------------------------------------------------------------
-- [RDF.Security]
---------------------------------------------------------------
             
 -- [RDF.Security].[Group]
 TRUNCATE TABLE [RDF.Security].[Group]
 INSERT INTO [RDF.Security].[Group]
 
         ( SecurityGroupID ,
           Label ,
           HasSpecialViewAccess ,
           HasSpecialEditAccess ,
           Description
         )
 SELECT   R.x.value('SecurityGroupID[1]', 'varchar(max)') ,
          R.x.value('Label[1]', 'varchar(max)'),
          R.x.value('HasSpecialViewAccess[1]', 'varchar(max)'),
          R.x.value('HasSpecialEditAccess[1]', 'varchar(max)'),
          R.x.value('Description[1]', 'varchar(max)')
  FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[RDF.Security].[Group]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x ) 



---------------------------------------------------------------
-- [Utility.NLP]
---------------------------------------------------------------
   
	--[Utility.NLP].[ParsePorterStemming]
	INSERT INTO [Utility.NLP].ParsePorterStemming
	        ( Step, Ordering, phrase1, phrase2 ) 
	SELECT	R.x.value('Step[1]','varchar(max)'),
			R.x.value('Ordering[1]','varchar(max)'), 
			R.x.value('phrase1[1]','varchar(max)'), 
			R.x.value('phrase2[1]','varchar(max)')
	 FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Utility.NLP].[ParsePorterStemming]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )
	
	--[Utility.NLP].[StopWord]
	INSERT INTO [Utility.NLP].StopWord
	        ( word, stem, scope ) 
	SELECT	R.x.value('word[1]','varchar(max)'),
			R.x.value('stem[1]','varchar(max)'),
			R.x.value('scope[1]','varchar(max)')
	 FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Utility.NLP].[StopWord]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )
  
	--[Utility.NLP].[Thesaurus.Source]
	INSERT INTO [Utility.NLP].[Thesaurus.Source]
	        ( Source, SourceName ) 
	SELECT	R.x.value('Source[1]','varchar(max)'),
			R.x.value('SourceName[1]','varchar(max)')
	 FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Utility.NLP].[Thesaurus.Source]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )


---------------------------------------------------------------
-- [User.Session]
---------------------------------------------------------------

  --[User.Session].Bot		
  INSERT INTO [User.Session].Bot  ( UserAgent )
   SELECT	R.x.value('UserAgent[1]','varchar(max)') 
	 FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[User.Session].Bot'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )
  
  
  
---------------------------------------------------------------
-- [Direct.]
---------------------------------------------------------------
   
  --[Direct.].[Sites]
  INSERT INTO [Direct.].[Sites]
          ( SiteID ,
            BootstrapURL ,
            SiteName ,
            QueryURL ,
            SortOrder ,
            IsActive
          )
  SELECT	R.x.value('SiteID[1]','varchar(max)'),
			R.x.value('BootstrapURL[1]','varchar(max)'),
			R.x.value('SiteName[1]','varchar(max)'),
			R.x.value('QueryURL[1]','varchar(max)'),
			R.x.value('SortOrder[1]','varchar(max)'),
			R.x.value('IsActive[1]','varchar(max)')
	 FROM    ( SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Direct.].[Sites]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )
	
	
---------------------------------------------------------------
-- [Profile.Data]
---------------------------------------------------------------
 
    --[Profile.Data].[Publication.Type]		
  INSERT INTO [Profile.Data].[Publication.Type]
          ( pubidtype_id, name, sort_order )
           
   SELECT	R.x.value('pubidtype_id[1]','varchar(max)'),
			R.x.value('name[1]','varchar(max)'),
			R.x.value('sort_order[1]','varchar(max)')
	 FROM    (SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Profile.Data].[Publication.Type]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )
   
  --[Profile.Data].[Publication.MyPub.Category]
  TRUNCATE TABLE [Profile.Data].[Publication.MyPub.Category]
  INSERT INTO [Profile.Data].[Publication.MyPub.Category]
          ( [HmsPubCategory] ,
            [CategoryName]
          ) 
   SELECT	R.x.value('HmsPubCategory[1]','varchar(max)'),
			R.x.value('CategoryName[1]','varchar(max)')
	 FROM    (SELECT
                      @x.query
                      ('Import[1]/Table[@Name=''[Profile.Data].[Publication.MyPub.Category]'']')
                      x
          ) t
  CROSS APPLY x.nodes('//Row') AS R ( x )
  
  
  -- Use to generate select lists for new tables
  -- SELECT   'R.x.value(''' + c.name +  '[1]'',' + '''varchar(max)'')'+ ',' ,* 
  -- FROM sys.columns c 
  -- JOIN  sys.types t ON t.system_type_id = c.system_type_id 
  -- WHERE object_id IN (SELECT object_id FROM sys.tables WHERE name = 'Publication.MyPub.Category') 
  --AND T.NAME<>'sysname'ORDER BY c.column_id
	 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[NetworkAuthorshipTimeline.Concept.GetData]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DescriptorName NVARCHAR(255)
 	SELECT @DescriptorName = d.DescriptorName
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n,
			[Profile.Data].[Concept.Mesh.Descriptor] d
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
			AND m.InternalID = d.DescriptorUI

    -- Insert statements for procedure here
	declare @gc varchar(max)

	declare @y table (
		y int,
		A int,
		B int
	)

	insert into @y (y,A,B)
		select n.n y, coalesce(t.A,0) A, coalesce(t.B,0) B
		from [Utility.Math].[N] left outer join (
			select (case when y < 1970 then 1970 else y end) y,
				sum(A) A,
				sum(B) B
			from (
				select pmid, pubyear y, (case when w = 1 then 1 else 0 end) A, (case when w < 1 then 1 else 0 end) B
				from (
					select distinct pmid, pubyear, topicweight w
					from [Profile.Cache].[Concept.Mesh.PersonPublication]
					where meshheader = @DescriptorName
				) t
			) t
			group by y
		) t on n.n = t.y
		where n.n between 1980 and year(getdate())

	declare @x int

	select @x = max(A+B)
		from @y

	if coalesce(@x,0) > 0
	begin
		declare @v varchar(1000)
		declare @z int
		declare @k int
		declare @i int

		set @z = power(10,floor(log(@x)/log(10)))
		set @k = floor(@x/@z)
		if @x > @z*@k
			select @k = @k + 1
		if @k > 5
			select @k = floor(@k/2.0+0.5), @z = @z*2

		set @v = ''
		set @i = 0
		while @i <= @k
		begin
			set @v = @v + '|' + cast(@z*@i as varchar(50))
			set @i = @i + 1
		end
		set @v = '|0|'+cast(@x as varchar(50))
		--set @v = '|0|50|100'

		declare @h varchar(1000)
		set @h = ''
		select @h = @h + '|' + (case when y % 2 = 1 then '' else ''''+right(cast(y as varchar(50)),2) end)
			from @y
			order by y 

		declare @w float
		--set @w = @k*@z
		set @w = @x

		declare @d varchar(max)
		set @d = ''
		select @d = @d + cast(floor(0.5 + 100*A/@w) as varchar(50)) + ','
			from @y
			order by y
		set @d = left(@d,len(@d)-1) + '|'
		select @d = @d + cast(floor(0.5 + 100*B/@w) as varchar(50)) + ','
			from @y
			order by y
		set @d = left(@d,len(@d)-1)

		declare @c varchar(50)
		set @c = 'FB8072,80B1D3'
		--set @c = 'FB8072,B3DE69,80B1D3'
		--set @c = 'F96452,a8dc4f,68a4cc'
		--set @c = 'fea643,76cbbd,b56cb5'

		--select @v, @h, @d

		--set @gc = 'http://chart.apis.google.com/chart?chs=595x100&chf=bg,s,ffffff|c,s,ffffff&chxt=x,y&chxl=0:' + @h + '|1:' + @v + '&cht=bvs&chd=t:' + @d + '&chdl=First+Author|Middle or Unkown|Last+Author&chco='+@c+'&chbh=10'
		set @gc = 'http://chart.apis.google.com/chart?chs=595x100&chf=bg,s,ffffff|c,s,ffffff&chxt=x,y&chxl=0:' + @h + '|1:' + @v + '&cht=bvs&chd=t:' + @d + '&chdl=Major+Topic|Minor+Topic&chco='+@c+'&chbh=10'

		select @gc gc --, @w w

		--select * from @y order by y

	end

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Process.AddAuditUpdate]	(@insert_new_record BIT=1,
																								 @ProcessName varchar(1000),
																								 @ProcessStartDate datetime=NULL,
																								 @ProcessEnddate datetime=NULL,
																								 @ProcessedRows INT=NULL,
																								 @Error BIT=0,
																								 @AuditID UNIQUEIDENTIFIER=NULL OUTPUT)
as 
begin
SET NOCOUNT ON 

 

 
	IF @insert_new_record=1
		BEGIN
				SELECT @AuditID = NEWID()
				INSERT INTO [Profile.Cache].[Process.Audit]
				   (AuditID,ProcessName,ProcessStartDate) VALUES(@AuditID,@ProcessName,@ProcessStartDate)
		END
	ELSE
		UPDATE [Profile.Cache].[Process.Audit]
			 SET ProcessEndDate = ISNULL(@ProcessEnddate,GETDATE()),
				   ProcessedRows=@ProcessedRows,
					 Error=@Error
	   WHERE AuditID = @AuditID

end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.DoesPublicationExist](	@pmid INT, @exists BIT OUTPUT)
AS
BEGIN
	SET NOCOUNT ON;

  SELECT @exists=0
  SELECT TOP 1 @exists=0, @exists = CASE WHEN PMID IS NULL THEN 0 ELSE 1 END  
		FROM [Profile.Data].[Publication.PubMed.AllXML] 
	 WHERE pmid = @PMID	 

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.MyPub.General](
	[MPID] [nvarchar](50) NOT NULL,
	[PersonID] [int] NULL,
	[PMID] [nvarchar](15) NULL,
	[HmsPubCategory] [nvarchar](60) NULL,
	[NlmPubCategory] [nvarchar](250) NULL,
	[PubTitle] [nvarchar](2000) NULL,
	[ArticleTitle] [nvarchar](2000) NULL,
	[ArticleType] [nvarchar](30) NULL,
	[ConfEditors] [nvarchar](2000) NULL,
	[ConfLoc] [nvarchar](2000) NULL,
	[EDITION] [nvarchar](30) NULL,
	[PlaceOfPub] [nvarchar](60) NULL,
	[VolNum] [nvarchar](30) NULL,
	[PartVolPub] [nvarchar](15) NULL,
	[IssuePub] [nvarchar](30) NULL,
	[PaginationPub] [nvarchar](30) NULL,
	[AdditionalInfo] [nvarchar](2000) NULL,
	[Publisher] [nvarchar](255) NULL,
	[SecondaryAuthors] [nvarchar](2000) NULL,
	[ConfNm] [nvarchar](2000) NULL,
	[ConfDTs] [nvarchar](60) NULL,
	[ReptNumber] [nvarchar](35) NULL,
	[ContractNum] [nvarchar](35) NULL,
	[DissUnivNm] [nvarchar](2000) NULL,
	[NewspaperCol] [nvarchar](15) NULL,
	[NewspaperSect] [nvarchar](15) NULL,
	[PublicationDT] [smalldatetime] NULL,
	[Abstract] [varchar](max) NULL,
	[Authors] [varchar](max) NULL,
	[URL] [varchar](1000) NULL,
	[CreatedDT] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedDT] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK__my_pubs_general__03BB8E22] PRIMARY KEY CLUSTERED 
(
	[MPID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Databank](
	[PMID] [int] NOT NULL,
	[DataBankName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_pm_pubs_databanks] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[DataBankName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Chemical](
	[PMID] [int] NOT NULL,
	[NameOfSubstance] [varchar](255) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE  [Profile.Data].[Publication.Pubmed.AddDisambiguationLog] (@batchID UNIQUEIDENTIFIER, 
												@personID INT,
												@actionValue INT,
												@action VARCHAR(200) )
AS
BEGIN
	IF @action='StartService'
		BEGIN
			INSERT INTO [Profile.Data].[Publication.PubMed.DisambiguationAudit]  (BatchID,BatchCount,PersonID,ServiceCallStart)
			VALUES (@batchID,@actionValue,@personID,GETDATE())
		END
	IF @action='EndService'
		BEGIN
			UPDATE [Profile.Data].[Publication.PubMed.DisambiguationAudit] 
			   SET ServiceCallEnd = GETDATE(),
				   ServiceCallPubsFound  =@actionValue
			 WHERE batchID=@batchID
			   AND personid=@personID
		END
	IF @action='LocalCounts'
		BEGIN
			UPDATE [Profile.Data].[Publication.PubMed.DisambiguationAudit] 
			   SET ServiceCallNewPubs = @actionValue,
				   ServiceCallExistingPubs  =ServiceCallPubsFound-@actionValue
			 WHERE batchID=@batchID
			   AND personid=@personID
		END
	IF @action='AuthorComplete'
		BEGIN
			UPDATE [Profile.Data].[Publication.PubMed.DisambiguationAudit] 
			   SET ServiceCallPubsAdded = @actionValue,
				   ProcessEnd  =GETDATE(),
				   Success= CASE WHEN @actionValue =ServiceCallNewPubs THEN 1 ELSE 0 END
			 WHERE batchID=@batchID
			   AND personid=@personID
		END
	IF @action='Error'
		BEGIN
			UPDATE [Profile.Data].[Publication.PubMed.DisambiguationAudit] 
			   SET ErrorText = @actionValue,
				   ProcessEnd  =GETDATE(),
				   Success=1
			 WHERE batchID=@batchID
			   AND personid=@personID
		END
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Accession](
	[PMID] [int] NOT NULL,
	[DataBankName] [varchar](100) NOT NULL,
	[AccessionNumber] [varchar](50) NOT NULL,
 CONSTRAINT [PK_pm_pubs_accessions] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[DataBankName] ASC,
	[AccessionNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Investigator](
	[PmPubsInvestigatorId] [int] IDENTITY(0,1) NOT NULL,
	[PMID] [int] NOT NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](100) NULL,
	[ForeName] [varchar](100) NULL,
	[Suffix] [varchar](20) NULL,
	[Initials] [varchar](20) NULL,
	[Affiliation] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[PmPubsInvestigatorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Grant](
	[PMID] [int] NOT NULL,
	[GrantID] [varchar](50) NOT NULL,
	[Acronym] [varchar](50) NULL,
	[Agency] [varchar](1000) NULL,
 CONSTRAINT [PK_pm_pubs_grants] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[GrantID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Author](
	[PmPubsAuthorID] [int] IDENTITY(1,1) NOT NULL,
	[PMID] [int] NOT NULL,
	[ValidYN] [varchar](1) NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](100) NULL,
	[ForeName] [varchar](100) NULL,
	[Suffix] [varchar](20) NULL,
	[Initials] [varchar](20) NULL,
	[Affiliation] [varchar](1000) NULL,
 CONSTRAINT [PK__pm_pubs_authors__17F790F9] PRIMARY KEY CLUSTERED 
(
	[PmPubsAuthorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Keyword](
	[PMID] [int] NOT NULL,
	[Keyword] [varchar](255) NOT NULL,
	[MajorTopicYN] [char](1) NULL,
 CONSTRAINT [PK_pm_pubs_keywords] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[Keyword] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Publication.Pubmed.AddPMIDs] (@personid INT,
																		@PMIDxml XML)
AS
BEGIN
	SET NOCOUNT ON;	
	

	BEGIN TRY
		BEGIN TRAN		 
							 
			  -- Add publications_include records
			  INSERT INTO [Profile.Data].[Publication.PubMed.Disambiguation] (personid,pmid)
			  SELECT @personid,
					 D.element.value('.','INT') pmid		 
				FROM @PMIDxml.nodes('//PMID') AS D(element)
			   WHERE NOT EXISTS(SELECT TOP 1 * FROM [Profile.Data].[Publication.PubMed.Disambiguation]	 dp WHERE personid = @personid and dp.pmid = D.element.value('.','INT'))	

		
		COMMIT
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK

		-- Raise an error with the details of the exception
		SELECT @ErrMsg = 'usp_CheckPMIDList FAILED WITH : ' + ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH				
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Mesh](
	[PMID] [int] NOT NULL,
	[DescriptorName] [varchar](255) NOT NULL,
	[QualifierName] [varchar](255) NOT NULL,
	[MajorTopicYN] [char](1) NULL,
 CONSTRAINT [PK_pm_pubs_mesh] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[DescriptorName] ASC,
	[QualifierName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_dq] ON [Profile.Data].[Publication.PubMed.Mesh] 
(
	[DescriptorName] ASC,
	[QualifierName] ASC,
	[MajorTopicYN] ASC,
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.PubType](
	[PMID] [int] NOT NULL,
	[PublicationType] [varchar](100) NOT NULL,
 CONSTRAINT [PK_pm_pubs_pubtypes] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[PublicationType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Framework].[ResolveURL]
	@ApplicationName varchar(1000) = '',
	@param1 varchar(1000) = '',
	@param2 varchar(1000) = '',
	@param3 varchar(1000) = '',
	@param4 varchar(1000) = '',
	@param5 varchar(1000) = '',
	@param6 varchar(1000) = '',
	@param7 varchar(1000) = '',
	@param8 varchar(1000) = '',
	@param9 varchar(1000) = '',
	@SessionID uniqueidentifier = null,
	@ContentType varchar(255) = null,
	@Resolved bit = NULL OUTPUT,
	@ErrorDescription varchar(max) = NULL OUTPUT,
	@ResponseURL varchar(1000) = NULL OUTPUT,
	@ResponseContentType varchar(255) = NULL OUTPUT,
	@ResponseStatusCode int = NULL OUTPUT,
	@ResponseRedirect bit = NULL OUTPUT,
	@ResponseIncludePostData bit = NULL OUTPUT,
	@subject BIGINT = NULL OUTPUT,
	@predicate BIGINT = NULL OUTPUT,
	@object BIGINT = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- URL Pattern String:
	-- domainname	/{profile | display}	/{sNodeID | sAliasType/sAliasID}	/{pNodeID | pAliasType/pAliasID | sTab}	/{oNodeID | oAliasType/oAliasID | pTab}	/oTab	/sNodeID_pNodeID_oNodeID.rdf

	DECLARE @SessionHistory XML

	-- By default we were not able to resolve the URL
	SELECT @Resolved = 0

	-- Load param values into a table
	DECLARE @params TABLE (id int, val varchar(1000))
	INSERT INTO @params (id, val) VALUES (1, @param1)
	INSERT INTO @params (id, val) VALUES (2, @param2)
	INSERT INTO @params (id, val) VALUES (3, @param3)
	INSERT INTO @params (id, val) VALUES (4, @param4)
	INSERT INTO @params (id, val) VALUES (5, @param5)
	INSERT INTO @params (id, val) VALUES (6, @param6)
	INSERT INTO @params (id, val) VALUES (7, @param7)
	INSERT INTO @params (id, val) VALUES (8, @param8)
	INSERT INTO @params (id, val) VALUES (9, @param9)

	DECLARE @MaxParam int
	SELECT @MaxParam = 0
	SELECT @MaxParam = MAX(id) FROM @params WHERE val > ''

	DECLARE @Tab VARCHAR(1000)
	DECLARE @File VARCHAR(1000)
	DECLARE @ViewAs VARCHAR(50)
	
	SELECT @subject=NULL, @predicate=NULL, @object=NULL, @Tab=NULL, @File=NULL
	
	SELECT @File = val, @MaxParam = @MaxParam-1
		FROM @params
		WHERE id = @MaxParam and val like '%.%'

	DECLARE @pointer INT
	SELECT @pointer=1
	
	DECLARE @aliases INT
	SELECT @aliases = 0
	
	-- subject
	IF (@MaxParam >= @pointer)
	BEGIN
		SELECT @subject = CAST(val AS BIGINT), @pointer = @pointer + 1
			FROM @params 
			WHERE id=@pointer AND val NOT LIKE '%[^0-9]%'
		IF @subject IS NULL AND @MaxParam > @pointer
			SELECT @subject = NodeID, @pointer = @pointer + 2, @aliases = @aliases + 1
				FROM [RDF.].Alias 
				WHERE AliasType = (SELECT val FROM @params WHERE id = @pointer)
					AND AliasID = (SELECT val FROM @params WHERE id = @pointer+1)
		IF @subject IS NULL
			SELECT @ErrorDescription = 'The subject cannot be found.'
	END

	-- predicate
	IF (@MaxParam >= @pointer) AND (@subject IS NOT NULL)
	BEGIN
		SELECT @predicate = CAST(val AS BIGINT), @pointer = @pointer + 1
			FROM @params 
			WHERE id=@pointer AND val NOT LIKE '%[^0-9]%'
		IF @predicate IS NULL AND @MaxParam > @pointer
			SELECT @predicate = NodeID, @pointer = @pointer + 2, @aliases = @aliases + 1
				FROM [RDF.].Alias 
				WHERE AliasType = (SELECT val FROM @params WHERE id = @pointer)
					AND AliasID = (SELECT val FROM @params WHERE id = @pointer+1)
		IF @predicate IS NULL AND @MaxParam = @pointer
			SELECT @Tab=(SELECT val FROM @params WHERE id = @pointer)
		IF @predicate IS NULL AND @Tab IS NULL
			SELECT @ErrorDescription = 'The predicate cannot be found.'
	END
	
	-- object
	IF (@MaxParam >= @pointer) AND (@predicate IS NOT NULL)
	BEGIN
		SELECT @object = CAST(val AS BIGINT), @pointer = @pointer + 1
			FROM @params 
			WHERE id=@pointer AND val NOT LIKE '%[^0-9]%'
		IF @object IS NULL AND @MaxParam > @pointer
			SELECT @object = NodeID, @pointer = @pointer + 2, @aliases = @aliases + 1
				FROM [RDF.].Alias 
				WHERE AliasType = (SELECT val FROM @params WHERE id = @pointer)
					AND AliasID = (SELECT val FROM @params WHERE id = @pointer+1)
		IF @object IS NULL AND @MaxParam = @pointer
			SELECT @Tab=(SELECT val FROM @params WHERE id = @pointer)
		IF @object IS NULL AND @Tab IS NULL
			SELECT @ErrorDescription = 'The object cannot be found.'
	END
	
	-- tab
	IF (@MaxParam = @pointer) AND (@object IS NOT NULL) AND (@Tab IS NULL)
		SELECT @Tab=(SELECT val FROM @params WHERE id = @pointer)
	
	-- Return results
	IF (@ErrorDescription IS NULL)
	BEGIN

		declare @basePath nvarchar(400)
		select @basePath = value from [Framework.].Parameter where ParameterID = 'basePath'

		-- Default
		SELECT	@Resolved = 1,
				@ErrorDescription = '',
				@ResponseContentType = @ContentType,
				@ResponseStatusCode = 200,
				@ResponseRedirect = 0,
				@ResponseIncludePostData = 0,
				@ResponseURL = '~/profile/Profile.aspx?'
					+ 'subject=' + IsNull(cast(@subject as varchar(50)),'')
					+ '&predicate=' + IsNull(cast(@predicate as varchar(50)),'')
					+ '&object=' + IsNull(cast(@object as varchar(50)),'')
					+ '&tab=' + IsNull(@tab,'')
					+ '&file=' + IsNull(@file,'')

		DECLARE @FileRDF varchar(1000)
		SELECT @FileRDF =	IsNull(cast(@subject as varchar(50)),'')
							+IsNull('_'+cast(@predicate as varchar(50)),'')
							+IsNull('_'+cast(@object as varchar(50)),'')+'.rdf'

		DECLARE @FilePresentationXML varchar(1000)
		SELECT @FilePresentationXML = 'presentation_'
							+IsNull(cast(@subject as varchar(50)),'')
							+IsNull('_'+cast(@predicate as varchar(50)),'')
							+IsNull('_'+cast(@object as varchar(50)),'')+'.xml'

		IF (@ApplicationName = 'profile') AND (@File = @FileRDF)
				-- Display as RDF
				SELECT	@ResponseContentType = 'application/rdf+xml',
						@ResponseURL = @ResponseURL + '&viewas=RDF'
		ELSE IF (@ApplicationName = 'profile') AND (@File = @FilePresentationXML)
				-- Display PresentationXML
				SELECT	@ResponseContentType = 'application/rdf+xml',
						@ResponseURL = @ResponseURL + '&viewas=PresentationXML'
		ELSE IF (@ApplicationName = 'profile') AND (@ContentType = 'application/rdf+xml')
				-- Redirect 303 to the RDF URL
				SELECT	@ResponseContentType = 'application/rdf+xml',
						@ResponseStatusCode = 303,
						@ResponseRedirect = 1,
						@ResponseIncludePostData = 1,
						@ResponseURL = @basePath + '/profile'
							+ IsNull('/'+cast(@subject as varchar(50)),'')
							+ IsNull('/'+cast(@predicate as varchar(50)),'')
							+ IsNull('/'+cast(@object as varchar(50)),'')
							+ '/' + @FileRDF
		ELSE IF (@ApplicationName = 'profile')
				-- Redirect 303 to the HTML URL
				SELECT	@ResponseContentType = @ContentType,
						@ResponseStatusCode = 303,
						@ResponseRedirect = 1,
						@ResponseIncludePostData = 1,
						@ResponseURL = @basePath + '/display'
							+ (CASE WHEN @Subject IS NULL THEN ''
									ELSE IsNull((SELECT TOP 1 '/'+Subject
											FROM (
												SELECT 1 k, AliasType+'/'+AliasID Subject
													FROM [RDF.].Alias
													WHERE NodeID = @Subject AND Preferred = 1
												UNION ALL
												SELECT 2, CAST(@Subject AS VARCHAR(50))
											) t
											ORDER BY k, Subject),'')
									END)
							+ (CASE WHEN @Predicate IS NULL THEN ''
									ELSE IsNull((SELECT TOP 1 '/'+Subject
											FROM (
												SELECT 1 k, AliasType+'/'+AliasID Subject
													FROM [RDF.].Alias
													WHERE NodeID = @Predicate AND Preferred = 1
												UNION ALL
												SELECT 2, CAST(@Predicate AS VARCHAR(50))
											) t
											ORDER BY k, Subject),'')
									END)
							+ (CASE WHEN @Object IS NULL THEN ''
									ELSE IsNull((SELECT TOP 1 '/'+Subject
											FROM (
												SELECT 1 k, AliasType+'/'+AliasID Subject
													FROM [RDF.].Alias
													WHERE NodeID = @Object AND Preferred = 1
												UNION ALL
												SELECT 2, CAST(@Object AS VARCHAR(50))
											) t
											ORDER BY k, Subject),'')
									END)
							+ (CASE WHEN @MaxParam >= 1 AND @Pointer <= 1 THEN '/'+@param1 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 2 AND @Pointer <= 2 THEN '/'+@param2 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 3 AND @Pointer <= 3 THEN '/'+@param3 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 4 AND @Pointer <= 4 THEN '/'+@param4 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 5 AND @Pointer <= 5 THEN '/'+@param5 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 6 AND @Pointer <= 6 THEN '/'+@param6 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 7 AND @Pointer <= 7 THEN '/'+@param7 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 8 AND @Pointer <= 8 THEN '/'+@param8 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 9 AND @Pointer <= 9 THEN '/'+@param9 ELSE '' END)
		ELSE IF (@ApplicationName = 'presentation')
				-- Display as HTML
				SELECT	@ResponseURL = @ResponseURL + '&viewas=PresentationXML'
		ELSE
				-- Display as HTML
				SELECT	@ResponseURL = replace(@ResponseURL,'~/Profile/Profile.aspx','~/Profile/Display.aspx') + '&viewas=HTML'


		IF @ResponseRedirect = 0
			SELECT @ResponseURL = @ResponseURL + '&ContentType='+IsNull(@ResponseContentType,'') + '&StatusCode='+IsNull(cast(@ResponseStatusCode as varchar(50)),'')

	END

	/*
		Valid Rest Paths (T=text, N=numeric):

		T
		T/N
			T/N/N
				T/N/N/N
					T/N/N/N/T
				T/N/N/T
				T/N/N/T/T
					T/N/N/T/T/T
			T/N/T
			T/N/T/T
				T/N/T/T/N
					T/N/T/T/N/T
				T/N/T/T/T
				T/N/T/T/T/T
					T/N/T/T/T/T/T
		T/T/T
			T/T/T/N
				T/T/T/N/N
					T/T/T/N/N/T
				T/T/T/N/T
				T/T/T/N/T/T
					T/T/T/N/T/T/T
			T/T/T/T
			T/T/T/T/T
				T/T/T/T/T/N
					T/T/T/T/T/N/T
				T/T/T/T/T/T
				T/T/T/T/T/T/T
					T/T/T/T/T/T/T/T
	*/

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Framework.].[ResolveURL]
	@ApplicationName varchar(1000) = '',
    @param1 varchar(1000) = '',
	@param2 varchar(1000) = '',
	@param3 varchar(1000) = '',
	@param4 varchar(1000) = '',
	@param5 varchar(1000) = '',
	@param6 varchar(1000) = '',
	@param7 varchar(1000) = '',
	@param8 varchar(1000) = '',
	@param9 varchar(1000) = '',
	@SessionID uniqueidentifier = NULL,	 
	@RestURL varchar(MAX) = NULL,
	@UserAgent varchar(255) = NULL,
	@ContentType varchar(255) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Log request
	DECLARE @HistoryID INT
	INSERT INTO [User.Session].[History.ResolveURL]	(RequestDate, ApplicationName, param1, param2, param3, param4, param5, param6, param7, param8, param9, SessionID, RestURL, UserAgent, ContentType)
		SELECT GetDate(), @ApplicationName, @param1, @param2, @param3, @param4, @param5, @param6, @param7, @param8, @param9, @SessionID, @RestURL, @UserAgent, @ContentType
	SELECT @HistoryID = @@IDENTITY		 

	-- For dynamic sql
	DECLARE @sql nvarchar(max)

	-- Define variables needed to construct the output XML
	DECLARE @Resolved bit
	DECLARE @ErrorDescription varchar(max)
	DECLARE @ResponseURL varchar(1000)
	DECLARE @ResponseContentType varchar(255)
	DECLARE @ResponseStatusCode int
	DECLARE @ResponseRedirect bit
	DECLARE @ResponseIncludePostData bit

	-- Determine if this application has a custom resolver
	DECLARE @CustomResolver varchar(1000)
	SELECT @CustomResolver = Resolver
		FROM [Framework.].RestPath
		WHERE ApplicationName = @ApplicationName

	-- Resolve the URL
	SELECT @Resolved = 0
	IF @CustomResolver IS NOT NULL
	BEGIN
		-- Use a custom resolver
		SELECT @sql = 'EXEC ' + @CustomResolver 
			+ ' @ApplicationName = ''' + replace(@ApplicationName,'''','''''') + ''', '
			+ ' @param1 = ''' + replace(@param1,'''','''''') + ''', '
			+ ' @param2 = ''' + replace(@param2,'''','''''') + ''', '
			+ ' @param3 = ''' + replace(@param3,'''','''''') + ''', '
			+ ' @param4 = ''' + replace(@param4,'''','''''') + ''', '
			+ ' @param5 = ''' + replace(@param5,'''','''''') + ''', '
			+ ' @param6 = ''' + replace(@param6,'''','''''') + ''', '
			+ ' @param7 = ''' + replace(@param7,'''','''''') + ''', '
			+ ' @param8 = ''' + replace(@param8,'''','''''') + ''', '
			+ ' @param9 = ''' + replace(@param9,'''','''''') + ''', '
			+ ' @SessionID = ' + IsNull('''' + replace(@SessionID,'''','''''') + '''','NULL') + ', '
			+ ' @ContentType = ' + IsNull('''' + replace(@ContentType,'''','''''') + '''','NULL') + ', '
			+ ' @Resolved = @Resolved_OUT OUTPUT, '
			+ ' @ErrorDescription = @ErrorDescription_OUT OUTPUT, '
			+ ' @ResponseURL = @ResponseURL_OUT OUTPUT, '
			+ ' @ResponseContentType = @ResponseContentType_OUT OUTPUT, '
			+ ' @ResponseStatusCode = @ResponseStatusCode_OUT OUTPUT, '
			+ ' @ResponseRedirect = @ResponseRedirect_OUT OUTPUT, '
			+ ' @ResponseIncludePostData = @ResponseIncludePostData_OUT OUTPUT '
		EXEC sp_executesql @sql, 
			N'
				@Resolved_OUT bit OUTPUT,
				@ErrorDescription_OUT varchar(max) OUTPUT,
				@ResponseURL_OUT varchar(1000) OUTPUT,
				@ResponseContentType_OUT varchar(255) OUTPUT,
				@ResponseStatusCode_OUT int OUTPUT,
				@ResponseRedirect_OUT bit OUTPUT,
				@ResponseIncludePostData_OUT bit OUTPUT',
			@Resolved_OUT = @Resolved OUTPUT,
			@ErrorDescription_OUT = @ErrorDescription OUTPUT,
			@ResponseURL_OUT = @ResponseURL OUTPUT,
			@ResponseContentType_OUT = @ResponseContentType OUTPUT,
			@ResponseStatusCode_OUT = @ResponseStatusCode OUTPUT,
			@ResponseRedirect_OUT = @ResponseRedirect OUTPUT,
			@ResponseIncludePostData_OUT = @ResponseIncludePostData OUTPUT
	END
	ELSE
	BEGIN
		-- Use the default resolver
		SELECT	@Resolved = 1,
				@ErrorDescription = '', 
				@ResponseURL = BaseURL,
				@ResponseContentType = @ContentType,
				@ResponseStatusCode = 200,
				@ResponseRedirect = 0,
				@ResponseIncludePostData = 0
		    FROM [Framework.Alias].ApplicationBaseURL
			WHERE ApplicationName = @ApplicationName
		SELECT @ResponseURL = @ResponseURL + (CASE WHEN CHARINDEX('?',@ResponseURL) > 0 THEN '' ELSE '?' END)
			+ '&param1=' + @param1
			+ '&param2=' + @param2
			+ '&param3=' + @param3
			+ '&param4=' + @param4
			+ '&param5=' + @param5
			+ '&param6=' + @param6
			+ '&param7=' + @param7
			+ '&param8=' + @param8
			+ '&param9=' + @param9
	END
	-- Add standard parameters
	IF (@Resolved = 1) AND (@ResponseRedirect = 0)
	BEGIN
		SELECT @ResponseURL = @ResponseURL + (CASE WHEN CHARINDEX('?',@ResponseURL) > 0 THEN '' ELSE '?' END)
		SELECT @ResponseURL = @ResponseURL + '&SessionID=' + IsNull(CAST(@SessionID AS varchar(50)),'')
	END
	SELECT @ErrorDescription = IsNull(@ErrorDescription,'URL could not be resolved.')

	-- Log results
	UPDATE [User.Session].[History.ResolveURL]
		SET CustomResolver = @CustomResolver,
			Resolved = @Resolved,
			ErrorDescription = @ErrorDescription,
			ResponseURL = @ResponseURL,
			ResponseContentType = @ResponseContentType,
			ResponseStatusCode = @ResponseStatusCode,
			ResponseRedirect = @ResponseRedirect,
			ResponseIncludePostData = @ResponseIncludePostData
		WHERE HistoryID = @HistoryID

	-- Return results 
	SELECT	@Resolved Resolved, 
			@ErrorDescription ErrorDescription, 
			@ResponseURL ResponseURL,
			@ResponseContentType ResponseContentType,
			@ResponseStatusCode ResponseStatusCode,
			@ResponseRedirect ResponseRedirect,
			@ResponseIncludePostData ResponseIncludePostData,
			@SessionID RedirectHeaderSessionID


	/*
		Examples:

		EXEC [Framework.].[ResolveURL] @ApplicationName='profile', @param1='12345', @ContentType='application/rdf+xml'
		EXEC [Framework.].[ResolveURL] @ApplicationName='profile', @param1='12345', @param2='12345.rdf'
		EXEC [Framework.].[ResolveURL] @ApplicationName='profile', @param1='12345'
		EXEC [Framework.].[ResolveURL] @ApplicationName='display', @param1='12345', @SessionID = '16A199ED-07C5-436F-AB7D-0214792630A6'
		EXEC [Framework.].[ResolveURL] @ApplicationName='profile', @param1='12345', @param2='12345.rdf', @SessionID = '16A199ED-07C5-436F-AB7D-0214792630A6'

	*/

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Authenticate] (
	@UserName NVARCHAR(50),
	@Password VARCHAR(128),
	@UserID INT = NULL OUTPUT,
	@PersonID INT = NULL OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY	
		SELECT @UserID = UserID, @PersonID = PersonID
			FROM [User.Account].[User]
			WHERE UserName = @UserName
				AND Password = @Password	  

	END TRY
	BEGIN CATCH	
		--Check success		
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		IF @@TRANCOUNT > 0  ROLLBACK
			--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Concept.Mesh.ParseMeshXML]
AS
BEGIN
	SET NOCOUNT ON;

	-- Clear any existing data
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.XML]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.Descriptor]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.Qualifier]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.Term]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.SemanticType]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.SemanticGroupType]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.SemanticGroup]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.Tree]
	TRUNCATE TABLE [Profile.Data].[Concept.Mesh.TreeTop]

	-- Extract items from SemGroups.xml
	INSERT INTO [Profile.Data].[Concept.Mesh.SemanticGroupType] (SemanticGroupUI,SemanticGroupName,SemanticTypeUI,SemanticTypeName)
		SELECT 
			S.x.value('SemanticGroupUI[1]','varchar(10)'),
			S.x.value('SemanticGroupName[1]','varchar(50)'),
			S.x.value('SemanticTypeUI[1]','varchar(10)'),
			S.x.value('SemanticTypeName[1]','varchar(50)')
		FROM [Profile.Data].[Concept.Mesh.File] CROSS APPLY Data.nodes('//SemanticType') AS S(x)
		WHERE Name = 'SemGroups.xml'

	-- Extract items from MeSH2011.xml
	INSERT INTO [Profile.Data].[Concept.Mesh.XML] (DescriptorUI, MeSH)
		SELECT D.x.value('DescriptorUI[1]','varchar(10)'), D.x.query('.')
			FROM [Profile.Data].[Concept.Mesh.File] CROSS APPLY Data.nodes('//DescriptorRecord') AS D(x)
			WHERE Name = 'MeSH.xml'


	---------------------------------------
	-- Parse MeSH XML and populate tables
	---------------------------------------


	INSERT INTO [Profile.Data].[Concept.Mesh.Descriptor] (DescriptorUI, DescriptorName)
		SELECT DescriptorUI, MeSH.value('DescriptorRecord[1]/DescriptorName[1]/String[1]','varchar(255)')
			FROM [Profile.Data].[Concept.Mesh.XML]

	INSERT INTO [Profile.Data].[Concept.Mesh.Qualifier] (DescriptorUI, QualifierUI, DescriptorName, QualifierName, Abbreviation)
		SELECT	m.DescriptorUI,
				Q.x.value('QualifierReferredTo[1]/QualifierUI[1]','varchar(10)'),
				m.MeSH.value('DescriptorRecord[1]/DescriptorName[1]/String[1]','varchar(255)'),
				Q.x.value('QualifierReferredTo[1]/QualifierName[1]/String[1]','varchar(255)'),
				Q.x.value('Abbreviation[1]','varchar(2)')
			FROM [Profile.Data].[Concept.Mesh.XML] m CROSS APPLY MeSH.nodes('//AllowableQualifier') AS Q(x)

	SELECT	m.DescriptorUI,
			C.x.value('ConceptUI[1]','varchar(10)') ConceptUI,
			m.MeSH.value('DescriptorRecord[1]/DescriptorName[1]/String[1]','varchar(255)') DescriptorName,
			C.x.value('@PreferredConceptYN[1]','varchar(1)') PreferredConceptYN,
			C.x.value('ConceptRelationList[1]/ConceptRelation[1]/@RelationName[1]','varchar(3)') RelationName,
			C.x.value('ConceptName[1]/String[1]','varchar(255)') ConceptName,
			C.x.query('.') ConceptXML
		INTO #c
		FROM [Profile.Data].[Concept.Mesh.XML] m 
			CROSS APPLY MeSH.nodes('//Concept') AS C(x)

	INSERT INTO [Profile.Data].[Concept.Mesh.Term] (DescriptorUI, ConceptUI, TermUI, TermName, DescriptorName, PreferredConceptYN, RelationName, ConceptName, ConceptPreferredTermYN, IsPermutedTermYN, LexicalTag)
		SELECT	DescriptorUI,
				ConceptUI,
				T.x.value('TermUI[1]','varchar(10)'),
				T.x.value('String[1]','varchar(255)'),
				DescriptorName,
				PreferredConceptYN,
				RelationName,
				ConceptName,
				T.x.value('@ConceptPreferredTermYN[1]','varchar(1)'),
				T.x.value('@IsPermutedTermYN[1]','varchar(1)'),
				T.x.value('@LexicalTag[1]','varchar(3)')
			FROM #c C CROSS APPLY ConceptXML.nodes('//Term') AS T(x)

	INSERT INTO [Profile.Data].[Concept.Mesh.SemanticType] (DescriptorUI, SemanticTypeUI, SemanticTypeName)
		SELECT DISTINCT 
				m.DescriptorUI,
				S.x.value('SemanticTypeUI[1]','varchar(10)') SemanticTypeUI,
				S.x.value('SemanticTypeName[1]','varchar(50)') SemanticTypeName
			FROM [Profile.Data].[Concept.Mesh.XML] m 
				CROSS APPLY MeSH.nodes('//SemanticType') AS S(x)

	INSERT INTO [Profile.Data].[Concept.Mesh.SemanticGroup] (DescriptorUI, SemanticGroupUI, SemanticGroupName)
		SELECT DISTINCT t.DescriptorUI, g.SemanticGroupUI, g.SemanticGroupName
			FROM [Profile.Data].[Concept.Mesh.SemanticGroupType] g, [Profile.Data].[Concept.Mesh.SemanticType] t
			WHERE g.SemanticTypeUI = t.SemanticTypeUI

	INSERT INTO [Profile.Data].[Concept.Mesh.Tree] (DescriptorUI, TreeNumber)
		SELECT	m.DescriptorUI,
				T.x.value('.','varchar(255)')
			FROM [Profile.Data].[Concept.Mesh.XML] m 
				CROSS APPLY MeSH.nodes('//TreeNumber') AS T(x)

	INSERT INTO [Profile.Data].[Concept.Mesh.TreeTop] (TreeNumber, DescriptorName)
		SELECT	T.x.value('.','varchar(255)'),
				m.MeSH.value('DescriptorRecord[1]/DescriptorName[1]/String[1]','varchar(255)')
			FROM [Profile.Data].[Concept.Mesh.XML] m 
				CROSS APPLY MeSH.nodes('//TreeNumber') AS T(x)

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Concept.Mesh.GetSimilarMesh]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DescriptorName NVARCHAR(255)
 	SELECT @DescriptorName = d.DescriptorName
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n,
			[Profile.Data].[Concept.Mesh.Descriptor] d
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
			AND m.InternalID = d.DescriptorUI

 	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	;with a as (
		select SimilarConcept DescriptorName, Weight, SortOrder
		from [Profile.Cache].[Concept.Mesh.SimilarConcept]
		where meshheader = @DescriptorName
	), b as (
		select top 10 DescriptorName, Weight, (select count(*) from a) TotalRecords, SortOrder
		from a
	)
	 SELECT b.*, @baseURI + cast(m.NodeID as varchar(50)) ObjectURI
		 FROM [RDF.Stage].[InternalNodeMap] m, [Profile.Data].[Concept.Mesh.Descriptor] d, b
		 WHERE m.Class = 'http://www.w3.org/2004/02/skos/core#Concept' AND m.InternalType = 'MeshDescriptor'
			AND m.InternalID = d.DescriptorUI AND d.DescriptorName = b.DescriptorName

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [RDF.].[fnURI2NodeID] (
	@URI	nvarchar(4000)
) 
RETURNS bigint
AS
BEGIN
	DECLARE @result bigint
	IF @URI IS NULL
		SELECT @result = NULL
	ELSE
		SELECT @result = NodeID
			FROM [RDF.].Node
			WHERE ValueHash = [RDF.].fnValueHash(null,null,@URI)
	RETURN @result
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION  [Utility.NLP].[fnPorterEndsCVC]
	(
		@Word nvarchar(4000)
	)
RETURNS bit
AS
BEGIN
--*o  - the stem ends cvc, where the second c is not W, X or Y (e.g. -WIL, -HOP).

--declaring local variables
DECLARE @pattern NVARCHAR(3), @ret bit


SELECT @ret = 0

--'check to see if atleast 3 characters are present
If LEN(@Word) >= 3
    BEGIN
	-- find out the CVC pattern
	-- we need to check only the last three characters
	SELECT @pattern = RIGHT( [Utility.NLP].fnPorterCVCpattern(@Word),3)
	-- check to see if the letters in str match the sequence cvc
	IF @pattern = N'cvc' AND CHARINDEX(RIGHT(@Word,1), N'wxy') = 0
		SELECT @ret = 1
    END
RETURN @Ret
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.Application].[fnEncryptBase64RC4]( @strInput VARCHAR(max), @strPassword VARCHAR(100) ) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN [Utility.Application].fnBinaryToBase64(
				CONVERT(VARBINARY(max),
							[Utility.Application].[fnEncryptRC4](@strInput,@strPassword)
						)
			)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.Application].[fnDecryptBase64RC4]( @strInput VARCHAR(max), @strPassword VARCHAR(100) ) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN [Utility.Application].[fnEncryptRC4](
				[Utility.Application].fnBase64ToBinary(@strInput),
				@strPassword
			)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION  [Utility.NLP].[fnPorterCountm]
	(
		@Word nvarchar(4000)
	)
RETURNS tinyint
AS
BEGIN

--A \consonant\ in a word is a letter other than A, E, I, O or U, and other
--than Y preceded by a consonant. (The fact that the term `consonant' is
--defined to some extent in terms of itself does not make it ambiguous.) So in
--TOY the consonants are T and Y, and in SYZYGY they are S, Z and G. If a
--letter is not a consonant it is a \vowel\.

--declaring local variables
DECLARE @pattern nvarchar(4000), @ret tinyint, @i int, @flag bit

--initializing
SELECT @ret = 0, @flag = 0,  @i = 1

If Len(@Word) > 0
    BEGIN
	--find out the CVC pattern
	SELECT @pattern =  [Utility.NLP].fnPorterCVCpattern(@Word)
	--counting the number of m's...
	WHILE @i <= LEN(@pattern)
	    BEGIN
        	IF SUBSTRING(@pattern,@i,1) = N'v' OR @flag = 1
		    BEGIN
			SELECT @flag = 1
		        IF SUBSTRING(@pattern,@i,1) = N'c'
			    SELECT @ret = @ret + 1, @flag = 0
		    END
		SELECT @i = @i + 1
	    END
    END

    RETURN @Ret
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION  [Utility.NLP].[fnPorterContainsVowel]
	(
		@Word nvarchar(4000)
	)
RETURNS bit
AS
BEGIN

--checking word to see if vowels are present
DECLARE @pattern nvarchar(4000), @ret bit

SET @ret = 0

IF LEN(@Word) > 0
    BEGIN
    	--find out the CVC pattern
    	SELECT @pattern =  [Utility.NLP].fnPorterCVCpattern(@Word)
	--check to see if the return pattern contains a vowel
    	IF CHARINDEX( N'v',@pattern) > 0
	  SELECT @ret = 1
    END
RETURN @Ret
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Ontology.Import].[fnGetPropertyTree]
(
	-- Add the parameters for the function here
	@property nvarchar(1000) = NULL,
	@depth int = 0
)
RETURNS xml
AS
BEGIN
	-- Declare the return variable here
	DECLARE @x xml

	-- select [Ontology.Import].[fnGetPropertyTree](null,0)

	if @property is null
		select @x = (
				select Subject as "property/@name", @depth as "property/@depth", Object as "property/@type",
					[Ontology.Import].[fnGetPropertyTree](Subject,@depth+1) as "property"
				from (
					select Subject, Object
						from [Ontology.Import].[Triple] a
						where Object in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
							and not exists (
								select * 
								from [Ontology.Import].[Triple] b 
								where b.Predicate = 'http://www.w3.org/2000/01/rdf-schema#subPropertyOf'
									and b.Subject = a.Subject
							)
					union all
					select Object, 'http://www.w3.org/2002/07/owl#DatatypeProperty'
						from [Ontology.Import].[Triple] a
						where a.Predicate = 'http://www.w3.org/2000/01/rdf-schema#subPropertyOf'
							and not exists (
								select * from [Ontology.Import].[Triple] b
								where b.Object in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
									and a.Object = b.Subject
							)
				) t
				order by Subject
				for xml path(''), type
		)
	else
		select @x = (
				select Subject as "property/@name", @depth as "property/@depth", Object as "property/@type",
					[Ontology.Import].[fnGetPropertyTree](Subject,@depth+1) as "property"
				from [Ontology.Import].[Triple] a
				where Object in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
					and exists (
						select * 
						from [Ontology.Import].[Triple] b 
						where b.Predicate = 'http://www.w3.org/2000/01/rdf-schema#subPropertyOf'
							and b.Object = @property
							and b.Subject = a.Subject
					)
				order by Subject
				for xml path(''), type
		)

	-- Return the result of the function
	RETURN @x

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Ontology.Import].[fnGetClassTree]
(
	-- Add the parameters for the function here
	@class nvarchar(1000) = NULL,
	@depth int = 0
)
RETURNS xml
AS
BEGIN
	-- Declare the return variable here
	DECLARE @x xml

	-- select [Ontology.Import].fnGetClassTree(null,0)

	if @class is null
		select @x = (
				select Subject as "class/@name", @depth as "class/@depth", @class as "class/@parent",
					[Ontology.Import].fnGetClassTree(Subject,@depth+1) as "class"
				from (
					select Subject
						from [Ontology.Import].[Triple] a
						where Object = 'http://www.w3.org/2002/07/owl#Class'
							and not exists (
								select * 
								from [Ontology.Import].[Triple] b 
								where b.Predicate = 'http://www.w3.org/2000/01/rdf-schema#subClassOf'
									and b.Object not like 'http://profiles.catalyst.harvard.edu/ontology/nodeID#%'
									and b.Subject = a.Subject
							)
					union all
					select Object
						from [Ontology.Import].[Triple] a
						where a.Predicate = 'http://www.w3.org/2000/01/rdf-schema#subClassOf'
							and not exists (
								select * from [Ontology.Import].[Triple] b
								where b.Object = 'http://www.w3.org/2002/07/owl#Class'
									and a.Object = b.Subject
							)
							and a.Object not like 'http://profiles.catalyst.harvard.edu/ontology/nodeID#%'
				) t
				order by Subject
				for xml path(''), type
		)
	else
		select @x = (
				select Subject as "class/@name", @depth as "class/@depth", @class as "class/@parent",
					[Ontology.Import].fnGetClassTree(Subject,@depth+1) as "class"
				from [Ontology.Import].[Triple] a
				where Object = 'http://www.w3.org/2002/07/owl#Class'
					and exists (
						select * 
						from [Ontology.Import].[Triple] b 
						where b.Predicate = 'http://www.w3.org/2000/01/rdf-schema#subClassOf'
							and b.Object = @class
							and b.Subject = a.Subject
					)
				order by Subject
				for xml path(''), type
		)

	-- Return the result of the function
	RETURN @x

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[ConnectionDetails.Person.HasResearchArea.GetData]
	@subject BIGINT,
	@object BIGINT,
	@SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @subject

	DECLARE @MeshHeader NVARCHAR(255)
 	SELECT @MeshHeader = d.DescriptorName
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n,
			[Profile.Data].[Concept.Mesh.Descriptor] d
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @object
			AND m.InternalID = d.DescriptorUI
	
	;with a as (
		select m.meshheader, m.pmid, m.topicweight, m.authorweight, m.yearweight, m.uniquenessweight, m.meshweight overallweight,
			cast([Profile.Cache].[fnPublication.Pubmed.General2Reference](g.pmid, ArticleDay, ArticleMonth, ArticleYear, ArticleTitle, Authors, AuthorListCompleteYN, Issue, JournalDay, JournalMonth, JournalYear, MedlineDate, MedlinePgn, MedlineTA, Volume, 0) as varchar(8000)) Reference,
			'This phrase is used in ' 
				+ cast(c.numpublications as varchar(10)) 
				+ ' publication' + (case when c.numpublications = 1 then '' else 's' end)
				+ ' by '
				+ cast(c.numfaculty as varchar(10))
				+ ' author' + (case when c.numfaculty = 1 then '' else 's' end)
				+ '.' as UniquenessWeightStr,
			(case when m.topicweight = 1 then 'MeSH major topic' else 'MeSH minor topic' end) TopicWeightStr,
			(case when m.authorweight = 1 then 'First or senior author' when authorweight = 0.25 then 'Middle author' else 'Default author weight' end) AuthorWeightStr,
			(case when g.pubdate < '1/1/1902' then 'Unknown publication date' else 'Published in '+cast(year(g.pubdate) as varchar(10)) end) YearWeightStr
		from [Profile.Cache].[Concept.Mesh.PersonPublication] m, [Profile.Data].[Publication.PubMed.General] g, [Profile.Cache].[Concept.Mesh.Count] c
		where m.personid = @PersonID and m.meshheader = @MeshHeader and m.pmid = g.pmid and m.meshheader = c.meshheader
	), b as (
		select count(*) PublicationCount, sum(overallweight) TotalOverallWeight
		from a
	)
	select *
	from a, b
	order by overallweight desc, pmid

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[ConnectionDetails.Person.CoAuthorOf.GetData]
	@subject BIGINT,
	@object BIGINT,
	@SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @subject
 
	DECLARE @PersonID2 INT
 	SELECT @PersonID2 = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @object

	;with c as (
		select a.pmid, a.authorweight a1, b.authorweight a2, a.YearWeight y, a.pubyear d, (a.authorweight * b.authorweight * a.YearWeight) w,
			a.authorposition ap1, b.authorposition ap2
		from [Profile.Cache].[Publication.PubMed.AuthorPosition] a, [Profile.Cache].[Publication.PubMed.AuthorPosition] b
		where a.pmid = b.pmid and a.personid = @PersonID and b.personid = @PersonID2
	), d as (
		select count(*) n, max(d) d, sum(w) tw
		from c
	)
	select @PersonID PersonID1, @PersonID2 PersonID2,
		d.n PublicationCount, d.tw TotalOverallWeight,
		c.a1 AuthorWeight1, c.a2 AuthorWeight2, c.y YearWeight, c.d ArticleYear, c.w OverallWeight, c.pmid PMID,
		(case c.ap1 when 'F' then 'First author' when 'S' then 'First Author' when 'L' then 'Senior Author' when 'M' then 'Middle Author' else 'Default author weight' end) AuthorWeight1Str,
		(case c.ap2 when 'F' then 'First author' when 'S' then 'First Author' when 'L' then 'Senior Author' when 'M' then 'Middle Author' else 'Default author weight' end) AuthorWeight2Str,
		(case when g.pubdate < '1/1/1902' then 'Unknown publication date' else 'Published in '+cast(year(g.pubdate) as varchar(10)) end) YearWeightStr,
		[Profile.Cache].[fnPublication.Pubmed.General2Reference](g.pmid, ArticleDay, ArticleMonth, ArticleYear, ArticleTitle, Authors, AuthorListCompleteYN, Issue, JournalDay, JournalMonth, JournalYear, MedlineDate, MedlinePgn, MedlineTA, Volume, 0) Reference
	from c, d, [Profile.Data].[Publication.PubMed.General] g
	where c.pmid = g.pmid
	order by c.w desc

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Framework.].[CreateInstallData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @x xml

	select @x = (
		select
			(
				select
					--------------------------------------------------------
					-- [Framework.]
					--------------------------------------------------------
					(
						select	'[Framework.].[Parameter]' 'Table/@Name',
								(
									select	ParameterID 'ParameterID', 
											Value 'Value'
									from [Framework.].[Parameter]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Framework.].[RestPath]' 'Table/@Name',
								(
									select	ApplicationName 'ApplicationName',
											Resolver 'Resolver'
									from [Framework.].[RestPath]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Framework.].[Job]' 'Table/@Name',
								(
									select	JobID 'JobID',
											JobGroup 'JobGroup',
											Step 'Step',
											IsActive 'IsActive',
											Script 'Script',
											Status 'Status',
											LastStart 'LastStart',
											LastEnd 'LastEnd',
											ErrorCode 'ErrorCode',
											ErrorMsg 'ErrorMsg'
									from [Framework.].[Job]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Framework.].[JobGroup]' 'Table/@Name',
								(
									SELECT  JobGroup 'JobGroup',
											Name 'Name',
											Type 'Type',
											Description 'Description'	
									from [Framework.].JobGroup
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [Ontology.]
					--------------------------------------------------------
					(
						select	'[Ontology.].[ClassGroup]' 'Table/@Name',
								(
									select	ClassGroupURI 'ClassGroupURI',
											_ClassGroupLabel 'ClassGroupLabel',
											SortOrder 'SortOrder'
									from [Ontology.].[ClassGroup]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[ClassGroupClass]' 'Table/@Name',
								(
									select	ClassGroupURI 'ClassGroupURI',
											ClassURI 'ClassURI',
											_ClassLabel 'ClassLabel',
											SortOrder 'SortOrder'
									from [Ontology.].[ClassGroupClass]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[ClassProperty]' 'Table/@Name',
								(
									select	ClassPropertyID 'ClassPropertyID',
											Class 'Class',
											NetworkProperty 'NetworkProperty',
											Property 'Property',
											IsDetail 'IsDetail',
											Limit 'Limit',
											IncludeDescription 'IncludeDescription',
											IncludeNetwork 'IncludeNetwork',
											SearchWeight 'SearchWeight',
											CustomDisplay 'CustomDisplay',
											CustomEdit 'CustomEdit',
											ViewSecurityGroup 'ViewSecurityGroup',
											EditSecurityGroup 'EditSecurityGroup',
											EditPermissionsSecurityGroup 'EditPermissionsSecurityGroup',
											EditExistingSecurityGroup 'EditExistingSecurityGroup',
											EditAddNewSecurityGroup 'EditAddNewSecurityGroup',
											EditAddExistingSecurityGroup 'EditAddExistingSecurityGroup',
											EditDeleteSecurityGroup 'EditDeleteSecurityGroup',
											MinCardinality 'MinCardinality',
											MaxCardinality 'MaxCardinality',
											CustomDisplayModule 'CustomDisplayModule',
											CustomEditModule 'CustomEditModule',
											_ClassNode '_ClassNode',
											_NetworkPropertyNode '_NetworkPropertyNode',
											_PropertyNode '_PropertyNode',
											_TagName '_TagName',
											_PropertyLabel '_PropertyLabel', 
											_NumberOfNodes '_NumberOfNodes',
											_NumberOfTriples '_NumberOfTriples'
									from [Ontology.].ClassProperty
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[DataMap]' 'Table/@Name',
						
								(
									select  DataMapID 'DataMapID',
											DataMapGroup 'DataMapGroup',
											IsAutoFeed 'IsAutoFeed',
											Graph 'Graph',
											Class 'Class',
											NetworkProperty 'NetworkProperty',
											Property 'Property',
											MapTable 'MapTable',
											sInternalType 'sInternalType',
											sInternalID 'sInternalID',
											cClass 'cClass',
											cInternalType 'cInternalType',
											cInternalID 'cInternalID',
											oClass 'oClass',
											oInternalType 'oInternalType',
											oInternalID 'oInternalID',
											oValue 'oValue',
											oDataType 'oDataType',
											oLanguage 'oLanguage',
											oStartDate 'oStartDate',
											oStartDatePrecision 'oStartDatePrecision',
											oEndDate 'oEndDate',
											oEndDatePrecision 'oEndDatePrecision',
											oObjectType 'oObjectType',
											Weight 'Weight',
											OrderBy 'OrderBy',
											ViewSecurityGroup 'ViewSecurityGroup',
											EditSecurityGroup 'EditSecurityGroup',
											_ClassNode '_ClassNode',
											_NetworkPropertyNode '_NetworkPropertyNode',
											_PropertyNode '_PropertyNode'
									from [Ontology.].[DataMap]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[Namespace]' 'Table/@Name',
								(
									select	URI 'URI',
											Prefix 'Prefix'
									from [Ontology.].[Namespace]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[PropertyGroup]' 'Table/@Name',
								(
									select	PropertyGroupURI 'PropertyGroupURI',
											SortOrder 'SortOrder',
											_PropertyGroupLabel '_PropertyGroupLabel',
											_PropertyGroupNode '_PropertyGroupNode',
											_NumberOfNodes '_NumberOfNodes'
									from [Ontology.].[PropertyGroup]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Ontology.].[PropertyGroupProperty]' 'Table/@Name',
								(
									select	PropertyGroupURI 'PropertyGroupURI',
											PropertyURI 'PropertyURI',
											SortOrder 'SortOrder',
											CustomDisplayModule 'CustomDisplayModule',
											CustomEditModule 'CustomEditModule',
											_PropertyGroupNode '_PropertyGroupNode',
											_PropertyNode '_PropertyNode',
											_TagName '_TagName',
											_PropertyLabel '_PropertyLabel',
											_NumberOfNodes '_NumberOfNodes'
									from [Ontology.].[PropertyGroupProperty]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [Ontology.Presentation]
					--------------------------------------------------------
					(
						select	'[Ontology.Presentation].[XML]' 'Table/@Name',
								(
									select	PresentationID 'PresentationID', 
											type 'type',
											subject 'subject',
											predicate 'predicate',
											object 'object',
											presentationXML 'presentationXML'
									from [Ontology.Presentation].[XML]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [RDF.Security]
					--------------------------------------------------------
					(
						select	'[RDF.Security].[Group]' 'Table/@Name',
								(
									select	SecurityGroupID 'SecurityGroupID',
											Label 'Label',
											HasSpecialViewAccess 'HasSpecialViewAccess',
											HasSpecialEditAccess 'HasSpecialEditAccess',
											Description 'Description'
									from [RDF.Security].[Group]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [Utility.NLP]
					--------------------------------------------------------
					(
						select	'[Utility.NLP].[ParsePorterStemming]' 'Table/@Name',
								(
									select	step 'Step',
											Ordering 'Ordering',
											phrase1 'phrase1',
											phrase2 'phrase2'
									from [Utility.NLP].ParsePorterStemming
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Utility.NLP].[StopWord]' 'Table/@Name',
								(
									select	word 'word',
											stem 'stem',
											scope 'scope'
									from [Utility.NLP].[StopWord]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					(
						select	'[Utility.NLP].[Thesaurus.Source]' 'Table/@Name',
								(
									select	Source 'Source',
											SourceName 'SourceName'
									from [Utility.NLP].[Thesaurus.Source]
									for xml path('Row'), type
								) 'Table'
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [User.Session]
					--------------------------------------------------------
					(
						select	'[User.Session].Bot' 'Table/@Name',
							(
								SELECT UserAgent 'UserAgent' 
								  FROM [User.Session].Bot
				  					for xml path('Row'), type
			   				) 'Table'  
						for xml path(''), type
					),
					--------------------------------------------------------
					-- [Direct.]
					--------------------------------------------------------
					(
						select	'[Direct.].[Sites]' 'Table/@Name',
							(
								SELECT SiteID 'SiteID',
										BootstrapURL 'BootstrapURL',
										SiteName 'SiteName',
										QueryURL 'QueryURL',
										SortOrder 'SortOrder',
										IsActive 'IsActive'  
								  FROM [Direct.].[Sites] 
			 					for xml path('Row'), type
					 		) 'Table'   
						for xml path(''), TYPE
					),
					--------------------------------------------------------
					-- [Profile.Data]
					--------------------------------------------------------
					(
						select	'[Profile.Data].[Publication.Type]' 'Table/@Name',
							(
								SELECT	pubidtype_id 'pubidtype_id',
										name 'name',
										sort_order 'sort_order'
								  FROM [Profile.Data].[Publication.Type]
				  					for xml path('Row'), type
			   				) 'Table'  
						for xml path(''), type
					),
					(
						select	'[Profile.Data].[Publication.MyPub.Category]' 'Table/@Name',
							(
								SELECT	HmsPubCategory 'HmsPubCategory',
										CategoryName 'CategoryName'
								  FROM [Profile.Data].[Publication.MyPub.Category]
				  					for xml path('Row'), type
							) 'Table'  
						for xml path(''), type
					)	
				for xml path(''), type
			) 'Import'
		for xml path(''), type
	)

	insert into [Framework.].[InstallData] (Data)
		select @x


   --Use to generate select lists for new tables
   --SELECT    c.name +  ' ''' + name + ''','
   --FROM sys.columns c  
   --WHERE object_id IN (SELECT object_id FROM sys.tables WHERE name = 'Publication.MyPub.Category')  

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.Presentation].[ConvertXML2Tables]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	truncate table [Ontology.Presentation].[General]
	insert into [Ontology.Presentation].[General]
		select	PresentationID, 
				Type,
				Subject,
				Predicate,
				Object,
				PresentationXML.value('Presentation[1]/PageOptions[1]/@Columns[1]','varchar(max)') PageColumns,
				PresentationXML.value('Presentation[1]/WindowName[1]','varchar(max)') WindowName,
				PresentationXML.value('Presentation[1]/PageTitle[1]','varchar(max)') PageTitle,
				PresentationXML.value('Presentation[1]/PageBackLinkName[1]','varchar(max)') PageBackLinkName,
				PresentationXML.value('Presentation[1]/PageBackLinkURL[1]','varchar(max)') PageBackLinkURL,
				PresentationXML.value('Presentation[1]/PageSubTitle[1]','varchar(max)') PageSubTitle,
				PresentationXML.value('Presentation[1]/PageDescription[1]','varchar(max)') PageDescription,
				PresentationXML.value('Presentation[1]/PanelTabType[1]','varchar(max)') PanelTabType,
				(CASE WHEN CAST(PresentationXML.query('Presentation[1]/ExpandRDFList[1]/*') AS NVARCHAR(MAX)) <> ''
					THEN PresentationXML.query('Presentation[1]/ExpandRDFList[1]/*')
					ELSE NULL END) ExpandRDFList
			from [Ontology.Presentation].[XML]

	truncate table [Ontology.Presentation].[Panel]
	insert into [Ontology.Presentation].[Panel]
		select	o.PresentationID,
				p.x.value('@Type','varchar(max)') Type, 
				IsNull(p.x.value('@TabSort','varchar(max)'),-1) TabSort, 
				p.x.value('@TabType','varchar(max)') TabType,
				p.x.value('@Alias','varchar(max)') Alias,
				p.x.value('@Name','varchar(max)') Name,
				p.x.value('@Icon','varchar(max)') Icon,
				p.x.value('@DisplayRule','varchar(max)') DisplayRule,
				(CASE WHEN CAST(p.x.query('./*') AS NVARCHAR(MAX)) <> ''
					THEN p.x.query('./*')
					ELSE NULL END) ModuleXML
			from [Ontology.Presentation].[XML] o CROSS APPLY o.PresentationXML.nodes('Presentation[1]/PanelList[1]/Panel') as p(x)
			where p.x.value('@Type','varchar(max)') <> ''

	-- SELECT * FROM [Ontology.Presentation].[General]
	-- SELECT * FROM [Ontology.Presentation].[Panel]

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.Import].[ConvertTriple2OWL]
	@OWL varchar(50),
	@Graph bigint = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- This stored procedure is currently only intended for use with @OWL = 'PRNS_1.0' (and @Graph = 3)

	select t.subject, n.prefix+':'+right(t.predicate,len(t.predicate)-len(n.uri)) predicate, t.object
		into #t
		from [Ontology.Import].Triple t, [Ontology.].Namespace n
		where t.OWL = @OWL and t.Predicate like n.URI+'%'
		order by t.subject, predicate, t.object

	declare @z as varchar(max)

	select @z =
		(select 
				'<rdf:Description rdf:about="'+subject+'">'
				+(
					select '<'+v.predicate+' rdf:resource="'+v.object+'"/>' 
					from #t v 
					where v.subject = t.subject 
					order by v.predicate, v.object
					for xml path(''), type
				).value('(./text())[1]','nvarchar(max)')
				+'</rdf:Description>'
			from (select distinct subject from #t) t
			order by t.subject
			for xml path(''), type
		).value('(./text())[1]','nvarchar(max)')

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + @z + '</rdf:RDF>'

	-- select cast(@x as xml) RDF
	BEGIN TRY
		begin transaction

			delete 
				from [Ontology.Import].[OWL] 
				where Name = @OWL

			insert into [Ontology.Import].[OWL] (Name, Data, Graph)
				select @OWL, cast(@x as xml), @Graph

		commit transaction
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK

		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)

	END CATCH		


	-- select * from [Ontology.Import].[OWL]

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Organization.GetInstitutions]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT x.InstitutionID, x.InstitutionName, x.InstitutionAbbreviation, n.NodeID, n.Value URI
		FROM (
				SELECT CAST(MAX(InstitutionID) AS VARCHAR(50)) InstitutionID,
						LTRIM(RTRIM(InstitutionName)) InstitutionName, 
						MIN(institutionabbreviation) InstitutionAbbreviation
				FROM [Profile.Data].[Organization.Institution] WITH (NOLOCK)
				GROUP BY LTRIM(RTRIM(InstitutionName))
			) x 
			LEFT OUTER JOIN [RDF.Stage].InternalNodeMap m WITH (NOLOCK)
				ON m.class = 'http://xmlns.com/foaf/0.1/Organization'
					AND m.InternalType = 'Institution'
					AND m.InternalID = CAST(x.InstitutionID AS VARCHAR(50))
			LEFT OUTER JOIN [RDF.].Node n WITH (NOLOCK)
				ON m.NodeID = n.NodeID
					AND n.ViewSecurityGroup = -1
		ORDER BY InstitutionName

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Organization.GetDivisions]

AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT x.DivisionID, x.DivisionName, n.NodeID, n.Value URI
		FROM (
				SELECT *
				FROM [Profile.Data].[Organization.Division] WITH (NOLOCK)
				WHERE LTRIM(RTRIM(DivisionName))<>''
			) x 
			LEFT OUTER JOIN [RDF.Stage].InternalNodeMap m WITH (NOLOCK)
				ON m.class = 'http://xmlns.com/foaf/0.1/Organization'
					AND m.InternalType = 'Division'
					AND m.InternalID = CAST(x.DivisionID AS VARCHAR(50))
			LEFT OUTER JOIN [RDF.].Node n WITH (NOLOCK)
				ON m.NodeID = n.NodeID
					AND n.ViewSecurityGroup = -1
		ORDER BY DivisionName

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Organization.GetDepartments]

AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT x.DepartmentID, x.DepartmentName Department, n.NodeID, n.Value URI
		FROM (
				SELECT *
				FROM [Profile.Data].[Organization.Department] WITH (NOLOCK)
				WHERE Visible = 1 AND LTRIM(RTRIM(DepartmentName))<>''
			) x 
			LEFT OUTER JOIN [RDF.Stage].InternalNodeMap m WITH (NOLOCK)
				ON m.class = 'http://xmlns.com/foaf/0.1/Organization'
					AND m.InternalType = 'Department'
					AND m.InternalID = CAST(x.DepartmentID AS VARCHAR(50))
			LEFT OUTER JOIN [RDF.].Node n WITH (NOLOCK)
				ON m.NodeID = n.NodeID
					AND n.ViewSecurityGroup = -1
		ORDER BY Department

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [RDF.Stage].[LoadTriplesFromOntology]
	@OWL NVARCHAR(100) = NULL,
	@Truncate BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	if @Truncate = 1
		truncate table [RDF.Stage].Triple
 
	insert into [RDF.Stage].Triple (
			sURI,sViewSecurityGroup,sEditSecurityGroup,
			pProperty,pViewSecurityGroup,pEditSecurityGroup,
			oValue,oObjectType,oViewSecurityGroup,oEditSecurityGroup,
			tViewSecurityGroup,Weight,SortOrder,Graph)
		select	Subject, -1, -50,
				Predicate, -1, -50,
				Object, (case when Object like 'http%' then 0 else 1 end), -1, -50,
				-1, 1, row_number() over (partition by Subject, Predicate order by Object),
				Graph
		from [Ontology.Import].Triple
		where OWL = IsNull(@OWL,OWL)
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Person.GetFilters]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT x.PersonFilterID, x.PersonFilterCategory, x.PersonFilter, x.PersonFilterSort, n.NodeID, n.Value URI
		FROM (
				SELECT PersonFilterID, PersonFilterCategory, PersonFilter, PersonFilterSort
				FROM [Profile.Data].[Person.Filter]
			) x 
			LEFT OUTER JOIN [RDF.Stage].InternalNodeMap m WITH (NOLOCK)
				ON m.class = 'http://profiles.catalyst.harvard.edu/ontology/prns#PersonFilter'
					AND m.InternalType = 'PersonFilter'
					AND m.InternalID = CAST(x.PersonFilterID AS VARCHAR(50))
			LEFT OUTER JOIN [RDF.].Node n WITH (NOLOCK)
				ON m.NodeID = n.NodeID
					AND n.ViewSecurityGroup = -1
		ORDER BY PersonFilterSort

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Person.GetFacultyRanks]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT   facultyrank
  FROM (SELECT TOP 100 PERCENT
							 facultyrank,
							 facultyranksort
					FROM [Profile.Data].[Person.FacultyRank]
				 GROUP BY facultyrank,
							 facultyranksort
				 ORDER BY facultyranksort asc) a
		ORDER BY facultyranksort
	
 


END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [Profile.Data].[Person.GetAffiliations] (@PersonID INT)
AS
BEGIN
	SET NOCOUNT ON;	
		SELECT title,
					 InstitutionFullName,
					 DepartmentFullname,
					 DivisionFullname 
			FROM [Profile.Data].[Person.Affiliation] p
LEFT	JOIN [Profile.Data].[Organization.InstitutionFullName] i on i.institutionfullnameid=p.institutionfullnameid
LEFT	JOIN [Profile.Data].[Organization.DepartmentFullName] d on d.departmentfullnameid = p.departmentfullnameid
LEFT	JOIN [Profile.Data].[Organization.DivisionFullName] di on di.divisionfullnameid = p.divisionfullnameid
		 WHERE PersonID = @PersonID 
			 AND sortorder > 1 
  ORDER BY sortorder 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Person.FilterRelationship](
	[PersonID] [int] NOT NULL,
	[PersonFilterid] [int] NOT NULL,
 CONSTRAINT [PK_person_filter_relationships_1] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[PersonFilterid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[NetworkRadial.GetCoauthors]
@NodeID BIGINT, @SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE @PersonID1 INT
 
	SELECT @PersonID1 = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
		
	SELECT TOP 120
						personid,
						distance,
						numberofpaths,
						weight,
						w2,
						lastname,
						firstname,
						p,
						k,
						cast(-1 as bigint) nodeid,
						cast('' as varchar(400)) uri
			 INTO #network 
			 FROM ( 
							SELECT personid, 
										 distance, 
										 numberofpaths, 
										 weight, 
										 w2, 
										 p.lastname, 
										 p.firstname, 
										 p.numpublications p, 
										 ROW_NUMBER() OVER (PARTITION BY distance ORDER BY w2 DESC) k 
							  FROM [Profile.Cache].Person p
							  JOIN ( SELECT *, ROW_NUMBER() OVER (PARTITION BY personid2 ORDER BY distance, w2 DESC) k 
										FROM (
											SELECT personid2, 1 distance, n numberofpaths, w weight, w w2 
												FROM [Profile.Cache].[SNA.Coauthor]  
												WHERE personid1 = @personid1
											UNION ALL 
												SELECT b.personid2, 2 distance, b.n numberofpaths, b.w weight,a.w*b.w w2 
												FROM [Profile.Cache].[SNA.Coauthor] a JOIN [Profile.Cache].[SNA.Coauthor] b ON a.personid2 = b.personid1 
												WHERE a.personid1 = @personid1  
											UNION ALL 
												SELECT @personid1 personid2, 0 distance, 1 numberofpaths, 1 weight, 1 w2 
										) t 
									) t ON p.personid = t.personid2 
							  WHERE k = 1  AND p.IsActive = 1
						) t 
			WHERE k <= 80 
	ORDER BY distance, k
	
	UPDATE n
		SET n.NodeID = m.NodeID, n.URI = p.Value + cast(m.NodeID as varchar(50))
		FROM #network n, [RDF.Stage].InternalNodeMap m, [Framework.].Parameter p
		WHERE p.ParameterID = 'baseURI' AND m.InternalHash = [RDF.].fnValueHash(null,null,'http://xmlns.com/foaf/0.1/Person^^Person^^'+cast(n.PersonID as varchar(50)))
 
	DELETE FROM #network WHERE IsNull(URI,'') = ''	
	
 
	SELECT c.personid1 id1, c.personid2	id2, c.n, CAST(c.w AS VARCHAR) w, 
			(CASE WHEN YEAR(firstpubdate)<1980 THEN 1980 ELSE YEAR(firstpubdate) END) y1, 
			(CASE WHEN YEAR(lastpubdate)<1980 THEN 1980 ELSE YEAR(lastpubdate) END) y2,
			(case when c.personid1 = @personid1 or c.personid2 = @personid1 then 1 else 0 end) k,
			a.nodeid n1, b.nodeid n2, a.uri u1, b.uri u2
		into #network2
		from #network a
			JOIN #network b on a.personid < b.personid  
			JOIN [Profile.Cache].[SNA.Coauthor] c ON a.personid = c.personid1 and b.personid = c.personid2  
 
	;with a as (
		select id1, id2, w, k from #network2
		union all
		select id2, id1, w, k from #network2
	), b as (
		select a.*, row_number() over (partition by a.id1 order by a.w desc, a.id2) s
		from a, 
			(select id1 from a group by id1 having max(k) = 0) b,
			(select id1 from a group by id1 having max(k) > 0) c
		where a.id1 = b.id1 and a.id2 = c.id1
	)
	update n
		set n.k = 2
		from #network2 n, b
		where (n.id1 = b.id1 and n.id2 = b.id2 and b.s = 1) or (n.id1 = b.id2 and n.id2 = b.id1 and b.s = 1)
 
	update n
		set n.k = 3
		from #network2 n, (
			select *, row_number() over (order by k desc, w desc) r 
			from #network2 
		) r
		where n.id1=r.id1 and n.id2=r.id2 and n.k=0 and r.r<=360
 
	SELECT (
		SELECT personid "@id", nodeid "@nodeid", uri "@uri", distance "@d", p "@pubs", firstname "@fn", lastname "@ln", cast(w2 as varchar(50)) "@w2"
		FROM #network
		FOR XML PATH('NetworkPerson'),ROOT('NetworkPeople'),TYPE
	), (
		SELECT id1 "@id1", id2 "@id2", n "@n", cast(w as varchar(50)) "@w", y1 "@y1", y2 "@y2",
			n1 "@nodeid1", n2 "@nodeid2", u1 "@uri1", u2 "@uri2"
		FROM #network2
		WHERE k > 0
		FOR XML PATH('NetworkCoAuthor'),ROOT('NetworkCoAuthors'),TYPE
	)
	FOR XML PATH('LocalNetwork')
 
 
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Person.Photo](
	[PhotoID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[Photo] [varbinary](max) NULL,
	[PhotoLink] [nvarchar](max) NULL,
 CONSTRAINT [PK_photo] PRIMARY KEY CLUSTERED 
(
	[PhotoID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Person.GetUnGeocodedAddresses]	 
AS
BEGIN
	SET NOCOUNT ON;	

SELECT DISTINCT addressstring
  FROM [Profile.Data].Person
 WHERE (ISNULL(latitude ,0)=0
 		OR geoscore = 0)
and addressstring<>''


END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[NetworkTimeline.Person.HasResearchArea.GetData]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
 	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	;with a as (
		select t.*, g.pubdate
		from (
			select top 20 *, 
				--numpubsthis/sqrt(numpubsall+100)/sqrt((LastPublicationYear+1 - FirstPublicationYear)*1.00000) w
				--numpubsthis/sqrt(numpubsall+100)/((LastPublicationYear+1 - FirstPublicationYear)*1.00000) w
				--WeightNTA/((LastPublicationYear+2 - FirstPublicationYear)*1.00000) w
				weight w
			from [Profile.Cache].[Concept.Mesh.Person]
			where personid = @PersonID
			order by w desc, meshheader
		) t, [Profile.Cache].[Concept.Mesh.PersonPublication] m, [Profile.Data].[Publication.PubMed.General] g
		where t.meshheader = m.meshheader and t.personid = m.personid and m.pmid = g.pmid and year(g.pubdate) > 1900
	), b as (
		select min(firstpublicationyear)-1 a, max(lastpublicationyear)+1 b,
			cast(cast('1/1/'+cast(min(firstpublicationyear)-1 as varchar(10)) as datetime) as float) f,
			cast(cast('1/1/'+cast(max(lastpublicationyear)+1 as varchar(10)) as datetime) as float) g
		from a
	), c as (
		select a.*, (cast(pubdate as float)-f)/(g-f) x, a, b, f, g
		from a, b
	), d as (
		select meshheader, min(x) MinX, max(x) MaxX, avg(x) AvgX
				--, (select avg(cast(g.pubdate as float))
				--from resnav_people_hmsopen.dbo.pm_pubs_general g, (
				--	select distinct pmid
				--	from resnav_people_hmsopen.dbo.cache_pub_mesh m
				--	where m.meshheader = c.meshheader
				--) t
				--where g.pmid = t.pmid) AvgAllX
		from c
		group by meshheader
	)
	select c.*, d.MinX, d.MaxX, d.AvgX,	c.meshheader label, (select count(distinct meshheader) from a) n,
		@baseURI + cast(m.NodeID as varchar(50)) ObjectURI
		 --, (d.AvgAllX - c.f)/(c.g-c.f) AvgAllX
	from c, d, [Profile.Data].[Concept.Mesh.Descriptor] p, [RDF.Stage].[InternalNodeMap] m
	where c.meshheader = d.meshheader and d.meshheader = p.DescriptorName and p.DescriptorUI = m.InternalID
		and m.Class = 'http://www.w3.org/2004/02/skos/core#Concept' and m.InternalType = 'MeshDescriptor'
	order by AvgX, firstpublicationyear, lastpublicationyear, meshheader, pubdate

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.Cache].[History.UpdateTopSearchPhrase]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #TopSearchPhrase (
		TimePeriod CHAR(1) NOT NULL,
		Phrase VARCHAR(100) NOT NULL,
		NumberOfQueries INT
	)

	-- Get top day, week, and month phrases
	
	INSERT INTO #TopSearchPhrase (TimePeriod, Phrase, NumberOfQueries)
		SELECT TOP 10 'd', Phrase, COUNT(*) n
			FROM [Search.].[History.Phrase]
			WHERE NumberOfConnections > 0
				AND LEN(Phrase) <= 100
				AND IsBot = 0
				AND EndDate >= DATEADD(DAY,-1,GETDATE())
			GROUP BY Phrase
			ORDER BY n DESC

	INSERT INTO #TopSearchPhrase (TimePeriod, Phrase, NumberOfQueries)
		SELECT TOP 10 'w', Phrase, COUNT(*) n
			FROM [Search.].[History.Phrase]
			WHERE NumberOfConnections > 0
				AND LEN(Phrase) <= 100
				AND IsBot = 0
				AND EndDate >= DATEADD(WEEK,-1,GETDATE())
			GROUP BY Phrase
			ORDER BY n DESC

	INSERT INTO #TopSearchPhrase (TimePeriod, Phrase, NumberOfQueries)
		SELECT TOP 10 'm', Phrase, COUNT(*) n
			FROM [Search.].[History.Phrase]
			WHERE NumberOfConnections > 0
				AND LEN(Phrase) <= 100
				AND IsBot = 0
				AND EndDate >= DATEADD(MONTH,-1,GETDATE())
			GROUP BY Phrase
			ORDER BY n DESC

	-- Add phrases to try to get to 10 phrases per time period

	DECLARE @n INT
	
	SELECT @n = 10 - (SELECT COUNT(*) FROM #TopSearchPhrase WHERE TimePeriod = 'd')
	IF @n > 0
		INSERT INTO #TopSearchPhrase (TimePeriod, Phrase, NumberOfQueries)
			SELECT TOP(@n) 'd', Phrase, 0
				FROM #TopSearchPhrase
				WHERE TimePeriod = 'w'
					AND Phrase NOT IN (SELECT Phrase FROM #TopSearchPhrase WHERE TimePeriod = 'd')
				ORDER BY NumberOfQueries DESC

	SELECT @n = 10 - (SELECT COUNT(*) FROM #TopSearchPhrase WHERE TimePeriod = 'd')
	IF @n > 0
		INSERT INTO #TopSearchPhrase (TimePeriod, Phrase, NumberOfQueries)
			SELECT TOP(@n) 'd', Phrase, 0
				FROM #TopSearchPhrase
				WHERE TimePeriod = 'm'
					AND Phrase NOT IN (SELECT Phrase FROM #TopSearchPhrase WHERE TimePeriod = 'd')
				ORDER BY NumberOfQueries DESC

	SELECT @n = 10 - (SELECT COUNT(*) FROM #TopSearchPhrase WHERE TimePeriod = 'w')
	IF @n > 0
		INSERT INTO #TopSearchPhrase (TimePeriod, Phrase, NumberOfQueries)
			SELECT TOP(@n) 'w', Phrase, 0
				FROM #TopSearchPhrase
				WHERE TimePeriod = 'm'
					AND Phrase NOT IN (SELECT Phrase FROM #TopSearchPhrase WHERE TimePeriod = 'w')
				ORDER BY NumberOfQueries DESC

	-- Update the cache table

	TRUNCATE TABLE [Search.Cache].[History.TopSearchPhrase]
	INSERT INTO [Search.Cache].[History.TopSearchPhrase] (TimePeriod, Phrase, NumberOfQueries)
		SELECT TimePeriod, Phrase, NumberOfQueries 
			FROM #TopSearchPhrase

	--DROP TABLE #TopSearchPhrase
	--SELECT * FROM [Search.Cache].[History.TopSearchPhrase]
	
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION  [Utility.NLP].[fnPorterEndsDoubleCVC]
	(
		@Word nvarchar(4000)
	)
RETURNS bit
AS
BEGIN

--*o  - the stem ends cvc, where the second c is not W, X or Y (e.g. -WIL, -HOP).

--declaring local variables
DECLARE @pattern NVARCHAR(3), @ret bit

SET @ret = 0

--check to see if atleast 3 characters are present
IF Len(@Word) >= 3 
    BEGIN    
  	-- find out the CVC pattern
    	-- we need to check only the last three characters
	SELECT @pattern = RIGHT( [Utility.NLP].fnPorterCVCpattern(@Word),3)
	-- check to see if the letters in str match the sequence cvc
    	IF @pattern = N'cvc' AND 
	   CHARINDEX(RIGHT(@Word,1), N'wxy') = 0
		SELECT @ret = 1
    END
RETURN @Ret
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.].[GetClassCounts]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @s as xml
	select @s = (
		select 
			(
				select	
					g.ClassGroupURI as "@rdf_.._resource", 
					g._ClassGroupLabel as "rdfs_.._label", 
					'http://www.w3.org/2001/XMLSchema#int' as "prns_.._numberOfConnections/@rdf_.._datatype",
					g._NumberOfNodes as "prns_.._numberOfConnections",
					(select	c.ClassURI as "@rdf_.._resource",
							c._ClassLabel as "rdfs_.._label",
							'http://www.w3.org/2001/XMLSchema#int' as "prns_.._numberOfConnections/@rdf_.._datatype",
							c._NumberOfNodes as "prns_.._numberOfConnections"
						from [Ontology.].[ClassGroupClass] c
						where c.ClassGroupURI = g.ClassGroupURI
						order by c.SortOrder
						for xml path('prns_.._matchesClass'), type
					)
				from [Ontology.].[ClassGroup] g
				order by g.SortOrder
				for xml path('prns_.._matchesClassGroup'), type
			)
		for xml path('rdf_.._Description'), type
	)

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + replace(cast(@s as nvarchar(max)),'_.._',':') + '</rdf:RDF>'
	select cast(@x as xml) RDF

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Concept.Mesh.GetJournals]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DescriptorName NVARCHAR(255)
 	SELECT @DescriptorName = d.DescriptorName
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n,
			[Profile.Data].[Concept.Mesh.Descriptor] d
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
			AND m.InternalID = d.DescriptorUI

	select top 10 Journal, JournalTitle, Weight, NumJournals TotalRecords
		from [Profile.Cache].[Concept.Mesh.Journal]
		where meshheader = @DescriptorName

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[GetPropertyList]
	@RDF xml = NULL,
	@RDFStr nvarchar(max) = NULL,
	@PresentationXML xml,
	@RootPath nvarchar(max) = 'rdf:RDF[1]/rdf:Description[1]',
	@ShowAllProperties bit = 0,
	@CountsOnly bit = 0,
	@PropertyGroupURI varchar(400) = NULL,
	@PropertyURI varchar(400) = NULL,
	@returnTable bit = 0,
	@returnXML bit = 1,
	@returnXMLasStr bit = 0,
	@PropertyListXML xml = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-----------------------------------------------------
	-- Copy the @RDFStr value to the @RDF variable
	-----------------------------------------------------

	if (@RDF is null and @RDFStr is not null)
		select @RDF = cast(replace(@RDFStr,char(13),'&#13;') as xml)

	-----------------------------------------------------
	-- Define temp tables and variables
	-----------------------------------------------------

	create table #RDFData (
		ItemSortOrder int identity(0,1) primary key,
		TagName varchar(400),
		ObjectValue nvarchar(max),
		ObjectURI varchar(400),
		ObjectClass varchar(400),
		ObjectClassName varchar(max)
	)

	declare @sql nvarchar(max)



	-----------------------------------------------------
	-- Parse the RDF data
	-----------------------------------------------------

	select @sql = ''
	select @sql = @sql + ' '''+URI+''' as '+Prefix+','
		from [Ontology.].Namespace
	select @sql = left(@sql,len(@sql)-1)

	select @sql = '
		;WITH XMLNAMESPACES (
			'+@sql+'
		), RDFDescriptions as (
			select	z.value(''@rdf:about'',''varchar(max)'') About,
					z.value(''rdfs:label[1]'',''varchar(max)'') Label,
					(select top 1 t.ClassURI
						from (select x.value(''@rdf:resource[1]'',''varchar(max)'') ClassURI
								from z.nodes(''rdf:type'') as t(x)
							) t
							left outer join [Ontology.].ClassTreeDepth d
							on t.ClassURI = d.Class
						order by (case when d._TreeDepth is null then 1 else 0 end), d._TreeDepth desc
					) Class
			from (select @RDF as x) t cross apply x.nodes(''rdf:RDF[1]/rdf:Description'') as R(z)
		), RDFTagsTemp as (
			select	z.value(''namespace-uri(.)'',''varchar(max)'') NamespaceURI,
					z.value(''local-name(.)'',''varchar(max)'') LocalName,
					z.value(''@rdf:resource'',''varchar(max)'') Resource,
					z.value(''.'',''nvarchar(max)'') Value
			from (select @RDF.query('''+@RootPath+''') as x) t cross apply x.nodes(''rdf:Description/*'') as R(z)
		)
		select	o.Prefix+'':''+b.LocalName TagName, 
					Coalesce(a.Label,b.Resource,b.Value) ObjectValue, 
					b.Resource ObjectURI,
					a.Class ObjectClass,
					c.Label ObjectClassName
			from RDFTagsTemp b 
				inner join [Ontology.].[Namespace] o on o.URI = b.NamespaceURI
				left outer join RDFDescriptions a on b.Resource = a.About
				left outer join RDFDescriptions c on a.Class = c.About
		'

	insert into #RDFData (TagName, ObjectValue, ObjectURI, ObjectClass, ObjectClassName)
			EXEC sp_executesql @sql, N'@RDF xml', @RDF = @RDF

	--create nonclustered index idx_TagName on #RDFData(TagName)

	-----------------------------------------------------
	-- Parse the PresentationXML
	-----------------------------------------------------

	select p.*, s.Label ViewSecurityGroupLabel
		into #Properties
		from (
			select	R.p.value('../@URI','varchar(400)') PropertyGroupURI,
					R.p.value('../@Label','varchar(max)') PropertyGroupLabel,
					R.p.value('../@SortOrder','int') PropertyGroupSortOrder,
					R.p.value('@URI','varchar(400)') PropertyURI,
					R.p.value('@Label','varchar(max)') PropertyLabel,
					R.p.value('@SortOrder','int') PropertySortOrder,
					R.p.value('@TagName','varchar(400)') TagName,
					R.p.value('@CustomDisplay','varchar(max)') CustomDisplay,
					R.p.value('@CustomEdit','varchar(max)') CustomEdit,
					R.p.value('@ViewSecurityGroup','bigint') ViewSecurityGroup,
					R.p.value('@EditPermissions','varchar(max)') EditPermissions,
					R.p.value('@EditExisting','varchar(max)') EditExisting,
					R.p.value('@EditAddNew','varchar(max)') EditAddNew,
					R.p.value('@EditAddExisting','varchar(max)') EditAddExisting,
					R.p.value('@EditDelete','varchar(max)') EditDelete,
					R.p.value('@MinCardinality','varchar(max)') MinCardinality,
					R.p.value('@MaxCardinality','varchar(max)') MaxCardinality,
					R.p.value('@ObjectType','bit') ObjectType,
					R.p.value('@HasDataFeed','varchar(max)') HasDataFeed,
					(case when cast(R.p.query('./*') as nvarchar(max))='' then null else R.p.query('./*') end) CustomModule
				from (select @PresentationXML x) t cross apply t.x.nodes('Presentation/PropertyList/PropertyGroup/Property') as R(p)
		) p left outer join (
			select	R.p.value('@ID','bigint') ID,
					R.p.value('@Label','varchar(max)') Label
				from (select @PresentationXML x) t cross apply t.x.nodes('Presentation/SecurityGroupList/SecurityGroup') as R(p)
		) s on p.ViewSecurityGroup = s.ID
		where PropertyGroupURI = IsNull(@PropertyGroupURI,PropertyGroupURI)
			and PropertyURI = IsNull(@PropertyURI,PropertyURI)
			and (@ShowAllProperties = 1 or (TagName in (select TagName from #RDFData)))

	--create nonclustered index idx_TagName on #Properties(TagName)
	--create nonclustered index idx_PropertyGroupURI on #Properties(PropertyGroupURI)
	--create nonclustered index idx_PropertyURI on #Properties(PropertyURI)

	-----------------------------------------------------
	-- Create the Property List
	-----------------------------------------------------

	if @returnTable = 1 and @CountsOnly = 0
		select	p.PropertyGroupURI, p.PropertyGroupLabel, p.PropertyGroupSortOrder, IsNull(gn.Items,0) NumberOfPropertyGroupConnections,
				p.PropertyURI, p.PropertyLabel, p.PropertySortOrder, p.TagName, IsNull(pn.Items,0) NumberOfPropertyConnections,
				r.ItemSortOrder, r.ObjectValue, r.ObjectURI, r.ObjectClass, r.ObjectClassName,
				p.CustomDisplay, p.ViewSecurityGroup, p.ViewSecurityGroupLabel, p.CustomEdit,
				p.EditPermissions, p.EditExisting, p.EditAddNew, p.EditAddExisting, p.EditDelete,
				p.MinCardinality, p.MaxCardinality, p.OjbectType, p.HasDataFeed,
				p.CustomModule
			from #Properties p
				left outer join (
					select p.PropertyGroupURI, count(*) Items
						from #Properties p inner join #RDFData r
							on p.TagName = r.TagName
					group by p.PropertyGroupURI
				) gn on gn.PropertyGroupURI = p.PropertyGroupURI
				left outer join (
					select p.PropertyURI, count(*) Items
						from #Properties p inner join #RDFData r
							on p.TagName = r.TagName
					group by p.PropertyURI
				) pn on pn.PropertyURI = p.PropertyURI
				left outer join #RDFData r
					on p.TagName = r.TagName
			where (@ShowAllProperties = 1 or r.ItemSortOrder is not null)
			order by p.PropertyGroupSortOrder, p.PropertySortOrder, r.ItemSortOrder


	if @returnTable = 1 and @CountsOnly = 1
		select	p.PropertyGroupURI, p.PropertyGroupLabel, p.PropertyGroupSortOrder, IsNull(gn.Items,0) NumberOfPropertyGroupConnections,
				p.PropertyURI, p.PropertyLabel, p.PropertySortOrder, p.TagName, IsNull(pn.Items,0) NumberOfPropertyConnections,
				p.CustomDisplay, p.ViewSecurityGroup, p.ViewSecurityGroupLabel, p.CustomEdit,
				p.EditPermissions, p.EditExisting, p.EditAddNew, p.EditAddExisting, p.EditDelete,
				p.MinCardinality, p.MaxCardinality, p.ObjectType, p.HasDataFeed,
				p.CustomModule
			from #Properties p
				left outer join (
					select p.PropertyGroupURI, count(*) Items
						from #Properties p inner join #RDFData r
							on p.TagName = r.TagName
					group by p.PropertyGroupURI
				) gn on gn.PropertyGroupURI = p.PropertyGroupURI
				left outer join (
					select p.PropertyURI, count(*) Items
						from #Properties p inner join #RDFData r
							on p.TagName = r.TagName
					group by p.PropertyURI
				) pn on pn.PropertyURI = p.PropertyURI
			where (@ShowAllProperties = 1 or pn.PropertyURI is not null)
			order by p.PropertyGroupSortOrder, p.PropertySortOrder


	if (@returnTable = 0 or @returnXML = 1)
		select @PropertyListXML = (
			select (
				select	g.PropertyGroupURI "@URI",
						g.PropertyGroupLabel "@Label",
						g.PropertyGroupSortOrder "@SortOrder",
						(select	count(*)
							from #Properties p, #RDFData r
							where p.PropertyGroupURI = g.PropertyGroupURI and r.TagName = p.TagName
						) "@NumberOfConnections",
						(
							select	p.PropertyURI "@URI",
									p.PropertyLabel "@Label",
									p.PropertySortOrder "@SortOrder",
									p.TagName "@TagName",
									(select	count(*)
										from #RDFData r
										where r.TagName = p.TagName
									) "@NumberOfConnections",
									p.CustomDisplay "@CustomDisplay",
									p.ViewSecurityGroup "@ViewSecurityGroup",
									p.ViewSecurityGroupLabel "@ViewSecurityGroupLabel",
									p.CustomEdit "@CustomEdit",
									p.EditPermissions "@EditPermissions",
									p.EditExisting "@EditExisting",
									p.EditAddNew "@EditAddNew",
									p.EditAddExisting "@EditAddExisting",
									p.EditDelete "@EditDelete",
									p.MinCardinality "@MinCardinality",
									p.MaxCardinality "@MaxCardinality",
									p.ObjectType "@ObjectType",
									p.HasDataFeed "@HasDataFeed",
									p.CustomModule "CustomModule",
									(case when @CountsOnly = 1 then null else (
											select	row_number() over (order by r.ItemSortOrder) "Connection/@SortOrder",
													r.ObjectURI "Connection/@ResourceURI",
													r.ObjectClass "Connection/@ClassURI",
													r.ObjectClassName "Connection/@ClassName",
													r.ObjectValue "Connection"
												from #RDFData r
												where r.TagName = p.TagName
												order by r.ItemSortOrder
												for xml path(''), type
										) end) "Network"
								from #Properties p
								where p.PropertyGroupURI = g.PropertyGroupURI
								order by p.PropertySortOrder
								for xml path('Property'), type
						)
					from (select distinct PropertyGroupURI, PropertyGroupLabel, PropertyGroupSortOrder from #Properties) g
					order by g.PropertyGroupSortOrder
					for xml path('PropertyGroup'), type
			) "PropertyList"
			for xml path(''), type
		)

	if @PropertyListXML is null or (cast(@PropertyListXML as nvarchar(max)) = '')
		select @PropertyListXML = cast('<PropertyList />' as xml)

	if @returnXML = 1 and @returnXMLasStr = 0
		select @PropertyListXML PropertyList

	if @returnXML = 1 and @returnXMLasStr = 1
		select cast(@PropertyListXML as nvarchar(max)) PropertyList

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.].[GetTopSearchPhrase]
	@TimePeriod CHAR(1)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT *
		FROM [Search.Cache].[History.TopSearchPhrase]
		WHERE TimePeriod = @TimePeriod
		ORDER BY NumberOfQueries DESC

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [RDF.].[GetStoreTriple]
	-- Define the triple
	@ExistingTripleID bigint = null,
	@SubjectID bigint = null,
	@PredicateID bigint = null,
	@ObjectID bigint = null,
	@SubjectURI varchar(400) = NULL,
	@PredicateURI varchar(400) = NULL,
	@ObjectURI varchar(400) = NULL,
	-- Attributes
	@ViewSecurityGroup bigint = null,
	@Weight float = null,
	@SortOrder int = null,
	@MoveUpOne bit = null,
	@MoveDownOne bit = null,
	-- Inverse predicate triple
	@StoreInverse bit = 0,
	@InverseViewSecurityGroup bigint = null,
	@InverseWeight float = null,
	-- Other
	@OldObjectID bigint = null,
	@OldObjectURI varchar(400) = NULL,
	-- Security
	@SessionID uniqueidentifier = NULL,
	-- Output variables
	@Error bit = NULL OUTPUT,
	@TripleID bigint = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	SELECT @Error = 0
	SELECT @TripleID = NULL

	DECLARE @OldTripleID BIGINT
	SELECT @OldTripleID = NULL

	DECLARE @OldSortOrder BIGINT
	DECLARE @NewSortOrder BIGINT
	DECLARE @MaxSortOrder BIGINT

	SELECT @ExistingTripleID = NULL WHERE @ExistingTripleID = 0
	SELECT @SubjectID = NULL WHERE @SubjectID = 0
	SELECT @PredicateID = NULL WHERE @PredicateID = 0
	SELECT @ObjectID = NULL WHERE @ObjectID = 0
	SELECT @OldObjectID = NULL WHERE @OldObjectID = 0

	IF (@SortOrder IS NOT NULL)
		SELECT @MoveUpOne = NULL, @MoveDownOne = NULL

	-- Convert URIs to NodeIDs
 	IF (@SubjectID IS NULL) AND (@SubjectURI IS NOT NULL)
		SELECT @SubjectID = [RDF.].fnURI2NodeID(@SubjectURI)
 	IF (@PredicateID IS NULL) AND (@PredicateURI IS NOT NULL)
		SELECT @PredicateID = [RDF.].fnURI2NodeID(@PredicateURI)
 	IF (@ObjectID IS NULL) AND (@ObjectURI IS NOT NULL)
		SELECT @ObjectID = [RDF.].fnURI2NodeID(@ObjectURI)
 	IF (@OldObjectID IS NULL) AND (@OldObjectURI IS NOT NULL)
		SELECT @OldObjectID = [RDF.].fnURI2NodeID(@OldObjectURI)
 
	-- Confirm ExistingTripleID exists
	IF (@ExistingTripleID IS NOT NULL)
		SELECT @TripleID = TripleID, @SubjectID = subject, @PredicateID = predicate, @ObjectID = object
			FROM [RDF.].Triple
			WHERE TripleID = @ExistingTripleID

	-- Make sure required parameters are defined
	IF (@SubjectID IS NULL OR @PredicateID IS NULL OR @ObjectID IS NULL)
	BEGIN
		SELECT @Error = 1
		RETURN
	END	
	SELECT @Error = 1
		WHERE NOT EXISTS (SELECT * FROM [RDF.].Node WHERE NodeID = @SubjectID)
			OR NOT EXISTS (SELECT * FROM [RDF.].Node WHERE NodeID = @PredicateID)
			OR NOT EXISTS (SELECT * FROM [RDF.].Node WHERE NodeID = @ObjectID)
	IF (@SubjectID IS NULL OR @PredicateID IS NULL OR @ObjectID IS NULL)
	BEGIN
		SELECT @Error = 1
		RETURN
	END	

	-- Determine if a triple already exitsts
	IF (@TripleID IS NULL)
		SELECT @TripleID = TripleID
			FROM [RDF.].Triple
			WHERE subject = @SubjectID AND predicate = @PredicateID AND object = @ObjectID
	
	-- Handle the case where there is an OldObjectID
	IF (@OldObjectID IS NOT NULL) AND (@OldObjectID <> @ObjectID)
	BEGIN
		SELECT @OldTripleID = TripleID,
				@ViewSecurityGroup = IsNull(@ViewSecurityGroup,ViewSecurityGroup),
				@Weight = IsNull(@Weight,Weight),
				@OldSortOrder = SortOrder
			FROM [RDF.].Triple
			WHERE subject = @SubjectID AND predicate = @PredicateID AND object = @OldObjectID
		IF @OldTripleID IS NOT NULL
		BEGIN
			SELECT @SortOrder = @OldSortOrder, @TripleID = @OldTripleID
			UPDATE [RDF.].Triple
				SET object = @ObjectID
				WHERE TripleID = @TripleID
			/*
			DELETE 
				FROM [RDF.].Triple
				WHERE TripleID = @OldTripleID
			UPDATE [RDF.].Triple
				SET SortOrder = SortOrder - 1
				WHERE subject = @SubjectID AND predicate = @PredicateID AND SortOrder >= @OldSortOrder
			SELECT @OldTripleID = NULL
			*/
		END
	END

	-- Incremental SortOrders
	IF (@MoveUpOne = 1 OR @MoveDownOne = 1)
	BEGIN
		IF (@OldSortOrder IS NOT NULL)
			SELECT @SortOrder = @OldSortOrder + (CASE WHEN @MoveUpOne = 1 THEN 1 WHEN @MoveDownOne = 1 THEN -1 ELSE 0 END)
		ELSE IF (@TripleID IS NOT NULL)
			SELECT @SortOrder = SortOrder + (CASE WHEN @MoveUpOne = 1 THEN 1 WHEN @MoveDownOne = 1 THEN -1 ELSE 0 END)
				FROM [RDF.].Triple
				WHERE TripleID = @TripleID
	END

	-- Set SortOrder variables
	IF @TripleID IS NOT NULL
		SELECT @OldSortOrder = SortOrder
			FROM [RDF.].Triple
			WHERE TripleID = @TripleID
	SELECT @MaxSortOrder = MAX(SortOrder)
		FROM [RDF.].Triple
		WHERE subject = @SubjectID AND predicate = @PredicateID
	SELECT @MaxSortOrder = IsNull(@MaxSortOrder,0)
	SELECT @NewSortOrder = (CASE WHEN @MaxSortOrder = 0 THEN 1
								WHEN @SortOrder < 1 THEN 1
								WHEN @SortOrder <= @MaxSortOrder THEN @SortOrder
								WHEN @TripleID IS NOT NULL THEN @MaxSortOrder
								ELSE @MaxSortOrder + 1 END)
 
	-- Update attributes if a triple already exists
	IF (@TripleID IS NOT NULL)
	BEGIN
		IF @ViewSecurityGroup IS NOT NULL
			UPDATE [RDF.].Triple
				SET ViewSecurityGroup = @ViewSecurityGroup
				WHERE TripleID = @TripleID
		IF @Weight IS NOT NULL
			UPDATE [RDF.].Triple
				SET Weight = @Weight
				WHERE TripleID = @TripleID
		IF (@SortOrder IS NOT NULL) AND (@SortOrder <> @OldSortOrder)
			UPDATE [RDF.].Triple
				SET SortOrder = (CASE
									WHEN TripleID = @TripleID 
										THEN @NewSortOrder
									WHEN (@NewSortOrder > @OldSortOrder) AND (SortOrder > @OldSortOrder) AND (SortOrder <= @NewSortOrder)
										THEN SortOrder - 1
									WHEN (@NewSortOrder < @OldSortOrder) AND (SortOrder < @OldSortOrder) AND (SortOrder >= @NewSortOrder)
										THEN SortOrder + 1
									ELSE SortOrder END)
				WHERE subject = @SubjectID AND predicate = @PredicateID 
					AND (SortOrder >= @NewSortOrder OR SortOrder >= @OldSortOrder)
					AND (SortOrder <= @NewSortOrder OR SortOrder <= @OldSortOrder)
	END
 
	-- Create a new triple if needed
	IF (@TripleID IS NULL)
	BEGIN
		-- Get ObjectType
		DECLARE @ObjectType BIT
		SELECT @ObjectType = ObjectType
			FROM [RDF.].[Node]
			WHERE NodeID = @ObjectID
		-- Shift SortOrders of existing triples
		IF @NewSortOrder <= @MaxSortOrder
			UPDATE [RDF.].Triple
				SET SortOrder = SortOrder + 1
				WHERE subject = @SubjectID AND predicate = @PredicateID
					AND SortOrder >= @NewSortOrder
		-- Get default @ViewSecurityGroup
		IF @ViewSecurityGroup IS NULL
		BEGIN
			SELECT @ViewSecurityGroup = MAX(IsNull(p.ViewSecurityGroup,c.ViewSecurityGroup))
				FROM [RDF.].Triple t
						INNER JOIN [Ontology.].ClassProperty c
							ON t.subject = @SubjectID
								AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
								AND t.object = c._ClassNode
								AND c._PropertyNode = @PredicateID
								AND c._NetworkPropertyNode IS NULL
						LEFT OUTER JOIN [RDF.Security].NodeProperty p
							ON p.NodeID = @SubjectID
								AND p.Property = @PredicateID
			SELECT @ViewSecurityGroup = IsNull(@ViewSecurityGroup,-1)
		END
		-- Create the triple
		INSERT INTO [RDF.].[Triple] (ViewSecurityGroup, Subject, Predicate, Object, ObjectType, Weight, SortOrder, TripleHash)
			SELECT @ViewSecurityGroup, @SubjectID, @PredicateID, @ObjectID, @ObjectType, IsNull(@Weight,1), @NewSortOrder,
					[RDF.].fnTripleHash(@SubjectID, @PredicateID, @ObjectID) 
		SET @TripleID = @@IDENTITY
		-- Create the inverse triple
		IF (@StoreInverse IS NOT NULL)
		BEGIN	
			-- Determine if there is an inverse property
			DECLARE @InversePredicateID BIGINT
			SELECT @InversePredicateID = object
				FROM [RDF.].Triple
				WHERE subject = @PredicateID
					AND predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#inverseOf')
			IF @InversePredicateID IS NOT NULL
			BEGIN
				-- Get default @InverseWeight
				SELECT @InverseWeight = IsNull(@InverseWeight,@Weight)
				-- Create the inverse triple
				EXEC [RDF.].GetStoreTriple	@SubjectID = @ObjectID,
											@PredicateID = @InversePredicateID,
											@ObjectID = @SubjectID,
											@ViewSecurityGroup = @InverseViewSecurityGroup,
											@Weight = @InverseWeight,
											@SortOrder = NULL,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT
			END
		END
	END

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Person.GetPhotos](@NodeID bigINT)
AS
BEGIN

DECLARE @PersonID INT 

    SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
		
	SELECT  photo,
			p.PhotoID		
		FROM [Profile.Data].[Person.Photo] p WITH(NOLOCK)
	 WHERE PersonID=@PersonID  
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

Copyright (c) 2008-2010 by the President and Fellows of Harvard College. All rights reserved.  Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD., and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the National Center for Research Resources and Harvard University.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name "Harvard" nor the names of its contributors nor the name "Harvard Catalyst" may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER (PRESIDENT AND FELLOWS OF HARVARD COLLEGE) AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.




*/
CREATE procedure [Profile.Import].[LoadProfilesData]	(
												@use_internalusername_as_pkey BIT=0)
AS
BEGIN
	SET NOCOUNT ON;	

												
	-- Start Transaction. Log load failures, roll back transaction on error.
	BEGIN TRY
				BEGIN TRAN				 

					  DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
						 

						-- Department
						INSERT INTO [Profile.Data].[Organization.Department](departmentname,visible)
						SELECT DISTINCT
									 departmentname, 
									 1
							FROM [Profile.Import].PersonAffiliation a
						 WHERE departmentname IS NOT NULL 
							 and departmentname NOT IN (SELECT departmentname FROM [Profile.Data].[Organization.Department])


						-- institution
						INSERT INTO [Profile.Data].[Organization.Institution]
										( InstitutionName ,
											InstitutionAbbreviation
										)					 
						SELECT	INSTITUTIONNAME,
										INSTITUTIONABBREVIATION
							FROM (
										SELECT	INSTITUTIONNAME,
														INSTITUTIONABBREVIATION, 
														COUNT(*)CNT,		
														ROW_NUMBER() OVER(PARTITION BY institutionname order by SUM(CASE WHEN INSTITUTIONABBREVIATION='' THEN 0 ELSE 1 END) desc)rank
											FROM  [Profile.Import].PersonAffiliation
									GROUP BY  INSTITUTIONNAME,
														INSTITUTIONABBREVIATION
										)A
							WHERE rank=1
								AND institutionname <>''
								AND NOT EXISTS(SELECT b.institutionname 
																FROM [Profile.Data].[Organization.Institution] b
															 WHERE b.institutionname=a.institutionname)
 
					
						-- division
						INSERT INTO [Profile.Data].[Organization.Division]
										( DivisionName  
										)
						SELECT DISTINCT 
									 divisionname 
							FROM [Profile.Import].PersonAffiliation a
						 WHERE divisionname IS NOT NULL
							 AND NOT EXISTS(SELECT b.divisionname 
																FROM [Profile.Data].[Organization.Division] b
															 WHERE b.divisionname=a.divisionname)
 
						-- Flag deleted people
						UPDATE [Profile.Data].Person
							 SET ISactive=0
						 WHERE internalusername NOT IN(SELECT internalusername FROM [Profile.Import].Person)
				
					-- Update person/user records where data has changed. 
						UPDATE p
						   SET p.firstname=lp.firstname,
									 p.lastname=lp.lastname,
									 p.middlename=lp.middlename,
									 p.displayname=lp.displayname, 
									 p.suffix=lp.suffix,
									 p.addressline1=lp.addressline1,
									 p.addressline2=lp.addressline2,
									 p.addressline3=lp.addressline3,
									 p.addressline4=lp.addressline4, 
									 p.city=lp.city,
									 p.state=lp.state,
									 p.zip=lp.zip, 
									 p.building=lp.building,
									 p.room=lp.room,
									 p.phone=lp.phone,
									 p.fax=lp.fax, 
									 p.EmailAddr=lp.EmailAddr,
									 p.AddressString=lp.AddressString,    
									 p.isactive=lp.isactive,
									 p.visible=lp.isvisible
					  FROM [Profile.Data].Person p
	          JOIN [Profile.Import].Person lp on lp.internalusername = p.internalusername
																				  and (ISNULL(lp.firstname,'')<>ISNULL(p.firstname,'')
																					 or ISNULL(lp.lastname,'')<>ISNULL(p.lastname,'')
																					 or ISNULL(lp.middlename,'')<>ISNULL(p.middlename,'')
																					 or ISNULL(lp.displayname,'')<>ISNULL(p.displayname,'') 
																					 or ISNULL(lp.suffix,'')<>ISNULL(p.suffix,'')
																					 or ISNULL(lp.addressline1,'')<>ISNULL(p.addressline1,'')
																					 or ISNULL(lp.addressline2,'')<>ISNULL(p.addressline2,'')
																					 or ISNULL(lp.addressline3,'')<>ISNULL(p.addressline3,'')
																					 or ISNULL(lp.addressline4,'')<>ISNULL(p.addressline4,'') 
																					 or ISNULL(lp.city,'')<>ISNULL(p.city,'') 
																					 or ISNULL(lp.state,'')<>ISNULL(p.state,'') 
																					 or ISNULL(lp.zip,'')<>ISNULL(p.zip,'') 
																					 or ISNULL(lp.building,'')<>ISNULL(p.building,'')
																					 or ISNULL(lp.room,'')<>ISNULL(p.room,'')
																					 or ISNULL(lp.phone,'')<>ISNULL(p.phone,'')
																					 or ISNULL(lp.fax,'')<>ISNULL(p.fax,'') 
																					 or ISNULL(lp.EmailAddr,'')<>ISNULL(p.EmailAddr,'')
																					 or ISNULL(lp.AddressString,'')<>ISNULL(p.AddressString,'')  
																					 or ISNULL(lp.Isactive,'')<>ISNULL(p.Isactive,'')
																					 or ISNULL(lp.isvisible,'')<>ISNULL(p.visible,'')) 
						-- Update changed user info
						UPDATE	 u
						   SET	 u.firstname=up.firstname,
								 u.lastname=up.lastname,
								 u.displayname=up.displayname,   
								 u.institution=up.institution,
								 u.department=up.department ,
								 u.emailaddr = up.emailaddr
					  FROM [User.Account].[User] u
	          JOIN [Profile.Import].[User] up on up.internalusername = u.internalusername
													 and (ISNULL(up.firstname,'')<>ISNULL(u.firstname,'')
														 or ISNULL(up.lastname,'')<>ISNULL(u.lastname,'')
														 or ISNULL(up.displayname,'')<>ISNULL(u.displayname,'')  
														 or ISNULL(up.institution,'')<>ISNULL(u.institution,'')
														 or ISNULL(up.department,'')<>ISNULL(u.department,'') 
														 or ISNULL(up.emailaddr,'')<>ISNULL(u.emailaddr,'') )
				  
					-- Remove Affiliations that have changed, so they'll be re-added
				 SELECT DISTINCT COALESCE(  p.internalusername,p.internalusername )internalusername
					 INTO #affiliations
					 FROM [Profile.Cache].[Person.Affiliation] cpa 
			     JOIN [Profile.Data].Person p ON p.personid = cpa.personid
			FULL join [Profile.Import].PersonAffiliation pa on pa.internalusername = p.internalusername
													and ISNULL(pa.affiliationorder,'')=ISNULL(cpa.sortorder,'')
													and ISNULL(pa.primaryaffiliation,'') = ISNULL(cpa.isprimary,'')
													and ISNULL(pa.title,'') = ISNULL(cpa.title,'') 
													and ISNULL(pa.institutionabbreviation,'') = ISNULL(cpa.institutionabbreviation,'')
													and ISNULL(pa.departmentname,'') = ISNULL(cpa.departmentname,'')
													and ISNULL(pa.divisionname,'') = ISNULL(cpa.divisionname,'')
													and ISNULL(pa.facultyrank,'') = ISNULL(cpa.facultyrank,'')
					WHERE  pa.internalusername IS NULL OR cpa.personid IS NULL
					
					DELETE FROM [Profile.Data].[Person.Affiliation] where personid in (SELECT personid FROM [Profile.Data].Person WHERE internalusername IN ( SELECT internalusername FROM #affiliations	))
					
					-- Remove Filters that have changed, so they'll be re-added
					DELETE 
					  FROM [Profile.Data].[Person.FilterRelationship] 
					 WHERE personid IN (SELECT personid 
														    FROM [Profile.Data].Person  
														   WHERE InternalUsername IN 
																					(
																							SELECT  coalesce( a.internalusername, p.internalusername )
																								FROM [Profile.Import].PersonFilterFlag pf
																								JOIN [Profile.Import].Person p on p.internalusername = pf.internalusername
																					 FULL JOIN (select internalusername,personfilter 
																												from [Profile.Data].[Person.FilterRelationship] pfr
																												JOIN [Profile.Data].Person  p ON p.personid = pfr.personid 
																												join [Profile.Data].[Person.Filter] pf on pf.personfilterid = pfr.personfilterid)a ON a.internalusername = p.internalusername 
																																																													AND a.personfilter = pf.personfilter
																						WHERE a.internalusername is null or p.internalusername is null
																						))
 
				  			 
								 
						 
								 
									 
					-- user
					IF @use_internalusername_as_pkey=0
					BEGIN
						INSERT INTO [User.Account].[User]
						        ( IsActive ,
						          CanBeProxy ,
						          FirstName ,
						          LastName ,
						          DisplayName ,
						          Institution ,
						          Department ,
						          InternalUserName ,
						          emailaddr 
						        ) 
							SELECT 1,
										 canbeproxy,
										 ISNULL(firstname,''),
										 ISNULL(lastname,''),
										 ISNULL(displayname,''),  
										 institution, 
										 department,
						         InternalUserName 	,
						         emailaddr								 
								FROM [Profile.Import].[User] u 
							 WHERE NOT EXISTS (SELECT * 
															 FROM [User.Account].[User] b
															WHERE b.internalusername=u.internalusername)
					 UNION
						 SELECT  1,
										 1,
										 ISNULL(firstname,''),
										 ISNULL(lastname,''),
										 ISNULL(displayname,''), 
										 institutionname, 
										 departmentname,
						         u.InternalUserName,
						         u.emailaddr 
								FROM [Profile.Import].Person u 
					 LEFT JOIN [Profile.Import].PersonAffiliation pa on pa.internalusername = u.internalusername 
																						and pa.primaryaffiliation=1
							 WHERE NOT EXISTS (SELECT * 
															 FROM [User.Account].[User] b
															WHERE b.internalusername=u.internalusername)
						END
					ELSE
						BEGIN
							SET IDENTITY_INSERT [User.Account].[User] ON 

							INSERT INTO [User.Account].[User]
						        ( userid,
											IsActive ,
						          CanBeProxy ,
						          FirstName ,
						          LastName ,
						          DisplayName ,
						          Institution ,
						          Department  ,
						          InternalUserName  ,
						          emailaddr 
						        ) 
							SELECT u.internalusername,
											1,
										 canbeproxy,
										 ISNULL(firstname,''),
										 ISNULL(lastname,''),
										 ISNULL(displayname,''),  
										 institution, 
										 department,
						          InternalUserName 	,
						          emailaddr 								 
								FROM [Profile.Import].[User] u 
							 WHERE NOT EXISTS (SELECT * 
															 FROM [User.Account].[User] b
															WHERE b.internalusername=u.internalusername)
					 UNION ALL
						 SELECT  u.internalusername,
											1,
										 1,
										 ISNULL(firstname,''),
										 ISNULL(lastname,''),
										 ISNULL(displayname,''), 
										 institutionname, 
										 departmentname,
						          u.InternalUserName ,
						          u.emailaddr 
								FROM [Profile.Import].Person u 
					 LEFT JOIN [Profile.Import].PersonAffiliation pa on pa.internalusername = u.internalusername 
																						and pa.primaryaffiliation=1
							 WHERE NOT EXISTS (SELECT * 
															 FROM [User.Account].[User] b
															WHERE b.internalusername=u.internalusername)
						   AND NOT EXISTS (SELECT * FROM [Profile.Import].[User] b WHERE b.internalusername =u.internalusername)
						   
							SET IDENTITY_INSERT [User.Account].[User] OFF
						END

					-- faculty ranks
					INSERT INTO [Profile.Data].[Person.FacultyRank]
					        ( FacultyRank ,
					          FacultyRankSort ,
					          Visible
					        ) 
					SELECT DISTINCT 
								 facultyrank,
								 facultyrankorder,
								 1 
						FROM [Profile.Import].PersonAffiliation p
					 WHERE   NOT EXISTS (SELECT * 
										 FROM [Profile.Data].[Person.FacultyRank] a
										WHERE a.facultyrank=p.facultyrank)

					-- person
					IF @use_internalusername_as_pkey=0
					BEGIN				
						INSERT INTO [Profile.Data].Person
						        ( UserID ,
						          FirstName ,
						          LastName ,
						          MiddleName ,
						          DisplayName ,
						          Suffix ,
						          IsActive ,
						          EmailAddr ,
						          Phone ,
						          Fax ,
						          AddressLine1 ,
						          AddressLine2 ,
						          AddressLine3 ,
						          AddressLine4 ,
						          city ,
						          state ,
						          zip ,
						          Building ,
						          Floor ,
						          Room ,
						          AddressString ,
						          Latitude ,
						          Longitude ,
						          FacultyRankID ,
						          InternalUsername ,
						          Visible
						        )
					  SELECT  UserID,
										ISNULL(p.FirstName,''),
										ISNULL(p.LastName,''),
										ISNULL(p.MiddleName,''),
										ISNULL(p.DisplayName,''), 
										ISNULL(Suffix,''),
										p.IsActive,
										p.EmailAddr,
										Phone,
										Fax,
										AddressLine1,
										AddressLine2,
										AddressLine3,
										AddressLine4,
					          city ,
					          state ,
					          zip ,
										Building,
										Floor,
										Room,
										AddressString,
										Latitude,
										Longitude,
										FacultyRankID ,
										p.InternalUsername,
										p.isvisible
						 FROM  [Profile.Import].Person p
				LEFT JOIN  [Profile.Import].PersonAffiliation pa on pa.internalusername = p.internalusername 
																					and pa.primaryaffiliation=1
				LEFT JOIN  [Profile.Data].[Person.FacultyRank] fr on fr.facultyrank=pa.facultyrank
						 JOIN  [User.Account].[User] u ON u.internalusername = p.internalusername 
						WHERE  NOT EXISTS (SELECT * 
										 FROM [Profile.Data].Person b
								 		WHERE b.internalusername=p.internalusername)  
						END
					ELSE
						BEGIN
							SET IDENTITY_INSERT [Profile.Data].Person ON
							INSERT INTO [Profile.Data].Person
						        ( personid,
											UserID ,
						          FirstName ,
						          LastName ,
						          MiddleName ,
						          DisplayName ,
						          Suffix ,
						          IsActive ,
						          EmailAddr ,
						          Phone ,
						          Fax ,
						          AddressLine1 ,
						          AddressLine2 ,
						          AddressLine3 ,
						          AddressLine4 ,
						          Building ,
						          Floor ,
						          Room ,
						          AddressString ,
						          Latitude ,
						          Longitude ,
						          FacultyRankID ,
						          InternalUsername ,
						          Visible
						        )
					  SELECT  p.internalusername,
										userid,
										ISNULL(p.FirstName,''),
										ISNULL(p.LastName,''),
										ISNULL(p.MiddleName,''),
										ISNULL(p.DisplayName,''), 
										ISNULL(Suffix,''),
										p.IsActive,
										p.EmailAddr,
										Phone,
										Fax,
										AddressLine1,
										AddressLine2,
										AddressLine3,
										AddressLine4,
										Building,
										Floor,
										Room,
										AddressString,
										Latitude,
										Longitude,
										FacultyRankID ,
										p.InternalUsername,
										p.isvisible
						 FROM  [Profile.Import].Person p
				LEFT JOIN  [Profile.Import].PersonAffiliation pa on pa.internalusername = p.internalusername 
																					and pa.primaryaffiliation=1
				LEFT JOIN  [Profile.Data].[Person.FacultyRank] fr on fr.facultyrank=pa.facultyrank
						 JOIN  [User.Account].[User] u ON u.internalusername = p.internalusername 
						WHERE  NOT EXISTS (SELECT * 
										 FROM [Profile.Data].Person b
								 		WHERE b.internalusername=p.internalusername)  
							SET IDENTITY_INSERT [Profile.Data].Person OFF

						END
 
						-- add personid to user
						UPDATE u
							 SET u.personid = p.personid
							FROM [Profile.Data].Person p
						  JOIN [User.Account].[User] u  ON u.userid = p.userid
						 
				 
					-- person affiliation
					INSERT INTO [Profile.Data].[Person.Affiliation]
					        ( PersonID ,
					          SortOrder ,
					          IsActive ,
					          IsPrimary ,
					          InstitutionID ,
					          DepartmentID ,
					          DivisionID ,
					          Title ,
					          EmailAddress ,
					          FacultyRankID
					        ) 
					SELECT p.personid,
								 affiliationorder,
								 1,
								 primaryaffiliation ,
								 InstitutionID,
								 DepartmentID,
								 DivisionID,
								 c.title,
								 c.emailaddr,
								 fr.facultyrankid
						from [Profile.Import].PersonAffiliation c 
						JOIN [Profile.Data].Person p on c.internalusername=p.internalusername
			 LEFT JOIN [Profile.Data].[Organization.Institution] i ON i.institutionname = c.institutionname 
			 LEFT JOIN [Profile.Data].[Organization.Department] d  ON d.departmentname = c.departmentname
			 LEFT JOIN [Profile.Data].[Organization.Division] di ON di.divisionname = c.divisionname
			 LEFT JOIN [Profile.Data].[Person.FacultyRank] fr on fr.facultyrank = c.facultyrank 
					 WHERE NOT EXISTS (SELECT *
															 FROM [Profile.Data].[Person.Affiliation] a
															WHERE a.personid=p.personid
														    AND ISNULL(a.InstitutionID,'')=ISNULL(i.InstitutionID,'')
																AND ISNULL(a.DepartmentID,'') = ISNULL(d.DepartmentID,'')
																AND ISNULL(a.DivisionID,'')=ISNULL(di.DivisionID,''))
				 

					-- person_filters
					INSERT INTO [Profile.Data].[Person.Filter]
					        ( PersonFilter 
					        ) 
					 
					SELECT DISTINCT 
								 personfilter
						FROM [Profile.Import].PersonFilterFlag b
				   WHERE NOT EXISTS (SELECT * 
															 FROM [Profile.Data].[Person.Filter] a
															WHERE a.personfilter = b.personfilter)


				-- person_filter_relationships
					INSERT INTO [Profile.Data].[Person.FilterRelationship]
					        ( PersonID ,
					          PersonFilterid
					        ) 
						  SELECT DISTINCT
								 p.personid,
								 personfilterid 
						FROM [Profile.Import].PersonFilterFlag ptf
			 			JOIN [Profile.Data].[Person.Filter] pt on pt.personfilter=ptf.personfilter
				 		JOIN [Profile.Data].Person p on p.internalusername = ptf.internalusername 
				   WHERE NOT EXISTS (SELECT * 
										 FROM [Profile.Data].[Person.FilterRelationship] ptf
										 JOIN [Profile.Data].[Person.Filter] pt2 on pt2.personfilterid=ptf.personfilterid
										 JOIN [Profile.Data].Person p2 on p2.personid=ptf.personid 
									  WHERE (p2.personid=p.personid 
										 and pt.personfilterid=pt2.personfilterid  
										 )
										 )												     										     
 
				 
			-- Hide/Show Departments
			update d
			set d.visible = isnull(t.v,0)
			from [Profile.Data].[Organization.Department] d left outer join (
				select a.departmentname, max(cast(a.departmentvisible as int)) v
				from [Profile.Import].PersonAffiliation a, [Profile.Import].Person p
				where a.internalusername = p.internalusername and p.isactive = 1
				group by a.departmentname
			) t on d.departmentname = t.departmentname

 
		COMMIT
	END TRY
	BEGIN CATCH
			--Check success
			IF @@TRANCOUNT > 0  ROLLBACK

			-- Raise an error with the details of the exception
			SELECT @ErrMsg =  ERROR_MESSAGE(),
						 @ErrSeverity = ERROR_SEVERITY()

			RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH	
				
	END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.Security].[GetSessionSecurityGroupNodes]
@SessionID UNIQUEIDENTIFIER=NULL, @Subject BIGINT=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*

	This procedure returns Security Group nodes to which
	the given session has access. However, it only returns
	the NodeID of the session itself if the subject is that
	session node; otherwise, there is no need to include
	node in the result set.

	*/

	-- Get the session's NodeID
	SELECT NodeID SecurityGroupNode
		FROM [User.Session].Session
		WHERE NodeID IS NOT NULL
			AND SessionID = @SessionID
	-- Get the user's NodeID
	UNION
	SELECT m.NodeID SecurityGroupNode
		FROM [User.Session].Session s 
			INNER JOIN [RDF.Stage].InternalNodeMap m
				ON	s.SessionID = @SessionID
					AND s.UserID IS NOT NULL
					AND m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
					AND m.InternalType = 'User'
					AND m.InternalID = CAST(s.UserID AS VARCHAR(50))
	-- Get designated proxy NodeIDs
	UNION
	SELECT m.NodeID SecurityGroupNode
		FROM [User.Session].Session s
			INNER JOIN [User.Account].[DesignatedProxy] x
				ON	s.SessionID = @SessionID
					AND s.UserID IS NOT NULL
					AND @Subject IS NOT NULL
					AND x.UserID = s.UserID
			INNER JOIN [RDF.Stage].InternalNodeMap m
				ON	m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
					AND m.InternalType = 'User'
					AND m.InternalID = CAST(x.ProxyForUserID AS VARCHAR(50))
			INNER JOIN [RDF.].[Node] n
				ON	n.NodeID = @Subject
					AND m.NodeID IN (@Subject, n.ViewSecurityGroup, n.EditSecurityGroup)
	/*
	SELECT m.NodeID SecurityGroupNode
		FROM [User.Session].Session s
			INNER JOIN [RDF.].[Node] n
				ON	s.SessionID = @SessionID
					AND s.UserID IS NOT NULL
					AND @Subject IS NOT NULL
					AND n.NodeID = @Subject
			INNER JOIN [User.Account].[DesignatedProxy] x
				ON	x.UserID = s.UserID
					AND x.ProxyForUserID IN (@Subject, n.ViewSecurityGroup, n.EditSecurityGroup)
			INNER JOIN [RDF.Stage].InternalNodeMap m
				ON	m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
					AND m.InternalType = 'User'
					AND m.InternalID = CAST(x.ProxyForUserID AS VARCHAR(50))
	*/
	-- Get default proxy NodeIDs
	UNION
	SELECT m.NodeID SecurityGroupNode
		FROM [User.Session].Session s
			INNER JOIN [RDF.].[Node] n
				ON	s.SessionID = @SessionID
					AND s.UserID IS NOT NULL
					AND @Subject IS NOT NULL
					AND n.NodeID = @Subject
			INNER JOIN [User.Account].[DefaultProxy] x
				ON	x.UserID = s.UserID
			INNER JOIN [User.Account].[User] u
				ON	((IsNull(x.ProxyForInstitution,'') = '') 
							OR (IsNull(x.ProxyForInstitution,'') = IsNull(u.Institution,'')))
					AND ((IsNull(x.ProxyForDepartment,'') = '') 
							OR (IsNull(x.ProxyForDepartment,'') = IsNull(u.Department,'')))
					AND ((IsNull(x.ProxyForDivision,'') = '') 
							OR (IsNull(x.ProxyForDivision,'') = IsNull(u.Division,'')))
			INNER JOIN [RDF.Stage].InternalNodeMap m
				ON	m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
					AND m.InternalType = 'User'
					AND m.InternalID = CAST(u.UserID AS VARCHAR(50))
					AND m.NodeID IN (@Subject, n.ViewSecurityGroup, n.EditSecurityGroup)
					
	/*
	SELECT m.NodeID SecurityGroupNode
		FROM [User.Session].Session s
			INNER JOIN [RDF.].[Node] n
				ON	s.SessionID = @SessionID
					AND s.UserID IS NOT NULL
					AND @Subject IS NOT NULL
					AND n.NodeID = @Subject
			INNER JOIN [User.Account].[DefaultProxy] x
				ON	x.UserID = s.UserID
			INNER JOIN [User.Account].[User] u
				ON	u.UserID IN (@Subject, n.ViewSecurityGroup, n.EditSecurityGroup)
					AND ((IsNull(x.ProxyForInstitution,'') = '') 
							OR (IsNull(x.ProxyForInstitution,'') = IsNull(u.Institution,'')))
					AND ((IsNull(x.ProxyForDepartment,'') = '') 
							OR (IsNull(x.ProxyForDepartment,'') = IsNull(u.Department,'')))
					AND ((IsNull(x.ProxyForDivision,'') = '') 
							OR (IsNull(x.ProxyForDivision,'') = IsNull(u.Division,'')))
			INNER JOIN [RDF.Stage].InternalNodeMap m
				ON	m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
					AND m.InternalType = 'User'
					AND m.InternalID = CAST(u.UserID AS VARCHAR(50))
	*/

	/*
	This will later be expanded to include all nodes to which a
	session's users is connected through a membership predicate.
	*/


END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.Security].[GetSessionSecurityGroup]
	@SessionID uniqueidentifier = NULL,
	@SecurityGroupID bigint = -1 OUTPUT,
	@HasSpecialViewAccess bit = 0 OUTPUT,
	@HasSpecialEditAccess bit = 0 OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT	@SecurityGroupID = IsNull(MIN(g.SecurityGroupID),-1),
			@HasSpecialViewAccess = IsNull(MAX(CAST(g.HasSpecialViewAccess AS TINYINT)),0),
			@HasSpecialEditAccess = IsNull(MAX(CAST(g.HasSpecialEditAccess AS TINYINT)),0)
		FROM [User.Session].Session s, [RDF.Security].Member m, [RDF.Security].[Group] g
		WHERE s.SessionID = @SessionID AND s.UserID IS NOT NULL
			AND s.UserID = m.UserID AND m.SecurityGroupID = g.SecurityGroupID
			
	IF @SecurityGroupID > -20
		SELECT @SecurityGroupID = (case when UserID is not null then -20 when IsBot = 1 then -1 else -10 end)
			FROM [User.Session].Session
			WHERE SessionID = @SessionID

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.Presentation].[ConvertTables2XML]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	TRUNCATE TABLE [Ontology.Presentation].[XML]
	INSERT INTO [Ontology.Presentation].[XML]
		SELECT PresentationID, Type, Subject, Predicate, Object,
			(SELECT	(CASE Type WHEN 'P' THEN 'profile' WHEN 'N' THEN 'network' WHEN 'C' THEN 'connection' WHEN 'E' THEN 'profile' END) "@PresentationClass",
					PageColumns "PageOptions/@Columns",
					WindowName,
					PageColumns,
					PageTitle,
					PageBackLinkName,
					PageBackLinkURL,
					PageSubTitle,
					PageDescription,
					PanelTabType,
					(SELECT	Type "Panel/@Type",
							(CASE WHEN TabSort = -1 THEN NULL ELSE TabSort END) "Panel/@TabSort",
							TabType "Panel/@TabType",
							Alias "Panel/@Alias",
							Name "Panel/@Name",
							Icon "Panel/@Icon",
							DisplayRule "Panel/@DisplayRule",
							ModuleXML "Panel"
						FROM [Ontology.Presentation].[Panel] p
						WHERE p.PresentationID = g.PresentationID
						FOR XML PATH(''), TYPE
					) PanelList,
					ExpandRDFList ExpandRDFList
				FOR XML PATH('Presentation'), TYPE
			) PresentationXML,
			[RDF.].fnURI2NodeID(subject) _SubjectNode,
			[RDF.].fnURI2NodeID(predicate) _PredicateNode,
			[RDF.].fnURI2NodeID(object) _ObjectNode
		FROM [Ontology.Presentation].[General] g

	-- SELECT * FROM [Ontology.Presentation].[XML]

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.Import].[ConvertOWL2Triple]
	@OWL varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY 
    begin transaction

		delete 
			from [Ontology.Import].Triple
			where OWL = @OWL

		insert into [Ontology.Import].Triple (OWL, Graph, Subject, Predicate, Object)
			select OWL, Graph, Subject, Predicate, Object 
			from [Ontology.Import].vwOwlTriple
			where OWL = @OWL

	commit transaction
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		

	-- select * from [Ontology.Import].Triple
	-- select * from [Ontology.Import].vwOwlTriple
	-- exec [Ontology.Import].[ConvertOWL2Triple] @OWL = 'VIVO_1.4'

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[ConnectionDetails.Person.SimilarTo.GetData]
	@subject BIGINT,
	@object BIGINT,
	@SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @subject
 
	DECLARE @PersonID2 INT
 	SELECT @PersonID2 = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @object

	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	DECLARE @hasResearchAreaID BIGINT
	SELECT @hasResearchAreaID = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#hasResearchArea')

	;with a as (
		select a.PersonID PersonID1, b.PersonID PersonID2, a.MeshHeader, 
			a.NumPubsThis PublicationCount1, b.NumPubsThis PublicationCount2,
			a.Weight KeywordWeight1, b.Weight KeywordWeight2,
			a.Weight*b.Weight OverallWeight
		from [Profile.Cache].[Concept.Mesh.Person] a, [Profile.Cache].[Concept.Mesh.Person] b
		where a.personid = @PersonID and b.personid = @PersonID2
			and a.meshheader = b.meshheader
	), b as (
		select count(*) SharedKeywords, sum(OverallWeight) TotalOverallWeight 
		from a
	)
	select a.*, b.*, @baseURI + cast(m.NodeID as varchar(50)) ObjectURI,
		@baseURI + cast(@subject as varchar(50)) + '/' + cast(@hasResearchAreaID as varchar(50)) + '/' + cast(m.NodeID as varchar(50)) ConnectionURI1,
		@baseURI + cast(@object as varchar(50)) + '/' + cast(@hasResearchAreaID as varchar(50)) + '/' + cast(m.NodeID as varchar(50)) ConnectionURI2
	from a, b, [Profile.Data].[Concept.Mesh.Descriptor] d, [RDF.Stage].[InternalNodeMap] m
	where a.MeshHeader = d.DescriptorName and d.DescriptorUI = m.InternalID
		and m.Class = 'http://www.w3.org/2004/02/skos/core#Concept' and m.InternalType = 'MeshDescriptor'
	order by OverallWeight desc, MeshHeader

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdateWord2Mesh]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	select a.word, a.mesh_header
		into #cache_word2mesh
		from [Profile.Cache].[Concept.Mesh.Word2mesh2All] a, [Profile.Cache].[Concept.Mesh.Count] c
		where a.mesh_header = c.meshheader
	select a.word, a.mesh_header
		into #cache_word2mesh2
		from [Profile.Cache].[Concept.Mesh.Word2mesh2All] a, [Profile.Cache].[Concept.Mesh.Count] c
		where a.mesh_header = c.meshheader
	select a.word, a.mesh_term, a.mesh_header, a.num_words
		into #cache_word2mesh3
		from [Profile.Cache].[Concept.Mesh.Word2Mesh3All] a, [Profile.Cache].[Concept.Mesh.Count] c
		where a.mesh_header = c.meshheader
 
	BEGIN TRY
		BEGIN TRAN
			truncate TABLE [Profile.Cache].[Concept.Mesh.Word2mesh]
			insert into [Profile.Cache].[Concept.Mesh.Word2mesh](word, meshheader)
				select word, mesh_header from #cache_word2mesh
			truncate table [Profile.Cache].[Concept.Mesh.Word2mesh2]
			insert into [Profile.Cache].[Concept.Mesh.Word2mesh2](word, mesh_header)
				select word, mesh_header from #cache_word2mesh2
			truncate table [Profile.Cache].[Concept.Mesh.Word2mesh3]
			insert into [Profile.Cache].[Concept.Mesh.Word2mesh3](word, meshterm, meshheader, numwords)
				select word, mesh_term, mesh_header, num_words from #cache_word2mesh3
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdateSimilarConcept]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
  /* 
	create table dbo.cache_similar_concepts (
		MeshHeader nvarchar(255) not null,
		SortOrder int not null, 
		SimilarConcept nvarchar(255), 
		Weight float
	)
	alter table cache_similar_concepts add primary key (MeshHeader, SortOrder)
*/
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
 
	create table #cache_similar_concepts(meshheader nvarchar(255), sortorder int, similarconcept nvarchar(255), weight float)
 
	create table #cache_similar_concepts_tmp(m int, sortorder int, similarm int, weight float)
 
	select MeshHeader, Weight, row_number() over (order by MeshHeader) m 
		into #mesh2num
		from [Profile.Cache].[Concept.Mesh.Count]
	alter table #mesh2num add primary key (MeshHeader)
	create table #num2mesh (m int not null, MeshHeader nvarchar(255))
	insert into #num2mesh (m, MeshHeader) select m, MeshHeader from #mesh2num
	alter table #num2mesh add primary key (m)
 
	create table #cache_user_mesh (m int not null, personid int not null, weight float, meshweight float)
	insert into #cache_user_mesh (m, personid, weight, meshweight)
		select m.m, c.PersonID, c.Weight, m.Weight MeshWeight
		from [Profile.Cache].[Concept.Mesh.Person] c, #mesh2num m
		where c.meshheader = m.meshheader
	alter table #cache_user_mesh add primary key (m, personid)
 
	declare @maxp int
	declare @p int
	select @maxp = max(m) from #num2mesh
	set @p = 1
	while @p <= @maxp
	begin
		INSERT INTO #cache_similar_concepts_tmp(m,sortorder,similarm,weight)
			SELECT m, k, similarm, weight
			FROM (
				SELECT m, similarm, weight, row_number() over (partition by m order by weight desc) k
				FROM (
					SELECT a.m,
						b.m similarm,
						SUM(a.weight * b.weight * b.meshweight) weight
					FROM #cache_user_mesh a inner join #cache_user_mesh b 
						ON a.personid = b.personid 
							AND a.m <> b.m 
							AND a.m between @p and @p+999
					GROUP BY a.m, b.m
				) t
			) t
			WHERE k <= 60
		set @p = @p + 1000
	end
 
	insert into #cache_similar_concepts(meshheader, sortorder, similarconcept, weight)
		select a.meshheader, c.sortorder, b.meshheader, c.weight
		from #cache_similar_concepts_tmp c, #num2mesh a, #num2mesh b
		where c.m = a.m and c.similarm = b.m
 
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.SimilarConcept]
			INSERT INTO [Profile.Cache].[Concept.Mesh.SimilarConcept] (meshheader, sortorder, similarconcept, weight)
				SELECT meshheader, sortorder, similarconcept, weight FROM #cache_similar_concepts
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[CustomViewPersonSameDepartment.GetList]
@NodeID BIGINT, @SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	declare @labelID bigint
	select @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')

	declare @baseURI nvarchar(400)
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'

	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID

	declare @i nvarchar(500)
	declare @d nvarchar(500)
	declare @v nvarchar(500)

	select @i = institutionname, @d = departmentname, @v = divisionfullname
		from [Profile.Cache].[Person]
		where personid = @personid

	declare @InstitutionURI varchar(400)
	declare @DepartmentURI varchar(400)

	select	@InstitutionURI = @baseURI + cast(j.NodeID as varchar(50)),
			@DepartmentURI = @baseURI + cast(e.NodeID as varchar(50))
		from [Profile.Data].[Organization.Institution] i,
			[Profile.Data].[Organization.Department] d,
			[RDF.Stage].[InternalNodeMap] j,
			[RDF.Stage].[InternalNodeMap] e
		where i.InstitutionName = @i and d.DepartmentName = @d
			and j.InternalType = 'Institution' and j.Class = 'http://xmlns.com/foaf/0.1/Organization' and j.InternalID = cast(i.InstitutionID as varchar(50))
			and e.InternalType = 'Department' and e.Class = 'http://xmlns.com/foaf/0.1/Organization' and e.InternalID = cast(d.DepartmentID as varchar(50))

	declare @x xml

	;with a as (
		select a.personid, 
			max(case when a.divisionname = @v then 1 else 0 end) v,
			max(case when s.numpublications > 0 then 1 else 0 end) p
			--row_number() over (order by newid()) k
		from [Profile.Cache].[Person.Affiliation] a, [Profile.Cache].[Person] s
		where a.personid <> @personid
			and a.instititutionname = @i and a.departmentname = @d
			and a.personid = s.personid
		group by a.personid
	), b as (
		select top(5) *
		from a
		order by v desc, p desc, newid()
	), c as (
		select m.NodeID, n.Value URI, l.Value Label
		from b
			inner join [RDF.Stage].[InternalNodeMap] m
				on m.InternalType = 'Person' and m.Class = 'http://xmlns.com/foaf/0.1/Person' and m.InternalID = cast(b.personid as varchar(50))
			inner join [RDF.].[Node] n
				on n.NodeID = m.NodeID and n.ViewSecurityGroup = -1
			inner join [RDF.].[Triple] t
				on t.subject = n.NodeID and t.predicate = @labelID and t.ViewSecurityGroup = -1
			inner join [RDF.].[Node] l
				on l.NodeID = t.object and l.ViewSecurityGroup = -1
	)
	select @x = (
			select	(select count(*) from a) "NumberOfConnections",
					@InstitutionURI "InstitutionURI",
					@DepartmentURI "DepartmentURI",
					(select	NodeID "Connection/@NodeID",
							URI "Connection/@URI",
							Label "Connection"
						from c
						order by Label
						for xml path(''), type
					)
			for xml path('Network'), type
		)

	select @x XML

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [RDF.].[DeleteTriple]
	@TripleID bigint = NULL,
	@SubjectID bigint = NULL,
	@PredicateID bigint = NULL,
	@ObjectID bigint = NULL,
	@SubjectURI varchar(400) = NULL,
	@PredicateURI varchar(400) = NULL,
	@ObjectURI varchar(400) = NULL,
	@DeleteInverse bit = 0,
	@DeleteType tinyint = 0,
	@SessionID uniqueidentifier = NULL,
	-- Output variables
	@Error bit = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	SELECT @Error = 0

	SELECT @TripleID = NULL WHERE @TripleID = 0
	SELECT @SubjectID = NULL WHERE @SubjectID = 0
	SELECT @PredicateID = NULL WHERE @PredicateID = 0
	SELECT @ObjectID = NULL WHERE @ObjectID = 0
	
	-- Convert URIs to NodeIDs
	
 	IF (@SubjectID IS NULL) AND (@SubjectURI IS NOT NULL)
	BEGIN
		SELECT @SubjectID = [RDF.].fnURI2NodeID(@SubjectURI)
		IF @SubjectID IS NULL
			SELECT @Error = 1
	END
		
 	IF (@PredicateID IS NULL) AND (@PredicateURI IS NOT NULL)
	BEGIN
		SELECT @PredicateID = [RDF.].fnURI2NodeID(@PredicateURI)
		IF @PredicateID IS NULL
			SELECT @Error = 1
	END

 	IF (@ObjectID IS NULL) AND (@ObjectURI IS NOT NULL)
	BEGIN
		SELECT @ObjectID = [RDF.].fnURI2NodeID(@ObjectURI)
		IF @ObjectID IS NULL
			SELECT @Error = 1
	END

	IF Coalesce(@TripleID, @SubjectID, @PredicateID, @ObjectID) IS NULL
		SELECT @Error = 1

	IF @Error = 1
	BEGIN
		RETURN
	END

	-- Determine if there is an inverse predicate
	DECLARE @InversePredicateID BIGINT
	SELECT @InversePredicateID = NULL
	IF (@DeleteInverse IS NOT NULL) AND (@TripleID IS NOT NULL) AND (@PredicateID IS NULL)
		SELECT @PredicateID = predicate
			FROM [RDF.].Triple
			WHERE TripleID = @TripleID
	IF (@DeleteInverse IS NOT NULL) AND (@PredicateID IS NOT NULL)
		SELECT @InversePredicateID = object
			FROM [RDF.].Triple
			WHERE subject = @PredicateID
				AND predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#inverseOf')
BEGIN TRY
	BEGIN TRANSACTION
 
		-- Get a list of TripleIDs to delete
		CREATE TABLE #DeleteTriples (
			TripleID bigint primary key,
			subject bigint,
			predicate bigint
		)
		DECLARE @sql NVARCHAR(max)
		SELECT @sql = ''
			+ 'SELECT TripleID, subject, predicate '
			+ 'FROM [RDF.].[Triple] '
			+ 'WHERE 1=1 '
			+ (CASE WHEN @TripleID IS NOT NULL THEN ' AND TripleID = '+CAST(@TripleID AS VARCHAR(50)) ELSE '' END)
			+ (CASE WHEN @SubjectID IS NOT NULL THEN ' AND Subject = '+CAST(@SubjectID AS VARCHAR(50)) ELSE '' END)
			+ (CASE WHEN @PredicateID IS NOT NULL THEN ' AND Predicate = '+CAST(@PredicateID AS VARCHAR(50)) ELSE '' END)
			+ (CASE WHEN @ObjectID IS NOT NULL THEN ' AND Object = '+CAST(@ObjectID AS VARCHAR(50)) ELSE '' END)
		INSERT INTO #DeleteTriples
			EXEC sp_executesql @sql
		
		-- Add inverse triples to list
		IF @InversePredicateID IS NOT NULL
			INSERT INTO #DeleteTriples (TripleID, subject, predicate)
				SELECT t.TripleID, t.subject, t.predicate
					FROM [RDF.].Triple t, [RDF.].Triple v, #DeleteTriples d
					WHERE	t.subject = v.object
						and t.predicate = @InversePredicateID
						and t.object = v.subject
						and v.TripleID = d.TripleID
						and t.TripleID not in (select TripleID from #DeleteTriples)
		
		-- Delete triples
 
		IF @DeleteType = 0 -- True delete
		BEGIN
			-- Delete triples
			DELETE FROM [RDF.].[Triple] WHERE TripleID IN (SELECT TripleID FROM #DeleteTriples)
			-- Update sort orders
			UPDATE t
				SET t.SortOrder = x.SortOrder
				FROM [RDF.].[Triple] t
					INNER JOIN (
						SELECT v.TripleID, row_number() over (partition by v.subject, v.predicate order by v.sortorder) SortOrder
						FROM [RDF.].[Triple] v
							INNER JOIN (
								SELECT DISTINCT subject, predicate
									FROM #DeleteTriples
							) w
							ON v.subject = w.subject AND v.predicate = w.predicate
					) x ON t.TripleID = x.TripleID AND t.SortOrder <> x.SortOrder 
			-- TODO: Delete reitification 
		END
 
		IF @DeleteType = 1 -- Change security groups
		BEGIN
			UPDATE [RDF.].[Triple] SET ViewSecurityGroup = 0 WHERE TripleID IN (SELECT TripleID FROM #DeleteTriples)
		END
 
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [Utility.NLP].[fnPorterStep5]
	(
		@InWord nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN
--STEP 5a
--
--    (m>1) E     ->                  probate        ->  probat
--                                    rate           ->  rate
--    (m=1 and not *o) E ->           cease          ->  ceas
--
--STEP 5b
--
--    (m>1 and *d and *L) -> single letter
--                                    controll       ->  control
--                                    roll           ->  roll

--declaring local variables
    DECLARE @Ret nvarchar(4000), @Temp nvarchar(4000), @m tinyint
    SET @Ret = @InWord

--Step5a
    IF RIGHT(@Ret , 1) = N'e'	            --word ends with e
	BEGIN
	    SELECT @temp = LEFT(@Ret, LEN(@Ret) - 1)
	    SELECT @m = [Utility.NLP].fnPorterCountm(@temp)
	    IF @m > 1						--m>1
		SELECT @Ret = LEFT(@Ret, LEN(@Ret) - 1)
	    ELSE IF @m = 1					--m=1
		BEGIN
		    IF [Utility.NLP].fnPorterEndsCVC(@temp) = 0		--not *o
			SELECT @Ret = LEFT(@Ret, LEN(@Ret) - 1)
		END
	END
----------------------------------------------------------------------------------------------------------
--
--Step5b
IF [Utility.NLP].fnPorterCountm(@Ret) > 1
    BEGIN
	IF [Utility.NLP].fnPorterEndsDoubleConsonant(@Ret) = 1 AND RIGHT(@Ret, 1) = N'l'
	    SELECT @Ret = LEFT(@Ret, LEN(@Ret) - 1)
    END
--retuning the word
RETURN @Ret
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.NLP].[fnPorterStep4]
	(
		@InWord nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN
--STEP 4
--
--    (m>1) AL    ->                  revival        ->  reviv
--    (m>1) ANCE  ->                  allowance      ->  allow
--    (m>1) ENCE  ->                  inference      ->  infer
--    (m>1) ER    ->                  airliner       ->  airlin
--    (m>1) IC    ->                  gyroscopic     ->  gyroscop
--    (m>1) ABLE  ->                  adjustable     ->  adjust
--    (m>1) IBLE  ->                  defensible     ->  defens
--    (m>1) ANT   ->                  irritant       ->  irrit
--    (m>1) EMENT ->                  replacement    ->  replac
--    (m>1) MENT  ->                  adjustment     ->  adjust
--    (m>1) ENT   ->                  dependent      ->  depend
--    (m>1 and (*S or *T)) ION ->     adoption       ->  adopt
--    (m>1) OU    ->                  homologou      ->  homolog
--    (m>1) ISM   ->                  communism      ->  commun
--    (m>1) ATE   ->                  activate       ->  activ
--    (m>1) ITI   ->                  angulariti     ->  angular
--    (m>1) OUS   ->                  homologous     ->  homolog
--    (m>1) IVE   ->                  effective      ->  effect
--    (m>1) IZE   ->                  bowdlerize     ->  bowdler
--
--The suffixes are now removed. All that remains is a little tidying up.

    DECLARE @Ret nvarchar(4000), @Temp nvarchar(4000)
    DECLARE @Phrase1 NVARCHAR(15)
    DECLARE @CursorName CURSOR

--checking word
    SELECT @Ret = @InWord
    SET @CursorName = CURSOR FOR 
	SELECT phrase1 FROM [Utility.NLP].ParsePorterStemming WHERE Step = 4 AND RIGHT(@Ret ,LEN(Phrase1)) = Phrase1
		ORDER BY Ordering
    OPEN @CursorName

    -- Do Step 4
    FETCH NEXT FROM @CursorName INTO @Phrase1
    WHILE @@FETCH_STATUS = 0 
	BEGIN
	    --IF RIGHT(@Ret ,LEN(@Phrase1)) = @Phrase1
		BEGIN
		    SELECT @temp = LEFT(@Ret, LEN(@Ret) - LEN(@Phrase1))
            	    IF [Utility.NLP].fnPorterCountm(@temp) > 1
			BEGIN
			    IF RIGHT(@Ret ,LEN(N'ion')) = N'ion'
				BEGIN
				    IF RIGHT(@temp ,1) = N's' OR RIGHT(@temp ,1) = N't'
					SELECT @Ret = LEFT(@Ret, LEN(@Ret) - LEN(@Phrase1))
				END
			    ELSE
				SELECT @Ret = LEFT(@Ret, LEN(@Ret) - LEN(@Phrase1))
			END
            	    BREAK
		END
	    FETCH NEXT FROM @CursorName INTO @Phrase1
        END

    -- Free Resources
    CLOSE @CursorName
    DEALLOCATE @CursorName

    --retuning the word
    RETURN @Ret
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION  [Utility.NLP].[fnPorterStep3]
	(
		@InWord nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN

/*STEP 3
    (m>0) ICATE ->  IC              triplicate     ->  triplic
    (m>0) ATIVE ->                  formative      ->  form
    (m>0) ALIZE ->  AL              formalize      ->  formal
    (m>0) ICITI ->  IC              electriciti    ->  electric
    (m>0) ICAL  ->  IC              electrical     ->  electric
    (m>0) FUL   ->                  hopeful        ->  hope
    (m>0) NESS  ->                  goodness       ->  good
*/

--declaring local variables
    DECLARE @Ret nvarchar(4000), @Temp nvarchar(4000)
    DECLARE @Phrase1 NVARCHAR(15), @Phrase2 NVARCHAR(15)
    DECLARE @CursorName CURSOR, @i int

--checking word
    SET @Ret = @InWord
    SET @CursorName = CURSOR FOR 
	SELECT phrase1, phrase2 FROM  [Utility.NLP].ParsePorterStemming WHERE Step = 3 AND RIGHT(@Ret ,LEN(Phrase1)) = Phrase1
		ORDER BY Ordering
    OPEN @CursorName

    -- Do Step 2
    FETCH NEXT FROM @CursorName INTO @Phrase1, @Phrase2
    WHILE @@FETCH_STATUS = 0 
	BEGIN
	    --IF RIGHT(@Ret ,LEN(@Phrase1)) = @Phrase1
		BEGIN
		    SELECT @temp = LEFT(@Ret, LEN(@Ret) - LEN(@Phrase1))
            	    IF  [Utility.NLP].fnPorterCountm(@temp) > 0
			SELECT @Ret = LEFT(@Ret, LEN(@Ret) - LEN(@Phrase1)) + @Phrase2
            	    BREAK
		END
	    FETCH NEXT FROM @CursorName INTO @Phrase1, @Phrase2
        END


    -- Free Resources
    CLOSE @CursorName
    DEALLOCATE @CursorName

    --retuning the word
    RETURN @Ret
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION  [Utility.NLP].[fnPorterStep2]
	(
		@InWord nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN

/*STEP 2

    (m>0) ATIONAL ->  ATE           relational     ->  relate
    (m>0) TIONAL  ->  TION          conditional    ->  condition
                                    rational       ->  rational
    (m>0) ENCI    ->  ENCE          valenci        ->  valence
    (m>0) ANCI    ->  ANCE          hesitanci      ->  hesitance
    (m>0) IZER    ->  IZE           digitizer      ->  digitize
Also,
    (m>0) BLI    ->   BLE           conformabli    ->  conformable

    (m>0) ALLI    ->  AL            radicalli      ->  radical
    (m>0) ENTLI   ->  ENT           differentli    ->  different
    (m>0) ELI     ->  E             vileli        - >  vile
    (m>0) OUSLI   ->  OUS           analogousli    ->  analogous
    (m>0) IZATION ->  IZE           vietnamization ->  vietnamize
    (m>0) ATION   ->  ATE           predication    ->  predicate
    (m>0) ATOR    ->  ATE           operator       ->  operate
    (m>0) ALISM   ->  AL            feudalism      ->  feudal
    (m>0) IVENESS ->  IVE           decisiveness   ->  decisive
    (m>0) FULNESS ->  FUL           hopefulness    ->  hopeful
    (m>0) OUSNESS ->  OUS           callousness    ->  callous
    (m>0) ALITI   ->  AL            formaliti      ->  formal
    (m>0) IVITI   ->  IVE           sensitiviti    ->  sensitive
    (m>0) BILITI  ->  BLE           sensibiliti    ->  sensible
Also,
    (m>0) LOGI    ->  LOG           apologi        -> apolog

The test for the string S1 can be made fast by doing a program switch on
the penultimate letter of the word being tested. This gives a fairly even
breakdown of the possible values of the string S1. It will be seen in fact
that the S1-strings in step 2 are presented here in the alphabetical order
of their penultimate letter. Similar techniques may be applied in the other
steps.
*/

--declaring local variables
    DECLARE @Ret nvarchar(4000), @Temp nvarchar(4000)
    DECLARE @Phrase1 NVARCHAR(15), @Phrase2 NVARCHAR(15)
    DECLARE @CursorName CURSOR --, @i int

--checking word
    SET @Ret = @InWord
    SET @CursorName = CURSOR FOR 
	SELECT phrase1, phrase2 FROM  [Utility.NLP].ParsePorterStemming WHERE Step = 2 AND RIGHT(@Ret ,LEN(Phrase1)) = Phrase1
		ORDER BY Ordering
    OPEN @CursorName

    -- Do Step 2
    FETCH NEXT FROM @CursorName INTO @Phrase1, @Phrase2
    WHILE @@FETCH_STATUS = 0 
	BEGIN
	    --IF RIGHT(@Ret ,LEN(@Phrase1)) = @Phrase1
		BEGIN
		    SELECT @temp = LEFT(@Ret, LEN(@Ret) - LEN(@Phrase1))
            	    IF  [Utility.NLP].fnPorterCountm(@temp) > 0
			SELECT @Ret = LEFT(@Ret, LEN(@Ret) - LEN(@Phrase1)) + @Phrase2
            	    BREAK
		END
	    FETCH NEXT FROM @CursorName INTO @Phrase1, @Phrase2
        END
    -- Free Resources
    CLOSE @CursorName
    DEALLOCATE @CursorName


--retuning the word
    RETURN @Ret
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION  [Utility.NLP].[fnPorterStep1]
	(
		@InWord nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN

    DECLARE @Ret nvarchar(4000)
    DECLARE @Phrase1 NVARCHAR(15), @Phrase2 NVARCHAR(15)
    DECLARE @CursorName CURSOR

    -- DO some initial cleanup
    SELECT @Ret = @InWord

/*STEP 1A

    SSES -> SS                         caresses  ->  caress
    IES  -> I                          ponies    ->  poni
                                       ties      ->  ti
    SS   -> SS                         caress    ->  caress
    S    ->                            cats      ->  cat
*/
    -- Create Cursor for Porter Step 1
    SET @CursorName = CURSOR FOR 
	SELECT phrase1, phrase2 FROM  [Utility.NLP].ParsePorterStemming WHERE Step = 1 AND RIGHT(@Ret ,LEN(Phrase1)) = Phrase1
		ORDER BY Ordering
    OPEN @CursorName

    -- Do Step 1
    FETCH NEXT FROM @CursorName INTO @Phrase1, @Phrase2
    WHILE @@FETCH_STATUS = 0 
	BEGIN
	    --IF RIGHT(@Ret ,LEN(@Phrase1)) = @Phrase1
		BEGIN
		    SELECT @Ret = LEFT(@Ret, LEN(@Ret) - LEN(@Phrase1)) + @Phrase2
		    BREAK
		END
	    FETCH NEXT FROM @CursorName INTO @Phrase1, @Phrase2
        END
    -- Free Resources
    CLOSE @CursorName
    DEALLOCATE @CursorName

--STEP 1B
--
--   If
--       (m>0) EED -> EE                     feed      ->  feed
--                                           agreed    ->  agree
--   Else
--       (*v*) ED  ->                        plastered ->  plaster
--                                           bled      ->  bled
--       (*v*) ING ->                        motoring  ->  motor
--                                           sing      ->  sing
--
--If the second or third of the rules in Step 1b is successful, the following
--is done:
--
--    AT -> ATE                       conflat(ed)  ->  conflate
--    BL -> BLE                       troubl(ed)   ->  trouble
--    IZ -> IZE                       siz(ed)      ->  size
--    (*d and not (*L or *S or *Z))
--       -> single letter
--                                    hopp(ing)    ->  hop
--                                    tann(ed)     ->  tan
--                                    fall(ing)    ->  fall
--                                    hiss(ing)    ->  hiss
--                                    fizz(ed)     ->  fizz
--    (m=1 and *o) -> E               fail(ing)    ->  fail
--                                    fil(ing)     ->  file
--
--The rule to map to a single letter causes the removal of one of the double
--letter pair. The -E is put back on -AT, -BL and -IZ, so that the suffixes
---ATE, -BLE and -IZE can be recognised later. This E may be removed in step
--4.

--declaring local variables
DECLARE @m tinyint, @Temp nvarchar(4000),@second_third_success bit

--initializing 
SELECT @second_third_success = 0

--(m>0) EED -> EE..else..(*v*) ED  ->(*v*) ING  ->
    IF RIGHT(@Ret ,LEN(N'eed')) = N'eed'
	BEGIN
	    --counting the number of m--s
	    SELECT @temp = LEFT(@Ret, LEN(@Ret) - LEN(N'eed'))
	    SELECT @m =  [Utility.NLP].fnPorterCountm(@temp)

    	    If @m > 0
                SELECT @Ret = LEFT(@Ret, LEN(@Ret) - LEN(N'eed')) + N'ee' 
	END
    ELSE IF RIGHT(@Ret ,LEN(N'ed')) = N'ed'
	BEGIN
	    --trim and check for vowel
	    SELECT @temp = LEFT(@Ret, LEN(@Ret) - LEN(N'ed'))
	    If  [Utility.NLP].fnPorterContainsVowel(@temp) = 1
		SELECT @ret = LEFT(@Ret, LEN(@Ret) - LEN(N'ed')), @second_third_success = 1
	END
    ELSE IF RIGHT(@Ret ,LEN(N'ing')) = N'ing'
	BEGIN
	    --trim and check for vowel
	    SELECT @temp = LEFT(@Ret, LEN(@Ret) - LEN(N'ing'))
	    If  [Utility.NLP].fnPorterContainsVowel(@temp) = 1
		SELECT @ret = LEFT(@Ret, LEN(@Ret) - LEN(N'ing')), @second_third_success = 1
	END

--If the second or third of the rules in Step 1b is SUCCESSFUL, the following
--is done:
--
--    AT -> ATE                       conflat(ed)  ->  conflate
--    BL -> BLE                       troubl(ed)   ->  trouble
--    IZ -> IZE                       siz(ed)      ->  size
--    (*d and not (*L or *S or *Z))
--       -> single letter
--                                    hopp(ing)    ->  hop
--                                    tann(ed)     ->  tan
--                                    fall(ing)    ->  fall
--                                    hiss(ing)    ->  hiss
--                                    fizz(ed)     ->  fizz
--    (m=1 and *o) -> E               fail(ing)    ->  fail
--                                    fil(ing)     ->  file


IF @second_third_success = 1              --If the second or third of the rules in Step 1b is SUCCESSFUL
    BEGIN        
    	IF RIGHT(@Ret ,LEN(N'at')) = N'at'	--AT -> ATE
	    SELECT @ret = LEFT(@Ret, LEN(@Ret) - LEN(N'at')) + N'ate'
    	ELSE IF RIGHT(@Ret ,LEN(N'bl')) = N'bl'	--BL -> BLE
	    SELECT @ret = LEFT(@Ret, LEN(@Ret) - LEN(N'bl')) + N'ble'
    	ELSE IF RIGHT(@Ret ,LEN(N'iz')) = N'iz'	--IZ -> IZE
	    SELECT @ret = LEFT(@Ret, LEN(@Ret) - LEN(N'iz')) + N'ize'
    	ELSE IF  [Utility.NLP].fnPorterEndsDoubleConsonant(@Ret) = 1  /*(*d and not (*L or *S or *Z))-> single letter*/
	    BEGIN
		IF CHARINDEX(RIGHT(@Ret,1), N'lsz') = 0
		    SELECT @ret = LEFT(@Ret, LEN(@Ret) - 1)
            END
	ELSE IF  [Utility.NLP].fnPorterCountm(@Ret) = 1        /*(m=1 and *o) -> E */
	    BEGIN
	       	IF  [Utility.NLP].fnPorterEndsDoubleCVC(@Ret) = 1
                   SELECT @ret = @Ret + N'e'
            END
    END
    
----------------------------------------------------------------------------------------------------------
--
--STEP 1C
--
--    (*v*) Y -> I                    happy        ->  happi
--                                    sky          ->  sky
IF RIGHT(@Ret ,LEN(N'y')) = N'y'
    BEGIN        
        --trim and check for vowel
        SELECT @temp = LEFT(@Ret, LEN(@Ret)-1)
        IF  [Utility.NLP].fnPorterContainsVowel(@temp) = 1
	    SELECT @ret = LEFT(@Ret, LEN(@Ret) - 1) + N'i'
    END

    RETURN @Ret
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[Beta.SetDisplayPreferences]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select m.NodeID, p.Property, v.NodeID ViewSecurityGroup
		into #NodeProperty
		from [User.Account].[User] u, [Profile.Import].[Beta.DisplayPreference] d, 
			[RDF.Stage].InternalNodeMap m, [RDF.Stage].InternalNodeMap v, (
				select 0 n, [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#authorInAuthorship') Property
				union all
				select 1 n, [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#awardOrHonor') Property
				union all
				select 2 n, [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#overview') Property
				union all
				select 3 n, [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#mainImage') Property
			) p
		where u.PersonID = d.PersonID
			and m.Class = 'http://xmlns.com/foaf/0.1/Person'
			and m.InternalType = 'Person'
			and m.InternalID = cast(u.PersonID as nvarchar(50))
			and v.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
			and v.InternalType = 'User'
			and v.InternalID = cast(u.UserID as nvarchar(50))
			and ( (p.n=0 and d.ShowPublications='N') or (p.n=1 and d.ShowAwards='N') or (p.n=2 and d.ShowNarrative='N') or (p.n=3 and d.ShowPhoto='N') )
	create unique clustered index idx_np on #NodeProperty (NodeID, Property)

	insert into [RDF.Security].NodeProperty (NodeID, Property, ViewSecurityGroup)
		select NodeID, Property, ViewSecurityGroup
			from #NodeProperty a
			where not exists (
				select *
				from [RDF.Security].NodeProperty s
				where a.NodeID = s.NodeID and a.Property = s.Property
			)

	update t
		set t.ViewSecurityGroup = n.ViewSecurityGroup
		from #NodeProperty n, [RDF.].Triple t
		where n.NodeID = t.Subject and n.Property = t.Predicate

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdatePerson]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	SELECT *, 1 WeightCategory, row_number() over (partition by personid order by weight desc, meshheader) k
		INTO #cache_user_mesh
		FROM (
			SELECT PersonID, MeshHeader, max(NumPubsAll) NumPubsAll, count(*) NumPubsThis, sum(MeshWeight) Weight, 
				min(PubYear) FirstPublicationYear, max(PubYear) LastPublicationYear, max(AuthorWeight) MaxAuthorWeight,
				min(PubDate) FirstPubDate, max(PubDate) LastPubDate
			FROM [Profile.Cache].[Concept.Mesh.PersonPublication]
			GROUP BY PersonID, MeshHeader
		) t
	CREATE UNIQUE CLUSTERED INDEX idx_pm ON #cache_user_mesh(personid, meshheader)
 
	UPDATE c
		SET c.WeightCategory = 
			(case	when k <= (case when n.n >= 50 then floor(n.n*0.1) else 5 end) then 2 
					when k >= (n.n - floor((n.n-5)/2)) then 0 
					else 1 end)
		FROM #cache_user_mesh c, (
			select personid, count(*) n
			from #cache_user_mesh
			group by personid
		) n
		WHERE c.personid = n.personid
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.Person]
			INSERT INTO [Profile.Cache].[Concept.Mesh.Person] (PersonID, MeshHeader, NumPubsAll, NumPubsThis, Weight, FirstPublicationYear, LastPublicationYear, MaxAuthorWeight, WeightCategory, FirstPubDate, LastPubDate)
				SELECT PersonID, MeshHeader, NumPubsAll, NumPubsThis, Weight, FirstPublicationYear, LastPublicationYear, MaxAuthorWeight, WeightCategory, FirstPubDate, LastPubDate
				FROM #cache_user_mesh
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Relationship.SetRelationship]
	@SessionID UNIQUEIDENTIFIER,
	@Subject BIGINT,
	@RelationshipType VARCHAR(50) = NULL,
	@SetToExists BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- Get the UserID of the SessionID. Exit if not found.
	DECLARE @SessionUserID INT
	SELECT @SessionUserID = UserID
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID
	IF @SessionUserID IS NULL
		RETURN


	-- Convert the Subject to a PersonID. Exit if not found.
	DECLARE @PersonID INT
	SELECT @PersonID = CAST(InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap]
		WHERE @Subject IS NOT NULL
			AND NodeID = @Subject
			AND Class = 'http://xmlns.com/foaf/0.1/Person'
			AND InternalType = 'Person'
	IF @PersonID IS NULL
		RETURN


	-- Check that the RelationshipType is valid
	IF (@RelationshipType NOT IN ('Collaborator','CurrentAdvisor','PastAdvisor','CurrentAdvisee','PastAdvisee')) AND (@SetToExists = 1)
		RETURN


	-- Delete an existing relationship
	IF @SetToExists = 0
		DELETE
		FROM [User.Account].[Relationship]
		WHERE UserID = @SessionUserID
			AND PersonID = @PersonID
			AND RelationshipType = IsNull(@RelationshipType,RelationshipType)
	

	-- Add a relationship if it doesn't exist
	IF @SetToExists = 1
		INSERT INTO [User.Account].[Relationship] (UserID, PersonID, RelationshipType)
			SELECT @SessionUserID, @PersonID, @RelationshipType
			WHERE NOT EXISTS (
				SELECT *
				FROM [User.Account].[Relationship]
				WHERE UserID = @SessionUserID
					AND PersonID = @PersonID
					AND RelationshipType = @RelationshipType
			)

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Relationship.GetRelationship]
	@SessionID UNIQUEIDENTIFIER,
	@Details BIT = 0,
	@Subject BIGINT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/***********************************************************************
	This procedure does one of five things, based on the input parameters:
	
	1) If the Session is not logged in (i.e. not a user), then..
		Nothing is returned.
		
	2) If a Subject is provided and it is not a person, then...
		Nothing is returned.
	
	3) If a Subject is provided and it is a person, then...
		A list of relationship types is returned, with a flag "DoesExist"
		that indicates whether the Session user has a relationship with
		the Subject person.
	
	4) If a Subject is not provided and Details = 0, then...
		A list of all people who have at least one relationship with the
		Session user is returned.
	
	5) If a Subject is not provided and Details = 1, then...
		A list of all people who have a relationship with the Session user
		is returned, grouped by relationship type.
		
	***********************************************************************/

	-- Get the UserID of the SessionID. Exit if not found.
	DECLARE @SessionUserID INT
	SELECT @SessionUserID = UserID
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID
	IF @SessionUserID IS NULL
		RETURN


	-- Convert the Subject to a PersonID
	DECLARE @PersonID INT
	SELECT @PersonID = NULL
	SELECT @PersonID = CAST(InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap]
		WHERE @Subject IS NOT NULL
			AND NodeID = @Subject
			AND Class = 'http://xmlns.com/foaf/0.1/Person'
			AND InternalType = 'Person'
	IF (@Subject IS NOT NULL) AND (@PersonID IS NULL)
		RETURN


	-- Build a list of relationship types
	DECLARE @r TABLE (
		RelationshipType varchar(50),
		RelationshipName varchar(50),
		SortOrder int
	)
	INSERT INTO @r (RelationshipType, RelationshipName, SortOrder)
		SELECT 'Collaborator', 'Collaborator', 0 
		UNION ALL
		SELECT 'CurrentAdvisor', 'Advisor (Current)', 1 
		UNION ALL
		SELECT 'PastAdvisor', 'Advisor (Past)', 2 
		UNION ALL 
		SELECT 'CurrentAdvisee', 'Advisee (Current)', 3 
		UNION ALL
		SELECT 'PastAdvisee', 'Advisee (Past)', 4
	
	
	-- Return the relationships between the session user and the PersonID
	IF (@PersonID IS NOT NULL)
		SELECT r.RelationshipType, r.RelationshipName, r.SortOrder, 
				(CASE WHEN u.PersonID IS NULL THEN 0 ELSE 1 END) DoesExist
			FROM @r r
				LEFT OUTER JOIN [User.Account].[Relationship] u
					ON u.UserID = @SessionUserID
						AND u.PersonID = @PersonID
						AND r.RelationshipType = u.RelationshipType
			ORDER BY r.SortOrder

	-- Create a temp table to store a list of PersonIDs before converting to NodeIDs
	DECLARE @p AS TABLE (
		RelationshipType VARCHAR(50),
		RelationshipName VARCHAR(100),
		SortOrder INT,
		PersonID INT,
		Name NVARCHAR(100)
	)

	-- Return a list of people who have at least one relationship to the session user
	IF (@PersonID IS NULL) AND (@Details = 0)
	BEGIN
		INSERT INTO @p (PersonID, Name)
			SELECT PersonID,
				LastName + (CASE WHEN LastName<>'' AND FirstName<>'' THEN ', ' ELSE '' END) + FirstName AS Name
			FROM [Profile.Data].[Person] p
			WHERE p.PersonID IN (
					SELECT PersonID
						FROM [User.Account].[Relationship]
						WHERE UserID = @SessionUserID
				) AND p.IsActive = 1

		SELECT	p.PersonID,
				p.Name,
				m.NodeID,
				o.Value + CAST(m.NodeID AS VARCHAR(50)) URI
			FROM @p p
				INNER JOIN [RDF.Stage].[InternalNodeMap] m
					ON m.Class = 'http://xmlns.com/foaf/0.1/Person'
						AND m.InternalType = 'Person'
						AND m.InternalID = CAST(p.PersonID as VARCHAR(50))
				INNER JOIN [Framework.].[Parameter] o
					ON o.ParameterID = 'baseURI'
			ORDER BY p.Name
	END


	-- Return people who have a relationship to the session user, grouped by relationship type
	IF (@PersonID IS NULL) AND (@Details = 1)
	BEGIN
		;WITH a AS (
			SELECT r.RelationshipType, r.RelationshipName, r.SortOrder,
					p.PersonID,
					p.LastName + (CASE WHEN p.LastName<>'' AND p.FirstName<>'' THEN ', ' ELSE '' END) + p.FirstName AS Name
				FROM @r r
					INNER JOIN [User.Account].[Relationship] u
						ON u.UserID = @SessionUserID
							AND r.RelationshipType = u.RelationshipType
					INNER JOIN [Profile.Data].[Person] p
						ON u.PersonID = p.PersonID AND p.IsActive = 1
		), b AS (
			SELECT RelationshipType, COUNT(*) N
				FROM a
				GROUP BY RelationshipType
		)
		INSERT INTO @p (RelationshipType, RelationshipName, SortOrder, PersonID, Name)
			SELECT a.*
				FROM a INNER JOIN b ON a.RelationshipType = b.RelationshipType

		SELECT	p.RelationshipType, 
				p.RelationshipName, 
				p.SortOrder, 
				p.PersonID,
				p.Name,
				m.NodeID,
				o.Value + CAST(m.NodeID AS VARCHAR(50)) URI
			FROM @p p
				INNER JOIN [RDF.Stage].[InternalNodeMap] m
					ON m.Class = 'http://xmlns.com/foaf/0.1/Person'
						AND m.InternalType = 'Person'
						AND m.InternalID = CAST(p.PersonID as VARCHAR(50))
				INNER JOIN [Framework.].[Parameter] o
					ON o.ParameterID = 'baseURI'
			ORDER BY p.SortOrder, p.Name, p.PersonID
	END


END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.Pubmed.ParsePubMedXML]
	@pmid int
AS
BEGIN
	SET NOCOUNT ON;


	UPDATE [Profile.Data].[Publication.PubMed.AllXML] set ParseDT = GetDate() where pmid = @pmid


	delete from [Profile.Data].[Publication.PubMed.Author] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Investigator] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.PubType] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Chemical] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Databank] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Accession] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Keyword] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Grant] where pmid = @pmid
	delete from [Profile.Data].[Publication.PubMed.Mesh] where pmid = @pmid
	
	-- Update pm_pubs_general if record exists, else insert new record
	IF EXISTS (SELECT 1 FROM [Profile.Data].[Publication.PubMed.General] WHERE pmid = @pmid) 
		BEGIN 
		
			UPDATE g
			   SET 	Owner= nref.value('@Owner[1]','varchar(max)') ,
							Status = nref.value('@Status[1]','varchar(max)') ,
							PubModel=nref.value('Article[1]/@PubModel','varchar(max)') ,
							Volume	 = nref.value('Article[1]/Journal[1]/JournalIssue[1]/Volume[1]','varchar(max)') ,
							Issue = nref.value('Article[1]/Journal[1]/JournalIssue[1]/Issue[1]','varchar(max)') ,
							MedlineDate = nref.value('Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/MedlineDate[1]','varchar(max)') ,
							JournalYear = nref.value('Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/Year[1]','varchar(max)') ,
							JournalMonth = nref.value('Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/Month[1]','varchar(max)') ,
							JournalDay=nref.value('Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/Day[1]','varchar(max)') ,
							JournalTitle = nref.value('Article[1]/Journal[1]/Title[1]','varchar(max)') ,
							ISOAbbreviation=nref.value('Article[1]/Journal[1]/ISOAbbreviation[1]','varchar(max)') ,
							MedlineTA = nref.value('MedlineJournalInfo[1]/MedlineTA[1]','varchar(max)') ,
							ArticleTitle = nref.value('Article[1]/ArticleTitle[1]','varchar(max)') ,
							MedlinePgn = nref.value('Article[1]/Pagination[1]/MedlinePgn[1]','varchar(max)') ,
							AbstractText = nref.value('Article[1]/Abstract[1]/AbstractText[1]','varchar(max)') ,
							ArticleDateType= nref.value('Article[1]/ArticleDate[1]/@DateType[1]','varchar(max)') ,
							ArticleYear = nref.value('Article[1]/ArticleDate[1]/Year[1]','varchar(max)') ,
							ArticleMonth = nref.value('Article[1]/ArticleDate[1]/Month[1]','varchar(max)') ,
							ArticleDay = nref.value('Article[1]/ArticleDate[1]/Day[1]','varchar(max)') ,
							Affiliation=nref.value('Article[1]/Affiliation[1]','varchar(max)') ,
							AuthorListCompleteYN = nref.value('Article[1]/AuthorList[1]/@CompleteYN[1]','varchar(max)') ,
							GrantListCompleteYN=nref.value('Article[1]/GrantList[1]/@CompleteYN[1]','varchar(max)') 
				FROM  [Profile.Data].[Publication.PubMed.General]  g
				JOIN  [Profile.Data].[Publication.PubMed.AllXML] a ON a.pmid = g.pmid
					 CROSS APPLY  x.nodes('//MedlineCitation[1]') as R(nref)
				WHERE a.pmid = @pmid
				
		END
	ELSE 
		BEGIN 
		
			--*** general ***
			insert into [Profile.Data].[Publication.PubMed.General] (pmid, Owner, Status, PubModel, Volume, Issue, MedlineDate, JournalYear, JournalMonth, JournalDay, JournalTitle, ISOAbbreviation, MedlineTA, ArticleTitle, MedlinePgn, AbstractText, ArticleDateType, ArticleYear, ArticleMonth, ArticleDay, Affiliation, AuthorListCompleteYN, GrantListCompleteYN)
				select pmid, 
					nref.value('@Owner[1]','varchar(max)') Owner,
					nref.value('@Status[1]','varchar(max)') Status,
					nref.value('Article[1]/@PubModel','varchar(max)') PubModel,
					nref.value('Article[1]/Journal[1]/JournalIssue[1]/Volume[1]','varchar(max)') Volume,
					nref.value('Article[1]/Journal[1]/JournalIssue[1]/Issue[1]','varchar(max)') Issue,
					nref.value('Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/MedlineDate[1]','varchar(max)') MedlineDate,
					nref.value('Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/Year[1]','varchar(max)') JournalYear,
					nref.value('Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/Month[1]','varchar(max)') JournalMonth,
					nref.value('Article[1]/Journal[1]/JournalIssue[1]/PubDate[1]/Day[1]','varchar(max)') JournalDay,
					nref.value('Article[1]/Journal[1]/Title[1]','varchar(max)') JournalTitle,
					nref.value('Article[1]/Journal[1]/ISOAbbreviation[1]','varchar(max)') ISOAbbreviation,
					nref.value('MedlineJournalInfo[1]/MedlineTA[1]','varchar(max)') MedlineTA,
					nref.value('Article[1]/ArticleTitle[1]','varchar(max)') ArticleTitle,
					nref.value('Article[1]/Pagination[1]/MedlinePgn[1]','varchar(max)') MedlinePgn,
					nref.value('Article[1]/Abstract[1]/AbstractText[1]','varchar(max)') AbstractText,
					nref.value('Article[1]/ArticleDate[1]/@DateType[1]','varchar(max)') ArticleDateType,
					nref.value('Article[1]/ArticleDate[1]/Year[1]','varchar(max)') ArticleYear,
					nref.value('Article[1]/ArticleDate[1]/Month[1]','varchar(max)') ArticleMonth,
					nref.value('Article[1]/ArticleDate[1]/Day[1]','varchar(max)') ArticleDay,
					nref.value('Article[1]/Affiliation[1]','varchar(max)') Affiliation,
					nref.value('Article[1]/AuthorList[1]/@CompleteYN[1]','varchar(max)') AuthorListCompleteYN,
					nref.value('Article[1]/GrantList[1]/@CompleteYN[1]','varchar(max)') GrantListCompleteYN
				from [Profile.Data].[Publication.PubMed.AllXML] cross apply x.nodes('//MedlineCitation[1]') as R(nref)
				where pmid = @pmid
	END


	--*** authors ***
	insert into [Profile.Data].[Publication.PubMed.Author] (pmid, ValidYN, LastName, FirstName, ForeName, Suffix, Initials, Affiliation)
		select pmid, 
			nref.value('@ValidYN','varchar(max)') ValidYN, 
			nref.value('LastName[1]','varchar(max)') LastName, 
			nref.value('FirstName[1]','varchar(max)') FirstName,
			nref.value('ForeName[1]','varchar(max)') ForeName,
			nref.value('Suffix[1]','varchar(max)') Suffix,
			nref.value('Initials[1]','varchar(max)') Initials,
			nref.value('Affiliation[1]','varchar(max)') Affiliation
		from [Profile.Data].[Publication.PubMed.AllXML] cross apply x.nodes('//AuthorList/Author') as R(nref)
		where pmid = @pmid
		

	--*** investigators ***
	insert into [Profile.Data].[Publication.PubMed.Investigator] (pmid, LastName, FirstName, ForeName, Suffix, Initials, Affiliation)
		select pmid, 
			nref.value('LastName[1]','varchar(max)') LastName, 
			nref.value('FirstName[1]','varchar(max)') FirstName,
			nref.value('ForeName[1]','varchar(max)') ForeName,
			nref.value('Suffix[1]','varchar(max)') Suffix,
			nref.value('Initials[1]','varchar(max)') Initials,
			nref.value('Affiliation[1]','varchar(max)') Affiliation
		from [Profile.Data].[Publication.PubMed.AllXML] cross apply x.nodes('//InvestigatorList/Investigator') as R(nref)
		where pmid = @pmid
		

	--*** pubtype ***
	insert into [Profile.Data].[Publication.PubMed.PubType] (pmid, PublicationType)
		select * from (
			select distinct pmid, nref.value('.','varchar(max)') PublicationType
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//PublicationTypeList/PublicationType') as R(nref)
			where pmid = @pmid
		) t where PublicationType is not null


	--*** chemicals
	insert into [Profile.Data].[Publication.PubMed.Chemical] (pmid, NameOfSubstance)
		select * from (
			select distinct pmid, nref.value('.','varchar(max)') NameOfSubstance
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//ChemicalList/Chemical/NameOfSubstance') as R(nref)
			where pmid = @pmid
		) t where NameOfSubstance is not null


	--*** databanks ***
	insert into [Profile.Data].[Publication.PubMed.Databank] (pmid, DataBankName)
		select * from (
			select distinct pmid, 
				nref.value('.','varchar(max)') DataBankName
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//DataBankList/DataBank/DataBankName') as R(nref)
			where pmid = @pmid
		) t where DataBankName is not null


	--*** accessions ***
	insert into [Profile.Data].[Publication.PubMed.Accession] (pmid, DataBankName, AccessionNumber)
		select * from (
			select distinct pmid, 
				nref.value('../../DataBankName[1]','varchar(max)') DataBankName,
				nref.value('.','varchar(max)') AccessionNumber
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//DataBankList/DataBank/AccessionNumberList/AccessionNumber') as R(nref)
			where pmid = @pmid
		) t where DataBankName is not null and AccessionNumber is not null


	--*** keywords ***
	insert into [Profile.Data].[Publication.PubMed.Keyword] (pmid, Keyword, MajorTopicYN)
		select pmid, Keyword, max(MajorTopicYN)
		from (
			select pmid, 
				nref.value('.','varchar(max)') Keyword,
				nref.value('@MajorTopicYN','varchar(max)') MajorTopicYN
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//KeywordList/Keyword') as R(nref)
			where pmid = @pmid
		) t where Keyword is not null
		group by pmid, Keyword


	--*** grants ***
	insert into [Profile.Data].[Publication.PubMed.Grant] (pmid, GrantID, Acronym, Agency)
		select pmid, GrantID, max(Acronym), max(Agency)
		from (
			select pmid, 
				nref.value('GrantID[1]','varchar(max)') GrantID, 
				nref.value('Acronym[1]','varchar(max)') Acronym,
				nref.value('Agency[1]','varchar(max)') Agency
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//GrantList/Grant') as R(nref)
			where pmid = @pmid
		) t where GrantID is not null
		group by pmid, GrantID


	--*** mesh ***
	insert into [Profile.Data].[Publication.PubMed.Mesh] (pmid, DescriptorName, QualifierName, MajorTopicYN)
		select pmid, DescriptorName, coalesce(QualifierName,''), max(MajorTopicYN)
		from (
			select pmid, 
				nref.value('@MajorTopicYN[1]','varchar(max)') MajorTopicYN, 
				nref.value('.','varchar(max)') DescriptorName,
				null QualifierName
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//MeshHeadingList/MeshHeading/DescriptorName') as R(nref)
			where pmid = @pmid
			union all
			select pmid, 
				nref.value('@MajorTopicYN[1]','varchar(max)') MajorTopicYN, 
				nref.value('../DescriptorName[1]','varchar(max)') DescriptorName,
				nref.value('.','varchar(max)') QualifierName
			from [Profile.Data].[Publication.PubMed.AllXML]
				cross apply x.nodes('//MeshHeadingList/MeshHeading/QualifierName') as R(nref)
			where pmid = @pmid
		) t where DescriptorName is not null
		group by pmid, DescriptorName, QualifierName





	--*** general (authors) ***

	declare @a as table (
		i int identity(0,1) primary key,
		pmid int,
		lastname varchar(100),
		initials varchar(20),
		s varchar(max)
	)

	insert into @a (pmid, lastname, initials)
		select pmid, lastname, initials
		from [Profile.Data].[Publication.PubMed.Author]
		where pmid = @pmid
		order by pmid, PmPubsAuthorID

	declare @s varchar(max)
	declare @lastpmid int
	set @s = ''
	set @lastpmid = -1

	update @a
		set
			@s = s = case
					when @lastpmid <> pmid then lastname+' '+initials
					else @s + ', ' + lastname+' '+initials
				end,
			@lastpmid = pmid

	--create nonclustered index idx_p on @a (pmid)

	update g
		set g.authors = coalesce(a.authors,'')
		from [Profile.Data].[Publication.PubMed.General] g, (
				select pmid, (case when authors > authors_short then authors_short+', et al' else authors end) authors
				from (
					select pmid, max(s) authors,
							max(case when len(s)<3990 then s else '' end) authors_short
						from @a group by pmid
				) t
			) a
		where g.pmid = a.pmid





	--*** general (pubdate) ***

	declare @d as table (
		pmid int,
		PubDate datetime
	)

	insert into @d (pmid,PubDate)
		select pmid,[Profile.Data].[fnPublication.Pubmed.GetPubDate](MedlineDate,JournalYear,JournalMonth,JournalDay,ArticleYear,ArticleMonth,ArticleDay)
		from [Profile.Data].[Publication.PubMed.General]
		where pmid = @pmid



	/*

	insert into @d (pmid,PubDate)
		select pmid,
			case when JournalMonth is not null then JournalMonth
				when MedlineMonth is not null then MedlineMonth
				else coalesce(ArticleMonth,'1') end
			+'/'+
			case when JournalMonth is not null then coalesce(JournalDay,'1')
				when MedlineMonth is not null then '1'
				else coalesce(ArticleDay,'1') end
			+'/'+
			case when JournalYear is not null then coalesce(JournalYear,'1900')
				when MedlineMonth is not null then coalesce(MedlineYear,'1900')
				else coalesce(ArticleYear,'1900') end
			as PubDate
		from (
			select pmid, ArticleYear, ArticleDay, MedlineYear, JournalYear, JournalDay,
				(case MedlineMonth
					when 'Jan' then '1'
					when 'Feb' then '2'
					when 'Mar' then '3'
					when 'Arp' then '4'
					when 'May' then '5'
					when 'Jun' then '6'
					when 'Jul' then '7'
					when 'Aug' then '8'
					when 'Sep' then '9'
					when 'Oct' then '10'
					when 'Nov' then '11'
					when 'Dec' then '12'
					when 'Win' then '1'
					when 'Spr' then '4'
					when 'Sum' then '7'
					when 'Fal' then '10'
					else null end) MedlineMonth,
				(case JournalMonth
					when 'Jan' then '1'
					when 'Feb' then '2'
					when 'Mar' then '3'
					when 'Arp' then '4'
					when 'May' then '5'
					when 'Jun' then '6'
					when 'Jul' then '7'
					when 'Aug' then '8'
					when 'Sep' then '9'
					when 'Oct' then '10'
					when 'Nov' then '11'
					when 'Dec' then '12'
					when 'Win' then '1'
					when 'Spr' then '4'
					when 'Sum' then '7'
					when 'Fal' then '10'
					when '1' then '1'
					when '2' then '2'
					when '3' then '3'
					when '4' then '4'
					when '5' then '5'
					when '6' then '6'
					when '7' then '7'
					when '8' then '8'
					when '9' then '9'
					when '10' then '10'
					when '11' then '11'
					when '12' then '12'
					else null end) JournalMonth,
				(case ArticleMonth
					when 'Jan' then '1'
					when 'Feb' then '2'
					when 'Mar' then '3'
					when 'Arp' then '4'
					when 'May' then '5'
					when 'Jun' then '6'
					when 'Jul' then '7'
					when 'Aug' then '8'
					when 'Sep' then '9'
					when 'Oct' then '10'
					when 'Nov' then '11'
					when 'Dec' then '12'
					when 'Win' then '1'
					when 'Spr' then '4'
					when 'Sum' then '7'
					when 'Fal' then '10'
					when '1' then '1'
					when '2' then '2'
					when '3' then '3'
					when '4' then '4'
					when '5' then '5'
					when '6' then '6'
					when '7' then '7'
					when '8' then '8'
					when '9' then '9'
					when '10' then '10'
					when '11' then '11'
					when '12' then '12'
					else null end) ArticleMonth
			from (
				select pmid,
					left(medlinedate,4) as MedlineYear,
					substring(replace(medlinedate,' ',''),5,3) as MedlineMonth,
					JournalYear, left(journalMonth,3) as JournalMonth, JournalDay,
					ArticleYear, ArticleMonth, ArticleDay
				from pm_pubs_general
				where pmid = @pmid
			) t
		) t

	*/


	--create nonclustered index idx_p on @d (pmid)

	update g
		set g.PubDate = coalesce(d.PubDate,'1/1/1900')
		from [Profile.Data].[Publication.PubMed.General] g, @d d
		where g.pmid = d.pmid


END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Author2Person](
	[PersonID] [int] NOT NULL,
	[PmPubsAuthorID] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	 procedure [Profile.Data].[Publication.Pubmed.AddOneAuthorPosition]
	@PersonID INT,
	@pmid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select distinct @pmid pmid, p.personid, p.lastname, p.firstname, '' middlename,
			left(p.lastname,1) ln, left(p.firstname,1) fn, left('',1) mn
		into #pmid_person_name
		from [Profile.Cache].Person p
		where p.personid = @personid
	create unique clustered index idx_pu on #pmid_person_name(pmid,personid)

	select distinct pmid, personid, pmpubsauthorid
		into #authorid_personid
		from (
			select a.pmid, a.PmPubsAuthorID, p.personid, dense_rank() over (partition by a.pmid, p.personid order by 
				(case when a.lastname = p.lastname and (a.forename like p.firstname + left(p.middlename,1) + '%') then 1
					when a.lastname = p.lastname and (a.forename like p.firstname + '%') and len(p.firstname) > 1 then 2
					when a.lastname = p.lastname and a.initials = p.fn+p.mn then 3
					when a.lastname = p.lastname and left(a.initials,1) = p.fn then 4
					when a.lastname = p.lastname then 5
					else 6 end) ) k
			from [Profile.Data].[Publication.PubMed.Author]	 a inner join #pmid_person_name p 
				on a.pmid = p.pmid and a.validyn = 'Y' and left(a.lastname,1) = p.ln
		) t
		where k = 1
	create unique clustered index idx_ap on #authorid_personid(pmid, personid, pmpubsauthorid)

	select pmid, min(pmpubsauthorid) a, max(pmpubsauthorid) b
		into #pmid_authorid_range
		from [Profile.Data].[Publication.PubMed.Author]
		group by pmid
	create unique clustered index idx_p on #pmid_authorid_range(pmid)

	select PersonID, pmid, a AuthorPosition, 
			(case when a in ('F','L','S') then 1.00
				when a in ('M') then 0.25
				else 0.50 end) AuthorWeight
		into #cache_author_position
		from (
			select pmid, personid, a, row_number() over (partition by pmid, personid order by k) k
			from (
				select a.pmid, a.personid,
						(case when a.pmpubsauthorid = r.a then 'F'
							when a.pmpubsauthorid = r.b then 'L'
							else 'M'
							end) a,
						(case when a.pmpubsauthorid = r.a then 1
							when a.pmpubsauthorid = r.b then 2
							else 3
							end) k
					from #authorid_personid a, #pmid_authorid_range r
					where a.pmid = r.pmid and r.b <> r.a
				union all
				select p.pmid, p.personid, 'S' a, 0 k
					from #pmid_person_name p, #pmid_authorid_range r
					where p.pmid = r.pmid and r.a = r.b
				union all
				select pmid, personid, 'U' a, 9 k
					from #pmid_person_name
			) t
		) t
		where k = 1
	create clustered index idx_pmid on #cache_author_position(pmid)

	select PersonID, a.pmid, AuthorPosition, AuthorWeight, g.PubDate, year(g.PubDate) PubYear,
			(case when g.PubDate = '1900-01-01 00:00:00.000' then 0.5
				else power(cast(0.5 as float),cast(datediff(d,g.PubDate,GetDate()) as float)/365.25/10)
				end) YearWeight
		into #cache_pm_author_position
		from #cache_author_position a, [Profile.Data].[Publication.PubMed.General] g
		where a.pmid = g.pmid
	update #cache_pm_author_position
		set PubYear = Year(GetDate()), YearWeight = 1
		where YearWeight > 1

	delete t
		from #cache_pm_author_position t, [Profile.Cache].[Publication.PubMed.AuthorPosition] c
		where t.personid = c.personid and t.pmid = c.pmid

	INSERT INTO [Profile.Cache].[Publication.PubMed.AuthorPosition]
	         (PersonID, pmid, AuthorPosition, AuthorWeight, PubDate, PubYear, YearWeight)
		SELECT PersonID, pmid, AuthorPosition, AuthorWeight, PubDate, PubYear, YearWeight 
		FROM #cache_pm_author_position

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.Person.Include](
	[PubID] [uniqueidentifier] NOT NULL,
	[PersonID] [int] NULL,
	[PMID] [int] NULL,
	[MPID] [nvarchar](50) NULL,
 CONSTRAINT [PK__publications_inc__339FAB6E] PRIMARY KEY CLUSTERED 
(
	[PubID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_mu] ON [Profile.Data].[Publication.Person.Include] 
(
	[MPID] ASC,
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_pu] ON [Profile.Data].[Publication.Person.Include] 
(
	[PMID] ASC,
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_u] ON [Profile.Data].[Publication.Person.Include] 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.Person.Exclude](
	[PubID] [uniqueidentifier] NOT NULL,
	[PersonID] [int] NULL,
	[PMID] [int] NULL,
	[MPID] [nvarchar](50) NULL,
 CONSTRAINT [PK__publications_exc__3587F3E0] PRIMARY KEY CLUSTERED 
(
	[PubID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.Person.Add](
	[PubID] [uniqueidentifier] NOT NULL,
	[PersonID] [int] NOT NULL,
	[PMID] [int] NULL,
	[MPID] [nvarchar](50) NULL,
 CONSTRAINT [PK__publications_add__37703C52] PRIMARY KEY CLUSTERED 
(
	[PubID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.Cache].[Public.UpdateCache]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	declare @typeID bigint
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')

	declare @labelID bigint
	select @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')

	--------------------------------------------------
	-- NodeMap
	--------------------------------------------------

	select t.Subject NodeID, c._PropertyNode Property, max(SearchWeight) SearchWeight
		into #n
		from [Ontology.].ClassProperty c, [RDF.].Triple t, [RDF.].Node n
		where t.Predicate = @typeID and t.object = c._ClassNode and c.SearchWeight > 0
			and t.Subject = n.NodeID
			and t.ViewSecurityGroup = -1
			and n.ViewSecurityGroup = -1
		group by t.Subject, c._PropertyNode
	create unique clustered index idx_np on #n(NodeID,Property)

	create table #s (
		NodeID bigint not null,
		MatchedByNodeID bigint not null,
		Distance int,
		Paths int,
		Weight float
	)
	alter table #s add primary key (NodeID, MatchedByNodeID)

	insert into #s (NodeID, MatchedByNodeID, Distance, Paths, Weight)
		select x.NodeID, t.Object, 1, count(*), 1-exp(sum(log(case when x.SearchWeight*t.Weight > 0.999999 then 0.000001 else 1-x.SearchWeight*t.Weight end)))
			from #n x, [RDF.].Triple t, [RDF.].Node n
			where x.NodeID = t.subject and x.Property = t.predicate and x.SearchWeight*t.Weight > 0
				and t.Object = n.NodeID
				and t.ViewSecurityGroup = -1
				and n.ViewSecurityGroup = -1
			group by x.NodeID, t.Object

	declare @i int
	select @i = 1
	while @i < 10
	begin
		insert into #s (NodeID, MatchedByNodeID, Distance, Paths, Weight)
			select s.NodeID, t.MatchedByNodeID, @i+1, count(*), 1-exp(sum(log(case when s.Weight*t.Weight > 0.999999 then 0.000001 else 1-s.Weight*t.Weight end)))
				from #s s, #s t
				where s.MatchedByNodeID = t.NodeID
					and s.Distance = @i
					and t.Distance = 1
					and t.NodeID <> s.NodeID
					and not exists (
						select *
						from #s u
						where u.NodeID = s.NodeID and u.MatchedByNodeID = t.MatchedByNodeID
					)
				group by s.NodeID, t.MatchedByNodeID
		if @@ROWCOUNT = 0
			select @i = 10
		select @i = @i + 1
	end


	--------------------------------------------------
	-- NodeSummary (Part 1)
	--------------------------------------------------

	select t.subject NodeID, min(case when len(n.Value)>500 then left(n.Value,497)+'...' else n.Value end) Label
		into #l
		from [RDF.].Triple t, [RDF.].Node n
		where t.predicate = @labelID and t.object = n.NodeID
			and t.subject in (select NodeID from #s)
			and t.ViewSecurityGroup = -1
			and n.ViewSecurityGroup = -1
		group by t.subject


	--------------------------------------------------
	-- NodeClass
	--------------------------------------------------

	select distinct l.NodeID, t.Object
		into #c
		from [RDF.].Node l, [RDF.].Triple t, [RDF.].Node n
		where l.NodeID = t.subject and t.predicate = @typeID and t.object = n.NodeID
			and t.ViewSecurityGroup = -1
			and n.ViewSecurityGroup = -1
			and l.ViewSecurityGroup = -1

	create unique clustered index idx_no on #c(NodeID, Object)

	--------------------------------------------------
	-- NodeSummary (Part 2)
	--------------------------------------------------
	CREATE INDEX idx_c ON #c ([Object]) INCLUDE ([NodeID])							
	CREATE INDEX idx_l ON #l ([NodeID]) INCLUDE ([Label])	

	select NodeID, Label, ClassName, row_number() over (order by Label, NodeID) SortOrder
		into #l2
		from (
			select l.NodeID, l.Label, d._ClassName ClassName,
				row_number() over (partition by l.NodeID order by IsNull(d._TreeDepth,0) desc, d._ClassName) k
			from #l l
				inner join #c c on l.NodeID = c.NodeID
				inner join [Ontology.].ClassGroupClass g on c.Object = g._ClassNode
				left outer join [Ontology.].ClassTreeDepth d on c.Object = d._ClassNode
		) t
		where k = 1

	--------------------------------------------------
	-- NodeRDF
	--------------------------------------------------

	select n.NodeID, c._PropertyNode PropertyNode, max(Limit) Limit, max(cast(c.IncludeDescription as tinyint)) IncludeDescription, max(_TagName) TagName
		into #NodePropertyExpand
		from #c n, [Ontology.].ClassProperty c, [RDF.].Node p
		where n.Object = c._ClassNode
			and c._NetworkPropertyNode is null
			and c.IsDetail = 0
			and c._PropertyNode = p.NodeID
			and p.ViewSecurityGroup = -1
		group by n.NodeID, c._PropertyNode
	--[10740312 in 00:00:31]

	select e.NodeID, o.NodeID ExpandNodeID, e.IncludeDescription, e.TagName, o.ObjectType, o.Value, o.Language, o.DataType
		into #NodePropertyValue
		from #NodePropertyExpand e, [RDF.].Triple t, [RDF.].Node o
		where t.subject = e.NodeID
			and t.predicate = e.PropertyNode
			and t.object = o.NodeID
			and t.ViewSecurityGroup = -1
			and o.ViewSecurityGroup = -1
			and ((e.Limit is null) or (t.SortOrder <= e.Limit))
	--[8646849 in 00:01:31]

	select NodeID, ExpandNodeID,
			'_TAGLT_'+tagName
			+(case when ObjectType = 0 then ' rdf:resource="'+Value+'"/_TAGGT_' 
					else '_TAGGT_'+Value+'_TAGLT_/'+tagName+'_TAGGT_' end)
			TagValue
		into #NodePropertyTagTemp
		from (
			select NodeID, ExpandNodeID, TagName, ObjectType, Language, DataType,
				(case when charindex(char(0),cast(Value as varchar(max))) > 0
						then replace(replace(replace(replace(cast(Value as varchar(max)),char(0),''),'&','&amp;'),'<','&lt;'),'>','&gt;')
						else replace(replace(replace(Value,'&','&amp;'),'<','&lt;'),'>','&gt;')
						end) Value
				from #NodePropertyValue
		) t
	--[9162177 in 00:03:39]

	create nonclustered index idx_n on #NodePropertyTagTemp(NodeID)
	--[00:00:07]

	select NodeID, ExpandNodeID, TagValue, row_number() over (partition by NodeID order by TagValue) k
		into #NodePropertyTag
		from #NodePropertyTagTemp
	--[9162177 in 00:00:34]
	
	create clustered index idx_nk on #NodePropertyTag(NodeID,k)
	--[00:00:07]
	create nonclustered index idx_kn on #NodePropertyTag(k,NodeID)
	--[00:00:10]

	select NodeID, TagValue Tags
		into #NodeTags
		from #NodePropertyTag
		where k = 1
		
	create unique clustered index idx_n on #NodeTags(NodeID)
		
	declare @k int
	select @k = 2
	while (@k > 0) and (@k < 25)
	begin
		update t
			set t.Tags = t.Tags + p.TagValue
			from #NodeTags t
				inner join #NodePropertyTag p
					on t.NodeID = p.NodeID and p.k = @k
		if @@ROWCOUNT = 0
			select @k = -1
		else
			select @k = @k + 1			
	end
	--[4162659 in 00:05:01]

	
	--[00:00:16]
		
	/*	
	select NodeID,
			cast((
				select b.TagValue+''	
					from #NodePropertyTag b
					where b.NodeID = a.NodeID
					order by b.TagValue
					for xml path(''), type
			) as nvarchar(max))
			Tags
		into #NodeTags
		from #NodePropertyTag a
		group by NodeID
	--[3764783 in 00:13:18]
	*/
	
	select t.NodeID, 
			'_TAGLT_rdf:Description rdf:about="' + replace(replace(replace(n.Value,'&','&amp;'),'<','&lt;'),'>','&gt;') + '"_TAGGT_'
			+ t.Tags
			+ '_TAGLT_/rdf:Description_TAGGT_'
			RDF
		into #NodeRDF
		from #NodeTags t, [RDF.].Node n
		where t.NodeID = n.NodeID
	--[4162659 in 00:01:40]


	--------------------------------------------------
	-- NodeExpand
	--------------------------------------------------

	select distinct NodeID, ExpandNodeID
		into #NodeExpand
		from #NodePropertyValue
		where IncludeDescription = 1
	--[5370803 in 00:00:06]


	--------------------------------------------------
	-- NodePrefix
	--------------------------------------------------

	create table #NodePrefix (
		Prefix varchar(800) not null,
		NodeID bigint not null
	)
	insert into #NodePrefix (Prefix,NodeID)
		select left(Value,800), NodeID
			from [RDF.].Node
			where ViewSecurityGroup = -1
	--[5710775 in 00:00:09]
	alter table #NodePrefix add primary key (Prefix, NodeID)
	--[00:00:13]


	--------------------------------------------------
	-- Update actual tables
	--------------------------------------------------

	BEGIN TRY
		BEGIN TRAN
		
			truncate table [Search.Cache].[Public.NodeMap]
			insert into [Search.Cache].[Public.NodeMap]
				select * from #s
			truncate table [Search.Cache].[Public.NodeSummary]
			insert into [Search.Cache].[Public.NodeSummary]
				select * from #l2
			truncate table [Search.Cache].[Public.NodeClass]
			insert into [Search.Cache].[Public.NodeClass]
				select * from #c
					

			truncate table [Search.Cache].[Public.NodeExpand]
			insert into [Search.Cache].[Public.NodeExpand] (NodeID, ExpandNodeID)
				select NodeID, ExpandNodeID
					from #NodeExpand
			--[5370803 in 00:00:17]

			truncate table [Search.Cache].[Public.NodeRDF]
			insert into [Search.Cache].[Public.NodeRDF] (NodeID, RDF)
				select NodeID, RDF
					from #NodeRDF
			--[3764783 in 00:00:30]

			truncate table [Search.Cache].[Public.NodePrefix]
			insert into [Search.Cache].[Public.NodePrefix] (Prefix, NodeID)
				select Prefix, NodeID
					from #NodePrefix
			--[8001238 in 00:00:57]

		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		--Raise an error with the details of the exception
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Person.UpdatePhysicalNeighbor]
AS
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	SELECT personid, neighborid, distance, displayname, myneighbors
		INTO #neighbors
		FROM (
			SELECT personid, neighborid, d distance, displayname, lf myneighbors, row_number() over (partition by personid order by d, newid()) k
			FROM (
				select p.personid, q.personid neighborid, q.displayname, q.lastname + ', ' + q.firstname lf,
					(CASE
						WHEN p.room <> '' and p.room = q.room THEN 1
						WHEN p.floor <> '' and p.floor = q.floor THEN 2
						WHEN p.building <> '' and p.building = q.building THEN 3
						WHEN p.institutionname <> '' and p.departmentname <> '' and p.divisionfullname <> '' and p.institutionname = q.institutionname and p.departmentname = q.departmentname and p.divisionfullname = q.divisionfullname THEN 4
						WHEN p.institutionname <> '' and p.departmentname <> '' and p.institutionname = q.institutionname and p.departmentname = q.departmentname THEN 5
						WHEN p.institutionname <> '' and p.institutionname = q.institutionname THEN 6
						ELSE 7
					END) d
				from [Profile.Cache].Person p, [Profile.Cache].Person q
				where p.personid <> q.personid and p.latitude = q.latitude and p.longitude = q.longitude 
					and p.latitude is not null and p.longitude is not null
					and q.latitude is not null and q.longitude is not null
				--where p.personid <> q.personid and p.addressline3 <> '' and p.addressline4 <> '' and p.addressline3 = q.addressline3 and p.addressline4 = q.addressline4
			) t
		) t
		WHERE k <= 5
 
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Person.PhysicalNeighbor]
			INSERT INTO [Profile.Cache].[Person.PhysicalNeighbor]
				SELECT * FROM #neighbors
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@error = 1,@insert_new_record=0
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.Cache].[Private.UpdateCache]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	declare @typeID bigint
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')

	declare @labelID bigint
	select @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')

	--------------------------------------------------
	-- NodeMap
	--------------------------------------------------

	select t.Subject NodeID, c._PropertyNode Property, max(SearchWeight) SearchWeight
		into #n
		from [Ontology.].ClassProperty c, [RDF.].Triple t, [RDF.].Node n
		where t.Predicate = @typeID and t.object = c._ClassNode and c.SearchWeight > 0
			and t.Subject = n.NodeID
			and t.ViewSecurityGroup between -30 and -1
			and n.ViewSecurityGroup between -30 and -1
		group by t.Subject, c._PropertyNode
	create unique clustered index idx_np on #n(NodeID,Property)

	create table #s (
		NodeID bigint not null,
		MatchedByNodeID bigint not null,
		Distance int,
		Paths int,
		Weight float
	)
	alter table #s add primary key (NodeID, MatchedByNodeID)

	insert into #s (NodeID, MatchedByNodeID, Distance, Paths, Weight)
		select x.NodeID, t.Object, 1, count(*), 1-exp(sum(log(case when x.SearchWeight*t.Weight > 0.999999 then 0.000001 else 1-x.SearchWeight*t.Weight end)))
			from #n x, [RDF.].Triple t, [RDF.].Node n
			where x.NodeID = t.subject and x.Property = t.predicate and x.SearchWeight*t.Weight > 0
				and t.Object = n.NodeID
				and t.ViewSecurityGroup between -30 and -1
				and n.ViewSecurityGroup between -30 and -1
			group by x.NodeID, t.Object

	declare @i int
	select @i = 1
	while @i < 10
	begin
		insert into #s (NodeID, MatchedByNodeID, Distance, Paths, Weight)
			select s.NodeID, t.MatchedByNodeID, @i+1, count(*), 1-exp(sum(log(case when s.Weight*t.Weight > 0.999999 then 0.000001 else 1-s.Weight*t.Weight end)))
				from #s s, #s t
				where s.MatchedByNodeID = t.NodeID
					and s.Distance = @i
					and t.Distance = 1
					and t.NodeID <> s.NodeID
					and not exists (
						select *
						from #s u
						where u.NodeID = s.NodeID and u.MatchedByNodeID = t.MatchedByNodeID
					)
				group by s.NodeID, t.MatchedByNodeID
		if @@ROWCOUNT = 0
			select @i = 10
		select @i = @i + 1
	end


	--------------------------------------------------
	-- NodeSummary (Part 1)
	--------------------------------------------------

	select t.subject NodeID, min(case when len(n.Value)>500 then left(n.Value,497)+'...' else n.Value end) Label
		into #l
		from [RDF.].Triple t, [RDF.].Node n
		where t.predicate = @labelID and t.object = n.NodeID
			and t.subject in (select NodeID from #s)
			and t.ViewSecurityGroup between -30 and -1
			and n.ViewSecurityGroup between -30 and -1
		group by t.subject


	--------------------------------------------------
	-- NodeClass
	--------------------------------------------------

	select distinct l.NodeID, t.Object
		into #c
		from [RDF.].Node l, [RDF.].Triple t, [RDF.].Node n
		where l.NodeID = t.subject and t.predicate = @typeID and t.object = n.NodeID
			and t.ViewSecurityGroup between -30 and -1
			and n.ViewSecurityGroup between -30 and -1
			and l.ViewSecurityGroup between -30 and -1

	create unique clustered index idx_no on #c(NodeID, Object)

	--------------------------------------------------
	-- NodeSummary (Part 2)
	--------------------------------------------------
	CREATE INDEX idx_c ON #c ([Object]) INCLUDE ([NodeID])							
	CREATE INDEX idx_l ON #l ([NodeID]) INCLUDE ([Label])	

	select NodeID, Label, ClassName, row_number() over (order by Label, NodeID) SortOrder
		into #l2
		from (
			select l.NodeID, l.Label, d._ClassName ClassName,
				row_number() over (partition by l.NodeID order by IsNull(d._TreeDepth,0) desc, d._ClassName) k
			from #l l
				inner join #c c on l.NodeID = c.NodeID
				inner join [Ontology.].ClassGroupClass g on c.Object = g._ClassNode
				left outer join [Ontology.].ClassTreeDepth d on c.Object = d._ClassNode
		) t
		where k = 1

	--------------------------------------------------
	-- NodeRDF
	--------------------------------------------------

	select n.NodeID, c._PropertyNode PropertyNode, max(Limit) Limit, max(cast(c.IncludeDescription as tinyint)) IncludeDescription, max(_TagName) TagName
		into #NodePropertyExpand
		from #c n, [Ontology.].ClassProperty c, [RDF.].Node p
		where n.Object = c._ClassNode
			and c._NetworkPropertyNode is null
			and c.IsDetail = 0
			and c._PropertyNode = p.NodeID
			and p.ViewSecurityGroup between -30 and -1
		group by n.NodeID, c._PropertyNode
	--[10740312 in 00:00:31]

	select e.NodeID, o.NodeID ExpandNodeID, e.IncludeDescription, e.TagName, o.ObjectType, o.Value, o.Language, o.DataType
		into #NodePropertyValue
		from #NodePropertyExpand e, [RDF.].Triple t, [RDF.].Node o
		where t.subject = e.NodeID
			and t.predicate = e.PropertyNode
			and t.object = o.NodeID
			and t.ViewSecurityGroup between -30 and -1
			and o.ViewSecurityGroup between -30 and -1
			and ((e.Limit is null) or (t.SortOrder <= e.Limit))
	--[8646849 in 00:01:31]

	select NodeID, ExpandNodeID,
			'_TAGLT_'+tagName
			+(case when ObjectType = 0 then ' rdf:resource="'+Value+'"/_TAGGT_' 
					else '_TAGGT_'+Value+'_TAGLT_/'+tagName+'_TAGGT_' end)
			TagValue
		into #NodePropertyTagTemp
		from (
			select NodeID, ExpandNodeID, TagName, ObjectType, Language, DataType,
				(case when charindex(char(0),cast(Value as varchar(max))) > 0
						then replace(replace(replace(replace(cast(Value as varchar(max)),char(0),''),'&','&amp;'),'<','&lt;'),'>','&gt;')
						else replace(replace(replace(Value,'&','&amp;'),'<','&lt;'),'>','&gt;')
						end) Value
				from #NodePropertyValue
		) t
	--[9162177 in 00:03:39]

	create nonclustered index idx_n on #NodePropertyTagTemp(NodeID)
	--[00:00:07]

	select NodeID, ExpandNodeID, TagValue, row_number() over (partition by NodeID order by TagValue) k
		into #NodePropertyTag
		from #NodePropertyTagTemp
	--[9162177 in 00:00:34]
	
	create nonclustered index idx_nk on #NodePropertyTag(NodeID,k)
	--[00:00:07]
	create nonclustered index idx_kn on #NodePropertyTag(k,NodeID)
	--[00:00:10]
	create clustered index idx_nk3 on #NodePropertyTag(NodeID,k)
	
	select NodeID, TagValue Tags
		into #NodeTags
		from #NodePropertyTag
		where k = 1
		
	create clustered index idx_kn2 on #NodeTags(NodeID)	
			
	declare @k int
	select @k = 2
	while (@k > 0) and (@k < 25)
	begin
		update t
			set t.Tags = t.Tags + p.TagValue
			from #NodeTags t
				inner join #NodePropertyTag p
					on t.NodeID = p.NodeID and p.k = @k
		if @@ROWCOUNT = 0
			select @k = -1
		else
			select @k = @k + 1			
	end
	--[4162659 in 00:05:01]

	--create unique clustered index idx_n on #NodeTags(NodeID)
	--[00:00:16]
		
	/*	
	select NodeID,
			cast((
				select b.TagValue+''	
					from #NodePropertyTag b
					where b.NodeID = a.NodeID
					order by b.TagValue
					for xml path(''), type
			) as nvarchar(max))
			Tags
		into #NodeTags
		from #NodePropertyTag a
		group by NodeID
	--[3764783 in 00:13:18]
	*/
	
	select t.NodeID, 
			'_TAGLT_rdf:Description rdf:about="' + replace(replace(replace(n.Value,'&','&amp;'),'<','&lt;'),'>','&gt;') + '"_TAGGT_'
			+ t.Tags
			+ '_TAGLT_/rdf:Description_TAGGT_'
			RDF
		into #NodeRDF
		from #NodeTags t, [RDF.].Node n
		where t.NodeID = n.NodeID
	--[4162659 in 00:01:40]


	--------------------------------------------------
	-- NodeExpand
	--------------------------------------------------

	select distinct NodeID, ExpandNodeID
		into #NodeExpand
		from #NodePropertyValue
		where IncludeDescription = 1
	--[5370803 in 00:00:06]


	--------------------------------------------------
	-- NodePrefix
	--------------------------------------------------

	create table #NodePrefix (
		Prefix varchar(800) not null,
		NodeID bigint not null
	)
	insert into #NodePrefix (Prefix,NodeID)
		select left(Value,800), NodeID
			from [RDF.].Node
			where ViewSecurityGroup between -30 and -1
	--[5710775 in 00:00:09]
	alter table #NodePrefix add primary key (Prefix, NodeID)
	--[00:00:13]


	--------------------------------------------------
	-- Update actual tables
	--------------------------------------------------

	BEGIN TRY
		BEGIN TRAN
		
			truncate table [Search.Cache].[Private.NodeMap]
			insert into [Search.Cache].[Private.NodeMap]
				select * from #s
			truncate table [Search.Cache].[Private.NodeSummary]
			insert into [Search.Cache].[Private.NodeSummary]
				select * from #l2
			truncate table [Search.Cache].[Private.NodeClass]
			insert into [Search.Cache].[Private.NodeClass]
				select * from #c
					

			truncate table [Search.Cache].[Private.NodeExpand]
			insert into [Search.Cache].[Private.NodeExpand] (NodeID, ExpandNodeID)
				select NodeID, ExpandNodeID
					from #NodeExpand
			--[5370803 in 00:00:17]

			truncate table [Search.Cache].[Private.NodeRDF]
			insert into [Search.Cache].[Private.NodeRDF] (NodeID, RDF)
				select NodeID, RDF
					from #NodeRDF
			--[3764783 in 00:00:30]

			truncate table [Search.Cache].[Private.NodePrefix]
			insert into [Search.Cache].[Private.NodePrefix] (Prefix, NodeID)
				select Prefix, NodeID
					from #NodePrefix
			--[8001238 in 00:00:57]

		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		--Raise an error with the details of the exception
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Proxy.GetProxies] 
	@SessionID UNIQUEIDENTIFIER,
	@Operation VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;


	/**************************************************************
	This stored procedure supports three operations:
	
	1) GetDefaultUsersWhoseNodesICanEdit
	2) GetDesignatedUsersWhoseNodesICanEdit
	3) GetAllUsersWhoCanEditMyNodes
	
	Operation #1 returns a list of organizations.
	Operations #2 and #3 return a list of user accounts, some of
	  which also have person profiles (PersonURI).
	Operation #3 also indicates which proxies can be deleted.
	**************************************************************/
	
	
	-- Get the UserID of the SessionID. Exit if not found.
	DECLARE @SessionUserID INT
	SELECT @SessionUserID = UserID
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID
	IF @SessionUserID IS NULL
		RETURN


	IF @Operation = 'GetDefaultUsersWhoseNodesICanEdit'
		SELECT Institution, Department, Division, MAX(IsVisible*1) IsVisible
			FROM (
				-- Default Proxies
				SELECT	(case when IsNull(ProxyForInstitution,'')='' then 'All' else ProxyForInstitution end) Institution,
						(case when IsNull(ProxyForDepartment,'')='' then 'All' else ProxyForDepartment end) Department,
						(case when IsNull(ProxyForDivision,'')='' then 'All' else ProxyForDivision end) Division,
						IsVisible
					FROM [User.Account].[DefaultProxy]
					WHERE UserID = @SessionUserID
				-- Security Groups with Special Edit Access
				UNION ALL
				SELECT 'All' Institution, 'All' Department, 'All' Division, m.IsVisible
					FROM [RDF.Security].[Member] m
						INNER JOIN [RDF.Security].[Group] g
							ON m.SecurityGroupID = g.SecurityGroupID
							AND g.HasSpecialEditAccess = 1
			) t
			GROUP BY Institution, Department, Division
			ORDER BY	(case when Institution = 'All' then 0 else 1 end), Institution,
						(case when Department = 'All' then 0 else 1 end), Department,
						(case when Division = 'All' then 0 else 1 end), Division


	IF @Operation = 'GetDesignatedUsersWhoseNodesICanEdit'
		SELECT u.UserID, u.DisplayName, u.Institution, u.Department, u.EmailAddr,
				o.Value+cast(p.NodeID as varchar(50)) PersonURI
			FROM [User.Account].[User] u
				INNER JOIN (
					-- Designated Proxies
					SELECT ProxyForUserID
						FROM [User.Account].[DesignatedProxy]
						WHERE UserID = @SessionUserID
				) x ON u.UserID = x.ProxyForUserID
				INNER JOIN [Framework.].Parameter o
					ON o.ParameterID = 'baseURI'
				LEFT OUTER JOIN [RDF.Stage].[InternalNodeMap] p
					ON u.PersonID IS NOT NULL
						AND cast(u.PersonID as varchar(50)) = p.InternalID
						AND p.Class = 'http://xmlns.com/foaf/0.1/Person'
						AND p.InternalType = 'Person'
						AND p.NodeID IS NOT NULL
			ORDER BY u.LastName, u.FirstName


	IF @Operation = 'GetAllUsersWhoCanEditMyNodes'
		SELECT u.UserID, u.DisplayName, u.Institution, u.Department, u.EmailAddr, 
				o.Value+cast(p.NodeID as varchar(50)) PersonURI, x.CanDelete
			FROM [User.Account].[User] u
				INNER JOIN (
					SELECT UserID, MIN(CanDelete) CanDelete
						FROM (
							-- Designated Proxies
							SELECT UserID, 1 CanDelete
								FROM [User.Account].[DesignatedProxy]
								WHERE ProxyForUserID = @SessionUserID
							-- Default Proxies
							UNION ALL
							SELECT x.UserID, 0 CanDelete
								FROM [User.Account].[DefaultProxy] x
									INNER JOIN [User.Account].[User] u
										ON ((IsNull(x.ProxyForInstitution,'') = '') 
												OR (IsNull(x.ProxyForInstitution,'') = IsNull(u.Institution,'')))
										AND ((IsNull(x.ProxyForDepartment,'') = '') 
												OR (IsNull(x.ProxyForDepartment,'') = IsNull(u.Department,'')))
										AND ((IsNull(x.ProxyForDivision,'') = '') 
												OR (IsNull(x.ProxyForDivision,'') = IsNull(u.Division,'')))
										AND u.UserID = @SessionUserID
										AND x.IsVisible = 1
							-- Security Groups with Special Edit Access
							UNION ALL
							SELECT m.UserID, 0 CanDelete
								FROM [RDF.Security].[Member] m
									INNER JOIN [RDF.Security].[Group] g
										ON m.SecurityGroupID = g.SecurityGroupID
										AND m.IsVisible = 1
										AND g.HasSpecialEditAccess = 1
						) t
						GROUP BY UserID
				) x ON u.UserID = x.UserID
				INNER JOIN [Framework.].Parameter o
					ON o.ParameterID = 'baseURI'
				LEFT OUTER JOIN [RDF.Stage].[InternalNodeMap] p
					ON u.PersonID IS NOT NULL
						AND cast(u.PersonID as varchar(50)) = p.InternalID
						AND p.Class = 'http://xmlns.com/foaf/0.1/Person'
						AND p.InternalType = 'Person'
						AND p.NodeID IS NOT NULL
			ORDER BY u.LastName, u.FirstName

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Proxy.DeleteDesignatedProxy]
	@SessionID UNIQUEIDENTIFIER,
	@UserID VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;


	-- Get the UserID of the SessionID. Exit if not found.
	DECLARE @SessionUserID INT
	SELECT @SessionUserID = UserID
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID
	IF @SessionUserID IS NULL
		RETURN
	
	-- Add the designated proxy
	DELETE
		FROM [User.Account].[DesignatedProxy]
		WHERE UserID = @UserID AND ProxyForUserID = @SessionUserID

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Proxy.AddDesignatedProxy]
	@SessionID UNIQUEIDENTIFIER,
	@UserID VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;


	-- Get the UserID of the SessionID. Exit if not found.
	DECLARE @SessionUserID INT
	SELECT @SessionUserID = UserID
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID
	IF @SessionUserID IS NULL
		RETURN
	
	-- Add the designated proxy
	INSERT INTO [User.Account].[DesignatedProxy] (UserID, ProxyForUserID)
		SELECT @UserID, @SessionUserID
			WHERE NOT EXISTS (
				SELECT *
					FROM [User.Account].[DesignatedProxy]
					WHERE UserID = @UserID AND ProxyForUserID = @SessionUserID
			)

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Person.UpdateAffiliation]
as
begin
 
DECLARE @date DATETIME,@auditid UNIQUEIDENTIFIER, @rows int
SELECT @date=GETDATE() 
EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName ='Person.UpdateAffiliation',@ProcessStartDate =@date,@insert_new_record=1
 
 
truncate table [Profile.Cache].[Person.Affiliation]
insert into [Profile.Cache].[Person.Affiliation]
SELECT personid, sortorder,isprimary,title,institutionname,institutionabbreviation,departmentname,divisionname,facultyrank
												FROM [Profile.Data].[Person.Affiliation] pa  
												JOIN [Profile.Data].[Organization.Department] d on  d.departmentid=pa.departmentid 
			    						  JOIN [Profile.Data].[Organization.Institution] ins ON ins.institutionid=pa.institutionid 
									 LEFT JOIN [Profile.Data].[Organization.Division] di on di.divisionid=pa.divisionid
									 LEFT JOIN [Profile.Data].[Person.FacultyRank] fr on fr.facultyrankid = pa.facultyrankid
 
 
SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName ='Person.UpdateAffiliation',@ProcessEndDate =@date,@ProcessedRows = @rows,@insert_new_record=0
 
 
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.Stage].[LoadAliases]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	TRUNCATE TABLE [RDF.].Alias

	INSERT INTO [RDF.].Alias (AliasType, AliasID, NodeID, Preferred)
		SELECT 'Network', 'CoAuthors', [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf'), 1
	INSERT INTO [RDF.].Alias (AliasType, AliasID, NodeID, Preferred)
		SELECT 'Network', 'SimilarTo', [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#similarTo'), 1
	INSERT INTO [RDF.].Alias (AliasType, AliasID, NodeID, Preferred)
		SELECT 'Network', 'ResearchAreas', [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#hasResearchArea'), 1

	/*
	
	-- Example: PersonID as the preferred alias for a person
	INSERT INTO [RDF.].Alias (AliasType, AliasID, NodeID, Preferred)
		SELECT InternalType, InternalID, NodeID, 1
			FROM [RDF.Stage].InternalNodeMap
			WHERE InternalType='Person' and Class = 'http://xmlns.com/foaf/0.1/Person'

	-- Example: InternalUsername as an alternative alias for a person
	INSERT INTO [RDF.].Alias (AliasType, AliasID, NodeID, Preferred)
		SELECT 'Username', p.InternalUsername, m.NodeID, 0
			FROM [RDF.Stage].InternalNodeMap m, [Profile.Data].[Person] p
			WHERE m.InternalType='Person' and m.Class = 'http://xmlns.com/foaf/0.1/Person'
				and m.InternalID = CAST(p.PersonID as varchar(50))

	*/
	
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[SNA.Coauthor.UpdateReach]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	select PersonID1 PersonID, Distance, count(*) NumPeople
		into #sna_reach_tmp
		from [Profile.Cache].[SNA.Coauthor.Distance]
		group by PersonID1, Distance
	create unique clustered index idx_pd on #sna_reach_tmp(PersonID, Distance)
 
	select 99 n into #n
	insert into #n(n)
		select n
		from [Utility.Math].N
		where n > 0 and n <= (select max(Distance) from #sna_reach_tmp where Distance < 99)
	create unique clustered index idx_n on #n(n)
 
	select p.PersonID, n.n Distance, 0 NumPeople
		into #sna_reach
		from #n n, (select distinct PersonID from #sna_reach_tmp) p
	create unique clustered index idx_pd on #sna_reach(PersonID, Distance)
 
	update s
		set s.NumPeople = t.NumPeople
		from #sna_reach s, #sna_reach_tmp t
		where s.PersonID = t.PersonID and s.Distance = t.Distance
 
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[SNA.Coauthor.Reach]
				INSERT INTO [Profile.Cache].[SNA.Coauthor.Reach] (PersonID,Distance,NumPeople)
					SELECT PersonID,Distance,NumPeople FROM #sna_reach
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[SNA.Coauthor.UpdateDistance]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	insert into [Profile.Cache].[SNA.Coauthor.DistanceLog] (x,d) values ('Start',getdate())
 
	create table #sna_distance(PersonID1 int, PersonID2 int, Distance tinyint, NumPaths smallint) 
 
	--create a copy of sna_coauthors so we don't lock up that table
	select PersonID1, PersonID2
		into #sna_coauthors
		from [Profile.Cache].[SNA.Coauthor]
	alter table #sna_coauthors add primary key (PersonID1, PersonID2)
 
	select i, row_number() over (order by i) k
		into #p
		from (select distinct PersonID1 i from #sna_coauthors) t
	create unique clustered index idx_k on #p(k)
	create unique nonclustered index idx_i on #p(i)
 
	DECLARE @d INT
 
	declare @maxp int
	declare @p int
	select @maxp = max(k) from #p
	set @p = 1
	while @p <= @maxp
	begin
 
		insert into [Profile.Cache].[SNA.Coauthor.DistanceLog] (x,d) values ('Started p = '+cast(@p as varchar(50)),getdate())
 
		--create empty table
		;with a as (
			select distinct personid1 i from #sna_coauthors
		)
		select a.i, b.i j, cast(99 as tinyint) d, cast(0 as smallint) s
			into #z
			from (select i from #p where k between @p and @p+999) a, #p b
			where a.i <> b.i
		set @p = @p + 1000
 
		CREATE UNIQUE CLUSTERED INDEX idx_ij ON #z(i,j)
		
		--seed table (i.e. coauthors) with default distances, num_paths
		UPDATE z 
			SET d = 1, s = 1
			FROM #z z INNER JOIN #sna_coauthors y ON z.i = y.PersonID1 and z.j = y.PersonID2
 
		
		--iterate over network by distance level, derive distances and number of paths
		SELECT @d = 1
		WHILE @d < 15 --Max depth that we will search
		BEGIN
			
			SELECT z.i, y.PersonID2 j, sum(z.s) t
				INTO #x
				FROM #z z  	   
        JOIN #sna_coauthors y ON z.d = @d AND z.j = y.PersonID1
	      JOIN #z w ON w.i = z.i AND w.j = y.PersonID2 AND w.d = 99
				GROUP BY z.i, y.PersonID2
				--OPTION(RECOMPILE)
			CREATE UNIQUE CLUSTERED INDEX idx_ij on #x(i,j)
			SELECT @d = @d + 1
			UPDATE z 
				SET d = @d, s = t
				FROM #z z  
			  JOIN #x t ON z.i = t.i AND z.j = t.j
			DROP TABLE #x
		END
 
	 
		INSERT INTO #sna_distance(PersonID1,PersonID2,Distance,NumPaths)
			SELECT i,j,d,s FROM #z
 
		drop table #z
 
	end
 
	insert into [Profile.Cache].[SNA.Coauthor.DistanceLog]  (x,d) values ('Finished loops',getdate())
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[SNA.Coauthor.Distance]
				INSERT INTO [Profile.Cache].[SNA.Coauthor.Distance] (PersonID1,PersonID2,Distance,NumPaths)
					SELECT PersonID1,PersonID2,Distance,NumPaths FROM #sna_distance
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
	insert INTO [Profile.Cache].[SNA.Coauthor.DistanceLog] (x,d) values ('Completed Insert',getdate())
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[SNA.Coauthor.UpdateCoauthor]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	select a.personid PersonID1, b.personid PersonID2, sum(a.AuthorWeight*b.AuthorWeight*a.YearWeight) w, min(a.PubDate) FirstPubDate, max(b.PubDate) LastPubDate, count(*) n
		into #sna_coauthors
		from [Profile.Cache].[Publication.PubMed.AuthorPosition] a, [Profile.Cache].[Publication.PubMed.AuthorPosition] b
		where a.pmid = b.pmid and a.personid <> b.personid
		group by a.personid, b.personid
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[SNA.Coauthor]
			INSERT INTO [Profile.Cache].[SNA.Coauthor](personid1,personid2,w,FirstPubDate,LastPubDate,N)
				SELECT personid1,personid2,w,FirstPubDate,LastPubDate,N FROM #sna_coauthors
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[SetNodePropertySecurity]
	@NodeID bigint,
	@PropertyID bigint = NULL,
	@PropertyURI varchar(400) = NULL,
	@ViewSecurityGroup bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	SELECT @NodeID = NULL WHERE @NodeID = 0
	SELECT @PropertyID = NULL WHERE @PropertyID = 0

	IF (@PropertyID IS NULL) AND (@PropertyURI IS NOT NULL)
		SELECT @PropertyID = [RDF.].fnURI2NodeID(@PropertyURI)

	-- If node+property, then save setting so that it does
	-- not get overwritten through data loads
	IF (@NodeID IS NOT NULL) AND (@PropertyID IS NOT NULL) AND (@ViewSecurityGroup IS NOT NULL)
	BEGIN
		UPDATE [RDF.Security].NodeProperty
			SET ViewSecurityGroup = @ViewSecurityGroup
			WHERE NodeID = @NodeID AND Property = @PropertyID
		INSERT INTO [RDF.Security].NodeProperty (NodeID, Property, ViewSecurityGroup)
			SELECT @NodeID, @PropertyID, @ViewSecurityGroup
			WHERE NOT EXISTS (
				SELECT *
				FROM [RDF.Security].NodeProperty
				WHERE NodeID = @NodeID AND Property = @PropertyID
			)
		UPDATE [RDF.].Triple
			SET ViewSecurityGroup = @ViewSecurityGroup
			WHERE Subject = @NodeID AND Predicate = @PropertyID
	END
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Session].[UpdateSession]
	@SessionID UNIQUEIDENTIFIER, 
	@UserID INT=NULL, 
	@LastUsedDate DATETIME=NULL, 
	@LogoutDate DATETIME=NULL,
	@SessionPersonNodeID BIGINT = NULL OUTPUT,
	@SessionPersonURI VARCHAR(400) = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- See if there is a PersonID associated with this session	
	DECLARE @PersonID INT
	SELECT @PersonID = PersonID
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID
	IF @PersonID IS NULL AND @UserID IS NOT NULL
		SELECT @PersonID = PersonID
			FROM [User.Account].[User]
			WHERE UserID = @UserID

	-- Get the NodeID and URI of the PersonID
	IF @PersonID IS NOT NULL
	BEGIN
		SELECT @SessionPersonNodeID = m.NodeID, @SessionPersonURI = p.Value + CAST(m.NodeID AS VARCHAR(50))
			FROM [RDF.Stage].InternalNodeMap m, [Framework.].[Parameter] p
			WHERE m.InternalID = @PersonID
				AND m.InternalType = 'person'
				AND m.Class = 'http://xmlns.com/foaf/0.1/Person'
				AND p.ParameterID = 'baseURI'
	END

	-- Update the session data
    IF EXISTS (SELECT * FROM [User.Session].[Session] WHERE SessionID = @SessionID)
		UPDATE [User.Session].[Session]
			SET	UserID = IsNull(@UserID,UserID),
				UserNode = IsNull((SELECT NodeID FROM [User.Account].[User] WHERE UserID = @UserID AND @UserID IS NOT NULL),UserNode),
				PersonID = IsNull(@PersonID,PersonID),
				LastUsedDate = IsNull(@LastUsedDate,LastUsedDate),
				LogoutDate = IsNull(@LogoutDate,LogoutDate)
			WHERE SessionID = @SessionID

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.].[UpdateDerivedFields]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Triple
	UPDATE o
		SET	_SubjectNode = [RDF.].fnURI2NodeID(subject),
			_PredicateNode = [RDF.].fnURI2NodeID(predicate),
			_ObjectNode = [RDF.].fnURI2NodeID(object),
			_TripleID = NULL
		FROM [Ontology.Import].[Triple] o
	UPDATE o
		SET o._TripleID = r.TripleID
		FROM [Ontology.Import].[Triple] o, [RDF.].Triple r
		WHERE o._SubjectNode = r.Subject AND o._PredicateNode = r.Predicate AND o._ObjectNode = r.Object

	-- DataMap
	UPDATE o
		SET	_ClassNode = [RDF.].fnURI2NodeID(Class),
			_NetworkPropertyNode = [RDF.].fnURI2NodeID(NetworkProperty),
			_PropertyNode = [RDF.].fnURI2NodeID(property)
		FROM [Ontology.].DataMap o

	-- ClassProperty
	UPDATE o
		SET	_ClassNode = [RDF.].fnURI2NodeID(Class),
			_NetworkPropertyNode = [RDF.].fnURI2NodeID(NetworkProperty),
			_PropertyNode = [RDF.].fnURI2NodeID(property),
			_TagName = (select top 1 n.Prefix+':'+substring(o.property,len(n.URI)+1,len(o.property)) t
						from [Ontology.].Namespace n
						where o.property like n.uri+'%'
						)
		FROM [Ontology.].ClassProperty o
	UPDATE e
		SET e._PropertyLabel = o.value
		FROM [ontology.].ClassProperty e
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON e._PropertyNode = t.subject AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label') 
			LEFT OUTER JOIN [RDF.].[Node] o
				ON t.object = o.nodeid
	UPDATE e
		SET e._ObjectType = (CASE WHEN o.value = 'http://www.w3.org/2002/07/owl#ObjectProperty' THEN 0 ELSE 1 END)
		FROM [ontology.].ClassProperty e
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON e._PropertyNode = t.subject AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type') 
			LEFT OUTER JOIN [RDF.].[Node] o
				ON t.object = o.nodeid and o.value in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')

	-- ClassGroup
	UPDATE o
		SET	_ClassGroupNode = [RDF.].fnURI2NodeID(ClassGroupURI)
		FROM [Ontology.].ClassGroup o
	UPDATE e
		SET e._ClassGroupLabel = o.value
		FROM [ontology.].ClassGroup e
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON e._ClassGroupNode = t.subject AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label') 
			LEFT OUTER JOIN [RDF.].[Node] o
				ON t.object = o.nodeid

	-- ClassGroupClass
	UPDATE o
		SET	_ClassGroupNode = [RDF.].fnURI2NodeID(ClassGroupURI),
			_ClassNode = [RDF.].fnURI2NodeID(ClassURI)
		FROM [Ontology.].ClassGroupClass o
	UPDATE e
		SET e._ClassLabel = o.value
		FROM [ontology.].ClassGroupClass e
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON e._ClassNode = t.subject AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label') 
			LEFT OUTER JOIN [RDF.].[Node] o
				ON t.object = o.nodeid
				
	-- ClassTreeDepth
	declare @ClassDepths table (
		NodeID bigint,
		SubClassOf bigint,
		Depth int,
		ClassURI varchar(400),
		ClassName varchar(400)
	)
	;with x as (
		select t.subject NodeID, 
			max(case when w.subject is null then null else v.object end) SubClassOf
		from [RDF.].Triple t
			left outer join [RDF.].Triple v
				on v.subject = t.subject 
				and v.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#subClassOf')
			left outer join [RDF.].Triple w
				on w.subject = v.object
				and w.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type') 
				and w.object = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#Class')
		where t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type') 
			and t.object = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#Class') 
		group by t.subject
	)
	insert into @ClassDepths (NodeID, SubClassOf, Depth, ClassURI)
		select x.NodeID, x.SubClassOf, (case when x.SubClassOf is null then 0 else null end) Depth, n.Value
		from x, [RDF.].Node n
		where x.NodeID = n.NodeID
	;with a as (
		select NodeID, SubClassOf, Depth
			from @ClassDepths
		union all
		select b.NodeID, IsNull(a.NodeID,b.SubClassOf), a.Depth+1
			from a, @ClassDepths b
			where b.SubClassOf = a.NodeID
				and a.Depth is not null
				and b.Depth is null
	), b as (
		select NodeID, SubClassOf, Max(Depth) Depth
		from a
		group by NodeID, SubClassOf
	)
	update c
		set c.Depth = b.Depth
		from @ClassDepths c, b
		where c.NodeID = b.NodeID
	;with a as (
		select c.NodeID, max(n.Value) ClassName
			from @ClassDepths c
				inner join [RDF.].Triple t
					on t.subject = c.NodeID
						and t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')
				inner join [RDF.].Node n
					on t.object = n.NodeID
			group by c.NodeID
	)
	update c
		set c.ClassName = a.ClassName
		from @ClassDepths c, a
		where c.NodeID = a.NodeID
	truncate table [Ontology.].ClassTreeDepth
	insert into [Ontology.].ClassTreeDepth (Class, _TreeDepth, _ClassNode, _ClassName)
		select ClassURI, Depth, NodeID, ClassName
			from @ClassDepths

	-- PropertyGroup
	UPDATE o
		SET	_PropertyGroupNode = [RDF.].fnURI2NodeID(PropertyGroupURI)
		FROM [Ontology.].PropertyGroup o
	UPDATE e
		SET e._PropertyGroupLabel = o.value
		FROM [ontology.].PropertyGroup e
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON e._PropertyGroupNode = t.subject AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label') 
			LEFT OUTER JOIN [RDF.].[Node] o
				ON t.object = o.nodeid

	-- PropertyGroupProperty
	UPDATE o
		SET	_PropertyGroupNode = [RDF.].fnURI2NodeID(PropertyGroupURI),
			_PropertyNode = [RDF.].fnURI2NodeID(PropertyURI),
			_TagName = (select top 1 n.Prefix+':'+substring(o.PropertyURI,len(n.URI)+1,len(o.PropertyURI)) t
						from [Ontology.].Namespace n
						where o.PropertyURI like n.uri+'%'
						)
		FROM [Ontology.].PropertyGroupProperty o
	UPDATE e
		SET e._PropertyLabel = o.value
		FROM [ontology.].PropertyGroupProperty e
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON e._PropertyNode = t.subject AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label') 
			LEFT OUTER JOIN [RDF.].[Node] o
				ON t.object = o.nodeid


	-- Presentation
	UPDATE o
		SET	_SubjectNode = [RDF.].fnURI2NodeID(subject),
			_PredicateNode = [RDF.].fnURI2NodeID(predicate),
			_ObjectNode = [RDF.].fnURI2NodeID(object)
		FROM [Ontology.Presentation].[XML] o


	-- select * from [Ontology.Import].[Triple]
	-- select * from [Ontology.].ClassProperty
	-- select * from [Ontology.].ClassGroup
	-- select * from [Ontology.].ClassGroupClass
	-- select * from [Ontology.].ClassTreeDepth
	-- select * from [Ontology.].PropertyGroup
	-- select * from [Ontology.].PropertyGroupProperty
	-- select * from [Ontology.Presentation].[XML]

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.].[UpdateCounts]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @typeID BIGINT
	SELECT @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')

	-- Get ClassGroup counts
	SELECT g.ClassGroupURI, COUNT(DISTINCT t.Subject) NumberOfNodes
		INTO #ClassGroup
		FROM [Ontology.].[ClassGroup] g, [Ontology.].[ClassGroupClass] c, [RDF.].[Triple] t,
			[RDF.].[Node] s, [RDF.].[Node] p, [RDF.].[Node] o
		WHERE g.ClassGroupURI = c.ClassGroupURI and c._ClassNode = t.Object and t.Predicate = @typeID
			and t.ViewSecurityGroup = -1
			and t.subject = s.nodeid and s.ViewSecurityGroup = -1
			and t.predicate = p.nodeid and p.ViewSecurityGroup = -1
			and t.object = o.nodeid and o.ViewSecurityGroup = -1
		GROUP BY g.ClassGroupURI

	-- Get ClassGroupClass counts
	SELECT c.ClassGroupURI, c.ClassURI, COUNT(DISTINCT t.Subject) NumberOfNodes
		INTO #ClassGroupClass
		FROM [Ontology.].[ClassGroupClass] c, [RDF.].[Triple] t,
			[RDF.].[Node] s, [RDF.].[Node] p, [RDF.].[Node] o
		WHERE c._ClassNode = t.Object and t.Predicate = @typeID
			and t.ViewSecurityGroup = -1
			and t.subject = s.nodeid and s.ViewSecurityGroup = -1
			and t.predicate = p.nodeid and p.ViewSecurityGroup = -1
			and t.object = o.nodeid and o.ViewSecurityGroup = -1
		GROUP BY c.ClassGroupURI, c.ClassURI

	-- Get ClassProperty counts
	SELECT c.ClassPropertyID, COUNT(DISTINCT t.Subject) NumberOfNodes, COUNT(DISTINCT t2.TripleID) NumberOfTriples
		INTO #ClassProperty
		FROM [Ontology.].[ClassProperty] c, [RDF.].[Triple] t,
			[RDF.].[Node] s, [RDF.].[Node] p, [RDF.].[Node] o,
			[RDF.].[Triple] t2,
			[RDF.].[Node] p2, [RDF.].[Node] o2
		WHERE c._ClassNode = t.Object 
			and c._NetworkPropertyNode is null
			and t.Predicate = @typeID 
			and t.ViewSecurityGroup = -1
			and t.subject = s.nodeid and s.ViewSecurityGroup = -1
			and t.predicate = p.nodeid and p.ViewSecurityGroup = -1
			and t.object = o.nodeid and o.ViewSecurityGroup = -1
			and t2.subject = t.subject
			and t2.predicate = c._PropertyNode
			and t2.ViewSecurityGroup = -1
			and t2.predicate = p2.nodeid and p2.ViewSecurityGroup = -1
			and t2.object = o2.nodeid and o2.ViewSecurityGroup = -1
		GROUP BY c.ClassPropertyID
BEGIN TRY 
	begin transaction
		
		-- Update ClassGroup
		UPDATE o
			SET	o._NumberOfNodes = IsNull(g.NumberOfNodes,0)
			FROM [Ontology.].[ClassGroup] o
				left outer join #ClassGroup g on o.ClassGroupURI = g.ClassGroupURI

		-- Update ClassGroupClass
		UPDATE o
			SET	o._NumberOfNodes = IsNull(c.NumberOfNodes,0)
			FROM [Ontology.].[ClassGroupClass] o
				left outer join #ClassGroupClass c on o.ClassGroupURI = c.ClassGroupURI and o.ClassURI = c.ClassURI

		-- Update ClassProperty
		UPDATE o
			SET	o._NumberOfNodes = IsNull(c.NumberOfNodes,0), o._NumberOfTriples = IsNull(c.NumberOfTriples,0)
			FROM [Ontology.].[ClassProperty] o
				left outer join #ClassProperty c on o.ClassPropertyID = c.ClassPropertyID

	commit transaction
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View
CREATE VIEW [RDF.SemWeb].[vwPublic_Literals] AS
	SELECT 0 id, 'ver:1'+char(10)+'guid:c8bcf60e1d354ebf9d8cecd5c02a2182'+char(10) value, null language, null datatype, null hash
	UNION ALL
	SELECT n.NodeID id, n.value, n.language, n.datatype, b.SemWebHash hash
		FROM [RDF.].Node n, [RDF.SemWeb].[vwHash2Base64] b --WITH (NOEXPAND)
		WHERE n.NodeID = b.NodeID AND n.ObjectType = 1 AND n.ViewSecurityGroup = -1
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [RDF.].[vwPropertyTall] as
	with a as (
		select s.Value Property, s.NodeID, s.NodeID PropertyNode
		from [RDF.].Triple t, [RDF.].Node s
		where t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
			and (t.object = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#DatatypeProperty')
					or t.object = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#ObjectProperty')
				)
			and t.subject = s.NodeID
	), b as (
		select t.subject, v.object
		from [RDF.].Triple t, [RDF.].Triple v
		where t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
			and t.object = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#Restriction')
			and t.subject = v.subject
			and v.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#onProperty')
	), c as (
		select *
			from a
		union
		select a.property, b.subject, b.object
			from a, b
			where a.NodeID = b.object
	), d as (
		select 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' Predicate
		union all select 'http://www.w3.org/2002/07/owl#minCardinality'
		union all select 'http://www.w3.org/2002/07/owl#maxCardinality'
		union all select 'http://www.w3.org/2000/01/rdf-schema#label'
		union all select 'http://www.w3.org/2000/01/rdf-schema#range'
		union all select 'http://www.w3.org/2002/07/owl#allValuesFrom'
		union all select 'http://www.w3.org/2002/07/owl#someValuesFrom'
		union all select 'http://www.w3.org/2000/01/rdf-schema#domain'
	), e as (
		select Predicate, [RDF.].fnURI2NodeID(Predicate) ActualPredicateNode
		from d
	), f as (
		select (case when Predicate in ('http://www.w3.org/2002/07/owl#allValuesFrom','http://www.w3.org/2002/07/owl#someValuesFrom')
					then 'http://www.w3.org/2000/01/rdf-schema#range' else Predicate end) Predicate,
				ActualPredicateNode,
				(case when Predicate in ('http://www.w3.org/2002/07/owl#allValuesFrom','http://www.w3.org/2002/07/owl#someValuesFrom')
					then [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#range') else ActualPredicateNode end) PredicateNode
		from e
	)
	select distinct c.Property, f.Predicate, n.Value, c.PropertyNode, f.PredicateNode, n.NodeID ValueNode
		from c, f, [RDF.].Triple t, [RDF.].Node n
		where t.subject = c.NodeID and t.predicate = f.ActualPredicateNode and t.object = n.NodeID
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [Ontology.].[vwPropertyTall] as
	with a as (
		select distinct Subject Property, cast(Subject as varbinary(max)) xProperty
			from [Ontology.Import].[Triple] b
			where Graph is not null
				and Predicate = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
				and Object in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
	), b as (
		select t.Subject Property, t.Predicate, t.Object Value, 
			t._SubjectNode PropertyNode, t._PredicateNode PredicateNode, t._ObjectNode ValueNode,
			a.xProperty
		from a, [Ontology.Import].[Triple] t
		where t.Graph is not null
			and a.xProperty = cast(t.Subject as varbinary(max))
	), c as (
		select m.Object Property, p.Predicate, p.Object Value,
				m._ObjectNode PropertyNode, p._PredicateNode PredicateNode, p._ObjectNode ValueNode,
				cast(m.Object as varbinary(max)) xProperty
			from [Ontology.Import].[Triple] t, [Ontology.Import].[Triple] m, [Ontology.Import].[Triple] p, a
			where t.Graph is not null
				and t.Predicate = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
				and t.Object = 'http://www.w3.org/2002/07/owl#Restriction'
				and m.Graph is not null
				and m.OWL = t.OWL
				and cast(m.Subject as varbinary(max)) = cast(t.Subject as varbinary(max))
				and m.Predicate = 'http://www.w3.org/2002/07/owl#onProperty'
				and p.Graph is not null
				and p.OWL = t.OWL
				and cast(p.Subject as varbinary(max)) = cast(t.Subject as varbinary(max))
				and not (p.Predicate = t.Predicate and p.Object = t.Object)
				and not (p.Predicate = m.Predicate and p.Object = m.Object)
				and cast(m.Object as varbinary(max)) = a.xProperty
	), d as (
		select * from b
		union all
		select * from c
	), e as (
		select distinct Property, 
			(case when Predicate in ('http://www.w3.org/2002/07/owl#someValuesFrom','http://www.w3.org/2002/07/owl#allValuesFrom') 
				then 'http://www.w3.org/2000/01/rdf-schema#range' 
				else Predicate end) Predicate,
			Value,
			PropertyNode,
			(case when Predicate in ('http://www.w3.org/2002/07/owl#someValuesFrom','http://www.w3.org/2002/07/owl#allValuesFrom') 
				then [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#range')
				else PredicateNode end) PredicateNode,
			ValueNode,
			xProperty
		from d
	)
	select Property, Predicate, Value, PropertyNode, PredicateNode, ValueNode
		from e
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.SemWeb].[vwPrivate_Literals] AS
	SELECT 0 id, 'ver:1'+char(10)+'guid:c8bcf60e1d354ebf9d8cecd5c02a2182'+char(10) value, null language, null datatype, null hash
	UNION ALL
	SELECT n.NodeID id, n.value, n.language, n.datatype, b.SemWebHash hash
		FROM [RDF.].Node n, [RDF.SemWeb].[vwHash2Base64] b --WITH (NOEXPAND)
		WHERE n.NodeID = b.NodeID AND n.ObjectType = 1
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Profile.Data].[vwPerson.Photo]
AS
SELECT p.*, m.NodeID, o.Value+'Modules/CustomViewPersonGeneralInfo/PhotoHandler.ashx?NodeID='+CAST(m.NodeID as varchar(50)) URI
FROM [Profile.Data].[Person.Photo] p
	INNER JOIN [RDF.Stage].[InternalNodeMap] m
		ON m.Class = 'http://xmlns.com/foaf/0.1/Person'
			AND m.InternalType = 'Person'
			AND m.InternalID = CAST(p.PersonID as varchar(50))
	INNER JOIN [Framework.].[Parameter] o
		ON o.ParameterID = 'baseURI';
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.].[vwClass] AS
	select Class, Label, ClassNode, LabelNode
		from (
			select s.Value Class, l.Value Label, s.NodeID ClassNode, l.NodeID LabelNode,
				row_number() over (partition by s.Value order by s.NodeID, l.NodeID) k
			from [RDF.].Triple t
				inner join [RDF.].Node s
					on t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
						and t.object = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#Class')
						and t.subject = s.NodeID
				left outer join [RDF.].Triple v
					on v.subject = t.subject
						and v.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')
				left outer join [RDF.].Node l
					on v.object = l.NodeID
		) t
		where k = 1
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Publication.MyPub.GetPublication](	@mpid NVARCHAR(50))
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	HmsPubCategory, 
					AdditionalInfo, 
					authors, 
					PlaceOfPub, 
					NewspaperCol, 
					ConfDTS, 
					ConfEditors, 
					ConfNM, 
					ContractNum, 
					PublicationDT, 
					edition, 
					IssuePub, 
					ConfLoc, 
					publisher, 
					url, 
					PaginationPub, 
					ReptNumber, 
					NewspaperSect, 
					PubTitle, 
					ArticleTitle, 
					DissUnivNM, 
					VolNum, 
					abstract 
    FROM	[Profile.Data].[Publication.MyPub.General] 
   WHERE	mpid =@mpid

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [Profile.Data].[vwPublication.Pubmed.Mesh.Descriptor]
AS
select pmid, descriptorname as MeshHeader, max(MajorTopicYN) MajorTopicYN
from [Profile.Data].[Publication.PubMed.Mesh]
group by pmid, descriptorname
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [RDF.].[vwPropertyWide] as
	with x as (
		select * from [RDF.].vwPropertyTall
	)
	select b.Value Domain, a.Property, a.Value Type, c.Value Range, d.Value MinCardinality, e.Value MaxCardinality, f.Value Label
	from x a
		left outer join x b
			on a.Property = b.Property and b.Predicate = 'http://www.w3.org/2000/01/rdf-schema#domain'
		left outer join x c
			on a.Property = c.Property and c.Predicate = 'http://www.w3.org/2000/01/rdf-schema#range'
		left outer join x d
			on a.Property = d.Property and d.Predicate = 'http://www.w3.org/2002/07/owl#minCardinality'
		left outer join x e
			on a.Property = e.Property and e.Predicate = 'http://www.w3.org/2002/07/owl#maxCardinality'
		left outer join x f
			on a.Property = f.Property and f.Predicate = 'http://www.w3.org/2000/01/rdf-schema#label'
	where a.Predicate = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
		and a.Value in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [Ontology.].[vwPropertyWide] as
	with x as (
		select * from [Ontology.].vwPropertyTall
	)
	select b.Value Domain, a.Property, a.Value Type, c.Value Range, d.Value MinCardinality, e.Value MaxCardinality, f.Value Label
	from x a
		left outer join x b
			on a.Property = b.Property and b.Predicate = 'http://www.w3.org/2000/01/rdf-schema#domain'
		left outer join x c
			on a.Property = c.Property and c.Predicate = 'http://www.w3.org/2000/01/rdf-schema#range'
		left outer join x d
			on a.Property = d.Property and d.Predicate = 'http://www.w3.org/2002/07/owl#minCardinality'
		left outer join x e
			on a.Property = e.Property and e.Predicate = 'http://www.w3.org/2002/07/owl#maxCardinality'
		left outer join x f
			on a.Property = f.Property and f.Predicate = 'http://www.w3.org/2000/01/rdf-schema#label'
	where a.Predicate = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
		and a.Value in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [Ontology.].[vwMissingPropertyGroupProperty] as
	with a as (
		select max(SortOrder) StartID
		from [ontology.].PropertyGroupProperty
		where PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview'
	), b as (
		select distinct Property
		from [RDF.].vwPropertyTall
		where Property not in (select PropertyURI from [ontology.].PropertyGroupProperty)
	)
	select 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview' PropertyGroupURI,
			Property PropertyURI,
			row_number() over (order by Property) + StartID SortOrder
		from a, b
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [Ontology.].[vwMissingClassProperty] as
	with a as (
		select max(ClassPropertyID) StartID
		from [Ontology.].ClassProperty
	), b as (
		select Class, min(HasType) HasType, min(HasLabel) HasLabel
		from (
			select Class, 0 HasType, 0 HasLabel
				from [RDF.].[vwClass]
				where Class not in (select class from [Ontology.].ClassProperty)
			union all
			select Class, 0 HasType, 1 HasLabel
				from [Ontology.].ClassProperty
				where Class not in (
					select Class 
					from [Ontology.].ClassProperty
					where Property = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' and NetworkProperty is null
				)
			union all
			select Class, 1 HasType, 0 HasLabel
				from [Ontology.].ClassProperty
				where Class not in (
					select Class 
					from [Ontology.].ClassProperty
					where Property = 'http://www.w3.org/2000/01/rdf-schema#label' and NetworkProperty is null
				)
			) t
		group by Class
	), c as (
		select Class, null NetworkProperty, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' Property, 0 IsDetail, null Limit, 1 IncludeDescription, 0 IncludeNetwork,
				0 SearchWeight,
				1 CustomDisplay, 0 CustomEdit, -1 ViewSecurityGroup, 
				-40 EditSecurityGroup,
				-40 EditPermissionsSecurityGroup, -40 EditExistingSecurityGroup, -40 EditAddNewSecurityGroup, -40 EditAddExistingSecurityGroup, -40 EditDeleteSecurityGroup,
				1 MinCardinality, null MaxCardinality, cast(null as xml) CustomEditModule
			from b
			where HasType = 0
		union all
		select Class, null NetworkProperty, 'http://www.w3.org/2000/01/rdf-schema#label' Property, 0 IsDetail, null Limit, 0 IncludeDescription, 0 IncludeNetwork,
				1 SearchWeight,
				1 CustomDisplay, 0 CustomEdit, -1 ViewSecurityGroup, 
				-40 EditSecurityGroup,
				-40 EditPermissionsSecurityGroup, -40 EditExistingSecurityGroup, -40 EditAddNewSecurityGroup, -40 EditAddExistingSecurityGroup, -40 EditDeleteSecurityGroup,
				1 MinCardinality, null MaxCardinality, cast(null as xml) CustomEditModule
			from b
			where HasLabel = 0
		union all
		select p.Value Domain, null NetworkProperty, p.Property, 1 IsDetail, null Limit, 
				(case when t.Value = 'http://www.w3.org/2002/07/owl#ObjectProperty' then 1 else 0 end) IncludeDescription, 
				0 IncludeNetwork,
				(case when t.Value = 'http://www.w3.org/2002/07/owl#ObjectProperty' then 0 else 0.5 end) SearchWeight,
				0 CustomDisplay, 0 CustomEdit, -1 ViewSecurityGroup, 
				-40 EditSecurityGroup,
				-40 EditPermissionsSecurityGroup, -40 EditExistingSecurityGroup, -40 EditAddNewSecurityGroup, -40 EditAddExistingSecurityGroup, -40 EditDeleteSecurityGroup,
				0 MinCardinality, null MaxCardinality, cast(null as xml) CustomEditModule
			from [RDF.].vwPropertyTall p, [RDF.].vwPropertyTall t
			where p.Predicate = 'http://www.w3.org/2000/01/rdf-schema#domain'
				and p.Property = t.Property
				and t.Predicate = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
				and t.Value in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
				and not exists (
					select *
					from [Ontology.].ClassProperty c
					where c.Class = p.Value and c.Property = p.Property and c.NetworkProperty is null
				)
	)
	select row_number() over (order by c.Class, c.Property) + a.StartID ClassPropertyID, c.*
		from c, a
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Person.UpdateSimilarPerson]
AS
BEGIN

	 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	create table #cache_similar_people (personid int, similarpersonid int, weight float, coauthor bit, numberOfSubjectAreas int)
 
 
 
	-- minutes
	select * into #cache_user_mesh from [Profile.Cache].[Concept.Mesh.Person]
	create unique clustered index idx_pm on #cache_user_mesh(personid,meshheader)
	declare @maxp int
	declare @p int
	select @maxp = max(personid) from [Profile.Cache].[Concept.Mesh.Person]
	set @p = 1
	while @p <= @maxp
	begin
		INSERT INTO #cache_similar_people(personid,similarpersonid,weight,coauthor,numberOfSubjectAreas)
			SELECT personid, similarpersonid, weight, 0 coauthor, numberOfSubjectAreas
			FROM (
				SELECT personid, similarpersonid, weight, numberOfSubjectAreas,
						row_number() over (partition by personid order by weight desc) k
				FROM (
					SELECT a.personid,
						b.personid similarpersonid,
						SUM(a.weight * b.weight) weight,
						count(*) numberOfSubjectAreas
					FROM #cache_user_mesh a inner join #cache_user_mesh b 
						ON a.meshheader = b.meshheader 
							AND a.personid <> b.personid 
							AND a.personid between @p and @p+999
					GROUP BY a.personid, b.personid
				) t
			) t
			WHERE k <= 60
		set @p = @p + 1000
	end
 
 
 
 
	-- Set CoAuthor Flag
	create unique clustered index idx_ps on #cache_similar_people(personid,similarpersonid)
	select distinct a.personid a, b.personid b
		into #coauthors
		from [Profile.Data].[Publication.Person.Include] a, [Profile.Data].[Publication.Person.Include] b
		where a.pmid = b.pmid and a.personid <> b.personid
	create unique clustered index idx_ab on #coauthors(a,b)
	update t 
		set coauthor = 1
		from #cache_similar_people t, #coauthors c
		where t.personid = c.a and t.similarpersonid = c.b
 
	BEGIN TRY
		BEGIN TRAN
			truncate table [Profile.Cache].[Person.SimilarPerson]
			insert into [Profile.Cache].[Person.SimilarPerson](PersonID, SimilarPersonID, Weight, CoAuthor, numberOfSubjectAreas)
				select PersonID, SimilarPersonID, Weight, CoAuthor, numberOfSubjectAreas
				from #cache_similar_people
			select @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@error = 1,@insert_new_record=0
		-- Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@ProcessedRows = @rows,@insert_new_record=0
 
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.DeleteOnePublication]
	@PersonID INT,
	@PubID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY 	 
	BEGIN TRANSACTION

		if exists (select * from [Profile.Data].[Publication.Person.Include]  where pubid = @PubID and PersonID = @PersonID)
		begin

			declare @pmid int
			declare @mpid varchar(50)

			set @pmid = (select pmid from [Profile.Data].[Publication.Person.Include] where pubid = @PubID)
			set @mpid = (select mpid from [Profile.Data].[Publication.Person.Include] where pubid = @PubID)

			insert into [Profile.Data].[Publication.Person.Exclude](pubid,PersonID,pmid,mpid)
				values (@pubid,@PersonID,@pmid,@mpid)

			delete from [Profile.Data].[Publication.Person.Include] where pubid = @PubID
			delete from [Profile.Data].[Publication.Person.Add] where pubid = @PubID

			if @pmid is not null
				delete from [Profile.Cache].[Publication.PubMed.AuthorPosition] where personid = @PersonID and pmid = @pmid

		end

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.DeleteAllPublications]
	@PersonID INT,
	@deletePMID BIT = 0,
	@deleteMPID BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @pubids table (pubid uniqueidentifier primary key)

	insert into @pubids(pubid)
		select pubid 
			from [Profile.Data].[Publication.Person.Include] 
			where PersonID = @PersonID AND (
					( (@deletePMID = 1) AND (@deleteMPID = 0) AND (pmid is not null) )
				or	( (@deletePMID = 0) AND (@deleteMPID = 1) AND (pmid is null) AND (mpid is not null) )
				or	( (@deletePMID = 1) AND (@deleteMPID = 1) )
			)
BEGIN TRY 
	BEGIN TRANSACTION

			insert into [Profile.Data].[Publication.Person.Exclude]
			         (pubid,PersonID,pmid,mpid)
				select pubid,@PersonID,pmid,mpid 
					from [Profile.Data].[Publication.Person.Include] 
					where pubid in (select pubid from @pubids)

			delete a
				from [Profile.Cache].[Publication.PubMed.AuthorPosition] a, (
					select distinct pmid
					from [Profile.Data].[Publication.Person.Include] 
					where pubid in (select pubid from @pubids)
						and pmid is not null
				) t
				where a.personid = @PersonID and a.pmid = t.pmid

			delete from [Profile.Data].[Publication.Person.Include] 
					where pubid in (select pubid from @pubids)

			delete from [Profile.Data].[Publication.Person.Add]
					where pubid in (select pubid from @pubids)

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Publication.Entity.UpdateEntityOnePerson]
	@PersonID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 
	-- *******************************************************************
	-- *******************************************************************
	-- Update InformationResource entities
	-- *******************************************************************
	-- *******************************************************************
 
 
	----------------------------------------------------------------------
	-- Get a list of current publications
	----------------------------------------------------------------------
 
	CREATE TABLE #Publications
	(
		PMID INT NULL ,
		MPID NVARCHAR(50) NULL ,
		EntityDate DATETIME NULL ,
		Reference VARCHAR(MAX) NULL ,
		Source VARCHAR(25) NULL ,
		URL VARCHAR(1000) NULL ,
		Title VARCHAR(4000) NULL
	)
 
	-- Add PMIDs to the publications temp table
	INSERT  INTO #Publications
            ( PMID ,
              EntityDate ,
              Reference ,
              Source ,
              URL ,
              Title
            )
            SELECT -- Get Pub Med pubs
                    PG.PMID ,
                    EntityDate = PG.PubDate,
                    Reference = REPLACE([Profile.Cache].[fnPublication.Pubmed.General2Reference](PG.PMID,
                                                              PG.ArticleDay,
                                                              PG.ArticleMonth,
                                                              PG.ArticleYear,
                                                              PG.ArticleTitle,
                                                              PG.Authors,
                                                              PG.AuthorListCompleteYN,
                                                              PG.Issue,
                                                              PG.JournalDay,
                                                              PG.JournalMonth,
                                                              PG.JournalYear,
                                                              PG.MedlineDate,
                                                              PG.MedlinePgn,
                                                              PG.MedlineTA,
                                                              PG.Volume, 0),
                                        CHAR(11), '') ,
                    Source = 'PubMed',
                    URL = 'http://www.ncbi.nlm.nih.gov/pubmed/' + CAST(ISNULL(PG.pmid, '') AS VARCHAR(20)),
                    Title = left((case when IsNull(PG.ArticleTitle,'') <> '' then PG.ArticleTitle else 'Untitled Publication' end),4000)
            FROM    [Profile.Data].[Publication.PubMed.General] PG
			WHERE	PG.PMID IN (
						SELECT PMID 
						FROM [Profile.Data].[Publication.Person.Include]
						WHERE PMID IS NOT NULL AND PersonID = @PersonID
					)
					AND PG.PMID NOT IN (
						SELECT PMID
						FROM [Profile.Data].[Publication.Entity.InformationResource]
						WHERE PMID IS NOT NULL
					)
 
	-- Add MPIDs to the publications temp table
	INSERT  INTO #Publications
            ( MPID ,
              EntityDate ,
			  Reference ,
			  Source ,
              URL ,
              Title
            )
            SELECT  MPID ,
                    EntityDate ,
 
 
                     Reference = REPLACE(authors
										+ (CASE WHEN IsNull(article,'') <> '' THEN article + '. ' ELSE '' END)
										+ (CASE WHEN IsNull(pub,'') <> '' THEN pub + '. ' ELSE '' END)
										+ y
                                        + CASE WHEN y <> ''
                                                    AND vip <> '' THEN '; '
                                               ELSE ''
                                          END + vip
                                        + CASE WHEN y <> ''
                                                    OR vip <> '' THEN '.'
                                               ELSE ''
                                          END, CHAR(11), '') ,
                    Source = 'Custom' ,
                    URL = url,
                    Title = left((case when IsNull(article,'')<>'' then article when IsNull(pub,'')<>'' then pub else 'Untitled Publication' end),4000)
            FROM    ( SELECT    MPID ,
                                EntityDate ,
                                url ,
                                authors = CASE WHEN authors = '' THEN ''
                                               WHEN RIGHT(authors, 1) = '.'
                                               THEN LEFT(authors,
                                                         LEN(authors) - 1)
                                               ELSE authors
                                          END ,
                                article = CASE WHEN article = '' THEN ''
                                               WHEN RIGHT(article, 1) = '.'
                                               THEN LEFT(article,
                                                         LEN(article) - 1)
                                               ELSE article
                                          END ,
                                pub = CASE WHEN pub = '' THEN ''
                                           WHEN RIGHT(pub, 1) = '.'
                                           THEN LEFT(pub, LEN(pub) - 1)
                                           ELSE pub
                                      END ,
                                y ,
                                vip
                      FROM      ( SELECT    MPG.mpid ,
                                            EntityDate = MPG.publicationdt ,
                                            authors = CASE WHEN RTRIM(LTRIM(COALESCE(MPG.authors,
                                                              ''))) = ''
                                                           THEN ''
                                                           WHEN RIGHT(COALESCE(MPG.authors,
                                                              ''), 1) = '.'
                                                            THEN  COALESCE(MPG.authors,
                                                              '') + ' '
                                                           ELSE COALESCE(MPG.authors,
                                                              '') + '. '
                                                      END ,
                                            url = CASE WHEN COALESCE(MPG.url,
                                                              '') <> ''
                                                            AND LEFT(COALESCE(MPG.url,
                                                              ''), 4) = 'http'
                                                       THEN MPG.url
                                                       WHEN COALESCE(MPG.url,
                                                              '') <> ''
                                                       THEN 'http://' + MPG.url
                                                       ELSE ''
                                                  END ,
                                            article = LTRIM(RTRIM(COALESCE(MPG.articletitle,
                                                              ''))) ,
                                            pub = LTRIM(RTRIM(COALESCE(MPG.pubtitle,
                                                              ''))) ,
                                            y = CASE WHEN MPG.publicationdt > '1/1/1901'
                                                     THEN CONVERT(VARCHAR(50), YEAR(MPG.publicationdt))
                                                     ELSE ''
                                                END ,
                                            vip = COALESCE(MPG.volnum, '')
                                            + CASE WHEN COALESCE(MPG.issuepub,
                                                              '') <> ''
                                                   THEN '(' + MPG.issuepub
                                                        + ')'
                                                   ELSE ''
                                              END
                                            + CASE WHEN ( COALESCE(MPG.paginationpub,
                                                              '') <> '' )
                                                        AND ( COALESCE(MPG.volnum,
                                                              '')
                                                              + COALESCE(MPG.issuepub,
                                                              '') <> '' )
                                                   THEN ':'
                                                   ELSE ''
                                              END + COALESCE(MPG.paginationpub,
                                                             '')
                                  FROM      [Profile.Data].[Publication.MyPub.General] MPG
                                  INNER JOIN [Profile.Data].[Publication.Person.Include] PL ON MPG.mpid = PL.mpid
                                                           AND PL.mpid NOT LIKE 'DASH%'
                                                           AND PL.mpid NOT LIKE 'ISI%'
                                                           AND PL.pmid IS NULL
                                                           AND PL.PersonID = @PersonID
									WHERE MPG.MPID NOT IN (
										SELECT MPID
										FROM [Profile.Data].[Publication.Entity.InformationResource]
										WHERE (MPID IS NOT NULL)
									)
                                ) T0
                    ) T0
 
	CREATE NONCLUSTERED INDEX idx_pmid on #publications(pmid)
	CREATE NONCLUSTERED INDEX idx_mpid on #publications(mpid)

	----------------------------------------------------------------------
	-- Update the Publication.Entity.InformationResource table
	----------------------------------------------------------------------
 
	-- Insert new publications
	INSERT INTO [Profile.Data].[Publication.Entity.InformationResource] (
			PMID,
			MPID,
			EntityName,
			EntityDate,
			Reference,
			Source,
			URL,
			IsActive
		)
		SELECT 	PMID,
				MPID,
				Title,
				EntityDate,
				Reference,
				Source,
				URL,
				1 IsActive
		FROM #publications
	-- Assign an EntityName, PubYear, and YearWeight
	UPDATE e
		SET --e.EntityName = 'Publication ' + CAST(e.EntityID as VARCHAR(50)),
			e.PubYear = year(e.EntityDate),
			e.YearWeight = (case when e.EntityDate is null then 0.5
							when year(e.EntityDate) <= 1901 then 0.5
							else power(cast(0.5 as float),cast(datediff(d,e.EntityDate,GetDate()) as float)/365.25/10)
							end)
		FROM [Profile.Data].[Publication.Entity.InformationResource] e,
			#publications p
		WHERE ((e.PMID = p.PMID) OR (e.MPID = p.MPID))
 
	-- *******************************************************************
	-- *******************************************************************
	-- Update Authorship entities
	-- *******************************************************************
	-- *******************************************************************
 
 	----------------------------------------------------------------------
	-- Get a list of current Authorship records
	----------------------------------------------------------------------

	CREATE TABLE #Authorship
	(
		EntityDate DATETIME NULL ,
		authorRank INT NULL,
		numberOfAuthors INT NULL,
		authorNameAsListed VARCHAR(255) NULL,
		AuthorWeight FLOAT NULL,
		AuthorPosition VARCHAR(1) NULL,
		PubYear INT NULL ,
		YearWeight FLOAT NULL ,
		PersonID INT NULL ,
		InformationResourceID INT NULL,
		PMID INT NULL,
		IsActive BIT
	)
 
	INSERT INTO #Authorship (EntityDate, PersonID, InformationResourceID, PMID, IsActive)
		SELECT e.EntityDate, i.PersonID, e.EntityID, e.PMID, 1 IsActive
			FROM [Profile.Data].[Publication.Entity.InformationResource] e,
				[Profile.Data].[Publication.Person.Include] i
			WHERE (e.PMID = i.PMID) and (e.PMID is not null) and (i.PersonID = @PersonID)
	INSERT INTO #Authorship (EntityDate, PersonID, InformationResourceID, PMID, IsActive)
		SELECT e.EntityDate, i.PersonID, e.EntityID, null PMID, 1 IsActive
			FROM [Profile.Data].[Publication.Entity.InformationResource] e,
				[Profile.Data].[Publication.Person.Include] i
			WHERE (e.MPID = i.MPID) and (e.MPID is not null) and (e.PMID is null) and (i.PersonID = @PersonID)
	CREATE NONCLUSTERED INDEX idx_person_pmid ON #Authorship(PersonID, PMID)
	CREATE NONCLUSTERED INDEX idx_person_pub ON #Authorship(PersonID, InformationResourceID)
 
	UPDATE a
		SET	a.authorRank=p.authorRank,
			a.numberOfAuthors=p.numberOfAuthors,
			a.authorNameAsListed=p.authorNameAsListed, 
			a.AuthorWeight=p.AuthorWeight, 
			a.AuthorPosition=p.AuthorPosition,
			a.PubYear=p.PubYear,
			a.YearWeight=p.YearWeight
		FROM #Authorship a, [Profile.Cache].[Publication.PubMed.AuthorPosition]  p
		WHERE a.PersonID = p.PersonID and a.PMID = p.PMID and a.PMID is not null
	UPDATE #authorship
		SET authorWeight = 0.5
		WHERE authorWeight IS NULL
	UPDATE #authorship
		SET authorPosition = 'U'
		WHERE authorPosition IS NULL
	UPDATE #authorship
		SET PubYear = year(EntityDate)
		WHERE PubYear IS NULL
	UPDATE #authorship
		SET	YearWeight = (case when EntityDate is null then 0.5
							when year(EntityDate) <= 1901 then 0.5
							else power(cast(0.5 as float),cast(datediff(d,EntityDate,GetDate()) as float)/365.25/10)
							end)
		WHERE YearWeight IS NULL

	----------------------------------------------------------------------
	-- Update the Publication.Authorship table
	----------------------------------------------------------------------
 
	-- Set IsActive = 0 for Authorships that no longer exist
	UPDATE [Profile.Data].[Publication.Entity.Authorship]
		SET IsActive = 0
		WHERE PersonID = @PersonID
			AND InformationResourceID NOT IN (SELECT InformationResourceID FROM #authorship)
	-- Set IsActive = 1 for current Authorships and update data
	UPDATE e
		SET e.EntityDate = a.EntityDate,
			e.authorRank = a.authorRank,
			e.numberOfAuthors = a.numberOfAuthors,
			e.authorNameAsListed = a.authorNameAsListed,
			e.authorWeight = a.authorWeight,
			e.authorPosition = a.authorPosition,
			e.PubYear = a.PubYear,
			e.YearWeight = a.YearWeight,
			e.IsActive = 1
		FROM #authorship a, [Profile.Data].[Publication.Entity.Authorship] e
		WHERE a.PersonID = e.PersonID and a.InformationResourceID = e.InformationResourceID
	-- Insert new Authorships
	INSERT INTO [Profile.Data].[Publication.Entity.Authorship] (
			EntityDate,
			authorRank,
			numberOfAuthors,
			authorNameAsListed,
			authorWeight,
			authorPosition,
			PubYear,
			YearWeight,
			PersonID,
			InformationResourceID,
			IsActive
		)
		SELECT 	EntityDate,
				authorRank,
				numberOfAuthors,
				authorNameAsListed,
				authorWeight,
				authorPosition,
				PubYear,
				YearWeight,
				PersonID,
				InformationResourceID,
				IsActive
		FROM #authorship a
		WHERE NOT EXISTS (
			SELECT *
			FROM [Profile.Data].[Publication.Entity.Authorship] e
			WHERE a.PersonID = e.PersonID and a.InformationResourceID = e.InformationResourceID
		)
	-- Assign an EntityName
	UPDATE [Profile.Data].[Publication.Entity.Authorship]
		SET EntityName = 'Authorship ' + CAST(EntityID as VARCHAR(50))
		WHERE PersonID = @PersonID AND EntityName is null


	-- *******************************************************************
	-- *******************************************************************
	-- Update RDF
	-- *******************************************************************
	-- *******************************************************************



	--------------------------------------------------------------
	-- Version 3 : Create stub RDF
	--------------------------------------------------------------

	CREATE TABLE #sql (
		i INT IDENTITY(0,1) PRIMARY KEY,
		s NVARCHAR(MAX)
	)
	INSERT INTO #sql (s)
		SELECT	'EXEC [RDF.Stage].ProcessDataMap '
					+'  @DataMapID = '+CAST(DataMapID AS VARCHAR(50))
					+', @InternalIdIn = '+InternalIdIn
					+', @TurnOffIndexing=0, @SaveLog=0; '
		FROM (
			SELECT *, '''SELECT CAST(EntityID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.Authorship] WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#Authorship'
					AND NetworkProperty IS NULL
					AND Property IS NULL
			UNION ALL
			SELECT *, '''' + CAST(@PersonID AS VARCHAR(50)) + '''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://xmlns.com/foaf/0.1/Person' 
					AND property = 'http://vivoweb.org/ontology/core#authorInAuthorship'
					AND NetworkProperty IS NULL
		) t
		ORDER BY DataMapID

	DECLARE @s NVARCHAR(MAX)
	WHILE EXISTS (SELECT * FROM #sql)
	BEGIN
		SELECT @s = s
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
		print @s
		EXEC sp_executesql @s
		DELETE
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
	END

	--select * from [Ontology.].DataMap


/*

	--------------------------------------------------------------
	-- Version 1 : Create all RDF using ProcessDataMap
	--------------------------------------------------------------

	CREATE TABLE #sql (
		i INT IDENTITY(0,1) PRIMARY KEY,
		s NVARCHAR(MAX)
	)
	INSERT INTO #sql (s)
		SELECT	'EXEC [RDF.Stage].ProcessDataMap '
					+'  @DataMapID = '+CAST(DataMapID AS VARCHAR(50))
					+', @InternalIdIn = '+InternalIdIn
					+', @TurnOffIndexing=0, @SaveLog=0; '
		FROM (
			SELECT *, '''SELECT CAST(InformationResourceID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.Authorship] WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#InformationResource' 
					AND IsNull(property,'') <> 'http://vivoweb.org/ontology/core#informationResourceInAuthorship'
					AND NetworkProperty IS NULL
			UNION ALL
			SELECT *, '''SELECT CAST(EntityID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.Authorship] WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#Authorship'
					AND IsNull(property,'') NOT IN ('http://vivoweb.org/ontology/core#linkedAuthor','http://vivoweb.org/ontology/core#linkedInformationResource')
					AND NetworkProperty IS NULL
			UNION ALL
			SELECT *, '''SELECT CAST(InformationResourceID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.Authorship] WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#InformationResource' 
					AND property = 'http://vivoweb.org/ontology/core#informationResourceInAuthorship'
					AND NetworkProperty IS NULL
			UNION ALL
			SELECT *, '''' + CAST(@PersonID AS VARCHAR(50)) + '''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://xmlns.com/foaf/0.1/Person' 
					AND property = 'http://vivoweb.org/ontology/core#authorInAuthorship'
					AND NetworkProperty IS NULL
		) t
		ORDER BY DataMapID

	DECLARE @s NVARCHAR(MAX)
	WHILE EXISTS (SELECT * FROM #sql)
	BEGIN
		SELECT @s = s
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
		--print @s
		EXEC sp_executesql @s
		DELETE
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
	END

*/


/*

	---------------------------------------------------------------------------------
	-- Version 2 : Create new entities using ProcessDataMap, and triples manually
	---------------------------------------------------------------------------------

	CREATE TABLE #sql (
		i INT IDENTITY(0,1) PRIMARY KEY,
		s NVARCHAR(MAX)
	)
	INSERT INTO #sql (s)
		SELECT	'EXEC [RDF.Stage].ProcessDataMap '
					+'  @DataMapID = '+CAST(DataMapID AS VARCHAR(50))
					+', @InternalIdIn = '+InternalIdIn
					+', @TurnOffIndexing=0, @SaveLog=0; '
		FROM (
			SELECT *, '''SELECT CAST(InformationResourceID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.Authorship] WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#InformationResource' 
					AND IsNull(property,'') <> 'http://vivoweb.org/ontology/core#informationResourceInAuthorship'
					AND NetworkProperty IS NULL
			UNION ALL
			SELECT *, '''SELECT CAST(EntityID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.Authorship] WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#Authorship'
					AND IsNull(property,'') NOT IN ('http://vivoweb.org/ontology/core#linkedAuthor','http://vivoweb.org/ontology/core#linkedInformationResource')
					AND NetworkProperty IS NULL
		) t
		ORDER BY DataMapID

	--select * from #sql
	--return

	DECLARE @s NVARCHAR(MAX)
	WHILE EXISTS (SELECT * FROM #sql)
	BEGIN
		SELECT @s = s
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
		--print @s
		EXEC sp_executesql @s
		DELETE
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
	END


	CREATE TABLE #a (
		PersonID INT,
		AuthorshipID INT,
		InformationResourceID INT,
		IsActive BIT,
		PersonNodeID BIGINT,
		AuthorshipNodeID BIGINT,
		InformationResourceNodeID BIGINT,
		AuthorInAuthorshipTripleID BIGINT,
		LinkedAuthorTripleID BIGINT,
		LinkedInformationResourceTripleID BIGINT,
		InformationResourceInAuthorshipTripleID BIGINT,
		AuthorRank INT,
		EntityDate DATETIME,
		TripleWeight FLOAT,
		AuthorRecord INT
	)
	-- Get authorship records
	INSERT INTO #a (PersonID, AuthorshipID, InformationResourceID, IsActive, AuthorRank, EntityDate, TripleWeight, AuthorRecord)
		SELECT PersonID, EntityID, InformationResourceID, IsActive, 
				AuthorRank, EntityDate, IsNull(authorweight * yearweight,0),
				0
			FROM [Profile.Data].[Publication.Entity.Authorship]
			WHERE PersonID = @PersonID
		UNION ALL
		SELECT PersonID, EntityID, InformationResourceID, IsActive, 
				AuthorRank, EntityDate, IsNull(authorweight * yearweight,0),
				1
			FROM [Profile.Data].[Publication.Entity.Authorship]
			WHERE PersonID <> @PersonID 
				AND IsActive = 1
				AND InformationResourceID IN (
					SELECT InformationResourceID
					FROM [Profile.Data].[Publication.Entity.Authorship]
					WHERE PersonID = @PersonID
				)
	-- Get entity IDs
	UPDATE a
		SET a.PersonNodeID = m.NodeID
		FROM #a a, [RDF.Stage].InternalNodeMap m
		WHERE m.Class = 'http://xmlns.com/foaf/0.1/Person'
			AND m.InternalType = 'Person'
			AND m.InternalID = CAST(a.PersonID AS VARCHAR(50))
	UPDATE a
		SET a.AuthorshipNodeID = m.NodeID
		FROM #a a, [RDF.Stage].InternalNodeMap m
		WHERE m.Class = 'http://vivoweb.org/ontology/core#Authorship'
			AND m.InternalType = 'Authorship'
			AND m.InternalID = CAST(a.AuthorshipID AS VARCHAR(50))
	UPDATE a
		SET a.InformationResourceNodeID = m.NodeID
		FROM #a a, [RDF.Stage].InternalNodeMap m
		WHERE m.Class = 'http://vivoweb.org/ontology/core#InformationResource'
			AND m.InternalType = 'InformationResource'
			AND m.InternalID = CAST(a.InformationResourceID AS VARCHAR(50))
	-- Get triple IDs
	UPDATE a
		SET a.AuthorInAuthorshipTripleID = t.TripleID
		FROM #a a, [RDF.].Triple t
		WHERE a.PersonNodeID IS NOT NULL AND a.AuthorshipNodeID IS NOT NULL
			AND t.subject = a.PersonNodeID
			AND t.predicate = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#authorInAuthorship')
			AND t.object = a.AuthorshipNodeID
	UPDATE a
		SET a.LinkedAuthorTripleID = t.TripleID
		FROM #a a, [RDF.].Triple t
		WHERE a.PersonNodeID IS NOT NULL AND a.AuthorshipNodeID IS NOT NULL
			AND t.subject = a.AuthorshipNodeID
			AND t.predicate = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#linkedAuthor')
			AND t.object = a.PersonNodeID
	UPDATE a
		SET a.LinkedInformationResourceTripleID = t.TripleID
		FROM #a a, [RDF.].Triple t
		WHERE a.AuthorshipNodeID IS NOT NULL AND a.InformationResourceID IS NOT NULL
			AND t.subject = a.AuthorshipNodeID
			AND t.predicate = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#linkedInformationResource')
			AND t.object = a.InformationResourceNodeID
	UPDATE a
		SET a.InformationResourceInAuthorshipTripleID = t.TripleID
		FROM #a a, [RDF.].Triple t
		WHERE a.AuthorshipNodeID IS NOT NULL AND a.InformationResourceID IS NOT NULL
			AND t.subject = a.InformationResourceNodeID
			AND t.predicate = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#informationResourceInAuthorship')
			AND t.object = a.AuthorshipNodeID
	
	--select * from #a
	--return
	--select * from [ontology.].datamap



	SELECT a.IsActive, a.subject, m._PropertyNode predicate, a.object, 
			a.TripleWeight, 0 ObjectType, a.SortOrder,
			IsNull(s.ViewSecurityGroup, m.ViewSecurityGroup) ViewSecurityGroup,
			a.TripleID, t.SortOrder ExistingSortOrder, X
		INTO #b
		FROM (
				SELECT AuthorshipNodeID subject, InformationResourceNodeID object, TripleWeight, 
						'http://vivoweb.org/ontology/core#Authorship' Class,
						'http://vivoweb.org/ontology/core#linkedInformationResource' Property,
						1 SortOrder,
						IsActive,
						LinkedInformationResourceTripleID TripleID,
						1 X
					FROM #a
					WHERE AuthorRecord = 0
					--WHERE IsActive = 1
				UNION ALL
				SELECT AuthorshipNodeID subject, PersonNodeID object, 1 TripleWeight,
						'http://vivoweb.org/ontology/core#Authorship' Class,
						'http://vivoweb.org/ontology/core#linkedAuthor' Property,
						1 SortOrder,
						IsActive,
						LinkedAuthorTripleID TripleID,
						2 X
					FROM #a
					WHERE AuthorRecord = 0
					--WHERE IsActive = 1
				UNION ALL
				SELECT InformationResourceNodeID subject, AuthorshipNodeID object, TripleWeight, 
						'http://vivoweb.org/ontology/core#InformationResource' Class,
						'http://vivoweb.org/ontology/core#informationResourceInAuthorship' Property,
						row_number() over (partition by InformationResourceNodeID, IsActive order by AuthorRank, t.SortOrder, AuthorshipNodeID) SortOrder,
						IsActive,
						InformationResourceInAuthorshipTripleID TripleID,
						3 X
					FROM #a a
						LEFT OUTER JOIN [RDF.].[Triple] t
						ON a.InformationResourceInAuthorshipTripleID = t.TripleID
					--WHERE IsActive = 1
				UNION ALL
				SELECT PersonNodeID subject, AuthorshipNodeID object, 1 TripleWeight, 
						'http://xmlns.com/foaf/0.1/Person' Class,
						'http://vivoweb.org/ontology/core#authorInAuthorship' Property,
						row_number() over (partition by PersonNodeID, IsActive order by EntityDate desc) SortOrder,
						IsActive,
						AuthorInAuthorshipTripleID TripleID,
						4 X
					FROM #a
					WHERE AuthorRecord = 0
					--WHERE IsActive = 1
			) a
			INNER JOIN [Ontology.].[DataMap] m
				ON m.Class = a.Class AND m.NetworkProperty IS NULL AND m.Property = a.Property
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON a.TripleID = t.TripleID
			LEFT OUTER JOIN [RDF.Security].[NodeProperty] s
				ON s.NodeID = a.subject
					AND s.Property = m._PropertyNode

	--SELECT * FROM #b ORDER BY X, subject, property, IsActive, sortorder

	-- Delete
	DELETE
		FROM [RDF.].Triple
		WHERE TripleID IN (
			SELECT TripleID
			FROM #b
			WHERE IsActive = 0 AND TripleID IS NOT NULL
		)
	--select @@ROWCOUNT

	-- Update
	UPDATE t
		SET t.SortOrder = b.SortOrder
		FROM [RDF.].Triple t
			INNER JOIN #b b
			ON t.TripleID = b.TripleID
				AND b.IsActive = 1 
				AND b.TripleID IS NOT NULL
				AND b.SortOrder <> b.ExistingSortOrder
	--select @@ROWCOUNT

	-- Insert
	INSERT INTO [RDF.].Triple (Subject,Predicate,Object,TripleHash,Weight,Reitification,ObjectType,SortOrder,ViewSecurityGroup,Graph)
		SELECT Subject,Predicate,Object,
				[RDF.].fnTripleHash(Subject,Predicate,Object),
				TripleWeight,NULL,0,SortOrder,ViewSecurityGroup,1
			FROM #b
			WHERE IsActive = 1 AND TripleID IS NULL
	--select @@ROWCOUNT

*/


END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Publication.Entity.UpdateEntity]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 
	-- *******************************************************************
	-- *******************************************************************
	-- Update InformationResource entities
	-- *******************************************************************
	-- *******************************************************************
 
 
	----------------------------------------------------------------------
	-- Get a list of current publications
	----------------------------------------------------------------------

	CREATE TABLE #Publications
	(
		PMID INT NULL ,
		MPID NVARCHAR(50) NULL ,
		EntityDate DATETIME NULL ,
		Reference VARCHAR(MAX) NULL ,
		Source VARCHAR(25) NULL ,
		URL VARCHAR(1000) NULL ,
		Title VARCHAR(4000) NULL ,
		EntityID INT NULL
	)
 
	-- Add PMIDs to the publications temp table
	INSERT  INTO #Publications
            ( PMID ,
              EntityDate ,
              Reference ,
              Source ,
              URL ,
              Title
            )
            SELECT -- Get Pub Med pubs
                    PG.PMID ,
                    EntityDate = PG.PubDate,
                    Reference = REPLACE([Profile.Cache].[fnPublication.Pubmed.General2Reference](PG.PMID,
                                                              PG.ArticleDay,
                                                              PG.ArticleMonth,
                                                              PG.ArticleYear,
                                                              PG.ArticleTitle,
                                                              PG.Authors,
                                                              PG.AuthorListCompleteYN,
                                                              PG.Issue,
                                                              PG.JournalDay,
                                                              PG.JournalMonth,
                                                              PG.JournalYear,
                                                              PG.MedlineDate,
                                                              PG.MedlinePgn,
                                                              PG.MedlineTA,
                                                              PG.Volume, 0),
                                        CHAR(11), '') ,
                    Source = 'PubMed',
                    URL = 'http://www.ncbi.nlm.nih.gov/pubmed/' + CAST(ISNULL(PG.pmid, '') AS VARCHAR(20)),
                    Title = left((case when IsNull(PG.ArticleTitle,'') <> '' then PG.ArticleTitle else 'Untitled Publication' end),4000)
            FROM    [Profile.Data].[Publication.PubMed.General] PG
			WHERE	PG.PMID IN (
						SELECT PMID 
						FROM [Profile.Data].[Publication.Person.Include]
						WHERE PMID IS NOT NULL )
 
	-- Add MPIDs to the publications temp table
	INSERT  INTO #Publications
            ( MPID ,
              EntityDate ,
			  Reference ,
			  Source ,
              URL ,
              Title
            )
            SELECT  MPID ,
                    EntityDate ,
                    Reference = REPLACE(authors
										+ (CASE WHEN IsNull(article,'') <> '' THEN article + '. ' ELSE '' END)
										+ (CASE WHEN IsNull(pub,'') <> '' THEN pub + '. ' ELSE '' END)
										+ y
                                        + CASE WHEN y <> ''
                                                    AND vip <> '' THEN '; '
                                               ELSE ''
                                          END + vip
                                        + CASE WHEN y <> ''
                                                    OR vip <> '' THEN '.'
                                               ELSE ''
                                          END, CHAR(11), '') ,
                    Source = 'Custom' ,
                    URL = url,
                    Title = left((case when IsNull(article,'')<>'' then article when IsNull(pub,'')<>'' then pub else 'Untitled Publication' end),4000)
            FROM    ( SELECT    MPID ,
                                EntityDate ,
                                url ,
                                authors = CASE WHEN authors = '' THEN ''
                                               WHEN RIGHT(authors, 1) = '.'
                                               THEN LEFT(authors,
                                                         LEN(authors) - 1)
                                               ELSE authors
                                          END ,
                                article = CASE WHEN article = '' THEN ''
                                               WHEN RIGHT(article, 1) = '.'
                                               THEN LEFT(article,
                                                         LEN(article) - 1)
                                               ELSE article
                                          END ,
                                pub = CASE WHEN pub = '' THEN ''
                                           WHEN RIGHT(pub, 1) = '.'
                                           THEN LEFT(pub, LEN(pub) - 1)
                                           ELSE pub
                                      END ,
                                y ,
                                vip
                      FROM      ( SELECT    MPG.mpid ,
                                            EntityDate = MPG.publicationdt ,
                                            authors = CASE WHEN RTRIM(LTRIM(COALESCE(MPG.authors,
                                                              ''))) = ''
                                                           THEN ''
                                                           WHEN RIGHT(COALESCE(MPG.authors,
                                                              ''), 1) = '.'
                                                            THEN  COALESCE(MPG.authors,
                                                              '') + ' '
                                                           ELSE COALESCE(MPG.authors,
                                                              '') + '. '
                                                      END ,
                                            url = CASE WHEN COALESCE(MPG.url,
                                                              '') <> ''
                                                            AND LEFT(COALESCE(MPG.url,
                                                              ''), 4) = 'http'
                                                       THEN MPG.url
                                                       WHEN COALESCE(MPG.url,
                                                              '') <> ''
                                                       THEN 'http://' + MPG.url
                                                       ELSE ''
                                                  END ,
                                            article = LTRIM(RTRIM(COALESCE(MPG.articletitle,
                                                              ''))) ,
                                            pub = LTRIM(RTRIM(COALESCE(MPG.pubtitle,
                                                              ''))) ,
                                            y = CASE WHEN MPG.publicationdt > '1/1/1901'
                                                     THEN CONVERT(VARCHAR(50), YEAR(MPG.publicationdt))
                                                     ELSE ''
                                                END ,
                                            vip = COALESCE(MPG.volnum, '')
                                            + CASE WHEN COALESCE(MPG.issuepub,
                                                              '') <> ''
                                                   THEN '(' + MPG.issuepub
                                                        + ')'
                                                   ELSE ''
                                              END
                                            + CASE WHEN ( COALESCE(MPG.paginationpub,
                                                              '') <> '' )
                                                        AND ( COALESCE(MPG.volnum,
                                                              '')
                                                              + COALESCE(MPG.issuepub,
                                                              '') <> '' )
                                                   THEN ':'
                                                   ELSE ''
                                              END + COALESCE(MPG.paginationpub,
                                                             '')
                                  FROM      [Profile.Data].[Publication.MyPub.General] MPG
                                  INNER JOIN [Profile.Data].[Publication.Person.Include] PL ON MPG.mpid = PL.mpid
                                                           AND PL.mpid NOT LIKE 'DASH%'
                                                           AND PL.mpid NOT LIKE 'ISI%'
                                                           AND PL.pmid IS NULL
                                ) T0
                    ) T0
 
	CREATE NONCLUSTERED INDEX idx_pmid on #publications(pmid)
	CREATE NONCLUSTERED INDEX idx_mpid on #publications(mpid)

	----------------------------------------------------------------------
	-- Update the Publication.Entity.InformationResource table
	----------------------------------------------------------------------

	-- Determine which publications already exist
	UPDATE p
		SET p.EntityID = e.EntityID
		FROM #publications p, [Profile.Data].[Publication.Entity.InformationResource] e
		WHERE p.PMID = e.PMID and p.PMID is not null
	UPDATE p
		SET p.EntityID = e.EntityID
		FROM #publications p, [Profile.Data].[Publication.Entity.InformationResource] e
		WHERE p.MPID = e.MPID and p.MPID is not null
	CREATE NONCLUSTERED INDEX idx_entityid on #publications(EntityID)

	-- Deactivate old publications
	UPDATE e
		SET e.IsActive = 0
		FROM [Profile.Data].[Publication.Entity.InformationResource] e
		WHERE e.EntityID NOT IN (SELECT EntityID FROM #publications)

	-- Update the data for existing publications
	UPDATE e
		SET e.EntityDate = p.EntityDate,
			e.Reference = p.Reference,
			e.Source = p.Source,
			e.URL = p.URL,
			e.EntityName = p.Title,
			e.IsActive = 1
		FROM #publications p, [Profile.Data].[Publication.Entity.InformationResource] e
		WHERE p.EntityID = e.EntityID and p.EntityID is not null

	-- Insert new publications
	INSERT INTO [Profile.Data].[Publication.Entity.InformationResource] (
			PMID,
			MPID,
			EntityName,
			EntityDate,
			Reference,
			Source,
			URL,
			IsActive,
			PubYear,
			YearWeight
		)
		SELECT 	PMID,
				MPID,
				Title,
				EntityDate,
				Reference,
				Source,
				URL,
				1 IsActive,
				PubYear = year(EntityDate),
				YearWeight = (case when EntityDate is null then 0.5
								when year(EntityDate) <= 1901 then 0.5
								else power(cast(0.5 as float),cast(datediff(d,EntityDate,GetDate()) as float)/365.25/10)
								end)
		FROM #publications
		WHERE EntityID IS NULL

 
	-- *******************************************************************
	-- *******************************************************************
	-- Update Authorship entities
	-- *******************************************************************
	-- *******************************************************************
 
 	----------------------------------------------------------------------
	-- Get a list of current Authorship records
	----------------------------------------------------------------------

	CREATE TABLE #Authorship
	(
		EntityDate DATETIME NULL ,
		authorRank INT NULL,
		numberOfAuthors INT NULL,
		authorNameAsListed VARCHAR(255) NULL,
		AuthorWeight FLOAT NULL,
		AuthorPosition VARCHAR(1) NULL,
		PubYear INT NULL ,
		YearWeight FLOAT NULL ,
		PersonID INT NULL ,
		InformationResourceID INT NULL,
		PMID INT NULL,
		IsActive BIT,
		EntityID INT
	)
 
	INSERT INTO #Authorship (EntityDate, PersonID, InformationResourceID, PMID, IsActive)
		SELECT e.EntityDate, i.PersonID, e.EntityID, e.PMID, 1 IsActive
			FROM [Profile.Data].[Publication.Entity.InformationResource] e,
				[Profile.Data].[Publication.Person.Include] i
			WHERE e.PMID = i.PMID and e.PMID is not null
	INSERT INTO #Authorship (EntityDate, PersonID, InformationResourceID, PMID, IsActive)
		SELECT e.EntityDate, i.PersonID, e.EntityID, null PMID, 1 IsActive
			FROM [Profile.Data].[Publication.Entity.InformationResource] e,
				[Profile.Data].[Publication.Person.Include] i
			WHERE (e.MPID = i.MPID) and (e.MPID is not null) and (e.PMID is null)
	CREATE NONCLUSTERED INDEX idx_person_pmid ON #Authorship(PersonID, PMID)
	CREATE NONCLUSTERED INDEX idx_person_pub ON #Authorship(PersonID, InformationResourceID)

	UPDATE a
		SET	a.authorRank=p.authorRank,
			a.numberOfAuthors=p.numberOfAuthors,
			a.authorNameAsListed=p.authorNameAsListed, 
			a.AuthorWeight=p.AuthorWeight, 
			a.AuthorPosition=p.AuthorPosition,
			a.PubYear=p.PubYear,
			a.YearWeight=p.YearWeight
		FROM #Authorship a, [Profile.Cache].[Publication.PubMed.AuthorPosition]  p
		WHERE a.PersonID = p.PersonID and a.PMID = p.PMID and a.PMID is not null
	UPDATE #authorship
		SET authorWeight = 0.5
		WHERE authorWeight IS NULL
	UPDATE #authorship
		SET authorPosition = 'U'
		WHERE authorPosition IS NULL
	UPDATE #authorship
		SET PubYear = year(EntityDate)
		WHERE PubYear IS NULL
	UPDATE #authorship
		SET	YearWeight = (case when EntityDate is null then 0.5
							when year(EntityDate) <= 1901 then 0.5
							else power(cast(0.5 as float),cast(datediff(d,EntityDate,GetDate()) as float)/365.25/10)
							end)
		WHERE YearWeight IS NULL

	----------------------------------------------------------------------
	-- Update the Publication.Authorship table
	----------------------------------------------------------------------

	-- Determine which authorships already exist
	UPDATE a
		SET a.EntityID = e.EntityID
		FROM #authorship a, [Profile.Data].[Publication.Entity.Authorship] e
		WHERE a.PersonID = e.PersonID and a.InformationResourceID = e.InformationResourceID
 	CREATE NONCLUSTERED INDEX idx_entityid on #authorship(EntityID)

	-- Deactivate old authorships
	UPDATE a
		SET a.IsActive = 0
		FROM [Profile.Data].[Publication.Entity.Authorship] a
		WHERE a.EntityID NOT IN (SELECT EntityID FROM #authorship)

	-- Update the data for existing authorships
	UPDATE e
		SET e.EntityDate = a.EntityDate,
			e.authorRank = a.authorRank,
			e.numberOfAuthors = a.numberOfAuthors,
			e.authorNameAsListed = a.authorNameAsListed,
			e.authorWeight = a.authorWeight,
			e.authorPosition = a.authorPosition,
			e.PubYear = a.PubYear,
			e.YearWeight = a.YearWeight,
			e.IsActive = 1
		FROM #authorship a, [Profile.Data].[Publication.Entity.Authorship] e
		WHERE a.EntityID = e.EntityID and a.EntityID is not null

	-- Insert new Authorships
	INSERT INTO [Profile.Data].[Publication.Entity.Authorship] (
			EntityDate,
			authorRank,
			numberOfAuthors,
			authorNameAsListed,
			authorWeight,
			authorPosition,
			PubYear,
			YearWeight,
			PersonID,
			InformationResourceID,
			IsActive
		)
		SELECT 	EntityDate,
				authorRank,
				numberOfAuthors,
				authorNameAsListed,
				authorWeight,
				authorPosition,
				PubYear,
				YearWeight,
				PersonID,
				InformationResourceID,
				IsActive
		FROM #authorship a
		WHERE EntityID IS NULL

	-- Assign an EntityName
	UPDATE [Profile.Data].[Publication.Entity.Authorship]
		SET EntityName = 'Authorship ' + CAST(EntityID as VARCHAR(50))
		WHERE EntityName is null
 
END
GO
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  PROCEDURE [Profile.Data].[Publication.GetPersonSharedPublicationsKeyword]
    (
      @UserID INT ,
      @UserID2 INT ,
      @Keyword VARCHAR(2000) ,
      @ExactKeyword BIT
    )
AS 
    BEGIN

        IF @Keyword IS NOT NULL 
            BEGIN	
                EXEC [Search.Execute].[GetMatchingKeywords] @Keyword, NULL, 0,
                    @ExactKeyword							
                INSERT  INTO [Search.History].Keyword
                        ( Keyword, ExactKeyword, SearchDate )
                VALUES  ( @Keyword, @ExactKeyword, GETDATE() )

 
                INSERT  INTO [Search.Cache].APIQueryMatchedPublication
                        SELECT DISTINCT
                                personid ,
                                pmid ,
                                meshheader ,
                                phrase ,
                                keywordstring ,
                                ISNULL(@ExactKeyword, 0) ,
                                searchphrase ,
                                searchweight * meshweight ,
                                searchweight ,
                                uniquenessweight ,
                                topicweight ,
                                authorweight ,
                                yearweight ,
                                GETDATE() searchdate
                        FROM    [Profile.Cache].[Concept.Mesh.PersonPublication] c
                                JOIN ( SELECT DISTINCT
                                                KeywordString ,
                                                SearchPhrase ,
                                                Phrase ,
                                                PublicationPhrase ,
                                                SearchWeight ,
                                                ExactKeyword
                                       FROM     [Search.Cache].MatchingKeyword
                                       WHERE    KeywordString = @Keyword
                                                AND ExactKeyword = ISNULL(@ExactKeyword,
                                                              0)
                                     ) a ON a.PublicationPhrase = c.meshheader
                        WHERE   c.personid = @UserID
                                AND NOT EXISTS ( SELECT pmid
                                                 FROM   [Search.Cache].APIQueryMatchedPublication a2
                                                 WHERE  a2.personid = c.personid
                                                        AND a2.pmid = c.pmid
                                                        AND a2.meshheader = c.meshheader
                                                        AND a2.phrase = A.phrase
                                                        AND a2.keywordstring = a.keywordstring
                                                        AND a2.exactkeyword = ISNULL(@ExactKeyword,
                                                              0) )
            END
											  
        DECLARE @encode_html INT
        DECLARE @dash_url VARCHAR(MAX) 
        SELECT  @dash_url = ISNULL('http://dash.harvard.edu/handle/1/', '')
        SELECT  @encode_html = 0 ; 
 

        SELECT  category "CustomCategory" ,
                CAST(pubid AS VARCHAR(50)) "PublicationID" ,
                PUBLICATIONS "PublicationReference" ,
                t.pmid pmid ,
                CASE WHEN frompubmed = 1
                     THEN 'http://www.ncbi.nlm.nih.gov/pubmed/'
                          + CAST(ISNULL(t.pmid, '') AS VARCHAR(20))
                     ELSE URL
                END "URL" ,
                'true' "Primary" ,
                sourcename "Name" ,
                NULL "PublicationDetails"
        FROM    ( SELECT  DISTINCT
                            p.pmid ,
                            NULL AS mpid ,
                            [Profile.Cache].[fnPublication.Pubmed.General2Reference](p.pmid,
                                                              ArticleDay,
                                                              ArticleMonth,
                                                              ArticleYear,
                                                              ArticleTitle,
                                                              Authors,
                                                              AuthorListCompleteYN,
                                                              Issue,
                                                              JournalDay,
                                                              JournalMonth,
                                                              JournalYear,
                                                              MedlineDate,
                                                              MedlinePgn,
                                                              MedlineTA,
                                                              Volume, 0) AS publications ,
                            1 AS frompubmed ,
                            [Profile.Data].[fnPublication.Pubmed.GetPubDate](MedlineDate,
                                                              JournalYear,
                                                              JournalMonth,
                                                              JournalDay,
                                                              ArticleYear,
                                                              ArticleMonth,
                                                              ArticleDay) AS publication_dt ,
                            i.pubid ,
                            NULL category ,
                            NULL url ,
                            'PubMed' sourcename
                  FROM      [Profile.Data].[Publication.Person.Include] i
                            JOIN [Profile.Data].[Publication.Person.Include] i2 ON i2.PMID = i.PMID
                                                              AND i2.PersonID = ISNULL(@userid2,
                                                              i2.PersonID)
                            JOIN [Profile.Data].[Publication.PubMed.General] p ON i.pmid = p.pmid
                  WHERE     i.personid = @UserID
                            AND p.pmid IS NOT NULL
                  UNION ALL
                  SELECT  DISTINCT
                            m.pmid ,
                            m.mpid ,
												 --dbo.fn_GetPubli ' cations			,
                            ( SELECT    authors
                                        + ( CASE WHEN url < > ''
                                                      AND article <> ''
                                                      AND pub <> ''
                                                 THEN url + article + '</a>. '
                                                      + pub + '. '
                                                 WHEN url <> ''
                                                      AND article <> ''
                                                 THEN url + article + '</a>. '
                                                 WHEN url <> ''
                                                      AND pub <> ''
                                                 THEN url + pub + '</a>. '
                                                 WHEN article <> ''
                                                      AND pub <> ''
                                                 THEN article + '. ' + pub
                                                      + '. '
                                                 WHEN article <> ''
                                                 THEN article + '. '
                                                 WHEN pub <> ''
                                                 THEN pub + '. '
                                                 ELSE ''
                                            END ) + y
                                        + ( CASE WHEN y <> ''
                                                      AND vip <> '' THEN '; '
                                                 ELSE ''
                                            END ) + vip
                                        + ( CASE WHEN y <> ''
                                                      OR vip <> '' THEN '.'
                                                 ELSE ''
                                            END )
                              FROM      ( SELECT    url ,
                                                    ( CASE WHEN authors = ''
                                                           THEN ''
                                                           WHEN RIGHT(authors,
                                                              1) = '.'
                                                           THEN LEFT(authors,
                                                              LEN(authors) - 1)
                                                           ELSE authors
                                                      END ) authors ,
                                                    ( CASE WHEN article = ''
                                                           THEN ''
                                                           WHEN RIGHT(article,
                                                              1) = '.'
                                                           THEN LEFT(article,
                                                              LEN(article) - 1)
                                                           ELSE article
                                                      END ) article ,
                                                    ( CASE WHEN pub = ''
                                                           THEN ''
                                                           WHEN RIGHT(pub, 1) = '.'
                                                           THEN LEFT(pub,
                                                              LEN(pub) - 1)
                                                           ELSE pub
                                                      END ) pub ,
                                                    y ,
                                                    vip ,
                                                    frompubmed ,
                                                    publicationdt
                                          FROM      ( SELECT  ( CASE
                                                              WHEN RTRIM(LTRIM(COALESCE(authors,
                                                              ''))) = ''
                                                              THEN ''
                                                              WHEN RIGHT(COALESCE(authors,
                                                              ''), 1) = '.'
                                                              THEN COALESCE(authors,
                                                              '') + ' '
                                                              ELSE COALESCE(authors,
                                                              '') + '. '
                                                              END ) authors ,
                                                              ( CASE
                                                              WHEN COALESCE(url,
                                                              '') <> ''
                                                              AND LEFT(COALESCE(url,
                                                              ''), 4) = 'http'
                                                              THEN '<a href="'
                                                              + url
                                                              + '" target="_blank">'
                                                              WHEN COALESCE(url,
                                                              '') <> ''
                                                              THEN '<a href="http://'
                                                              + url
                                                              + '" target="_blank">'
                                                              ELSE ''
                                                              END ) url ,
                                                              LTRIM(RTRIM(COALESCE(articletitle,
                                                              ''))) article ,
                                                              LTRIM(RTRIM(COALESCE(pubtitle,
                                                              ''))) pub ,
                                                              ( CASE
                                                              WHEN publicationdt > '1/1/1901'
                                                              THEN CONVERT(VARCHAR(50), YEAR(publicationdt))
                                                              ELSE ''
                                                              END ) y ,
                                                              COALESCE(volnum,
                                                              '')
                                                              + ( CASE
                                                              WHEN COALESCE(issuepub,
                                                              '') <> ''
                                                              THEN '('
                                                              + issuepub + ')'
                                                              ELSE ''
                                                              END )
                                                              + ( CASE
                                                              WHEN ( COALESCE(paginationpub,
                                                              '') <> '' )
                                                              AND ( COALESCE(volnum,
                                                              '')
                                                              + COALESCE(issuepub,
                                                              '') <> '' )
                                                              THEN ':'
                                                              ELSE ''
                                                              END )
                                                              + COALESCE(paginationpub,
                                                              '') vip ,
                                                              0 AS frompubmed ,
                                                              publicationdt
                                                      FROM    [Profile.Data].[Publication.MyPub.General] m2
                                                      WHERE   m2.mpid = m.mpid
                                                    ) t
                                        ) t
                            ) AS publications ,
                            0 ,
                            publicationdt ,
                            i.pubid ,
                            hmspubcategory ,
                            url ,
                            'Custom' sourcename
                  FROM      [Profile.Data].[Publication.MyPub.General] m
                            JOIN [Profile.Data].[Publication.Person.Include] i ON i.mpid = m.mpid
                            JOIN [Profile.Data].[Publication.Person.Include] i2 ON i2.mpid = i.mpid
                                                              AND i2.PersonID = ISNULL(@userid2,
                                                              i2.PersonID)
                  WHERE     m.personid = @UserID
                            AND i.mpid IS NOT NULL
                            AND i.mpid NOT LIKE 'DASH%'
                            AND i.mpid NOT LIKE 'ISI%'
                            AND i.pmid IS NULL
                  UNION ALL
                  SELECT    NULL AS pmid ,
                            p.mpid ,
                            g.BibliographicCitation publications ,
                            0 AS FromPubMed ,
                            m.publicationdt ,
                            pubid ,
                            m.hmspubcategory ,
                            @dash_url + CAST(g.dashid AS VARCHAR(10)) url ,
                            'DASH' sourcename
                  FROM      [Profile.Data].[Publication.MyPub.General] m ,
                            [Profile.Data].[Publication.Person.Include] p ,
                            [Profile.Data].[Publication.DSpace.MPID] d ,
                            [Profile.Data].[Publication.DSpace.PubGeneral] g
                  WHERE     p.personid = @UserID
                            AND m.mpid = p.mpid
                            AND p.mpid IS NOT NULL
                            AND p.pmid IS NULL
                            AND p.mpid LIKE 'DASH%'
                            AND p.mpid = d.mpid
                            AND d.dashid = g.dashid
                  UNION ALL
                  SELECT    NULL AS pmid ,
                            p.mpid ,
                            ( g.authors + '. ' + g.itemtitle
                              + ( CASE WHEN RIGHT(g.itemtitle, 1) NOT IN ( '.',
                                                              '?', '!' )
                                       THEN '. '
                                       ELSE ' '
                                  END ) + COALESCE(g.sourceabbrev,
                                                   g.sourcetitle) + '. '
                              + g.bibid + '.' ) publications ,
                            0 AS FromPubMed ,
                            m.publicationdt ,
                            pubid ,
                            m.hmspubcategory ,
                            'http://dx.doi.org/' + doi url ,
                            'DOI' sourcename
                  FROM      [Profile.Data].[Publication.MyPub.General] m ,
                            [Profile.Data].[Publication.Person.Include] p ,
                            [Profile.Data].[Publication.ISI.MPID] d ,
                            [Profile.Data].[Publication.ISI.PubGeneral] g
                  WHERE     p.personid = @UserID
                            AND m.mpid = p.mpid
                            AND p.mpid IS NOT NULL
                            AND p.pmid IS NULL
                            AND p.mpid LIKE 'ISI%'
                            AND p.mpid = d.mpid
                            AND d.recid = g.recid
                ) t
                OUTER APPLY ( SELECT DISTINCT
                                        pmid
                              FROM      [Search.Cache].APIQueryMatchedPublication c
                              WHERE     c.personid = @UserID
                                        AND c.keywordstring = @keyword
                                        AND c.pmid = t.pmid
                                        AND c.exactkeyword = ISNULL(@exactkeyword,
                                                              0)
                            ) c
        WHERE   CASE WHEN ISNULL(@Keyword, '') <> '' THEN c.pmid
                     ELSE ''
                END IS NOT NULL
        ORDER BY publication_dt DESC
 	
    END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [Profile.Data].[Publication.GetPersonPublications3](@UserID INT,@UserID2 INT, @Keyword Varchar(2000), @ExactKeyword BIT, @Pubs XML OUTPUT)
 as
BEGIN
DECLARE  @encode_html INT
declare  @dash_url varchar(max) 
select @dash_url = ISNULL('http://dash.harvard.edu/handle/1/','')
SELECT @encode_html = 0; 
 

	 SELECT 
						category																																									"Publication/@CustomCategory" ,
					  CAST(pubid AS VARCHAR(50))																																"Publication/PublicationID",
						PUBLICATIONS   																																								"Publication/PublicationReference",
						t.pmid																	 																									"Publication/PublicationSourceList/PublicationSource/@ID",
					  CASE WHEN frompubmed=1 THEN 'http://www.ncbi.nlm.nih.gov/pubmed/'+CAST(ISNULL(t.pmid,'')AS VARCHAR(20))ELSE URL END"Publication/PublicationSourceList/PublicationSource/@URL",
						 'true'																																											"Publication/PublicationSourceList/PublicationSource/@Primary",
					  sourcename    															"Publication/PublicationSourceList/PublicationSource/@Name" ,
						 null																	 "Publication/PublicationDetails" 
																		 
					 FROM (SELECT  DISTINCT 
												 p.pmid,
												 NULL                                              AS mpid,
												 [Profile.Cache].[fnPublication.Pubmed.General2Reference]	(p.pmid ,ArticleDay,ArticleMonth,ArticleYear,ArticleTitle,Authors,AuthorListCompleteYN,Issue,JournalDay,JournalMonth,JournalYear,MedlineDate,MedlinePgn,MedlineTA,Volume,0) AS publications,
												 1                                                 AS frompubmed,
												 [Profile.Data].[fnPublication.Pubmed.GetPubDate]( MedlineDate,JournalYear,JournalMonth,JournalDay,ArticleYear,ArticleMonth,ArticleDay)                                           AS publication_dt,
												 i.pubid,
												 NULL                                              category,
												 NULL                                              url,
												 'PubMed'										   sourcename
									 FROM  [Profile.Data].[Publication.Person.Include] i    
									 JOIN [Profile.Data].[Publication.Person.Include] i2 ON i2.PMID = i.PMID AND i2.PersonID = @userid2
									 JOIN [Profile.Data].[Publication.PubMed.General] p ON i.pmid = p.pmid
									WHERE  i.personid = @UserID
									  AND p.pmid IS NOT NULL
								 UNION ALL
								 SELECT  DISTINCT 
												 m.pmid,
												 m.mpid,
												 --dbo.fn_GetPubli ' cations			,
												 (SELECT authors + 
																(CASE 
																	WHEN url < > ''
 
																		 AND article <> ''
																			 AND pub <> '' THEN url + article + '</a>. ' + pub + '. '
																	WHEN url <> ''
																			 AND article <> '' THEN url + article + '</a>. '
																	WHEN url <> ''
																			 AND pub <> '' THEN url + pub + '</a>. '
																	WHEN article <> ''
																			 AND pub <> '' THEN article + '. ' + pub + '. '
																	WHEN article <> '' THEN article + '. '
																	WHEN pub <> '' THEN pub + '. '
																	ELSE ''
																END) + 
																y + 
															 (CASE 
																	 WHEN y <> ''
																				AND vip <> '' THEN '; '
																	 ELSE ''
																END) + 
																vip + 
																(CASE 
																	WHEN y <> ''
																				OR vip <> '' THEN '.'
																	ELSE ''
																END)
													FROM (SELECT url,
																			 (CASE 
																					WHEN authors = '' THEN ''
																					WHEN RIGHT(authors,1) = '.' THEN LEFT(authors,LEN(authors) - 1)
																					ELSE authors
																				END) authors,
																			 (CASE 
																					WHEN article = '' THEN ''
																					WHEN RIGHT(article,1) = '.' THEN LEFT(article,LEN(article) - 1)
																					ELSE article
																				END) article,
																			 (CASE 
																					WHEN pub = '' THEN ''
																					WHEN RIGHT(pub,1) = '.' THEN LEFT(pub,LEN(pub) - 1)
																					ELSE pub
																				END) pub,
																			 y,
																			 vip,
																			 frompubmed,
																			 publicationdt
														     FROM (SELECT (CASE 
																									WHEN RTRIM(LTRIM(COALESCE(authors,''))) = '' THEN ''
																									WHEN RIGHT(COALESCE(authors,''),1) = '.' THEN COALESCE(authors,'') + ' '
																									ELSE COALESCE(authors,'') + '. '
																								END) authors,
																							 (CASE 
																									WHEN COALESCE(url,'') <> ''
																											 AND LEFT(COALESCE(url,''),4) = 'http' THEN '<a href="' + url + '" target="_blank">'
																									WHEN COALESCE(url,'') <> '' THEN '<a href="http://' + url + '" target="_blank">'
																									ELSE ''
																								END) url,
																							 LTRIM(RTRIM(COALESCE(articletitle,'')))     article,
																							 LTRIM(RTRIM(COALESCE(pubtitle,'')))         pub,
																							 (CASE 
																									WHEN publicationdt > '1/1/1901' THEN CONVERT(VARCHAR(50),YEAR(publicationdt))
																									ELSE ''
																								END) y,
																							 COALESCE(volnum,'') + 
																							(CASE 
																									WHEN COALESCE(issuepub,'') <> '' THEN '(' + issuepub + ')'
																									ELSE ''
																								END) +	
																							(CASE 
																								WHEN (COALESCE(paginationpub,'') <> '') AND (COALESCE(volnum,'') + COALESCE(issuepub,'') <> '') THEN ':'
																								ELSE ''
																						  END) + 
																							COALESCE(paginationpub,'') vip,
																							0                                           AS frompubmed,
																							publicationdt
																			FROM		[Profile.Data].[Publication.MyPub.General] m2
																	   WHERE		m2.mpid = m.mpid) t) 
																 t) AS publications,
																 0,
																 publicationdt,
																 i.pubid,
																 hmspubcategory,
																 url,
																'Custom'										   sourcename
									  FROM [Profile.Data].[Publication.MyPub.General] m
								    JOIN [Profile.Data].[Publication.Person.Include] i  	 ON i.mpid = m.mpid
								    JOIN [Profile.Data].[Publication.Person.Include] i2  	 ON i2.mpid = i.mpid AND i2.PersonID = @userid2
								   WHERE m.personid = @UserID	
								     AND i.mpid IS NOT NULL
		 						
anD 
i.mpid NOT LIKE 'DASH%'
								     AND i.mpid NOT LIKE 'ISI%'
								     AND i.pmid IS NULL 
									UNION ALL 
									SELECT		null as pmid, 
										p.mpid,
										g.BibliographicCitation publications, 
										0 as FromPubMed, 
										m.publicationdt,
										pubid,
										m.hmspubcategory,
										@dash_url+cast(g.dashid as varchar(10)) url,
										'DASH' sourcename
									FROM	[Profile.Data].[Publication.MyPub.General] m, [Profile.Data].[Publication.Person.Include] p, [Profile.Data].[Publication.DSpace.MPID] d, [Profile.Data].[Publication.DSpace.PubGeneral] g
									WHERE	p.personid = @UserID
										and m.mpid = p.mpid
										and p.mpid is not null and p.pmid is null
										and p.mpid like 'DASH%' 
										and p.mpid = d.mpid and d.dashid = g.dashid
									UNION ALL
									SELECT 
										null as pmid, 
										p.mpid,
										(g.authors + '. ' 
										+ g.itemtitle + (case when right(g.itemtitle,1) not in ('.','?','!') then '. ' else ' ' end) 
										+ coalesce(g.sourceabbrev, g.sourcetitle) 
										+ '. ' + g.bibid + '.')
										publications,
										0 as FromPubMed, 
										m.publicationdt,
										pubid,
										m.hmspubcategory,
										'http://dx.doi.org/' + doi url,
										'DOI' sourcename
									FROM [Profile.Data].[Publication.MyPub.General] m,[Profile.Data].[Publication.Person.Include] p, [Profile.Data].[Publication.ISI.MPID] d, [Profile.Data].[Publication.ISI.PubGeneral] g
									where p.personid = @UserID
										and m.mpid = p.mpid
										and p.mpid is not null and p.pmid is null
										and p.mpid like 'ISI%' 
										and p.mpid = d.mpid and d.recid = g.recid
		 			     
								     ) t 
OUTER APPLY (SELECT DISTINCT pmid 
			  from [Search.Cache].APIQueryMatchedPublication c where  c.personid=@UserID AND c.keywordstring = @keyword AND c.pmid=t.pmid and c.exactkeyword = ISNULL(@exactkeyword,0)) c 								
where CASE WHEN ISNULL(@Keyword,'')<>''  THEN c.pmid ELSE '' END IS NOT NULL 									
ORDER BY publication_dt DESC
 	
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [Profile.Data].[Publication.GetPersonPublications2](@UserID INT,@Keyword Varchar(2000), @ExactKeyword BIT, @Pubs XML OUTPUT)
 as
BEGIN
DECLARE  @encode_html INT
declare  @dash_url varchar(max) 
select @dash_url = ISNULL('http://dash.harvard.edu/handle/1/','')
SELECT @encode_html = 0; 
 
SELECT @Pubs = (
	 SELECT 
						category																																									"Publication/@CustomCategory" ,
					  CAST(pubid AS VARCHAR(50))																																"Publication/PublicationID",
						PUBLICATIONS   																																								"Publication/PublicationReference",
						t.pmid																	 																									"Publication/PublicationSourceList/PublicationSource/@ID",
					  CASE WHEN frompubmed=1 THEN 'http://www.ncbi.nlm.nih.gov/pubmed/'+CAST(ISNULL(t.pmid,'')AS VARCHAR(20))ELSE URL END"Publication/PublicationSourceList/PublicationSource/@URL",
						 'true'																																											"Publication/PublicationSourceList/PublicationSource/@Primary",
					  sourcename    															"Publication/PublicationSourceList/PublicationSource/@Name" ,
						 null																																											"Publication/PublicationDetails" ,
																		 (
																				SELECT SearchPhrase "@SearchPhrase",
																							 (
																								SELECT meshheader "@PublicationPhrase", nodeid "@EntityID",
																											 (
																												SELECT	 CASE MAX(c3.SearchWeight)
																																			WHEN 1 THEN 'Exact match' 
																																			ELSE 'Partial match or synonym'
																																 END																													"SearchWeight/@SearchWeightText",
																																 CAST(MAX(c3.SearchWeight)AS VARCHAR)													"SearchWeight", 
																																 CAST(MAX(uniquenessweight)AS VARCHAR)												"UniquenessWeight" ,
																																 CASE MAX(ROUND(topicweight,4))	
																																		 WHEN 1 THEN 'MeSH major topic'
																																	  	 WHEN .25 THEN 'MeSH minor topic'
																																 END																													"TopicWeight/@TopicWeightText",
																																 CAST(MAX(topicweight)AS VARCHAR)															"TopicWeight" ,
																																 CASE  CONVERT(DEC(3,2),MAX(ROUND(authorweight,4)))
																																				WHEN 1 THEN 'First or Senior Author'
																																				WHEN .5 THEN 'Unknown Position'
																																				WHEN .25 THEN 'Middle Author'
																																 END																													"AuthorWeight/@AuthorWeightText",
																																 CAST(MAX(authorweight)AS VARCHAR)														"AuthorWeight",
								 																								 'Published In '+CAST(YEAR(publication_dt)AS VARCHAR(4))							"YearWeight/@YearWeightText",
																																 CAST(MAX(yearweight )	AS VARCHAR)														"YearWeight" , 
																																 CAST(MAX(OverallWeight)*MAX(c3.SearchWeight)AS VARCHAR)			"OverallWeight"
																													FROM [Search.Cache].APIQueryMatchedPublication c3
																												 WHERE c3.pmid = t.pmid
																													 AND c3.personid = @UserID
																													 AND c3.meshheader = c2.meshheader
																													 AND c3.exactkeyword = ISNULL(@exactkeyword,0)
																													 --AND c3.searchprhase = c2.searchphrase
																											 FOR XML PATH('PhraseMeasurements'),TYPE
																												)
																										FROM [Search.Cache].APIQueryMatchedPublication c2 
																					          --JOIN [ER.].Entity e ON e.EntityType = 'Concept' AND e.EntityName = c2.MeshHeader
																					          JOIN [RDF.].Node e ON e.ValueHash = [RDF.].fnValueHash(null,null,c2.MeshHeader)
																								 WHERE	KeywordString = @Keyword
																									 AND c2.pmid=t.pmid
																									 And C2.personid=@UserID
																									 and c2.searchphrase = c1.searchphrase
																									 and c2.exactkeyword = ISNULL(@exactkeyword,0)
																								 GROUP BY meshheader,nodeid
																							 FOR XML PATH('PublicationPhraseDetail'),ROOT('PublicationPhraseDetailList'), TYPE
																							 )
																				  FROM [Search.Cache].APIQueryMatchedPublication c1 
																				 WHERE KeywordString = @Keyword
																					 AND c1.pmid=t.pmid
																					 And C1.personid=@UserID
																					 and c1.exactkeyword = ISNULL(@exactkeyword,0)
																				 GROUP BY SearchPhrase
																			 FOR XML PATH('PublicationMatchDetail'),TYPE
 
																		 ) AS "Publication/PublicationMatchDetailList"
					 FROM (SELECT  DISTINCT 
												 p.pmid,
												 NULL                                              AS mpid,
												 [Profile.Cache].[fnPublication.Pubmed.General2Reference]	(p.pmid ,ArticleDay,ArticleMonth,ArticleYear,ArticleTitle,Authors,AuthorListCompleteYN,Issue,JournalDay,JournalMonth,JournalYear,MedlineDate,MedlinePgn,MedlineTA,Volume,0) AS publications,
												 1                                                 AS frompubmed,
												 [Profile.Data].[fnPublication.Pubmed.GetPubDate]( MedlineDate,JournalYear,JournalMonth,JournalDay,ArticleYear,ArticleMonth,ArticleDay)                                           AS publication_dt,
												 pubid,
												 NULL                                              category,
												 NULL                                              url,
												 'PubMed'										   sourcename
									 FROM  [Profile.Data].[Publication.Person.Include] i    
									 JOIN [Profile.Data].[Publication.PubMed.General] p ON i.pmid = p.pmid
									WHERE  i.personid = @UserID
									  AND p.pmid IS NOT NULL
								 UNION ALL
								 SELECT  DISTINCT 
												 m.pmid,
												 m.mpid,
												 --dbo.fn_GetPubli ' cations			,
												 (SELECT authors + 
																(CASE 
																	WHEN url < > ''
 
																		 AND article <> ''
																			 AND pub <> '' THEN url + article + '</a>. ' + pub + '. '
																	WHEN url <> ''
																			 AND article <> '' THEN url + article + '</a>. '
																	WHEN url <> ''
																			 AND pub <> '' THEN url + pub + '</a>. '
																	WHEN article <> ''
																			 AND pub <> '' THEN article + '. ' + pub + '. '
																	WHEN article <> '' THEN article + '. '
																	WHEN pub <> '' THEN pub + '. '
																	ELSE ''
																END) + 
																y + 
															 (CASE 
																	 WHEN y <> ''
																				AND vip <> '' THEN '; '
																	 ELSE ''
																END) + 
																vip + 
																(CASE 
																	WHEN y <> ''
																				OR vip <> '' THEN '.'
																	ELSE ''
																END)
													FROM (SELECT url,
																			 (CASE 
																					WHEN authors = '' THEN ''
																					WHEN RIGHT(authors,1) = '.' THEN LEFT(authors,LEN(authors) - 1)
																					ELSE authors
																				END) authors,
																			 (CASE 
																					WHEN article = '' THEN ''
																					WHEN RIGHT(article,1) = '.' THEN LEFT(article,LEN(article) - 1)
																					ELSE article
																				END) article,
																			 (CASE 
																					WHEN pub = '' THEN ''
																					WHEN RIGHT(pub,1) = '.' THEN LEFT(pub,LEN(pub) - 1)
																					ELSE pub
																				END) pub,
																			 y,
																			 vip,
																			 frompubmed,
																			 publicationdt
														     FROM (SELECT (CASE 
																									WHEN RTRIM(LTRIM(COALESCE(authors,''))) = '' THEN ''
																									WHEN RIGHT(COALESCE(authors,''),1) = '.' THEN COALESCE(authors,'') + ' '
																									ELSE COALESCE(authors,'') + '. '
																								END) authors,
																							 (CASE 
																									WHEN COALESCE(url,'') <> ''
																											 AND LEFT(COALESCE(url,''),4) = 'http' THEN '<a href="' + url + '" target="_blank">'
																									WHEN COALESCE(url,'') <> '' THEN '<a href="http://' + url + '" target="_blank">'
																									ELSE ''
																								END) url,
																							 LTRIM(RTRIM(COALESCE(articletitle,'')))     article,
																							 LTRIM(RTRIM(COALESCE(pubtitle,'')))         pub,
																							 (CASE 
																									WHEN publicationdt > '1/1/1901' THEN CONVERT(VARCHAR(50),YEAR(publicationdt))
																									ELSE ''
																								END) y,
																							 COALESCE(volnum,'') + 
																							(CASE 
																									WHEN COALESCE(issuepub,'') <> '' THEN '(' + issuepub + ')'
																									ELSE ''
																								END) +	
																							(CASE 
																								WHEN (COALESCE(paginationpub,'') <> '') AND (COALESCE(volnum,'') + COALESCE(issuepub,'') <> '') THEN ':'
																								ELSE ''
																						  END) + 
																							COALESCE(paginationpub,'') vip,
																							0                                           AS frompubmed,
																							publicationdt
																			FROM		[Profile.Data].[Publication.MyPub.General] m2
																	   WHERE		m2.mpid = m.mpid) t) 
																 t) AS publications,
																 0,
																 publicationdt,
																 pubid,
																 hmspubcategory,
																 url,
																'Custom'										   sourcename
									  FROM [Profile.Data].[Publication.MyPub.General] m
								    JOIN [Profile.Data].[Publication.Person.Include] i  	 ON i.mpid = m.mpid
								   WHERE m.personid = @UserID	
								     AND i.mpid IS NOT NULL
		 						
anD 
i.mpid NOT LIKE 'DASH%'
								     AND i.mpid NOT LIKE 'ISI%'
								     AND i.pmid IS NULL 
									UNION ALL 
									SELECT		null as pmid, 
										p.mpid,
										g.BibliographicCitation publications, 
										0 as FromPubMed, 
										m.publicationdt,
										pubid,
										m.hmspubcategory,
										@dash_url+cast(g.dashid as varchar(10)) url,
										'DASH' sourcename
									FROM	[Profile.Data].[Publication.MyPub.General] m, [Profile.Data].[Publication.Person.Include] p, [Profile.Data].[Publication.DSpace.MPID] d, [Profile.Data].[Publication.DSpace.PubGeneral] g
									WHERE	p.personid = @UserID
										and m.mpid = p.mpid
										and p.mpid is not null and p.pmid is null
										and p.mpid like 'DASH%' 
										and p.mpid = d.mpid and d.dashid = g.dashid
									UNION ALL
									SELECT 
										null as pmid, 
										p.mpid,
										(g.authors + '. ' 
										+ g.itemtitle + (case when right(g.itemtitle,1) not in ('.','?','!') then '. ' else ' ' end) 
										+ coalesce(g.sourceabbrev, g.sourcetitle) 
										+ '. ' + g.bibid + '.')
										publications,
										0 as FromPubMed, 
										m.publicationdt,
										pubid,
										m.hmspubcategory,
										'http://dx.doi.org/' + doi url,
										'DOI' sourcename
									FROM [Profile.Data].[Publication.MyPub.General] m,[Profile.Data].[Publication.Person.Include] p, [Profile.Data].[Publication.ISI.MPID] d, [Profile.Data].[Publication.ISI.PubGeneral] g
									where p.personid = @UserID
										and m.mpid = p.mpid
										and p.mpid is not null and p.pmid is null
										and p.mpid like 'ISI%' 
										and p.mpid = d.mpid and d.recid = g.recid
		 			     
								     ) t 
OUTER APPLY (SELECT DISTINCT pmid 
			  from [Search.Cache].APIQueryMatchedPublication c where  c.personid=@UserID AND c.keywordstring = @keyword AND c.pmid=t.pmid and c.exactkeyword = ISNULL(@exactkeyword,0)) c 								
where CASE WHEN ISNULL(@Keyword,'')<>''  THEN c.pmid ELSE '' END IS NOT NULL 									
ORDER BY publication_dt DESC
 	FOR  XML PATH('')	,TYPE					
	)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [Profile.Data].[Publication.MyPub.UpdatePublication]
	@mpid nvarchar(50),
	@HMS_PUB_CATEGORY nvarchar(60) = '',
	@PUB_TITLE nvarchar(2000) = '',
	@ARTICLE_TITLE nvarchar(2000) = '',
	@CONF_EDITORS nvarchar(2000) = '',
	@CONF_LOC nvarchar(2000) = '',
	@EDITION nvarchar(30) = '',
	@PLACE_OF_PUB nvarchar(60) = '',
	@VOL_NUM nvarchar(30) = '',
	@PART_VOL_PUB nvarchar(15) = '',
	@ISSUE_PUB nvarchar(30) = '',
	@PAGINATION_PUB nvarchar(30) = '',
	@ADDITIONAL_INFO nvarchar(2000) = '',
	@PUBLISHER nvarchar(255) = '',
	@CONF_NM nvarchar(2000) = '',
	@CONF_DTS nvarchar(60) = '',
	@REPT_NUMBER nvarchar(35) = '',
	@CONTRACT_NUM nvarchar(35) = '',
	@DISS_UNIV_NM nvarchar(2000) = '',
	@NEWSPAPER_COL nvarchar(15) = '',
	@NEWSPAPER_SECT nvarchar(15) = '',
	@PUBLICATION_DT smalldatetime = '',
	@ABSTRACT varchar(max) = '',
	@AUTHORS varchar(max) = '',
	@URL varchar(1000) = '',
	@updated_by varchar(50) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	---------------------------------------------------
	-- Update the MyPub General information
	---------------------------------------------------
 
	UPDATE [Profile.Data].[Publication.MyPub.General] SET
		HmsPubCategory = @HMS_PUB_CATEGORY,
		PubTitle = @PUB_TITLE,
		ArticleTitle = @ARTICLE_TITLE,
		ConfEditors = @CONF_EDITORS,
		ConfLoc = @CONF_LOC,
		EDITION = @EDITION,
		PlaceOfPub = @PLACE_OF_PUB,
		VolNum = @VOL_NUM,
		PartVolPub = @PART_VOL_PUB,
		IssuePub = @ISSUE_PUB,
		PaginationPub = @PAGINATION_PUB,
		AdditionalInfo = @ADDITIONAL_INFO,
		PUBLISHER = @PUBLISHER,
		ConfNm = @CONF_NM,
		ConfDTs = @CONF_DTS,
		ReptNumber = @REPT_NUMBER,
		ContractNum = @CONTRACT_NUM,
		DissUnivNm = @DISS_UNIV_NM,
		NewspaperCol = @NEWSPAPER_COL,
		NewspaperSect = @NEWSPAPER_SECT,
		PublicationDT = @PUBLICATION_DT,
		ABSTRACT = @ABSTRACT,
		AUTHORS = @AUTHORS,
		URL = @URL,
		UpdatedBy = @updated_by,
		UpdatedDT = GetDate()
	WHERE mpid = @mpid
		and mpid not in (select mpid from [Profile.Data].[Publication.DSpace.MPID])
		and mpid not in (select mpid from [Profile.Data].[Publication.ISI.MPID])


	IF @@ROWCOUNT > 0
	BEGIN

		DECLARE @SQL NVARCHAR(MAX)

		---------------------------------------------------
		-- Update the InformationResource Entity
		---------------------------------------------------
	
		-- Get publication information
	
		CREATE TABLE #Publications
		(
			PMID INT NULL ,
			MPID NVARCHAR(50) NULL ,
			EntityDate DATETIME NULL ,
			Reference VARCHAR(MAX) NULL ,
			Source VARCHAR(25) NULL ,
			URL VARCHAR(1000) NULL ,
			Title VARCHAR(4000) NULL
		)

		INSERT  INTO #Publications
				( MPID ,
				  EntityDate ,
				  Reference ,
				  Source ,
				  URL ,
				  Title
				)
				SELECT  MPID ,
						EntityDate ,
						Reference = REPLACE(authors
											+ (CASE WHEN IsNull(article,'') <> '' THEN article + '. ' ELSE '' END)
											+ (CASE WHEN IsNull(pub,'') <> '' THEN pub + '. ' ELSE '' END)
											+ y
											+ CASE WHEN y <> ''
														AND vip <> '' THEN '; '
												   ELSE ''
											  END + vip
											+ CASE WHEN y <> ''
														OR vip <> '' THEN '.'
												   ELSE ''
											  END, CHAR(11), '') ,
						Source = 'Custom' ,
						URL = url,
						Title = left((case when IsNull(article,'')<>'' then article when IsNull(pub,'')<>'' then pub else 'Untitled Publication' end),4000)
				FROM    ( SELECT    MPID ,
									EntityDate ,
									url ,
									authors = CASE WHEN authors = '' THEN ''
												   WHEN RIGHT(authors, 1) = '.'
												   THEN LEFT(authors,
															 LEN(authors) - 1)
												   ELSE authors
											  END ,
									article = CASE WHEN article = '' THEN ''
												   WHEN RIGHT(article, 1) = '.'
												   THEN LEFT(article,
															 LEN(article) - 1)
												   ELSE article
											  END ,
									pub = CASE WHEN pub = '' THEN ''
											   WHEN RIGHT(pub, 1) = '.'
											   THEN LEFT(pub, LEN(pub) - 1)
											   ELSE pub
										  END ,
									y ,
									vip
						  FROM      ( SELECT    MPG.mpid ,
												EntityDate = MPG.publicationdt ,
												authors = CASE WHEN RTRIM(LTRIM(COALESCE(MPG.authors,
																  ''))) = ''
															   THEN ''
															   WHEN RIGHT(COALESCE(MPG.authors,
																  ''), 1) = '.'
																THEN  COALESCE(MPG.authors,
																  '') + ' '
															   ELSE COALESCE(MPG.authors,
																  '') + '. '
														  END ,
												url = CASE WHEN COALESCE(MPG.url,
																  '') <> ''
																AND LEFT(COALESCE(MPG.url,
																  ''), 4) = 'http'
														   THEN MPG.url
														   WHEN COALESCE(MPG.url,
																  '') <> ''
														   THEN 'http://' + MPG.url
														   ELSE ''
													  END ,
												article = LTRIM(RTRIM(COALESCE(MPG.articletitle,
																  ''))) ,
												pub = LTRIM(RTRIM(COALESCE(MPG.pubtitle,
																  ''))) ,
												y = CASE WHEN MPG.publicationdt > '1/1/1901'
														 THEN CONVERT(VARCHAR(50), YEAR(MPG.publicationdt))
														 ELSE ''
													END ,
												vip = COALESCE(MPG.volnum, '')
												+ CASE WHEN COALESCE(MPG.issuepub,
																  '') <> ''
													   THEN '(' + MPG.issuepub
															+ ')'
													   ELSE ''
												  END
												+ CASE WHEN ( COALESCE(MPG.paginationpub,
																  '') <> '' )
															AND ( COALESCE(MPG.volnum,
																  '')
																  + COALESCE(MPG.issuepub,
																  '') <> '' )
													   THEN ':'
													   ELSE ''
												  END + COALESCE(MPG.paginationpub,
																 '')
									  FROM      [Profile.Data].[Publication.MyPub.General] MPG
									  WHERE MPID = @mpid
									) T0
						) T0

		-- Update the entity record
		DECLARE @EntityID INT		
		UPDATE e
			SET e.EntityDate = p.EntityDate,
				e.Reference = p.Reference,
				e.Source = p.Source,
				e.URL = p.URL,
				@EntityID = e.EntityID
			FROM #publications p, [Profile.Data].[Publication.Entity.InformationResource] e
			WHERE p.MPID = e.MPID

		-- Update the RDF
		IF @EntityID IS NOT NULL
		BEGIN
			SELECT @SQL = ''
			SELECT @SQL = @SQL + 'EXEC [RDF.Stage].ProcessDataMap @DataMapID = '
								+CAST(DataMapID AS VARCHAR(50))
								+', @InternalIdIn = '
								+'''' + CAST(@EntityID AS VARCHAR(50)) + ''''
								+', @TurnOffIndexing=0, @SaveLog=0; '
				FROM [Ontology.].DataMap
				WHERE Class = 'http://vivoweb.org/ontology/core#InformationResource'
					AND NetworkProperty IS NULL
					AND Property IN (
										'http://www.w3.org/2000/01/rdf-schema#label',
										'http://profiles.catalyst.harvard.edu/ontology/prns#informationResourceReference',
										'http://profiles.catalyst.harvard.edu/ontology/prns#publicationDate',
										'http://profiles.catalyst.harvard.edu/ontology/prns#year'
									)
			EXEC sp_executesql @SQL
		END

		---------------------------------------------------
		-- Update the Authorship Entity
		---------------------------------------------------

		IF (@EntityID IS NOT NULL)
		BEGIN

			CREATE TABLE #Authorship
			(
				EntityDate DATETIME NULL ,
				authorRank INT NULL,
				numberOfAuthors INT NULL,
				authorNameAsListed VARCHAR(255) NULL,
				AuthorWeight FLOAT NULL,
				AuthorPosition VARCHAR(1) NULL,
				PubYear INT NULL ,
				YearWeight FLOAT NULL ,
				PersonID INT NULL ,
				InformationResourceID INT NULL,
				PMID INT NULL,
				IsActive BIT
			)

			INSERT INTO #Authorship (EntityDate, PersonID, InformationResourceID, PMID, IsActive)
				SELECT e.EntityDate, i.PersonID, e.EntityID, null PMID, 1 IsActive
					FROM [Profile.Data].[Publication.Entity.InformationResource] e,
						[Profile.Data].[Publication.Person.Include] i
					WHERE (e.MPID = i.MPID) and (e.MPID = @mpid) and (e.PMID is null)
		 
			UPDATE #authorship
				SET authorWeight = 0.5,
					authorPosition = 'U',
					PubYear = year(EntityDate),
					YearWeight = (case when EntityDate is null then 0.5
														when year(EntityDate) <= 1901 then 0.5
														else power(cast(0.5 as float),cast(datediff(d,EntityDate,GetDate()) as float)/365.25/10)
														end)

			-- Update the entity record
			SELECT @EntityID = NULL
			UPDATE e
				SET e.EntityDate = a.EntityDate,
					e.authorRank = a.authorRank,
					e.numberOfAuthors = a.numberOfAuthors,
					e.authorNameAsListed = a.authorNameAsListed,
					e.authorWeight = a.authorWeight,
					e.authorPosition = a.authorPosition,
					e.PubYear = a.PubYear,
					e.YearWeight = a.YearWeight,
					@EntityID = EntityID
				FROM #authorship a, [Profile.Data].[Publication.Entity.Authorship] e
				WHERE a.PersonID = e.PersonID and a.InformationResourceID = e.InformationResourceID

			-- Update the RDF
			/*
			IF @EntityID IS NOT NULL
			BEGIN
				SELECT @SQL = ''
				SELECT @SQL = @SQL + 'EXEC [RDF.Stage].ProcessDataMap @DataMapID = '
									+CAST(DataMapID AS VARCHAR(50))
									+', @InternalIdIn = '
									+'''' + CAST(@EntityID AS VARCHAR(50)) + ''''
									+', @TurnOffIndexing=0, @SaveLog=0; '
					FROM [Ontology.].DataMap
					WHERE Class = 'http://vivoweb.org/ontology/core#Authorship'
						AND NetworkProperty IS NULL
						AND Property IN (
											'http://www.w3.org/2000/01/rdf-schema#label',
											'http://profiles.catalyst.harvard.edu/ontology/prns#authorPosition',
											'http://profiles.catalyst.harvard.edu/ontology/prns#authorPositionWeight',
											'http://profiles.catalyst.harvard.edu/ontology/prns#authorshipWeight',
											'http://profiles.catalyst.harvard.edu/ontology/prns#numberOfAuthors',
											'http://vivoweb.org/ontology/core#authorRank'
										)
				EXEC sp_executesql @SQL
			END
			*/

		END

	END
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.PubMed.GetPersonInfoForDisambiguation] 
AS
BEGIN
SET nocount  ON;
 
 
DECLARE  @search XML,
		 @batchID UNIQUEIDENTIFIER,
		 @batchcount INT,
		 @threshold FLOAT
 
--SET Custom Threshold based on internal Institutional Logic, default is .98
SELECT @threshold = .98
 
SELECT @batchID=NEWID()
 
SELECT personid, 
			 (SELECT ISNULL(RTRIM(firstname),'')  "Name/First",
							 ISNULL(RTRIM(middlename),'') "Name/Middle",
							 ISNULL(RTRIM(p.lastname),'') "Name/Last",
							 ISNULL(RTRIM(suffix),'')     "Name/Suffix",
							 CASE 
								 WHEN a.n is not null or b.n is not null 
									    /*  Below is example of a custom piece of logic to alter the disambiguation by telling the disambiguation service
										to Require First Name usage in the algorithm for faculty who are lower in rank */
									or facultyranksort > 4 
									THEN 'true'
								 ELSE 'false'
							 END "RequireFirstName",
							 d.cnt													"LocalDuplicateNames",
							 @threshold												"MatchThreshold",
							 (SELECT DISTINCT ISNULL(LTRIM(ISNULL(emailaddress,p.emailaddr)),'') Email
									FROM [Profile.Data].[Person.Affiliation] pa
								 WHERE pa.personid = p.personid
								FOR XML PATH(''),TYPE) AS "EmailList",
							 (SELECT Affiliation
									FROM [Profile.Data].[Publication.PubMed.DisambiguationAffiliation]
								FOR XML PATH(''),TYPE) AS "AffiliationList",
							(SELECT PMID
							   FROM [Profile.Data].[Publication.Person.Add]
							  WHERE personid =p2.personid
						    FOR XML PATH(''),ROOT('PMIDAddList'),TYPE),
							(SELECT PMID
							   FROM [Profile.Data].[Publication.Person.Exclude]
							  WHERE personid =p2.personid
						    FOR XML PATH(''),ROOT('PMIDExcludeList'),TYPE)
					FROM [Profile.Data].Person p
						   LEFT JOIN ( 
								
									   --case 1
										SELECT LEFT(firstname,1)  f,
													 LEFT(middlename,1) m,
													 lastname,
													 COUNT(* )          n
										  FROM [Profile.Data].Person
										 GROUP BY LEFT(firstname,1),
													 LEFT(middlename,1),
													 lastname
										HAVING COUNT(* ) > 1
									)A ON a.lastname = p.lastname
									  and a.f=left(firstname,1)
									  and a.m = left(middlename,1)
					LEFT JOIN (			  
 
									--case 2
									SELECT LEFT(firstname,1) f,
												 lastname,
												 COUNT(* )         n
									  FROM [Profile.Data].Person
									 GROUP BY LEFT(firstname,1),
												 lastname
									HAVING COUNT(* ) > 1
												 AND SUM(CASE 
																	 WHEN middlename = '' THEN 1
																	 ELSE 0
																 END) > 0
																
								)B on b.f = left(firstname,1)
								  and b.lastname = p.lastname
					 LEFT JOIN ( SELECT [Utility.NLP].[fnNamePart1](firstname)F,
															lastname,
															COUNT(*)cnt
													 from [Profile.Data].Person 
												 GROUP BY [Utility.NLP].[fnNamePart1](firstname), 
															lastname
											)d on d.f = [Utility.NLP].[fnNamePart1](p2.firstname)
												and d.lastname = p2.lastname
 
										 
				 WHERE p.personid = p2.personid
				 
				FOR XML PATH(''),ROOT('FindPMIDs')) XML--as xml)
  INTO #batch
  FROM [Profile.Data].vwperson  p2
  
   
SELECT @batchcount=@@ROWCOUNT
 
SELECT @BatchID,@batchcount,*
  FROM #batch 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.PubMed.GetAllPMIDs] (@GetOnlyNewXML BIT=0 )
AS
BEGIN
	SET NOCOUNT ON;	
	

	BEGIN TRY
		IF @GetOnlyNewXML = 1 
		-- ONLY GET XML FOR NEW Publications
			BEGIN
				SELECT pmid
				  FROM [Profile.Data].[Publication.PubMed.Disambiguation]
				 WHERE pmid NOT IN(SELECT PMID FROM [Profile.Data].[Publication.PubMed.General])
			END
		ELSE 
		-- FULL REFRESH
			BEGIN
				SELECT pmid
				  FROM [Profile.Data].[Publication.PubMed.Disambiguation]
				 UNION   
				SELECT pmid
				  FROM [Profile.Data].[Publication.Person.Include]
			END 
		 
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK

		-- Raise an error with the details of the exception
		SELECT @ErrMsg = 'FAILED WITH : ' + ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH				
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.MyPub.AddPublication]
	@PersonID INT,
	@HMS_PUB_CATEGORY nvarchar(60) = '',
	@PUB_TITLE nvarchar(2000) = '',
	@ARTICLE_TITLE nvarchar(2000) = '',
	@CONF_EDITORS nvarchar(2000) = '',
	@CONF_LOC nvarchar(2000) = '',
	@EDITION nvarchar(30) = '',
	@PLACE_OF_PUB nvarchar(60) = '',
	@VOL_NUM nvarchar(30) = '',
	@PART_VOL_PUB nvarchar(15) = '',
	@ISSUE_PUB nvarchar(30) = '',
	@PAGINATION_PUB nvarchar(30) = '',
	@ADDITIONAL_INFO nvarchar(2000) = '',
	@PUBLISHER nvarchar(255) = '',
	@CONF_NM nvarchar(2000) = '',
	@CONF_DTS nvarchar(60) = '',
	@REPT_NUMBER nvarchar(35) = '',
	@CONTRACT_NUM nvarchar(35) = '',
	@DISS_UNIV_NM nvarchar(2000) = '',
	@NEWSPAPER_COL nvarchar(15) = '',
	@NEWSPAPER_SECT nvarchar(15) = '',
	@PUBLICATION_DT smalldatetime = '',
	@ABSTRACT varchar(max) = '',
	@AUTHORS varchar(max) = '',
	@URL varchar(1000) = '',
	@created_by varchar(50) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	 
	DECLARE @mpid nvarchar(50)
	SET @mpid = cast(NewID() as nvarchar(50))

	DECLARE @pubid nvarchar(50)
	SET @pubid = cast(NewID() as nvarchar(50))
	BEGIN TRY
	BEGIN TRANSACTION

		INSERT INTO [Profile.Data].[Publication.MyPub.General]
		        (
			mpid,
			PersonID,
			HmsPubCategory,
			PubTitle,
			ArticleTitle,
			ConfEditors,
			ConfLoc,
			EDITION,
			PlaceOfPub,
			VolNum,
			PartVolPub,
			IssuePub,
			PaginationPub,
			AdditionalInfo,
			Publisher,
			ConfNm,
			ConfDts,
			ReptNumber,
			ContractNum,
			DissUnivNM,
			NewspaperCol,
			NewspaperSect,
			PublicationDT,
			ABSTRACT,
			AUTHORS,
			URL,
			CreatedBy,
			CreatedDT,
			UpdatedBy,
			UpdatedDT
		) VALUES (
			@mpid,
			@PersonID,
			@HMS_PUB_CATEGORY,
			@PUB_TITLE,
			@ARTICLE_TITLE,
			@CONF_EDITORS,
			@CONF_LOC,
			@EDITION,
			@PLACE_OF_PUB,
			@VOL_NUM,
			@PART_VOL_PUB,
			@ISSUE_PUB,
			@PAGINATION_PUB,
			@ADDITIONAL_INFO,
			@PUBLISHER,
			@CONF_NM,
			@CONF_DTS,
			@REPT_NUMBER,
			@CONTRACT_NUM,
			@DISS_UNIV_NM,
	@NEWSPAPER_COL,
			@NEWSPAPER_SECT,
			@PUBLICATION_DT,
			@ABSTRACT,
			@AUTHORS,
			@URL,
			@created_by,
			GetDate(),
			@created_by,
			GetDate()
		)

		INSERT INTO [Profile.Data].[Publication.Person.Include]
		        ( PubID, PersonID,   MPID )
	 
			VALUES (@pubid, @PersonID, @mpid)

		INSERT INTO [Profile.Data].[Publication.Person.Add]
		        ( PubID, PersonID,   MPID )
			VALUES (@pubid, @PersonID, @mpid)

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=1
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure  [Profile.Data].[Publication.Pubmed.AddPubMedXML] ( 					 @pmid INT,
																			   @pubmedxml XML)
AS
BEGIN
	SET NOCOUNT ON;	
	 
	-- Parse Load Publication XML
	BEGIN TRY 	 
	
	IF ISNULL(CAST(@pubmedxml AS NVARCHAR(MAX)),'')='' 
		BEGIN
			DELETE FROM [Profile.Data].[Publication.PubMed.Disambiguation] WHERE pmid = @pmid AND NOT EXISTS (SELECT 1 FROM [Profile.Data].[Publication.Person.Add]  pa WHERE pa.pmid = @pmid)
			RETURN
		END
 
		BEGIN TRAN
			-- Remove existing pmid record
			DELETE FROM [Profile.Data].[Publication.PubMed.AllXML] WHERE pmid = @pmid
		
			-- Add Pub Med XML	
			INSERT INTO [Profile.Data].[Publication.PubMed.AllXML](pmid,X) VALUES(@pmid,CAST(@pubmedxml AS XML))		
			
			-- Parse Pub Med XML
			EXEC [Profile.Data].[Publication.Pubmed.ParsePubMedXML] 	 @pmid		
		 
		COMMIT
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg = '[Profile.Data].[Publication.Pubmed.AddPubMedXML] FAILED WITH : ' + ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH				
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procedure [Profile.Cache].[Publication.PubMed.UpdateAuthorPosition]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	  /* 
		drop table cache_pm_author_position
		create table dbo.cache_pm_author_position (
			PersonID int not null,
			pmid int not null,
			AuthorPosition char(1),
			AuthorWeight float,
			PubDate datetime,
			PubYear int,
			YearWeight float
		)
		alter table cache_pm_author_position add primary key (PersonID, pmid)
	*/
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	select distinct i.pmid, p.personid, p.lastname, p.firstname, '' middlename,
			left(p.lastname,1) ln, left(p.firstname,1) fn, left('',1) mn
		into #pmid_person_name
		from [Profile.Data].[Publication.Person.Include] i, [Profile.Cache].Person p
		where i.personid = p.personid and i.pmid is not null
	create unique clustered index idx_pu on #pmid_person_name(pmid,personid)
 
	select distinct pmid, personid, pmpubsauthorid
		into #authorid_personid
		from (
			select a.pmid, a.PmPubsAuthorID, p.personid, dense_rank() over (partition by a.pmid, p.personid order by 
				(case when a.lastname = p.lastname and (a.forename like p.firstname + left(p.middlename,1) + '%') then 1
					when a.lastname = p.lastname and (a.forename like p.firstname + '%') and len(p.firstname) > 1 then 2
					when a.lastname = p.lastname and a.initials = p.fn+p.mn then 3
					when a.lastname = p.lastname and left(a.initials,1) = p.fn then 4
					when a.lastname = p.lastname then 5
					else 6 end) ) k
			from [Profile.Data].[Publication.PubMed.Author] a inner join #pmid_person_name p 
				on a.pmid = p.pmid and a.validyn = 'Y' and left(a.lastname,1) = p.ln
		) t
		where k = 1
	create unique clustered index idx_ap on #authorid_personid(pmid, personid, pmpubsauthorid)
 
	select pmid, min(pmpubsauthorid) a, max(pmpubsauthorid) b, count(*) numberOfAuthors
		into #pmid_authorid_range
		from [Profile.Data].[Publication.PubMed.Author]
		group by pmid
	create unique clustered index idx_p on #pmid_authorid_range(pmid)
 
	select PersonID, pmid, a AuthorPosition, 
			(case when a in ('F','L','S') then 1.00
				when a in ('M') then 0.25
				else 0.50 end) AuthorWeight,
			pmpubsauthorid,
			cast(null as int) authorRank,
			cast(null as int) numberOfAuthors,
			cast(null as varchar(255)) authorNameAsListed
		into #cache_author_position
		from (
			select pmid, personid, a, pmpubsauthorid, row_number() over (partition by pmid, personid order by k, pmpubsauthorid) k
			from (
				select a.pmid, a.personid,
						(case when a.pmpubsauthorid = r.a then 'F'
							when a.pmpubsauthorid = r.b then 'L'
							else 'M'
							end) a,
						(case when a.pmpubsauthorid = r.a then 1
							when a.pmpubsauthorid = r.b then 2
							else 3
							end) k,
						a.pmpubsauthorid
					from #authorid_personid a, #pmid_authorid_range r
					where a.pmid = r.pmid and r.b <> r.a
				union all
				select p.pmid, p.personid, 'S' a, 0 k, r.a pmpubsauthorid
					from #pmid_person_name p, #pmid_authorid_range r
					where p.pmid = r.pmid and r.a = r.b
				union all
				select pmid, personid, 'U' a, 9 k, null pmpubsauthorid
					from #pmid_person_name
			) t
		) t
		where k = 1
	create clustered index idx_pmid on #cache_author_position(pmid)
	create nonclustered index idx_pmpubsauthorid on #cache_author_position(pmpubsauthorid)
 
	update a
		set a.numberOfAuthors = r.numberOfAuthors
		from #cache_author_position a, #pmid_authorid_range r
		where a.pmid = r.pmid
 
	select pmpubsauthorid, 
			isnull(LastName,'') 
			+ (case when isnull(LastName,'')<>'' and (isnull(ForeName,'')+isnull(Suffix,''))<>'' then ', ' else '' end)
			+ isnull(ForeName,'')
			+ (case when isnull(ForeName,'')<>'' and isnull(Suffix,'')<>'' then ' ' else '' end)
			+ isnull(Suffix,'') authorNameAsListed,
			row_number() over (partition by pmid order by pmpubsauthorid) authorRank
		into #pmpubsauthorid_authorRank
		from [Profile.Data].[Publication.PubMed.Author]
	create unique clustered index idx_p on #pmpubsauthorid_authorRank(pmpubsauthorid)
 
	update a
		set a.authorRank = r.authorRank, a.authorNameAsListed = r.authorNameAsListed
		from #cache_author_position a, #pmpubsauthorid_authorRank r
		where a.pmpubsauthorid = r.pmpubsauthorid
 
	select PersonID, a.pmid, AuthorPosition, AuthorWeight, g.PubDate, year(g.PubDate) PubYear,
			(case when g.PubDate = '1900-01-01 00:00:00.000' then 0.5
				else power(cast(0.5 as float),cast(datediff(d,g.PubDate,GetDate()) as float)/365.25/10)
				end) YearWeight,
			authorRank, numberOfAuthors, authorNameAsListed
		into #cache_pm_author_position
		from #cache_author_position a, [Profile.Data].[Publication.PubMed.General] g
		where a.pmid = g.pmid
	update #cache_pm_author_position
		set PubYear = Year(GetDate()), YearWeight = 1
		where YearWeight > 1
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Publication.PubMed.AuthorPosition]
			INSERT INTO [Profile.Cache].[Publication.PubMed.AuthorPosition] (PersonID, pmid, AuthorPosition, AuthorWeight, PubDate, PubYear, YearWeight, authorRank, numberOfAuthors, authorNameAsListed)
				SELECT PersonID, pmid, AuthorPosition, AuthorWeight, PubDate, PubYear, YearWeight, authorRank, numberOfAuthors, authorNameAsListed
				FROM #cache_pm_author_position
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Concept.Mesh.GetPublications]
	@NodeID BIGINT,
	@ListType varchar(50) = NULL,
	@LastDate datetime = '1/1/1900'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DescriptorName NVARCHAR(255)
 	SELECT @DescriptorName = d.DescriptorName
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n,
			[Profile.Data].[Concept.Mesh.Descriptor] d
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
			AND m.InternalID = d.DescriptorUI

	if @ListType = 'Newest' or @ListType IS NULL
	begin

		select *
		from (
			select top 10 g.pmid, g.pubdate, [Profile.Cache].[fnPublication.Pubmed.General2Reference](g.pmid, ArticleDay, ArticleMonth, ArticleYear, ArticleTitle, Authors, AuthorListCompleteYN, Issue, JournalDay, JournalMonth, JournalYear, MedlineDate, MedlinePgn, MedlineTA, Volume, 0) reference
			from [Profile.Data].[Publication.PubMed.General] g, (
				select m.pmid, max(MajorTopicYN) MajorTopicYN
				from [Profile.Data].[Publication.Person.Include] i, [Profile.Data].[Publication.PubMed.Mesh] m
				where i.pmid = m.pmid and i.pmid is not null and m.descriptorname = @DescriptorName
				group by m.pmid
			) m
			where g.pmid = m.pmid
			order by g.pubdate desc
		) t
		order by pubdate desc

	end

	if @ListType = 'Oldest' or @ListType IS NULL
	begin

		select *
		from (
			select top 10 g.pmid, g.pubdate, [Profile.Cache].[fnPublication.Pubmed.General2Reference](g.pmid, ArticleDay, ArticleMonth, ArticleYear, ArticleTitle, Authors, AuthorListCompleteYN, Issue, JournalDay, JournalMonth, JournalYear, MedlineDate, MedlinePgn, MedlineTA, Volume, 0) reference
			from [Profile.Data].[Publication.PubMed.General] g, (
				select m.pmid, max(MajorTopicYN) MajorTopicYN
				from [Profile.Data].[Publication.Person.Include] i, [Profile.Data].[Publication.PubMed.Mesh] m
				where i.pmid = m.pmid and i.pmid is not null and m.descriptorname = @DescriptorName
				group by m.pmid
			) m
			where g.pmid = m.pmid --and g.pubdate < @LastDate
			order by g.pubdate
		) t
		order by pubdate

	end


	if @ListType = 'Cited' or @ListType IS NULL
	begin

		;with pm_citation_count as (
			select pmid, 0 n
			from [Profile.Data].[Publication.PubMed.General]
		)
		select *
		from (
			select top 10 g.pmid, g.pubdate, c.n, [Profile.Cache].[fnPublication.Pubmed.General2Reference](g.pmid, ArticleDay, ArticleMonth, ArticleYear, ArticleTitle, Authors, AuthorListCompleteYN, Issue, JournalDay, JournalMonth, JournalYear, MedlineDate, MedlinePgn, MedlineTA, Volume, 0) reference
			from [Profile.Data].[Publication.PubMed.General] g, (
				select m.pmid, max(MajorTopicYN) MajorTopicYN
				from [Profile.Data].[Publication.Person.Include] i, [Profile.Data].[Publication.PubMed.Mesh] m
				where i.pmid = m.pmid and i.pmid is not null and m.descriptorname = @DescriptorName
				group by m.pmid
			) m, pm_citation_count c
			where g.pmid = m.pmid and m.pmid = c.pmid
			order by c.n desc, g.pubdate desc
		) t
		order by n desc, pubdate desc

	end

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdateJournal]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
 
	   /* 
 
		CREATE TABLE [Profile.Data].[Publication.Entity.InformationResource]
		(
			EntityID INT PRIMARY KEY CLUSTERED IDENTITY(1, 1) ,
			PMID INT NULL ,
			MPID NVARCHAR(50) NULL ,
			EntityName VARCHAR(4000) NULL ,
			EntityDate DATETIME NULL ,
			Reference VARCHAR(MAX) NULL ,
			Source VARCHAR(25) NULL ,
			URL VARCHAR(1000) NULL ,
			SummaryXML XML NULL ,
			IsActive BIT
		)
		CREATE NONCLUSTERED INDEX idx_pmid on [Profile.Data].[Publication.Entity.InformationResource](pmid)
		CREATE NONCLUSTERED INDEX idx_mpid on [Profile.Data].[Publication.Entity.InformationResource](mpid)
 
		CREATE TABLE [Profile.Data].[Publication.Entity.Authorship]
		(
			EntityID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
			EntityName VARCHAR(4000) NULL ,
			EntityDate DATETIME NULL ,
			authorRank INT NULL,
			numberOfAuthors INT NULL,
			authorNameAsListed VARCHAR(255) NULL,
			authorWeight FLOAT NULL,
			authorPosition VARCHAR(1) NULL,
			PersonID INT NULL ,
			InformationResourceID INT NULL,
			IsActive BIT
		)
		CREATE NONCLUSTERED INDEX idx_PIR on [Profile.Data].[Publication.Entity.Authorship](PersonID,InformationResourceID)
 
	*/
 
 
 
	-- *******************************************************************
	-- *******************************************************************
	-- Update InformationResource entities
	-- *******************************************************************
	-- *******************************************************************
 
 
 
	CREATE TABLE #Publications
	(
		PMID INT NULL ,
		MPID NVARCHAR(50) NULL ,
		EntityDate DATETIME NULL ,
		Reference VARCHAR(MAX) NULL ,
		Source VARCHAR(25) NULL ,
		URL VARCHAR(1000) NULL
	)
 
	-- Add PMIDs to the publications temp table
	INSERT  INTO #Publications
            ( PMID ,
              EntityDate ,
              Reference ,
              Source ,
              URL
            )
            SELECT -- Get Pub Med pubs
                    PG.PMID ,
                    EntityDate = PG.PubDate,
                    Reference = REPLACE([Profile.Cache].[fnPublication.Pubmed.General2Reference](PG.PMID,
                                                              PG.ArticleDay,
                                                              PG.ArticleMonth,
                                                              PG.ArticleYear,
                                                              PG.ArticleTitle,
                                                              PG.Authors,
                                                              PG.AuthorListCompleteYN,
                                                              PG.Issue,
                                                              PG.JournalDay,
                                                              PG.JournalMonth,
                                                              PG.JournalYear,
                                                              PG.MedlineDate,
                                                              PG.MedlinePgn,
                                                              PG.MedlineTA,
                                                              PG.Volume, 0),
                                        CHAR(11), '') ,
                    Source = 'PubMed',
                    URL = 'http://www.ncbi.nlm.nih.gov/pubmed/' + CAST(ISNULL(PG.pmid, '') AS VARCHAR(20))
            FROM    [Profile.Data].[Publication.PubMed.General] PG
			WHERE	PG.PMID IN (
						SELECT PMID 
						FROM [Profile.Data].[Publication.Person.Include]
						WHERE PMID IS NOT NULL )
 
	-- Add MPIDs to the publications temp table
	INSERT  INTO #Publications
            ( MPID ,
              EntityDate ,
        Reference,
   
Source ,
              URL
            )
            SELECT  MPID ,
                    EntityDate ,
                    Reference = REPLACE(authors
                                        + CASE WHEN url <> ''
                                                    AND article <> ''
                                                    AND pub <> ''
                                               THEN url + article + '</a>. '
                                                    + pub + '. '
                                               WHEN url <> ''
                                                    AND article <> ''
                                               THEN url + article + '</a>. '
                                               WHEN url <> ''
                                                    AND pub <> ''
                                               THEN url + pub + '</a>. '
                                               WHEN article <> ''
                                                    AND pub <> ''
                                               THEN article + '. ' + pub
                                                    + '. '
                                               WHEN article <> ''
                                               THEN article + '. '
                                               WHEN pub <> '' THEN pub + '. '
                                               ELSE ''
                                          END + y
                                        + CASE WHEN y <> ''
                                                    AND vip <> '' THEN '; '
                                               ELSE ''
                                          END + vip
                                        + CASE WHEN y <> ''
                                                    OR vip <> '' THEN '.'
                                               ELSE ''
                                          END, CHAR(11), '') ,
                    Source = 'Custom' ,
                    URL = url
            FROM    ( SELECT    MPID ,
                                EntityDate ,
                                url ,
                                authors = CASE WHEN authors = '' THEN ''
                                               WHEN RIGHT(authors, 1) = '.'
                                               THEN LEFT(authors,
                                                         LEN(authors) - 1)
                                               ELSE authors
                                          END ,
                                article = CASE WHEN article = '' THEN ''
                                               WHEN RIGHT(article, 1) = '.'
                                               THEN LEFT(article,
                                                         LEN(article) - 1)
                                               ELSE article
                                          END ,
                                pub = CASE WHEN pub = '' THEN ''
                                           WHEN RIGHT(pub, 1) = '.'
                                           THEN LEFT(pub, LEN(pub) - 1)
                                           ELSE pub
                                      END ,
                                y ,
                                vip
                      FROM      ( SELECT    MPG.mpid ,
                                            EntityDate = MPG.publicationdt ,
                                            authors = CASE WHEN RTRIM(LTRIM(COALESCE(MPG.authors,
                                                              ''))) = ''
                                                           THEN ''
                                                           WHEN RIGHT(COALESCE(MPG.authors,
                                                              ''), 1) = '.'
                                                            THEN  COALESCE(MPG.authors,
                                                              '') + ' '
                                                           ELSE COALESCE(MPG.authors,
                                                              '') + '. '
                                                      END ,
                                            url = CASE WHEN COALESCE(MPG.url,
                                                              '') <> ''
                                                            AND LEFT(COALESCE(MPG.url,
                                                              ''), 4) = 'http'
                                                       THEN '<a href="'
                                                            + MPG.url
                                                            + '" target="_blank">'
                                                       WHEN COALESCE(MPG.url,
                                                              '') <> ''
                                                       THEN '<a href="http://'
                                                            + MPG.url
                                                            + '" target="_blank">'
                                                       ELSE ''
                                                  END ,
                                            article = LTRIM(RTRIM(COALESCE(MPG.articletitle,
                                                              ''))) ,
                                            pub = LTRIM(RTRIM(COALESCE(MPG.pubtitle,
                                                              ''))) ,
                                            y = CASE WHEN MPG.publicationdt > '1/1/1901'
                                                     THEN CONVERT(VARCHAR(50), YEAR(MPG.publicationdt))
                                                     ELSE ''
                                                END ,
                                            vip = COALESCE(MPG.volnum, '')
                                            + CASE WHEN COALESCE(MPG.issuepub,
                                                              '') <> ''
                                                   THEN '(' + MPG.issuepub
                                                        + ')'
                                                   ELSE ''
                                              END
                                            + CASE WHEN ( COALESCE(MPG.paginationpub,
                                                              '') <> '' )
                                                        AND ( COALESCE(MPG.volnum,
                                                              '')
                                                              + COALESCE(MPG.issuepub,
                                                              '') <> '' )
                                                   THEN ':'
                                                   ELSE ''
                                              END + COALESCE(MPG.paginationpub,
                                                             '')
                                  FROM      [Profile.Data].[Publication.MyPub.General] MPG
                                  INNER JOIN [Profile.Data].[Publication.Person.Include] PL ON MPG.mpid = PL.mpid
                                                           AND PL.mpid NOT LIKE 'DASH%'
                                                           AND PL.mpid NOT LIKE 'ISI%'
                                                           AND PL.pmid IS NULL
                                ) T0
                    ) T0
 
	CREATE NONCLUSTERED INDEX idx_pmid on #publications(pmid)
	CREATE NONCLUSTERED INDEX idx_mpid on #publications(mpid)
 
	-- Update the Publication.Entity.InformationResource table
	UPDATE [Profile.Data].[Publication.Entity.InformationResource]
		SET IsActive = 0
	UPDATE e
		SET e.EntityDate = p.EntityDate,
			e.Reference = p.Reference,
			e.Source = p.Source,
			e.URL = p.URL,
			e.IsActive = 1
		FROM #publications p, [Profile.Data].[Publication.Entity.InformationResource] e
		WHERE p.PMID = e.PMID and p.PMID is not null
	UPDATE e
		SET e.EntityDate = p.EntityDate,
			e.Reference = p.Reference,
			e.Source = p.Source,
			e.URL = p.URL,
			e.IsActive = 1
		FROM #publications p, [Profile.Data].[Publication.Entity.InformationResource] e
		WHERE p.MPID = e.MPID and p.MPID is not NULL
			
	CREATE NONCLUSTERED INDEX pubidx ON #publications (pmid)
	CREATE NONCLUSTERED INDEX pubmpidx ON #publications (mpid)
	SELECT pmid INTO #pmid FROM [Profile.Data].[Publication.Entity.InformationResource] 
	SELECT mpid INTO #mpid FROM [Profile.Data].[Publication.Entity.InformationResource]  
	INSERT INTO [Profile.Data].[Publication.Entity.InformationResource] (
			PMID,
			MPID,
			EntityDate,
			Reference,
			Source,
			URL,
			IsActive
		)
		SELECT 	PMID,
				MPID,
				EntityDate,
				Reference,
				Source,
				URL,
				1 IsActive
		FROM #publications p
		--WHERE (PMID is not null and PMID not in (SELECT pmid FROM [Profile.Data].[Publication.Entity.InformationResource]))
		--	or (MPID is not null and MPID not in (SELECT mpid FROM [Profile.Data].[Publication.Entity.InformationResource]))
		WHERE (PMID is not null and NOT exists (SELECT pmid FROM #pmid a WHERE a.pmid = p.pmid))
			or (MPID is not null and NOT exists (SELECT mpid FROM #mpid b WHERE b.mpid = p.mpid))
	UPDATE [Profile.Data].[Publication.Entity.InformationResource]
		SET EntityName = 'Publication ' + CAST(EntityID as VARCHAR(50))
		WHERE EntityName is null
	UPDATE [Profile.Data].[Publication.Entity.InformationResource]
		SET PubYear = year(EntityDate),
			YearWeight = (case when EntityDate is null then 0.5
							when year(EntityDate) <= 1901 then 0.5
							else power(cast(0.5 as float),cast(datediff(d,EntityDate,GetDate()) as float)/365.25/10)
							end)
	UPDATE [Profile.Data].[Publication.Entity.InformationResource]
		SET	SummaryXML = (	select
							"Reference" = replace(Reference,char(0),''),
							"URL" = URL,
							"Source" = Source,
							"ID" = ISNULL(CONVERT(VARCHAR(40),pmid),mpid),
							"PMID" = CONVERT(VARCHAR(40),pmid),
							"PubYear" = PubYear,
							"YearWeight" = YearWeight
							FOR XML PATH (''), TYPE
						)
		WHERE IsActive = 1
 
 
	-- *******************************************************************
	-- *******************************************************************
	-- Update Authorship entities
	-- *******************************************************************
	-- *******************************************************************
 
 
	CREATE TABLE #Authorship
	(
		EntityDate DATETIME NULL ,
		authorRank INT NULL,
		numberOfAuthors INT NULL,
		authorNameAsListed VARCHAR(255) NULL,
		AuthorWeight FLOAT NULL,
		AuthorPosition VARCHAR(1) NULL,
		PubYear INT NULL ,
		YearWeight FLOAT NULL ,
		PersonID INT NULL ,
		InformationResourceID INT NULL,
		PMID INT NULL,
		IsActive BIT
	)
 
	INSERT INTO #Authorship (EntityDate, PersonID, InformationResourceID, PMID, IsActive)
		SELECT e.EntityDate, i.PersonID, e.EntityID, e.PMID, 1 IsActive
			FROM [Profile.Data].[Publication.Entity.InformationResource] e,
				[Profile.Data].[Publication.Person.Include] i
			WHERE e.PMID = i.PMID and e.PMID is not null
	INSERT INTO #Authorship (EntityDate, PersonID, InformationResourceID, PMID, IsActive)
		SELECT e.EntityDate, i.PersonID, e.EntityID, null PMID, 1 IsActive
			FROM [Profile.Data].[Publication.Entity.InformationResource] e,
				[Profile.Data].[Publication.Person.Include] i
			WHERE (e.MPID = i.MPID) and (e.MPID is not null) and (e.PMID is null)
	CREATE NONCLUSTERED INDEX idx_person_pmid ON #Authorship(PersonID, PMID)
	CREATE NONCLUSTERED INDEX idx_person_pub ON #Authorship(PersonID, InformationResourceID)
 
UPDATE a
		SET	a.authorRank=p.authorRank,
			a.numberOfAuthors=p.numberOfAuthors,
			a.authorNameAsListed=p.authorNameAsListed, 
			a.AuthorWeight=p.AuthorWeight, 
			a.AuthorPosition=p.AuthorPosition,
			a.PubYear=p.PubYear,
			a.YearWeight=p.YearWeight
		FROM #Authorship a, [Profile.Cache].[Publication.PubMed.AuthorPosition]  p
		WHERE a.PersonID = p.PersonID and a.PMID = p.PMID and a.PMID is not null
	UPDATE #authorship
		SET authorWeight = 0.5
		WHERE authorWeight IS NULL
	UPDATE #authorship
		SET authorPosition = 'U'
		WHERE authorPosition IS NULL
	UPDATE #authorship
		SET PubYear = year(EntityDate)
		WHERE PubYear IS NULL
	UPDATE #authorship
		SET	YearWeight = (case when EntityDate is null then 0.5
							when year(EntityDate) <= 1901 then 0.5
							else power(cast(0.5 as float),cast(datediff(d,EntityDate,GetDate()) as float)/365.25/10)
							end)
		WHERE YearWeight IS NULL
 
	-- Update the Publication.Authorship table
	UPDATE [Profile.Data].[Publication.Entity.Authorship]
		SET IsActive = 0
	UPDATE e
		SET e.EntityDate = a.EntityDate,
			e.authorRank = a.authorRank,
			e.numberOfAuthors = a.numberOfAuthors,
			e.authorNameAsListed = a.authorNameAsListed,
			e.authorWeight = a.authorWeight,
			e.authorPosition = a.authorPosition,
			e.PubYear = a.PubYear,
			e.YearWeight = a.YearWeight,
			e.IsActive = 1
		FROM #authorship a, [Profile.Data].[Publication.Entity.Authorship] e
		WHERE a.PersonID = e.PersonID and a.InformationResourceID = e.InformationResourceID
	INSERT INTO [Profile.Data].[Publication.Entity.Authorship] (
			EntityDate,
			authorRank,
			numberOfAuthors,
			authorNameAsListed,
			authorWeight,
			authorPosition,
			PubYear,
			YearWeight,
			PersonID,
			InformationResourceID,
			IsActive
		)
		SELECT 	EntityDate,
				authorRank,
				numberOfAuthors,
				authorNameAsListed,
				authorWeight,
				authorPosition,
				PubYear,
				YearWeight,
				PersonID,
				InformationResourceID,
				IsActive
		FROM #authorship a
		WHERE NOT EXISTS (
			SELECT *
			FROM [Profile.Data].[Publication.Entity.Authorship] e
			WHERE a.PersonID = e.PersonID and a.InformationResourceID = e.InformationResourceID
		)
	UPDATE [Profile.Data].[Publication.Entity.Authorship]
		SET EntityName = 'Authorship ' + CAST(EntityID as VARCHAR(50))
		WHERE EntityName is null
	UPDATE [Profile.Data].[Publication.Entity.Authorship]
		SET	SummaryXML = (	select
							"authorRank" = authorRank,
							"authorNameAsListed" = authorNameAsListed,
							"NumberOfAuthors" = numberOfAuthors,
							"AuthorPosition" = authorPosition,
							"AuthorWeight" = authorWeight,
							"PubYear" = PubYear,
							"YearWeight" = YearWeight,
							"ConnectionWeight" = isnull(authorWeight,0.5)*isnull(YearWeight,0.5)
							FOR XML PATH (''), TYPE
						)
		WHERE IsActive = 1
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdateCountTree]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	DECLARE @proc VARCHAR(200)
	SELECT @proc = OBJECT_NAME(@@PROCID)
	DECLARE @date DATETIME,@auditid UNIQUEIDENTIFIER, @rows int
	SELECT @date=GETDATE() 
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
 
	select m.meshheader,
			count(*) num_publications,
			count(distinct a.personid) num_faculty,
			cast(0 as float) weight,
			sum( (case when m.majortopicyn = 'Y' then 1 else 0.25 end) * a.authorweight * a.yearweight ) rawweight
		into #cache_mesh_count
		from [Profile.Cache].[Publication.PubMed.AuthorPosition] a, [Profile.Data].[vwPublication.Pubmed.Mesh.Descriptor] m
		where a.pmid = m.pmid
		group by m.meshheader
	update #cache_mesh_count set weight = 10/sqrt(100 + rawweight)
	create unique clustered index idx_m on #cache_mesh_count(meshheader)
 
 
	SELECT *
		INTO #m
		FROM (
			SELECT m.treenumber mesh_code,
				m.descriptorname meshheader,
				COALESCE(c.numpublications,0) num_publications,
				COALESCE(c.numfaculty,0) num_faculty,
				COALESCE(c.weight,0) weight
			FROM [Profile.Data].[Concept.Mesh.TreeTop] m
				LEFT JOIN [Profile.Cache].[Concept.Mesh.Count] c
				ON m.descriptorname = c.meshheader
		) t
	CREATE UNIQUE CLUSTERED INDEX idx_pk ON #m (mesh_code)
 
	SELECT *,
				 (SELECT SUM(num_publications)
						FROM #m n
					 WHERE n.mesh_code LIKE m.mesh_code + '%') tot_publications,
				 (SELECT SUM(weight)
						FROM #m n
					 WHERE n.mesh_code LIKE m.mesh_code + '%') tot_weight
		INTO #n
		FROM #m m
	CREATE UNIQUE CLUSTERED INDEX idx_pk ON #n (mesh_code)
 
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.Count]
			INSERT INTO [Profile.Cache].[Concept.Mesh.Count](meshheader, numpublications, numfaculty, weight, rawweight)
				SELECT meshheader, num_publications, num_faculty, weight, rawweight
				FROM #cache_mesh_count
			TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.Tree]
			INSERT INTO [Profile.Cache].[Concept.Mesh.Tree](meshcode, meshheader, numpublications, numfaculty, weight, totpublications, totweight)
				SELECT mesh_code, meshheader, num_publications, num_faculty, weight, tot_publications, tot_weight
				FROM #n
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName ='Concept.Mesh.UpdateCountTree',@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Framework.].[ChangeBaseURI]
	@oldBaseURI varchar(1000),
	@newBaseURI varchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
    /* 
 
	EXAMPLE:
 
	exec [Framework.].uspChangeBaseURI	@oldBaseURI = 'http://connects.catalyst.harvard.edu/profiles/profile/',
										@newBaseURI = 'http://dev.connects.catalyst.harvard.edu/profiles/profile/'
 
	*/
 
	UPDATE [Framework.].[Parameter]
		SET Value = @newBaseURI
		WHERE ParameterID = 'baseURI'
 
	UPDATE [RDF.].[Node]
		SET Value = @newBaseURI + substring(value,len(@oldBaseURI)+1,len(value)),
			ValueHash = [RDF.].[fnValueHash](Language,DataType,@newBaseURI + substring(value,len(@oldBaseURI)+1,len(value)))
		WHERE Value LIKE @oldBaseURI + '%'
 
	UPDATE m
		SET m.ValueHash = n.ValueHash
		FROM [RDF.Stage].InternalNodeMap m, [RDF.].[Node] n
		WHERE m.NodeID = n.NodeID
 
	EXEC [Search.Cache].[Public.UpdateCache]

	EXEC [Search.Cache].[Private.UpdateCache]

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.].[AddProperty]
	@OWL nvarchar(100),
	@PropertyURI varchar(400),
	@PropertyName varchar(max),
	@ObjectType bit,
	@PropertyGroupURI varchar(400) = null,
	@SortOrder int = null,
	@ClassURI varchar(400) = null,
	@NetworkPropertyURI varchar(400) = null,
	@IsDetail bit = null,
	@Limit int = null,
	@IncludeDescription bit = null,
	@IncludeNetwork bit = null,
	@SearchWeight float = null,
	@CustomDisplay bit = null,
	@CustomEdit bit = null,
	@ViewSecurityGroup bigint = null,
	@EditSecurityGroup bigint = null,
	@EditPermissionsSecurityGroup bigint = null,
	@EditExistingSecurityGroup bigint = null,
	@EditAddNewSecurityGroup bigint = null,
	@EditAddExistingSecurityGroup bigint = null,
	@EditDeleteSecurityGroup bigint = null,
	@MinCardinality int = null,
	@MaxCardinality int = null,
	@CustomEditModule xml = null,
	@ReSortClassProperty bit = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	---------------------------------------------------
	-- [Ontology.Import].[Triple]
	---------------------------------------------------

	DECLARE @LoadRDF BIT
	SELECT @LoadRDF = 0

	-- Get Graph
	DECLARE @Graph BIGINT
	SELECT @Graph = (SELECT Graph FROM [Ontology.Import].[OWL] WHERE Name = @OWL)

	-- Insert Type record
	IF NOT EXISTS (SELECT *
					FROM [Ontology.Import].[Triple]
					WHERE OWL = @OWL and Subject = @PropertyURI and Predicate = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
	BEGIN
		INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object)
			SELECT @OWL, @Graph, @PropertyURI,
				'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
				(CASE WHEN @ObjectType = 1 THEN 'http://www.w3.org/2002/07/owl#DatatypeProperty'
						ELSE 'http://www.w3.org/2002/07/owl#ObjectProperty' END)
		SELECT @LoadRDF = 1
	END
	
	-- Insert Label record
	IF NOT EXISTS (SELECT *
					FROM [Ontology.Import].[Triple]
					WHERE OWL = @OWL and Subject = @PropertyURI and Predicate = 'http://www.w3.org/2000/01/rdf-schema#label')
	BEGIN
		INSERT INTO [Ontology.Import].[Triple] (OWL, Graph, Subject, Predicate, Object)
			SELECT @OWL, @Graph, @PropertyURI,
				'http://www.w3.org/2000/01/rdf-schema#label',
				@PropertyName
		SELECT @LoadRDF = 1
	END

	-- Load RDF
	IF @LoadRDF = 1
	BEGIN
		EXEC [RDF.Stage].[LoadTriplesFromOntology] @OWL = @OWL, @Truncate = 1
		EXEC [RDF.Stage].[ProcessTriples]
	END
	
	---------------------------------------------------
	-- [Ontology.].[PropertyGroupProperty]
	---------------------------------------------------

	IF NOT EXISTS (SELECT * FROM [Ontology.].PropertyGroupProperty WHERE PropertyURI = @PropertyURI)
	BEGIN
	
		-- Validate the PropertyGroupURI
		SELECT @PropertyGroupURI = IsNull((SELECT TOP 1 PropertyGroupURI 
											FROM [Ontology.].PropertyGroup
											WHERE PropertyGroupURI = @PropertyGroupURI
												AND @PropertyGroupURI IS NOT NULL
											),'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview')
		
		-- Validate the SortOrder
		DECLARE @MaxSortOrder INT
		SELECT @MaxSortOrder = IsNull((SELECT MAX(SortOrder)
										FROM [Ontology.].PropertyGroupProperty
										WHERE PropertyGroupURI = @PropertyGroupURI),0)
		SELECT @SortOrder = (CASE WHEN @SortOrder IS NULL THEN @MaxSortOrder+1
									WHEN @SortOrder > @MaxSortOrder THEN @MaxSortOrder+1
									ELSE @SortOrder END)

		-- Shift SortOrder of existing records
		UPDATE [Ontology.].PropertyGroupProperty
			SET SortOrder = SortOrder + 1
			WHERE PropertyGroupURI = @PropertyGroupURI AND SortOrder >= @SortOrder
		
		-- Insert new property
		INSERT INTO [Ontology.].PropertyGroupProperty (PropertyGroupURI, PropertyURI, SortOrder, _NumberOfNodes)
			SELECT @PropertyGroupURI, @PropertyURI, @SortOrder, 0

	END

	---------------------------------------------------
	-- [Ontology.].[ClassProperty]
	---------------------------------------------------

	IF (@ClassURI IS NOT NULL) AND NOT EXISTS (
		SELECT *
		FROM [Ontology.].[ClassProperty]
		WHERE Class = @ClassURI AND Property = @PropertyURI
			AND ( (NetworkProperty IS NULL AND @NetworkPropertyURI IS NULL) OR (NetworkProperty = @NetworkPropertyURI) )
	)
	BEGIN

		-- Get the ClassPropertyID	
		DECLARE @ClassPropertyID INT
		SELECT @ClassPropertyID = IsNull((SELECT MAX(ClassPropertyID)
											FROM [Ontology.].ClassProperty),0)+1
		-- Insert the new property
		INSERT INTO [Ontology.].[ClassProperty] (
				ClassPropertyID,
				Class, NetworkProperty, Property,
				IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight,
				CustomDisplay, CustomEdit, ViewSecurityGroup,
				EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup,
				MinCardinality, MaxCardinality, CustomEditModule,
				_NumberOfNodes, _NumberOfTriples		
			)
			SELECT	@ClassPropertyID,
					@ClassURI, @NetworkPropertyURI, @PropertyURI,
					IsNull(@IsDetail,1), @Limit, IsNull(@IncludeDescription,0), IsNull(@IncludeNetwork,0),
					IsNull(@SearchWeight,(CASE WHEN @ObjectType = 0 THEN 0 ELSE 0.5 END)),
					IsNull(@CustomDisplay,0), IsNull(@CustomEdit,0), IsNull(@ViewSecurityGroup,-1),
					IsNull(@EditSecurityGroup,-40),
					Coalesce(@EditPermissionsSecurityGroup,@EditSecurityGroup,-40),
					Coalesce(@EditExistingSecurityGroup,@EditSecurityGroup,-40),
					Coalesce(@EditAddNewSecurityGroup,@EditSecurityGroup,-40),
					Coalesce(@EditAddExistingSecurityGroup,@EditSecurityGroup,-40),
					Coalesce(@EditDeleteSecurityGroup,@EditSecurityGroup,-40),
					IsNull(@MinCardinality,0),
					@MaxCardinality,
					@CustomEditModule,
					0, 0

		-- Re-sort the table
		IF @ReSortClassProperty = 1
			update x
				set x.ClassPropertyID = y.k
				from [Ontology.].ClassProperty x, (
					select *, row_number() over (order by (case when NetworkProperty is null then 0 else 1 end), Class, NetworkProperty, IsDetail, IncludeNetwork, Property) k
						from [Ontology.].ClassProperty
				) y
				where x.Class = y.Class and x.Property = y.Property
					and ((x.NetworkProperty is null and y.NetworkProperty is null) or (x.NetworkProperty = y.NetworkProperty))

	END

	---------------------------------------------------
	-- Update Derived Fields
	---------------------------------------------------

	EXEC [Ontology.].UpdateDerivedFields
	
	
	/*
	
	-- Example
	exec [Ontology.].AddProperty
		@OWL = 'PRNS_1.0',
		@PropertyURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#emailEncrypted',
		@PropertyName = 'email encrypted',
		@ObjectType = 1,
		@PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupAddress',
		@SortOrder = 20,
		@ClassURI = 'http://xmlns.com/foaf/0.1/Person',
		@NetworkPropertyURI = null,
		@IsDetail = 0,
		@SearchWeight = 0,
		@CustomDisplay = 1,
		@CustomEdit = 1

	*/
	
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  function [Profile.Data].[fnPublication.Person.GetPublications](@UserID INT)
RETURNS  @p  TABLE(
										RowNum VARCHAR(10),
										Reference NVARCHAR(MAX),
										FromPubMed BIT,
										PubId NVARCHAR(50),
										pmid INT,
										mpid VARCHAR(50),
										category NVARCHAR(60),
										url			VARCHAR(1000),
									  pubdate DATETIME
									)
AS
BEGIN
DECLARE  @encode_html INT,
@pubmed_url VARCHAR(200)
declare @dash_url varchar(max)
select @dash_url = ISNULL('http://dash.harvard.edu/handle/1/',''),
			@pubmed_url='http://www.ncbi.nlm.nih.gov/pubmed/'
SELECT @encode_html = 0;
 
WITH cte
		 AS (SELECT CONVERT(VARCHAR,ROW_NUMBER() OVER(ORDER BY publication_dt desc, publications)) + '. ' AS rownum,
								publications,
								frompubmed,
								pubid,
								pmid,
								mpid,
								category,
								url,publication_dt
					 FROM (SELECT  DISTINCT 
												 p.pmid,
												 NULL                                              AS mpid,
													[Profile.Cache].[fnPublication.Pubmed.General2Reference]	(p.pmid ,ArticleDay,ArticleMonth,ArticleYear,ArticleTitle,Authors,AuthorListCompleteYN,Issue,JournalDay,JournalMonth,JournalYear,MedlineDate,MedlinePgn,MedlineTA,Volume,0) AS publications,
												 1                                                 AS frompubmed,
												 [Profile.Data].[fnPublication.Pubmed.GetPubDate]( MedlineDate,JournalYear,JournalMonth,JournalDay,ArticleYear,ArticleMonth,ArticleDay)                                           AS publication_dt,
												 pubid,
												 NULL                                              category,
												 @pubmed_url + CAST(ISNULL(p.pmid,'') AS VARCHAR(20))	     url,
												 'PubMed'										   sourcename
									 FROM [Profile.Data].[Publication.Person.Include] i    
									 JOIN [Profile.Data].[Publication.PubMed.General] p ON i.pmid = p.pmid
									WHERE  i.personid = @UserID
									  AND p.pmid IS NOT NULL
								 UNION ALL
								 SELECT  DISTINCT 
												 m.pmid,
												 m.mpid,
												 --dbo.fn_GetPublicationReference(m.mpid,'mpid',1)	AS Publications			,
 	
				 (SELECT authors + 
																(CASE 
																	WHEN url <> ''
																			 AND article <> ''
																			 AND pub <> '' THEN url + article + '</a>. ' + pub + '. '
																	WHEN url <> ''
																			 AND article <> '' THEN url + article + '</a>. '
																	WHEN url <> ''
																			 AND pub <> '' THEN url + pub + '</a>. '
																	WHEN article <> ''
																			 AND pub <> '' THEN article + '. ' + pub + '. '
																	WHEN article <> '' THEN article + '. '
																	WHEN pub <> '' THEN pub + '. '
																	ELSE ''
																END) + 
																y + 
															 (CASE 
																	 WHEN y <> ''
																				AND vip <> '' THEN '; '
																	 ELSE ''
																END) + 
																vip + 
																(CASE 
																	WHEN y <> ''
																				OR vip <> '' THEN '.'
																	ELSE ''
																END)
													FROM (SELECT url,
																			 (CASE 
																					WHEN authors = '' THEN ''
																					WHEN RIGHT(authors,1) = '.' THEN LEFT(authors,LEN(authors) - 1)
																					ELSE authors
																				END) authors,
																			 (CASE 
																					WHEN article = '' THEN ''
																					WHEN RIGHT(article,1) = '.' THEN LEFT(article,LEN(article) - 1)
																					ELSE article
																				END) article,
																			 (CASE 
																					WHEN pub = '' THEN ''
																					WHEN RIGHT(pub,1) = '.' THEN LEFT(pub,LEN(pub) - 1)
																					ELSE pub
																				END) pub,
																			 y,
																			 vip,
																			 frompubmed,
																			 publicationdt
														       		  FROM (SELECT ( 		case													WHEN RTRIM(LTRIM(COALESCE(authors,''))) = '' THEN ''
																									WHEN RIGHT(COALESCE(authors,''),1) = '.' THEN COALESCE(authors,'') + ' '
																									ELSE COALESCE(authors,'') + '. '
																								END) authors,
																							 (CASE 
																									WHEN COALESCE(url,'') <> ''
																											 AND LEFT(COALESCE(url,''),4) = 'http' THEN '<a href="' + url + '" target="_blank">'
																									WHEN COALESCE(url,'') <> '' THEN '<a href="http://' + url + '" target="_blank">'
																									ELSE ''
																								END) url,
																							 LTRIM(RTRIM(COALESCE(articletitle,'')))     article,
																							 LTRIM(RTRIM(COALESCE(pubtitle,'')))         pub,
																							 (CASE 
																									WHEN publicationdt > '1/1/1901' THEN CONVERT(VARCHAR(50),YEAR(publicationdt))
																									ELSE ''
																								END) y,
																							 COALESCE(volnum,'') + 
																							(CASE 
																									WHEN COALESCE(issuepub,'') <> '' THEN '(' + issuepub + ')'
																									ELSE ''
																								END) +	
																							(CASE 
																								WHEN (COALESCE(paginationpub,'') <> '') AND (COALESCE(volnum,'') + COALESCE(issuepub,'') <> '') THEN ':'
																								ELSE ''
																						  END) + 
																							COALESCE(paginationpub,'') vip,
																							0                                           AS frompubmed,
																							publicationdt
																			FROM		[Profile.Data].[Publication.MyPub.General] m2
																	   WHERE		m2.mpid = m.mpid) t) 
																 t) AS publications,
																 0,
																 publicationdt,
																 pubid,
																 hmspubcategory,
																 url,
																'Custom'										   sourcename
									FROM [Profile.Data].[Publication.MyPub.General] m
								    JOIN [Profile.Data].[Publication.Person.Include] i 	ON i.mpid = m.mpid
			 
 WHERE m.personid = @UserID	
								     AND i.mpid IS NOT NULL
								     AND i.mpid NOT LIKE 'DASH%'
								     AND i.mpid NOT LIKE 'ISI%'
								     AND i.pmid IS NULL 
									UNION ALL 
									SELECT		null as pmid, 
										p.mpid,
										g.BibliographicCitation publications, 
										0 as FromPubMed, 
										m.publicationdt,
										pubid,
										m.hmspubcategory,
										@dash_url+cast(g.dashid as varchar(10)) url,
										'DASH' sourcename
									FROM	[Profile.Data].[Publication.MyPub.General] m, [Profile.Data].[Publication.Person.Include] p, [Profile.Data].[Publication.DSpace.MPID] d, [Profile.Data].[Publication.DSpace.PubGeneral] g
									WHERE	p.personid = @UserID
										and m.mpid = p.mpid
										and p.mpid is not null and p.pmid is null
										and p.mpid like 'DASH%' 
										and p.mpid = d.mpid and d.dashid = g.dashid
									UNION ALL
									SELECT 
										null as pmid, 
										p.mpid,
										(g.authors + '. ' 
										+ g.itemtitle + (case when right(g.itemtitle,1) not in ('.','?','!') then '. ' else ' ' end) 
										+ coalesce(g.sourceabbrev, g.sourcetitle) 
										+ '. ' + g.bibid + '.')
										publications,
										0 as FromPubMed, 
										m.publicationdt,
										pubid,
										m.hmspubcategory,
										'http://dx.doi.org/' + doi url,
										'DOI' sourcename
									FROM [Profile.Data].[Publication.MyPub.General] m,[Profile.Data].[Publication.Person.Include] p, [Profile.Data].[Publication.ISI.MPID] d, [Profile.Data].[Publication.ISI.PubGeneral] g
									where p.personid = @UserID
										and m.mpid = p.mpid
										and p.mpid is not null and p.pmid is null
										and p.mpid like 'ISI%' 
										and p.mpid = d.mpid and d.recid = g.recid
		 			     
								    ) t)
INSERT INTO @p
SELECT * 
	FROM cte
 ORDER BY CONVERT(INT,REPLACE(rownum,'.',''))
 
RETURN
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [RDF.].[DeleteNode]
	@NodeID bigint = NULL,
	@NodeURI varchar(400) = NULL,
	@DeleteType tinyint = 1,
	@SessionID uniqueidentifier = NULL,
	-- Output variables
	@Error bit = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
	
	SELECT @Error = 0
	
	SELECT @NodeID = NULL WHERE @NodeID = 0
 
	IF (@NodeID IS NULL) AND (@NodeURI IS NOT NULL)
		SELECT @NodeID = [RDF.].fnURI2NodeID(@NodeURI)
 
	IF (@NodeID IS NOT NULL)
	BEGIN TRY
	BEGIN TRANSACTION
	    
		IF @DeleteType = 0 -- True delete
		BEGIN
			EXEC [RDF.].[DeleteTriple] @DeleteType = @DeleteType, @SessionID = @SessionID, @Subject = @NodeID
			EXEC [RDF.].[DeleteTriple] @DeleteType = @DeleteType, @SessionID = @SessionID, @Predicate = @NodeID
			EXEC [RDF.].[DeleteTriple] @DeleteType = @DeleteType, @SessionID = @SessionID, @Object = @NodeID
			DELETE
				FROM [RDF.Stage].[InternalNodeMap]
				WHERE NodeID = @NodeID
			DELETE
				FROM [RDF.].[Node]
				WHERE NodeID = @NodeID
		END
 
		IF @DeleteType = 1 -- Change security groups
		BEGIN
			UPDATE [RDF.].[Node]
				SET ViewSecurityGroup = 0, EditSecurityGroup = -50
				WHERE NodeID = @NodeID
		END
  
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[CustomViewAuthorInAuthorship.GetList]
@NodeID BIGINT=NULL, @SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN

	DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT
	EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
	CREATE TABLE #SecurityGroupNodes (SecurityGroupNode BIGINT PRIMARY KEY)
	INSERT INTO #SecurityGroupNodes (SecurityGroupNode) EXEC [RDF.Security].GetSessionSecurityGroupNodes @SessionID, @NodeID


	declare @AuthorInAuthorship bigint
	select @AuthorInAuthorship = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#authorInAuthorship') 
	declare @LinkedInformationResource bigint
	select @LinkedInformationResource = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#linkedInformationResource') 


	select i.NodeID, p.EntityID, i.Value rdf_about, p.EntityName rdfs_label, 
		p.Reference prns_informationResourceReference, p.EntityDate prns_publicationDate,
		year(p.EntityDate) prns_year, p.pmid bibo_pmid, p.mpid prns_mpid
	from [RDF.].[Triple] t
		inner join [RDF.].[Node] a
			on t.subject = @NodeID and t.predicate = @AuthorInAuthorship
				and t.object = a.NodeID
				and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
				and ((a.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (a.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (a.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
		inner join [RDF.].[Node] i
			on t.object = i.NodeID
				and ((i.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (i.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (i.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
		inner join [RDF.Stage].[InternalNodeMap] m
			on i.NodeID = m.NodeID
		inner join [Profile.Data].[Publication.Entity.Authorship] e
			on m.InternalID = e.EntityID
		inner join [Profile.Data].[Publication.Entity.InformationResource] p
			on e.InformationResourceID = p.EntityID
	order by p.EntityDate desc

/*
	select i.NodeID, p.EntityID, i.Value rdf_about, p.EntityName rdfs_label, 
		p.Reference prns_informationResourceReference, p.EntityDate prns_publicationDate,
		year(p.EntityDate) prns_year, p.pmid bibo_pmid, p.mpid prns_mpid
	from [RDF.].[Triple] t
		inner join [RDF.].[Triple] v
			on t.subject = @NodeID and t.predicate = @AuthorInAuthorship
			and t.object = v.subject and v.predicate = @LinkedInformationResource
			and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
			and ((v.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (v.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (v.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
		inner join [RDF.].[Node] a
			on t.object = a.NodeID
			and ((a.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (a.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (a.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
		inner join [RDF.].[Node] i
			on v.object = i.NodeID
			and ((i.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (i.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (i.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
		inner join [RDF.Stage].[InternalNodeMap] m
			on i.NodeID = m.NodeID
		inner join [Profile.Data].[Publication.Entity.InformationResource] p
			on m.InternalID = p.EntityID
	order by p.EntityDate desc
*/

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdatePersonPublication]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	DECLARE @proc VARCHAR(200)
	SELECT @proc = OBJECT_NAME(@@PROCID)
	DECLARE @date DATETIME,@auditid UNIQUEIDENTIFIER, @rows int
	SELECT @date=GETDATE() 
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
	SELECT *, (case when majortopicyn='Y' then 1.0 else 0.25 end) TopicWeight 
		INTO #pm_pub_mesh 
		FROM [Profile.Data].[vwPublication.Pubmed.Mesh.Descriptor]
	CREATE UNIQUE CLUSTERED INDEX idx_pm on #pm_pub_mesh(pmid, meshheader)
 
	SELECT m.MeshHeader, a.PersonID, a.PMID, c.NumPublications NumPubsAll, 1 NumPubsThis,
			m.TopicWeight, a.AuthorWeight, a.YearWeight, c.Weight UniquenessWeight,
			m.TopicWeight * a.AuthorWeight * a.YearWeight * c.Weight MeshWeight,
			a.AuthorPosition, a.PubYear, c.NumFaculty NumPeopleAll, a.PubDate
		INTO #cache_pub_mesh
		FROM #pm_pub_mesh m, [Profile.Cache].[Publication.PubMed.AuthorPosition] a, [Profile.Cache].[Concept.Mesh.Count] c
		WHERE a.pmid = m.pmid and m.meshheader = c.meshheader
 
	BEGIN TRY
		BEGIN TRAN
			TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.PersonPublication]
			INSERT INTO [Profile.Cache].[Concept.Mesh.PersonPublication] (MeshHeader, PersonID, PMID, NumPubsAll, NumPubsThis, TopicWeight, AuthorWeight, YearWeight, UniquenessWeight, MeshWeight, AuthorPosition, PubYear, NumPeopleAll, PubDate)
				SELECT MeshHeader, PersonID, PMID, NumPubsAll, NumPubsThis, TopicWeight, AuthorWeight, YearWeight, UniquenessWeight, MeshWeight, AuthorPosition, PubYear, NumPeopleAll, PubDate
				FROM #cache_pub_mesh
			SELECT @rows = @@ROWCOUNT
		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName ='usp_cache_pub_mesh',@ProcessEndDate=@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Utility.NLP].[fnPorterAlgorithm]
	(
		@InWord nvarchar(4000)
	)
RETURNS nvarchar(4000)
AS
BEGIN
    DECLARE @Ret nvarchar(4000), @Temp nvarchar(4000)

    -- DO some initial cleanup
    SELECT @Ret = LOWER(ISNULL(RTRIM(LTRIM(@InWord)),N''))

    -- only strings greater than 2 are stemmed
    IF LEN(@Ret) > 2
	BEGIN
	    SELECT @Ret = [Utility.NLP].fnPorterStep1(@Ret)
	    SELECT @Ret = [Utility.NLP].fnPorterStep2(@Ret)
	    SELECT @Ret = [Utility.NLP].fnPorterStep3(@Ret)
	    SELECT @Ret = [Utility.NLP].fnPorterStep4(@Ret)
	    SELECT @Ret = [Utility.NLP].fnPorterStep5(@Ret)
	END

--End of Porter's algorithm.........returning the word
    RETURN @Ret
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[GetPropertyRangeList]
	@PropertyID BIGINT = NULL,
	@PropertyURI VARCHAR(400) = NULL,
	@returnTable BIT = 0,
	@returnXML BIT = 1,
	@PropertyRangeListXML XML = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@PropertyURI IS NULL) AND (@PropertyID IS NOT NULL)
		SELECT @PropertyURI = Value
			FROM [RDF.].Node
			WHERE NodeID = @PropertyID

	declare @LabelID bigint
	declare @SubClassOfID bigint
	select	@LabelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label'),
			@SubClassOfID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#subClassOf')

	create table #range (
		ClassID bigint primary key,
		ClassURI varchar(400),
		Label varchar(400),
		Depth int,
		SortOrder float,
	)
	
	insert into #range (ClassID, Label, Depth, SortOrder)
		select p.ValueNode, n.Value, 0, row_number() over (order by n.Value)
			from [ontology.].vwPropertyTall p, [RDF.].Triple t, [RDF.].Node n
			where p.property = @PropertyURI
				and p.predicate = 'http://www.w3.org/2000/01/rdf-schema#range'
				and t.subject = p.ValueNode
				and t.predicate = @LabelID
				and t.object = n.NodeID

	declare @done bit
	select @done = 0
	while @done = 0
	begin
		insert into #range (ClassID, Label, Depth, SortOrder)
			select t.subject, left(n.Value,400), r.depth+1,
					r.SortOrder + power(cast(0.001 as float),r.depth+1)*(row_number() over (partition by r.classid order by n.value))
				from #range r, [RDF.].Triple t, [RDF.].Triple v, [RDF.].Node n
				where t.object = r.ClassID
					and t.predicate = @SubClassOfID
					and t.subject = v.subject
					and v.predicate = @LabelID
					and v.object = n.NodeID
					and t.subject not in (select ClassID from #range)
		if @@ROWCOUNT = 0
			select @done = 1
	end
	
	update r
		set r.ClassURI = n.Value
		from #range r, [RDF.].Node n
		where r.ClassID = n.NodeID

	if @returnTable = 1
		select * 
		from #range
		order by sortorder

	select @PropertyRangeListXML = (
			select (
					select	ClassID "@ClassID",
							ClassURI "@ClassURI",
							Depth "@Depth",
							Label "@Label"
						from #range
						order by SortOrder
						for xml path('PropertyRange'), type
				) "PropertyRangeList"
			for xml path(''), type
		)

	if @PropertyRangeListXML is null or (cast(@PropertyRangeListXML as nvarchar(max)) = '')
		select @PropertyRangeListXML = cast('<PropertyRangeList />' as xml)
	
	if @returnXML = 1
		select @PropertyRangeListXML PropertyRangeList

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[NetworkMap.GetSimilarPeople]
@NodeID BIGINT, @show_connections BIT=0, @SessionID UNIQUEIDENTIFIER=NULL
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[NetworkMap.GetCoauthors]
@NodeID BIGINT, @which INT=0, @SessionID UNIQUEIDENTIFIER=NULL
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
		PersonID INT,
		display_name NVARCHAR(255),
		latitude FLOAT,
		longitude FLOAT,
		address1 NVARCHAR(1000),
		address2 NVARCHAR(1000),
		URI VARCHAR(400)
	)
 
	INSERT INTO @f (	PersonID,
						display_name,
						latitude,
						longitude,
						address1,
						address2
					)
		SELECT	p.PersonID,
				p.displayname,
				l.latitude,
				l.longitude,
				CASE WHEN p.addressstring like '%,%' THEN LEFT(p.addressstring,CHARINDEX(',',p.addressstring) - 1)ELSE P.addressstring END address1,
				CASE WHEN p.addressstring like '%,%' THEN REPLACE(SUBSTRING(p.addressstring,CHARINDEX(',',p.addressstring) + 1,LEN(p.addressstring)),', USA','') ELSE p.addressstring END address2
		FROM [Profile.Data].vwperson p,
				(SELECT DISTINCT PersonID
					FROM  [Profile.Data].[Publication.Person.Include]
					WHERE pmid IN (SELECT pmid
										FROM [Profile.Data].[Publication.Person.Include]
										WHERE PersonID = @PersonID
											AND pmid IS NOT NULL
									)
				) t,
				[Profile.Data].vwperson l
		 WHERE p.PersonID = t.PersonID
			 AND p.PersonID = l.PersonID
			 AND l.latitude IS NOT NULL
			 AND l.longitude IS NOT NULL
		 ORDER BY p.lastname, p.firstname
 
	UPDATE @f
		SET URI = p.Value + cast(m.NodeID as varchar(50))
		FROM @f, [RDF.Stage].InternalNodeMap m, [Framework.].Parameter p
		WHERE p.ParameterID = 'baseURI' AND m.InternalHash = [RDF.].fnValueHash(null,null,'http://xmlns.com/foaf/0.1/Person^^Person^^'+cast(PersonID as varchar(50)))
 
	DELETE FROM @f WHERE URI IS NULL
 
	IF (SELECT COUNT(*) FROM @f) = 1
		IF (SELECT personid from @f)=@PersonID
			DELETE FROM @f
 
 
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
						(CASE 
							 WHEN a.PersonID = @PersonID
								OR d.PersonID = @PersonID THEN 1
							 ELSE 0
						 END) is_person,
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
	END
		
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[NetworkAuthorshipTimeline.Person.GetData]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
    -- Insert statements for procedure here
	declare @gc varchar(max)

	declare @y table (
		y int,
		A int,
		B int,
		C int
	)

	insert into @y (y,A,B,C)
		select n.n y, coalesce(t.A,0) A, coalesce(t.B,0) B, coalesce(t.C,0) C 
		from [Utility.Math].[N] left outer join (
			select (case when y < 1970 then 1970 else y end) y,
				sum(case when r in ('F','S') then 1 else 0 end) A,
				sum(case when r not in ('F','S','L') then 1 else 0 end) B,
				sum(case when r in ('L') then 1 else 0 end) C
			from (
				select coalesce(p.AuthorPosition,'U') r, year(coalesce(p.pubdate,m.publicationdt,'1/1/1970')) y
				from [Profile.Data].[Publication.Person.Include] a
					left outer join [Profile.Cache].[Publication.PubMed.AuthorPosition] p on a.pmid = p.pmid and p.personid = a.personid
					left outer join [Profile.Data].[Publication.MyPub.General] m on a.mpid = m.mpid
				where a.personid = @PersonID
			) t
			group by y
		) t on n.n = t.y
		where n.n between 1980 and year(getdate())

	declare @x int

	select @x = max(A+B+C)
		from @y

	if coalesce(@x,0) > 0
	begin
		declare @v varchar(1000)
		declare @z int
		declare @k int
		declare @i int

		set @z = power(10,floor(log(@x)/log(10)))
		set @k = floor(@x/@z)
		if @x > @z*@k
			select @k = @k + 1
		if @k > 5
			select @k = floor(@k/2.0+0.5), @z = @z*2

		set @v = ''
		set @i = 0
		while @i <= @k
		begin
			set @v = @v + '|' + cast(@z*@i as varchar(50))
			set @i = @i + 1
		end
		set @v = '|0|'+cast(@x as varchar(50))
		--set @v = '|0|50|100'

		declare @h varchar(1000)
		set @h = ''
		select @h = @h + '|' + (case when y % 2 = 1 then '' else ''''+right(cast(y as varchar(50)),2) end)
			from @y
			order by y 

		declare @w float
		--set @w = @k*@z
		set @w = @x

		declare @d varchar(max)
		set @d = ''
		select @d = @d + cast(floor(0.5 + 100*A/@w) as varchar(50)) + ','
			from @y
			order by y
		set @d = left(@d,len(@d)-1) + '|'
		select @d = @d + cast(floor(0.5 + 100*B/@w) as varchar(50)) + ','
			from @y
			order by y
		set @d = left(@d,len(@d)-1) + '|'
		select @d = @d + cast(floor(0.5 + 100*C/@w) as varchar(50)) + ','
			from @y
			order by y
		set @d = left(@d,len(@d)-1)

		declare @c varchar(50)
		set @c = 'FB8072,B3DE69,80B1D3'
		--set @c = 'F96452,a8dc4f,68a4cc'
		--set @c = 'fea643,76cbbd,b56cb5'

		--select @v, @h, @d

		--set @gc = 'http://chart.apis.google.com/chart?chs=605x150&amp;chf=bg,s,ffffff|c,s,ffffff&amp;chxt=x,y&amp;chxl=0:|99|00|01|02|03|1:|0|10|20|30|40|50&amp;cht=bvs&amp;chd=t:70.00,42.00,34.00,38.00,82.00|30.00,18.00,8.00,6.00,4.00&amp;chdl=First+Author|Middle+Author&amp;chco=0000ff,cc3300&amp;chbh=50'
		--set @gc = 'http://chart.apis.google.com/chart?chxs=0,333333,10&amp;chs=605x80&amp;chf=bg,s,ffffff|c,s,ffffff&amp;chxt=x,y&amp;chxl=0:' + @h + '|1:' + @v + '&amp;cht=bvs&amp;chd=t:' + @d + '&amp;chdl=First+Author|Middle or Unkown|Last+Author&amp;chco=0000ff,009900,cc3300&amp;chbh=10'
		--set @gc = 'http://chart.apis.google.com/chart?chs=595x100&amp;chf=bg,s,ffffff|c,s,ffffff&amp;chxt=x,y&amp;chxl=0:' + @h + '|1:' + @v + '&amp;cht=bvs&amp;chd=t:' + @d + '&amp;chdl=First+Author|Middle or Unkown|Last+Author&amp;chco='+@c+'&amp;chbh=10'
		set @gc = 'http://chart.apis.google.com/chart?chs=595x100&chf=bg,s,ffffff|c,s,ffffff&chxt=x,y&chxl=0:' + @h + '|1:' + @v + '&cht=bvs&chd=t:' + @d + '&chdl=First+Author|Middle or Unkown|Last+Author&chco='+@c+'&chbh=10'

		select @gc gc --, @w w

		--select * from @y order by y

	end

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Person.DeletePhoto](@PhotoID INT)
AS
BEGIN

	-- Delete the triple
	DECLARE @NodeID BIGINT
	SELECT @NodeID = NodeID
		FROM [Profile.Data].[vwPerson.Photo]
		WHERE PhotoID = @PhotoID
	IF (@NodeID IS NOT NULL)
		EXEC [RDF.].[DeleteTriple] @SubjectID = @NodeID, @PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#mainImage'

	-- Delete the photo
	DELETE 
		FROM [Profile.Data].[Person.Photo]
		WHERE PhotoID=@PhotoID 

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[NetworkTimeline.Person.CoAuthorOf.GetData]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
 	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	;with e as (
		select top 20 s.PersonID1, s.PersonID2, s.n PublicationCount, 
			year(s.FirstPubDate) FirstPublicationYear, year(s.LastPubDate) LastPublicationYear, 
			p.DisplayName DisplayName2, ltrim(rtrim(p.FirstName+' '+p.LastName)) FirstLast2, s.w OverallWeight
		from [Profile.Cache].[SNA.Coauthor] s, [Profile.Cache].[Person] p
		where personid1 = @PersonID and personid2 = p.personid
		order by w desc, personid2
	), f as (
		select e.*, g.pubdate
		from [Profile.Data].[Publication.Person.Include] a, 
			[Profile.Data].[Publication.Person.Include] b, 
			[Profile.Data].[Publication.PubMed.General] g,
			e
		where a.personid = e.personid1 and b.personid = e.personid2 and a.pmid = b.pmid and a.pmid = g.pmid
			and g.pubdate > '1/1/1900'
	), g as (
		select min(year(pubdate))-1 a, max(year(pubdate))+1 b,
			cast(cast('1/1/'+cast(min(year(pubdate))-1 as varchar(10)) as datetime) as float) f,
			cast(cast('1/1/'+cast(max(year(pubdate))+1 as varchar(10)) as datetime) as float) g
		from f
	), h as (
		select f.*, (cast(pubdate as float)-f)/(g-f) x, a, b, f, g
		from f, g
	), i as (
		select personid2, min(x) MinX, max(x) MaxX, avg(x) AvgX
		from h
		group by personid2
	)
	select h.*, MinX, MaxX, AvgX, h.FirstLast2 label, (select count(distinct personid2) from i) n,
		@baseURI + cast(m.NodeID as varchar(50)) ObjectURI
	from h, i, [RDF.Stage].[InternalNodeMap] m
	where h.personid2 = i.personid2 and cast(i.personid2 as varchar(50)) = m.InternalID
		and m.Class = 'http://xmlns.com/foaf/0.1/Person' and m.InternalType = 'Person'
	order by AvgX, firstpublicationyear, lastpublicationyear, personid2, pubdate

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[GetStoreNode]
	-- Cat0
	@ExistingNodeID bigint = null,
	-- Cat1
	@Value nvarchar(max) = null,
	@Language nvarchar(255) = null,
	@DataType nvarchar(255) = null,
	@ObjectType bit = null,
	-- Cat2
	@Class nvarchar(400) = null,
	@InternalType nvarchar(100) = null,
	@InternalID nvarchar(100) = null,
	-- Cat3
	@TripleID bigint = null,
	-- Cat5, Cat6
	@StartTime nvarchar(100) = null,
	@EndTime nvarchar(100) = null,
	@TimePrecision nvarchar(100) = null,
	-- Cat7
	@DefaultURI bit = null,
	-- Cat8
	@EntityClassID bigint = null,
	@EntityClassURI varchar(400) = null,
	@Label nvarchar(max) = null,
	@ForceNewEntity bit = 0,
	-- Cat9
	@SubjectID bigint = null,
	@PredicateID bigint = null,
	@SortOrder int = null,
	-- Attributes
	@ViewSecurityGroup bigint = null,
	@EditSecurityGroup bigint = null,
	-- Security
	@SessionID uniqueidentifier = NULL,
	-- Output variables
	@Error bit = NULL OUTPUT,
	@NodeID bigint = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/* 
	The node can be defined in different ways:
		Cat 0: ExistingNodeID (a NodeID from [RDF.].Node)
		Cat 1: Value, Language, DataType, ObjectType (standard RDF literal [ObjectType=1], or just Value if URI [ObjectType=0])
		Cat 2: NodeType (primary VIVO type, http://xmlns.com/foaf/0.1/Person), InternalType (Profiles10 type, such as "Person"), InternalID (personID=32213)
		Cat 3: TripleID (from [RDF.].Triple -- a reitification)
		Cat 5: StartTime, EndTime, TimePrecision (VIVO's DateTimeInterval, DateTimeValue, and DateTimeValuePrecision classes)
		Cat 6: StartTime, TimePrecision (VIVO's DateTimeValue, and DateTimeValuePrecision classes)
		Cat 7: The default URI: baseURI+NodeID
		Cat 8: New entity with class (by node ID or URI) and label; ForceNewEntity=1 always creates a new node
		Cat 9: The object node of a triple given the SubjectID node, PredicateID node, and the triple sort order
	*/

	SELECT @Error = 0

	SELECT @ExistingNodeID = NULL WHERE @ExistingNodeID = 0
	SELECT @TripleID = NULL WHERE @TripleID = 0

 	IF (@EntityClassID IS NULL) AND (@EntityClassURI IS NOT NULL)
		SELECT @EntityClassID = [RDF.].fnURI2NodeID(@EntityClassURI)

	-- Determine the category
	DECLARE @Category INT
	SELECT @Category = (
		CASE
			WHEN (@ExistingNodeID IS NOT NULL) THEN 0
			WHEN (@Value IS NOT NULL) THEN 1
			WHEN ((@Class IS NOT NULL) AND (@InternalType IS NOT NULL) AND (@InternalID IS NOT NULL)) THEN 2
			WHEN (@TripleID IS NOT NULL) THEN 3
			WHEN ((@StartTime IS NOT NULL) AND (@EndTime IS NOT NULL) AND (@TimePrecision IS NOT NULL)) THEN 5
			WHEN ((@StartTime IS NOT NULL) AND (@TimePrecision IS NOT NULL)) THEN 6
			WHEN (@DefaultURI = 1) THEN 7
			WHEN ((@EntityClassID IS NOT NULL) AND (IsNull(@Label,'')<>'')) THEN 8
			WHEN ((@SubjectID IS NOT NULL) AND (@PredicateID IS NOT NULL) AND (@SortOrder IS NOT NULL)) THEN 9
			ELSE NULL END)

	IF @Category IS NULL
	BEGIN
		SELECT @Error = 1
		RETURN
	END

	-- Determine if the node already exists
	SELECT @NodeID = (CASE
		WHEN @Category = 0 THEN (
				SELECT NodeID
				FROM [RDF.].[Node]
				WHERE NodeID = @ExistingNodeID
			)
		WHEN @Category = 1 THEN (
				SELECT NodeID
				FROM [RDF.].[Node]
				WHERE ValueHash = [RDF.].[fnValueHash](@Language,@DataType,@Value)
			)
		WHEN @Category = 2 THEN (
				SELECT NodeID
				FROM [RDF.Stage].InternalNodeMap
				WHERE Class = @Class AND InternalType = @InternalType AND InternalID = @InternalID
			)
		WHEN @Category = 8 THEN (
				SELECT NodeID
				FROM [RDF.].Triple t, [RDF.].Triple v, [RDF.].Node n
				WHERE t.subject = v.subject
					AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
					AND t.object = @EntityClassID
					AND v.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')
					AND v.object = n.NodeID
					AND n.ValueHash = [RDF.].[fnValueHash](null,null,@Label)
					AND @ForceNewEntity = 0
			)
		WHEN @Category = 9 THEN (
				SELECT t.Object
				FROM [RDF.].[Triple] t
				WHERE t.subject = @SubjectID
					AND t.predicate = @PredicateID
					AND t.SortOrder = @SortOrder
			)
		ELSE NULL END)

	-- Update attributes of an existing node
	IF (@NodeID IS NOT NULL) AND (IsNull(@ViewSecurityGroup,@EditSecurityGroup) IS NOT NULL)
	BEGIN
		UPDATE [RDF.].Node
			SET ViewSecurityGroup = IsNull(@ViewSecurityGroup,ViewSecurityGroup),
				EditSecurityGroup = IsNull(@EditSecurityGroup,EditSecurityGroup)
			WHERE NodeID = @NodeID
	END

	-- Check that if a new node is needed, then all attributes are defined
	IF (@NodeID IS NULL)
	BEGIN
		SELECT	@ViewSecurityGroup = IsNull(@ViewSecurityGroup,-1),
				@EditSecurityGroup = IsNull(@EditSecurityGroup,-40)
		SELECT	@ObjectType = (CASE WHEN @Value LIKE 'http://%' or @Value LIKE 'https://%' THEN 0 ELSE 1 END)
			WHERE (@Category=1 AND @ObjectType IS NULL)
	END

	-- Create a new node if needed
	IF (@NodeID IS NULL)	
	BEGIN
		BEGIN TRY 
		BEGIN TRANSACTION

		-- Lookup the base URI
		DECLARE @baseURI NVARCHAR(400)
		SELECT @baseURI = Value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

		-- Create node based on category
		IF @Category = 1
			BEGIN
				INSERT INTO [RDF.].[Node] (ViewSecurityGroup, EditSecurityGroup, Language, DataType, Value, ObjectType, ValueHash)
					SELECT @ViewSecurityGroup, @EditSecurityGroup, @Language, @DataType, @Value, @ObjectType,
						[RDF.].[fnValueHash](@Language,@DataType,@Value)
				SET @NodeID = @@IDENTITY
			END
		IF @Category = 2
			BEGIN
				-- Create the InternalNodeMap record
				DECLARE @InternalNodeMapID BIGINT
				INSERT INTO [RDF.Stage].[InternalNodeMap] (InternalType, InternalID, NodeType, Status, InternalHash)
					SELECT @InternalType, @InternalID, @Class, 4, 
						[R DF.].fnValueHash(null,null,@Class+'^^'+@InternalType+'^^'+@InternalID)
				SET @InternalNodeMapID = @@IDENTITY
				-- Create the Node
				INSERT INTO [RDF.].[Node] (ViewSecurityGroup, EditSecurityGroup, InternalNodeMapID, ObjectType, Value, ValueHash)
					SELECT @ViewSecurityGroup, @EditSecurityGroup, @InternalNodeMapID, 0,
						'#INM'+cast(@InternalNodeMapID as nvarchar(50)),
						[RDF.].fnValueHash(null,null,'#INM'+cast(@InternalNodeMapID as nvarchar(50)))
				SET @NodeID = @@IDENTITY
				-- Update the InternalNodeMap, given the NodeID
				UPDATE [RDF.Stage].[InternalNodeMap]
					SET NodeID = @NodeID, Status = 0,
						ValueHash = [RDF.].fnValueHash(null,null,@baseURI+cast(@NodeID as nvarchar(50)))
					WHERE InternalNodeMapID = @InternalNodeMapID
				-- Update the Node, given the NodeID
				UPDATE [RDF.].[Node]
					SET Value = @baseURI+cast(@NodeID as nvarchar(50)),
						ValueHash = [RDF.].fnValueHash(null,null,@baseURI+cast(@NodeID as nvarchar(50)))
					WHERE NodeID = @NodeID
			END
		IF @Category = 7
			BEGIN
				-- Create the Node
				DECLARE @TempValue varchar(50)
				SELECT @TempValue = '#NODE'+cast(NewID() as varchar(50))
				INSERT INTO [RDF.].[Node] (ViewSecurityGroup, EditSecurityGroup, Value, ObjectType, ValueHash)
					SELECT @ViewSecurityGroup, @EditSecurityGroup, @TempValue, 0, [RDF.].[fnValueHash](NULL,NULL,@TempValue)
				SET @NodeID = @@IDENTITY
				-- Update the Node, given the NodeID
				UPDATE [RDF.].[Node]
					SET Value = @baseURI+cast(@NodeID as nvarchar(50)),
						ValueHash = [RDF.].fnValueHash(null,null,@baseURI+cast(@NodeID as nvarchar(50)))
					WHERE NodeID = @NodeID
			END
		IF @Category = 8
			BEGIN
				-- Create the new node
				EXEC [RDF.].GetStoreNode	@DefaultURI = 1,
											@ViewSecurityGroup = @ViewSecurityGroup,
											@EditSecurityGroup = @EditSecurityGroup,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT,
											@NodeID = @NodeID OUTPUT
				IF @Error = 1
				BEGIN
					RETURN
				END
				-- Convert URIs to NodeIDs
				DECLARE @TypeID BIGINT
				DECLARE @LabelID BIGINT
				DECLARE @ClassID BIGINT
				DECLARE @SubClassID BIGINT
				SELECT	@TypeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
						@LabelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label'),
						@ClassID = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#Class'),
						@SubClassID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#subClassOf')
				-- Add class(es) to new node
				DECLARE @TempClassID BIGINT
				SELECT @TempClassID = @EntityClassID
				WHILE (@TempClassID IS NOT NULL)
				BEGIN
					EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
												@PredicateID = @TypeID,
												@ObjectID = @TempClassID,
												@ViewSecurityGroup = -1,
												@Weight = 1,
												@SessionID = @SessionID,
												@Error = @Error OUTPUT
					IF @Error = 1
					BEGIN
						RETURN
					END
					-- Determine if there is a parent class
					SELECT @TempClassID = (
							SELECT TOP 1 t.object
							FROM [RDF.].Triple t, [RDF.].Triple c
							WHERE t.subject = @TempClassID
								AND t.predicate = @SubClassID
								AND c.subject = t.object
								AND c.predicate = @TypeID
								AND c.object = @ClassID
								AND NOT EXISTS (
									SELECT *
									FROM [RDF.].Triple v
									WHERE v.subject = @NodeID
										AND v.predicate = @TypeID
										AND v.object = t.object
								)
						)
				END
				-- Get node ID for label
				DECLARE @LabelNodeID BIGINT
				EXEC [RDF.].GetStoreNode	@Value = @Label,
											@ObjectType = 1,
											@ViewSecurityGroup = -1,
											@EditSecurityGroup = -40,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT,
											@NodeID = @LabelNodeID OUTPUT
				IF @Error = 1
				BEGIN
					RETURN
				END
				-- Add label to new node
				EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
											@PredicateID = @LabelID,
											@ObjectID = @LabelNodeID,
											@ViewSecurityGroup = -1,
											@Weight = 1,
											@SortOrder = 1,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT
				IF @Error = 1
				BEGIN
					RETURN
				END
			END
		IF @Category = 9
			BEGIN
				-- We can't create a new node in this case, so throw an error
				SELECT @Error = 1
			END

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK

		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)

	END CATCH		
	END

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[GetDataRDF]
	@subject BIGINT=NULL,
	@predicate BIGINT=NULL,
	@object BIGINT=NULL,
	@offset BIGINT=NULL,
	@limit BIGINT=NULL,
	@showDetails BIT=1,
	@expand BIT=1,
	@SessionID UNIQUEIDENTIFIER=NULL,
	@NodeListXML XML=NULL,
	@ExpandRDFListXML XML=NULL,
	@returnXML BIT=1,
	@returnXMLasStr BIT=0,
	@dataStr NVARCHAR (MAX)=NULL OUTPUT,
	@dataStrDataType NVARCHAR (255)=NULL OUTPUT,
	@dataStrLanguage NVARCHAR (255)=NULL OUTPUT,
	@RDF XML=NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*

	This stored procedure returns the data for a node in RDF format.

	Input parameters:
		@subject		The NodeID whose RDF should be returned.
		@predicate		The predicate NodeID for a network.
		@object			The object NodeID for a connection.
		@offset			Pagination - The first object node to return.
		@limit			Pagination - The number of object nodes to return.
		@showDetails	If 1, then additional properties will be returned.
		@expand			If 1, then object properties will be expanded.
		@SessionID		The SessionID of the user requesting the data.

	There are two ways to call this procedure. By default, @returnXML = 1,
	and the RDF is returned as XML. When @returnXML = 0, the data is instead
	returned as the strings @dataStr, @dataStrDataType, and @dataStrLanguage.
	This second method of calling this procedure is used by other procedures
	and is generally not called directly by the website.

	The RDF returned by this procedure is not equivalent to what is
	returned by SPARQL. This procedure applies security rules, expands
	nodes as defined by [Ontology.].[RDFExpand], and calculates network
	information on-the-fly.

	*/

	declare @d datetime

	declare @baseURI nvarchar(400)
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'

	select @subject = null where @subject = 0
	select @predicate = null where @predicate = 0
	select @object = null where @object = 0

	declare @firstURI nvarchar(400)
	select @firstURI = @baseURI+cast(@subject as varchar(50))

	declare @firstValue nvarchar(400)
	select @firstValue = null

	declare @typeID bigint
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')

	declare @labelID bigint
	select @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')	

	--*******************************************************************************************
	--*******************************************************************************************
	-- Define temp tables
	--*******************************************************************************************
	--*******************************************************************************************

	/*
		drop table #subjects
		drop table #types
		drop table #expand
		drop table #properties
		drop table #connections
	*/

	create table #subjects (
		subject bigint primary key,
		showDetail bit,
		expanded bit,
		uri nvarchar(400)
	)

	create table #types (
		subject bigint not null,
		object bigint not null,
		predicate bigint,
		showDetail bit,
		uri nvarchar(400)
	)
	create unique clustered index idx_sop on #types (subject,object,predicate)

	create table #expand (
		subject bigint not null,
		predicate bigint not null,
		uri nvarchar(400),
		property nvarchar(400),
		tagName nvarchar(1000),
		propertyLabel nvarchar(400),
		IsDetail bit,
		limit bigint,
		showStats bit,
		showSummary bit
	)
	alter table #expand add primary key (subject,predicate)

	create table #properties (
		uri nvarchar(400),
		subject bigint,
		predicate bigint,
		object bigint,
		showSummary bit,
		property nvarchar(400),
		tagName nvarchar(1000),
		propertyLabel nvarchar(400),
		Language nvarchar(255),
		DataType nvarchar(255),
		Value nvarchar(max),
		ObjectType bit,
		SortOrder int
	)

	create table #connections (
		subject bigint,
		subjectURI nvarchar(400),
		predicate bigint,
		predicateURI nvarchar(400),
		object bigint,
		Language nvarchar(255),
		DataType nvarchar(255),
		Value nvarchar(max),
		ObjectType bit,
		SortOrder int,
		Weight float,
		Reitification bigint,
		ReitificationURI nvarchar(400),
		connectionURI nvarchar(400)
	)

	create table #ClassPropertyCustom (
		ClassPropertyID int primary key,
		IncludeProperty bit,
		Limit int,
		IncludeNetwork bit,
		IncludeDescription bit
	)

	--*******************************************************************************************
	--*******************************************************************************************
	-- Setup variables used for security
	--*******************************************************************************************
	--*******************************************************************************************

	DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT, @HasSecurityGroupNodes BIT
	EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
	CREATE TABLE #SecurityGroupNodes (SecurityGroupNode BIGINT PRIMARY KEY)
	INSERT INTO #SecurityGroupNodes (SecurityGroupNode) EXEC [RDF.Security].GetSessionSecurityGroupNodes @SessionID, @Subject
	SELECT @HasSecurityGroupNodes = (CASE WHEN EXISTS (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END)


	--*******************************************************************************************
	--*******************************************************************************************
	-- Get subject information when it is a literal
	--*******************************************************************************************
	--*******************************************************************************************

	select @dataStr = Value, @dataStrDataType = DataType, @dataStrLanguage = Language
		from [RDF.].Node
		where NodeID = @subject and ObjectType = 1
			and ( (ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )


	--*******************************************************************************************
	--*******************************************************************************************
	-- Seed temp tables
	--*******************************************************************************************
	--*******************************************************************************************

	---------------------------------------------------------------------------------------------
	-- Profile [seed with the subject(s)]
	---------------------------------------------------------------------------------------------
	if (@subject is not null) and (@predicate is null) and (@object is null)
	begin
		insert into #subjects(subject,showDetail,expanded,URI)
			select NodeID, @showDetails, 0, Value
				from [RDF.].Node
				where NodeID = @subject
					and ((ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
		select @firstValue = URI
			from #subjects s, [RDF.].Node n
			where s.subject = @subject
				and s.subject = n.NodeID and n.ObjectType = 0
	end
	if (@NodeListXML is not null)
	begin
		insert into #subjects(subject,showDetail,expanded,URI)
			select n.NodeID, t.ShowDetails, 0, n.Value
			from [RDF.].Node n, (
				select NodeID, MAX(ShowDetails) ShowDetails
				from (
					select x.value('@ID','bigint') NodeID, IsNull(x.value('@ShowDetails','tinyint'),0) ShowDetails
					from @NodeListXML.nodes('//Node') as N(x)
				) t
				group by NodeID
				having NodeID not in (select subject from #subjects)
			) t
			where n.NodeID = t.NodeID and n.ObjectType = 0
	end

	---------------------------------------------------------------------------------------------
	-- Get all connections
	---------------------------------------------------------------------------------------------
	insert into #connections (subject, subjectURI, predicate, predicateURI, object, Language, DataType, Value, ObjectType, SortOrder, Weight, Reitification, ReitificationURI, connectionURI)
		select	s.NodeID subject, s.value subjectURI, 
				p.NodeID predicate, p.value predicateURI,
				t.object, o.Language, o.DataType, o.Value, o.ObjectType,
				t.SortOrder, t.Weight, 
				r.NodeID Reitification, r.Value ReitificationURI,
				@baseURI+cast(@subject as varchar(50))+'/'+cast(@predicate as varchar(50))+'/'+cast(object as varchar(50)) connectionURI
			from [RDF.].Triple t
				inner join [RDF.].Node s
					on t.subject = s.NodeID
				inner join [RDF.].Node p
					on t.predicate = p.NodeID
				inner join [RDF.].Node o
					on t.object = o.NodeID
				left join [RDF.].Node r
					on t.reitification = r.NodeID
						and t.reitification is not null
						and ((r.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (r.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (r.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
			where @subject is not null and @predicate is not null
				and s.NodeID = @subject 
				and p.NodeID = @predicate 
				and o.NodeID = IsNull(@object,o.NodeID)
				and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
				and ((s.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (s.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (s.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
				and ((p.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (p.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (p.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
				and ((o.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (o.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (o.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))

	---------------------------------------------------------------------------------------------
	-- Network [seed with network statistics and connections]
	---------------------------------------------------------------------------------------------
	if (@subject is not null) and (@predicate is not null) and (@object is null)
	begin
		select @firstURI = @baseURI+cast(@subject as varchar(50))+'/'+cast(@predicate as varchar(50))
		-- Basic network properties
		;with networkProperties as (
			select 1 n, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' property, 'rdf:type' tagName, 'type' propertyLabel, 0 ObjectType
			union all select 2, 'http://profiles.catalyst.harvard.edu/ontology/prns#numberOfConnections', 'prns:numberOfConnections', 'number of connections', 1
			union all select 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#maxWeight', 'prns:maxWeight', 'maximum connection weight', 1
			union all select 4, 'http://profiles.catalyst.harvard.edu/ontology/prns#minWeight', 'prns:minWeight', 'minimum connection weight', 1
			union all select 5, 'http://profiles.catalyst.harvard.edu/ontology/prns#predicateNode', 'prns:predicateNode', 'predicate node', 0
			union all select 6, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate', 'rdf:predicate', 'predicate', 0
			union all select 7, 'http://www.w3.org/2000/01/rdf-schema#label', 'rdfs:label', 'label', 1
			union all select 8, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#subject', 'rdf:subject', 'subject', 0
		), networkStats as (
			select	cast(isnull(count(*),0) as varchar(50)) numberOfConnections,
					cast(isnull(max(Weight),1) as varchar(50)) maxWeight,
					cast(isnull(min(Weight),1) as varchar(50)) minWeight,
					max(predicateURI) predicateURI
				from #connections
		), subjectLabel as (
			select IsNull(Max(o.Value),'') Label
			from [RDF.].Triple t, [RDF.].Node o
			where t.subject = @subject
				and t.predicate = @labelID
				and t.object = o.NodeID
				and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
				and ((o.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (o.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (o.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
		)
		insert into #properties (uri,predicate,property,tagName,propertyLabel,Value,ObjectType,SortOrder)
			select	@firstURI,
					[RDF.].fnURI2NodeID(p.property), p.property, p.tagName, p.propertyLabel,
					(case p.n when 1 then 'http://profiles.catalyst.harvard.edu/ontology/prns#Network'
								when 2 then n.numberOfConnections
								when 3 then n.maxWeight
								when 4 then n.minWeight
								when 5 then @baseURI+cast(@predicate as varchar(50))
								when 6 then n.predicateURI
								when 7 then l.Label
								when 8 then @baseURI+cast(@subject as varchar(50))
								end),
					p.ObjectType,
					1
				from networkStats n, networkProperties p, subjectLabel l
		-- Remove connections not within offset-limit window
		delete from #connections
			where (SortOrder < 1+IsNull(@offset,0)) or (SortOrder > IsNull(@limit,SortOrder) + (case when IsNull(@offset,0)<1 then 0 else @offset end))
		-- Add hasConnection properties
		insert into #properties (uri,predicate,property,tagName,propertyLabel,Value,ObjectType,SortOrder)
			select	@baseURI+cast(@subject as varchar(50))+'/'+cast(@predicate as varchar(50)),
					[RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#hasConnection'), 
					'http://profiles.catalyst.harvard.edu/ontology/prns#hasConnection', 'prns:hasConnection', 'has connection',
					connectionURI,
					0,
					SortOrder
				from #connections
	end

	---------------------------------------------------------------------------------------------
	-- Connection [seed with connection]
	---------------------------------------------------------------------------------------------
	if (@subject is not null) and (@predicate is not null) and (@object is not null)
	begin
		select @firstURI = @baseURI+cast(@subject as varchar(50))+'/'+cast(@predicate as varchar(50))+'/'+cast(@object as varchar(50))
	end

	---------------------------------------------------------------------------------------------
	-- Expanded Connections [seed with statistics, subject, object, and connectionDetails]
	---------------------------------------------------------------------------------------------
	if (@expand = 1 or @object is not null) and exists (select * from #connections)
	begin
		-- Connection statistics
		;with connectionProperties as (
			select 1 n, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' property, 'rdf:type' tagName, 'type' propertyLabel, 0 ObjectType
			union all select 2, 'http://profiles.catalyst.harvard.edu/ontology/prns#connectionWeight', 'prns:connectionWeight', 'connection weight', 1
			union all select 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#sortOrder', 'prns:sortOrder', 'sort order', 1
			union all select 4, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#object', 'rdf:object', 'object', 0
			union all select 5, 'http://profiles.catalyst.harvard.edu/ontology/prns#hasConnectionDetails', 'prns:hasConnectionDetails', 'connection details', 0
			union all select 6, 'http://profiles.catalyst.harvard.edu/ontology/prns#predicateNode', 'prns:predicateNode', 'predicate node', 0
			union all select 7, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate', 'rdf:predicate', 'predicate', 0
			union all select 8, 'http://www.w3.org/2000/01/rdf-schema#label', 'rdfs:label', 'label', 1
			union all select 9, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#subject', 'rdf:subject', 'subject', 0
			union all select 10, 'http://profiles.catalyst.harvard.edu/ontology/prns#connectionInNetwork', 'prns:connectionInNetwork', 'connection in network', 0
		)
		insert into #properties (uri,predicate,property,tagName,propertyLabel,Value,ObjectType,SortOrder)
			select	connectionURI,
					[RDF.].fnURI2NodeID(p.property), p.property, p.tagName, p.propertyLabel,
					(case p.n	when 1 then 'http://profiles.catalyst.harvard.edu/ontology/prns#Connection'
								when 2 then cast(c.Weight as varchar(50))
								when 3 then cast(c.SortOrder as varchar(50))
								when 4 then c.value
								when 5 then c.ReitificationURI
								when 6 then @baseURI+cast(@predicate as varchar(50))
								when 7 then c.predicateURI
								when 8 then l.value
								when 9 then c.subjectURI
								when 10 then c.subjectURI+'/'+cast(@predicate as varchar(50))
								end),
					(case p.n when 4 then c.ObjectType else p.ObjectType end),
					1
				from #connections c, connectionProperties p
					left outer join (
						select o.value
							from [RDF.].Triple t, [RDF.].Node o
							where t.subject = @subject 
								and t.predicate = @labelID
								and t.object = o.NodeID
								and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
								and ((o.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (o.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (o.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
					) l on p.n = 8
				where (p.n < 5) 
					or (p.n = 5 and c.ReitificationURI is not null)
					or (p.n > 5 and @object is not null)
		if (@expand = 1)
		begin
			-- Connection subject
			insert into #subjects (subject, showDetail, expanded, URI)
				select NodeID, 0, 0, Value
					from [RDF.].Node
					where NodeID = @subject
			-- Connection objects
			insert into #subjects (subject, showDetail, expanded, URI)
				select object, 0, 0, value
					from #connections
					where ObjectType = 0 and object not in (select subject from #subjects)
			-- Connection details (reitifications)
			insert into #subjects (subject, showDetail, expanded, URI)
				select Reitification, 0, 0, ReitificationURI
					from #connections
					where Reitification is not null and Reitification not in (select subject from #subjects)
		end
	end

	--*******************************************************************************************
	--*******************************************************************************************
	-- Get property values
	--*******************************************************************************************
	--*******************************************************************************************

	-- Get custom settings to override the [Ontology.].[ClassProperty] default values
	insert into #ClassPropertyCustom (ClassPropertyID, IncludeProperty, Limit, IncludeNetwork, IncludeDescription)
		select p.ClassPropertyID, t.IncludeProperty, t.Limit, t.IncludeNetwork, t.IncludeDescription
			from [Ontology.].[ClassProperty] p
				inner join (
					select	x.value('@Class','varchar(400)') Class,
							x.value('@NetworkProperty','varchar(400)') NetworkProperty,
							x.value('@Property','varchar(400)') Property,
							(case x.value('@IncludeProperty','varchar(5)') when 'true' then 1 when 'false' then 0 else null end) IncludeProperty,
							x.value('@Limit','int') Limit,
							(case x.value('@IncludeNetwork','varchar(5)') when 'true' then 1 when 'false' then 0 else null end) IncludeNetwork,
							(case x.value('@IncludeDescription','varchar(5)') when 'true' then 1 when 'false' then 0 else null end) IncludeDescription
					from @ExpandRDFListXML.nodes('//ExpandRDF') as R(x)
				) t
				on p.Class=t.Class and p.Property=t.Property
					and ((p.NetworkProperty is null and t.NetworkProperty is null) or (p.NetworkProperty = t.NetworkProperty))

	-- Get properties and loop if objects need to be expanded
	declare @numLoops int
	declare @maxLoops int
	declare @actualLoops int
	declare @NewSubjects int
	select @numLoops = 0, @maxLoops = 10, @actualLoops = 0
	while (@numLoops < @maxLoops)
	begin
		-- Get the types of each subject that hasn't been expanded
		truncate table #types
		insert into #types(subject,object,predicate,showDetail,uri)
			select s.subject, t.object, null, s.showDetail, s.uri
				from #subjects s 
					inner join [RDF.].Triple t on s.subject = t.subject 
						and t.predicate = @typeID 
					inner join [RDF.].Node n on t.object = n.NodeID
						and ((n.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (n.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN n.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
						and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
				where s.expanded = 0				   
		-- Get the subject types of each reitification that hasn't been expanded
		insert into #types(subject,object,predicate,showDetail,uri)
		select distinct s.subject, t.object, r.predicate, s.showDetail, s.uri
			from #subjects s 
				inner join [RDF.].Triple r on s.subject = r.reitification
				inner join [RDF.].Triple t on r.subject = t.subject 
					and t.predicate = @typeID 
				inner join [RDF.].Node n on t.object = n.NodeID
					and ((n.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (n.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN n.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
					and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
					and ((r.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (r.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN r.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
			where s.expanded = 0
		-- Get the items that should be expanded
		truncate table #expand
		insert into #expand(subject, predicate, uri, property, tagName, propertyLabel, IsDetail, limit, showStats, showSummary)
			select p.subject, o._PropertyNode, max(p.uri) uri, o.property, o._TagName, o._PropertyLabel, min(o.IsDetail*1) IsDetail, 
					(case when min(o.IsDetail*1) = 0 then max(case when o.IsDetail=0 then IsNull(c.limit,o.limit) else null end) else max(IsNull(c.limit,o.limit)) end) limit,
					(case when min(o.IsDetail*1) = 0 then max(case when o.IsDetail=0 then IsNull(c.IncludeNetwork,o.IncludeNetwork)*1 else 0 end) else max(IsNull(c.IncludeNetwork,o.IncludeNetwork)*1) end) showStats,
					(case when min(o.IsDetail*1) = 0 then max(case when o.IsDetail=0 then IsNull(c.IncludeDescription,o.IncludeDescription)*1 else 0 end) else max(IsNull(c.IncludeDescription,o.IncludeDescription)*1) end) showSummary
				from #types p
					inner join [Ontology.].ClassProperty o
						on p.object = o._ClassNode 
						and ((p.predicate is null and o._NetworkPropertyNode is null) or (p.predicate = o._NetworkPropertyNode))
						and o.IsDetail <= p.showDetail
					left outer join #ClassPropertyCustom c
						on o.ClassPropertyID = c.ClassPropertyID
				where IsNull(c.IncludeProperty,1) = 1
				group by p.subject, o.property, o._PropertyNode, o._TagName, o._PropertyLabel
		-- Get the values for each property that should be expanded
		insert into #properties (uri,subject,predicate,object,showSummary,property,tagName,propertyLabel,Language,DataType,Value,ObjectType,SortOrder)
			select e.uri, e.subject, t.predicate, t.object, e.showSummary,
					e.property, e.tagName, e.propertyLabel, 
					o.Language, o.DataType, o.Value, o.ObjectType, t.SortOrder
			from #expand e
				inner join [RDF.].Triple t
					on t.subject = e.subject and t.predicate = e.predicate
						and (e.limit is null or t.sortorder <= e.limit)
						and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
				inner join [RDF.].Node p
					on t.predicate = p.NodeID
						and ((p.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (p.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN p.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
				inner join [RDF.].Node o
					on t.object = o.NodeID
						and ((o.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (o.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN o.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
		-- Get network properties
		if (@numLoops = 0)
		begin
			-- Calculate network statistics
			select e.uri, e.subject, t.predicate, e.property, e.tagName, e.PropertyLabel, 
					cast(isnull(count(*),0) as varchar(50)) numberOfConnections,
					cast(isnull(max(t.Weight),1) as varchar(50)) maxWeight,
					cast(isnull(min(t.Weight),1) as varchar(50)) minWeight,
					@baseURI+cast(e.subject as varchar(50))+'/'+cast(t.predicate as varchar(50)) networkURI
				into #networks
				from #expand e
					inner join [RDF.].Triple t
						on t.subject = e.subject and t.predicate = e.predicate
							and (e.showStats = 1)
							and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
					inner join [RDF.].Node p
						on t.predicate = p.NodeID
							and ((p.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (p.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN p.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
					inner join [RDF.].Node o
						on t.object = o.NodeID
							and ((o.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (o.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN o.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
				group by e.uri, e.subject, t.predicate, e.property, e.tagName, e.PropertyLabel
			-- Create properties from network statistics
			;with networkProperties as (
				select 1 n, 'http://profiles.catalyst.harvard.edu/ontology/prns#hasNetwork' property, 'prns:hasNetwork' tagName, 'has network' propertyLabel, 0 ObjectType
				union all select 2, 'http://profiles.catalyst.harvard.edu/ontology/prns#numberOfConnections', 'prns:numberOfConnections', 'number of connections', 1
				union all select 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#maxWeight', 'prns:maxWeight', 'maximum connection weight', 1
				union all select 4, 'http://profiles.catalyst.harvard.edu/ontology/prns#minWeight', 'prns:minWeight', 'minimum connection weight', 1
				union all select 5, 'http://profiles.catalyst.harvard.edu/ontology/prns#predicateNode', 'prns:predicateNode', 'predicate node', 0
				union all select 6, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate', 'rdf:predicate', 'predicate', 0
				union all select 7, 'http://www.w3.org/2000/01/rdf-schema#label', 'rdfs:label', 'label', 1
				union all select 8, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', 'rdf:type', 'type', 0
			)
			insert into #properties (uri,subject,predicate,property,tagName,propertyLabel,Value,ObjectType,SortOrder)
				select	(case p.n when 1 then n.uri else n.networkURI end),
						(case p.n when 1 then subject else null end),
						[RDF.].fnURI2NodeID(p.property), p.property, p.tagName, p.propertyLabel,
						(case p.n when 1 then n.networkURI 
									when 2 then n.numberOfConnections
									when 3 then n.maxWeight
									when 4 then n.minWeight
									when 5 then @baseURI+cast(n.predicate as varchar(50))
									when 6 then n.property
									when 7 then n.PropertyLabel
									when 8 then 'http://profiles.catalyst.harvard.edu/ontology/prns#Network'
									end),
						p.ObjectType,
						1
					from #networks n, networkProperties p
					where p.n = 1 or @expand = 1
		end
		-- Mark that all previous subjects have been expanded
		update #subjects set expanded = 1 where expanded = 0
		-- See if there are any new subjects that need to be expanded
		insert into #subjects(subject,showDetail,expanded,uri)
			select distinct object, 0, 0, value
				from #properties
				where showSummary = 1
					and ObjectType = 0
					and object not in (select subject from #subjects)
		select @NewSubjects = @@ROWCOUNT		
		insert into #subjects(subject,showDetail,expanded,uri)
			select distinct predicate, 0, 0, property
				from #properties
				where predicate is not null
					and predicate not in (select subject from #subjects)
		-- If no subjects need to be expanded, then we are done
		if @NewSubjects + @@ROWCOUNT = 0
			select @numLoops = @maxLoops
		select @numLoops = @numLoops + 1 + @maxLoops * (1 - @expand)
		select @actualLoops = @actualLoops + 1
	end
	-- Add tagName as a property of DatatypeProperty and ObjectProperty classes
	insert into #properties (uri, subject, showSummary, property, tagName, propertyLabel, Value, ObjectType, SortOrder)
		select p.uri, p.subject, 0, 'http://profiles.catalyst.harvard.edu/ontology/prns#tagName', 'prns:tagName', 'tag name', 
				n.prefix+':'+substring(p.uri,len(n.uri)+1,len(p.uri)), 1, 1
			from #properties p, [Ontology.].Namespace n
			where p.property = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
				and p.value in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
				and p.uri like n.uri+'%'
	--select @actualLoops
	--select * from #properties order by (case when uri = @firstURI then 0 else 1 end), uri, tagName, value


	--*******************************************************************************************
	--*******************************************************************************************
	-- Handle the special case where a local node is storing a copy of an external URI
	--*******************************************************************************************
	--*******************************************************************************************

	if (@firstValue IS NOT NULL) AND (@firstValue <> @firstURI)
		insert into #properties (uri, subject, predicate, object, 
				showSummary, property, 
				tagName, propertyLabel, 
				Language, DataType, Value, ObjectType, SortOrder
			)
			select @firstURI uri, @subject subject, predicate, object, 
					showSummary, property, 
					tagName, propertyLabel, 
					Language, DataType, Value, ObjectType, 1 SortOrder
				from #properties
				where uri = @firstValue
					and not exists (select * from #properties where uri = @firstURI)
			union all
			select @firstURI uri, @subject subject, null predicate, null object, 
					0 showSummary, 'http://www.w3.org/2002/07/owl#sameAs' property,
					'owl:sameAs' tagName, 'same as' propertyLabel, 
					null Language, null DataType, @firstValue Value, 0 ObjectType, 1 SortOrder

	--*******************************************************************************************
	--*******************************************************************************************
	-- Generate an XML string from the node properties table
	--*******************************************************************************************
	--*******************************************************************************************

	declare @description nvarchar(max)
	select @description = ''
	-- sort the tags
	select *, 
			row_number() over (partition by uri order by i) j, 
			row_number() over (partition by uri order by i desc) k 
		into #propertiesSorted
		from (
			select *, row_number() over (order by (case when uri = @firstURI then 0 else 1 end), uri, tagName, SortOrder, value) i
				from #properties
		) t
	create unique clustered index idx_i on #propertiesSorted(i)
	-- handle special xml characters in the uri and value strings
	update #propertiesSorted
		set uri = replace(replace(replace(uri,'&','&amp;'),'<','&lt;'),'>','&gt;')
		where uri like '%[&<>]%'
	update #propertiesSorted
		set value = replace(replace(replace(value,'&','&amp;'),'<','&lt;'),'>','&gt;')
		where value like '%[&<>]%'
	-- concatenate the tags
	select @description = (
			select (case when j=1 then '<rdf:Description rdf:about="' + uri + '">' else '' end)
					+'<'+tagName
					+(case when ObjectType = 0 then ' rdf:resource="'+value+'"/>' else '>'+value+'</'+tagName+'>' end)
					+(case when k=1 then '</rdf:Description>' else '' end)
			from #propertiesSorted
			order by i
			for xml path(''), type
		).value('(./text())[1]','nvarchar(max)')
	-- default description if none exists
	if @description IS NULL
		select @description = '<rdf:Description rdf:about="' + @firstURI + '"'
			+IsNull(' xml:lang="'+@dataStrLanguage+'"','')
			+IsNull(' rdf:datatype="'+@dataStrDataType+'"','')
			+IsNull(' >'+replace(replace(replace(@dataStr,'&','&amp;'),'<','&lt;'),'>','&gt;')+'</rdf:Description>',' />')


	--*******************************************************************************************
	--*******************************************************************************************
	-- Return as a string or as XML
	--*******************************************************************************************
	--*******************************************************************************************

	select @dataStr = IsNull(@dataStr,@description)

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + @description + '</rdf:RDF>'

	if @returnXML = 1 and @returnXMLasStr = 0

		select cast(replace(@x,char(13),'&#13;') as xml) RDF

	if @returnXML = 1 and @returnXMLasStr = 1
		select @x RDF

	/*	
		declare @d datetime
		select @d = getdate()
		select datediff(ms,@d,getdate())
	*/

END


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.].[GetPresentationXML]
@subject BIGINT=NULL, @predicate BIGINT=NULL, @object BIGINT=NULL, @subjectType BIGINT=NULL, @objectType BIGINT=NULL, @SessionID UNIQUEIDENTIFIER=NULL, @EditMode BIT=0, @returnXML BIT=1, @PresentationXML XML=NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @typeID bigint
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')

	select @subject = null where @subject = 0
	select @predicate = null where @predicate = 0
	select @object = null where @object = 0

	declare @SecurityGroupListXML xml
	select @SecurityGroupListXML = NULL

	declare @NetworkNode bigint
	declare @ConnectionNode bigint
	select	@NetworkNode = [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#Network'),
			@ConnectionNode = [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#Connection')


	-------------------------------------------------------------------------------
	-- Determine the PresentationType (P = profile, N = network, C = connection)
	-------------------------------------------------------------------------------

	declare @PresentationType char(1)
	select @PresentationType = (case when IsNull(@object,@objectType) is not null AND @predicate is not null AND IsNull(@subject,@subjectType) is not null then 'C'
									when @predicate is not null AND IsNull(@subject,@subjectType) is not null then 'N'
									when IsNull(@subject,@subjectType) is not null then 'P'
									else NULL end)

	-------------------------------------------------------------------------------
	-- Determine whether the user can edit this profile
	-------------------------------------------------------------------------------

	DECLARE @CanEdit BIT
	SELECT @CanEdit = 0
	DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT, @HasSpecialEditAccess BIT
	EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT, @HasSpecialEditAccess OUTPUT
	CREATE TABLE #SecurityGroupNodes (SecurityGroupNode BIGINT PRIMARY KEY)
	IF (@PresentationType = 'P') AND (@SessionID IS NOT NULL)
	BEGIN
		-- Get SecurityGroup nodes
		INSERT INTO #SecurityGroupNodes (SecurityGroupNode) EXEC [RDF.Security].GetSessionSecurityGroupNodes @SessionID, @Subject
		SELECT @CanEdit = 1
			FROM [RDF.].Node
			WHERE NodeID = @subject
				AND ( (EditSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )
		-- Get names/descriptions of different SecurityGroups
		IF @CanEdit = 1 AND @EditMode = 1
		BEGIN
			;WITH a AS (
				SELECT 1 x, m.NodeID SecurityGroupID, 'Only Me' Label, 'Only me and special authorized users who manage this website.' Description
					FROM [User.Session].[Session] s, [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
					WHERE s.SessionID = @SessionID AND s.UserID IS NOT NULL
						AND m.InternalID = s.UserID AND m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User' AND m.InternalType = 'User'
						AND n.NodeID = @Subject AND n.EditSecurityGroup = m.NodeID 
			), b AS (
				SELECT 2 x, n.EditSecurityGroup SecurityGroupID, 'Owner' Label, 'Only ' + IsNull(Max(o.Value),'') + ' and special authorized users who manage this website.' Description
					FROM [RDF.].Node n, [RDF.].Triple t, [RDF.].Node o
					WHERE n.NodeID = @Subject AND n.EditSecurityGroup > 0
						AND n.EditSecurityGroup NOT IN (SELECT SecurityGroupID FROM a)
						AND t.Subject = n.NodeID 
						AND t.Predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label') 
						AND t.Object = o.NodeID
						AND ( (n.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (n.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (n.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )
						AND ( (t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )
						AND ( (o.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (o.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (o.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )
					GROUP BY n.EditSecurityGroup
			), c AS (
				SELECT 3 x, SecurityGroupID, Label, Description
					FROM [RDF.Security].[Group]
					WHERE SecurityGroupID between @SecurityGroupID and -1
				UNION ALL SELECT * FROM a
				UNION ALL SELECT * FROM b
			)
			SELECT @SecurityGroupListXML = (
				SELECT	SecurityGroupID "@ID",
						Label "@Label",
						Description "@Description"
					FROM c
					ORDER BY x, SecurityGroupID
					FOR XML PATH('SecurityGroup'), TYPE
			)
		END
	END

	-------------------------------------------------------------------------------
	-- Get the PresentationID based on type
	-------------------------------------------------------------------------------

	declare @PresentationID int
	select @PresentationID = (
			select top 1 PresentationID
				from [Ontology.Presentation].[XML]
				where type = (case when @EditMode = 1 then 'E' else IsNull(@PresentationType,'P') end)
					AND	(_SubjectNode IS NULL
							OR _SubjectNode = @subjectType
							OR _SubjectNode IN (select object from [RDF.].Triple where @subject is not null and subject=@subject and predicate=@typeID)
						)
					AND	(_PredicateNode IS NULL
							OR _PredicateNode = @predicate
						)
					AND	(_ObjectNode IS NULL
							OR _ObjectNode = @objectType
							OR _ObjectNode IN (select object from [RDF.].Triple where @object is not null and subject=@object and predicate=@typeID)
						)
				order by	(case when _ObjectNode is null then 1 else 0 end),
							(case when _PredicateNode is null then 1 else 0 end),
							(case when _SubjectNode is null then 1 else 0 end),
							PresentationID
		)

	-------------------------------------------------------------------------------
	-- Get the PropertyListXML based on type
	-------------------------------------------------------------------------------

	declare @PropertyListXML xml
	if @EditMode = 0
	begin
		-- View properties
		select @PropertyListXML = (
			select PropertyGroupURI "@URI", _PropertyGroupLabel "@Label", SortOrder "@SortOrder", x.query('.')
			from (
				select PropertyGroupURI, _PropertyGroupLabel, SortOrder,
				(
					select	a.URI "@URI", 
							a.TagName "@TagName", 
							a.Label "@Label", 
							p.SortOrder "@SortOrder",
							(case when a.CustomDisplay = 1 then 'true' else 'false' end) "@CustomDisplay",
							cast(a.CustomDisplayModule as xml)
					from [ontology.].PropertyGroupProperty p, (
						select NodeID,
							max(URI) URI, 
							max(TagName) TagName, 
							max(Label) Label,
							max(CustomDisplay) CustomDisplay,
							max(CustomDisplayModule) CustomDisplayModule
						from (
								select
									c._PropertyNode NodeID,
									c.Property URI,
									c._TagName TagName,
									c._PropertyLabel Label,
									cast(c.CustomDisplay as tinyint) CustomDisplay,
									IsNull(cast(c.CustomDisplayModule as nvarchar(max)),cast(p.CustomDisplayModule as nvarchar(max))) CustomDisplayModule
								from [Ontology.].ClassProperty c
									left outer join [Ontology.].PropertyGroupProperty p
									on c.Property = p.PropertyURI
								where c._ClassNode in (
									select object 
										from [RDF.].Triple 
										where subject=@subject and predicate=@typeID and @predicate is null and @object is null
									union all
									select @NetworkNode
										where @subject is not null and @predicate is not null and @object is null
									union all
									select @ConnectionNode
										where @subject is not null and @predicate is not null and @object is not null
								)
								and 1 = (case	when c._NetworkPropertyNode is null and @predicate is null then 1
												when c._NetworkPropertyNode is null and @predicate is not null and @object is null and c._ClassNode = @NetworkNode then 1
												when c._NetworkPropertyNode is null and @predicate is not null and @object is not null and c._ClassNode = @ConnectionNode then 1
												when c._NetworkPropertyNode = @predicate and @object is not null then 1
												else 0 end)
							) t
						group by NodeID
					) a
					where p._PropertyNode = a.NodeID and p._PropertyGroupNode = g._PropertyGroupNode
					order by p.SortOrder
					for xml path('Property'), type
				) x
				from [ontology.].PropertyGroup g
			) t
			where x is not null
			order by SortOrder
			for xml path('PropertyGroup'), type
		)
	end
	else
	begin
		-- Edit properties
		select @PropertyListXML = (
			select PropertyGroupURI "@URI", _PropertyGroupLabel "@Label", SortOrder "@SortOrder", x.query('.')
			from (
				select PropertyGroupURI, _PropertyGroupLabel, SortOrder,
				(
					select	a.URI "@URI", 
							a.TagName "@TagName", 
							a.Label "@Label", 
							p.SortOrder "@SortOrder",
							IsNull(s.ViewSecurityGroup,a.ViewSecurityGroup) "@ViewSecurityGroup",
							(case when a.CustomEdit = 1 then 'true' else 'false' end) "@CustomEdit",
							(case when a.EditPermissions = 1 then 'true' else 'false' end) "@EditPermissions",
							(case when a.EditExisting = 1 then 'true' else 'false' end) "@EditExisting",
							(case when a.EditAddNew = 1 then 'true' else 'false' end) "@EditAddNew",
							(case when a.EditAddExisting = 1 then 'true' else 'false' end) "@EditAddExisting",
							(case when a.EditDelete = 1 then 'true' else 'false' end) "@EditDelete",
							a.MinCardinality "@MinCardinality",
							a.MaxCardinality "@MaxCardinality",
							a.ObjectType "@ObjectType",
							(case when a.HasDataFeed = 1 then 'true' else 'false' end) "@HasDataFeed",
							cast(a.CustomEditModule as xml)
					from [ontology.].PropertyGroupProperty p inner join (
						select NodeID,
							max(URI) URI, 
							max(TagName) TagName, 
							max(Label) Label,
							max(ViewSecurityGroup) ViewSecurityGroup,
							max(CustomEdit) CustomEdit,
							max(EditPermissions) EditPermissions,
							max(EditExisting) EditExisting,
							max(EditAddNew) EditAddNew,
							max(EditAddExisting) EditAddExisting,
							max(EditDelete) EditDelete,
							min(MinCardinality) MinCardinality,
							max(MaxCardinality) MaxCardinality,
							max(cast(ObjectType as tinyint)) ObjectType,
							max(HasDataFeed) HasDataFeed,
							max(CustomEditModule) CustomEditModule
						from (
								select
									c._PropertyNode NodeID,
									c.Property URI,
									c._TagName TagName,
									c._PropertyLabel Label,
									c.ViewSecurityGroup,
									cast(c.CustomEdit as tinyint) CustomEdit,
									(case when ( (EditPermissionsSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditPermissionsSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditPermissionsSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) ) then 1 else 0 end) EditPermissions,
									(case when ( (EditExistingSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditExistingSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditExistingSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) ) then 1 else 0 end) EditExisting,
									(case when ( (EditAddNewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditAddNewSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditAddNewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) ) then 1 else 0 end) EditAddNew,
									(case when ( (EditAddExistingSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditAddExistingSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditAddExistingSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) ) then 1 else 0 end) EditAddExisting,
									(case when ( (EditDeleteSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditDeleteSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditDeleteSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) ) then 1 else 0 end) EditDelete,
									c.MinCardinality,
									c.MaxCardinality,
									c._ObjectType ObjectType,
									(case when d._PropertyNode is null then 0 else 1 end) HasDataFeed,
									IsNull(cast(c.CustomEditModule as nvarchar(max)),cast(p.CustomEditModule as nvarchar(max))) CustomEditModule
								from [Ontology.].ClassProperty c
									left outer join (
										select distinct _ClassNode, _PropertyNode
										from [Ontology.].DataMap
										where NetworkProperty is null and _ClassNode is not null and _PropertyNode is not null and IsAutoFeed = 1
									) d
										on c._ClassNode = d._ClassNode and c._PropertyNode = d._PropertyNode
									left outer join [Ontology.].PropertyGroupProperty p
										on c.Property = p.PropertyURI
								where c._ClassNode in (
									select object 
										from [RDF.].Triple 
										where subject=@subject and predicate=@typeID and @predicate is null and @object is null
								)
								and c.Property is not null
								and c.NetworkProperty is null
								and ( (EditSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (EditSecurityGroup > 0 AND @HasSpecialEditAccess = 1) OR (EditSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )
							) t
						group by NodeID
					) a
					on p._PropertyNode = a.NodeID and p._PropertyGroupNode = g._PropertyGroupNode
					left outer join [RDF.Security].NodeProperty s
					on s.NodeID = @subject and s.Property = p._PropertyNode 
					order by p.SortOrder
					for xml path('Property'), type
				) x
				from [ontology.].PropertyGroup g
			) t
			where x is not null
			order by SortOrder
			for xml path('PropertyGroup'), type
		)
	end	

	-------------------------------------------------------------------------------
	-- Combine the PresentationXML with property information
	-------------------------------------------------------------------------------

	select @PresentationXML = (
		select
			PresentationXML.value('Presentation[1]/@PresentationClass[1]','varchar(max)') "@PresentationClass",
			PresentationXML.value('Presentation[1]/PageOptions[1]/@Columns[1]','varchar(max)') "PageOptions/@Columns",
			(case when @CanEdit = 1 then 'true' else NULL end) "PageOptions/@CanEdit",
			(case when @CanEdit = 1 then 'true' else NULL end) "CanEdit",
			PresentationXML.query('Presentation[1]/WindowName[1]'),
			PresentationXML.query('Presentation[1]/PageColumns[1]'),
			PresentationXML.query('Presentation[1]/PageTitle[1]'),
			PresentationXML.query('Presentation[1]/PageBackLinkName[1]'),
			PresentationXML.query('Presentation[1]/PageBackLinkURL[1]'),
			PresentationXML.query('Presentation[1]/PageSubTitle[1]'),
			PresentationXML.query('Presentation[1]/PageDescription[1]'),
			PresentationXML.query('Presentation[1]/PanelTabType[1]'),
			PresentationXML.query('Presentation[1]/PanelList[1]'),
			PresentationXML.query('Presentation[1]/ExpandRDFList[1]'),
			@PropertyListXML "PropertyList",
			@SecurityGroupListXML "SecurityGroupList"
		from [Ontology.Presentation].[XML]
		where presentationid = @PresentationID
		for xml path('Presentation'), type
	)
	
	if @returnXML = 1
		select @PresentationXML PresentationXML

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[CustomEditAuthorInAuthorship.GetList]
@NodeID BIGINT=NULL, @SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN

	DECLARE @PersonID INT
 
	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
	SELECT r.Reference, (CASE WHEN r.PMID IS NOT NULL THEN 1 ELSE 0 END) FromPubMed, i.PubID, r.PMID, r.MPID, NULL Category, r.URL, r.EntityDate PubDate, r.EntityID, r.Source, r.IsActive, i.PersonID
		FROM [Profile.Data].[Publication.Person.Include] i
			INNER JOIN [Profile.Data].[Publication.Entity.InformationResource] r
				ON i.PMID = r.PMID AND i.PMID IS NOT NULL
				AND i.PersonID = @PersonID
	UNION ALL
	SELECT r.Reference, (CASE WHEN r.PMID IS NOT NULL THEN 1 ELSE 0 END) FromPubMed, i.PubID, r.PMID, r.MPID, g.HmsPubCategory Category, r.URL, r.EntityDate PubDate, r.EntityID, r.Source, r.IsActive, i.PersonID
		FROM [Profile.Data].[Publication.Person.Include] i
			INNER JOIN [Profile.Data].[Publication.Entity.InformationResource] r
				ON i.MPID = r.MPID AND i.PMID IS NULL AND i.MPID IS NOT NULL
				AND i.PersonID = @PersonID
			INNER JOIN [Profile.Data].[Publication.MyPub.General] g
				ON i.MPID = g.MPID
	ORDER BY EntityDate DESC, EntityID

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [User.Session].[CreateSession]
    @RequestIP VARCHAR(16),
    @UserAgent VARCHAR(500) = NULL,
    @UserID VARCHAR(200) = NULL,
	@SessionPersonNodeID BIGINT = NULL OUTPUT,
	@SessionPersonURI VARCHAR(400) = NULL OUTPUT
AS 
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON ;

	-- See if there is a PersonID associated with the user	
	DECLARE @PersonID INT
	IF @UserID IS NOT NULL
		SELECT @PersonID = PersonID
			FROM [User.Account].[User]
			WHERE UserID = @UserID

	-- Get the NodeID and URI of the PersonID
	IF @PersonID IS NOT NULL
	BEGIN
		SELECT @SessionPersonNodeID = m.NodeID, @SessionPersonURI = p.Value + CAST(m.NodeID AS VARCHAR(50))
			FROM [RDF.Stage].InternalNodeMap m, [Framework.].[Parameter] p
			WHERE m.InternalID = @PersonID
				AND m.InternalType = 'person'
				AND m.Class = 'http://xmlns.com/foaf/0.1/Person'
				AND p.ParameterID = 'baseURI'
	END

 
    DECLARE @SessionID UNIQUEIDENTIFIER
 BEGIN TRY 
	BEGIN TRANSACTION
 
		-- Create a SessionID
		SELECT @SessionID = NEWID()
 
		-- Create the Session table record
		INSERT INTO [User.Session].Session
			(	SessionID,
				CreateDate,
				LastUsedDate,
				LoginDate,
				LogoutDate,
				RequestIP,
				UserID,
				UserNode,
				PersonID,
				UserAgent,
				IsBot
			)
            SELECT  @SessionID ,
                    GETDATE() ,
                    GETDATE() ,
                    CASE WHEN @UserID IS NULL THEN NULL
                         ELSE GETDATE()
                    END ,
                    NULL ,
                    @RequestIP ,
                    @UserID ,
					(SELECT NodeID FROM [User.Account].[User] WHERE UserID = @UserID AND @UserID IS NOT NULL),
                    @PersonID,
                    @UserAgent,
                    0
                    
        -- Check if bot
        IF @UserAgent IS NOT NULL AND EXISTS (SELECT * FROM [User.Session].[Bot] WHERE @UserAgent LIKE UserAgent)
			UPDATE [User.Session].Session
				SET IsBot = 1
				WHERE SessionID = @SessionID

		-- Create a node
		DECLARE @Error INT
		DECLARE @NodeID BIGINT
		EXEC [RDF.].[GetStoreNode]	@DefaultURI = 1,
									@SessionID = @SessionID,
									@ViewSecurityGroup = 0,
									@EditSecurityGroup = -50,
									@Error = @Error OUTPUT,
									@NodeID = @NodeID OUTPUT

		-- If no error...
		IF (@Error = 0) AND (@NodeID IS NOT NULL)
		BEGIN
			-- Update the Session record with the NodeID
			UPDATE [User.Session].Session
				SET NodeID = @NodeID
				WHERE SessionID = @SessionID

			-- Update the ViewSecurityGroup of the session node
			UPDATE [RDF.].Node
				SET ViewSecurityGroup = @NodeID
				WHERE NodeID = @NodeID
 
			-- Add properties to the node
			DECLARE @TypeID BIGINT
			DECLARE @SessionClass BIGINT
			DECLARE @TripleID BIGINT
			SELECT	@TypeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
					@SessionClass = [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#Session')
			EXEC [RDF.].[GetStoreTriple]	@SubjectID = @NodeID,
											@PredicateID = @TypeID,
											@ObjectID = @SessionClass,
											@ViewSecurityGroup = @NodeID,
											@Weight = 1,
											@SortOrder = 1,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT,
											@TripleID = @TripleID OUTPUT
		END

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		

 
    SELECT *
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID AND @SessionID IS NOT NULL
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Person.AddPhoto]
	@PersonID INT,
	@Photo VARBINARY(MAX)=NULL,
	@PhotoLink NVARCHAR(MAX)=NULL
AS
BEGIN
	
	SET NOCOUNT ON;

	-- Only one custom photo per user, so replace any existing custom photos

	IF EXISTS (SELECT 1 FROM [Profile.Data].[Person.Photo] WHERE PersonID = @personid)
		BEGIN 
			UPDATE [Profile.Data].[Person.Photo] SET photo = @photo, PhotoLink = @PhotoLink WHERE PersonID = @personid 
		END
	ELSE 
		BEGIN 
			INSERT INTO [Profile.Data].[Person.Photo](PersonID ,Photo,PhotoLink) VALUES(@PersonID,@Photo,@PhotoLink)
		END 
	
	DECLARE @NodeID BIGINT
	DECLARE @URI VARCHAR(400)
	DECLARE @URINodeID BIGINT
	SELECT @NodeID = NodeID, @URI = URI
		FROM [Profile.Data].[vwPerson.Photo]
		WHERE PersonID = @PersonID
	IF (@NodeID IS NOT NULL AND @URI IS NOT NULL)
		BEGIN
			EXEC [RDF.].[GetStoreNode] @Value = @URI, @NodeID = @URINodeID OUTPUT
			IF (@URINodeID IS NOT NULL)
				EXEC [RDF.].[GetStoreTriple]	@SubjectID = @NodeID,
												@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#mainImage',
												@ObjectID = @URINodeID
		END
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.].[ParseSearchString]
	@SearchString VARCHAR(500) = NULL,
	@NumberOfPhrases INT = 0 OUTPUT,
	@CombinedSearchString VARCHAR(8000) = '' OUTPUT,
	@SearchPhraseXML XML = NULL OUTPUT,
	@SearchPhraseFormsXML XML = NULL OUTPUT,
	@ProcessTime INT = 0 OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

	-- Start timer
	declare @d datetime
	select @d = GetDate()


	-- Remove bad characters
	declare @SearchStringNormalized varchar(max)
	select @SearchStringNormalized = ''
	declare @StringPos int
	select @StringPos = 1
	declare @InQuotes tinyint
	select @InQuotes = 0
	declare @Char char(1)
	while @StringPos <= len(@SearchString)
	begin
		select @Char = substring(@SearchString,@StringPos,1)
		select @InQuotes = 1 - @InQuotes where @Char = '"'
		if @Char like '[0-9A-Za-z]'
			select @SearchStringNormalized = @SearchStringNormalized + @Char
		else if @Char = '"'
			select @SearchStringNormalized = @SearchStringNormalized + ' '
		else if right(@SearchStringNormalized,1) not in (' ','_')
			select @SearchStringNormalized = @SearchStringNormalized + (case when @InQuotes = 1 then '_' else ' ' end)
		select @StringPos = @StringPos + 1
	end
	select @SearchStringNormalized = replace(@SearchStringNormalized,'  ',' ')
	select @SearchStringNormalized = ' ' + ltrim(rtrim(replace(replace(' '+@SearchStringNormalized+' ',' _',' '),'_ ',' '))) + ' |'


	-- Find phrase positions
	declare @PhraseBreakPositions table (z int, n int, m int, i int)
	;with a as (
		select n.n, row_number() over (order by n.n) - 1 i
			from [Utility.Math].N n
			where n.n between 1 and len(@SearchStringNormalized) and substring(@SearchStringNormalized,n.n,1) = ' '
	), b as (
		select count(*)-1 j from a
	)
	insert into @PhraseBreakPositions
		select n.n z, a.n, a.i m, row_number() over (partition by n.n order by a.n) i
			from a, b, [Utility.Math].N n
			where n.n < Power(2,b.j-1)
				and 1 = (case when a.i=0 then 1 when a.i=b.j then 1 when Power(2,a.i-1) & n.n > 0 then 1 else 0 end)
	select @SearchStringNormalized = replace(@SearchStringNormalized,'_',' ')


	-- Extract phrases
	declare @TempPhraseList table (i int, w varchar(max), x int) 
	;with d as (
		select c.*, substring(@SearchStringNormalized,c.n+1,d.n-c.n-1) w, d.m-c.m l
			from @PhraseBreakPositions c, @PhraseBreakPositions d
			where c.z=d.z and c.i=d.i-1
	), e as (
		select d.*, IsNull(t.x,0) x
		from d outer apply (select top 1 1 x from [Utility.NLP].Thesaurus t where d.w = t.TermName) t
	), f as (
		select top 1 z
		from e
		group by z 
		order by sum(l*l*x) desc, z desc
	)
	insert into @TempPhraseList
		select row_number() over (order by e.i) i, e.w, e.x
			from e, f
			where e.z = f.z
				and e.w not in (select word from [Utility.NLP].StopWord where scope = 0)
				and e.w <> ''
	declare @PhraseList table (PhraseID int, Phrase varchar(max), ThesaurusMatch bit, Forms varchar(max))
	insert into @PhraseList (PhraseID, Phrase, ThesaurusMatch, Forms)
		select i, w, x, (case when x = 0 then '"'+[Utility.NLP].fnPorterAlgorithm(p.w)+'*"'
						else substring(cast( (
									select distinct ' OR "'+v.TermName+'"'
										from [Utility.NLP].Thesaurus t, [Utility.NLP].Thesaurus v
										where p.w=t.TermName and t.Source=v.Source and t.ConceptID=v.ConceptID
										for xml path(''), type
								) as varchar(max)),5,999999)
						end)
		from @TempPhraseList p
	select @NumberOfPhrases = (select max(PhraseID) from @PhraseList)
	select @SearchStringNormalized = substring(@SearchStringNormalized,2,len(@SearchStringNormalized)-3)


	-- Create a combined string for fulltext search
	select @CombinedSearchString = 
			(case when @NumberOfPhrases = 0 then ''
				when @NumberOfPhrases = 1 then
					'"'+@SearchStringNormalized+'" OR ' + (select Forms from @PhraseList)
				else
					'"'+@SearchStringNormalized+'"'
					+ ' OR '
					+ '(' + replace(@SearchStringNormalized,' ',' NEAR ') + ')'
					+ ' OR '
					+ '(' + substring(cast((select ' AND ('+Forms+')' from @PhraseList order by PhraseID for xml path(''), type) as varchar(max)),6,999999) + ')'
				end)
				
	
	-- Create an XML message listing the parsed phrases
	select @SearchPhraseXML =		(select
										(select PhraseID "SearchPhrase/@ID", 
											(case when ThesaurusMatch='1' then 'true' else 'false' end) "SearchPhrase/@ThesaurusMatch",
											Phrase "SearchPhrase"
										from @PhraseList
										order by PhraseID
										for xml path(''), type) "SearchPhraseList"
									for xml path(''), type)
	select @SearchPhraseFormsXML =	(select
										(select PhraseID "SearchPhrase/@ID", 
											(case when ThesaurusMatch='1' then 'true' else 'false' end) "SearchPhrase/@ThesaurusMatch",
											Forms "SearchPhrase/@Forms",
											Phrase "SearchPhrase"
										from @PhraseList
										order by PhraseID
										for xml path(''), type) "SearchPhraseList"
									for xml path(''), type)

					
	-- End timer
	select @ProcessTime = datediff(ms,@d,GetDate())

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [Utility.NLP].[fnNormalizeSplitStem]
	(
		@InWord nvarchar(4000)
	)
RETURNS 
	@words table (
		word varchar(255),word2 varchar(255)
	)
AS
BEGIN

	insert into @words (word,word2)
		select distinct [Utility.NLP].fnPorterAlgorithm(nref.value('.','varchar(max)')) word,nref.value('.','varchar(max)')  word2 
		from (
			select cast(replace(
				'<x><w>'+replace([Utility.NLP].fnNormalize(@InWord),' ','</w><w>')+'</w></x>',
				'<w></w>','') as xml) x
		) t
		cross apply x.nodes('//w') as R(nref)

    RETURN
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[CustomEditAwardOrHonor.StoreItem]
@ExistingAwardReceiptID BIGINT=NULL, @ExistingAwardReceiptURI VARCHAR (400)=NULL, @awardOrHonorForID BIGINT=NULL, @awardOrHonorForURI BIGINT=NULL, @label VARCHAR (MAX), @awardConferredBy VARCHAR (MAX)=NULL, @startDate VARCHAR (MAX)=NULL, @endDate VARCHAR (MAX)=NULL, @SessionID UNIQUEIDENTIFIER=NULL, @Error BIT=NULL OUTPUT, @NodeID BIGINT=NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*
	
	This stored procedure either creates or updates an
	AwardReceipt. In both cases a label is required.
	Nodes can be specified either by ID or URI.
	
	*/
	
	SELECT @Error = 0

	-------------------------------------------------
	-- Validate and prepare variables
	-------------------------------------------------
	
	-- Convert URIs to NodeIDs
 	IF (@ExistingAwardReceiptID IS NULL) AND (@ExistingAwardReceiptURI IS NOT NULL)
		SELECT @ExistingAwardReceiptID = [RDF.].fnURI2NodeID(@ExistingAwardReceiptURI)
 	IF (@awardOrHonorForID IS NULL) AND (@awardOrHonorForURI IS NOT NULL)
		SELECT @awardOrHonorForID = [RDF.].fnURI2NodeID(@awardOrHonorForURI)

	-- Check that some operation will be performed
	IF ((@ExistingAwardReceiptID IS NULL) AND (@awardOrHonorForID IS NULL)) OR (IsNull(@label,'') = '')
	BEGIN
		SELECT @Error = 1
		RETURN
	END

	-- Convert properties to NodeIDs
	DECLARE @awardConferredByNodeID BIGINT
	DECLARE @startDateNodeID BIGINT
	DECLARE @endDateNodeID BIGINT
	
	SELECT @awardConferredByNodeID = NULL, @startDateNodeID = NULL, @endDateNodeID = NULL
	
	IF IsNull(@awardConferredBy,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @awardConferredBy, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @awardConferredByNodeID OUTPUT
	IF IsNull(@startDate,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @startDate, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @startDateNodeID OUTPUT
	IF IsNull(@endDate,'')<>''
		EXEC [RDF.].GetStoreNode @Value = @endDate, @Language = NULL, @DataType = NULL,
			@SessionID = @SessionID, @Error = @Error OUTPUT, @NodeID = @endDateNodeID OUTPUT

	-------------------------------------------------
	-- Handle required nodes and properties
	-------------------------------------------------

	-- Get an AwardReceipt with just a label
	IF (@ExistingAwardReceiptID IS NOT NULL)
	BEGIN
		-- The AwardReceipt NodeID is the ExistingAwardReceipt
		SELECT @NodeID = @ExistingAwardReceiptID
		-- Delete any existing properties
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#awardConferredBy',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#startDate',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#endDate',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		EXEC [RDF.].DeleteTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://www.w3.org/2000/01/rdf-schema#label',
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		-- Add the label
		DECLARE @labelNodeID BIGINT
		EXEC [RDF.].GetStoreNode	@Value = @label, 
									@Language = NULL,
									@DataType = NULL,
									@SessionID = @SessionID, 
									@Error = @Error OUTPUT, 
									@NodeID = @labelNodeID OUTPUT
		EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://www.w3.org/2000/01/rdf-schema#label',
									@ObjectID = @labelNodeID,
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
	END
	ELSE
	BEGIN
		-- Create a new AwardReceipt
		EXEC [RDF.].GetStoreNode	@EntityClassURI = 'http://vivoweb.org/ontology/core#AwardReceipt',
									@Label = @label,
									@ForceNewEntity = 1,
									@SessionID = @SessionID, 
									@Error = @Error OUTPUT, 
									@NodeID = @NodeID OUTPUT
		-- Link the AwardReceipt to the awardOrHonorFor
		EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
									@PredicateURI = 'http://vivoweb.org/ontology/core#awardOrHonorFor',
									@ObjectID = @awardOrHonorForID,
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
		-- Link the awardOrHonorFor to the AwardReceipt
		EXEC [RDF.].GetStoreTriple	@SubjectID = @awardOrHonorForID,
									@PredicateURI = 'http://vivoweb.org/ontology/core#awardOrHonor',
									@ObjectID = @NodeID,
									@SessionID = @SessionID,
									@Error = @Error OUTPUT
	END

	-------------------------------------------------
	-- Handle optional properties
	-------------------------------------------------

	-- Add optional properties to the AwardReceipt
	IF (@NodeID IS NOT NULL) AND (@Error = 0)
	BEGIN
		IF @awardConferredByNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#awardConferredBy',
										@ObjectID = @awardConferredByNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
		IF @startDateNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#startDate',
										@ObjectID = @startDateNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
		IF @endDateNodeID IS NOT NULL
			EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
										@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#endDate',
										@ObjectID = @endDateNodeID,
										@SessionID = @SessionID,
										@Error = @Error OUTPUT
	END

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Ontology.].[CleanUp]
	@Action varchar(100) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- This stored procedure contains code to help developers manage
	-- content in several ontology tables.
	
	-------------------------------------------------------------
	-- View the contents of the tables
	-------------------------------------------------------------

	if @Action = 'ShowTables'
	begin
		select * from [Ontology.].ClassGroup
		select * from [Ontology.].ClassGroupClass
		select * from [Ontology.].ClassProperty
		select * from [Ontology.].DataMap
		select * from [Ontology.].Namespace
		select * from [Ontology.].OWL
		select * from [Ontology.].Presentation
		select * from [Ontology.].PropertyGroup
		select * from [Ontology.].PropertyGroupProperty
		select * from [Ontology.Import].[Triple]
	end
	
	-------------------------------------------------------------
	-- Insert missing records, use default values
	-------------------------------------------------------------

	if @Action = 'AddMissingRecords'
	begin

		insert into [Ontology.].ClassProperty (ClassPropertyID, Class, NetworkProperty, Property, IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, MinCardinality, MaxCardinality, CustomEditModule)
			select ClassPropertyID, Class, NetworkProperty, Property, IsDetail, Limit, IncludeDescription, IncludeNetwork, SearchWeight, CustomDisplay, CustomEdit, ViewSecurityGroup, EditSecurityGroup, EditPermissionsSecurityGroup, EditExistingSecurityGroup, EditAddNewSecurityGroup, EditAddExistingSecurityGroup, EditDeleteSecurityGroup, MinCardinality, MaxCardinality, CustomEditModule
				from [Ontology.].vwMissingClassProperty

		insert into [Ontology.].PropertyGroupProperty (PropertyGroupURI, PropertyURI, SortOrder)
			select PropertyGroupURI, PropertyURI, SortOrder
				from [Ontology.].vwMissingPropertyGroupProperty

	end

	-------------------------------------------------------------
	-- Update IDs using the default sort order
	-------------------------------------------------------------

	if @Action = 'UpdateIDs'
	begin
		
		update x
			set x.ClassPropertyID = y.k
			from [Ontology.].ClassProperty x, (
				select *, row_number() over (order by (case when NetworkProperty is null then 0 else 1 end), Class, NetworkProperty, IsDetail, IncludeNetwork, Property) k
					from [Ontology.].ClassProperty
			) y
			where x.Class = y.Class and x.Property = y.Property
				and ((x.NetworkProperty is null and y.NetworkProperty is null) or (x.NetworkProperty = y.NetworkProperty))

		update x
			set x.DataMapID = y.k
			from [Ontology.].DataMap x, (
				select *, row_number() over (order by	(case when Property is null then 0 when NetworkProperty is null then 1 else 2 end), 
														(case when Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User' then 0 else 1 end), 
														Class,
														(case when NetworkProperty = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' then 0 when NetworkProperty = 'http://www.w3.org/2000/01/rdf-schema#label' then 1 else 2 end),
														NetworkProperty, 
														(case when Property = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' then 0 when Property = 'http://www.w3.org/2000/01/rdf-schema#label' then 1 else 2 end),
														MapTable,
														Property
														) k
					from [Ontology.].DataMap
			) y
			where x.Class = y.Class and x.sInternalType = y.sInternalType
				and ((x.Property is null and y.Property is null) or (x.Property = y.Property))
				and ((x.NetworkProperty is null and y.NetworkProperty is null) or (x.NetworkProperty = y.NetworkProperty))

		update x
			set x.PresentationID = y.k
			from [Ontology.].Presentation x, (
				select *, row_number() over (order by	(case when Type = 'E' then 1 else 0 end), 
														Subject,
														(case Type when 'P' then 1 when 'N' then 2 else 3 end),
														Predicate, Object
														) k
					from [Ontology.].Presentation
			) y
			where x.Type = y.Type
				and ((x.Subject is null and y.Subject is null) or (x.Subject = y.Subject))
				and ((x.Predicate is null and y.Predicate is null) or (x.Predicate = y.Predicate))
				and ((x.Object is null and y.Object is null) or (x.Object = y.Object))	

	end

	-------------------------------------------------------------
	-- Update derived and calculated fields
	-------------------------------------------------------------

	if @Action = 'UpdateFields'
	begin
		exec [Ontology.].UpdateDerivedFields
		exec [Ontology.].UpdateCounts
	end
    
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Import].[Beta.LoadData] (@SourceDBName varchar(max))
AS BEGIN
	 
	SET NOCOUNT ON;
 
	   /* 
 
	This stored procedure imports a subset of data from a Profiles RNS Beta
	instance into the Profiles RNS 1.0 Extended Schema tables. 
 
	Input parameters:
		@SourceDBName				source db to pull beta data from.		  
 
	Test Call:
		[Utility.Application].[uspImportBetaData] resnav_people_hmsopen
		
	*/
	DECLARE @sql NVARCHAR(MAX) 
	
	-- Toggle off fkey constraints
	ALTER TABLE [Profile.Data].[Person.FilterRelationship]  NOCHECK CONSTRAINT FK_person_type_relationships_person
	ALTER TABLE [Profile.Data].[Person.FilterRelationship]  NOCHECK CONSTRAINT FK_person_type_relationships_person_types	
	ALTER TABLE [Profile.Data].[Publication.Person.Include]  NOCHECK CONSTRAINT FK_publications_include_pm_pubs_general
	ALTER TABLE [Profile.Data].[Publication.MyPub.General]  NOCHECK CONSTRAINT FK_my_pubs_general_person
	ALTER TABLE [Profile.Data].[Publication.Person.Include]  NOCHECK CONSTRAINT FK_publications_include_person
	ALTER TABLE [Profile.Data].[Publication.Person.Include]  NOCHECK CONSTRAINT FK_publications_include_my_pubs_general 
	ALTER TABLE [Profile.Data].[Publication.PubMed.Accession]  NOCHECK CONSTRAINT  FK_pm_pubs_accessions_pm_pubs_general
	ALTER TABLE [Profile.Data].[Publication.PubMed.Author]  NOCHECK CONSTRAINT  FK_pm_pubs_authors_pm_pubs_general
	ALTER TABLE [Profile.Data].[Publication.PubMed.Chemical]  NOCHECK CONSTRAINT  FK_pm_pubs_chemicals_pm_pubs_general
	ALTER TABLE [Profile.Data].[Publication.PubMed.Databank]  NOCHECK CONSTRAINT  FK_pm_pubs_databanks_pm_pubs_general
	ALTER TABLE [Profile.Data].[Publication.PubMed.Grant]  NOCHECK CONSTRAINT FK_pm_pubs_grants_pm_pubs_general
	
	-- [profile.data].[Organization.Department] 
	TRUNCATE TABLE [profile.data].[Organization.Department]
	SET IDENTITY_INSERT [profile.data].[Organization.Department] ON 
	SELECT @sql = 'SELECT DepartmentID,DepartmentName,Visible FROM '+ @SourceDBName + '.dbo.department'
	INSERT INTO [profile.data].[Organization.Department](DepartmentID,DepartmentName,Visible)
	EXEC sp_executesql @sql
	SET IDENTITY_INSERT [profile.data].[Organization.Department] OFF	
	
	--[profile.data].[Organization.Division]dbo.division
	TRUNCATE TABLE [profile.data].[Organization.division]
	SET IDENTITY_INSERT [profile.data].[Organization.Division] ON 
	SELECT @sql = 'SELECT DivisionID,DivisionName FROM '+ @SourceDBName + '.dbo.Division'
	INSERT INTO [profile.data].[Organization.Division](DivisionID,DivisionName)
	EXEC sp_executesql @sql	
	SET IDENTITY_INSERT [profile.data].[Organization.Division] OFF	
	
	--[profile.data].[Organization.Institution]dbo.institution
	TRUNCATE TABLE [profile.data].[Organization.institution]
	SET IDENTITY_INSERT [profile.data].[Organization.institution] ON 
	SELECT @sql = 'SELECT institutionID,institutionName,InstitutionAbbreviation FROM '+ @SourceDBName + '.dbo.institution'
	INSERT INTO [profile.data].[Organization.institution](institutionID,institutionName,InstitutionAbbreviation)
	EXEC sp_executesql @sql	
	SET IDENTITY_INSERT [profile.data].[Organization.institution] OFF	
	
	--	[profile.data].[concept.mesh.descriptor]dbo.mesh_descriptors institution
	TRUNCATE TABLE [profile.data].[concept.mesh.descriptor]
	SELECT @sql = 'SELECT DescriptorUI,DescriptorName FROM '+ @SourceDBName + '.dbo.mesh_descriptors'
	INSERT INTO [profile.data].[concept.mesh.descriptor](DescriptorUI,DescriptorName )
	EXEC sp_executesql @sql	 	
	
	--	[profile.data].[concept.mesh.tree]dbo.mesh_tree
	TRUNCATE TABLE [profile.data].[concept.mesh.tree]
	SELECT @sql = 'SELECT DescriptorUI,TreeNumber FROM '+ @SourceDBName + '.dbo.mesh_tree'
	INSERT INTO [profile.data].[concept.mesh.tree](DescriptorUI,TreeNumber )
	EXEC sp_executesql @sql	 
	
	--	[profile.data].[concept.mesh.SemanticGroup]dbo.mesh_semantic_groups
	TRUNCATE TABLE [profile.data].[concept.mesh.SemanticGroup]
	SELECT @sql = 'SELECT DescriptorUI,SemanticGroupUI,SemanticGroupName FROM '+ @SourceDBName + '.dbo.mesh_semantic_groups'
	INSERT INTO [profile.data].[concept.mesh.SemanticGroup](DescriptorUI,SemanticGroupUI,SemanticGroupName  )
	EXEC sp_executesql @sql	 	
	
	--  [profile.cache].[Publication.PubMed.AuthorPosition], dbo.cache_pm_author_position
	TRUNCATE TABLE [profile.cache].[Publication.PubMed.AuthorPosition]
	SELECT @sql =  'SELECT [PersonID],[PMID],[AuthorPosition],[AuthorWeight],[PubDate],[PubYear],[YearWeight] FROM '+ @SourceDBName + '.dbo.cache_pm_author_position'
	INSERT INTO [profile.cache].[Publication.PubMed.AuthorPosition]([PersonID],[PMID],[AuthorPosition],[AuthorWeight],[PubDate],[PubYear],[YearWeight]  )
	EXEC sp_executesql @sql	 
	 
	--	[Profile.Data].[Person]dbo.person
	DELETE FROM [profile.Data].[Person]
	SET IDENTITY_INSERT [profile.data].[Person] ON 
	SELECT @sql = 'SELECT [PersonID],[UserID],[FirstName],[LastName],[MiddleName],[DisplayName],[Suffix],[IsActive],[EmailAddr],[Phone],[Fax],[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[City],[State],[Zip],[Building],[Floor],[Room],[AddressString],[Latitude],[Longitude],[GeoScore],[FacultyRankID],[InternalUsername],[Visible] FROM '+ @SourceDBName + '.dbo.person'
	INSERT INTO [profile.data].[Person]([PersonID],[UserID],[FirstName],[LastName],[MiddleName],[DisplayName],[Suffix],[IsActive],[EmailAddr],[Phone],[Fax],[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[City],[State],[Zip],[Building],[Floor],[Room],[AddressString],[Latitude],[Longitude],[GeoScore],[FacultyRankID],[InternalUsername],[Visible]  )
	EXEC sp_executesql @sql	 
	SET IDENTITY_INSERT [profile.data].[Person] OFF 	
	
	--	[Profile.Data].[Person.FilterRelationship]dbo.person_filter_relationships
	TRUNCATE TABLE [profile.Data].[Person.FilterRelationship] 
	SELECT @sql = 'SELECT [PersonID],[PersonFilterid] FROM '+ @SourceDBName + '.dbo.person_filter_relationships'
	INSERT INTO [profile.data].[Person.FilterRelationship]([PersonID],[PersonFilterid] )
	EXEC sp_executesql @sql	   
	
	--	[Profile.Data].[Person.Filter]dbo.person_filters
	SET IDENTITY_INSERT [profile.data].[Person.Filter] ON 
	DELETE FROM [profile.Data].[Person.Filter] 
	SELECT @sql = 'SELECT [PersonFilterID],[PersonFilter],[PersonFilterCategory],[PersonFilterSort] FROM '+ @SourceDBName + '.dbo.person_filters'
	INSERT INTO [profile.data].[Person.Filter]([PersonFilterID],[PersonFilter],[PersonFilterCategory],[PersonFilterSort] )
	EXEC sp_executesql @sql	   
	SET IDENTITY_INSERT [profile.data].[Person.Filter] OFF 
		
	--	[profile.data].[Person.Affiliation]dbo.person_affiliations
	SET IDENTITY_INSERT [profile.data].[Person.Affiliation] ON 
	TRUNCATE TABLE [profile.Data].[Person.Affiliation] 
	SELECT @sql = 'SELECT [PersonAffiliationID],[PersonID],[SortOrder],[IsActive],[IsPrimary],[InstitutionID],[DepartmentID],[DivisionID],[Title],[EmailAddress],[FacultyRankID] 
					FROM '+ @SourceDBName + '.dbo.person_affiliations a
						LEFT OUTER JOIN '+ @SourceDBName + '.dbo.institution_fullname i ON a.[InstitutionFullnameID] = i.[InstitutionFullnameID] 
						LEFT OUTER JOIN '+ @SourceDBName + '.dbo.department_fullname d ON a.[DepartmentFullNameID] = d.[DepartmentFullNameID]
						LEFT OUTER JOIN '+ @SourceDBName + '.dbo.division_fullname v ON a.[DivisionFullnameID] = v.[DivisionFullnameID]'
	INSERT INTO [profile.data].[Person.Affiliation]([PersonAffiliationID],[PersonID],[SortOrder],[IsActive],[IsPrimary],[InstitutionID],[DepartmentID],[DivisionID],[Title],[EmailAddress],[FacultyRankID] )
	EXEC sp_executesql @sql	   
	SET IDENTITY_INSERT [profile.data].[Person.Affiliation] OFF 	
	
	--	[Profile.Data].[Person.Award]dbo.awards 
	TRUNCATE TABLE [profile.Import].[Beta.Award] 
	SELECT @sql = 'SELECT [AwardID],[PersonID],[Yr],[Yr2],[AwardNM],[AwardingInst] FROM '+ @SourceDBName + '.dbo.awards'
	INSERT INTO [profile.Import].[Beta.Award]([AwardID],[PersonID],[Yr],[Yr2],[AwardNM],[AwardingInst] )
	EXEC sp_executesql @sql	    
	
	--	[Profile.Data].[Person.FacultyRank]dbo.faculty_rank
	SET IDENTITY_INSERT [profile.data].[Person.FacultyRank] ON 
	TRUNCATE TABLE [profile.Data].[Person.FacultyRank] 
	SELECT @sql = 'SELECT [FacultyRankID],[FacultyRank],[FacultyRankSort],[Visible] FROM '+ @SourceDBName + '.dbo. faculty_rank'
	INSERT INTO [profile.data].[Person.FacultyRank]([FacultyRankID],[FacultyRank],[FacultyRankSort],[Visible] )
	EXEC sp_executesql @sql	   
	SET IDENTITY_INSERT [profile.data].[Person.FacultyRank] OFF 
	
	--	[profile.data].[person.narrative]dbo.narratives  
	TRUNCATE TABLE [profile.Import].[Beta.Narrative] 
	SELECT @sql = 'SELECT [PersonID],[NarrativeMain] FROM '+ @SourceDBName + '.dbo.narratives'
	INSERT INTO [profile.Import].[Beta.Narrative]([PersonID],[NarrativeMain] )
	EXEC sp_executesql @sql	    	
	
	--	[Profile.Cache].[SNA.Coauthor]dbo.sna_coauthors 
	TRUNCATE TABLE [Profile.Cache].[SNA.Coauthor]
	SELECT @sql = 'SELECT [PersonID1],[PersonID2],[i],[j],[w],[FirstPubDate],[LastPubDate],[n] FROM '+ @SourceDBName + '.dbo.sna_coauthors'
	INSERT INTO [Profile.Cache].[SNA.Coauthor]([PersonID1],[PersonID2],[i],[j],[w],[FirstPubDate],[LastPubDate],[n] )
	EXEC sp_executesql @sql	    
	
	--	[profile.cache].[Concept.Mesh.Count]dbo.cache_mesh_count
	TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.Count]
	SELECT @sql = 'SELECT[MeshHeader],[NumPublications],[NumFaculty],[Weight],[RawWeight] FROM '+ @SourceDBName + '.dbo.cache_mesh_count'
	INSERT INTO [Profile.Cache].[Concept.Mesh.Count]([MeshHeader],[NumPublications],[NumFaculty],[Weight],[RawWeight] )
	EXEC sp_executesql @sql	    
	 
	--	[Profile.Cache].[Person.PhysicalNeighbor]dbo.cache_physical_neighbors
	TRUNCATE TABLE [Profile.Cache].[Person.PhysicalNeighbor]
	SELECT @sql = 'SELECT[PersonID],[NeighborID],[Distance],[DisplayName],[MyNeighbors] FROM '+ @SourceDBName + '.dbo.cache_physical_neighbors'
	INSERT INTO [Profile.Cache].[Person.PhysicalNeighbor]([PersonID],[NeighborID],[Distance],[DisplayName],[MyNeighbors])
	EXEC sp_executesql @sql	    
	
	--	[Profile.Cache].[Person.SimilarPerson]dbo.cache_similar_people
	TRUNCATE TABLE [Profile.Cache].[Person.SimilarPerson]
	SELECT @sql = 'SELECT[PersonID],[SimilarPersonID],[Weight],[CoAuthor] FROM '+ @SourceDBName + '.dbo.cache_similar_people'
	INSERT INTO [Profile.Cache].[Person.SimilarPerson]([PersonID],[SimilarPersonID],[Weight],[CoAuthor])
	EXEC sp_executesql @sql	    
	
	--	[Profile.Cache].[Concept.Mesh.Person]dbo.cache_user_mesh
	TRUNCATE TABLE [Profile.Cache].[Concept.Mesh.Person]
	SELECT @sql = 'SELECT[PersonID],[MeshHeader],[NumPubsAll],[NumPubsThis],[Weight],[FirstPublicationYear],[LastPublicationYear],[MaxAuthorWeight],[WeightCategory]FROM '+ @SourceDBName + '.dbo.cache_user_mesh'
	INSERT INTO [Profile.Cache].[Concept.Mesh.Person]([PersonID],[MeshHeader],[NumPubsAll],[NumPubsThis],[Weight],[FirstPublicationYear],[LastPublicationYear],[MaxAuthorWeight],[WeightCategory])
	EXEC sp_executesql @sql	    
	
	--	[Profile.Data].[Publication.PubMed.General]dbo.pm_pubs_general
	DELETE FROM [Profile.Data].[Publication.PubMed.General]
	SELECT @sql = 'SELECT[PMID],[Owner],[Status],[PubModel],[Volume],[Issue],[MedlineDate],[JournalYear],[JournalMonth],[JournalDay],[JournalTitle],[ISOAbbreviation],[MedlineTA],[ArticleTitle],[MedlinePgn],[AbstractText],[ArticleDateType],[ArticleYear],[ArticleMonth],[ArticleDay],[Affiliation],[AuthorListCompleteYN],[GrantListCompleteYN],[PubDate],[Authors]FROM '+ @SourceDBName + '.dbo.pm_pubs_general'
	INSERT INTO [Profile.Data].[Publication.PubMed.General]([PMID],[Owner],[Status],[PubModel],[Volume],[Issue],[MedlineDate],[JournalYear],[JournalMonth],[JournalDay],[JournalTitle],[ISOAbbreviation],[MedlineTA],[ArticleTitle],[MedlinePgn],[AbstractText],[ArticleDateType],[ArticleYear],[ArticleMonth],[ArticleDay],[Affiliation],[AuthorListCompleteYN],[GrantListCompleteYN],[PubDate],[Authors])
	EXEC sp_executesql @sql	    
	
	--	[Profile.Data].[Publication.MyPub.General]dbo.my_pubs_general
	DELETE FROM [Profile.Data].[Publication.MyPub.General]
	SELECT @sql = 'SELECT[MPID],[PersonID],[PMID],[HmsPubCategory],[NlmPubCategory],[PubTitle],[ArticleTitle],[ArticleType],[ConfEditors],[ConfLoc],[EDITION],[PlaceOfPub],[VolNum],[PartVolPub],[IssuePub],[PaginationPub],[AdditionalInfo],[Publisher],[SecondaryAuthors],[ConfNm],[ConfDTs],[ReptNumber],[ContractNum],[DissUnivNm],[NewspaperCol],[NewspaperSect],[PublicationDT],[Abstract],[Authors],[URL],[CreatedDT],[CreatedBy],[UpdatedDT],[UpdatedBy] FROM '+ @SourceDBName + '.dbo.my_pubs_general'
	INSERT INTO [Profile.Data].[Publication.MyPub.General]([MPID],[PersonID],[PMID],[HmsPubCategory],[NlmPubCategory],[PubTitle],[ArticleTitle],[ArticleType],[ConfEditors],[ConfLoc],[EDITION],[PlaceOfPub],[VolNum],[PartVolPub],[IssuePub],[PaginationPub],[AdditionalInfo],[Publisher],[SecondaryAuthors],[ConfNm],[ConfDTs],[ReptNumber],[ContractNum],[DissUnivNm],[NewspaperCol],[NewspaperSect],[PublicationDT],[Abstract],[Authors],[URL],[CreatedDT],[CreatedBy],[UpdatedDT],[UpdatedBy] )
	EXEC sp_executesql @sql	    
	
	--	[Profile.Data].[Publication.PubMed.Mesh]
	DELETE FROM [Profile.Data].[Publication.PubMed.Mesh]
	SELECT @sql = 'SELECT [PMID],[descriptorname],[QualifierName],[MajorTopicYN] FROM '+ @SourceDBName + '.dbo.pm_pubs_mesh'
	INSERT INTO [Profile.Data].[Publication.PubMed.Mesh]( [PMID],[descriptorname],[QualifierName],[MajorTopicYN])
	EXEC sp_executesql @sql	 
	
	-- [Profile.Data].[Publication.PubMed.Accession]
	DELETE FROM [Profile.Data].[Publication.PubMed.Accession]
	SELECT @sql = 'SELECT [PMID],[DataBankName],[AccessionNumber]  FROM '+ @SourceDBName + '.dbo.pm_pubs_accessions'
	INSERT INTO [Profile.Data].[Publication.PubMed.accession]([PMID],[DataBankName],[AccessionNumber])
	EXEC sp_executesql @sql	 
	
	--1 [Profile.Data].[Publication.PubMed.Author]
	DELETE FROM [Profile.Data].[Publication.PubMed.Author]
	SELECT @sql = 'SELECT [PMID],[ValidYN],[LastName],FirstName,ForeName,Suffix,Initials,Affiliation  FROM '+ @SourceDBName + '.dbo.pm_pubs_authors'
	INSERT INTO [Profile.Data].[Publication.PubMed.Author]([PMID],[ValidYN],[LastName],FirstName,ForeName,Suffix,Initials,Affiliation)
	EXEC sp_executesql @sql	 
	
	 
	--1 [Profile.Data].[Publication.PubMed.Chemical]
	DELETE FROM [Profile.Data].[Publication.PubMed.Chemical]
	SELECT @sql = 'SELECT [PMID],NameOfSubstance  FROM '+ @SourceDBName + '.dbo.pm_pubs_chemicals'
	INSERT INTO [Profile.Data].[Publication.PubMed.Chemical]([PMID],NameOfSubstance)
	EXEC sp_executesql @sql	 
	
	 
	-- [Profile.Data].[Publication.PubMed.Databank]
	DELETE FROM [Profile.Data].[Publication.PubMed.Databank]
	SELECT @sql = 'SELECT [PMID],DataBankName  FROM '+ @SourceDBName + '.dbo.pm_pubs_databanks'
	INSERT INTO [Profile.Data].[Publication.PubMed.Databank]([PMID],DataBankName)
	EXEC sp_executesql @sql	 
	
	 
	--[Profile.Data].[Publication.PubMed.Grant]
	DELETE FROM [Profile.Data].[Publication.PubMed.Grant]
	SELECT @sql = 'SELECT [PMID],GrantID,Acronym,Agency  FROM '+ @SourceDBName + '.dbo.pm_pubs_grants'
	INSERT INTO [Profile.Data].[Publication.PubMed.Grant]([PMID],GrantID,Acronym,Agency )
	EXEC sp_executesql @sql	
	
	--[Profile.Data].[Publication.PubMed.Investigator]
	DELETE FROM [Profile.Data].[Publication.PubMed.Investigator]
	SELECT @sql = 'SELECT [PMID],[LastName],FirstName,ForeName,Suffix,Initials,Affiliation FROM '+ @SourceDBName + '.dbo.pm_pubs_investigators'
	INSERT INTO [Profile.Data].[Publication.PubMed.Investigator]([PMID],[LastName],FirstName,ForeName,Suffix,Initials,Affiliation)
	EXEC sp_executesql @sql	
	
	--[Profile.Data].[Publication.PubMed.Keyword]
	DELETE FROM [Profile.Data].[Publication.PubMed.Keyword]
	SELECT @sql = 'SELECT PMID, Keyword,MajorTopicYN  FROM '+ @SourceDBName + '.dbo.pm_pubs_keywords'
	INSERT INTO [Profile.Data].[Publication.PubMed.Keyword](PMID, Keyword,MajorTopicYN )
	EXEC sp_executesql @sql	 
	
	--	[Profile.Data].[Publication.Person.Include]dbo.publications_include
	TRUNCATE TABLE [Profile.Data].[Publication.Person.Include]
	SELECT @sql = 'SELECT[PubID],[PersonID],[PMID],[MPID] FROM '+ @SourceDBName + '.dbo.publications_include'
	INSERT INTO [Profile.Data].[Publication.Person.Include]([PubID],[PersonID],[PMID],[MPID])
	EXEC sp_executesql @sql	    
	 
	--	[User.Account].[User]dbo.[user]
	SET IDENTITY_INSERT [User.Account].[User] ON 
	DELETE FROM [User.Account].[User]
	SELECT @sql = 'SELECT[UserID],EmailAddr,[PersonID],[IsActive],[CanBeProxy],[FirstName],[LastName],[DisplayName],[InstitutionFullName],[DepartmentFullName],[DivisionFullName],[UserName],[Password],[CreateDate],[ApplicationName],[Comment],[IsApproved],[IsOnline],[InternalUserName] FROM '+ @SourceDBName + '.dbo.[user] '
	INSERT INTO [User.Account].[User]([UserID],EmailAddr,[PersonID],[IsActive],[CanBeProxy],[FirstName],[LastName],[DisplayName],[Institution],[Department],[Division],[UserName],[Password],[CreateDate],[ApplicationName],[Comment],[IsApproved],[IsOnline],[InternalUserName])
	EXEC sp_executesql @sql	    
	SET IDENTITY_INSERT [User.Account].[User] OFF  
 
	--  [User.Account].DefaultProxy
	DELETE FROM [User.Account].DefaultProxy
	SELECT @sql = 'SELECT proxy, institution,department,NULL, case when ishidden=''Y'' then 0 else 1 end	FROM  '+ @SourceDBName + '.dbo.[proxies_default]  '
	INSERT INTO [User.Account].DefaultProxy
	        ( UserID ,
	          ProxyForInstitution ,
	          ProxyForDepartment ,
	          ProxyForDivision ,
	          IsVisible
	        )
	EXEC sp_executesql @sql	 
	
	-- [User.Account].DesignatedProxy 
	DELETE FROM [User.Account].DesignatedProxy 
	SELECT @sql = 'select  Proxy, PersonID FROM  '+ @SourceDBName + '.dbo.[proxies_designated]  '
	INSERT INTO [User.Account].DesignatedProxy ( UserID, ProxyForUserID )
	EXEC sp_executesql @sql 
	
	-- [User.Account].Relationship 
	DELETE FROM [User.Account].Relationship
	SELECT @sql = 'select UserID, personid,RelationshipType FROM  '+ @SourceDBName + '.dbo.[user_relationships]  '
	INSERT INTO [User.Account].Relationship ( UserID, personid,RelationshipType )
	EXEC sp_executesql @sql 
	 
	-- [Profile.Import].[Beta.DisplayPreference]
	TRUNCATE TABLE [Profile.Import].[Beta.DisplayPreference]
	SELECT @sql = 'select PersonID,ShowPhoto,ShowPublications,ShowAwards,ShowNarrative,ShowAddress,ShowEmail,ShowPhone,ShowFax,PhotoPreference FROM  '+ @SourceDBName + '.dbo.[display_prefs]  '
	INSERT INTO [Profile.Import].[Beta.DisplayPreference] (PersonID,ShowPhoto,ShowPublications,ShowAwards,ShowNarrative,ShowAddress,ShowEmail,ShowPhone,ShowFax,PhotoPreference )
	EXEC sp_executesql @sql 			
	
	-- [Profile.Data].[Person.Photo]
	TRUNCATE TABLE [Profile.Data].[Person.Photo]
	SELECT @sql = 'select PersonID,Photo,PhotoLink  FROM  '+ @SourceDBName + '.dbo.[photo]  '
	INSERT INTO [Profile.Data].[Person.Photo] (PersonID,Photo,PhotoLink )
	EXEC sp_executesql @sql 	
	
	  
	 
	-- Toggle off fkey constraints
	ALTER TABLE [Profile.Data].[Person.FilterRelationship]  CHECK CONSTRAINT FK_person_type_relationships_person
	ALTER TABLE [Profile.Data].[Person.FilterRelationship]  CHECK CONSTRAINT FK_person_type_relationships_person_types	
	ALTER TABLE [Profile.Data].[Publication.Person.Include]  CHECK CONSTRAINT FK_publications_include_pm_pubs_general
	ALTER TABLE [Profile.Data].[Publication.MyPub.General]  CHECK CONSTRAINT FK_my_pubs_general_person
	ALTER TABLE [Profile.Data].[Publication.Person.Include]  CHECK CONSTRAINT FK_publications_include_person
	ALTER TABLE [Profile.Data].[Publication.Person.Include]  CHECK CONSTRAINT FK_publications_include_my_pubs_general 
	ALTER TABLE [Profile.Data].[Publication.PubMed.Accession]  CHECK CONSTRAINT  FK_pm_pubs_accessions_pm_pubs_general
	ALTER TABLE [Profile.Data].[Publication.PubMed.Author]  CHECK CONSTRAINT  FK_pm_pubs_authors_pm_pubs_general
	ALTER TABLE [Profile.Data].[Publication.PubMed.Chemical]  CHECK CONSTRAINT  FK_pm_pubs_chemicals_pm_pubs_general
	ALTER TABLE [Profile.Data].[Publication.PubMed.Databank]   CHECK CONSTRAINT  FK_pm_pubs_databanks_pm_pubs_general
	ALTER TABLE [Profile.Data].[Publication.PubMed.Grant]  CHECK CONSTRAINT FK_pm_pubs_grants_pm_pubs_general
	
	-- Popluate [Publication.Entity.Authorship] and [Publication.Entity.InformationResource] tables
	EXEC [Profile.Data].[Publication.Entity.UpdateEntity]
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.Pubmed.LoadDisambiguationResults]
AS
BEGIN
BEGIN TRY  
BEGIN TRAN
 
-- Remove orphaned pubs
DELETE FROM [Profile.Data].[Publication.Person.Include]
	  WHERE NOT EXISTS (SELECT *
						  FROM [Profile.Data].[Publication.PubMed.Disambiguation] p
						 WHERE p.personid = [Profile.Data].[Publication.Person.Include].personid
						   AND p.pmid = [Profile.Data].[Publication.Person.Include].pmid)
		AND mpid IS NULL
 
--Move in new pubs
INSERT INTO [Profile.Data].[Publication.Person.Include]
SELECT	 NEWID(),
		 personid,
		 pmid,
		 NULL
  FROM [Profile.Data].[Publication.PubMed.Disambiguation] d
 WHERE NOT EXISTS (SELECT *
					 FROM  [Profile.Data].[Publication.Person.Include] p
					WHERE p.personid = d.personid
					  AND p.pmid = d.pmid)
  AND EXISTS (SELECT 1 FROM [Profile.Data].[Publication.PubMed.General] g where g.pmid = d.pmid)					  
 
COMMIT
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		
 
-- Popluate [Publication.Entity.Authorship] and [Publication.Entity.InformationResource] tables
	EXEC [Profile.Data].[Publication.Entity.UpdateEntity]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.Pubmed.AddPublication] 
	@UserID INT,
	@pmid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	if exists (select * from [Profile.Data].[Publication.PubMed.AllXML] where pmid = @pmid)
	begin
 
		declare @ParseDate datetime
		set @ParseDate = (select coalesce(ParseDT,'1/1/1900') from [Profile.Data].[Publication.PubMed.AllXML] where pmid = @pmid)
		if (@ParseDate < '1/1/2000')
		begin
			exec [Profile.Data].[Publication.Pubmed.ParsePubMedXML] 
			 @pmid
		end
 BEGIN TRY 
		BEGIN TRANSACTION
 
			if not exists (select * from [Profile.Data].[Publication.Person.Include] where PersonID = @UserID and pmid = @pmid)
			begin
 
				declare @pubid uniqueidentifier
				declare @mpid varchar(50)
 
				set @mpid = null
 
				set @pubid = (select top 1 pubid from [Profile.Data].[Publication.Person.Exclude] where PersonID = @UserID and pmid = @pmid)
				if @pubid is not null
					begin
						set @mpid = (select mpid from [Profile.Data].[Publication.Person.Exclude] where pubid = @pubid)
						delete from [Profile.Data].[Publication.Person.Exclude] where pubid = @pubid
					end
				else
					begin
						set @pubid = (select newid())
					end
 
				insert into [Profile.Data].[Publication.Person.Include](pubid,PersonID,pmid,mpid)
					values (@pubid,@UserID,@pmid,@mpid)
 
				insert into [Profile.Data].[Publication.Person.Add](pubid,PersonID,pmid,mpid)
					values (@pubid,@UserID,@pmid,@mpid)
 
				EXEC  [Profile.Data].[Publication.Pubmed.AddOneAuthorPosition] @PersonID = @UserID, @pmid = @pmid
 
				-- Popluate [Publication.Entity.Authorship] and [Publication.Entity.InformationResource] tables
				EXEC [Profile.Data].[Publication.Entity.UpdateEntityOnePerson]@UserID
				
			end
 
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		
 
	END
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.GetPersonPublications] 
	-- Add the parameters for the stored procedure here
	@UserID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
SELECT *
  FROM [Profile.Data].[fnPublication.Person.GetPublications](@UserID)
 
 
	--ORDER BY publication_dt, publications
 
 
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.Cache].[Public.GetNodes]
	@SearchOptions XML,
	@SessionID UNIQUEIDENTIFIER = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

	/*
	
	EXEC [Search.].[GetNodes] @SearchOptions = '
	<SearchOptions>
		<MatchOptions>
			<SearchString ExactMatch="false">options for "lung cancer" treatment</SearchString>
			<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
			<SearchFiltersList>
				<SearchFilter Property="http://xmlns.com/foaf/0.1/lastName" MatchType="Left">Smit</SearchFilter>
			</SearchFiltersList>
		</MatchOptions>
		<OutputOptions>
			<Offset>0</Offset>
			<Limit>5</Limit>
			<SortByList>
				<SortBy IsDesc="1" Property="http://xmlns.com/foaf/0.1/firstName" />
				<SortBy IsDesc="0" Property="http://xmlns.com/foaf/0.1/lastName" />
			</SortByList>
		</OutputOptions>	
	</SearchOptions>
	'
		
	*/

	declare @MatchOptions xml
	declare @OutputOptions xml
	declare @SearchString varchar(500)
	declare @ClassGroupURI varchar(400)
	declare @ClassURI varchar(400)
	declare @SearchFiltersXML xml
	declare @offset bigint
	declare @limit bigint
	declare @SortByXML xml
	declare @DoExpandedSearch bit
	
	select	@MatchOptions = @SearchOptions.query('SearchOptions[1]/MatchOptions[1]'),
			@OutputOptions = @SearchOptions.query('SearchOptions[1]/OutputOptions[1]')
	
	select	@SearchString = @MatchOptions.value('MatchOptions[1]/SearchString[1]','varchar(500)'),
			@DoExpandedSearch = (case when @MatchOptions.value('MatchOptions[1]/SearchString[1]/@ExactMatch','varchar(50)') = 'true' then 0 else 1 end),
			@ClassGroupURI = @MatchOptions.value('MatchOptions[1]/ClassGroupURI[1]','varchar(400)'),
			@ClassURI = @MatchOptions.value('MatchOptions[1]/ClassURI[1]','varchar(400)'),
			@SearchFiltersXML = @MatchOptions.query('MatchOptions[1]/SearchFiltersList[1]'),
			@offset = @OutputOptions.value('OutputOptions[1]/Offset[1]','bigint'),
			@limit = @OutputOptions.value('OutputOptions[1]/Limit[1]','bigint'),
			@SortByXML = @OutputOptions.query('OutputOptions[1]/SortByList[1]')

	declare @baseURI nvarchar(400)
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'

	declare @d datetime
	select @d = GetDate()
	
	declare @IsBot bit
	if @SessionID is not null
		select @IsBot = IsBot
			from [User.Session].[Session]
			where SessionID = @SessionID
	select @IsBot = IsNull(@IsBot,0)
	
	declare @SearchHistoryQueryID int
	insert into [Search.].[History.Query] (StartDate, SessionID, IsBot, SearchOptions)
		select GetDate(), @SessionID, @IsBot, @SearchOptions
	select @SearchHistoryQueryID = @@IDENTITY

	-------------------------------------------------------
	-- Parse search string and convert to fulltext query
	-------------------------------------------------------

	declare @NumberOfPhrases INT
	declare @CombinedSearchString VARCHAR(8000)
	declare @SearchPhraseXML XML
	declare @SearchPhraseFormsXML XML
	declare @ParseProcessTime INT

	EXEC [Search.].[ParseSearchString]	@SearchString = @SearchString,
										@NumberOfPhrases = @NumberOfPhrases OUTPUT,
										@CombinedSearchString = @CombinedSearchString OUTPUT,
										@SearchPhraseXML = @SearchPhraseXML OUTPUT,
										@SearchPhraseFormsXML = @SearchPhraseFormsXML OUTPUT,
										@ProcessTime = @ParseProcessTime OUTPUT

	declare @PhraseList table (PhraseID int, Phrase varchar(max), ThesaurusMatch bit, Forms varchar(max))
	insert into @PhraseList (PhraseID, Phrase, ThesaurusMatch, Forms)
	select	x.value('@ID','INT'),
			x.value('.','VARCHAR(MAX)'),
			x.value('@ThesaurusMatch','BIT'),
			x.value('@Forms','VARCHAR(MAX)')
		from @SearchPhraseFormsXML.nodes('//SearchPhrase') as p(x)

	--SELECT @NumberOfPhrases, @CombinedSearchString, @SearchPhraseXML, @SearchPhraseFormsXML, @ParseProcessTime
	--SELECT * FROM @PhraseList
	--select datediff(ms,@d,GetDate())


	-------------------------------------------------------
	-- Parse search filters
	-------------------------------------------------------

	create table #SearchFilters (
		SearchFilterID int identity(0,1) primary key,
		IsExclude bit,
		PropertyURI varchar(400),
		PropertyURI2 varchar(400),
		Value varchar(750),
		Predicate bigint,
		Predicate2 bigint
	)
	
	insert into #SearchFilters (IsExclude, PropertyURI, PropertyURI2, Value, Predicate, Predicate2)	
		select t.IsExclude, t.PropertyURI, t.PropertyURI2, 
				left(t.Value,750)+(case when t.MatchType='Left' then '%' else '' end),
				t.Predicate, t.Predicate2
			from (
				select IsNull(IsExclude,0) IsExclude, PropertyURI, PropertyURI2, MatchType, Value,
					[RDF.].fnURI2NodeID(PropertyURI) Predicate,
					[RDF.].fnURI2NodeID(PropertyURI2) Predicate2
				from (
					select distinct S.x.value('@IsExclude','bit') IsExclude,
							S.x.value('@Property','varchar(400)') PropertyURI,
							S.x.value('@Property2','varchar(400)') PropertyURI2,
							S.x.value('@MatchType','varchar(100)') MatchType,
							S.x.value('.','nvarchar(max)') Value
					from @SearchFiltersXML.nodes('//SearchFilter') as S(x)
				) t
			) t
			where t.Value IS NOT NULL and t.Value <> ''
			
	declare @NumberOfIncludeFilters int
	select @NumberOfIncludeFilters = IsNull((select count(*) from #SearchFilters where IsExclude=0),0)

	-------------------------------------------------------
	-- Parse sort by options
	-------------------------------------------------------

	create table #SortBy (
		SortByID int identity(1,1) primary key,
		IsDesc bit,
		PropertyURI varchar(400),
		PropertyURI2 varchar(400),
		PropertyURI3 varchar(400),
		Predicate bigint,
		Predicate2 bigint,
		Predicate3 bigint
	)
	
	insert into #SortBy (IsDesc, PropertyURI, PropertyURI2, PropertyURI3, Predicate, Predicate2, Predicate3)	
		select IsNull(IsDesc,0), PropertyURI, PropertyURI2, PropertyURI3,
				[RDF.].fnURI2NodeID(PropertyURI) Predicate,
				[RDF.].fnURI2NodeID(PropertyURI2) Predicate2,
				[RDF.].fnURI2NodeID(PropertyURI3) Predicate3
			from (
				select S.x.value('@IsDesc','bit') IsDesc,
						S.x.value('@Property','varchar(400)') PropertyURI,
						S.x.value('@Property2','varchar(400)') PropertyURI2,
						S.x.value('@Property3','varchar(400)') PropertyURI3
				from @SortByXML.nodes('//SortBy') as S(x)
			) t

	-------------------------------------------------------
	-- Get initial list of matching nodes (before filters)
	-------------------------------------------------------

	create table #FullNodeMatch (
		NodeID bigint not null,
		Paths bigint,
		Weight float
	)

	if @CombinedSearchString <> ''
	begin

		-- Get nodes that match separate phrases
		create table #PhraseNodeMatch (
			PhraseID int not null,
			NodeID bigint not null,
			Paths bigint,
			Weight float
		)
		if (@NumberOfPhrases > 1) and (@DoExpandedSearch = 1)
		begin
			declare @PhraseSearchString varchar(8000)
			declare @loop int
			select @loop = 1
			while @loop <= @NumberOfPhrases
			begin
				select @PhraseSearchString = Forms
					from @PhraseList
					where PhraseID = @loop
				insert into #PhraseNodeMatch (PhraseID, NodeID, Paths, Weight)
					select @loop, s.NodeID, count(*) Paths, 1-exp(sum(log(case when s.Weight*m.Weight > 0.999999 then 0.000001 else 1-s.Weight*m.Weight end))) Weight
						from [Search.Cache].[Public.NodeMap] s, (
							select [Key] NodeID, [Rank]*0.001 Weight
								from Containstable ([RDF.].Node, value, @PhraseSearchString) n
						) m
						where s.MatchedByNodeID = m.NodeID
						group by s.NodeID
				select @loop = @loop + 1
			end
			--create clustered index idx_n on #PhraseNodeMatch(NodeID)
		end

		create table #TempMatchNodes (
			NodeID bigint,
			MatchedByNodeID bigint,
			Distance int,
			Paths int,
			Weight float,
			mWeight float
		)
		insert into #TempMatchNodes (NodeID, MatchedByNodeID, Distance, Paths, Weight, mWeight)
			select s.*, m.Weight mWeight
				from [Search.Cache].[Public.NodeMap] s, (
					select [Key] NodeID, [Rank]*0.001 Weight
						from Containstable ([RDF.].Node, value, @CombinedSearchString) n
				) m
				where s.MatchedByNodeID = m.NodeID

		insert into #FullNodeMatch (NodeID, Paths, Weight)
			select IsNull(a.NodeID,b.NodeID) NodeID, IsNull(a.Paths,b.Paths) Paths,
					(case when a.weight is null or b.weight is null then IsNull(a.Weight,b.Weight) else 1-(1-a.Weight)*(1-b.Weight) end) Weight
				from (
					select NodeID, exp(sum(log(Paths))) Paths, exp(sum(log(Weight))) Weight
						from #PhraseNodeMatch
						group by NodeID
						having count(*) = @NumberOfPhrases
				) a full outer join (
					select NodeID, count(*) Paths, 1-exp(sum(log(case when Weight*mWeight > 0.999999 then 0.000001 else 1-Weight*mWeight end))) Weight
						from #TempMatchNodes
						group by NodeID
				) b on a.NodeID = b.NodeID
		--select 'Text Matches Found', datediff(ms,@d,getdate())
	end
	else if (@NumberOfIncludeFilters > 0)
	begin
		insert into #FullNodeMatch (NodeID, Paths, Weight)
			select t1.Subject, 1, 1
				from #SearchFilters f
					inner join [RDF.].Triple t1
						on f.Predicate is not null
							and t1.Predicate = f.Predicate 
							and t1.ViewSecurityGroup = -1
					left outer join [Search.Cache].[Public.NodePrefix] n1
						on n1.NodeID = t1.Object
					left outer join [RDF.].Triple t2
						on f.Predicate2 is not null
							and t2.Subject = n1.NodeID
							and t2.Predicate = f.Predicate2
							and t2.ViewSecurityGroup = -1
					left outer join [Search.Cache].[Public.NodePrefix] n2
						on n2.NodeID = t2.Object
				where f.IsExclude = 0
					and (case when f.Predicate2 is not null then n2.Prefix else n1.Prefix end)
						like f.Value
				group by t1.Subject
				having count(distinct f.SearchFilterID) = @NumberOfIncludeFilters
		delete from #SearchFilters where IsExclude = 0
		select @NumberOfIncludeFilters = 0
	end
	else if (IsNull(@ClassGroupURI,'') <> '' or IsNull(@ClassURI,'') <> '')
	begin
		insert into #FullNodeMatch (NodeID, Paths, Weight)
			select n.NodeID, 1, 1
				from [Search.Cache].[Public.NodeClass] n, [Ontology.].ClassGroupClass c
				where n.Class = c._ClassNode
					and ((@ClassGroupURI is null) or (c.ClassGroupURI = @ClassGroupURI))
					and ((@ClassURI is null) or (c.ClassURI = @ClassURI))
		select @ClassGroupURI = null, @ClassURI = null
	end

	-------------------------------------------------------
	-- Run the actual search
	-------------------------------------------------------
	create table #Node (
		SortOrder bigint identity(0,1) primary key,
		NodeID bigint,
		Paths bigint,
		Weight float
	)

	insert into #Node (NodeID, Paths, Weight)
		select s.NodeID, s.Paths, s.Weight
			from #FullNodeMatch s
				inner join [Search.Cache].[Public.NodeSummary] n on
					s.NodeID = n.NodeID
					and ( IsNull(@ClassGroupURI,@ClassURI) is null or s.NodeID in (
							select NodeID
								from [Search.Cache].[Public.NodeClass] x, [Ontology.].ClassGroupClass c
								where x.Class = c._ClassNode
									and c.ClassGroupURI = IsNull(@ClassGroupURI,c.ClassGroupURI)
									and c.ClassURI = IsNull(@ClassURI,c.ClassURI)
						) )
					and ( @NumberOfIncludeFilters =
							(select count(distinct f.SearchFilterID)
								from #SearchFilters f
									inner join [RDF.].Triple t1
										on f.Predicate is not null
											and t1.Subject = s.NodeID
											and t1.Predicate = f.Predicate 
											and t1.ViewSecurityGroup = -1
									left outer join [Search.Cache].[Public.NodePrefix] n1
										on n1.NodeID = t1.Object
									left outer join [RDF.].Triple t2
										on f.Predicate2 is not null
											and t2.Subject = n1.NodeID
											and t2.Predicate = f.Predicate2
											and t2.ViewSecurityGroup = -1
									left outer join [Search.Cache].[Public.NodePrefix] n2
										on n2.NodeID = t2.Object
								where f.IsExclude = 0
									and (case when f.Predicate2 is not null then n2.Prefix else n1.Prefix end)
										like f.Value
							)
						)
					and not exists (
							select *
								from #SearchFilters f
									inner join [RDF.].Triple t1
										on f.Predicate is not null
											and t1.Subject = s.NodeID
											and t1.Predicate = f.Predicate 
											and t1.ViewSecurityGroup = -1
									left outer join [Search.Cache].[Public.NodePrefix] n1
										on n1.NodeID = t1.Object
									left outer join [RDF.].Triple t2
										on f.Predicate2 is not null
											and t2.Subject = n1.NodeID
											and t2.Predicate = f.Predicate2
											and t2.ViewSecurityGroup = -1
									left outer join [Search.Cache].[Public.NodePrefix] n2
										on n2.NodeID = t2.Object
								where f.IsExclude = 1
									and (case when f.Predicate2 is not null then n2.Prefix else n1.Prefix end)
										like f.Value
						)
				outer apply (
					select	max(case when SortByID=1 then AscSortBy else null end) AscSortBy1,
							max(case when SortByID=2 then AscSortBy else null end) AscSortBy2,
							max(case when SortByID=3 then AscSortBy else null end) AscSortBy3,
							max(case when SortByID=1 then DescSortBy else null end) DescSortBy1,
							max(case when SortByID=2 then DescSortBy else null end) DescSortBy2,
							max(case when SortByID=3 then DescSortBy else null end) DescSortBy3
						from (
							select	SortByID,
									(case when f.IsDesc = 1 then null
											when f.Predicate3 is not null then n3.Value
											when f.Predicate2 is not null then n2.Value
											else n1.Value end) AscSortBy,
									(case when f.IsDesc = 0 then null
											when f.Predicate3 is not null then n3.Value
											when f.Predicate2 is not null then n2.Value
											else n1.Value end) DescSortBy
								from #SortBy f
									inner join [RDF.].Triple t1
										on f.Predicate is not null
											and t1.Subject = s.NodeID
											and t1.Predicate = f.Predicate 
											and t1.ViewSecurityGroup = -1
									left outer join [RDF.].Node n1
										on n1.NodeID = t1.Object
											and n1.ViewSecurityGroup = -1
									left outer join [RDF.].Triple t2
										on f.Predicate2 is not null
											and t2.Subject = n1.NodeID
											and t2.Predicate = f.Predicate2
											and t2.ViewSecurityGroup = -1
									left outer join [RDF.].Node n2
										on n2.NodeID = t2.Object
											and n2.ViewSecurityGroup = -1
									left outer join [RDF.].Triple t3
										on f.Predicate3 is not null
											and t3.Subject = n2.NodeID
											and t3.Predicate = f.Predicate3
											and t3.ViewSecurityGroup = -1
									left outer join [RDF.].Node n3
										on n3.NodeID = t3.Object
											and n3.ViewSecurityGroup = -1
							) t
					) o
			order by	(case when o.AscSortBy1 is null then 1 else 0 end),
						o.AscSortBy1,
						(case when o.DescSortBy1 is null then 1 else 0 end),
						o.DescSortBy1 desc,
						(case when o.AscSortBy2 is null then 1 else 0 end),
						o.AscSortBy2,
						(case when o.DescSortBy2 is null then 1 else 0 end),
						o.DescSortBy2 desc,
						(case when o.AscSortBy3 is null then 1 else 0 end),
						o.AscSortBy3,
						(case when o.DescSortBy3 is null then 1 else 0 end),
						o.DescSortBy3 desc,
						s.Weight desc,
						n.ShortLabel,
						n.NodeID


	--select 'Search Nodes Found', datediff(ms,@d,GetDate())

	-------------------------------------------------------
	-- Get network counts
	-------------------------------------------------------

	declare @NumberOfConnections as bigint
	declare @MaxWeight as float
	declare @MinWeight as float

	select @NumberOfConnections = count(*), @MaxWeight = max(Weight), @MinWeight = min(Weight) 
		from #Node

	-------------------------------------------------------
	-- Get matching class groups and classes
	-------------------------------------------------------

	declare @MatchesClassGroups nvarchar(max)

	select c.ClassGroupURI, c.ClassURI, n.NodeID
		into #NodeClass
		from #Node n, [Search.Cache].[Public.NodeClass] s, [Ontology.].ClassGroupClass c
		where n.NodeID = s.NodeID and s.Class = c._ClassNode

	;with a as (
		select ClassGroupURI, count(distinct NodeID) NumberOfNodes
			from #NodeClass s
			group by ClassGroupURI
	), b as (
		select ClassGroupURI, ClassURI, count(distinct NodeID) NumberOfNodes
			from #NodeClass s
			group by ClassGroupURI, ClassURI
	)
	select @MatchesClassGroups = replace(cast((
			select	g.ClassGroupURI "@rdf_.._resource", 
				g._ClassGroupLabel "rdfs_.._label",
				'http://www.w3.org/2001/XMLSchema#int' "prns_.._numberOfConnections/@rdf_.._datatype",
				a.NumberOfNodes "prns_.._numberOfConnections",
				g.SortOrder "prns_.._sortOrder",
				(
					select	c.ClassURI "@rdf_.._resource",
							c._ClassLabel "rdfs_.._label",
							'http://www.w3.org/2001/XMLSchema#int' "prns_.._numberOfConnections/@rdf_.._datatype",
							b.NumberOfNodes "prns_.._numberOfConnections",
							c.SortOrder "prns_.._sortOrder"
						from b, [Ontology.].ClassGroupClass c
						where b.ClassGroupURI = c.ClassGroupURI and b.ClassURI = c.ClassURI
							and c.ClassGroupURI = g.ClassGroupURI
						order by c.SortOrder
						for xml path('prns_.._matchesClass'), type
				)
			from a, [Ontology.].ClassGroup g
			where a.ClassGroupURI = g.ClassGroupURI
			order by g.SortOrder
			for xml path('prns_.._matchesClassGroup'), type
		) as nvarchar(max)),'_.._',':')

	-------------------------------------------------------
	-- Get RDF of search results objects
	-------------------------------------------------------

	declare @ObjectNodesRDF nvarchar(max)

	if @NumberOfConnections > 0
	begin
		/*
			-- Alternative methods that uses GetDataRDF to get the RDF
			declare @NodeListXML xml
			select @NodeListXML = (
					select (
							select NodeID "@ID"
							from #Node
							where SortOrder >= IsNull(@offset,0) and SortOrder < IsNull(IsNull(@offset,0)+@limit,SortOrder+1)
							order by SortOrder
							for xml path('Node'), type
							)
					for xml path('NodeList'), type
				)
			exec [RDF.].GetDataRDF @NodeListXML = @NodeListXML, @expand = 1, @showDetails = 0, @returnXML = 0, @dataStr = @ObjectNodesRDF OUTPUT
		*/
		create table #OutputNodes (
			NodeID bigint primary key,
			k int
		)
		insert into #OutputNodes (NodeID,k)
			select NodeID,0
			from #Node
			where SortOrder >= IsNull(@offset,0) and SortOrder < IsNull(IsNull(@offset,0)+@limit,SortOrder+1)
		declare @k int
		select @k = 0
		while @k < 10
		begin
			insert into #OutputNodes (NodeID,k)
				select distinct e.ExpandNodeID, @k+1
				from #OutputNodes o, [Search.Cache].[Public.NodeExpand] e
				where o.k = @k and o.NodeID = e.NodeID
					and e.ExpandNodeID not in (select NodeID from #OutputNodes)
			if @@ROWCOUNT = 0
				select @k = 10
			else
				select @k = @k + 1
		end
		select @ObjectNodesRDF = replace(replace(cast((
				select r.RDF + ''
				from #OutputNodes n, [Search.Cache].[Public.NodeRDF] r
				where n.NodeID = r.NodeID
				order by n.NodeID
				for xml path(''), type
			) as nvarchar(max)),'_TAGLT_','<'),'_TAGGT_','>')
	end


	-------------------------------------------------------
	-- Form search results RDF
	-------------------------------------------------------

	declare @results nvarchar(max)

	select @results = ''
			+'<rdf:Description rdf:nodeID="SearchResults">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Network" />'
			+'<rdfs:label>Search Results</rdfs:label>'
			+'<prns:numberOfConnections rdf:datatype="http://www.w3.org/2001/XMLSchema#int">'+cast(IsNull(@NumberOfConnections,0) as nvarchar(50))+'</prns:numberOfConnections>'
			+'<prns:offset rdf:datatype="http://www.w3.org/2001/XMLSchema#int"' + IsNull('>'+cast(@offset as nvarchar(50))+'</prns:offset>',' />')
			+'<prns:limit rdf:datatype="http://www.w3.org/2001/XMLSchema#int"' + IsNull('>'+cast(@limit as nvarchar(50))+'</prns:limit>',' />')
			+'<prns:maxWeight rdf:datatype="http://www.w3.org/2001/XMLSchema#float"' + IsNull('>'+cast(@MaxWeight as nvarchar(50))+'</prns:maxWeight>',' />')
			+'<prns:minWeight rdf:datatype="http://www.w3.org/2001/XMLSchema#float"' + IsNull('>'+cast(@MinWeight as nvarchar(50))+'</prns:minWeight>',' />')
			+'<vivo:overview rdf:parseType="Literal">'
			+IsNull(cast(@SearchOptions as nvarchar(max)),'')
			+'<SearchDetails>'+IsNull(cast(@SearchPhraseXML as nvarchar(max)),'')+'</SearchDetails>'
			+IsNull('<prns:matchesClassGroupsList>'+@MatchesClassGroups+'</prns:matchesClassGroupsList>','')
			+'</vivo:overview>'
			+IsNull((select replace(replace(cast((
					select '_TAGLT_prns:hasConnection rdf:nodeID="C'+cast(SortOrder as nvarchar(50))+'" /_TAGGT_'
					from #Node
					where SortOrder >= IsNull(@offset,0) and SortOrder < IsNull(IsNull(@offset,0)+@limit,SortOrder+1)
					order by SortOrder
					for xml path(''), type
				) as nvarchar(max)),'_TAGLT_','<'),'_TAGGT_','>')),'')
			+'</rdf:Description>'
			+IsNull((select replace(replace(cast((
					select ''
						+'_TAGLT_rdf:Description rdf:nodeID="C'+cast(x.SortOrder as nvarchar(50))+'"_TAGGT_'
						+'_TAGLT_prns:connectionWeight_TAGGT_'+cast(x.Weight as nvarchar(50))+'_TAGLT_/prns:connectionWeight_TAGGT_'
						+'_TAGLT_prns:sortOrder_TAGGT_'+cast(x.SortOrder as nvarchar(50))+'_TAGLT_/prns:sortOrder_TAGGT_'
						+'_TAGLT_rdf:object rdf:resource="'+replace(n.Value,'"','')+'"/_TAGGT_'
						+'_TAGLT_rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Connection" /_TAGGT_'
						+'_TAGLT_rdfs:label_TAGGT_'+(case when s.ShortLabel<>'' then ltrim(rtrim(s.ShortLabel)) else 'Untitled' end)+'_TAGLT_/rdfs:label_TAGGT_'
						+IsNull(+'_TAGLT_vivo:overview_TAGGT_'+s.ClassName+'_TAGLT_/vivo:overview_TAGGT_','')
						+'_TAGLT_/rdf:Description_TAGGT_'
					from #Node x, [RDF.].Node n, [Search.Cache].[Public.NodeSummary] s
					where x.SortOrder >= IsNull(@offset,0) and x.SortOrder < IsNull(IsNull(@offset,0)+@limit,x.SortOrder+1)
						and x.NodeID = n.NodeID
						and x.NodeID = s.NodeID
					order by x.SortOrder
					for xml path(''), type
				) as nvarchar(max)),'_TAGLT_','<'),'_TAGGT_','>')),'')
			+IsNull(@ObjectNodesRDF,'')

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + @results + '</rdf:RDF>'
	select cast(@x as xml) RDF


	-------------------------------------------------------
	-- Log results
	-------------------------------------------------------

	update [Search.].[History.Query]
		set EndDate = GetDate(),
			DurationMS = datediff(ms,StartDate,GetDate()),
			NumberOfConnections = IsNull(@NumberOfConnections,0)
		where SearchHistoryQueryID = @SearchHistoryQueryID
	
	insert into [Search.].[History.Phrase] (SearchHistoryQueryID, PhraseID, ThesaurusMatch, Phrase, EndDate, IsBot, NumberOfConnections)
		select	@SearchHistoryQueryID,
				PhraseID,
				ThesaurusMatch,
				Phrase,
				GetDate(),
				@IsBot,
				IsNull(@NumberOfConnections,0)
			from @PhraseList

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.Cache].[Public.GetConnection]
	@SearchOptions XML,
	@NodeID BIGINT = NULL,
	@NodeURI VARCHAR(400) = NULL,
	@SessionID UNIQUEIDENTIFIER = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- start timer
	declare @d datetime
	select @d = GetDate()

	-- get the NodeID
	IF (@NodeID IS NULL) AND (@NodeURI IS NOT NULL)
		SELECT @NodeID = [RDF.].fnURI2NodeID(@NodeURI)
	IF @NodeID IS NULL
		RETURN
	SELECT @NodeURI = Value
		FROM [RDF.].Node
		WHERE NodeID = @NodeID

	-- get the search string
	declare @SearchString varchar(500)
	declare @DoExpandedSearch bit
	select	@SearchString = @SearchOptions.value('SearchOptions[1]/MatchOptions[1]/SearchString[1]','varchar(500)'),
			@DoExpandedSearch = (case when @SearchOptions.value('SearchOptions[1]/MatchOptions[1]/SearchString[1]/@ExactMatch','varchar(50)') = 'true' then 0 else 1 end)

	if @SearchString is null
		RETURN

	-- set constants
	declare @baseURI nvarchar(400)
	declare @typeID bigint
	declare @labelID bigint
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
	select @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')

	-------------------------------------------------------
	-- Parse search string and convert to fulltext query
	-------------------------------------------------------
	
	declare @NumberOfPhrases INT
	declare @CombinedSearchString VARCHAR(8000)
	declare @SearchPhraseXML XML
	declare @SearchPhraseFormsXML XML
	declare @ParseProcessTime INT

		
	EXEC [Search.].[ParseSearchString]	@SearchString = @SearchString,
										@NumberOfPhrases = @NumberOfPhrases OUTPUT,
										@CombinedSearchString = @CombinedSearchString OUTPUT,
										@SearchPhraseXML = @SearchPhraseXML OUTPUT,
										@SearchPhraseFormsXML = @SearchPhraseFormsXML OUTPUT,
										@ProcessTime = @ParseProcessTime OUTPUT

	declare @PhraseList table (PhraseID int, Phrase varchar(max), ThesaurusMatch bit, Forms varchar(max))
	insert into @PhraseList (PhraseID, Phrase, ThesaurusMatch, Forms)
	select	x.value('@ID','INT'),
			x.value('.','VARCHAR(MAX)'),
			x.value('@ThesaurusMatch','BIT'),
			x.value('@Forms','VARCHAR(MAX)')
		from @SearchPhraseFormsXML.nodes('//SearchPhrase') as p(x)


	-------------------------------------------------------
	-- Find matching nodes connected to NodeID
	-------------------------------------------------------

	-- Get nodes that match separate phrases
	create table #PhraseNodeMap (
		PhraseID int not null,
		NodeID bigint not null,
		MatchedByNodeID bigint not null,
		Distance int,
		Paths int,
		MapWeight float,
		TextWeight float,
		Weight float
	)
	if (@DoExpandedSearch = 1)
	begin
		declare @PhraseSearchString varchar(8000)
		declare @loop int
		select @loop = 1
		while @loop <= @NumberOfPhrases
		begin
			select @PhraseSearchString = Forms
				from @PhraseList
				where PhraseID = @loop
			insert into #PhraseNodeMap (PhraseID, NodeID, MatchedByNodeID, Distance, Paths, MapWeight, TextWeight, Weight)
				select @loop, s.NodeID, s.MatchedByNodeID, s.Distance, s.Paths, s.Weight, m.Weight,
						(case when s.Weight*m.Weight > 0.999999 then 0.999999 else s.Weight*m.Weight end) Weight
					from [Search.Cache].[Public.NodeMap] s, (
						select [Key] NodeID, [Rank]*0.001 Weight
							from Containstable ([RDF.].Node, value, @PhraseSearchString) n
					) m
					where s.MatchedByNodeID = m.NodeID and s.NodeID = @NodeID
			select @loop = @loop + 1
		end
	end
	else
	begin
		insert into #PhraseNodeMap (PhraseID, NodeID, MatchedByNodeID, Distance, Paths, MapWeight, TextWeight, Weight)
			select 1, s.NodeID, s.MatchedByNodeID, s.Distance, s.Paths, s.Weight, m.Weight,
					(case when s.Weight*m.Weight > 0.999999 then 0.999999 else s.Weight*m.Weight end) Weight
				from [Search.Cache].[Public.NodeMap] s, (
					select [Key] NodeID, [Rank]*0.001 Weight
						from Containstable ([RDF.].Node, value, @CombinedSearchString) n
				) m
				where s.MatchedByNodeID = m.NodeID and s.NodeID = @NodeID
	end


	-------------------------------------------------------
	-- Get details on the matches
	-------------------------------------------------------
	

	;WITH m AS (
		SELECT 1 DirectMatch, NodeID, NodeID MiddleNodeID, MatchedByNodeID, 
				COUNT(DISTINCT PhraseID) Phrases, 1-exp(sum(log(1-Weight))) Weight
			FROM #PhraseNodeMap
			WHERE Distance = 1
			GROUP BY NodeID, MatchedByNodeID
		UNION ALL
		SELECT 0 DirectMatch, d.NodeID, y.NodeID MiddleNodeID, d.MatchedByNodeID,
				COUNT(DISTINCT d.PhraseID) Phrases, 1-exp(sum(log(1-d.Weight))) Weight
			FROM #PhraseNodeMap d
				INNER JOIN [Search.Cache].[Public.NodeMap] x
					ON x.NodeID = d.NodeID
						AND x.Distance = d.Distance - 1
				INNER JOIN [Search.Cache].[Public.NodeMap] y
					ON y.NodeID = x.MatchedByNodeID
						AND y.MatchedByNodeID = d.MatchedByNodeID
						AND y.Distance = 1
			WHERE d.Distance > 1
			GROUP BY d.NodeID, d.MatchedByNodeID, y.NodeID
	), w as (
		SELECT DISTINCT m.DirectMatch, m.NodeID, m.MiddleNodeID, m.MatchedByNodeID, m.Phrases, m.Weight,
			p._PropertyLabel PropertyLabel, p._PropertyNode PropertyNode
		FROM m
			INNER JOIN [Search.Cache].[Public.NodeClass] c
				ON c.NodeID = m.MiddleNodeID
			INNER JOIN [Ontology.].[ClassProperty] p
				ON p._ClassNode = c.Class
					AND p._NetworkPropertyNode IS NULL
					AND p.SearchWeight > 0
			INNER JOIN [RDF.].Triple t
				ON t.subject = m.MiddleNodeID
					AND t.predicate = p._PropertyNode
					AND t.object = m.MatchedByNodeID
	)
	SELECT w.DirectMatch, w.Phrases, w.Weight,
			n.NodeID, n.Value URI, c.ShortLabel Label, c.ClassName, 
			w.PropertyLabel Predicate, 
			w.MatchedByNodeID, o.value Value
		INTO #MatchDetails
		FROM w
			INNER JOIN [RDF.].Node n
				ON n.NodeID = w.MiddleNodeID
			INNER JOIN [Search.Cache].[Public.NodeSummary] c
				ON c.NodeID = w.MiddleNodeID
			INNER JOIN [RDF.].Node o
				ON o.NodeID = w.MatchedByNodeID

	UPDATE #MatchDetails
		SET Weight = (CASE WHEN Weight > 0.999999 THEN 999999 WHEN Weight < 0.000001 THEN 0.000001 ELSE Weight END)

	-------------------------------------------------------
	-- Build ConnectionDetailsXML
	-------------------------------------------------------

	DECLARE @ConnectionDetailsXML XML
	
	;WITH a AS (
		SELECT DirectMatch, NodeID, URI, Label, ClassName, 
				COUNT(*) NumberOfProperties, 1-exp(sum(log(1-Weight))) Weight,
				(
					SELECT	p.Predicate "Name",
							p.Phrases "NumberOfPhrases",
							p.Weight "Weight",
							p.Value "Value",
							(
								SELECT r.Phrase "MatchedPhrase"
								FROM #PhraseNodeMap q, @PhraseList r
								WHERE q.MatchedByNodeID = p.MatchedByNodeID
									AND r.PhraseID = q.PhraseID
								ORDER BY r.PhraseID
								FOR XML PATH(''), TYPE
							) "MatchedPhraseList"
						FROM #MatchDetails p
						WHERE p.DirectMatch = m.DirectMatch
							AND p.NodeID = m.NodeID
						ORDER BY p.Predicate
						FOR XML PATH('Property'), TYPE
				) PropertyList
			FROM #MatchDetails m
			GROUP BY DirectMatch, NodeID, URI, Label, ClassName
	)
	SELECT @ConnectionDetailsXML = (
		SELECT	(
					SELECT	NodeID "NodeID",
							URI "URI",
							Label "Label",
							ClassName "ClassName",
							NumberOfProperties "NumberOfProperties",
							Weight "Weight",
							PropertyList "PropertyList"
					FROM a
					WHERE DirectMatch = 1
					FOR XML PATH('Match'), TYPE
				) "DirectMatchList",
				(
					SELECT	NodeID "NodeID",
							URI "URI",
							Label "Label",
							ClassName "ClassName",
							NumberOfProperties "NumberOfProperties",
							Weight "Weight",
							PropertyList "PropertyList"
					FROM a
					WHERE DirectMatch = 0
					FOR XML PATH('Match'), TYPE
				) "IndirectMatchList"				
		FOR XML PATH(''), TYPE
	)
	
	--SELECT @ConnectionDetailsXML ConnectionDetails
	--SELECT * FROM #PhraseNodeMap


	-------------------------------------------------------
	-- Get RDF of the NodeID
	-------------------------------------------------------

	DECLARE @ObjectNodeRDF NVARCHAR(MAX)
	
	EXEC [RDF.].GetDataRDF	@subject = @NodeID,
							@showDetails = 0,
							@expand = 0,
							@SessionID = @SessionID,
							@returnXML = 0,
							@dataStr = @ObjectNodeRDF OUTPUT


	-------------------------------------------------------
	-- Form search results details RDF
	-------------------------------------------------------

	DECLARE @results NVARCHAR(MAX)

	SELECT @results = ''
			+'<rdf:Description rdf:nodeID="SearchResultsDetails">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Connection" />'
			+'<prns:connectionInNetwork rdf:NodeID="SearchResults" />'
			--+'<prns:connectionWeight>0.37744</prns:connectionWeight>'
			+'<prns:hasConnectionDetails rdf:NodeID="ConnectionDetails" />'
			+'<rdf:object rdf:resource="'+@NodeURI+'" />'
			+'<rdfs:label>Search Results Details</rdfs:label>'
			+'</rdf:Description>'
			+'<rdf:Description rdf:nodeID="SearchResults">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Network" />'
			+'<rdfs:label>Search Results</rdfs:label>'
			+'<vivo:overview rdf:parseType="Literal">'
			+CAST(@SearchOptions AS NVARCHAR(MAX))
			+IsNull('<SearchDetails>'+CAST(@SearchPhraseXML AS NVARCHAR(MAX))+'</SearchDetails>','')
			+'</vivo:overview>'
			+'<prns:hasConnection rdf:nodeID="SearchResultsDetails" />'
			+'</rdf:Description>'
			+IsNull(@ObjectNodeRDF,'')
			+'<rdf:Description rdf:NodeID="ConnectionDetails">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#ConnectionDetails" />'
			+'<vivo:overview rdf:parseType="Literal">'
			+CAST(@ConnectionDetailsXML AS NVARCHAR(MAX))
			+'</vivo:overview>'
			+'</rdf:Description> '

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + @results + '</rdf:RDF>'
	select cast(@x as xml) RDF

/*


	EXEC [Search.].[GetNodes] @SearchOptions = '
	<SearchOptions>
		<MatchOptions>
			<SearchString ExactMatch="false">options for "lung cancer" treatment</SearchString>
			<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
		</MatchOptions>
		<OutputOptions>
			<Offset>0</Offset>
			<Limit>5</Limit>
		</OutputOptions>	
	</SearchOptions>
	'

	EXEC [Search.].[GetConnection] @SearchOptions = '
	<SearchOptions>
		<MatchOptions>
			<SearchString ExactMatch="false">options for "lung cancer" treatment</SearchString>
			<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
		</MatchOptions>
		<OutputOptions>
			<Offset>0</Offset>
			<Limit>5</Limit>
		</OutputOptions>	
	</SearchOptions>
	', @NodeURI = 'http://localhost:55956/profile/1069731'


*/


END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.Cache].[Private.GetNodes]
@SearchOptions XML, @SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

	/*
	
	EXEC [Search.].[Private.GetNodes] @SearchOptions = '
	<SearchOptions>
		<MatchOptions>
			<SearchString ExactMatch="false">options for "lung cancer" treatment</SearchString>
			<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
			<SearchFiltersList>
				<SearchFilter Property="http://xmlns.com/foaf/0.1/lastName" MatchType="Left">Smit</SearchFilter>
			</SearchFiltersList>
		</MatchOptions>
		<OutputOptions>
			<Offset>0</Offset>
			<Limit>5</Limit>
			<SortByList>
				<SortBy IsDesc="1" Property="http://xmlns.com/foaf/0.1/firstName" />
				<SortBy IsDesc="0" Property="http://xmlns.com/foaf/0.1/lastName" />
			</SortByList>
		</OutputOptions>	
	</SearchOptions>
	'
		
	*/

	declare @MatchOptions xml
	declare @OutputOptions xml
	declare @SearchString varchar(500)
	declare @ClassGroupURI varchar(400)
	declare @ClassURI varchar(400)
	declare @SearchFiltersXML xml
	declare @offset bigint
	declare @limit bigint
	declare @SortByXML xml
	declare @DoExpandedSearch bit
	
	select	@MatchOptions = @SearchOptions.query('SearchOptions[1]/MatchOptions[1]'),
			@OutputOptions = @SearchOptions.query('SearchOptions[1]/OutputOptions[1]')
	
	select	@SearchString = @MatchOptions.value('MatchOptions[1]/SearchString[1]','varchar(500)'),
			@DoExpandedSearch = (case when @MatchOptions.value('MatchOptions[1]/SearchString[1]/@ExactMatch','varchar(50)') = 'true' then 0 else 1 end),
			@ClassGroupURI = @MatchOptions.value('MatchOptions[1]/ClassGroupURI[1]','varchar(400)'),
			@ClassURI = @MatchOptions.value('MatchOptions[1]/ClassURI[1]','varchar(400)'),
			@SearchFiltersXML = @MatchOptions.query('MatchOptions[1]/SearchFiltersList[1]'),
			@offset = @OutputOptions.value('OutputOptions[1]/Offset[1]','bigint'),
			@limit = @OutputOptions.value('OutputOptions[1]/Limit[1]','bigint'),
			@SortByXML = @OutputOptions.query('OutputOptions[1]/SortByList[1]')

	declare @baseURI nvarchar(400)
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'

	declare @d datetime
	select @d = GetDate()
	

	-------------------------------------------------------
	-- Parse search string and convert to fulltext query
	-------------------------------------------------------

	declare @NumberOfPhrases INT
	declare @CombinedSearchString VARCHAR(8000)
	declare @SearchPhraseXML XML
	declare @SearchPhraseFormsXML XML
	declare @ParseProcessTime INT

	EXEC [Search.].[ParseSearchString]	@SearchString = @SearchString,
										@NumberOfPhrases = @NumberOfPhrases OUTPUT,
										@CombinedSearchString = @CombinedSearchString OUTPUT,
										@SearchPhraseXML = @SearchPhraseXML OUTPUT,
										@SearchPhraseFormsXML = @SearchPhraseFormsXML OUTPUT,
										@ProcessTime = @ParseProcessTime OUTPUT

	declare @PhraseList table (PhraseID int, Phrase varchar(max), ThesaurusMatch bit, Forms varchar(max))
	insert into @PhraseList (PhraseID, Phrase, ThesaurusMatch, Forms)
	select	x.value('@ID','INT'),
			x.value('.','VARCHAR(MAX)'),
			x.value('@ThesaurusMatch','BIT'),
			x.value('@Forms','VARCHAR(MAX)')
		from @SearchPhraseFormsXML.nodes('//SearchPhrase') as p(x)

	--SELECT @NumberOfPhrases, @CombinedSearchString, @SearchPhraseXML, @SearchPhraseFormsXML, @ParseProcessTime
	--SELECT * FROM @PhraseList
	--select datediff(ms,@d,GetDate())


	-------------------------------------------------------
	-- Parse search filters
	-------------------------------------------------------

	create table #SearchFilters (
		SearchFilterID int identity(0,1) primary key,
		IsExclude bit,
		PropertyURI varchar(400),
		PropertyURI2 varchar(400),
		Value varchar(750),
		Predicate bigint,
		Predicate2 bigint
	)
	
	insert into #SearchFilters (IsExclude, PropertyURI, PropertyURI2, Value, Predicate, Predicate2)	
		select t.IsExclude, t.PropertyURI, t.PropertyURI2, 
				left(t.Value,750)+(case when t.MatchType='Left' then '%' else '' end),
				t.Predicate, t.Predicate2
			from (
				select IsNull(IsExclude,0) IsExclude, PropertyURI, PropertyURI2, MatchType, Value,
					[RDF.].fnURI2NodeID(PropertyURI) Predicate,
					[RDF.].fnURI2NodeID(PropertyURI2) Predicate2
				from (
					select distinct S.x.value('@IsExclude','bit') IsExclude,
							S.x.value('@Property','varchar(400)') PropertyURI,
							S.x.value('@Property2','varchar(400)') PropertyURI2,
							S.x.value('@MatchType','varchar(100)') MatchType,
							S.x.value('.','nvarchar(max)') Value
					from @SearchFiltersXML.nodes('//SearchFilter') as S(x)
				) t
			) t
			where t.Value IS NOT NULL and t.Value <> ''
			
	declare @NumberOfIncludeFilters int
	select @NumberOfIncludeFilters = IsNull((select count(*) from #SearchFilters where IsExclude=0),0)

	-------------------------------------------------------
	-- Parse sort by options
	-------------------------------------------------------

	create table #SortBy (
		SortByID int identity(1,1) primary key,
		IsDesc bit,
		PropertyURI varchar(400),
		PropertyURI2 varchar(400),
		PropertyURI3 varchar(400),
		Predicate bigint,
		Predicate2 bigint,
		Predicate3 bigint
	)
	
	insert into #SortBy (IsDesc, PropertyURI, PropertyURI2, PropertyURI3, Predicate, Predicate2, Predicate3)	
		select IsNull(IsDesc,0), PropertyURI, PropertyURI2, PropertyURI3,
				[RDF.].fnURI2NodeID(PropertyURI) Predicate,
				[RDF.].fnURI2NodeID(PropertyURI2) Predicate2,
				[RDF.].fnURI2NodeID(PropertyURI3) Predicate3
			from (
				select S.x.value('@IsDesc','bit') IsDesc,
						S.x.value('@Property','varchar(400)') PropertyURI,
						S.x.value('@Property2','varchar(400)') PropertyURI2,
						S.x.value('@Property3','varchar(400)') PropertyURI3
				from @SortByXML.nodes('//SortBy') as S(x)
			) t

	-------------------------------------------------------
	-- Get initial list of matching nodes (before filters)
	-------------------------------------------------------

	create table #FullNodeMatch (
		NodeID bigint not null,
		Paths bigint,
		Weight float
	)

	if @CombinedSearchString <> ''
	begin

		-- Get nodes that match separate phrases
		create table #PhraseNodeMatch (
			PhraseID int not null,
			NodeID bigint not null,
			Paths bigint,
			Weight float
		)
		if (@NumberOfPhrases > 1) and (@DoExpandedSearch = 1)
		begin
			declare @PhraseSearchString varchar(8000)
			declare @loop int
			select @loop = 1
			while @loop <= @NumberOfPhrases
			begin
				select @PhraseSearchString = Forms
					from @PhraseList
					where PhraseID = @loop
				insert into #PhraseNodeMatch (PhraseID, NodeID, Paths, Weight)
					select @loop, s.NodeID, count(*) Paths, 1-exp(sum(log(case when s.Weight*m.Weight > 0.999999 then 0.000001 else 1-s.Weight*m.Weight end))) Weight
						from [Search.Cache].[Private.NodeMap] s, (
							select [Key] NodeID, [Rank]*0.001 Weight
								from Containstable ([RDF.].Node, value, @PhraseSearchString) n
						) m
						where s.MatchedByNodeID = m.NodeID
						group by s.NodeID
				select @loop = @loop + 1
			end
			--create clustered index idx_n on #PhraseNodeMatch(NodeID)
		end

		create table #TempMatchNodes (
			NodeID bigint,
			MatchedByNodeID bigint,
			Distance int,
			Paths int,
			Weight float,
			mWeight float
		)
		insert into #TempMatchNodes (NodeID, MatchedByNodeID, Distance, Paths, Weight, mWeight)
			select s.*, m.Weight mWeight
				from [Search.Cache].[Private.NodeMap] s, (
					select [Key] NodeID, [Rank]*0.001 Weight
						from Containstable ([RDF.].Node, value, @CombinedSearchString) n
				) m
				where s.MatchedByNodeID = m.NodeID

		insert into #FullNodeMatch (NodeID, Paths, Weight)
			select IsNull(a.NodeID,b.NodeID) NodeID, IsNull(a.Paths,b.Paths) Paths,
					(case when a.weight is null or b.weight is null then IsNull(a.Weight,b.Weight) else 1-(1-a.Weight)*(1-b.Weight) end) Weight
				from (
					select NodeID, exp(sum(log(Paths))) Paths, exp(sum(log(Weight))) Weight
						from #PhraseNodeMatch
						group by NodeID
						having count(*) = @NumberOfPhrases
				) a full outer join (
					select NodeID, count(*) Paths, 1-exp(sum(log(case when Weight*mWeight > 0.999999 then 0.000001 else 1-Weight*mWeight end))) Weight
						from #TempMatchNodes
						group by NodeID
				) b on a.NodeID = b.NodeID
		--select 'Text Matches Found', datediff(ms,@d,getdate())
	end
	else if (@NumberOfIncludeFilters > 0)
	begin
		insert into #FullNodeMatch (NodeID, Paths, Weight)
			select t1.Subject, 1, 1
				from #SearchFilters f
					inner join [RDF.].Triple t1
						on f.Predicate is not null
							and t1.Predicate = f.Predicate 
							and t1.ViewSecurityGroup between -30 and -1
					left outer join [Search.Cache].[Private.NodePrefix] n1
						on n1.NodeID = t1.Object
					left outer join [RDF.].Triple t2
						on f.Predicate2 is not null
							and t2.Subject = n1.NodeID
							and t2.Predicate = f.Predicate2
							and t2.ViewSecurityGroup between -30 and -1
					left outer join [Search.Cache].[Private.NodePrefix] n2
						on n2.NodeID = t2.Object
				where f.IsExclude = 0
					and (case when f.Predicate2 is not null then n2.Prefix else n1.Prefix end)
						like f.Value
				group by t1.Subject
				having count(distinct f.SearchFilterID) = @NumberOfIncludeFilters
		delete from #SearchFilters where IsExclude = 0
		select @NumberOfIncludeFilters = 0
	end
	else if (IsNull(@ClassGroupURI,'') <> '' or IsNull(@ClassURI,'') <> '')
	begin
		insert into #FullNodeMatch (NodeID, Paths, Weight)
			select n.NodeID, 1, 1
				from [Search.Cache].[Private.NodeClass] n, [Ontology.].ClassGroupClass c
				where n.Class = c._ClassNode
					and ((@ClassGroupURI is null) or (c.ClassGroupURI = @ClassGroupURI))
					and ((@ClassURI is null) or (c.ClassURI = @ClassURI))
		select @ClassGroupURI = null, @ClassURI = null
	end

	-------------------------------------------------------
	-- Run the actual search
	-------------------------------------------------------
	create table #Node (
		SortOrder bigint identity(0,1) primary key,
		NodeID bigint,
		Paths bigint,
		Weight float
	)

	insert into #Node (NodeID, Paths, Weight)
		select s.NodeID, s.Paths, s.Weight
			from #FullNodeMatch s
				inner join [Search.Cache].[Private.NodeSummary] n on
					s.NodeID = n.NodeID
					and ( IsNull(@ClassGroupURI,@ClassURI) is null or s.NodeID in (
							select NodeID
								from [Search.Cache].[Private.NodeClass] x, [Ontology.].ClassGroupClass c
								where x.Class = c._ClassNode
									and c.ClassGroupURI = IsNull(@ClassGroupURI,c.ClassGroupURI)
									and c.ClassURI = IsNull(@ClassURI,c.ClassURI)
						) )
					and ( @NumberOfIncludeFilters =
							(select count(distinct f.SearchFilterID)
								from #SearchFilters f
									inner join [RDF.].Triple t1
										on f.Predicate is not null
											and t1.Subject = s.NodeID
											and t1.Predicate = f.Predicate 
											and t1.ViewSecurityGroup between -30 and -1
									left outer join [Search.Cache].[Private.NodePrefix] n1
										on n1.NodeID = t1.Object
									left outer join [RDF.].Triple t2
										on f.Predicate2 is not null
											and t2.Subject = n1.NodeID
											and t2.Predicate = f.Predicate2
											and t2.ViewSecurityGroup between -30 and -1
									left outer join [Search.Cache].[Private.NodePrefix] n2
										on n2.NodeID = t2.Object
								where f.IsExclude = 0
									and (case when f.Predicate2 is not null then n2.Prefix else n1.Prefix end)
										like f.Value
							)
						)
					and not exists (
							select *
								from #SearchFilters f
									inner join [RDF.].Triple t1
										on f.Predicate is not null
											and t1.Subject = s.NodeID
											and t1.Predicate = f.Predicate 
											and t1.ViewSecurityGroup between -30 and -1
									left outer join [Search.Cache].[Private.NodePrefix] n1
										on n1.NodeID = t1.Object
									left outer join [RDF.].Triple t2
										on f.Predicate2 is not null
											and t2.Subject = n1.NodeID
											and t2.Predicate = f.Predicate2
											and t2.ViewSecurityGroup between -30 and -1
									left outer join [Search.Cache].[Private.NodePrefix] n2
										on n2.NodeID = t2.Object
								where f.IsExclude = 1
									and (case when f.Predicate2 is not null then n2.Prefix else n1.Prefix end)
										like f.Value
						)
				outer apply (
					select	max(case when SortByID=1 then AscSortBy else null end) AscSortBy1,
							max(case when SortByID=2 then AscSortBy else null end) AscSortBy2,
							max(case when SortByID=3 then AscSortBy else null end) AscSortBy3,
							max(case when SortByID=1 then DescSortBy else null end) DescSortBy1,
							max(case when SortByID=2 then DescSortBy else null end) DescSortBy2,
							max(case when SortByID=3 then DescSortBy else null end) DescSortBy3
						from (
							select	SortByID,
									(case when f.IsDesc = 1 then null
											when f.Predicate3 is not null then n3.Value
											when f.Predicate2 is not null then n2.Value
											else n1.Value end) AscSortBy,
									(case when f.IsDesc = 0 then null
											when f.Predicate3 is not null then n3.Value
											when f.Predicate2 is not null then n2.Value
											else n1.Value end) DescSortBy
								from #SortBy f
									inner join [RDF.].Triple t1
										on f.Predicate is not null
											and t1.Subject = s.NodeID
											and t1.Predicate = f.Predicate 
											and t1.ViewSecurityGroup between -30 and -1
									left outer join [RDF.].Node n1
										on n1.NodeID = t1.Object
											and n1.ViewSecurityGroup between -30 and -1
									left outer join [RDF.].Triple t2
										on f.Predicate2 is not null
											and t2.Subject = n1.NodeID
											and t2.Predicate = f.Predicate2
											and t2.ViewSecurityGroup between -30 and -1
									left outer join [RDF.].Node n2
										on n2.NodeID = t2.Object
											and n2.ViewSecurityGroup between -30 and -1
									left outer join [RDF.].Triple t3
										on f.Predicate3 is not null
											and t3.Subject = n2.NodeID
											and t3.Predicate = f.Predicate3
											and t3.ViewSecurityGroup between -30 and -1
									left outer join [RDF.].Node n3
										on n3.NodeID = t3.Object
											and n3.ViewSecurityGroup between -30 and -1
							) t
					) o
			order by	(case when o.AscSortBy1 is null then 1 else 0 end),
						o.AscSortBy1,
						(case when o.DescSortBy1 is null then 1 else 0 end),
						o.DescSortBy1 desc,
						(case when o.AscSortBy2 is null then 1 else 0 end),
						o.AscSortBy2,
						(case when o.DescSortBy2 is null then 1 else 0 end),
						o.DescSortBy2 desc,
						(case when o.AscSortBy3 is null then 1 else 0 end),
						o.AscSortBy3,
						(case when o.DescSortBy3 is null then 1 else 0 end),
						o.DescSortBy3 desc,
						s.Weight desc,
						n.ShortLabel,
						n.NodeID


	--select 'Search Nodes Found', datediff(ms,@d,GetDate())

	-------------------------------------------------------
	-- Get network counts
	-------------------------------------------------------

	declare @NumberOfConnections as bigint
	declare @MaxWeight as float
	declare @MinWeight as float

	select @NumberOfConnections = count(*), @MaxWeight = max(Weight), @MinWeight = min(Weight) 
		from #Node

	-------------------------------------------------------
	-- Get matching class groups and classes
	-------------------------------------------------------

	declare @MatchesClassGroups nvarchar(max)

	select c.ClassGroupURI, c.ClassURI, n.NodeID
		into #NodeClass
		from #Node n, [Search.Cache].[Private.NodeClass] s, [Ontology.].ClassGroupClass c
		where n.NodeID = s.NodeID and s.Class = c._ClassNode

	;with a as (
		select ClassGroupURI, count(distinct NodeID) NumberOfNodes
			from #NodeClass s
			group by ClassGroupURI
	), b as (
		select ClassGroupURI, ClassURI, count(distinct NodeID) NumberOfNodes
			from #NodeClass s
			group by ClassGroupURI, ClassURI
	)
	select @MatchesClassGroups = replace(cast((
			select	g.ClassGroupURI "@rdf_.._resource", 
				g._ClassGroupLabel "rdfs_.._label",
				'http://www.w3.org/2001/XMLSchema#int' "prns_.._numberOfConnections/@rdf_.._datatype",
				a.NumberOfNodes "prns_.._numberOfConnections",
				g.SortOrder "prns_.._sortOrder",
				(
					select	c.ClassURI "@rdf_.._resource",
							c._ClassLabel "rdfs_.._label",
							'http://www.w3.org/2001/XMLSchema#int' "prns_.._numberOfConnections/@rdf_.._datatype",
							b.NumberOfNodes "prns_.._numberOfConnections",
							c.SortOrder "prns_.._sortOrder"
						from b, [Ontology.].ClassGroupClass c
						where b.ClassGroupURI = c.ClassGroupURI and b.ClassURI = c.ClassURI
							and c.ClassGroupURI = g.ClassGroupURI
						order by c.SortOrder
						for xml path('prns_.._matchesClass'), type
				)
			from a, [Ontology.].ClassGroup g
			where a.ClassGroupURI = g.ClassGroupURI
			order by g.SortOrder
			for xml path('prns_.._matchesClassGroup'), type
		) as nvarchar(max)),'_.._',':')

	-------------------------------------------------------
	-- Get RDF of search results objects
	-------------------------------------------------------

	declare @ObjectNodesRDF nvarchar(max)

	if @NumberOfConnections > 0
	begin
		/*
			-- Alternative methods that uses GetDataRDF to get the RDF
			declare @NodeListXML xml
			select @NodeListXML = (
					select (
							select NodeID "@ID"
							from #Node
							where SortOrder >= IsNull(@offset,0) and SortOrder < IsNull(IsNull(@offset,0)+@limit,SortOrder+1)
							order by SortOrder
							for xml path('Node'), type
							)
					for xml path('NodeList'), type
				)
			exec [RDF.].GetDataRDF @NodeListXML = @NodeListXML, @expand = 1, @showDetails = 0, @returnXML = 0, @dataStr = @ObjectNodesRDF OUTPUT
		*/
		create table #OutputNodes (
			NodeID bigint primary key,
			k int
		)
		insert into #OutputNodes (NodeID,k)
			select NodeID,0
			from #Node
			where SortOrder >= IsNull(@offset,0) and SortOrder < IsNull(IsNull(@offset,0)+@limit,SortOrder+1)
		declare @k int
		select @k = 0
		while @k < 10
		begin
			insert into #OutputNodes (NodeID,k)
				select distinct e.ExpandNodeID, @k+1
				from #OutputNodes o, [Search.Cache].[Private.NodeExpand] e
				where o.k = @k and o.NodeID = e.NodeID
					and e.ExpandNodeID not in (select NodeID from #OutputNodes)
			if @@ROWCOUNT = 0
				select @k = 10
			else
				select @k = @k + 1
		end
		select @ObjectNodesRDF = replace(replace(cast((
				select r.RDF + ''
				from #OutputNodes n, [Search.Cache].[Private.NodeRDF] r
				where n.NodeID = r.NodeID
				order by n.NodeID
				for xml path(''), type
			) as nvarchar(max)),'_TAGLT_','<'),'_TAGGT_','>')
	end


	-------------------------------------------------------
	-- Form search results RDF
	-------------------------------------------------------

	declare @results nvarchar(max)

	select @results = ''
			+'<rdf:Description rdf:nodeID="SearchResults">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Network" />'
			+'<rdfs:label>Search Results</rdfs:label>'
			+'<prns:numberOfConnections rdf:datatype="http://www.w3.org/2001/XMLSchema#int">'+cast(IsNull(@NumberOfConnections,0) as nvarchar(50))+'</prns:numberOfConnections>'
			+'<prns:offset rdf:datatype="http://www.w3.org/2001/XMLSchema#int"' + IsNull('>'+cast(@offset as nvarchar(50))+'</prns:offset>',' />')
			+'<prns:limit rdf:datatype="http://www.w3.org/2001/XMLSchema#int"' + IsNull('>'+cast(@limit as nvarchar(50))+'</prns:limit>',' />')
			+'<prns:maxWeight rdf:datatype="http://www.w3.org/2001/XMLSchema#float"' + IsNull('>'+cast(@MaxWeight as nvarchar(50))+'</prns:maxWeight>',' />')
			+'<prns:minWeight rdf:datatype="http://www.w3.org/2001/XMLSchema#float"' + IsNull('>'+cast(@MinWeight as nvarchar(50))+'</prns:minWeight>',' />')
			+'<vivo:overview rdf:parseType="Literal">'
			+IsNull(cast(@SearchOptions as nvarchar(max)),'')
			+'<SearchDetails>'+IsNull(cast(@SearchPhraseXML as nvarchar(max)),'')+'</SearchDetails>'
			+IsNull('<prns:matchesClassGroupsList>'+@MatchesClassGroups+'</prns:matchesClassGroupsList>','')
			+'</vivo:overview>'
			+IsNull((select replace(replace(cast((
					select '_TAGLT_prns:hasConnection rdf:nodeID="C'+cast(SortOrder as nvarchar(50))+'" /_TAGGT_'
					from #Node
					where SortOrder >= IsNull(@offset,0) and SortOrder < IsNull(IsNull(@offset,0)+@limit,SortOrder+1)
					order by SortOrder
					for xml path(''), type
				) as nvarchar(max)),'_TAGLT_','<'),'_TAGGT_','>')),'')
			+'</rdf:Description>'
			+IsNull((select replace(replace(cast((
					select ''
						+'_TAGLT_rdf:Description rdf:nodeID="C'+cast(x.SortOrder as nvarchar(50))+'"_TAGGT_'
						+'_TAGLT_prns:connectionWeight_TAGGT_'+cast(x.Weight as nvarchar(50))+'_TAGLT_/prns:connectionWeight_TAGGT_'
						+'_TAGLT_prns:sortOrder_TAGGT_'+cast(x.SortOrder as nvarchar(50))+'_TAGLT_/prns:sortOrder_TAGGT_'
						+'_TAGLT_rdf:object rdf:resource="'+replace(n.Value,'"','')+'"/_TAGGT_'
						+'_TAGLT_rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Connection" /_TAGGT_'
						+'_TAGLT_rdfs:label_TAGGT_'+(case when s.ShortLabel<>'' then ltrim(rtrim(s.ShortLabel)) else 'Untitled' end)+'_TAGLT_/rdfs:label_TAGGT_'
						+IsNull(+'_TAGLT_vivo:overview_TAGGT_'+s.ClassName+'_TAGLT_/vivo:overview_TAGGT_','')
						+'_TAGLT_/rdf:Description_TAGGT_'
					from #Node x, [RDF.].Node n, [Search.Cache].[Private.NodeSummary] s
					where x.SortOrder >= IsNull(@offset,0) and x.SortOrder < IsNull(IsNull(@offset,0)+@limit,x.SortOrder+1)
						and x.NodeID = n.NodeID
						and x.NodeID = s.NodeID
					order by x.SortOrder
					for xml path(''), type
				) as nvarchar(max)),'_TAGLT_','<'),'_TAGGT_','>')),'')
			+IsNull(@ObjectNodesRDF,'')

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + @results + '</rdf:RDF>'
	select cast(@x as xml) RDF


END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.Cache].[Private.GetConnection]
	@SearchOptions XML,
	@NodeID BIGINT = NULL,
	@NodeURI VARCHAR(400) = NULL,
	@SessionID UNIQUEIDENTIFIER = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- start timer
	declare @d datetime
	select @d = GetDate()

	-- get the NodeID
	IF (@NodeID IS NULL) AND (@NodeURI IS NOT NULL)
		SELECT @NodeID = [RDF.].fnURI2NodeID(@NodeURI)
	IF @NodeID IS NULL
		RETURN
	SELECT @NodeURI = Value
		FROM [RDF.].Node
		WHERE NodeID = @NodeID

	-- get the search string
	declare @SearchString varchar(500)
	declare @DoExpandedSearch bit
	select	@SearchString = @SearchOptions.value('SearchOptions[1]/MatchOptions[1]/SearchString[1]','varchar(500)'),
			@DoExpandedSearch = (case when @SearchOptions.value('SearchOptions[1]/MatchOptions[1]/SearchString[1]/@ExactMatch','varchar(50)') = 'true' then 0 else 1 end)

	if @SearchString is null
		RETURN

	-- set constants
	declare @baseURI nvarchar(400)
	declare @typeID bigint
	declare @labelID bigint
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
	select @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')

	-------------------------------------------------------
	-- Parse search string and convert to fulltext query
	-------------------------------------------------------
	
	declare @NumberOfPhrases INT
	declare @CombinedSearchString VARCHAR(8000)
	declare @SearchPhraseXML XML
	declare @SearchPhraseFormsXML XML
	declare @ParseProcessTime INT

		
	EXEC [Search.].[ParseSearchString]	@SearchString = @SearchString,
										@NumberOfPhrases = @NumberOfPhrases OUTPUT,
										@CombinedSearchString = @CombinedSearchString OUTPUT,
										@SearchPhraseXML = @SearchPhraseXML OUTPUT,
										@SearchPhraseFormsXML = @SearchPhraseFormsXML OUTPUT,
										@ProcessTime = @ParseProcessTime OUTPUT

	declare @PhraseList table (PhraseID int, Phrase varchar(max), ThesaurusMatch bit, Forms varchar(max))
	insert into @PhraseList (PhraseID, Phrase, ThesaurusMatch, Forms)
	select	x.value('@ID','INT'),
			x.value('.','VARCHAR(MAX)'),
			x.value('@ThesaurusMatch','BIT'),
			x.value('@Forms','VARCHAR(MAX)')
		from @SearchPhraseFormsXML.nodes('//SearchPhrase') as p(x)


	-------------------------------------------------------
	-- Find matching nodes connected to NodeID
	-------------------------------------------------------


	-- Get nodes that match separate phrases
	create table #PhraseNodeMap (
		PhraseID int not null,
		NodeID bigint not null,
		MatchedByNodeID bigint not null,
		Distance int,
		Paths int,
		MapWeight float,
		TextWeight float,
		Weight float
	)
	if (@DoExpandedSearch = 1)
	begin
		declare @PhraseSearchString varchar(8000)
		declare @loop int
		select @loop = 1
		while @loop <= @NumberOfPhrases
		begin
			select @PhraseSearchString = Forms
				from @PhraseList
				where PhraseID = @loop
			insert into #PhraseNodeMap (PhraseID, NodeID, MatchedByNodeID, Distance, Paths, MapWeight, TextWeight, Weight)
				select @loop, s.NodeID, s.MatchedByNodeID, s.Distance, s.Paths, s.Weight, m.Weight,
						(case when s.Weight*m.Weight > 0.999999 then 0.999999 else s.Weight*m.Weight end) Weight
					from [Search.Cache].[Private.NodeMap] s, (
						select [Key] NodeID, [Rank]*0.001 Weight
							from Containstable ([RDF.].Node, value, @PhraseSearchString) n
					) m
					where s.MatchedByNodeID = m.NodeID and s.NodeID = @NodeID
			select @loop = @loop + 1
		end
	end
	else
	begin
		insert into #PhraseNodeMap (PhraseID, NodeID, MatchedByNodeID, Distance, Paths, MapWeight, TextWeight, Weight)
			select 1, s.NodeID, s.MatchedByNodeID, s.Distance, s.Paths, s.Weight, m.Weight,
					(case when s.Weight*m.Weight > 0.999999 then 0.999999 else s.Weight*m.Weight end) Weight
				from [Search.Cache].[Private.NodeMap] s, (
					select [Key] NodeID, [Rank]*0.001 Weight
						from Containstable ([RDF.].Node, value, @CombinedSearchString) n
				) m
				where s.MatchedByNodeID = m.NodeID and s.NodeID = @NodeID
	end


	-------------------------------------------------------
	-- Get details on the matches
	-------------------------------------------------------
	

	;WITH m AS (
		SELECT 1 DirectMatch, NodeID, NodeID MiddleNodeID, MatchedByNodeID, 
				COUNT(DISTINCT PhraseID) Phrases, 1-exp(sum(log(1-Weight))) Weight
			FROM #PhraseNodeMap
			WHERE Distance = 1
			GROUP BY NodeID, MatchedByNodeID
		UNION ALL
		SELECT 0 DirectMatch, d.NodeID, y.NodeID MiddleNodeID, d.MatchedByNodeID,
				COUNT(DISTINCT d.PhraseID) Phrases, 1-exp(sum(log(1-d.Weight))) Weight
			FROM #PhraseNodeMap d
				INNER JOIN [Search.Cache].[Private.NodeMap] x
					ON x.NodeID = d.NodeID
						AND x.Distance = d.Distance - 1
				INNER JOIN [Search.Cache].[Private.NodeMap] y
					ON y.NodeID = x.MatchedByNodeID
						AND y.MatchedByNodeID = d.MatchedByNodeID
						AND y.Distance = 1
			WHERE d.Distance > 1
			GROUP BY d.NodeID, d.MatchedByNodeID, y.NodeID
	), w as (
		SELECT DISTINCT m.DirectMatch, m.NodeID, m.MiddleNodeID, m.MatchedByNodeID, m.Phrases, m.Weight,
			p._PropertyLabel PropertyLabel, p._PropertyNode PropertyNode
		FROM m
			INNER JOIN [Search.Cache].[Private.NodeClass] c
				ON c.NodeID = m.MiddleNodeID
			INNER JOIN [Ontology.].[ClassProperty] p
				ON p._ClassNode = c.Class
					AND p._NetworkPropertyNode IS NULL
					AND p.SearchWeight > 0
			INNER JOIN [RDF.].Triple t
				ON t.subject = m.MiddleNodeID
					AND t.predicate = p._PropertyNode
					AND t.object = m.MatchedByNodeID
	)
	SELECT w.DirectMatch, w.Phrases, w.Weight,
			n.NodeID, n.Value URI, c.ShortLabel Label, c.ClassName, 
			w.PropertyLabel Predicate, 
			w.MatchedByNodeID, o.value Value
		INTO #MatchDetails
		FROM w
			INNER JOIN [RDF.].Node n
				ON n.NodeID = w.MiddleNodeID
			INNER JOIN [Search.Cache].[Private.NodeSummary] c
				ON c.NodeID = w.MiddleNodeID
			INNER JOIN [RDF.].Node o
				ON o.NodeID = w.MatchedByNodeID

	UPDATE #MatchDetails
		SET Weight = (CASE WHEN Weight > 0.999999 THEN 999999 WHEN Weight < 0.000001 THEN 0.000001 ELSE Weight END)

	-------------------------------------------------------
	-- Build ConnectionDetailsXML
	-------------------------------------------------------

	DECLARE @ConnectionDetailsXML XML
	
	;WITH a AS (
		SELECT DirectMatch, NodeID, URI, Label, ClassName, 
				COUNT(*) NumberOfProperties, 1-exp(sum(log(1-Weight))) Weight,
				(
					SELECT	p.Predicate "Name",
							p.Phrases "NumberOfPhrases",
							p.Weight "Weight",
							p.Value "Value",
							(
								SELECT r.Phrase "MatchedPhrase"
								FROM #PhraseNodeMap q, @PhraseList r
								WHERE q.MatchedByNodeID = p.MatchedByNodeID
									AND r.PhraseID = q.PhraseID
								ORDER BY r.PhraseID
								FOR XML PATH(''), TYPE
							) "MatchedPhraseList"
						FROM #MatchDetails p
						WHERE p.DirectMatch = m.DirectMatch
							AND p.NodeID = m.NodeID
						ORDER BY p.Predicate
						FOR XML PATH('Property'), TYPE
				) PropertyList
			FROM #MatchDetails m
			GROUP BY DirectMatch, NodeID, URI, Label, ClassName
	)
	SELECT @ConnectionDetailsXML = (
		SELECT	(
					SELECT	NodeID "NodeID",
							URI "URI",
							Label "Label",
							ClassName "ClassName",
							NumberOfProperties "NumberOfProperties",
							Weight "Weight",
							PropertyList "PropertyList"
					FROM a
					WHERE DirectMatch = 1
					FOR XML PATH('Match'), TYPE
				) "DirectMatchList",
				(
					SELECT	NodeID "NodeID",
							URI "URI",
							Label "Label",
							ClassName "ClassName",
							NumberOfProperties "NumberOfProperties",
							Weight "Weight",
							PropertyList "PropertyList"
					FROM a
					WHERE DirectMatch = 0
					FOR XML PATH('Match'), TYPE
				) "IndirectMatchList"				
		FOR XML PATH(''), TYPE
	)
	
	--SELECT @ConnectionDetailsXML ConnectionDetails
	--SELECT * FROM #PhraseNodeMap


	-------------------------------------------------------
	-- Get RDF of the NodeID
	-------------------------------------------------------

	DECLARE @ObjectNodeRDF NVARCHAR(MAX)
	
	EXEC [RDF.].GetDataRDF	@subject = @NodeID,
							@showDetails = 0,
							@expand = 0,
							@SessionID = @SessionID,
							@returnXML = 0,
							@dataStr = @ObjectNodeRDF OUTPUT


	-------------------------------------------------------
	-- Form search results details RDF
	-------------------------------------------------------

	DECLARE @results NVARCHAR(MAX)

	SELECT @results = ''
			+'<rdf:Description rdf:nodeID="SearchResultsDetails">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Connection" />'
			+'<prns:connectionInNetwork rdf:NodeID="SearchResults" />'
			--+'<prns:connectionWeight>0.37744</prns:connectionWeight>'
			+'<prns:hasConnectionDetails rdf:NodeID="ConnectionDetails" />'
			+'<rdf:object rdf:resource="'+@NodeURI+'" />'
			+'<rdfs:label>Search Results Details</rdfs:label>'
			+'</rdf:Description>'
			+'<rdf:Description rdf:nodeID="SearchResults">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Network" />'
			+'<rdfs:label>Search Results</rdfs:label>'
			+'<vivo:overview rdf:parseType="Literal">'
			+CAST(@SearchOptions AS NVARCHAR(MAX))
			+IsNull('<SearchDetails>'+CAST(@SearchPhraseXML AS NVARCHAR(MAX))+'</SearchDetails>','')
			+'</vivo:overview>'
			+'<prns:hasConnection rdf:nodeID="SearchResultsDetails" />'
			+'</rdf:Description>'
			+IsNull(@ObjectNodeRDF,'')
			+'<rdf:Description rdf:NodeID="ConnectionDetails">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#ConnectionDetails" />'
			+'<vivo:overview rdf:parseType="Literal">'
			+CAST(@ConnectionDetailsXML AS NVARCHAR(MAX))
			+'</vivo:overview>'
			+'</rdf:Description> '

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + @results + '</rdf:RDF>'
	select cast(@x as xml) RDF


END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Concept.Mesh.UpdateWord2MeshAll]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER,@rows BIGINT 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
 
 
 
	select distinct nref.value('.','varchar(max)') word, m mesh_header 
		into #cwm
		from (
			select m, cast(replace(
				'<x><w>'+replace(v,' ','</w><w>')+'</w></x>',
				'<w></w>','') as xml) x
			from (select m, 
				replace(
				replace(
				replace(
				replace(
				replace(
				replace(m,
					nchar(11),' '),
					',',' '),
					'-',' '),
					'&','&amp;'),
					'<','&lt;'),
					'>','&gt;') v 
				from (
					select distinct DescriptorName m from [Profile.Data].[Concept.Mesh.Descriptor]
				) t
			) t
		) t
		cross apply x.nodes('//w') as R(nref)
 
	select distinct word, TermName mesh_term, DescriptorName as mesh_header, 0 num_words
		into #cwm3
		from [Profile.Data].[Concept.Mesh.Term]
			cross apply [Utility.NLP].fnNormalizeSplitStem(termname)
	create nonclustered index idx_ht on #cwm3(mesh_header, mesh_term)
	update c
		set c.num_words = t.n
		from #cwm3 c, (
			select mesh_header, mesh_term, count(*) n
			from #cwm3
			group by mesh_header, mesh_term
		) t
		where c.mesh_header = t.mesh_header and c.mesh_term = t.mesh_term
 
	select distinct word, mesh_header
		into #cwm2
		from #cwm3
 BEGIN TRY
	begin transaction
 
		delete FROM [Profile.Cache].[Concept.Mesh.Word2meshAll]
		insert into [Profile.Cache].[Concept.Mesh.Word2meshAll] (word, mesh_header)
			select word, mesh_header from #cwm
 
		delete from [Profile.Cache].[Concept.Mesh.Word2mesh2All]
		insert into [Profile.Cache].[Concept.Mesh.Word2mesh2All] (word, mesh_header)
			select word, mesh_header from #cwm2
 
		delete from [Profile.Cache].[Concept.Mesh.Word2Mesh3All]
		insert into [Profile.Cache].[Concept.Mesh.Word2Mesh3All] (word, mesh_term, mesh_header, num_words)
			select word, mesh_term, mesh_header, num_words from #cwm3
 
	commit transaction
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@error = 1,@insert_new_record=0
		-- Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
	SELECT @date=GETDATE()
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate =@date,@ProcessedRows = @rows,@insert_new_record=0
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.].[LookupNodes]
	@SearchOptions XML,
	@SessionID UNIQUEIDENTIFIER = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/********************************************************************
	
	This procedure provides secure, real-time search for editing and
	administrative functions. It gets called in the same way as the
	main GetNodes search procedure, but it has several differences:
	
	1) All nodes, including non-public nodes, are searched. The
		user's SessionID determines which non-public nodes are
		returned.
	2) No cache tables are used. Changes to Nodes and Triples are
		immediately available to this procedure. Though, there could
		be a delay caused by the time it takes fulltext search indexes
		to be updated.
	3) Only node labels (not the full content of a profile) are 
		searched. As a result, fewer nodes are matched by a search
		string.
	4) There are fewer search options. In particular, class group,
		search filters, and sort options are not supported.
	5) Data is returned as XML, not RDF.
	
	Below are examples:

	-- Return all people named "Smith"
	EXEC [Search.].[LookupNodes] @SearchOptions = '
		<SearchOptions>
			<MatchOptions>
				<SearchString>Smith</SearchString>
				<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
			</MatchOptions>
			<OutputOptions>
				<Offset>0</Offset>
				<Limit>5</Limit>
			</OutputOptions>	
		</SearchOptions>
		'

	-- Return publications about "lung cancer"
	EXEC [Search.].[LookupNodes] @SearchOptions = '
		<SearchOptions>
			<MatchOptions>
				<SearchString>lung cancer</SearchString>
				<ClassURI>http://purl.org/ontology/bibo/AcademicArticle</ClassURI>
			</MatchOptions>
			<OutputOptions>
				<Offset>5</Offset>
				<Limit>10</Limit>
			</OutputOptions>	
		</SearchOptions>
		'

	-- Return all departments
	EXEC [Search.].[LookupNodes] @SearchOptions = '
		<SearchOptions>
			<MatchOptions>
				<ClassURI>http://vivoweb.org/ontology/core#Department</ClassURI>
			</MatchOptions>
			<OutputOptions>
				<Offset>0</Offset>
				<Limit>25</Limit>
			</OutputOptions>	
		</SearchOptions>
		'

	********************************************************************/

	-- start timer
	declare @d datetime
	select @d = GetDate()

	-- declare variables
	declare @MatchOptions xml
	declare @OutputOptions xml
	declare @SearchString varchar(500)
	declare @ClassURI varchar(400)
	declare @offset bigint
	declare @limit bigint
	declare @baseURI nvarchar(400)
	declare @typeID bigint
	declare @labelID bigint
	declare @classID bigint
	declare @CombinedSearchString VARCHAR(8000)

	-- set constants
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
	select @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')

	-- parse input
	select	@MatchOptions = @SearchOptions.query('SearchOptions[1]/MatchOptions[1]'),
			@OutputOptions = @SearchOptions.query('SearchOptions[1]/OutputOptions[1]')
	select	@SearchString = @MatchOptions.value('MatchOptions[1]/SearchString[1]','varchar(500)'),
			@ClassURI = @MatchOptions.value('MatchOptions[1]/ClassURI[1]','varchar(400)'),
			@offset = @OutputOptions.value('OutputOptions[1]/Offset[1]','bigint'),
			@limit = @OutputOptions.value('OutputOptions[1]/Limit[1]','bigint')
	if @ClassURI is not null
		select @classID = [RDF.].fnURI2NodeID(@ClassURI)
	if @SearchString is not null
		EXEC [Search.].[ParseSearchString]	@SearchString = @SearchString,
											@CombinedSearchString = @CombinedSearchString OUTPUT

	-- get security information
	DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT
	EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
	CREATE TABLE #SecurityGroupNodes (SecurityGroupNode BIGINT PRIMARY KEY)
	INSERT INTO #SecurityGroupNodes (SecurityGroupNode) EXEC [RDF.Security].GetSessionSecurityGroupNodes @SessionID


	-- get a list of possible classes
	create table #c (ClassNode bigint primary key, TreeDepth int, ClassName varchar(400))
	insert into #c (ClassNode, TreeDepth, ClassName)
		select _ClassNode, _TreeDepth, _ClassName
		from [Ontology.].ClassTreeDepth
		where _ClassNode = IsNull(@classID,_ClassNode)

	
	-- CASE 1: A search string was provided
	IF IsNull(@CombinedSearchString,'') <> ''
	BEGIN
		;with a as (
			select NodeID, Label, ClassName, URI, ConnectionWeight,
					row_number() over (order by Label, NodeID) SortOrder
				from (
					select (case when len(m.Value)>500 then left(m.Value,497)+'...' else m.Value end) Label, 
						n.NodeID, n.value URI, c.ClassName ClassName, x.[Rank]*0.001 ConnectionWeight,
						row_number() over (partition by n.NodeID order by c.TreeDepth desc) k
					from Containstable ([RDF.].Node, value, @CombinedSearchString) x
						inner join [RDF.].Node m -- text node
							on x.[Key] = m.NodeID
								and ((m.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (m.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (m.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join [RDF.].Triple t -- match label
							on t.object = m.NodeID
								and t.predicate = @labelID
								and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join [RDF.].Node n -- match node
							on n.NodeID = t.subject
								and ((n.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (n.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (n.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join [RDF.].Triple v -- class
							on v.subject = n.NodeID
								and v.predicate = @typeID
								and ((v.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (v.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (v.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join #c c -- class name
							on c.ClassNode = v.object
				) t
				where k = 1
		)
		select (
				select	@SearchString "SearchString",
						@ClassURI "ClassURI",
						@offset "offset",
						@limit "limit",
						(select count(*) from a) "NumberOfConnections",
						(
							select	SortOrder "Connection/@SortOrder",
									NodeID "Connection/@NodeID",
									ClassName "Connection/@ClassName", 
									URI "Connection/@URI",
									ConnectionWeight "Connection/@ConnectionWeight",
									Label "Connection"
							from a
							where SortOrder >= (IsNull(@offset,0) + 1) AND SortOrder <= (IsNull(@offset,0) + IsNull(@limit,SortOrder))
							order by SortOrder
							for xml path(''), type
						) "Network"
					for xml path('SearchResults'), type
			) SearchResults
	END


	-- CASE 2: A Class, but no search string, was provided
	IF (IsNull(@CombinedSearchString,'') = '') AND (@classID IS NOT NULL)
	BEGIN
		;with a as (
			select NodeID, Label, ClassName, URI, 1 ConnectionWeight,
					row_number() over (order by Label, NodeID) SortOrder
				from (
					select (case when len(m.Value)>500 then left(m.Value,497)+'...' else m.Value end) Label, 
						n.NodeID, n.value URI, c.ClassName ClassName,
						row_number() over (partition by n.NodeID order by m.NodeID desc) k
					from #c c
						inner join [RDF.].Triple v -- class
							on v.object = c.ClassNode
								and v.predicate = @typeID
								and ((v.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (v.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (v.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join [RDF.].Node n -- match node
							on n.NodeID = v.subject
								and ((n.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (n.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (n.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join [RDF.].Triple t -- match label
							on t.subject = n.NodeID
								and t.predicate = @labelID
								and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join [RDF.].Node m -- text node
							on m.NodeID = t.object
								and ((m.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (m.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (m.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
				) t
				where k = 1
		)
		select (
				select	@SearchString "SearchString",
						@ClassURI "ClassURI",
						@offset "offset",
						@limit "limit",
						(select count(*) from a) "NumberOfConnections",
						(
							select	SortOrder "Connection/@SortOrder",
									NodeID "Connection/@NodeID",
									ClassName "Connection/@ClassName", 
									URI "Connection/@URI",
									ConnectionWeight "Connection/@ConnectionWeight",
									Label "Connection"
							from a
							where SortOrder >= (IsNull(@offset,0) + 1) AND SortOrder <= (IsNull(@offset,0) + IsNull(@limit,SortOrder))
							order by SortOrder
							for xml path(''), type
						) "Network"
					for xml path('SearchResults'), type
			) SearchResults	
	END


END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [Utility.NLP].[fnQuoteNormalizeSplitStem]
	(
		@InWord nvarchar(4000)
	)
RETURNS 
	@words table (
	phrase int,
		plen int,
		wpos int,
		word varchar(255),
		phrasestr varchar(2000)
	)
 AS
 BEGIN

    DECLARE @Temp nvarchar(4000)
	DECLARE @str nvarchar(4000)
	DECLARE @i int
	DECLARE @c varchar(1)
	DECLARE @q int
	DECLARE @phrases table (
		phrase int identity(0,1),
		phrasestr varchar(4000),
		quoted int
	)
	DECLARE @w table (
		phrase int,
		wpos int identity(0,1),
		word varchar(255),
		quoted int,
		phrasestr varchar(2000)
	)

    SELECT @Temp = ISNULL(RTRIM(LTRIM(@InWord)),N'')

	SET @str = ''
	SET @i = 1
	SET @q = 0

	WHILE @i <= LEN(@Temp)
	BEGIN
		SET @c = (select substring(@Temp,@i,1))
		IF (@c = '"')
		BEGIN
			INSERT INTO @phrases (phrasestr, quoted) VALUES (@str, @q)
			SET @q = 1 - @q
			SET @str = ''
		END
		ELSE
		BEGIN
			SET @str = @str + @c
		END
		SET @i = @i + 1
	END
	INSERT INTO @phrases (phrasestr, quoted) VALUES (@str, @q)

	DELETE FROM @phrases WHERE phrasestr = ''

 
 
	insert into @w (phrase, word, quoted,phrasestr)
		select phrase, word, quoted,CASE WHEN quoted=1 THEN ltrim(rtrim(phrasestr))ELSE word2 END
		from @phrases cross apply [Utility.NLP].fnNormalizeSplitStem(phrasestr)
		where word not in ('and');
 
	;with w as (
		select phrase, (row_number() over (partition by phrase order by wpos)) - 1 wpos, word, phrasestr
		from (
			select word, wpos, (dense_rank() over (order by k)) - 1 phrase,phrasestr
			from (
				select phrase + (case when quoted = 1 then 0 else wpos/10000.0 end) k, * from @w
			) t
		) t
	)
	insert into @words (phrase, plen, wpos, word,phrasestr)
		select w.phrase, v.plen, w.wpos, w.word ,phrasestr
		from w, (select phrase, count(*) plen from w group by phrase) v
		where w.phrase = v.phrase

    RETURN
 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.].[GetNodes]
	@SearchOptions XML,
	@SessionID UNIQUEIDENTIFIER = NULL,
	@Lookup BIT = 0,
	@UseCache VARCHAR(50) = 'Public'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*
	
	EXEC [Search.].[GetNodes] @SearchOptions = '
	<SearchOptions>
		<MatchOptions>
			<SearchString ExactMatch="false">options for "lung cancer" treatment</SearchString>
			<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
			<SearchFiltersList>
				<SearchFilter Property="http://xmlns.com/foaf/0.1/lastName" MatchType="Left">Smit</SearchFilter>
			</SearchFiltersList>
		</MatchOptions>
		<OutputOptions>
			<Offset>0</Offset>
			<Limit>5</Limit>
			<SortByList>
				<SortBy IsDesc="1" Property="http://xmlns.com/foaf/0.1/firstName" />
				<SortBy IsDesc="0" Property="http://xmlns.com/foaf/0.1/lastName" />
			</SortByList>
		</OutputOptions>	
	</SearchOptions>
	'
		
	*/
	
	-- Select either a lookup or a full search
	IF @Lookup = 1
	BEGIN
		-- Run a lookup
		EXEC [Search.].[LookupNodes] @SearchOptions = @SearchOptions, @SessionID = @SessionID
	END
	ELSE
	BEGIN
		-- Run a full search
		-- Determine the cache type if set to auto
		IF IsNull(@UseCache,'Auto') IN ('','Auto')
		BEGIN
			DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT
			EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
			SELECT @UseCache = (CASE WHEN @SecurityGroupID <= -30 THEN 'Private' ELSE 'Public' END)
		END
		-- Run the search based on the cache type
		IF @UseCache = 'Public'
			EXEC [Search.Cache].[Public.GetNodes] @SearchOptions = @SearchOptions, @SessionID = @SessionID
		ELSE IF @UseCache = 'Private'
			EXEC [Search.Cache].[Private.GetNodes] @SearchOptions = @SearchOptions, @SessionID = @SessionID
	END

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.].[GetConnection]
	@SearchOptions XML,
	@NodeID BIGINT = NULL,
	@NodeURI VARCHAR(400) = NULL,
	@SessionID UNIQUEIDENTIFIER = NULL,
	@UseCache VARCHAR(50) = 'Public'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Determine the cache type if set to auto
	IF IsNull(@UseCache,'Auto') IN ('','Auto')
	BEGIN
		DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT
		EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
		SELECT @UseCache = (CASE WHEN @SecurityGroupID <= -30 THEN 'Private' ELSE 'Public' END)
	END

	-- Get connection based on the cache type
	IF @UseCache = 'Public'
		EXEC [Search.Cache].[Public.GetConnection] @SearchOptions = @SearchOptions, @NodeID = @NodeID, @NodeURI = @NodeURI, @SessionID = @SessionID
	ELSE IF @UseCache = 'Private'
		EXEC [Search.Cache].[Private.GetConnection] @SearchOptions = @SearchOptions, @NodeID = @NodeID, @NodeURI = @NodeURI, @SessionID = @SessionID

END
GO
ALTER TABLE [Profile.Data].[Person.FilterRelationship]  WITH NOCHECK ADD  CONSTRAINT [FK_person_type_relationships_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Person.FilterRelationship] CHECK CONSTRAINT [FK_person_type_relationships_person]
GO
ALTER TABLE [Profile.Data].[Person.FilterRelationship]  WITH NOCHECK ADD  CONSTRAINT [FK_person_type_relationships_person_types] FOREIGN KEY([PersonFilterid])
REFERENCES [Profile.Data].[Person.Filter] ([PersonFilterID])
GO
ALTER TABLE [Profile.Data].[Person.FilterRelationship] CHECK CONSTRAINT [FK_person_type_relationships_person_types]
GO
ALTER TABLE [Profile.Data].[Person.Photo]  WITH CHECK ADD  CONSTRAINT [FK_photo_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Person.Photo] CHECK CONSTRAINT [FK_photo_person]
GO
ALTER TABLE [Profile.Data].[Publication.MyPub.General]  WITH NOCHECK ADD  CONSTRAINT [FK_my_pubs_general_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Publication.MyPub.General] CHECK CONSTRAINT [FK_my_pubs_general_person]
GO
ALTER TABLE [Profile.Data].[Publication.Person.Add]  WITH CHECK ADD  CONSTRAINT [FK_publications_add_my_pubs_general] FOREIGN KEY([MPID])
REFERENCES [Profile.Data].[Publication.MyPub.General] ([MPID])
GO
ALTER TABLE [Profile.Data].[Publication.Person.Add] CHECK CONSTRAINT [FK_publications_add_my_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.Person.Add]  WITH CHECK ADD  CONSTRAINT [FK_publications_add_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Publication.Person.Add] CHECK CONSTRAINT [FK_publications_add_person]
GO
ALTER TABLE [Profile.Data].[Publication.Person.Exclude]  WITH CHECK ADD  CONSTRAINT [FK_publications_exclude_my_pubs_general] FOREIGN KEY([MPID])
REFERENCES [Profile.Data].[Publication.MyPub.General] ([MPID])
GO
ALTER TABLE [Profile.Data].[Publication.Person.Exclude] CHECK CONSTRAINT [FK_publications_exclude_my_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.Person.Exclude]  WITH CHECK ADD  CONSTRAINT [FK_publications_exclude_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Publication.Person.Exclude] CHECK CONSTRAINT [FK_publications_exclude_person]
GO
ALTER TABLE [Profile.Data].[Publication.Person.Include]  WITH NOCHECK ADD  CONSTRAINT [FK_publications_include_my_pubs_general] FOREIGN KEY([MPID])
REFERENCES [Profile.Data].[Publication.MyPub.General] ([MPID])
GO
ALTER TABLE [Profile.Data].[Publication.Person.Include] CHECK CONSTRAINT [FK_publications_include_my_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.Person.Include]  WITH NOCHECK ADD  CONSTRAINT [FK_publications_include_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Publication.Person.Include] CHECK CONSTRAINT [FK_publications_include_person]
GO
ALTER TABLE [Profile.Data].[Publication.Person.Include]  WITH NOCHECK ADD  CONSTRAINT [FK_publications_include_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.Person.Include] CHECK CONSTRAINT [FK_publications_include_pm_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Accession]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_accessions_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Accession] CHECK CONSTRAINT [FK_pm_pubs_accessions_pm_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Author]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_authors_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Author] CHECK CONSTRAINT [FK_pm_pubs_authors_pm_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Author2Person]  WITH CHECK ADD  CONSTRAINT [FK_pm_authors2username_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Author2Person] CHECK CONSTRAINT [FK_pm_authors2username_person]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Author2Person]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_authors2username_pm_pubs_authors] FOREIGN KEY([PmPubsAuthorID])
REFERENCES [Profile.Data].[Publication.PubMed.Author] ([PmPubsAuthorID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Author2Person] CHECK CONSTRAINT [FK_pm_authors2username_pm_pubs_authors]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Chemical]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_chemicals_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Chemical] CHECK CONSTRAINT [FK_pm_pubs_chemicals_pm_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Databank]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_databanks_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Databank] CHECK CONSTRAINT [FK_pm_pubs_databanks_pm_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Grant]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_grants_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Grant] CHECK CONSTRAINT [FK_pm_pubs_grants_pm_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Investigator]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_investigators_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Investigator] CHECK CONSTRAINT [FK_pm_pubs_investigators_pm_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Keyword]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_keywords_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Keyword] CHECK CONSTRAINT [FK_pm_pubs_keywords_pm_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Mesh]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_mesh_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Mesh] CHECK CONSTRAINT [FK_pm_pubs_mesh_pm_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.PubType]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_pubtypes_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.PubType] CHECK CONSTRAINT [FK_pm_pubs_pubtypes_pm_pubs_general]
GO
ALTER TABLE [User.Session].[Session]  WITH CHECK ADD  CONSTRAINT [FK_Session_Person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [User.Session].[Session] CHECK CONSTRAINT [FK_Session_Person]
GO
ALTER TABLE [User.Session].[Session]  WITH CHECK ADD  CONSTRAINT [FK_Session_User] FOREIGN KEY([UserID])
REFERENCES [User.Account].[User] ([UserID])
GO
ALTER TABLE [User.Session].[Session] CHECK CONSTRAINT [FK_Session_User]
GO

GO
 
--lOAD n TABLE
 WITH   E00 ( N )
          AS ( SELECT   1
               UNION ALL
               SELECT   1
             ),
        E02 ( N )
          AS ( SELECT   1
               FROM     E00 a ,
                        E00 b
             ),
        E04 ( N )
          AS ( SELECT   1
               FROM     E02 a ,
                        E02 b
             ),
        E08 ( N )
          AS ( SELECT   1
               FROM     E04 a ,
                        E04 b
             ),
        E16 ( N )
          AS ( SELECT   1
               FROM     E08 a ,
                        E08 b
             ),
        E32 ( N )
          AS ( SELECT   1
               FROM     E16 a ,
                        E16 b
             ),
        cteTally ( N )
          AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY N )
               FROM     E32
             )
    
    INSERT INTO [Utility.Math].N
    SELECT  N -1
    FROM    cteTally
    WHERE   N <= 100000 ; 
    
 GO 