<!--

    NAME     rdf2xmi.xsl
    VERSION  1.24.1-SNAPSHOT
    DATE     2020-05-19

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
    Transformation of RDF document into XMI

-->
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:uml="http://schema.omg.org/spec/UML/2.1"
	xmlns:xmi="http://schema.omg.org/spec/XMI/2.1"
	xmlns:mim="http://bp4mc2.org/def/mim#"
>

<xsl:key name="nodes" match="rdf:RDF/rdf:Description" use="@rdf:about"/>
<xsl:key name="blanks" match="rdf:RDF/rdf:Description" use="@rdf:nodeID"/>

<xsl:template match="rdf:Description" mode="name">
	<xsl:variable name="tokens" select="tokenize(@rdf:about,'#|/|\\')"/>
	<xsl:variable name="last" select="$tokens[last()]"/>
	<xsl:if test="$last=''"><xsl:value-of select="TODOOOOO"/></xsl:if>
	<xsl:value-of select="$last"/>
</xsl:template>

<!--
XMI for rdfs:Class elements
-->
<xsl:template match="rdf:RDF" mode="rdfs">
	<uml:Model xmi:type="uml:Model" name="LDP_Model" visibility="public">
		<packagedElement xmi:type="uml:Package" xmi:id="LDP_Root_Package" name="Model" visibility="public">
			<packagedElement xmi:type="uml:Package" xmi:id="LDP_Package.1" name="RDFS Classes" visibility="public">
				<xsl:for-each select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2000/01/rdf-schema#Class']">
					<xsl:variable name="name"><xsl:apply-templates select="." mode="name"/></xsl:variable>
					<xsl:variable name="class-uri" select="@rdf:about"/>
					<packagedElement xmi:type="uml:Class" xmi:id="{@rdf:about}" name="{$name}" visibility="public">
						<xsl:for-each select="../rdf:Description[rdfs:domain/@rdf:resource=$class-uri]">
							<xsl:choose>
								<xsl:when test="exists(key('nodes',rdfs:range/@rdf:resource))">
									<ownedAttribute xmi:type="uml:Property" xmi:id="S{@rdf:about}" visibility="public" association="{@rdf:about}" isStatic="false" isReadOnly="false" isDerived="false" isOrdered="false" isUnique="true" isDerivedUnion="false" aggregation="none">
										<type xmi:idref="{rdfs:range/@rdf:resource}"/>
									</ownedAttribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="name"><xsl:apply-templates select="." mode="name"/></xsl:variable>
									<ownedAttribute xmi:type="uml:Property" xmi:id="{@rdf:about}" name="{$name}" visibility="private" isStatic="false" isReadOnly="false" isDerived="false" isOrdered="false" isUnique="true" isDerivedUnion="false"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:for-each select="rdfs:subClassOf">
							<generalization xmi:type="uml:Generalization" xmi:id="G{$class-uri}" general="{@rdf:resource}"/>
						</xsl:for-each>
					</packagedElement>
					<xsl:if test="exists(rdfs:comment)">
						<ownedComment xmi:type="uml:Comment" xmi:id="C{$class-uri}" body="{rdfs:comment}">
							<annotatedElement xmi:idref="{$class-uri}"/>
						</ownedComment>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="rdf:Description[exists(key('nodes',rdfs:domain/@rdf:resource)) and exists(key('nodes',rdfs:range/@rdf:resource))]">
					<xsl:variable name="name"><xsl:apply-templates select="." mode="name"/></xsl:variable>
					<packagedElement xmi:type="uml:Association" xmi:id="{@rdf:about}" name="{$name}" visibility="public">
						<memberEnd xmi:idref="S{@rdf:about}"/>
						<memberEnd xmi:idref="D{@rdf:about}"/>
						<ownedEnd xmi:type="uml:Property" xmi:id="D{@rdf:about}" visibility="public" association="{@rdf:about}" isStatic="false" isReadOnly="false" isDerived="false" isOrdered="false" isUnique="true" isDerivedUnion="false" aggregation="none">
							<type xmi:idref="{rdfs:range/@rdf:resource}"/>
						</ownedEnd>
					</packagedElement>
				</xsl:for-each>
			</packagedElement>
		</packagedElement>
	</uml:Model>
</xsl:template>

<!--
XMI for MIM elements
-->
<xsl:template match="rdf:RDF" mode="mim">
	<uml:Model xmi:type="uml:Model" name="LDP_Model" visibility="public">
		<packagedElement xmi:type="uml:Package" xmi:id="LDP_Root_Package" name="Model" visibility="public">
			<packagedElement xmi:type="uml:Package" xmi:id="LDP_Package.1" name="MIM Model" visibility="public">
				<xsl:for-each select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Objecttype']">
					<xsl:variable name="name"><xsl:apply-templates select="." mode="name"/></xsl:variable>
					<xsl:variable name="class-uri" select="@rdf:about"/>
					<packagedElement xmi:type="uml:Class" xmi:id="{@rdf:about}" name="{$name}" visibility="public">
						<xsl:for-each select="../rdf:Description[mim:objecttype/@rdf:resource=$class-uri]">
							<xsl:if test="exists(key('nodes',mim:gerelateerdObjecttype/@rdf:resource))">
								<xsl:choose>
									<xsl:when test="rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Generalisatie'">
										<generalization xmi:type="uml:Generalization" xmi:id="{@rdf:about}" general="{mim:gerelateerdObjecttype/@rdf:resource}"/>
									</xsl:when>
									<xsl:when test="rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Relatiesoort' and not(mim:typeAggregatie/@rdf:resource='http://bp4mc2.org/def/mim#Composite')">
										<ownedAttribute xmi:type="uml:Property" xmi:id="S{@rdf:about}" name="{mim:naam}" visibility="public" association="{@rdf:about}" isStatic="false" isReadOnly="false" isDerived="false" isOrdered="false" isUnique="true" isDerivedUnion="false" aggregation="none">
											<type xmi:idref="{mim:gerelateerdObjecttype/@rdf:resource}"/>
										</ownedAttribute>
									</xsl:when>
									<xsl:otherwise />
								</xsl:choose>
							</xsl:if>
						</xsl:for-each>
					</packagedElement>
					<xsl:if test="exists(mim:definitie)">
						<ownedComment xmi:type="uml:Comment" xmi:id="C{$class-uri}" body="{mim:definitie}">
							<annotatedElement xmi:idref="{$class-uri}"/>
						</ownedComment>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Relatiesoort' and exists(key('nodes',mim:objecttype/@rdf:resource)) and exists(key('nodes',mim:gerelateerdObjecttype/@rdf:resource))]">
					<packagedElement xmi:type="uml:Association" xmi:id="{@rdf:about}" name="" visibility="public">
						<memberEnd xmi:idref="S{@rdf:about}"/>
						<memberEnd xmi:idref="D{@rdf:about}"/>
						<xsl:if test="mim:typeAggregatie/@rdf:resource='http://bp4mc2.org/def/mim#Composite'">
							<ownedEnd xmi:type="uml:Property" xmi:id="S{@rdf:about}" visibility="public" association="{@rdf:about}" isStatic="false" isReadOnly="false" isDerived="false" isOrdered="false" isUnique="true" isDerivedUnion="false" aggregation="composite">
								<type xmi:idref="{mim:gerelateerdObjecttype/@rdf:resource}"/>
							</ownedEnd>
						</xsl:if>
						<ownedEnd xmi:type="uml:Property" xmi:id="D{@rdf:about}" visibility="public" association="{@rdf:about}" isStatic="false" isReadOnly="true" isDerived="false" isOrdered="false" isUnique="true" isDerivedUnion="false" aggregation="none">
							<type xmi:idref="{mim:objecttype/@rdf:resource}"/>
						</ownedEnd>
					</packagedElement>
				</xsl:for-each>
			</packagedElement>
		</packagedElement>
	</uml:Model>
	<xsl:for-each select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Objecttype']">
		<mim:Objecttype xmi:id="mim:Objecttype" base_Class="{@rdf:about}"/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="/">
	<xsl:for-each select="results/rdf:RDF[1]">
		<xmi:XMI xmi:version="2.1">
			<xmi:Documentation exporter="Linked Data Platform" exporterVersion="0.1"/>
			<xsl:if test="exists(rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2000/01/rdf-schema#Class'])">
				<xsl:apply-templates select="." mode="rdfs"/>
			</xsl:if>
			<xsl:if test="exists(rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Objecttype'])">
				<xsl:apply-templates select="." mode="mim"/>
			</xsl:if>
		</xmi:XMI>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
