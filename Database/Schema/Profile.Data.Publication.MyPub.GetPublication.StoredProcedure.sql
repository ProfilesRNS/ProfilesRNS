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
