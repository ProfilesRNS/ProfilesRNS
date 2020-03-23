SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Import].[GoogleWebservice.ParseGeocodeResults]
	@BatchID varchar(100) = '',
	@RowID int = -1,
	@LogID int = -1,
	@URL varchar (500) = '',
	@Data varchar(max)
AS
BEGIN
	SET NOCOUNT ON;	
	declare @x xml, @status varchar(100), @errorText varchar(max), @lat varchar(20), @lng varchar(20), @location_type varchar(100)

	begin try
		set @x = cast(@data	as xml)
	end try
	begin catch
		set @status = 'XML Parsing Error'
		set @errorText = ERROR_MESSAGE()
	end catch

	if @x is not null
	BEGIN
		select @status = nref.value('status[1]','varchar(100)'),
		@errorText = nref.value('error_message[1]','varchar(max)'),
		@lat = nref.value('result[1]/geometry[1]/location[1]/lat[1]','varchar(20)'),
		@lng = nref.value('result[1]/geometry[1]/location[1]/lng[1]','varchar(20)'),
		@location_type = nref.value('result[1]/geometry[1]/location_type[1]','varchar(100)')
		from @x.nodes('//GeocodeResponse[1]') as R(nref)
	END

	IF @status = 'OK' 
	BEGIN
		UPDATE t SET t.Latitude = @lat, t.Longitude = @lng, t.GeoScore = case when @location_type = 'ROOFTOP' then 9 when @location_type = 'RANGE_INTERPOLATED' then 6 when @location_type = 'GEOMETRIC_CENTER' then 4 else 3 end
			FROM [Profile.Data].Person t
			JOIN [Profile.Import].[PRNSWebservice.Options] o ON o.job = 'geocode'
			AND @URL = o.url + REPLACE(REPLACE(t.AddressString, '#', '' ), ' ', '+') + '&sensor=false' + isnull('&key=' + apikey, '') 
			AND isnull(t.GeoScore, 0) < 10
		update [Profile.Import].[PRNSWebservice.Log] set ResultCount = @@ROWCOUNT where LogID = @LogID
	END
	ELSE 
	BEGIN
		if @LogID > 0
		begin
			select @LogID = isnull(@LogID, -1) from [Profile.Import].[PRNSWebservice.Log] where BatchID = @BatchID and RowID = @RowID
		end

		if @LogID > 0
			update [Profile.Import].[PRNSWebservice.Log] set Success = 0, HttpResponse = @Data, ErrorText = isnull(@status, '') + ' : ' + isnull(@errorText, '') where LogID = @LogID
		else
			insert into [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID, URL, HttpResponse, Success, ErrorText) Values ('Geocode', @BatchID, @RowID, @URL, @Data, 0, isnull(@status, '') + ' : ' + isnull(@errorText, ''))
	END
END
GO
