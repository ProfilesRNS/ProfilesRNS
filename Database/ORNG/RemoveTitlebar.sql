
select REPLACE(CAST(CustomDisplayModule as varchar(max)), '<Param Name="OptParams">{}</Param>',
'<Param Name="OptParams">{''hide_titlebar'':1}</Param>'), * from [Ontology.].[ClassProperty] where Property like '%orng%'
  and CAST(CustomDisplayModule as varchar(max)) like '%{}%'
  and CAST(CustomEditModule as varchar(max)) like '%{}%';


update   [Ontology.].[ClassProperty] set 
CustomDisplayModule = REPLACE(CAST(CustomDisplayModule as varchar(max)), '<Param Name="OptParams">{}</Param>',
'<Param Name="OptParams">{''hide_titlebar'':1}</Param>'), 
CustomEditModule = REPLACE(CAST(CustomEditModule as varchar(max)), '<Param Name="OptParams">{}</Param>',
'<Param Name="OptParams">{''hide_titlebar'':1}</Param>')
where Property like '%orng%'
  and CAST(CustomDisplayModule as varchar(max)) like '%{}%'
  and CAST(CustomEditModule as varchar(max)) like '%{}%';

select * from [Ontology.].[ClassProperty] where Property like '%orng%'
  and CAST(CustomDisplayModule as varchar(max)) like '%hide_titlebar%'
  and CAST(CustomEditModule as varchar(max)) like '%hide_titlebar%';