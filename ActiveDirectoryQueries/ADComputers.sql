-- Returns details for a single computer account.

SELECT 
  *,
  CAST((CAST(lastLogon AS numeric(23,1)) / 864000000000.0 - 109207) AS DATETIME) LastLogon
FROM OPENQUERY 
(ADSI, ' 
  SELECT 
  CN, 
  distinguishedName, 
  dNSHostName, 
  location,
  operatingSystem,
  operatingSystemServicePack,
  operatingSystemVersion,
  lastLogon
  From 
  ''LDAP://DC=<<domain>>,DC=<<tld>>'' 
  Where objectCategory=''computer'' 
  And objectClass = ''computer'' 
  And CN = ''<<computer name>>''  
  ' ) 
