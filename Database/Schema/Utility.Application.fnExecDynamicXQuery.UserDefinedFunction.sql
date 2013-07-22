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
