SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Job.GetPostData]
	@Job varchar(55),
	@BatchSize int = 0
AS
BEGIN
	if @Job = 'Bibliometrics'
	begin
		select @BatchSize = case when @BatchSize = 0 then 10000 else @BatchSize end
		exec [Profile.Data].[Publication.Pubmed.GetPMIDsforBibliometrics] @BatchSize=@BatchSize
	end
END
