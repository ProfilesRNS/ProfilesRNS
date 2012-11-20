#if DOTNET2
using System.Collections;
using System.Collections.Generic;
using System.IO;
using SemWeb.Constants;

namespace SemWeb
{
    /// <summary>
    /// Writer that outputs triples in Notation3 format.
    /// </summary>
    /// <remarks>
    /// This class' memory use is proportional to the number of statements written.
    /// Intended for pretty printing.
    /// Use <see cref="TurtleWriter"/> or <see cref="NTriplesWriter"/> for performance.
    /// </remarks>
    public class N3Writer : TurtleWriter
    {
        /// <summary>Entity abbreviations.</summary>
        protected static readonly Hashtable N3Abbreviations;

        /// <summary>All non-reified, non-list statements, keyed by subject.</summary>
        private Lookup<Entity, Statement> m_StatementsBySubject = new Lookup<Entity, Statement>();
        /// <summary>All reified statements, keyed by formula ID.</summary>
        private Lookup<Entity, Statement> m_ReifiedStatementsById = new Lookup<Entity, Statement>();
        /// <summary>All list values, keyed by list ID.</summary>
        private Dictionary<Entity, Resource> m_ValuesByListId = new Dictionary<Entity, Resource>();
        /// <summary>All list tail IDs, keyed by list ID.</summary>
        private Dictionary<Entity, Entity> m_TailsByListId = new Dictionary<Entity, Entity>();

        /// <summary>
        /// Initializes the <see cref="N3Writer"/> class.
        /// </summary>
        static N3Writer()
        {
            N3Abbreviations = new Hashtable(TurtleAbbreviations);
            N3Abbreviations[Predicate.OwlSameAs.Uri] = "=";
            N3Abbreviations[Predicate.LogImplies.Uri] = "=>";
        }

        /// <summary>
        /// Gets the namespace abbreviations hashtable.
        /// </summary>
        /// <value></value>
        /// <returns>A hashtable of URI/abbreviation pairs.</returns>
        protected override Hashtable Abbreviations { get { return N3Abbreviations; } }

        /// <summary>
        /// Initializes a new <see cref="N3Writer"/> instance.
        /// </summary>
        /// <param name="writer">The writer.</param>
        public N3Writer(TextWriter writer) : base(writer) { }

        /// <summary>
        /// Initializes a new <see cref="N3Writer"/> instance.
        /// </summary>
        /// <param name="file">The file.</param>
        public N3Writer(string file) : this(GetWriter(file)) { }

        /// <summary>
        /// Adds the statement.
        /// </summary>
        /// <param name="statement">The statement (not a formula).</param>
        protected override void AddStatement(Statement statement)
        {
            Entity predicate = statement.Predicate;
            if (predicate == Predicate.RdfFirst && !m_ValuesByListId.ContainsKey(statement.Subject))
                m_ValuesByListId.Add(statement.Subject, statement.Object);
            else if (predicate == Predicate.RdfRest && !m_TailsByListId.ContainsKey(statement.Subject))
                m_TailsByListId.Add(statement.Subject, (Entity)statement.Object);
            else
                m_StatementsBySubject.Add(statement.Subject, statement);
        }

        /// <summary>
        /// Adds the statement of a formula.
        /// </summary>
        /// <param name="statement">The statement.</param>
        protected override void AddFormulaStatement(Statement statement)
        {
            m_ReifiedStatementsById.Add(statement.Meta, statement);
        }

        /// <summary>
        /// Removes the specified statement, marking it as written.
        /// </summary>
        /// <param name="statement">The statement.</param>
        protected void Remove(Statement statement)
        {
            m_StatementsBySubject.Remove(statement.Subject, statement);
            m_ReifiedStatementsById.Remove(statement.Meta, statement);
        }

        /// <summary>
        /// Closes N3 output.
        /// </summary>
        public override void Close()
        {
            WriteNamespaces();
            WriteStatements();

            base.Close();
        }

        /// <summary>
        /// Writes all statements to the output writer, grouped by subject.
        /// </summary>
        protected virtual void WriteStatements()
        {
            Queue<Entity> subjects = new Queue<Entity>(SortEntities(m_StatementsBySubject.Keys));
            while (subjects.Count > 0)
            {
                Entity subject = subjects.Peek();
                if (m_StatementsBySubject.Keys.Contains(subject))
                {
                    List<Statement> statements = new List<Statement>(m_StatementsBySubject[subject]);
                    statements.Sort(CompareStatementBodies);
                    foreach (Statement statement in statements)
                        WriteStatement(statement);
                }
                subjects.Dequeue();
            }
        }

        /// <summary>
        /// Compares the statement bodies for sorting.
        /// </summary>
        /// <param name="x">The first statement.</param>
        /// <param name="y">The second statement.</param>
        /// <returns>A number indicating the order of <paramref name="x"/> and <paramref name="y"/></returns>
        protected virtual int CompareStatementBodies(Statement x, Statement y)
        {
            int predicateComp = x.Predicate.CompareTo(y.Predicate);
            return predicateComp != 0 ? predicateComp : x.Object.CompareTo(y.Object);
        }

        /// <summary>
        /// Writes the bodies of the specified statements (sharing a subject) to the output writer.
        /// </summary>
        /// <param name="statements">The statements.</param>
        protected virtual void WriteStatementBodies(List<Statement> statements)
        {
            foreach (Statement statement in statements)
                WriteStatementBody(statement);
        }

        /// <summary>
        /// Writes the specified entity to the output writer.
        /// </summary>
        /// <param name="entity">The entity.</param>
        protected override void WriteEntity(Entity entity)
        {
            if (IsFormulaId(entity))
                WriteFormula(entity);
            else if (IsListId(entity))
                WriteList(entity);
            else
                base.WriteEntity(entity);
        }

        /// <summary>
        /// Writes the formula identified by the specified ID to the output writer.
        /// </summary>
        /// <param name="formulaId">The formula ID.</param>
        protected virtual void WriteFormula(Entity formulaId)
        {
            List<Statement> statements = new List<Statement>(m_ReifiedStatementsById[formulaId]);
			bool multipleStatements = statements.Count > 1;
			statements.Sort(CompareStatementBodies);

            Write('{');
            if (!multipleStatements)
            {
                WriteFormulaStatement(statements[0]);
            }
            else
            {
                foreach (Statement statement in statements)
                {
                    Write("\n ");
                    WriteFormulaStatement(statement);
                }
                Write('\n');
            }
            Write('}');
        }

        /// <summary>
        /// Writes the statement of a formula to the output writer.
        /// </summary>
        /// <param name="statement">The statement.</param>
        protected virtual void WriteFormulaStatement(Statement statement)
        {
            bool subjectIsFormula = IsFormulaId(statement.Subject);
            bool objectIsFormula = IsFormulaId(statement.Object);

            if (!subjectIsFormula)
            {
                WriteEntity(statement.Subject);
                Write(' ');
            }
            else
            {
                Write('\n');
                WriteFormula(statement.Subject);
                Write('\n');
            }

            WritePredicate(statement.Predicate);

            if (!objectIsFormula)
            {
                Write(' ');
                WriteResource(statement.Object);
                Write('.');
            }
            else
            {
                Write('\n');
                WriteFormula((Entity)statement.Object);
                Write(".\n");
            }
        }

        /// <summary>
        /// Writes the specified list to the output writer.
        /// </summary>
        /// <param name="listId">The list ID.</param>
        protected virtual void WriteList(Entity listId)
        {
            Write('(');
            while (listId != Identifier.RdfNil)
            {
                Resource item;
                if (m_ValuesByListId.TryGetValue(listId, out item) && item != Identifier.RdfNil)
                {
                    WriteResource(item);
                }

                Entity tail;
                Resource oldItem = item;
                if (m_TailsByListId.TryGetValue(listId, out tail))
                {
                    listId = m_TailsByListId[listId];
                    if (listId != Identifier.RdfNil)
                    {
                        if (IsFormulaId(oldItem))
                            Write('\n');
                        Write(' ');
                    }
                }
                else
                {
                    Write(' ');
                    WriteEntity(new BNode());
                    listId = Identifier.RdfNil;
                }
            }
            Write(')');
        }

        /// <summary>
        /// Determines whether the specified resource is the ID of a formula.
        /// </summary>
        /// <param name="node">The node.</param>
        /// <returns><c>true</c> if the resource is a formula ID; otherwise, <c>false</c>.</returns>
        protected bool IsFormulaId(Resource node)
        {
            return node is Entity && m_ReifiedStatementsById.Contains((Entity)node);
        }

        /// <summary>
        /// Determines whether the specified resource is the ID of a list.
        /// </summary>
        /// <param name="node">The node.</param>
        /// <returns><c>true</c> if the resource is a list ID; otherwise, <c>false</c>.</returns>
        protected bool IsListId(Resource node)
        {
            return node is Entity
                && (m_ValuesByListId.ContainsKey((Entity)node)
                 || m_TailsByListId.ContainsKey((Entity)node));
        }

        /// <summary>
        /// Returns the first element in the collection or the default value if the collection is empty.
        /// </summary>
        /// <typeparam name="T">Element type.</typeparam>
        /// <param name="items">The items.</param>
        /// <returns>The first element or the default value.</returns>
        protected T FirstOrDefault<T>(IEnumerable<T> items)
        {
            IEnumerator<T> enumerator = items.GetEnumerator();
            return enumerator.MoveNext() ? enumerator.Current : default(T);
        }

        /// <summary>
        /// Sorts the entities.
        /// </summary>
        /// <param name="items">The items.</param>
        /// <returns>A sorted list of entities.</returns>
        protected List<Entity> SortEntities(IEnumerable<Entity> items)
        {
            List<Entity> sortedItems = new List<Entity>(items);
            sortedItems.Sort(delegate(Entity x, Entity y)
            {
                if (x is BNode && !(y is BNode))
                    return 1;
                if (y is BNode && !(x is BNode))
                    return -1;
                return x.ToString().CompareTo(y.ToString());
            });
            return sortedItems;
        }

        /// <summary>
        /// Implements a multi-valued dictionary.
        /// </summary>
        /// <typeparam name="K">Key type.</typeparam>
        /// <typeparam name="V">Value type.</typeparam>
        protected sealed class Lookup<K, V>
        {
            /// <summary>Dictionary of items.</summary>
            private Dictionary<K, Dictionary<V, V>> m_Items;

            /// <summary>
            /// Gets the items with the specified key.
            /// </summary>
            /// <value>The items, or an empty collection if no item with the specified key exists.</value>
            public ICollection<V> this[K key] { get { return GetAll(key); } }

            /// <summary>
            /// Gets the keys of the dictionary.
            /// </summary>
            /// <value>The keys.</value>
            public ICollection<K> Keys { get { return m_Items.Keys; } }

            /// <summary>
            /// Gets a value indicating whether this collection is empty.
            /// </summary>
            /// <value><c>true</c> if this collection is empty; otherwise, <c>false</c>.</value>
            public bool IsEmpty { get { return m_Items.Count == 0; } }

            /// <summary>
            /// Initializes a new <see cref="Lookup&lt;K, V&gt;"/> instance.
            /// </summary>
            public Lookup()
            {
                m_Items = new Dictionary<K, Dictionary<V, V>>();
            }

            /// <summary>
            /// Determines whether the collection contains items with the specified key.
            /// </summary>
            /// <param name="key">The key.</param>
            /// <returns><c>true</c> if the key is present; otherwise, <c>false</c>.</returns>
            public bool Contains(K key)
            {
                return m_Items.ContainsKey(key);
            }

            /// <summary>
            /// Adds the specified value with the specified key.
            /// </summary>
            /// <param name="key">The key.</param>
            /// <param name="item">The item.</param>
            public void Add(K key, V item)
            {
                Dictionary<V, V> keyStatements;
                if (!m_Items.TryGetValue(key, out keyStatements))
                    m_Items[key] = keyStatements = new Dictionary<V, V>();
                if (!keyStatements.ContainsKey(item))
                    keyStatements.Add(item, item);
            }

            /// <summary>
            /// Removes the item with the specified key.
            /// </summary>
            /// <param name="key">The key.</param>
            /// <param name="statement">The statement.</param>
            public void Remove(K key, V statement)
            {
                Dictionary<V, V> keyStatements;
                if (m_Items.TryGetValue(key, out keyStatements))
                {
                    keyStatements.Remove(statement);
                    if (keyStatements.Count == 0)
                        m_Items.Remove(key);
                }
            }

            /// <summary>
            /// Gets all items with the specified key.
            /// </summary>
            /// <param name="key">The key.</param>
            /// <returns>The items.</returns>
            public ICollection<V> GetAll(K key)
            {
                Dictionary<V, V> keyStatements;
                return m_Items.TryGetValue(key, out keyStatements) ? keyStatements.Keys : (ICollection<V>)new V[0];
            }
        }
    }
}
#endif