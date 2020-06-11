rem convert DC.xml to txt file
type DC.xml >> DC.txt

rem remove namespaces
type DC.txt | findstr /v /i "openarchives" | findstr /v /i "XMLSchema" | findstr /v /i "<OAI-PMH" | findstr /v /i "UTF-8" > DC-ready-to-tranform.txt

rem add valid namespaces back to top
echo ^<?xml version="1.0" encoding="UTF-8"?^> >> temp.txt
echo ^<OAI-PMH xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^> >> temp.txt
type DC-ready-to-tranform.txt >> temp.txt
move /y temp.txt DC-ready-to-tranform.txt

rem convert DC.txt back to xml file
rename DC-ready-to-tranform.txt DC-ready-to-tranform.xml

rem delete temp files
del "DC.txt"
del "DC.xml"