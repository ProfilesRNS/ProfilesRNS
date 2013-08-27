<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:geo="http://aims.fao.org/aos/geopolitical.owl#" xmlns:afn="http://jena.hpl.hp.com/ARQ/function#" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:obo="http://purl.obolibrary.org/obo/" xmlns:dcelem="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:event="http://purl.org/NET/c4dm/event.owl#" xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:vann="http://purl.org/vocab/vann/" xmlns:vitro07="http://vitro.mannlib.cornell.edu/ns/vitro/0.7#" xmlns:vitro="http://vitro.mannlib.cornell.edu/ns/vitro/public#" xmlns:vivo="http://vivoweb.org/ontology/core#" xmlns:pvs="http://vivoweb.org/ontology/provenance-support#" xmlns:scirr="http://vivoweb.org/ontology/scientific-research-resource#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:swvs="http://www.w3.org/2003/06/sw-vocab-status/ns#" xmlns:skco="http://www.w3.org/2004/02/skos/core#" xmlns:owl2="http://www.w3.org/2006/12/owl2-xml#" xmlns:skos="http://www.w3.org/2008/05/skos#" xmlns:foaf="http://xmlns.com/foaf/0.1/">
  <xsl:param name="root"></xsl:param>
  <xsl:template match="/">
    <xsl:if test="rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://vivoweb.org/ontology/core#InformationResource']">
		<xsl:variable name="plusImage">
			<xsl:value-of select="$root"/><![CDATA[/Profile/Modules/PropertyList/images/minusSign.gif]]>			
		</xsl:variable>
      <xsl:for-each select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://vivoweb.org/ontology/core#InformationResource']">        

          <div>
            <xsl:value-of select="prns:informationResourceReference"/>
          </div>
        
          <xsl:if test="bibo:pmid !=''">
            <br></br>
            <div class="viewIn">
              <span class="viewInLabel">View in: </span>
              <a href="//www.ncbi.nlm.nih.gov/pubmed/{bibo:pmid}" target="_blank">
                <xsl:value-of select="'PubMed'"/>
              </a>
            </div>
          </xsl:if>

		  <xsl:if test="//rdf:RDF/rdf:Description/rdf:type[@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept']">
		  <br></br>
		  <div class="PropertyGroupItem">
			  <div class="PropertyItemHeader">
				  <a href="javascript:toggleBlock('propertyitem','subjectAreaItems')">
					  <img src="{$plusImage}" style="border: none; text-decoration: none !important" border="0" />
				  </a>
				  subject areas
			  </div>
			  <div class="PropertyGroupData">
				  <div id="subjectAreaItems" style="padding-top: 8px;">
					  <ul style="padding-left:0; margin:0; list-style-type: none;">
						  <xsl:for-each select ="//rdf:RDF/rdf:Description/rdf:type[@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept']">
							  <xsl:variable name="about" select="../@rdf:about"></xsl:variable>
							  <li>
								  <a href="{$about}">
									  <xsl:value-of select="../rdfs:label"/>
								  </a>
							  </li>
						  </xsl:for-each>
					  </ul>
				  </div>
			  </div>
		  </div>
		  </xsl:if>
		  		  
		  <xsl:if test="//rdf:RDF/rdf:Description/rdf:type[@rdf:resource='http://vivoweb.org/ontology/core#Authorship'][../vivo:linkedAuthor]">
		  <br></br>
		  <div class="PropertyGroupItem" style="margin-bottom: 10px;">
			  <div class="PropertyItemHeader">
				  <a href="javascript:toggleBlock('propertyitem','authorshipItems')">
					  <img src="{$plusImage}" style="border: none; text-decoration: none !important" border="0" />
				  </a>
				  authors with profiles
			  </div>
			  <div class="PropertyGroupData">
				  <div id="authorshipItems" style="padding-top: 8px;">
					  <ul style="padding-left:0; margin:0; list-style-type: none;">
						  <xsl:for-each select ="//rdf:RDF/rdf:Description/rdf:type[@rdf:resource='http://vivoweb.org/ontology/core#Authorship']">
							  <xsl:for-each select="../vivo:linkedAuthor">
								  <xsl:variable name="resource" select="@rdf:resource"></xsl:variable>
								  <li>
									  <a href="{$resource}">
										  <xsl:value-of select="//rdf:RDF/rdf:Description[@rdf:about=$resource]/prns:fullName"/>
									  </a>
								  </li>
							  </xsl:for-each>
						  </xsl:for-each>
					  </ul>
				  </div>
			  </div>
		  </div>
		  </xsl:if>
		  <br></br>
        
      </xsl:for-each>

    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

