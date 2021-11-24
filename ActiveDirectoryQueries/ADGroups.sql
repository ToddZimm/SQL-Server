-- Returns a list of groups

select *
from openquery
(ADSI,'SELECT cn, distinguishedName, sAMAccountName
FROM ''LDAP://DC=<<domain>>,DC=<<tld>>'' 
WHERE objectCategory = ''group''
AND cn = ''*<<search string>>*''')
ORDER BY 1
