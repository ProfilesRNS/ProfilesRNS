namespace SemWeb.Constants
{
    /// <summary>
    /// Common RDF namespaces.
    /// </summary>
    public static class Namespace
    {
        public const string RDF = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
        public const string OWL = "http://www.w3.org/2002/07/owl#";
        public const string LOG = "http://www.w3.org/2000/10/swap/log#";
        public const string XMLSCHEMA = "http://www.w3.org/2001/XMLSchema#";
    }

    /// <summary>
    /// Common RDF identifiers.
    /// </summary>
    public static class Identifier
    {
        public static readonly Entity RdfStatement = Namespace.RDF + "Statement";
        public static readonly Entity RdfNil = Namespace.RDF + "nil";

        public const string XML_INTEGER = Namespace.XMLSCHEMA + "integer";
        public const string XML_INTEGER_ABBREV = Namespace.XMLSCHEMA + "int";
        public const string XML_DOUBLE = Namespace.XMLSCHEMA + "double";
        public const string XML_DECIMAL = Namespace.XMLSCHEMA + "decimal";
        public const string XML_FLOAT = Namespace.XMLSCHEMA + "float";
        public const string XML_BOOLEAN = Namespace.XMLSCHEMA + "boolean";

        public static readonly Entity XmlInteger = XML_INTEGER;
        public static readonly Entity XmlDouble = XML_DOUBLE;
        public static readonly Entity XmlDecimal = XML_DECIMAL;
        public static readonly Entity XmlBoolean = XML_BOOLEAN;
		
		public static readonly Entity LogFormula = Namespace.LOG + "Formula";
    }

    /// <summary>
    /// Common RDF predicates.
    /// </summary>
    public class Predicate
    {
        public static readonly Entity RdfType = Namespace.RDF + "type";
        public static readonly Entity RdfSubject = Namespace.RDF + "subject";
        public static readonly Entity RdfPredicate = Namespace.RDF + "predicate";
        public static readonly Entity RdfObject = Namespace.RDF + "object";
        public static readonly Entity RdfFirst = Namespace.RDF + "first";
        public static readonly Entity RdfRest = Namespace.RDF + "rest";

        public static readonly Entity OwlSameAs = Namespace.OWL + "sameAs";

        public static readonly Entity LogImplies = Namespace.LOG + "implies";
        public static readonly Entity LogIncludes = Namespace.LOG + "includes";
    }
}