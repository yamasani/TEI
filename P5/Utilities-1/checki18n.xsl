<xsl:stylesheet version="1.0"
	  xmlns:rng="http://relaxng.org/ns/structure/1.0"
	  xmlns:tei="http://www.tei-c.org/ns/1.0"
	  exclude-result-prefixes="rng tei"
	  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:param name="lang">ja</xsl:param>
<xsl:param name="date">2008-01-30</xsl:param>
<xsl:key name="REMARKS" match="tei:remarks[not(@xml:lang) and string-length(.)&gt;0]" use="1"/>
<xsl:key name="GLOSS" match="tei:gloss[not(@xml:lang) and string-length(.)&gt;0]" use="1"/>
<xsl:key name="DESC"  match="tei:desc[not(@xml:lang) and string-length(.)&gt;0]" use="1"/>
<xsl:key name="VALDESC"  match="tei:valDesc[not(@xml:lang) and string-length(.)&gt;0]" use="1"/>
<xsl:template match="/">
  <TEI  xmlns="http://www.tei-c.org/ns/1.0">
<!--
    <xsl:for-each select="key('GLOSS',1)">
      <xsl:if test="not(../tei:gloss[@xml:lang=$lang])">
	<xsl:call-template name="foo"/>
      </xsl:if>
    </xsl:for-each>
-->
    <xsl:for-each select="key('DESC',1)">
      <xsl:if test="not(../tei:desc[@xml:lang=$lang])">
	<xsl:call-template name="foo"/>
      </xsl:if>
    </xsl:for-each>


    <xsl:for-each select="key('REMARKS',1)">
      <xsl:if test="not(../tei:remarks[@xml:lang=$lang])">
	<xsl:call-template name="foo"/>
      </xsl:if>
    </xsl:for-each>

<!--
    <xsl:for-each select="key('VALDESC',1)">
      <xsl:if test="not(../tei:valDesc[@xml:lang=$lang])">
	<xsl:call-template name="foo"/>
      </xsl:if>
    </xsl:for-each>
-->  
</TEI>
</xsl:template>

<xsl:template name="foo">
  <xsl:choose>
    <xsl:when test="parent::tei:classSpec">
      <classSpec ident="{../@ident}"
		 xmlns="http://www.tei-c.org/ns/1.0">
	<xsl:call-template name="show"/>
      </classSpec>
    </xsl:when>
    
    <xsl:when test="parent::tei:valItem and ancestor::tei:classSpec">
      <classSpec ident="{ancestor::tei:classSpec/@ident}"
		 xmlns="http://www.tei-c.org/ns/1.0">
	<attList>
	  <attDef ident="{ancestor::tei:attDef/@ident}">
	    <valList>
	      <valItem ident="{ancestor::tei:valItem/@ident}">
		<xsl:call-template name="show"/>
	      </valItem>
	    </valList>
	  </attDef>
	</attList>
      </classSpec>
    </xsl:when>

    <xsl:when test="ancestor::tei:attDef and ancestor::tei:classSpec">
	<classSpec ident="{ancestor::tei:classSpec/@ident}"
		     xmlns="http://www.tei-c.org/ns/1.0">
	  <attList>
	    <attDef ident="{ancestor::tei:attDef/@ident}">
		<xsl:call-template name="show"/>
	    </attDef>
	  </attList>
	</classSpec>	
    </xsl:when>

    <xsl:when test="parent::tei:elementSpec">
      <elementSpec ident="{../@ident}"
		 xmlns="http://www.tei-c.org/ns/1.0">
	<xsl:call-template name="show"/>
      </elementSpec>
    </xsl:when>
    
    <xsl:when test="parent::tei:valItem and ancestor::tei:elementSpec">
      <elementSpec ident="{ancestor::tei:elementSpec/@ident}"
		 xmlns="http://www.tei-c.org/ns/1.0">
	<attList>
	  <attDef ident="{ancestor::tei:attDef/@ident}">
	    <valList>
	      <valItem ident="{ancestor::tei:valItem/@ident}">
		<xsl:call-template name="show"/>
	      </valItem>
	    </valList>
	  </attDef>
	</attList>
      </elementSpec>
    </xsl:when>

    <xsl:when test="ancestor::tei:attDef and ancestor::tei:elementSpec">
	<elementSpec ident="{ancestor::tei:elementSpec/@ident}"
		     xmlns="http://www.tei-c.org/ns/1.0">
	  <attList>
	    <attDef ident="{ancestor::tei:attDef/@ident}">
		<xsl:call-template name="show"/>
	    </attDef>
	  </attList>
	</elementSpec>	
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="show">
  <xsl:element name="{local-name(.)}" xmlns="http://www.tei-c.org/ns/1.0">
    <xsl:attribute name="version">
      <xsl:value-of select="$date"/>
    </xsl:attribute>
    <xsl:attribute name="xml:lang">
      <xsl:value-of select="$lang"/>
    </xsl:attribute>
    <xsl:comment>ENGLISH:  <xsl:value-of
    select="translate(.,'-','–')"/></xsl:comment>
      <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="@*|text()">
  <xsl:copy/>
</xsl:template>

<xsl:template match="*">
 <xsl:copy>
  <xsl:apply-templates select="@*"/>
  <xsl:apply-templates       
      select="*|text()"/>
 </xsl:copy>
</xsl:template>

</xsl:stylesheet>
