@echo off
REM
REM
REM  Copyright (c) 2008-2013 by the President and Fellows of Harvard College. All rights reserved.  Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD., and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the National Center for Research Resources and Harvard University.
REM
REM  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
REM      * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
REM      * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
REM      * Neither the name "Harvard" nor the names of its contributors nor the name "Harvard Catalyst" may be used to endorse or promote products derived from this software without specific prior written permission.
REM  
REM  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER (PRESIDENT AND FELLOWS OF HARVARD COLLEGE) AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
REM  
REM  

REM This script is designed for SQL 2008+
REM

echo . Creating new ProfilesRNS database
sqlcmd -S . -d master -E -i ProfilesRNS_CreateDatabase.sql

echo . Creating ProfilesRNS Schema
sqlcmd -S . -d ProfilesRNS -E -i ProfilesRNS_CreateSchema.sql

echo . Creating ProfilesRNS Accounts
sqlcmd -S . -d ProfilesRNS -E -i ProfilesRNS_CreateAccount.sql 

echo . Importing Ontology Data
sqlcmd -S . -d ProfilesRNS -E -v ProfilesRNSRootPath="%~dp0" -i ProfilesRNS_DataLoad_Part1.sql


REM echo . Dropping various ProfilesRNS jobs
sqlcmd -S . -d ProfilesRNS -E -Q "exec msdb.dbo.sp_delete_job @job_name ='ProfilesRNSGeoCode'"
sqlcmd -S . -d ProfilesRNS -E -Q "exec msdb.dbo.sp_delete_job @job_name ='PubMedDisambiguation_GetPubs'"
sqlcmd -S . -d ProfilesRNS -E -Q "exec msdb.dbo.sp_delete_job @job_name ='PubMedDisambiguation_GetPubMEDXML'"

REM echo . Dropping various SSIS packages
dtutil /SQL ProfilesGeoCode /DELETE
dtutil /SQL PubMedDisambiguation_GetPubMEDXML /DELETE
dtutil /SQL PubMedDisambiguation_GetPubs /DELETE


echo . Installing PubMedDisambiguation_GetPubs SSIS package
dtutil /FILE "%~dp0\SQL2008\PubMedDisambiguation_GetPubs.dtsx" /DestServer . /COPY SQL;PubMedDisambiguation_GetPubs

echo . Installing PubMedDisambiguation_GetPubMEDXML SSIS package
dtutil /FILE "%~dp0\SQL2008\PubMedDisambiguation_GetPubMEDXML.dtsx" /DestServer . /COPY SQL;PubMedDisambiguation_GetPubMEDXML

echo . Installing ProfilesGeoCode SSIS package
dtutil /FILE "%~dp0\SQL2008\ProfilesGeoCode.dtsx" /DestServer . /COPY SQL;ProfilesGeoCode

echo . Creating ProfilesRNSGeoCode job
sqlcmd -S . -d ProfilesRNS -E -v YourProfilesServerName="." YourProfilesDatabaseName="ProfilesRNS" -i "%~dp0\ProfilesRNS_GeoCodeJob.sql"
 
echo . Creating PubMedDisambiguation_GetPubs job
sqlcmd -S . -d ProfilesRNS -E -v YourProfilesServerName="." YourProfilesDatabaseName="ProfilesRNS" -i "%~dp0\SQL2008\PubMedDisambiguation_GetPubs.sql"

echo . Creating PubMedDisambiguation_GetPubMEDXML job
sqlcmd -S . -d ProfilesRNS -E -v YourProfilesServerName="." YourProfilesDatabaseName="ProfilesRNS" -i "%~dp0\SQL2008\PubMedDisambiguation_GetPubMEDXML.sql"


