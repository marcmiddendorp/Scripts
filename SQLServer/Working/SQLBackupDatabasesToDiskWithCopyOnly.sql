/* Simple script to backup all SQL Server databases with Copy Only switch */

DECLARE @name VARCHAR(50) -- database name 
DECLARE @path VARCHAR(256) -- path for backup files 
DECLARE @fileName VARCHAR(256) -- filename for backup 
DECLARE @fileDate VARCHAR(20) -- used for file name

SET @path = 'M:\MSSQL10_50.SQL5\MSSQL\Backup\'  -- file path here (keep '\' at end of path) --

SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112)

DECLARE db_cursor CURSOR FOR 
SELECT name
FROM master.dbo.sysdatabases
WHERE name NOT IN ('master','model','msdb','tempdb') 

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0  
BEGIN  
       SET @fileName = @path + @name + '_' + @fileDate + '.BAK' 
       BACKUP DATABASE  @name TO DISK = @fileName with COPY_ONLY -- use this switch to prevent affecting the normal backup / restore cycle --


       FETCH NEXT FROM db_cursor INTO @name  
END  

CLOSE db_cursor  
DEALLOCATE db_cursor
