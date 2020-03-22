<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- This document contains templates used for all outputs (LaTeX, HTML, text, et cetera). -->

    <xsl:template match="name">
        <xsl:value-of select="first"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="middle"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="last"/>
        <xsl:for-each select="title">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:template>

	<xsl:template match="now">current</xsl:template>

	<xsl:template name="publication-authors">
		<xsl:for-each select="authors/name">
			<xsl:if test="position()!=1">
				<xsl:text> and </xsl:text>
			</xsl:if>
			<xsl:value-of select="first"/>
			<xsl:text> </xsl:text>
			<xsl:variable name="middlename" select="middle"/>
			<xsl:if test="$middlename!=''">
				<xsl:value-of select="$middlename"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="last"/>
		</xsl:for-each>
		<xsl:text>.  </xsl:text>
	</xsl:template>
	
</xsl:stylesheet>