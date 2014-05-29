select 
REPLACE(CAST(customdisplaymodule as varchar(max)), 
'<Param Name="OptParams">{}</Param>',
'<Param Name="OptParams">{''hide_titlebar'':1}</Param>'),
    * from [Ontology.].[ClassProperty] where Property like '%orng%' and CustomDisplayModule is not null;


update [Ontology.].[ClassProperty] set customdisplaymodule =
REPLACE(CAST(customdisplaymodule as varchar(max)), 
'<Param Name="OptParams">{}</Param>',
'<Param Name="OptParams">{''hide_titlebar'':1}</Param>') where Property like '%orng%' and CustomDisplayModule is not null;


select * from [Ontology.Presentation].[XML] where CAST([PresentationXML] as varchar(max)) like '%NetworkMap%'