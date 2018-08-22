<!--

    NAME     GraphmlTranslator.xsl
    VERSION  1.22.0
    DATE     2018-06-13

    Copyright 2012-2018

    This file is part of the Linked Data Theatre.

    The Linked Data Theatre is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    The Linked Data Theatre is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with the Linked Data Theatre.  If not, see <http://www.gnu.org/licenses/>.

-->
<!--
    DESCRIPTION
	Simple translator for excel files. Assumes only one excel worksheet and a header row containing the properties.

-->
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:graphml="http://graphml.graphdrawing.org/xmlns"
	xmlns:y="http://www.yworks.com/xml/graphml"
	xmlns:yed="http://bp4mc2.org/yed#"
>
	<xsl:key name="header" match="root/workbook/sheet[1]/row[1]/column" use="@id"/>

	<xsl:variable name="container-ns"><xsl:value-of select="root/container/url"/>#</xsl:variable>
	<xsl:variable name="container-url"><xsl:value-of select="root/container/url"/></xsl:variable>

	<xsl:template match="/">
		<rdf:RDF>
			<xsl:for-each select="root/graphml:graphml/graphml:graph/graphml:node">
				<xsl:variable name="uri" select="graphml:data[@key='d3']"/>
				<xsl:if test="$uri!=''">
					<rdf:Description rdf:about="{$uri}">
						<xsl:for-each select="graphml:data/y:GenericNode/y:Geometry">
							<yed:geometry>
								<rdf:Description>
									<yed:height><xsl:value-of select="@height"/></yed:height>
									<yed:width><xsl:value-of select="@width"/></yed:width>
									<yed:x><xsl:value-of select="@x"/></yed:x>
									<yed:y><xsl:value-of select="@y"/></yed:y>
								</rdf:Description>
							</yed:geometry>
						</xsl:for-each>
					</rdf:Description>
				</xsl:if>
			</xsl:for-each>
		</rdf:RDF>
	</xsl:template>
</xsl:stylesheet>