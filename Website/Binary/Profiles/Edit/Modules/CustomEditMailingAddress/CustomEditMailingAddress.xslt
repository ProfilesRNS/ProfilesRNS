<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:geo="http://aims.fao.org/aos/geopolitical.owl#" xmlns:afn="http://jena.hpl.hp.com/ARQ/function#" xmlns:prns="http://profiles.catalyst.harvard.edu/ontology/prns#" xmlns:obo="http://purl.obolibrary.org/obo/" xmlns:dcelem="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:event="http://purl.org/NET/c4dm/event.owl#" xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:vann="http://purl.org/vocab/vann/" xmlns:vitro07="http://vitro.mannlib.cornell.edu/ns/vitro/0.7#" xmlns:vitro="http://vitro.mannlib.cornell.edu/ns/vitro/public#" xmlns:vivo="http://vivoweb.org/ontology/core#" xmlns:pvs="http://vivoweb.org/ontology/provenance-support#" xmlns:scirr="http://vivoweb.org/ontology/scientific-research-resource#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:swvs="http://www.w3.org/2003/06/sw-vocab-status/ns#" xmlns:skco="http://www.w3.org/2004/02/skos/core#" xmlns:owl2="http://www.w3.org/2006/12/owl2-xml#" xmlns:skos="http://www.w3.org/2008/05/skos#" xmlns:foaf="http://xmlns.com/foaf/0.1/">
  <xsl:template match="/"> 
    
    <xsl:if test="rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/rdfs:label !=''">
      <table>
       
        <tr>
          <td>            
            <xsl:if test="rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/vivo:addressDepartment !=''">
              <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/vivo:addressDepartment "/>
              <br/>
            </xsl:if>
            <xsl:if test="rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/vivo:address1 !=''">
              <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/vivo:address1 "/>
              <br/>
            </xsl:if>
            <xsl:if test="rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[@rdf:about=rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/vivo:address2 !=''">
              <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/vivo:address2 "/>
              <br/>
            </xsl:if>
            <xsl:if test="rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/vivo:address3 !=''">
              <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/vivo:address3 "/>
              <br/>
            </xsl:if>            
            <xsl:if test="rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/vivo:addressCity !=''">
              <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/vivo:addressCity"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/vivo:addressState"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource]/rdf:object/@rdf:resource]/vivo:addressPostalCode"/>
              <br/>
            </xsl:if>
          </td>
        </tr>
  
      </table>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
