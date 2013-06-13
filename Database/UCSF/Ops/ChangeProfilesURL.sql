
DECLARE              @return_value int

EXEC      @return_value = [Framework.].[ChangeBaseURI]
                                @oldBaseURI = N'http://stage-profiles.ucsf.edu/profile/',
                                @newBaseURI = N'http://stage-profiles.ucsf.edu/profiles102/profile/'

SELECT  'Return Value' = @return_value

GO
-- check first!!

update [Framework.].Parameter set Value = 'http://stage-profiles.ucsf.edu/profiles102' where ParameterID = 'basePath'
update [Framework.].Parameter set Value = 'http://stage-profiles.ucsf.edu/profiles102/profile/' where ParameterID = 'baseURI'