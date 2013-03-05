/*

Copyright (c) 2008-2013 by the President and Fellows of Harvard College. All rights reserved.  Profiles Reseah Networking Software was developed under the supervision of Griffin M Weber, MD, PhD., and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the National Center for Reseah Resoues and Harvard University.

Redistribution and use in soue and binary forms, with or without modification, are permitted provided that the following conditions are met:
    * Redistributions of soue code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name "Harvard" nor the names of its contributors nor the name "Harvard Catalyst" may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER (PRESIDENT AND FELLOWS OF HARVARD COLLEGE) AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MEHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


*/
-- Step 1 Load base data files
EXEC [Framework.].[LoadXMLFile] @FilePath = 'C:\InstallData.xml', @TableDestination = '[Framework.].[InstallData]', @DestinationColumn = 'DATA'
EXEC [Framework.].[LoadXMLFile] @FilePath = 'C:\VIVO_1.4.owl', @TableDestination = '[Ontology.Import].owl', @DestinationColumn = 'DATA', @NameValue = 'VIVO_1.4'
EXEC [Framework.].[LoadXMLFile] @FilePath = 'C:\PRNS_1.0.owl', @TableDestination = '[Ontology.Import].owl', @DestinationColumn = 'DATA', @NameValue = 'PRNS_1.0'
EXEC [Framework.].[LoadXMLFile] @FilePath = 'C:\SemGroups.xml', @TableDestination = '[Profile.Data].[Concept.Mesh.File]', @DestinationColumn = 'DATA', @NameValue = 'SemGroups.xml'
EXEC [Framework.].[LoadXMLFile] @FilePath = 'C:\MeSH.xml', @TableDestination = '[Profile.Data].[Concept.Mesh.File]', @DestinationColumn = 'DATA', @NameValue = 'MeSH.xml'
EXEC [Framework.].[LoadInstallData]
UPDATE [Framework.].[Parameter] SET Value = 'http://localhost/profiles' WHERE ParameterID = 'basePath'
EXEC [Framework.].[RunJobGroup] @JobGroup = 1