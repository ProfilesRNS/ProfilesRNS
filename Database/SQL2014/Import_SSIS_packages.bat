dtutil /FILE "ProfilesRNS_CallPRNSWebservice.dtsx" /DestServer . /COPY SQL;ProfilesRNS_CallPRNSWebservice
pause
dtutil /FILE "ExporterDisambiguation_GetFunding.dtsx" /DestServer . /COPY SQL;ExporterDisambiguation_GetFunding
pause
dtutil /FILE "PubMedDisambiguation_GetPubs.dtsx" /DestServer . /COPY SQL;PubMedDisambiguation_GetPubs
pause
dtutil /FILE "PubMedDisambiguation_GetPubMEDXML.dtsx" /DestServer . /COPY SQL;PubMedDisambiguation_GetPubMEDXML
pause