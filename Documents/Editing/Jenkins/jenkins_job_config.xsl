<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="xs xd"
  version="2.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> May 31, 2012</xd:p>
      <xd:p><xd:b>Author:</xd:b> mholmes</xd:p>
      <xd:p>This transformation is designed to modify config.xml files for Jenkins TEI build jobs which are 
                  checked out from the TEI SourceForge SVN. It does two things:
      <xd:ul>
        <xd:li>Replaces the email addresses of Sebastian and Martin with that of the person creating 
        the Jenkins server, if they provided one, or nothing if they didn't. This prevents a new Jenkins 
        server from emailing SR and MDH if builds fail.</xd:li>
        <xd:li>Inserts job priorty settings into the properties element if these are not already present.
        This enables the Jenkins Priority Sorter plugin to schedule jobs correctly so that dependencies
        are satisfied, especially when the server is started up for the first time.</xd:li>
      </xd:ul>
        This is basically an identity transform with a few active templates.
      </xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="jobPriority">100</xsl:param>
  <xsl:param name="email"></xsl:param>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
<!-- If any jobs use the svn: protocol, they'll fail on a default install of Ubuntu 12.04 server. 
  We change it to http.-->
  <xsl:template match="remote[starts-with(., 'svn://')]">
    <remote><xsl:value-of select="replace(., 'svn://', 'http://')"/></remote>
  </xsl:template>
  
<!-- Insert the appropriate priority setting for this job, as specified in the parameter. -->
  
  <xsl:template match="properties[not(hudson.queueSorter.PrioritySorterJobProperty)]">
    <properties>
        <xsl:apply-templates/>
        <hudson.queueSorter.PrioritySorterJobProperty>
          <priority><xsl:value-of select="$jobPriority"/></priority>
        </hudson.queueSorter.PrioritySorterJobProperty>
    </properties>
</xsl:template>
  
<!-- Insert the email address for the server administrator, as specified in the parameter. -->
  <xsl:template match="hudson.tasks.Mailer/recipients">
    <recipients><xsl:value-of select="$email"/></recipients>
  </xsl:template>
  
<!-- Provide mailer section if it is not already there (e.g. in OxGarage job config). -->
  <xsl:template match="publishers[not(hudson.tasks.Mailer)]">
    <publishers>
      <xsl:apply-templates/>
      <xsl:if test="string-length($email) gt 4">
        <hudson.tasks.Mailer>
          <recipients><xsl:value-of select="$email"/></recipients>
          <dontNotifyEveryUnstableBuild>false</dontNotifyEveryUnstableBuild>
          <sendToIndividuals>true</sendToIndividuals>
        </hudson.tasks.Mailer>
      </xsl:if>
    </publishers>
  </xsl:template>
  
  <xsl:template match="@*|*|processing-instruction()|comment()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>