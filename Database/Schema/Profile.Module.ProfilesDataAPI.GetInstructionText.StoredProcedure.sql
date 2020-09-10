SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Module].[ProfilesDataAPI.GetInstructionText] 
AS
BEGIN
	SELECT '<html><body><h1>Profiles Data API</h1>To use the Profiles Data API call: /getPeople/{format}/{param name}/{param value}/{param name}/{param value}<br/><br/>
            <b>Supported Formats:</b> xml<br/><br/>
            <b>Parameters:</b>
            <ul><li><b>PersonIDs:</b> comma seperated list of personIDs</li></ul>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OR
            <ul><li><b>Institution:</b> limit results to users from this institution (default all users)</li>
            <li><b>Department:</b> limit results to users from this department (default all users)</li>
            <li><b>Division:</b> limit results to users from this division (default all users)</li>
            <li><b>FacultyRank:</b> limit results to users with this faculty rank (default all users)</li>
            <li><b>Keyword:</b> limit results to users with connected to this search term, ordered by connection strength (default all users)</li></ul>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PLUS
            <ul><li><b>Count:</b> maximum number of people to return (default all users)</li>
            <li><b>Offset:</b> offset to allow for pagination of results (default 0)</li>
            <li><b>Columns:</b> comma separated list of data to return, currently supported columns are address, affiliation, overview, publications, concepts</li>
            <li><b>Years:</b> only return publications from these years. Acceptable formats are comma separated (2017,2018,2019) or a range (2017-2019). (default all years)</li></ul></body></html>'
END
GO
