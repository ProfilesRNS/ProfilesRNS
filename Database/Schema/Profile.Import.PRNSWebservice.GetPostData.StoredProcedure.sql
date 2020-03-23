SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[PRNSWebservice.GetPostData]
	@Job varchar(55)
AS
BEGIN
	if @Job = 'Bibliometrics'
	begin
		exec [Profile.Data].[Publication.Pubmed.GetPMIDsforBibliometrics]
	end
	if @Job = 'Geocode'
	begin
		exec [Profile.Import].[GoogleWebservice.GetGeocodeAPIData] 
	end
END
GO
