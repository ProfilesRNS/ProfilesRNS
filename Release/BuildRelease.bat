@echo off
SETLOCAL EnableDelayedExpansion

REM
REM
REM  Copyright (c) 2008-2014 by the President and Fellows of Harvard College. All rights reserved.  Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD., and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the National Center for Research Resources and Harvard University.
REM
REM  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
REM      * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
REM      * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
REM      * Neither the name "Harvard" nor the names of its contributors nor the name "Harvard Catalyst" may be used to endorse or promote products derived from this software without specific prior written permission.
REM  
REM  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER (PRESIDENT AND FELLOWS OF HARVARD COLLEGE) AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
REM  
REM  

set Version=%1
set pdfCreatorPath=C:\ProgramData\PDFCreator
set RootPath=%~dp0
set RootPath=%RootPath:\Release\=\%
set zip="C:\Program Files\7-Zip\7z.exe"




mkdir ProfilesRNS
mkdir ProfilesRNS\Database
mkdir ProfilesRNS\Documentation
mkdir ProfilesRNS\Website
mkdir ProfilesRNS\Website\Binary
mkdir ProfilesRNS\Website\Binary\Profiles
mkdir ProfilesRNS\Website\Binary\ProfilesBetaAPI
mkdir ProfilesRNS\Website\Binary\ProfilesSearchAPI
mkdir ProfilesRNS\Website\Binary\ProfilesSPARQLAPI
mkdir ProfilesRNS\Website\SourceCode\Profiles
mkdir ProfilesRNS\Website\SourceCode\Profiles\Profiles
mkdir ProfilesRNS\Website\SourceCode\ProfilesBetaAPI
mkdir ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service
mkdir ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service\bin
mkdir ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.DataContracts
mkdir ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.ServiceContracts
mkdir ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.ServiceImplementation
mkdir ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Utility
mkdir ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Profiles.Common
mkdir ProfilesRNS\Website\SourceCode\ProfilesSearchAPI
mkdir ProfilesRNS\Website\SourceCode\ProfilesSPARQLAPI
mkdir ProfilesRNS\Website\SourceCode\SemWeb
mkdir ProfilesRNS\Website\SourceCode\SemWeb\src

REM 
REM 
REM Office interop won't work headlessly, so we just copy the word files when running from jenkins
REM 
REM 
call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" ConvertToPDF\ConvertToPDF.csproj "/p:Platform=AnyCPU;Configuration=Release"
call ConvertToPDF\bin\Release\ConvertToPDF.exe
if !errorlevel! equ 1 (
	Echo An error occured while building the release.
	exit /b 1
)
if !errorlevel! equ 2 (
	copy ..\Documentation\ProfilesRNS_DataFlowDiagram.pptx ProfilesRNS\Documentation\ProfilesRNS_DataFlowDiagram_%Version%.pptx
	copy ..\Documentation\ProfilesRNS_OntologyDiagram.pptx ProfilesRNS\Documentation\ProfilesRNS_OntologyDiagram_%Version%.pptx
	copy ..\Documentation\ProfilesRNS_APIGuide.doc ProfilesRNS\Documentation\ProfilesRNS_APIGuide_%Version%.doc
	copy ..\Documentation\ProfilesRNS_ArchitectureGuide.docx ProfilesRNS\Documentation\ProfilesRNS_ArchitectureGuide_%Version%.docx
	copy ..\Documentation\ProfilesRNS_InstallGuide.docx ProfilesRNS\Documentation\ProfilesRNS_InstallGuide_%Version%.docx
	copy ..\ProfilesRNS_ReadMeFirst.docx ProfilesRNS\ProfilesRNS_ReadMeFirst.docx
	copy ..\Documentation\ProfilesRNS_ReleaseNotes.docx ProfilesRNS\Documentation\ProfilesRNS_ReleaseNotes_%Version%.docx
	copy ..\Documentation\ProfilesRNS_v2.x.x_UpgradeGuide.docx ProfilesRNS\Documentation\ProfilesRNS_v2.x.x_UpgradeGuide.docx
)


echo d | xcopy /s ..\Documentation\API_Examples ProfilesRNS\Documentation\API_Examples
echo d | xcopy /s ..\Documentation\SQL_Examples ProfilesRNS\Documentation\SQL_Examples
copy ..\LICENSE.txt ProfilesRNS\LICENSE.txt


rem call C:\Windows\Microsoft.NET\Framework64\v3.5\MSBuild.exe ProfilesRNS_AutomatedBuildConfiguration.xml /target:publish
rem call C:\Windows\Microsoft.NET\Framework64\v3.5\MSBuild.exe ProfilesRNSSearchAPI_AutomatedBuildConfiguration.xml /target:publish
rem call C:\Windows\Microsoft.NET\Framework64\v3.5\MSBuild.exe ProfilesRNSSPARQLAPI_AutomatedBuildConfiguration.xml /target:publish
rem call C:\Windows\Microsoft.NET\Framework64\v3.5\MSBuild.exe ProfilesRNSBetaAPI_AutomatedBuildConfiguration.xml /target:publish

call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\Profiles\Profiles\Profiles.csproj" "/p:Platform=AnyCPU;Configuration=Release;PublishDestination=..\..\..\..\Release\ProfilesRNS\Website\Binary\Profiles" /t:PublishToFileSystem /p:VisualStudioVersion=14.0
call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service\Connects.Profiles.Service.csproj" "/p:Platform=AnyCPU;Configuration=Release;PublishDestination=..\..\..\..\Release\ProfilesRNS\Website\Binary\ProfilesBetaAPI" /t:PublishToFileSystem /p:VisualStudioVersion=14.0
call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\ProfilesSearchAPI\ProfilesSearchAPI.csproj" "/p:Platform=AnyCPU;Configuration=Release;PublishDestination=..\..\..\Release\ProfilesRNS\Website\Binary\ProfilesSearchAPI" /t:PublishToFileSystem /p:VisualStudioVersion=14.0
copy ..\Website\SourceCode\SemWeb\src\bin\sparql-core.dll ..\Website\SourceCode\ProfilesSPARQLAPI\bin\
call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\ProfilesSPARQLAPI\ProfilesSPARQLAPI.csproj" "/p:Platform=AnyCPU;Configuration=Release;PublishDestination=..\..\..\Release\ProfilesRNS\Website\Binary\ProfilesSPARQLAPI" /t:PublishToFileSystem /p:VisualStudioVersion=14.0

copy ..\Website\SourceCode\Profiles\Profiles\web.config ProfilesRNS\Website\Binary\Profiles\web.config
copy ..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service\web.config ProfilesRNS\Website\Binary\ProfilesBetaAPI\web.config
copy ..\Website\SourceCode\ProfilesSearchAPI\web.config ProfilesRNS\Website\Binary\ProfilesSearchAPI\web.config
copy ..\Website\SourceCode\ProfilesSPARQLAPI\web.config ProfilesRNS\Website\Binary\ProfilesSPARQLAPI\web.config

echo d | xcopy /s ..\Database\Data ProfilesRNS\Database\Data
pushd ProfilesRNS\Database\Data
del MeSH.xml
call %zip% e MeSH.xml.zip -y
del MeSH.xml.zip
popd

del "ProfilesRNS\Database\Data\InstallData.xml"
pushd "ProfilesRNS\Database\Data\InstallData"
call CreateInstallDataScript.bat > ..\InstallData.xml
popd

@RD /S /Q "ProfilesRNS\Database\Data\InstallData"

echo d | xcopy /s ..\Database\SQL2012 ProfilesRNS\Database\SQL2012
echo d | xcopy /s ..\Database\SQL2014 ProfilesRNS\Database\SQL2014
echo d | xcopy /s ..\Database\SQL2016 ProfilesRNS\Database\SQL2016
echo d | xcopy /s ..\Database\SQL2017 ProfilesRNS\Database\SQL2017
echo d | xcopy /s ..\Database\VersionUpgrade_2.0.0_2.5.1 ProfilesRNS\Database\VersionUpgrade_2.0.0_2.5.1
echo d | xcopy /s ..\Database\VersionUpgrade_2.5.1_2.6.0 ProfilesRNS\Database\VersionUpgrade_2.5.1_2.6.0
echo d | xcopy /s ..\Database\VersionUpgrade_2.6.0_2.7.0 ProfilesRNS\Database\VersionUpgrade_2.6.0_2.7.0
echo d | xcopy /s ..\Database\VersionUpgrade_2.7.0_2.8.0 ProfilesRNS\Database\VersionUpgrade_2.7.0_2.8.0
echo d | xcopy /s ..\Database\VersionUpgrade_2.8.0_2.9.0 ProfilesRNS\Database\VersionUpgrade_2.8.0_2.9.0
echo d | xcopy /s ..\Database\VersionUpgrade_2.9.0_2.10.0 ProfilesRNS\Database\VersionUpgrade_2.9.0_2.10.0
echo d | xcopy /s ..\Database\VersionUpgrade_2.10.0_2.10.1 ProfilesRNS\Database\VersionUpgrade_2.10.0_2.10.1
echo d | xcopy /s ..\Database\VersionUpgrade_2.10.1_2.11.0 ProfilesRNS\Database\VersionUpgrade_2.10.1_2.11.0
echo d | xcopy /s ..\Database\VersionUpgrade_2.11.0_2.11.1 ProfilesRNS\Database\VersionUpgrade_2.11.0_2.11.1
echo d | xcopy /s ..\Database\VersionUpgrade_2.11.1_2.12.0 ProfilesRNS\Database\VersionUpgrade_2.11.1_2.12.0
echo d | xcopy /s ..\Database\VersionUpgrade_2.12.0_3.0.0 ProfilesRNS\Database\VersionUpgrade_2.12.0_3.0.0
echo d | xcopy /s ..\Database\VersionUpgrade_3.0.0_3.1.0 ProfilesRNS\Database\VersionUpgrade_3.0.0_3.1.0
copy ..\Database\ProfilesRNS_CreateAccount.sql ProfilesRNS\Database\ProfilesRNS_CreateAccount.sql
copy ..\Database\ProfilesRNS_CreateDatabase.sql ProfilesRNS\Database\ProfilesRNS_CreateDatabase.sql
copy ..\Database\ProfilesRNS_DataLoad_Part1.sql ProfilesRNS\Database\ProfilesRNS_DataLoad_Part1.sql
copy ..\Database\ProfilesRNS_DataLoad_Part3.sql ProfilesRNS\Database\ProfilesRNS_DataLoad_Part3.sql
copy ..\Database\ProfilesRNS_GeoCodeJob.sql ProfilesRNS\Database\ProfilesRNS_GeoCodeJob.sql
copy ..\Database\ExporterDisambiguation_GetFunding.sql ProfilesRNS\Database\ExporterDisambiguation_GetFunding.sql
copy ..\Database\ProfilesRNS_BibliometricsJob.sql ProfilesRNS\Database\ProfilesRNS_BibliometricsJob.sql
copy ..\Database\PubMedDisambiguation_GetPubs.sql ProfilesRNS\Database\PubMedDisambiguation_GetPubs.sql
copy ..\Database\PubMedDisambiguation_GetPubMEDXML.sql ProfilesRNS\Database\PubMedDisambiguation_GetPubMEDXML.sql

del "%RootPath%\Database\ProfilesRNS_CreateSchema.sql"
pushd "%RootPath%\Database\schema"
call CreateSchemaInstallScript.bat > ..\ProfilesRNS_CreateSchema.sql
popd

copy ..\Database\ProfilesRNS_CreateSchema.sql ProfilesRNS\Database\ProfilesRNS_CreateSchema.sql

call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\Profiles\Profiles\Profiles.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\Profiles\Profiles" /t:CopySource  /p:VisualStudioVersion=14.0

call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service\Connects.Profiles.Service.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service" /t:CopySource /p:VisualStudioVersion=14.0
copy "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service\bin\microsoft.ServiceModel.Web.dll" "ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service\bin\microsoft.ServiceModel.Web.dll"
call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.DataContracts\Connects.Profiles.Service.DataContracts.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.DataContracts" /t:CopySource /p:VisualStudioVersion=14.0
call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.ServiceContracts\Connects.Profiles.Service.ServiceContracts.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.ServiceContracts" /t:CopySource /p:VisualStudioVersion=14.0
call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.ServiceImplementation\Connects.Profiles.Service.ServiceImplementation.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.ServiceImplementation" /t:CopySource /p:VisualStudioVersion=14.0
call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Utility\Connects.Profiles.Utility.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Utility" /t:CopySource /p:VisualStudioVersion=14.0
call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\ProfilesBetaAPI\Profiles.Common\Connects.Profiles.Common.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Profiles.Common" /t:CopySource /p:VisualStudioVersion=14.0

call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\ProfilesSearchAPI\ProfilesSearchAPI.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesSearchAPI" /t:CopySource /p:VisualStudioVersion=14.0
call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\ProfilesSPARQLAPI\ProfilesSPARQLAPI.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesSPARQLAPI" /t:CopySource /p:VisualStudioVersion=14.0

call "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild" "..\Website\SourceCode\SemWeb\src\SemWeb.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\SemWeb\src" /t:CopySource /p:VisualStudioVersion=14.0

copy ..\Website\SourceCode\Profiles\Profiles.sln ProfilesRNS\Website\SourceCode\Profiles\Profiles.sln
call %zip% a -tzip ProfilesRNS-%Version%.zip ProfilesRNS