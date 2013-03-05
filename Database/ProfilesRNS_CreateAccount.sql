/*

Copyright (c) 2008-2013 by the President and Fellows of Harvard College. All rights reserved.  Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD., and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the National Center for Research Resources and Harvard University.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name "Harvard" nor the names of its contributors nor the name "Harvard Catalyst" may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER (PRESIDENT AND FELLOWS OF HARVARD COLLEGE) AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


*/
USE [master]
GO
CREATE LOGIN [App_Profiles10] WITH PASSWORD=N'Password1234', DEFAULT_DATABASE=[ProfilesRNS], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [ProfilesRNS]
GO
CREATE USER [App_Profiles10] FOR LOGIN [App_Profiles10] WITH DEFAULT_SCHEMA=[dbo]
GO
EXEC sp_change_users_login 'Auto_Fix', 'App_Profiles10', NULL, 'Password1234'
GO
EXEC sp_addrolemember N'db_datareader', N'App_Profiles10'
GO
EXEC master..sp_addsrvrolemember @loginame = N'App_Profiles10', @rolename = N'sysadmin'
GO
SET NOCOUNT ON
DECLARE @user SYSNAME
 
-- 2 - Set @user variable
SELECT @user='App_Profiles10'
 
-- 4 - Populate temporary table
SELECT  'GRANT EXEC ON ' + '[' + ROUTINE_SCHEMA + ']' + '.' + '[' +ROUTINE_NAME + ']' + ' TO ' + @user
         call
  INTO #storedprocedures
  FROM INFORMATION_SCHEMA.ROUTINES
 WHERE ROUTINE_NAME NOT LIKE 'dt_%'
   AND ROUTINE_TYPE = 'PROCEDURE'
 
-- 6 - WHILE loop
WHILE exists (SELECT TOP 1 * FROM #storedprocedures  )
      BEGIN
       
            DECLARE @sql varchar(max)
            SELECT TOP 1 @sql=call
              FROM #storedprocedures
            DELETE      
              FROM #storedprocedures
             WHERE call=@sql
            EXEC (@SQL)
      END
DROP TABLE #storedprocedures