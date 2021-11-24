-- Returns details for a single AD user account.

SELECT *,
  CASE WHEN (userAccountControl & 2) <> 0 THEN 1 ELSE 0 END AS Disabled,
  CASE WHEN (userAccountControl & 10) <> 0 THEN 1 ELSE 0 END AS Locked,
  DATEADD(ms, ((LastLogonTimeStamp) / CAST(10000 AS bigint)) % 86400000, DATEADD(day, (LastLogonTimeStamp) / CAST(864000000000 AS bigint) - 109207, 0)) AS LastLogon
       
FROM OPENQUERY 
(ADSI, ' 
  SELECT 
  distinguishedName,
  CN, 
  sAMAccountname, 
  DisplayName, 
  LastLogonTimeStamp,
  telephoneNumber, 
  mail, 
  department, 
  title, 
  company,
  PrimaryGroupId,
  employeeID, 
  employeeNumber, 
  userAccountControl, 
  givenName, 
  sn, 
  middlename, 
  generationQualifier, 
  facsimileTelephoneNumber, 
  pager,
  manager,
  homedirectory,
  accountExpires,
  userPrincipalName
  From 
  ''LDAP://DC=<<domain>>,DC=<<tld>>'' 
  Where objectCategory=''person'' 
  And objectClass = ''user'' 
  And sAMAccountname = ''<<userid>>''  
  ' ) 
