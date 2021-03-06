<!--

    NAME     DirectTranslator.xsl
    VERSION  1.24.0
    DATE     2020-01-10

    Copyright 2012-2020

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
	Translates XML to a simple RDF format. Most usable for debugging purposes

-->
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
>
	<xsl:template match="/">
		<xsl:variable name="uri-filter">[^a-zA-Z0-9:\.\-_~/()#&amp;=,]</xsl:variable>
		<rdf:RDF>
			<xsl:for-each select="response/data/*">
				<rdf:Description rdf:about="http://example.org/id/user/{replace(name,$uri-filter,'')}">
					<foaf:name><xsl:value-of select="name"/></foaf:name>
					<foaf:gender><xsl:value-of select="gender"/></foaf:gender>
					<foaf:age><xsl:value-of select="age"/></foaf:age>
				</rdf:Description>
			</xsl:for-each>
		</rdf:RDF>
	</xsl:template>
</xsl:stylesheet>
