using System;
using System.Collections;
using System.IO;
using SemWeb.Constants;

namespace SemWeb
{
    /// <summary>
    /// Writer that outputs triples in Turtle format.
    /// </summary>
    public class TurtleWriter : NTriplesWriter
    {
        /// <summary>File indentation marker.</summary>
        private int m_Indentation = 0;

        /// <summary>The subject previously written.</summary>
        private Entity m_PreviousSubject;
        /// <summary>The predicate previously written.</summary>
        private Entity m_PreviousPredicate;

        /// <summary>Entity abbreviations.</summary>
        protected static readonly Hashtable TurtleAbbreviations;

        /// <summary>
        /// Initializes the <see cref="TurtleWriter"/> class.
        /// </summary>
        static TurtleWriter()
        {
            TurtleAbbreviations = new Hashtable();
            TurtleAbbreviations[Predicate.RdfType.Uri] = "a";
        }

        /// <summary>
        /// Gets the namespace abbreviations hashtable.
        /// </summary>
        /// <returns>A hashtable of URI/abbreviation pairs.</returns>
        protected virtual Hashtable Abbreviations { get { return TurtleAbbreviations; } }

        /// <summary>
        /// Initializes a new <see cref="TurtleWriter"/> instance.
        /// </summary>
        /// <param name="writer">The writer.</param>
        public TurtleWriter(TextWriter writer) : base (writer)
        {
            Namespaces = new AbbreviatedNamespaceManagerWrapper(Namespaces, Abbreviations);
        }

        /// <summary>
        /// Initializes a new <see cref="TurtleWriter"/> instance.
        /// </summary>
        /// <param name="file">The File.</param>
        public TurtleWriter(string file) : this(GetWriter(file)) { }

        /// <summary>
        /// Adds the statement.
        /// </summary>
        /// <param name="statement">The statement (not a formula).</param>
        protected override void AddStatement(Statement statement)
        {
            if(m_PreviousSubject == null)
            {
                WriteNamespaces();
            }
            base.AddStatement(statement);
        }

        /// <summary>
        /// Closes the writer and the underlying stream.
        /// </summary>
        public override void Close()
        {
            if (m_PreviousSubject != null)
            {
                Write('.');
            }
            base.Close();
        }

        /// <summary>
        /// Writes the namespace declarations.
        /// </summary>
        protected virtual void WriteNamespaces()
        {
            foreach (string prefix in Namespaces.GetPrefixes())
            {
                Write("@prefix ");
                WriteEscaped(prefix);
                Write(": <");
                WriteEscaped(Namespaces.GetNamespace(prefix));
                Write(">.\n");
            }
        }

        /// <summary>
        /// Writes the statement to the output stream.
        /// </summary>
        /// <param name="statement">The statement.</param>
        protected override void WriteStatement(Statement statement)
        {
            if (statement.Subject != m_PreviousSubject)
            {
                if (m_PreviousSubject != null)
                {
                    Write(".");
                    WriteLine();
                }

                WriteEntity(statement.Subject);
                Write(' ');
                m_PreviousSubject = statement.Subject;
                m_PreviousPredicate = null;
            }
            WriteStatementBody(statement);
        }

        /// <summary>
        /// Writes the statement body to the output writer.
        /// </summary>
        /// <param name="statement">The statement.</param>
        protected override void WriteStatementBody(Statement statement)
        {
            int indentation = 0;
            if (statement.Predicate != m_PreviousPredicate)
            {
                if (m_PreviousPredicate != null)
                {
                    Write(';');
                    WriteLine();
                    indentation += IncrementIndentation(1);
                    WriteIndentation();
                }
                WritePredicate(statement.Predicate);
                Write(' ');
            }
            else
            {
                indentation += IncrementIndentation(2);
                Write(",");
                WriteLine();
                WriteIndentation();
            }
            WriteResource(statement.Object);
            DecrementIndentation(indentation);

            m_PreviousPredicate = statement.Predicate;
        }

        /// <summary>
        /// Writes the specified bNode to the output writer.
        /// </summary>
        /// <param name="bNode">The bNode.</param>
        protected override void WriteBNode(BNode bNode)
        {
            if (bNode is Variable)
                WriteVariable((Variable)bNode);
            else
                base.WriteBNode(bNode);
        }

        /// <summary>
        /// Writes the specified variable to the output writer.
        /// </summary>
        /// <param name="variable">The variable.</param>
        protected virtual void WriteVariable(Variable variable)
        {
            Write("?");
            WriteEscaped(variable.LocalName ?? ("var" + Math.Abs(variable.GetHashCode())));
        }

        /// <summary>
        /// Writes the URI of the specified entity to the output writer.
        /// </summary>
        /// <param name="entity">The entity.</param>
        protected override void WriteUri(Entity entity)
        {
            string prefix, localname;
            if (Namespaces.Normalize(entity.Uri, out prefix, out localname))
            {
                if(prefix != null)
                {
                    WriteEscaped(prefix);
                    Write(':');
                }
                WriteEscaped(localname);
            }
            else
            {
                base.WriteUri(entity);
            }
        }

        /// <summary>
        /// Writes the literal with the specified data type to the output writer.
        /// </summary>
        /// <param name="literal">The literal.</param>
        /// <param name="dataType">The data type of the literal.</param>
        protected override void WriteLiteralValueWithDataType(string literal, string dataType)
        {
            switch(dataType)
            {
                case Identifier.XML_INTEGER:
                case Identifier.XML_INTEGER_ABBREV:
                case Identifier.XML_DOUBLE:
                case Identifier.XML_DECIMAL:
                case Identifier.XML_FLOAT:
                case Identifier.XML_BOOLEAN:
                    Write(literal);
                    break;
                default:
                    base.WriteLiteralValueWithDataType(literal, dataType);
                    break;
            }
        }

        /// <summary>
        /// Increments the indentation.
        /// </summary>
        /// <param name="units">The number units to increment.</param>
        /// <returns><paramref name="units"/>.</returns>
        protected virtual int IncrementIndentation(int units)
        {
            m_Indentation += units;
            return units;
        }

        /// <summary>
        /// Decrements the indentation.
        /// </summary>
        /// <param name="units">The number units to decrement.</param>
        /// <returns><paramref name="units"/>.</returns>
        protected virtual int DecrementIndentation(int units)
        {
            m_Indentation -= units;
            return units;
        }

        /// <summary>
        /// Starts a new line in the output writer.
        /// </summary>
        protected virtual void WriteIndentation()
        {
            for(int i=0; i<m_Indentation; i++)
                Write('\t');
        }

        /// <summary>
        /// NamespaceManager that extends an existing manager with abbreviation support.
        /// </summary>
        protected class AbbreviatedNamespaceManagerWrapper : NamespaceManager
        {
            /// <summary>The original namespace manager.</summary>
            private NamespaceManager m_OriginalNamespaceManager;
            /// <summary>Hashtable of URI/abbreviation pairs.</summary>
            private Hashtable m_Abbreviations;
            /// <summary>Minimum abbreviated URI length.</summary>
            private readonly int m_MinKeyLength;
            /// <summary>Maximum abbreviated URI length.</summary>
            private readonly int m_MaxKeyLength;

            /// <summary>
            /// Initializes a new <see cref="AbbreviatedNamespaceManagerWrapper"/> instance.
            /// </summary>
            /// <param name="originalNamespaceManager">The original namespace manager.</param>
            /// <param name="abbreviations">The abbreviations.</param>
            public AbbreviatedNamespaceManagerWrapper(NamespaceManager originalNamespaceManager, Hashtable abbreviations)
            {
                m_OriginalNamespaceManager = originalNamespaceManager;
                m_Abbreviations = abbreviations;
				
                // calculate minimum and maximum abbreviated URI length
                m_MaxKeyLength = 0;
                m_MinKeyLength = int.MaxValue;
                foreach (var key in abbreviations.Keys)
                {
                    m_MinKeyLength = Math.Min(((string) key).Length, m_MinKeyLength);
                    m_MaxKeyLength = Math.Max(((string)key).Length, m_MaxKeyLength);
                }
            }

            /// <summary>
            /// Maps the namespace with the specified URI to the specified prefix.
            /// </summary>
            /// <param name="uri">The URI.</param>
            /// <param name="prefix">The prefix.</param>
            public override void AddNamespace(string uri, string prefix)
            {
                m_OriginalNamespaceManager.AddNamespace(uri, prefix);
            }

            /// <summary>
            /// Gets the namespace with the specified prefix.
            /// </summary>
            /// <param name="prefix">The prefix.</param>
            /// <returns>The namespace</returns>
            public override string GetNamespace(string prefix)
            {
                return m_OriginalNamespaceManager.GetNamespace(prefix);
            }

            /// <summary>
            /// Gets the prefix of the specified namespace.
            /// </summary>
            /// <param name="uri">The URI.</param>
            /// <returns></returns>
            public override string GetPrefix(string uri)
            {
                return m_OriginalNamespaceManager.GetPrefix(uri);
            }

            /// <summary>
            /// Normalizes the specified URI.
            /// </summary>
            /// <param name="uri">The URI.</param>
            /// <param name="prefix">The prefix.</param>
            /// <param name="localname">The localname.</param>
            /// <returns><c>true</c> if a normalization was successful; otherwise, <c>false</c>.</returns>
            public override bool Normalize(string uri, out string prefix, out string localname)
            {
                // performance optimization: check abbreviations can contain URI by checking its length
                if (uri.Length >= m_MinKeyLength && uri.Length <= m_MaxKeyLength
                    && m_Abbreviations.ContainsKey(uri))
                {
                    prefix = null;
                    localname = (string)m_Abbreviations[uri];
                    return true;
                }
                else
                {
                    return m_OriginalNamespaceManager.Normalize(uri, out prefix, out localname);
                }
            }

            /// <summary>
            /// Normalizes the specified URI.
            /// </summary>
            /// <param name="uri">The URI.</param>
            /// <returns>The normalized URI.</returns>
            public override string Normalize(string uri)
            {
                if (m_Abbreviations.ContainsKey(uri))
                    return (string)m_Abbreviations[uri];
                else
                    return m_OriginalNamespaceManager.Normalize(uri);
            }

            /// <summary>
            /// Resolves the specified qName.
            /// </summary>
            /// <param name="qname">The qName.</param>
            /// <returns>The resolved URI.</returns>
            public override string Resolve(string qName)
            {
                return m_OriginalNamespaceManager.Resolve(qName);
            }

            /// <summary>
            /// Gets the namespaces.
            /// </summary>
            /// <returns>The namespaces.</returns>
            public override ICollection GetNamespaces()
            {
                return m_OriginalNamespaceManager.GetNamespaces();
            }

            /// <summary>
            /// Gets the prefixes.
            /// </summary>
            /// <returns>The prefixes.</returns>
            public override ICollection GetPrefixes()
            {
                return m_OriginalNamespaceManager.GetPrefixes();
            }
        }
    }
}