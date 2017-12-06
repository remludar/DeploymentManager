CREATE LOGIN RiskDataUser WITH PASSWORD = 'Risktadpole1';
GO 

CREATE USER RiskDataUser FOR LOGIN RiskDataUser
GO

EXEC sp_addrolemember 'db_datareader', 'RiskDataUser'; 
GO

