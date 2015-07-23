@echo off

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
set OFFICE_PATH=c:\Program Files\Microsoft Office\Office15
set pdfCreatorPath=C:\ProgramData\PDFCreator
set RootPath=%~dp0
set RootPath=%RootPath:\Release\=\%
set zip="C:\Program Files\7-Zip\7z.exe"




mkdir ProfilesRNS
mkdir ProfilesRNS\Database
mkdir ProfilesRNS\Documentation
mkdir ProfilesRNS\Documentation\ORNG
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
REM This assumes that you have PDFCreator set up as your default printer
REM It should be configured to save all files in the c:\ProgramData\PDFCreator folder without asking for input
REM This will waste a lot of paper if a physical printer is configured as the default
REM 
REM 

call "%OFFICE_PATH%\WINWORD.EXE" ..\ProfilesRNS_ReadMeFirst.docx /q /n /mFilePrintDefault /mFileCloseOrExit
call "%OFFICE_PATH%\WINWORD.EXE" ..\Documentation\ProfilesRNS_APIGuide.doc /q /n /mFilePrintDefault /mFileCloseOrExit
call "%OFFICE_PATH%\WINWORD.EXE" ..\Documentation\ProfilesRNS_ArchitectureGuide.docx /q /n /mFilePrintDefault /mFileCloseOrExit
call "%OFFICE_PATH%\WINWORD.EXE" ..\Documentation\ProfilesRNS_InstallGuide.docx /q /n /mFilePrintDefault /mFileCloseOrExit
call "%OFFICE_PATH%\WINWORD.EXE" ..\Documentation\ProfilesRNS_ReleaseNotes.docx /q /n /mFilePrintDefault /mFileCloseOrExit

call "%OFFICE_PATH%\POWERPNT.EXE" /p ..\Documentation\ProfilesRNS_DataFlowDiagram.pptx
call "%OFFICE_PATH%\POWERPNT.EXE" /p ..\Documentation\ProfilesRNS_OntologyDiagram.pptx

call "%OFFICE_PATH%\WINWORD.EXE" ..\Documentation\ORNG\ORNG_GadgetDevelopment.docx /q /n /mFilePrintDefault /mFileCloseOrExit
call "%OFFICE_PATH%\WINWORD.EXE" ..\Documentation\ORNG\ORNG_InstallationGuide.docx /q /n /mFilePrintDefault /mFileCloseOrExit
call "%OFFICE_PATH%\WINWORD.EXE" ..\Documentation\ORNG\ORNG_TroubleShootingGuide.docx /q /n /mFilePrintDefault /mFileCloseOrExit
call "%OFFICE_PATH%\POWERPNT.EXE" /p ..\Documentation\ORNG\ORNGArchitecturalDiagram.pptx
timeout 10

if exist "%pdfCreatorPath%\ProfilesRNS_InstallGuide.pdf" (
	move "%pdfCreatorPath%\ORNGArchitecturalDiagram.pdf" ProfilesRNS\Documentation\ORNG\ORNGArchitecturalDiagram_%Version%.pdf
	move "%pdfCreatorPath%\ProfilesRNS_DataFlowDiagram.pdf" ProfilesRNS\Documentation\ProfilesRNS_DataFlowDiagram_%Version%.pdf
	move "%pdfCreatorPath%\ProfilesRNS_OntologyDiagram.pdf" ProfilesRNS\Documentation\ProfilesRNS_OntologyDiagram_%Version%.pdf
	move "%pdfCreatorPath%\ORNG_GadgetDevelopment.pdf" ProfilesRNS\Documentation\ORNG\ORNG_GadgetDevelopment_%Version%.pdf
	move "%pdfCreatorPath%\ORNG_InstallationGuide.pdf" ProfilesRNS\Documentation\ORNG\ORNG_InstallationGuide_%Version%.pdf
	move "%pdfCreatorPath%\ORNG_TroubleShootingGuide.pdf" ProfilesRNS\Documentation\ORNG\ORNG_TroubleShootingGuide_%Version%.pdf
	move "%pdfCreatorPath%\ProfilesRNS_APIGuide.pdf" ProfilesRNS\Documentation\ProfilesRNS_APIGuide_%Version%.pdf
	move "%pdfCreatorPath%\ProfilesRNS_ArchitectureGuide.pdf" ProfilesRNS\Documentation\ProfilesRNS_ArchitectureGuide_%Version%.pdf
	move "%pdfCreatorPath%\ProfilesRNS_InstallGuide.pdf" ProfilesRNS\Documentation\ProfilesRNS_InstallGuide_%Version%.pdf
	move "%pdfCreatorPath%\ProfilesRNS_ReadMeFirst.pdf" ProfilesRNS\ProfilesRNS_ReadMeFirst.pdf
	move "%pdfCreatorPath%\ProfilesRNS_ReleaseNotes.pdf" ProfilesRNS\Documentation\ProfilesRNS_ReleaseNotes_%Version%.pdf
) else (
	copy ..\Documentation\ORNG\ORNGArchitecturalDiagram.pptx ProfilesRNS\Documentation\ORNG\ORNGArchitecturalDiagram_%Version%.pptx
	copy ..\Documentation\ProfilesRNS_DataFlowDiagram.pptx ProfilesRNS\Documentation\ProfilesRNS_DataFlowDiagram_%Version%.pptx
	copy ..\Documentation\ProfilesRNS_OntologyDiagram.pptx ProfilesRNS\Documentation\ProfilesRNS_OntologyDiagram_%Version%.pptx
	copy ..\Documentation\ORNG\ORNG_GadgetDevelopment.docx ProfilesRNS\Documentation\ORNG\ORNG_GadgetDevelopment_%Version%.docx
	copy ..\Documentation\ORNG\ORNG_InstallationGuide.docx ProfilesRNS\Documentation\ORNG\ORNG_InstallationGuide_%Version%.docx
	copy ..\Documentation\ORNG\ORNG_TroubleShootingGuide.docx ProfilesRNS\Documentation\ORNG\ORNG_TroubleShootingGuide_%Version%.docx
	copy ..\Documentation\ProfilesRNS_APIGuide.doc ProfilesRNS\Documentation\ProfilesRNS_APIGuide_%Version%.doc
	copy ..\Documentation\ProfilesRNS_ArchitectureGuide.docx ProfilesRNS\Documentation\ProfilesRNS_ArchitectureGuide_%Version%.docx
	copy ..\Documentation\ProfilesRNS_InstallGuide.docx ProfilesRNS\Documentation\ProfilesRNS_InstallGuide_%Version%.docx
	copy ..\ProfilesRNS_ReadMeFirst.docx ProfilesRNS\ProfilesRNS_ReadMeFirst.docx
	copy ..\Documentation\ProfilesRNS_ReleaseNotes.docx ProfilesRNS\Documentation\ProfilesRNS_ReleaseNotes_%Version%.docx
)

echo d | xcopy /s ..\Documentation\API_Examples ProfilesRNS\Documentation\API_Examples
echo d | xcopy /s ..\Documentation\SQL_Examples ProfilesRNS\Documentation\SQL_Examples
copy ..\Documentation\ORNG\screenshot-apache.JPG ProfilesRNS\Documentation\ORNG\screenshot-apache.JPG
copy ..\Documentation\ORNG\screenshot-isapi.JPG ProfilesRNS\Documentation\ORNG\screenshot-isapi.JPG
copy ..\Documentation\ORNG\uriworkermap.properties ProfilesRNS\Documentation\ORNG\uriworkermap.properties
copy ..\Documentation\ORNG\workers.properties ProfilesRNS\Documentation\ORNG\workers.properties
copy ..\LICENSE.txt ProfilesRNS\LICENSE.txt


rem call C:\Windows\Microsoft.NET\Framework64\v3.5\MSBuild.exe ProfilesRNS_AutomatedBuildConfiguration.xml /target:publish
rem call C:\Windows\Microsoft.NET\Framework64\v3.5\MSBuild.exe ProfilesRNSSearchAPI_AutomatedBuildConfiguration.xml /target:publish
rem call C:\Windows\Microsoft.NET\Framework64\v3.5\MSBuild.exe ProfilesRNSSPARQLAPI_AutomatedBuildConfiguration.xml /target:publish
rem call C:\Windows\Microsoft.NET\Framework64\v3.5\MSBuild.exe ProfilesRNSBetaAPI_AutomatedBuildConfiguration.xml /target:publish

call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\Profiles\Profiles\Profiles.csproj" "/p:Platform=AnyCPU;Configuration=Release;PublishDestination=..\..\..\..\Release\ProfilesRNS\Website\Binary\Profiles" /t:PublishToFileSystem
call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service\Connects.Profiles.Service.csproj" "/p:Platform=AnyCPU;Configuration=Release;PublishDestination=..\..\..\..\Release\ProfilesRNS\Website\Binary\ProfilesBetaAPI" /t:PublishToFileSystem
call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\ProfilesSearchAPI\ProfilesSearchAPI.csproj" "/p:Platform=AnyCPU;Configuration=Release;PublishDestination=..\..\..\Release\ProfilesRNS\Website\Binary\ProfilesSearchAPI" /t:PublishToFileSystem
copy ..\Website\SourceCode\SemWeb\src\bin\sparql-core.dll ..\Website\SourceCode\ProfilesSPARQLAPI\bin\
call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\ProfilesSPARQLAPI\ProfilesSPARQLAPI.csproj" "/p:Platform=AnyCPU;Configuration=Release;PublishDestination=..\..\..\Release\ProfilesRNS\Website\Binary\ProfilesSPARQLAPI" /t:PublishToFileSystem



echo d | xcopy /s ..\Database\Data ProfilesRNS\Database\Data
pushd ProfilesRNS\Database\Data
call zip e MeSH.xml.zip -y
del MeSH.xml.zip
popd
echo d | xcopy /s ..\Database\SQL2008 ProfilesRNS\Database\SQL2008
echo d | xcopy /s ..\Database\SQL2012 ProfilesRNS\Database\SQL2012
echo d | xcopy /s ..\Database\SQL2014 ProfilesRNS\Database\SQL2014
echo d | xcopy /s ..\Database\VersionUpgrade ProfilesRNS\Database\VersionUpgrade
copy ..\Database\ProfilesRNS_CreateAccount.sql ProfilesRNS\Database\ProfilesRNS_CreateAccount.sql
copy ..\Database\ProfilesRNS_CreateDatabase.sql ProfilesRNS\Database\ProfilesRNS_CreateDatabase.sql
copy ..\Database\ProfilesRNS_DataLoad_Part1.sql ProfilesRNS\Database\ProfilesRNS_DataLoad_Part1.sql
copy ..\Database\ProfilesRNS_DataLoad_Part3.sql ProfilesRNS\Database\ProfilesRNS_DataLoad_Part3.sql
copy ..\Database\ProfilesRNS_GeoCodeJob.sql ProfilesRNS\Database\ProfilesRNS_GeoCodeJob.sql

del "%RootPath%\Database\ProfilesRNS_CreateSchema.sql"
pushd "%RootPath%\Database\schema"
call CreateSchemaInstallScript.bat > ..\ProfilesRNS_CreateSchema.sql
popd

copy ..\Database\ProfilesRNS_CreateSchema.sql ProfilesRNS\Database\ProfilesRNS_CreateSchema.sql

call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\Profiles\Profiles\Profiles.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\Profiles\Profiles" /t:CopySource

call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service\Connects.Profiles.Service.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service" /t:CopySource
copy "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service\bin\microsoft.ServiceModel.Web.dll" "ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service\bin\microsoft.ServiceModel.Web.dll"
call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.DataContracts\Connects.Profiles.Service.DataContracts.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.DataContracts" /t:CopySource
call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.ServiceContracts\Connects.Profiles.Service.ServiceContracts.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.ServiceContracts" /t:CopySource
call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.ServiceImplementation\Connects.Profiles.Service.ServiceImplementation.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Service.ServiceImplementation" /t:CopySource
call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Utility\Connects.Profiles.Utility.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Connects.Profiles.Utility" /t:CopySource
call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\ProfilesBetaAPI\Profiles.Common\Connects.Profiles.Common.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesBetaAPI\Profiles.Common" /t:CopySource

call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\ProfilesSearchAPI\ProfilesSearchAPI.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesSearchAPI" /t:CopySource
call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\ProfilesSPARQLAPI\ProfilesSPARQLAPI.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\Release\ProfilesRNS\Website\SourceCode\ProfilesSPARQLAPI" /t:CopySource

call C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild "..\Website\SourceCode\SemWeb\src\SemWeb.csproj" "/p:Platform=AnyCPU;Configuration=Release;CopyDestination=..\..\..\..\Release\ProfilesRNS\Website\SourceCode\SemWeb\src" /t:CopySource

copy ..\Website\SourceCode\Profiles\Profiles.sln ProfilesRNS\Website\SourceCode\Profiles\Profiles.sln
echo d | xcopy /s ..\Website\ORNG ProfilesRNS\Website\ORNG
call %zip% a -tzip ProfilesRNS-%Version%.zip ProfilesRNS