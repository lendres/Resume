<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!--
    xmlns:math="http://exslt.org/math"
    extension-element-prefixes="math"
    -->

    <xsl:import href="common.xslt"/>
    <xsl:import href="xsl-template-functions.xsl"/>
	<xsl:output indent="yes" method="text"/>

	<xsl:template match="/">
    \documentclass{resume}
    \usepackage{lelists}
    \setlength{\listtopsep}{0pt}
    \setlength{\listindent}{0pt}

    \usepackage{subscripts}
    \usepackage{lehyperlink}
    \usepackage{leheadersandfooters}

    \usepackage{multicol}
    \setlength{\premulticols}{0in}
    \setlength{\postmulticols}{0in}

    \usepackage{leaddress}
    \usepackage{times}
	
	\usepackage[resetlabels]{multibib}
	\newcites{publications}{Publications}
	\newcites{patents}{Patents}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE PERSONAL INFORMATION.  DEFINE BEFORE BEGIN DOCUMENT OR IT
% WILL NOT BE PROCESSED CORRECTLY.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    \name{<xsl:apply-templates select="/resume/head/name"/>}
	\addresslinea{\myaddresslineoneshort}
	\addresslineb{\myaddresslinetwo}

	\renewcommand*{\phonename}{{\small{}Phone:}}
	\phone{\myphoneone}
	\renewcommand*{\emailname}{{\small{}Email:}}
	\email{\myemailthree}
	\website{\mywebsiteone}

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% BEGIN DOCUMENT.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	\pagestyle{lehorizontallinewpagenumber}
	\begin{document}
	\thispagestyle{lefooterhorizontalline}
	\makeresumeheaderB

	\catagory{Summary}
	<xsl:apply-templates select="/resume/summary"/>

	\catagory{Areas of Expertise}
	<xsl:apply-templates select="/resume/keywords"/>

    \catagory{Experience}
    <xsl:apply-templates select="/resume/experience"/>

	\catagory{Education}
	<xsl:apply-templates select="/resume/education"/>

    \vspace*{1pt}
    \catagory{Publications}
    <xsl:apply-templates select="/resume/publications/publication"/>
	\bibliographystylepublications{leplain}
	\bibliographypublications{le}
	
	\catagory{Patents}
	<xsl:apply-templates select="/resume/patents/patent"/>
	\bibliographystylepatents{leplain}
	\bibliographypatents{le}

    \catagory{Other Skills}
	<!--\begin{multicols}{3}-->
    \begin{bulletedlist}
		<xsl:apply-templates select="/resume/skills/group"/>
	\end{bulletedlist}
	<!--\end{multicols}-->

		\catagory{Certi{f}ications}
		<xsl:apply-templates select="/resume/certifications"/>

		\catagory{Af{f}iliations}
		<xsl:apply-templates select="/resume/memberships/membership"/>

        <!--\vspace*{1pt}
        \catagory{References}
        \catentryshort{}{\normalfont Available upon request}-->

        \end{document}
    </xsl:template>

	<!--<xsl:template match="group">
		<xsl:apply-templates select="./skill"/>
	</xsl:template>
	
	<xsl:template match="skill">
		\item <xsl:call-template name="make-string-latex-compatible"><xsl:with-param name="text" select="text()"/></xsl:call-template>
	</xsl:template>-->

    <xsl:template match="group">
        <xsl:variable name="heading" select="@heading"/>
        \item <xsl:value-of select="$heading"/><xsl:if test="$heading!=''">: </xsl:if>

        <xsl:variable name="count" select="count(skill)"/>

        <xsl:for-each select="skill">
            
            <!-- Extract the name of the skill and convert it to a LaTeX friendly format. -->
            <xsl:variable name="skill">
                <xsl:call-template name="make-string-latex-compatible">
                    <xsl:with-param name="text" select="."/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="$count>1">
                    <xsl:choose>
                        <!-- Last skill so format it a little different. -->
                        <xsl:when test="position()=$count">and <xsl:value-of select="$skill"/>.
                        </xsl:when>

                        <xsl:otherwise>
                            <!-- Write the skill and a comma. -->
                            <xsl:value-of select="$skill"/>,
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$skill"/>.
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

	
	<xsl:template match="summary">
		<xsl:value-of select="normalize-space(text())"/>
	</xsl:template>
	<xsl:template match="keywords">
		<xsl:for-each select="keyword">
			<xsl:if test="position()>1">
				<xsl:text> $\bullet$ </xsl:text>
			</xsl:if>
			<xsl:value-of select="text()"/>
		</xsl:for-each>
	</xsl:template>

    <xsl:template match="membership">
        <!-- Example: \catentryshort{January 2008}{Society of Petroleum Engineers (SPE)} -->
        <!-- Example: \catentry{December 1997}{Chi Epsilon - National Civil Engineering Honor Society}{Lawrence Tech chapter president from September 1998 to April 1999} -->
        <xsl:variable name="notes" select="notes"/>
        <xsl:choose>
            <xsl:when test="$notes=''">
                \catentrymembership<xsl:call-template name="membership-start"/>{}
            </xsl:when>
            <xsl:otherwise>
                \catentrymembership<xsl:call-template name="membership-start"/>{<xsl:value-of select="$notes"/>}
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="membership-start">
        <xsl:variable name="id" select="institution/@id"/>
        <xsl:variable name="institution" select="/resume/institutions/institution[@id=$id]"/>
        <xsl:variable name="institutionname" select="$institution/@name"/>
        {<xsl:value-of select="date/@year"/>}
        {<xsl:value-of select="$institutionname"/><xsl:if test="$institution/description!=''"> - <xsl:value-of select="$institution/description"/></xsl:if>}
    </xsl:template>

    <xsl:template match="publication">
        \nocitepublications{<xsl:value-of select="@id"/>}
    </xsl:template>

	<xsl:template match="patent">
        \nocitepatents{<xsl:value-of select="@id"/>}
    </xsl:template>

    <xsl:template match="certifications">
        <xsl:for-each select="certification">
			\catentrycertification{<xsl:value-of select="date/@year"/>}
                {<xsl:value-of select="title"/>}
                {<xsl:value-of select="address/city"/>, <xsl:value-of select="address/state"/>}
        </xsl:for-each>
    </xsl:template>

	<xsl:template match="experience">
		<xsl:variable name="njobs" select="count(job)"/>
        <xsl:for-each select="job">
            \catentry{<xsl:apply-templates select="./daterange/from"/> - <xsl:apply-templates select="./daterange/to"/>}
            {<xsl:value-of select="title[position()=1]"/>
            <xsl:for-each select="title">
	            <xsl:if test="position()>1">
		            <xsl:text> / </xsl:text><xsl:value-of select="."/>
	            </xsl:if>
            </xsl:for-each>
            <xsl:variable name="group" select="group"/>
            <xsl:if test="$group!=''"> \\ <xsl:value-of select="$group"/></xsl:if>}
            {<xsl:call-template name="get-company-name">
	            <xsl:with-param name="companyreference" select="company"/>
            </xsl:call-template>}
			{<xsl:call-template name="get-company-address">
	            <xsl:with-param name="companyreference" select="company"/>
            </xsl:call-template>}
			<xsl:variable name="desc" select="description"/>
			<xsl:choose>
				<xsl:when test="$desc!=''">
					\vspace*{-6pt}
					\noindent <xsl:call-template name="job-description"><xsl:with-param name="description" select="$desc"/></xsl:call-template>\hspace*{0pt}\\ \vspace*{-2pt}
				</xsl:when>
				<!-- 
					If we don't have a description, then adjust the spacing to match the entries that do have
					a description.  The exception is when we are at the last job entry.  Then we don't add the
					extra spacing or it messes up the spacing before the next Catagory Entry.
				-->
				<xsl:when test="position()!=$njobs">\\
						\vspace*{-8pt}
				</xsl:when>
			</xsl:choose>
			<!--<xsl:if test="position()=2">
					\newpage{}
			</xsl:if>-->
		</xsl:for-each>
		\vspace*{-8pt}
	</xsl:template>

	<xsl:template name="job-description">
		<xsl:param name="description"/>
		<xsl:value-of select="$description/p/text()"/>
		<xsl:apply-templates select="$description/bulletedlist"/>
	</xsl:template>

	<xsl:template match="bulletedlist">
		\begin{bulletedlist}
			<xsl:apply-templates select="*"/>
		\end{bulletedlist}
			\vspace*{-12pt}
	</xsl:template>
	
	<xsl:template match="item">
		\item <xsl:value-of select="text()"/>
	</xsl:template>
	
	<xsl:template match="from">
		<xsl:apply-templates select="*"/>
	</xsl:template>
    
    <xsl:template match="date">
        <xsl:value-of select="@monthnumber"/>
		<xsl:text>/</xsl:text>
        <xsl:value-of select="@year"/>
    </xsl:template>

	<xsl:template name="get-company-name">
		<xsl:param name="companyreference"/>
		<xsl:variable name="id" select="$companyreference/@id"/>
		<xsl:variable name="company" select="/resume/institutions/institution[@id=$id]"/>
        <xsl:call-template name="make-string-latex-compatible">
            <xsl:with-param name="text" select="$company/@name"/>
        </xsl:call-template>
    </xsl:template>

	<xsl:template name="get-company-address">
		<xsl:param name="companyreference"/>
		<xsl:variable name="id" select="$companyreference/@id"/>
		<xsl:variable name="company" select="/resume/institutions/institution[@id=$id]"/>
		<xsl:value-of select="$company/address/city"/>, <xsl:value-of select="$company/address/state"/>
	</xsl:template>

	<xsl:template name="make-string-latex-compatible">
        <xsl:param name="text"/>

        <!-- See replace string for a possible better method. -->
        <xsl:variable name="result1">
            <xsl:call-template name="replace-string">
                <xsl:with-param name="text" select="$text"/>
                <xsl:with-param name="from">&amp;</xsl:with-param>
                <xsl:with-param name="to">\&amp;</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="result2">
            <xsl:call-template name="replace-string">
                <xsl:with-param name="text" select="$result1"/>
                <xsl:with-param name="from">#</xsl:with-param>
                <xsl:with-param name="to">\#</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="$result2"/>
    </xsl:template>

	<xsl:template match="education">
		<xsl:for-each select="degree">
            <xsl:variable name="id" select="institution/@id"/>
            <xsl:variable name="institution" select="/resume/institutions/institution[@id=$id]"/>
            \catentryeducation{<xsl:value-of select="date/@year"/>}
                {<xsl:value-of select="@level"/><xsl:text> in </xsl:text><xsl:value-of select="major"/>}
                {<xsl:value-of select="$institution/@name"/>}
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>