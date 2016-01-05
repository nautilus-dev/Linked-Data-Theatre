<!--

    NAME     test.xpl
    VERSION  1.5.0
    DATE     2016-01-05

    Copyright 2012-2016

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
    Test pipeline, to test the new RDB2RDF processor
	
-->
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline"
		  xmlns:xforms="http://www.w3.org/2002/xforms"
          xmlns:oxf="http://www.orbeon.com/oxf/processors"
		  xmlns:sparql="http://www.w3.org/2005/sparql-results#"
		  xmlns:ev="http://www.w3.org/2001/xml-events"
		  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		  xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<!-- Configuration> -->
	<p:param type="input" name="instance"/>

	<p:processor name="oxf:rdb2rdf-processor">
		<p:input name="config">
			<config>
				<mappingDocument>proefMapping.ttl</mappingDocument>
				<outputFile>D:/Tomcat/temp/rdf-dump.ttl</outputFile>
			</config>
		</p:input>
		<p:output name="data" id="output"/>
	</p:processor>
	
	<p:processor name="oxf:xml-serializer">
		<p:input name="config">
			<config>
			</config>
		</p:input>
		<p:input name="data" href="#output"/>
	</p:processor>

</p:config>
