SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Import].[HMSWebservice.ImportData]
	@Job varchar(55),
	@Data xml
AS
BEGIN
	if @Job = 'Bibliometrics'
	begin
		exec [Profile.Data].[Publication.Pubmed.ParseBibliometricResults] @data=@data
	end
/*	if @Job = 'GetPubMedXML'
	begin
		exec [Profile.Data].[Publication.Pubmed.AddPubMedXMLBatch] @data=@data
	end
*/
END
GO
