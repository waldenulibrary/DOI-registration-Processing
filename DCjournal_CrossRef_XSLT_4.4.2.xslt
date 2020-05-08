<?xml version="1.0" encoding="UTF-8"?>
<!-- =============================================================
		Bepress to CrossRef XML Stylsheet for XSLT v2.0 Transformers, Version 1.0
        Compatible with XSLT v2.0 transformers, such as Oxygen XML Editor using the Saxon HE, EE, or PE processor.
        
		Use to transform bepress Digital Commons issue-level journal XML to CrossRef 4.4.2 XML in preparation for batch upload to CrossRef.
 		
        ***Instructions below; update all identified variables prior to transformation.***
        
        Created by Heather P. Westerlund, 08 April 2020, Walden University, and licensed under the GNU General Public License (http://www.gnu.org/licenses/). Added Abstract field. Updated instruction examples for Walden. Updated for CrossRef 4.4.2 schema, including DOI field updates.
		
		Derived from stylesheet created by Jeffrey M. Mortimore, 12 February 2016, Georgia Southern University, and licensed under a 
        Creative Commons Attribution 4.0 International License (http://creativecommons.org/licenses/by/4.0/deed.en). 
		Retrieved 08 April 2020 from https://digitalcommons.georgiasouthern.edu/lib-data/1/.
        
        Derived from stylesheet created by Janice Chan, 01 July 2013, Edith Cowan University, under a 
        Creative Commons Attribution 4.0 International License (http://creativecommons.org/licenses/by/4.0/deed.en).
        Retrieved 12 February 2016 from https://github.com/icecjan/bepress-crossref-doi.
     ============================================================= -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:template match="/">

        <!-- 1. In Digital Commons, post DOIs for all articles in the selected issue. 
		Once posted, deposit DOIs with CrossRef within 24 hours. -->

        <!-- 2. For the selected issue, export the ‘document export’ version of the OAI-PMH XML from Digital Commons.
		The base URL for the issue-level report is:
	
			https://[your-custom-domain]/do/oai/?verb=ListRecords&metadataPrefix=document-export&set=publication:[collection label]/vol[#]/iss[#]/
	
		Here is an exmple for Walden University's JSWGC vol. 1, iss. 1:
	
			https://scholarworks.waldenu.edu/do/oai/?verb=ListRecords&metadataPrefix=document-export&set=publication:jswgc/vol1/iss1/ 		-->

        <!-- 3. Remove the following attributes from the <OAI-PMH> opening element in the exported XML prior to transformation:
            
			xmlns="http://www.openarchives.org/OAI/2.0/"
			xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
			
		Once edited, the <OAI-PMH> opening element should appear as follows:
		
			<OAI-PMH xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			
		The transformation will fail if these attributes are not removed. -->

        <!-- 4. Update the depositor variables if needed. -->

        <xsl:variable name="depositor_name">Depositor name</xsl:variable>
        <xsl:variable name="depositor_email_address">Depositor email</xsl:variable>
        <xsl:variable name="registrant_name">Institution</xsl:variable>

        <!-- 5. Update the journal issn variable. -->

        <xsl:variable name="journal_electronic_issn">XXXX-XXXX</xsl:variable>

        <!-- 6. Transform the XML using a XSLT v2.0 transformer, such as Oxygen XML Editor using the Saxon HE, EE, or PE processor. -->

        <!-- 7. Save the outputed XML file and upload to CrossRef at http://doi.crossref.org. -->

        <xsl:variable name="date" select="adjust-date-to-timezone(current-date(), ())"/>
        <xsl:variable name="time" select="adjust-time-to-timezone(current-time(), ())"/>
        <xsl:variable name="tempdatetime" select="concat($date, '', $time)"/>
        <xsl:variable name="datetime" select="translate($tempdatetime, ':-.', '')"/>

        <doi_batch version="4.4.2" xmlns="http://www.crossref.org/schema/4.4.2"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="https://data.crossref.org/reports/help/schema_doc/doi_resources4.4.2/index.html http://data.crossref.org/schemas/crossref4.4.2.xsd" xmlns:jats="http://www.ncbi.nlm.nih.gov/JATS1">
            <head>
                <doi_batch_id>
                    <xsl:value-of select="$datetime"/>
                </doi_batch_id>
                <timestamp>
                    <xsl:value-of select="$datetime"/>
                </timestamp>
                <depositor>
                    <depositor_name>
                        <xsl:value-of select="$depositor_name"/>
                    </depositor_name>
                    <email_address>
                        <xsl:value-of select="$depositor_email_address"/>
                    </email_address>
                </depositor>
                <registrant>
                    <xsl:value-of select="$registrant_name"/>
                </registrant>
            </head>
            <body>
                <journal>
                    <journal_metadata>
                        <full_title>
                            <xsl:value-of select="OAI-PMH/ListRecords/record[1]/metadata/document-export/documents/document/publication-title"/>
                        </full_title>						
						<xsl:variable name="jabbrev">
							<xsl:value-of select="OAI-PMH/ListRecords/record[1]/metadata/document-export/documents/document/fields/field[@name = 'doi']/value"/>
						</xsl:variable>
						<xsl:variable name="jabbrev_trim">
							<xsl:value-of select="substring-after($jabbrev, '/')"/>
						</xsl:variable>
						<abbrev_title>
							<xsl:value-of select="substring-before($jabbrev_trim, '.')"/>
                        </abbrev_title>                        
						<issn media_type="electronic">
                            <xsl:value-of select="$journal_electronic_issn"/>
                        </issn>
                    </journal_metadata>
                    <journal_issue>
                        <publication_date media_type="online">
                            <xsl:variable name="datestr">
                                <xsl:value-of
                                    select="OAI-PMH/ListRecords/record[1]/metadata/document-export/documents/document/publication-date"
                                />
                            </xsl:variable>
                            <month>
                                <xsl:value-of select="substring($datestr, 6, 2)"/>
                            </month>
                            <day>
                                <xsl:value-of select="substring($datestr, 9, 2)"/>
                            </day>
                            <year>
                                <xsl:value-of select="substring($datestr, 1, 4)"/>
                            </year>
                        </publication_date>
                        <xsl:variable name="voliss">
                            <xsl:value-of select="OAI-PMH/request/@set"/>
                        </xsl:variable>
                        <xsl:variable name="vol_trim">
                            <xsl:value-of select="substring-after($voliss, 'vol')"/>
                        </xsl:variable>
                        <xsl:variable name="iss_trim">
                            <xsl:value-of select="substring-after($voliss, 'iss')"/>
                        </xsl:variable>
                        <journal_volume>
                            <volume>
                                <xsl:value-of select="substring-before($vol_trim, '/')"/>
                            </volume>
                        </journal_volume>
                        <issue>
                            <xsl:value-of select="substring-before($iss_trim, '/')"/>
                        </issue>
                    </journal_issue>
                    <xsl:for-each
                        select="OAI-PMH/ListRecords/record/metadata/document-export/documents/document">
                        <journal_article publication_type="full_text">
                            <titles>
                                <title>
                                    <xsl:value-of select="title"/>
                                </title>
                            </titles>
                            <xsl:if test="authors/author">
                                <contributors>
                                    <xsl:for-each select="authors/author">
                                        <xsl:if test="position() = 1">
                                            <person_name sequence="first" contributor_role="author">
                                                <given_name>
                                                  <xsl:variable name="given_names">
                                                  <xsl:choose>
                                                  <xsl:when test="mname != ''">
                                                  <xsl:value-of select="concat(fname, ' ', mname)"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="fname"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:variable>
                                                  <xsl:value-of select="$given_names"/>
                                                </given_name>
                                                <surname>
                                                  <xsl:value-of select="lname"/>
                                                </surname>
                                                <affiliation>
                                                  <xsl:choose>
                                                  <xsl:when test="institution != ''">
                                                  <xsl:value-of select="institution"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>None</xsl:otherwise>
                                                  </xsl:choose>
                                                </affiliation>
                                            </person_name>
                                        </xsl:if>
                                        <xsl:if test="position() > 1">
                                            <person_name sequence="additional"
                                                contributor_role="author">
                                                <given_name>
                                                  <xsl:variable name="given_names">
                                                  <xsl:choose>
                                                  <xsl:when test="mname > ''">
                                                  <xsl:value-of select="concat(fname, ' ', mname)"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="fname"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:variable>
                                                  <xsl:value-of select="$given_names"/>
                                                </given_name>
                                                <surname>
                                                  <xsl:value-of select="lname"/>
                                                </surname>
                                                <affiliation>
                                                  <xsl:choose>
                                                  <xsl:when test="institution != ''">
                                                  <xsl:value-of select="institution"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>None</xsl:otherwise>
                                                  </xsl:choose>
                                                </affiliation>
                                            </person_name>
                                        </xsl:if>
                                    </xsl:for-each>
                                </contributors>
                            </xsl:if>
							<jats:abstract>
								<xsl:for-each select="abstract">
									<xsl:variable name="abstract">
										<xsl:value-of select="."/>
									</xsl:variable>
									<xsl:if test="$abstract!='Abstract'">
										<jats:p>
											<xsl:value-of
												select="concat(normalize-space(replace(
												replace(
												replace(
												replace(.,'&lt;p&gt;',''),
												'&lt;/p&gt;',''),
												'&lt;strong&gt;',''),
												'&lt;/strong&gt;','')),'')"
											/>
										</jats:p>
									</xsl:if>
								</xsl:for-each>
							</jats:abstract>
                            <publication_date media_type="online">
                                <xsl:variable name="datestr">
                                    <xsl:value-of select="publication-date"/>
                                </xsl:variable>
                                <month>
                                    <xsl:value-of select="substring($datestr, 6, 2)"/>
                                </month>
                                <day>
                                    <xsl:value-of select="substring($datestr, 9, 2)"/>
                                </day>
                                <year>
                                    <xsl:value-of select="substring($datestr, 1, 4)"/>
                                </year>
                            </publication_date>
                            <doi_data>
                                <doi>
                                    <xsl:value-of select="fields/field[@name = 'doi']/value"/>
                                </doi>
                                <resource>
                                    <xsl:value-of select="coverpage-url"/>
                                </resource>
								<collection property="crawler-based">
									<item crawler="iParadigms">
										<resource>
											<xsl:value-of select="fulltext-url"/>
										</resource>
									</item>
								</collection>
                            </doi_data>
                        </journal_article>
                    </xsl:for-each>
                </journal>
            </body>
        </doi_batch>
    </xsl:template>
</xsl:stylesheet>