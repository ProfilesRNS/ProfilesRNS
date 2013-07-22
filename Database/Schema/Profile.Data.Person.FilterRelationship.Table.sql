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
