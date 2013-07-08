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
