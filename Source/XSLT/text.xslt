<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="common.xslt" />
    <xsl:import href="xsl-template-functions.xsl"/>
	<xsl:output indent="yes" method="text"/>

	<xsl:template match="/">
	<xsl:apply-templates select="/resume/head/name"/>

Summary:
<xsl:apply-templates select="/resume/summary"/>

Areas of Expertise:
<xsl:apply-templates select="/resume/keywords"/>

Experience:
<xsl:apply-templates select="/resume/experience"/>

Education:
<xsl:apply-templates select="/resume/education"/>

Publications:
<xsl:apply-templates select="/resume/publications/publication"/>

<xsl:apply-templates select="/resume/patents"/>

Skills:
<xsl:apply-templates select="/resume/skills/group"/>

<xsl:apply-templates select="/resume/certifications"/>

<xsl:apply-templates select="/resume/memberships"/>

	</xsl:template>

	
    <xsl:template match="group">
        <xsl:variable name="heading" select="@heading"/>
        <xsl:value-of select="$heading"/><xsl:if test="$heading!=''">: </xsl:if>
        <xsl:variable name="count" select="count(skill)"/>
        <xsl:for-each select="skill">
            <xsl:variable name="skill" select="."/>
            <xsl:choose>
                <xsl:when test="$count>1">
                    <xsl:choose>
                        <!--Last skill so format it a little different. -->
                        <xsl:when test="position()=$count">and <xsl:value-of select="$skill"/>.
                        </xsl:when>
                        <xsl:otherwise><!-- Write the skill and a comma. --><xsl:value-of select="$skill"/>, </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$skill"/>.
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
<xsl:text>
</xsl:text>
    </xsl:template>

	<xsl:template match="summary">
		<xsl:value-of select="normalize-space(text())"/>
	</xsl:template>
	<xsl:template match="keywords">
		<xsl:for-each select="keyword">
			<xsl:if test="position()>1"><xsl:text>, </xsl:text>
			</xsl:if>
<xsl:value-of select="text()"/>
		</xsl:for-each>
	</xsl:template>

	
	<!-- Memberships. -->
	<xsl:template match="memberships">
<xsl:text>
Affiliations:
</xsl:text>
		<xsl:apply-templates select="./membership"/>
	</xsl:template>
	
	<xsl:template match="membership">
        <xsl:variable name="notes" select="notes"/>
        <xsl:choose>
            <xsl:when test="$notes=''">
				<xsl:call-template name="membership-start"/>
            </xsl:when>
            <xsl:otherwise>
				<xsl:call-template name="membership-start"/><xsl:value-of select="$notes"/>
<xsl:text>
</xsl:text>
			</xsl:otherwise>
        </xsl:choose>
<xsl:text>
</xsl:text>
	</xsl:template>

    <xsl:template name="membership-start">
        <xsl:variable name="id" select="institution/@id"/>
        <xsl:variable name="institution" select="/resume/institutions/institution[@id=$id]"/>
        <xsl:variable name="institutionname" select="$institution/@name"/>
<xsl:value-of select="date/@month"/><xsl:text> </xsl:text><xsl:value-of select="date/@year"/>
<xsl:text>
</xsl:text>
        <xsl:value-of select="$institutionname"/><xsl:if test="$institution/description!=''"> - <xsl:value-of select="$institution/description"/></xsl:if>
<xsl:text>
</xsl:text>
    </xsl:template>


	<xsl:template match="patents">
<xsl:text>
Patents:
</xsl:text>
		<xsl:for-each select="patent">
			<xsl:variable name="id" select="@id"/>
			<xsl:apply-templates select="/resume/bibliography/*[@id=$id]">
				<xsl:with-param name="position" select="position()"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="patent">
		<xsl:param name="position"/>[<xsl:value-of select="$position"/>] <xsl:value-of select="title"/>.  <xsl:call-template name="publication-authors"/><xsl:value-of select="publisher"/><xsl:text> </xsl:text> <xsl:value-of select="number"/>, filed <xsl:value-of select="./filed/date/@month"/><xsl:text> </xsl:text><xsl:value-of select="./filed/date/@day"/><xsl:text>, </xsl:text><xsl:value-of select="filed/date/@year"/>.
<xsl:text>
</xsl:text>
	</xsl:template>
	

	<!-- Publications -->
	<xsl:template match="publication">
		<xsl:variable name="id" select="@id"/>
		<xsl:apply-templates select="/resume/bibliography/*[@id=$id]">
			<xsl:with-param name="position" select="position()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="inproceedings">
		<xsl:param name="position"/>[<xsl:value-of select="$position"/>] <xsl:call-template name="publication-authors"/><xsl:value-of select="title"/>.  In <xsl:value-of select="booktitle"/>, <xsl:value-of select="address/city"/>, <xsl:value-of select="address/state"/>, <xsl:value-of select="date/@month"/><xsl:text> </xsl:text><xsl:value-of select="date/@year"/>.
<xsl:text>
</xsl:text>
	</xsl:template>

	<xsl:template match="article">
		<xsl:param name="position"/>[<xsl:value-of select="$position"/>] <xsl:call-template name="publication-authors"/><xsl:value-of select="title"/>.  <xsl:call-template name="journal-title"/>, <xsl:value-of select="volume"/> <xsl:variable name="number" select="number"/><xsl:if test="$number!=''"> (<xsl:value-of select="number"/>) </xsl:if>, <xsl:value-of select="date/@year"/>.
<xsl:text>
</xsl:text>
	</xsl:template>

	<xsl:template match="onlinearticle">
		<xsl:param name="position"/>[<xsl:value-of select="$position"/>] <xsl:call-template name="publication-authors"/><xsl:value-of select="title"/>.  <xsl:value-of select="website"/>, online article, <xsl:value-of select="date/@month"/>, <xsl:value-of select="date/@year"/>.
		<xsl:text>
</xsl:text>
	</xsl:template>

	<xsl:template match="phdthesis">
		<xsl:param name="position"/>[<xsl:value-of select="$position"/>] <xsl:call-template name="publication-authors"/><xsl:value-of select="title"/>.  PhD thesis, <xsl:variable name="id" select="school/@id"/> <xsl:variable name="school" select="/resume/institutions/institution[@id=$id]"/> <xsl:value-of select="$school/@name"/>, <xsl:value-of select="$school/address/city"/>, <xsl:value-of select="$school/address/state"/>, <xsl:value-of select="date/@month"/>, <xsl:value-of select="date/@year"/>.
<xsl:text>
</xsl:text>
	</xsl:template>

	<xsl:template name="journal-title">
		<xsl:variable name="id" select="journal/@id"/>
		<xsl:value-of select="/resume/bibliography/journals/journal[@id=$id]/abbname"/>
	</xsl:template>
	
	
	<!-- Certifications -->
    <xsl:template match="certifications">
<xsl:text>
Certifications:
</xsl:text>
		<xsl:for-each select="certification">
<xsl:value-of select="date/@month"/><xsl:text> </xsl:text><xsl:value-of select="date/@year"/>
<xsl:text>
</xsl:text>
			<xsl:value-of select="title"/>
<xsl:text>
</xsl:text>
			<xsl:value-of select="address/city"/><xsl:text>, </xsl:text><xsl:value-of select="address/state"/><xsl:text>  </xsl:text><xsl:value-of select="address/zip"/>
<xsl:text>
</xsl:text>
        </xsl:for-each>
    </xsl:template>

	
	<!-- Main experience entry. -->
	<xsl:template match="experience">
		<xsl:variable name="njobs" select="count(job)"/>
        <xsl:for-each select="job">
            <xsl:apply-templates select="./daterange/from"/> to <xsl:apply-templates select="./daterange/to"/>
<xsl:text>
</xsl:text>
<xsl:for-each select="title">
<xsl:value-of select="."/>
<xsl:text>
</xsl:text>
</xsl:for-each>
            <xsl:variable name="group" select="group"/>
<xsl:if test="$group!=''">
<xsl:value-of select="$group"/>
</xsl:if>
            <xsl:call-template name="get-company-info">
	            <xsl:with-param name="companyreference" select="company"/>
            </xsl:call-template>
<xsl:variable name="desc" select="description"/>
<xsl:choose>
<xsl:when test="$desc!=''">
<!--<xsl:value-of select="normalize-space($desc)"/>-->
<xsl:call-template name="job-description"><xsl:with-param name="description" select="$desc"/></xsl:call-template>
<xsl:text>

</xsl:text>
</xsl:when>
</xsl:choose>
</xsl:for-each>
	</xsl:template>
	<!-- End of main experience entry. -->

	<xsl:template name="job-description"><xsl:param name="description"/>
<xsl:value-of select="normalize-space($description/p/text())"/>
<xsl:text>
</xsl:text>
<xsl:apply-templates select="$description/bulletedlist"/>
	</xsl:template>

	<xsl:template match="bulletedlist">
<xsl:for-each select="item"><xsl:text>- </xsl:text><xsl:value-of select="normalize-space()"/>
<xsl:text>
</xsl:text>
</xsl:for-each>
	</xsl:template>
	
	<!-- Dates -->
    <xsl:template match="from">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    
    <xsl:template match="date">
        <xsl:value-of select="@month"/>
		<xsl:text> </xsl:text>
        <xsl:value-of select="@year"/>
    </xsl:template>
    
	<xsl:template name="get-company-info">
		<xsl:param name="companyreference"/>
		<xsl:variable name="id" select="$companyreference/@id"/>
		<xsl:variable name="company" select="/resume/institutions/institution[@id=$id]"/>
		<xsl:value-of select="$company/@name"/>
<xsl:text>
</xsl:text>
		<xsl:value-of select="$company/address/city"/>, <xsl:value-of select="$company/address/state"/><xsl:text>  </xsl:text><xsl:value-of select="$company/address/zip"/>
<xsl:text>
</xsl:text>
    </xsl:template>

	<xsl:template match="education">
		<xsl:for-each select="degree">
            <xsl:variable name="id" select="institution/@id"/>
            <xsl:variable name="institution" select="/resume/institutions/institution[@id=$id]"/>
            <xsl:value-of select="date/@month"/> <xsl:text> </xsl:text> <xsl:value-of select="date/@year"/>
<xsl:text>
</xsl:text>
                <xsl:value-of select="@level"/><xsl:text> in </xsl:text><xsl:value-of select="major"/>
<xsl:text>
</xsl:text>
			<xsl:value-of select="$institution/@name"/>
<xsl:text>
</xsl:text>
                 <xsl:value-of select="$institution/address/city"/>, <xsl:value-of select="$institution/address/state"/><xsl:text>  </xsl:text><xsl:value-of select="$institution/address/zip"/>
<xsl:text>

</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>