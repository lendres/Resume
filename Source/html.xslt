<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="common.xslt"/>
	<xsl:output indent="yes" method="html"/>

	<xsl:template match="/">
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"&gt;</xsl:text>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Resume of <xsl:apply-templates select="/resume/head/name"/></title>
				<link rel="stylesheet" type="text/css" href="resume.css"/>
			</head>
			
			<body>
				<div class="content">
					<h1 class="name">
						<xsl:apply-templates select="/resume/head/name"/>
					</h1>
					<hr class="divider"/>

					<div class="navigation">
						<a href="#experience">Experience</a>
						<a href="#education">Education</a>
						<a href="#publicatioins">Publications</a>
						<a href="#certifications">Certifications</a>
						<a href="#skills">Skills</a>
						<a href="#memberships">Memberships</a>
						<!--<a href="#references">References</a>-->
					</div>

					<h2 id="experience" class="catagory">Experience</h2>
					<xsl:apply-templates select="/resume/experience"/>

					<h2 id="education" class="catagory">Education</h2>
					<xsl:apply-templates select="/resume/education"/>
					
					<h2 id="publicatioins" class="catagory">Publications</h2>
					<xsl:apply-templates select="/resume/publications/publication"/>
                    
					<h2 id="certifications" class="catagory">Certifications</h2>
					<h2 id="skills" class="catagory">Skills</h2>
					<h2 id="memberships" class="catagory">Memberships</h2>
					<!--<h2 id="references" class="catagory">References</h2>
					<div class="refavailable">Available Upon Request</div>-->
				</div>
			</body>
		</html>
	</xsl:template>

    <xsl:template match="publication">
        <xsl:variable name="id" select="@id"/>
        <xsl:apply-templates select="/resume/bibliography/*[@id=$id]">
            <xsl:with-param name="position" select="position()"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="inproceedings">
        <xsl:param name="position"/>
        <p class="publication">[<xsl:value-of select="$position"/>]
            <xsl:call-template name="publication-authors"/>
            <xsl:call-template name="publication-title"/>.  
			<xsl:call-template name="book-title"/>,
			<xsl:value-of select="address/city"/>, 
			<xsl:value-of select="address/state"/>, 
			<xsl:value-of select="date/@month"/><xsl:text> </xsl:text>
			<xsl:value-of select="date/@year"/>.
        </p>
    </xsl:template>

    <xsl:template match="article">
        <xsl:param name="position"/>
        <p class="publication">[<xsl:value-of select="$position"/>]
			<xsl:call-template name="publication-authors"/>
			<xsl:call-template name="publication-title"/>.
			<xsl:call-template name="journal-title"/>,
			<xsl:value-of select="volume"/>
			<xsl:variable name="number" select="number"/>
			<xsl:if test="$number!=''">
				(<xsl:value-of select="number"/>)
			</xsl:if>,
			<xsl:value-of select="date/@year"/>.
        </p>
    </xsl:template>

	<xsl:template match="phdthesis">
		<xsl:param name="position"/>
		<p class="publication">[<xsl:value-of select="$position"/>]
			<xsl:call-template name="publication-authors"/>
			<span class="phd-title">
				<xsl:call-template name="publication-title"/>
			</span>.  PhD thesis,
			<xsl:variable name="id" select="school/@id"/>
			<xsl:variable name="school" select="/resume/institutions/institution[@id=$id]"/>
			<xsl:value-of select="$school/@name"/>, 
			<xsl:value-of select="$school/address/city"/>, 
			<xsl:value-of select="$school/address/state"/>, 
			<xsl:value-of select="date/@month"/>, 
			<xsl:value-of select="date/@year"/>.
		</p>
	</xsl:template>

    <xsl:template name="publication-title">
        <span class="publication-title">
            <xsl:value-of select="title"/>
        </span>
    </xsl:template>

	<xsl:template name="book-title">In
		<span class="book-title">
			<xsl:value-of select="booktitle"/>
		</span>
	</xsl:template>

	<xsl:template name="journal-title">
		<span class="book-title">
			<xsl:variable name="id" select="journal/@id"/>
			<xsl:value-of select="/resume/bibliography/journals/journal[@id=$id]/abbname"/>
		</span>
	</xsl:template>
  
	<xsl:template match="name">
		<xsl:value-of select="first"/> <xsl:text> </xsl:text>
		<xsl:value-of select="middle"/> <xsl:text> </xsl:text>
		<xsl:value-of select="last"/>
		<xsl:for-each select="title">
			<xsl:text>, </xsl:text>
			<xsl:value-of select="."/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="experience">
		<xsl:for-each select="job">
			<div class="job">
				<h3 class="job-title">
					<xsl:value-of select="title[position()=1]"/>
					<xsl:for-each select="title">
						<xsl:if test="position()>1">
							<xsl:text> / </xsl:text><xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</h3>
				<p class="company-name">
					<xsl:call-template name="get-company-name-as-url">
						<xsl:with-param name="companyreference" select="company"/>
					</xsl:call-template>
				</p>
				<p class="company-group"><xsl:value-of select="group"/></p>
				<xsl:value-of select="description"/>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="get-company-name-as-url">
		<xsl:param name="companyreference"/>
		<xsl:variable name="id" select="$companyreference/@id"/>
		<xsl:variable name="company" select="/resume/institutions/institution[@id=$id]"/>

		<xsl:variable name="companyurl">
			<xsl:value-of select="$company/url"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$companyurl=''">
				<xsl:value-of select="$company/@name"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="$companyurl"/>
					</xsl:attribute>
					<xsl:value-of select="$company/@name"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="education">
		<xsl:for-each select="degree">
			<div class="degree">
				<h3 class="degree">
					<xsl:value-of select="@level"/>
					<xsl:text> in </xsl:text>
					<xsl:value-of select="major"/>
				</h3>
				<p class="degree-date">
					<xsl:value-of select="date/@month"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="date/@year"/>
				</p>

                <xsl:variable name="id" select="institution/@id"/>
                <xsl:variable name="institution" select="/resume/institutions/institution[@id=$id]"/>

                <p class="degree-institution">
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="$institution/url"/>
					</xsl:attribute>
					<xsl:value-of select="$institution/@name"/>
				</xsl:element>
				</p>
			</div>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>