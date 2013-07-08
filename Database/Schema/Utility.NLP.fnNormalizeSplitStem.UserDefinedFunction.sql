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
