rem convert DC.xml to txt file
type DC.xml >> DC.txt

rem remove namespaces
type DC.txt | findstr /v /i "openarchives" | findstr /v /i "XMLSchema" | findstr /v /i "<OAI-PMH" | findstr /v /i "UTF-8" > DC-ready-to-transform.txt

rem add valid namespaces back to top
echo ^<?xml version="1.0" encoding="UTF-8"?^> >> temp.txt
echo ^<OAI-PMH xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^> >> temp.txt
type DC-ready-to-transform.txt >> temp.txt
move /y temp.txt DC-ready-to-transform.txt

rem convert DC.txt back to xml file
rename DC-ready-to-transform.txt DC-ready-to-transform.xml

rem delete temp files
del "DC.txt"
del "DC.xml"