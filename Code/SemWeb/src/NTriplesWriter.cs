using System;
using System.IO;
using SemWeb.Constants;

namespace SemWeb
{
    /// <summary>
    /// Writer that outputs triples in N-Triples format.
    /// </summary>
    public class NTriplesWriter : RdfWriter
    {
        /// <summary>Output writer.</summary>
        private TextWriter m_Writer;

        /// <summary>Namespace manager.</summary>
        private NamespaceManager m_NamespaceManager = new NamespaceManager();

        /// <summary>ID of the formula last added.</summary>
        private Entity m_LastFormulaId;

        /// <summary>
        /// Initializes a new <see cref="NTriplesWriter"/> instance.
        /// </summary>
        /// <param name="writer">The writer.</param>
        public NTriplesWriter(TextWriter writer)
        {
            m_Writer = writer;
        }

        /// <summary>
        /// Initializes a new <see cref="NTriplesWriter"/> instance.
        /// </summary>
        /// <param name="file">The File.</param>
        public NTriplesWriter(string file) : this(GetWriter(file))
        { }

        /// <summary>
        /// Gets the namespace manager.
        /// </summary>
        /// <value>The namespace manager.</value>
        public override NamespaceManager Namespaces
        {
            get { return m_NamespaceManager; }
            set { m_NamespaceManager = value; }
        }

        /// <summary>
        /// Adds the specified statement.
        /// </summary>
        /// <param name="statement">The statement.</param>
        public override void Add(Statement statement)
        {
            if (statement.Meta == Statement.DefaultMeta)
                AddStatement(statement);
            else
                AddFormulaStatement(statement);
        }

        /// <summary>
        /// Adds the statement.
        /// </summary>
        /// <param name="statement">The statement (not a formula).</param>
        protected virtual void AddStatement(Statement statement)
        {
            WriteStatement(statement);
            FlushWriter();
        }

        /// <summary>
        /// Adds the statement of a formula.
        /// </summary>
        /// <param name="statement">The statement.</param>
        protected virtual void AddFormulaStatement(Statement statement)
        {
            Entity formulaId = statement.Meta;
            Entity statementId = new BNode();

            if (m_LastFormulaId != formulaId)
            {
                m_LastFormulaId = formulaId;
                AddStatement(new Statement(formulaId, Predicate.RdfType, Identifier.LogFormula));
            }

            AddStatement(new Statement(formulaId, Predicate.LogIncludes, statementId));
            AddStatement(new Statement(statementId, Predicate.RdfType, Identifier.RdfStatement));
            AddStatement(new Statement(statementId, Predicate.RdfSubject, statement.Subject));
            AddStatement(new Statement(statementId, Predicate.RdfPredicate, statement.Predicate));
            AddStatement(new Statement(statementId, Predicate.RdfObject, statement.Object));
        }

        /// <summary>
        /// Closes the writer and the underlying stream.
        /// </summary>
        public override void Close()
        {
            m_Writer.Close();
        }

        /// <summary>
        /// Writes the statement to the output stream.
        /// </summary>
        /// <param name="statement">The statement.</param>
        protected virtual void WriteStatement(Statement statement)
        {
            WriteEntity(statement.Subject);
            Write(' ');
            WriteStatementBody(statement);
        }

        /// <summary>
        /// Writes the statement body to the output writer.
        /// </summary>
        /// <param name="statement">The statement.</param>
        protected virtual void WriteStatementBody(Statement statement)
        {
            WritePredicate(statement.Predicate);
            Write(' ');
            WriteResource(statement.Object);
            Write('.');
            WriteLine();
        }

        /// <summary>
        /// Writes the specified predicate to the output writer.
        /// </summary>
        /// <param name="predicate">The predicate.</param>
        protected virtual void WritePredicate(Entity predicate)
        {
            WriteEntity(predicate);
        }

        /// <summary>
        /// Writes the specified resource to the output writer.
        /// </summary>
        /// <param name="resource">The resource.</param>
        protected virtual void WriteResource(Resource resource)
        {
            if (resource is Entity)
                WriteEntity((Entity)resource);
            else
                WriteLiteral((Literal)resource);
        }

        /// <summary>
        /// Writes the literal to the output writer.
        /// </summary>
        /// <param name="literal">The literal.</param>
        protected virtual void WriteLiteral(Literal literal)
        {
            if(!String.IsNullOrEmpty(literal.Language))
            {
                WriteLiteralValueWithLanguage(literal.Value, literal.Language);
            }
            else if(!String.IsNullOrEmpty(literal.DataType))
            {
                WriteLiteralValueWithDataType(literal.Value, literal.DataType);
            }
            else
            {
                WriteLiteralValue(literal.Value);
            }
        }

        /// <summary>
        /// Writes the literal value to the output writer.
        /// </summary>
        /// <param name="literal">The literal.</param>
        protected virtual void WriteLiteralValue(string literal)
        {
            Write('"');
            WriteEscaped(literal);
            Write('"');
        }

        /// <summary>
        /// Writes the literal with the specified language to the output writer.
        /// </summary>
        /// <param name="literal">The literal.</param>
        /// <param name="language">The language of the literal.</param>
        protected virtual void WriteLiteralValueWithLanguage(string literal, string language)
        {
            WriteLiteralValue(literal);
            Write('@');
            WriteEscaped(language);
        }

        /// <summary>
        /// Writes the literal with the specified data type to the output writer.
        /// </summary>
        /// <param name="literal">The literal.</param>
        /// <param name="dataType">The data type of the sliteral.</param>
        protected virtual void WriteLiteralValueWithDataType(string literal, string dataType)
        {
            WriteLiteralValue(literal);
            Write("^^");
            WriteUri(dataType);
        }

        /// <summary>
        /// Writes the specified entity to the output writer.
        /// </summary>
        /// <param name="entity">The entity.</param>
        protected virtual void WriteEntity(Entity entity)
        {
            if (entity is BNode)
                WriteBNode((BNode)entity);
            else
                WriteUri(entity);
        }

        /// <summary>
        /// Writes the specified bNode to the output writer.
        /// </summary>
        /// <param name="bNode">The bNode.</param>
        protected virtual void WriteBNode(BNode bNode)
        {
            Write("_:");
            WriteEscaped(bNode.LocalName ?? ("bnode" + Math.Abs(bNode.GetHashCode())));
        }

        /// <summary>
        /// Writes the URI of the specified entity to the output writer.
        /// </summary>
        /// <param name="entity">The entity.</param>
        protected virtual void WriteUri(Entity entity)
        {
            Write('<');
            WriteEscaped(entity.Uri);
            Write('>');
        }

        /// <summary>
        /// Writes the specified character to the output writer.
        /// </summary>
        /// <param name="c">The character.</param>
        protected void Write(char c)
        {
            m_Writer.Write(c);
        }

        /// <summary>
        /// Writes the specified string to the output writer.
        /// </summary>
        /// <param name="s">The string.</param>
        protected void Write(string s)
        {
            m_Writer.Write(s);
        }

        /// <summary>
        /// Writes the specified string to the output writer, escaping special characters.
        /// </summary>
        /// <param name="s">The string.</param>
        protected void WriteEscaped(string s)
        {
            int length = s.Length;
            for (int i = 0; i < length; i++)
            {
                char c = s[i];
                int charCode = (int)c;
                switch (charCode)
                {
                    case 0x09: Write(@"\t"); break;
                    case 0x0A: Write(@"\n"); break;
                    case 0x0D: Write(@"\r"); break;
                    case 0x22: Write(@"\" + '"'); break;
                    case 0x5C: Write(@"\\"); break;
                    default:
                        if (charCode >= 0x20 && charCode <= 0x7E)
                        {
                            Write(c);
                        }
                        else
                        {
                            if (!Char.IsSurrogate(c) || i == length - 1)
                            {
                                Write(@"\u");
                                Write(charCode.ToString("X4"));
                            }
                            else
                            {
                                Write(@"\U");
                                Write(Char.ConvertToUtf32(c, s[++i]).ToString("X8"));
                            }
                        }
                        break;
                }
            }
        }

        /// <summary>
        /// Starts a new line in the output writer.
        /// </summary>
        protected virtual void WriteLine()
        {
            Write('\n');
        }

        /// <summary>
        /// Flushes the output writer.
        /// </summary>
        protected void FlushWriter()
        {
            m_Writer.Flush();
        }
    }
}