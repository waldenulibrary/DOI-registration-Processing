# DOI-registration-Processing
 Crosswalk Digital Commons metadata to Crossref for DOI registration.

## Configuration

If the depositor info will generally stay the same, update the depositor variables in the XSLT:

    <xsl:variable name="depositor_name">Depositor name</xsl:variable>
    <xsl:variable name="depositor_email_address">Depositor email</xsl:variable>
    <xsl:variable name="registrant_name">Institution</xsl:variable>

## XML Crosswalking Instructions

1. In Digital Commons, publish DOIs for all articles in the selected issue, then deposit DOIs with CrossRef within 24 hours.

1. For the selected issue, export the ‘document export’ version of the OAI-PMH XML from Digital Commons. The base URL for the issue-level report is:
   * https://[your-custom-domain]/do/oai/?verb=ListRecords&metadataPrefix=document-export&set=publication:[collection label]/vol[#]/iss[#]/

   Here is an example for Walden University's JSWGC vol. 1, iss. 1:
   * https://scholarworks.waldenu.edu/do/oai/?verb=ListRecords&metadataPrefix=document-export&set=publication:jswgc/vol1/iss1/

1. In the Digital Commons XML, remove the following attributes from the <OAI-PMH> opening element in the exported XML prior to transformation. The transformation will fail if these attributes are not removed:
	
       xmlns="http://www.openarchives.org/OAI/2.0/"
       xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
	
   Once edited, the <OAI-PMH> opening element should appear as follows:

       <OAI-PMH xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

1. Update the depositor variables in the XSLT if needed:

       <xsl:variable name="depositor_name">Depositor name</xsl:variable>
       <xsl:variable name="depositor_email_address">Depositor email</xsl:variable>
       <xsl:variable name="registrant_name">Institution</xsl:variable>

1. Update the journal issn variable:

       <xsl:variable name="journal_electronic_issn">XXXX-XXXX</xsl:variable>

1. Transform the XML using a XSLT v2.0 transformer, such as Oxygen XML Editor using the Saxon HE, EE, or PE processor

1. Save the outputed XML file and upload to CrossRef at https://doi.crossref.org
