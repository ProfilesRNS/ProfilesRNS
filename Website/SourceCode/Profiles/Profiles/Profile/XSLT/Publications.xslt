<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:geo="http://aims.fao.org/aos/geopolitical.owl#" xmlns:afn="http://jena.hpl.hp.com/ARQ/function#" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:obo="http://purl.obolibrary.org/obo/" xmlns:dcelem="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:event="http://purl.org/NET/c4dm/event.owl#" xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:vann="http://purl.org/vocab/vann/" xmlns:vitro07="http://vitro.mannlib.cornell.edu/ns/vitro/0.7#" xmlns:vitro="http://vitro.mannlib.cornell.edu/ns/vitro/public#" xmlns:vivo="http://vivoweb.org/ontology/core#" xmlns:pvs="http://vivoweb.org/ontology/provenance-support#" xmlns:scirr="http://vivoweb.org/ontology/scientific-research-resource#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:swvs="http://www.w3.org/2003/06/sw-vocab-status/ns#" xmlns:skco="http://www.w3.org/2004/02/skos/core#" xmlns:owl2="http://www.w3.org/2006/12/owl2-xml#" xmlns:skos="http://www.w3.org/2008/05/skos#" xmlns:foaf="http://xmlns.com/foaf/0.1/">
  <xsl:template match="/">
    <xsl:if test="rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://vivoweb.org/ontology/core#InformationResource']">
      <div class="sectionHeader">Publications</div>
      <ol>
        <xsl:for-each select="rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://vivoweb.org/ontology/core#InformationResource']">
          <!-- year part -->
          <xsl:sort select="prns:year" data-type="number" order="descending"/>
          <!-- month part -->
          <xsl:sort select="substring(prns:publicationDate,6,2)" data-type="number" order="descending"/>
          <!-- day part -->
          <xsl:sort select="substring(prns:publicationDate,9,2)" data-type="number" order="descending"/>
          <div id="publicationListAll" class="publications">
            <li>
              <xsl:if test="position()= 1">
                <xsl:attribute name="style">
                  <xsl:value-of select="'border:none'"/>
                </xsl:attribute>
              </xsl:if>
              <div>
                <xsl:value-of select="rdfs:label"/>
              </div>
              <xsl:if test="bibo:pmid !=''">
                <div class="viewIn">
                  <span class="viewInLabel">View in: </span>
                  <a href="http://www.ncbi.nlm.nih.gov/pubmed/{bibo:pmid}" target="_blank">
                    <xsl:value-of select="'PubMed'"/>
                  </a>
                </div>
              </xsl:if>
            </li>
          </div>
        </xsl:for-each>
      </ol>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

