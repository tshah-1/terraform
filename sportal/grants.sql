create user 'cms'@'%' IDENTIFIED BY PASSWORD '*F7CD99DF8F3760BE3E54320720CA1E9FB41290FE'
grant SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, REFERENCES, INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER ON *.* TO 'cms'@'%' with grant option;



GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, RELOAD, PROCESS, FILE, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON *.* TO 'cms'@'localhost' IDENTIFIED BY PASSWORD '*F7CD99DF8F3760BE3E54320720CA1E9FB41290FE' WITH GRANT OPTION |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

create user 'dbimg'@'%' IDENTIFIED BY PASSWORD '*03D3379F3580909ADE8123FF676D5F292AE527CC';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE ON *.* TO 'dbimg'@'localhost';
---------------------------------------------------+
| Grants for dbimg@localhost                                                                                                                                                                                                                                       |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, FILE, INDEX, ALTER, CREATE TEMPORARY TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE ON *.* TO 'dbimg'@'localhost' IDENTIFIED BY PASSWORD '*03D3379F3580909ADE8123FF676D5F292AE527CC' |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

+-------------------------------------------------------------------------------------------------------------------------------+
| Grants for replicator@localhost                                                                                               |
+-------------------------------------------------------------------------------------------------------------------------------+
| GRANT REPLICATION SLAVE ON *.* TO 'replicator'@'localhost' IDENTIFIED BY PASSWORD '*CBFE67E586C4ECDA9F14B514E099672EBD6258CD' |
+-------------------------------------------------------------------------------------------------------------------------------+

create user 'M@5t3r'@'%' IDENTIFIED BY PASSWORD '*B714CEFE80BBE583A096546B6C0AD854D0A15610';
GRANT USAGE ON *.* TO 'M@5t3r'@'localhost';
+---------------------------------------------------------------------------------------------------------------+
| Grants for M@5t3r@localhost                                                                                   |
+---------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'M@5t3r'@'localhost' IDENTIFIED BY PASSWORD '*B714CEFE80BBE583A096546B6C0AD854D0A15610' |
+---------------------------------------------------------------------------------------------------------------+
1 row in set (0.27 sec)


create user 'pma'@'%' IDENTIFIED BY PASSWORD '*E919E7E5630C4D056BC40BA31C688B67A12657A4';
-------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Grants for pma@localhost                                                                                                                                                                                                                                                                                                                                                   |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'pma'@'localhost' IDENTIFIED BY PASSWORD '*E919E7E5630C4D056BC40BA31C688B67A12657A4'                                                                                                                                                                                                                                                                 |
| GRANT SELECT ON `mysql`.`host` TO 'pma'@'localhost'                                                                                                                                                                                                                                                                                                                        |
| GRANT SELECT ON `mysql`.`db` TO 'pma'@'localhost'                                                                                                                                                                                                                                                                                                                          |
| GRANT SELECT (Host, Create_priv, Shutdown_priv, Delete_priv, User, Process_priv, Reload_priv, Alter_priv, Super_priv, Grant_priv, Create_tmp_table_priv, Execute_priv, Repl_client_priv, Insert_priv, Repl_slave_priv, Lock_tables_priv, References_priv, Index_priv, File_priv, Drop_priv, Show_db_priv, Select_priv, Update_priv) ON `mysql`.`user` TO 'pma'@'localhost' |
| GRANT SELECT (Table_priv, Column_priv, Table_name, Db, User, Host) ON `mysql`.`tables_priv` TO 'pma'@'localhost'                                                                                                                                                                                                                                                           |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
5 rows in set (6.28 sec)
