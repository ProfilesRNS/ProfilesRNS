using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.Xml.Serialization;

namespace Search
{

    /// <remarks/>
	/// [DataContract(Namespace = "", Name = "query-request")]
	//[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	//[System.SerializableAttribute()]
	//[System.Diagnostics.DebuggerStepThroughAttribute()]
	//[System.ComponentModel.DesignerCategoryAttribute("code")]
	//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2007/SPARQL/protocol-types#")]
	//[System.Xml.Serialization.XmlRootAttribute(ElementName = "query-request", Namespace = "http://www.w3.org/2007/SPARQL/protocol-types#", IsNullable = false)]		
	[Serializable]
	[XmlType(TypeName="query-request", Namespace="http://www.w3.org/2007/SPARQL/protocol-types#")]
    public partial class queryrequest : object, System.ComponentModel.INotifyPropertyChanged
    {

        private string queryField;

        private string[] defaultgraphuriField;

        private string[] namedgraphuriField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form = System.Xml.Schema.XmlSchemaForm.Unqualified)] 			
        public string query
        {
            get
            {
                return this.queryField;
            }
            set
            {
                this.queryField = value;
                this.RaisePropertyChanged("query");
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("default-graph-uri", Form = System.Xml.Schema.XmlSchemaForm.Unqualified, DataType = "anyURI")]		
        public string[] defaultgraphuri
        {
            get
            {
                return this.defaultgraphuriField;
            }
            set
            {
                this.defaultgraphuriField = value;
                this.RaisePropertyChanged("defaultgraphuri");
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("named-graph-uri", Form = System.Xml.Schema.XmlSchemaForm.Unqualified, DataType = "anyURI")]		
        public string[] namedgraphuri
        {
            get
            {
                return this.namedgraphuriField;
            }
            set
            {
                this.namedgraphuriField = value;
                this.RaisePropertyChanged("namedgraphuri");
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
	
    /// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	[System.SerializableAttribute()]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute("code")]
	[System.Xml.Serialization.XmlRootAttribute("query-result", Namespace = "http://www.w3.org/2007/SPARQL/protocol-types#", IsNullable = false)]
	[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2007/SPARQL/protocol-types#")]	
    public partial class queryresult : object, System.ComponentModel.INotifyPropertyChanged
    {

        private object itemField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("RDF", typeof(object), Namespace = "http://www.w3.org/1999/02/22-rdf-syntax-ns#")]
        [System.Xml.Serialization.XmlElementAttribute("sparql", typeof(sparql), Namespace = "http://www.w3.org/2007/SPARQL/results#")]
        public object Item
        {
            get
            {
                return this.itemField;
            }
            set
            {
                this.itemField = value;
                this.RaisePropertyChanged("Item");
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    /// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	[System.SerializableAttribute()]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute("code")]
	[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2007/SPARQL/results#", IncludeInSchema = false)]
	[System.Xml.Serialization.XmlRootAttribute("sparql", Namespace = "http://www.w3.org/2007/SPARQL/results#", IsNullable = false)] 
    public partial class sparql : object, System.ComponentModel.INotifyPropertyChanged
    {

        private head headField;

        private object itemField;

        /// <remarks/>
        public head head
        {
            get
            {
                return this.headField;
            }
            set
            {
                this.headField = value;
                this.RaisePropertyChanged("head");
            }
        }

        /// <remarks/>
		[System.Xml.Serialization.XmlElementAttribute("boolean", typeof(bool))]
		[System.Xml.Serialization.XmlElementAttribute("results", typeof(results))]
		public object Item
		{
			get
			{
				return this.itemField;
			}
			set
			{
				this.itemField = value;
				this.RaisePropertyChanged("Item");
			}
		}

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    /// <remarks/>
	/// [DataContract(Namespace = "", Name = "head")]
	//[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	//[System.SerializableAttribute()]
	//[System.Diagnostics.DebuggerStepThroughAttribute()]
	//[System.ComponentModel.DesignerCategoryAttribute("code")]
	//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2007/SPARQL/results#")]
    public partial class head : object, System.ComponentModel.INotifyPropertyChanged
    {

        private variableCollection variableField;

        private linkCollection linkField;

        /// <remarks/>
		[XmlElement]
        public variableCollection variable
        {
            get
            {
                return this.variableField;
            }
            set
            {
                this.variableField = value;
                this.RaisePropertyChanged("variable");
            }
        }

        /// <remarks/>
		[XmlElement]
        public linkCollection link
        {
            get
            {
                return this.linkField;
            }
            set
            {
                this.linkField = value;
                this.RaisePropertyChanged("link");
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    /// <remarks/>
	/// [DataContract(Namespace = "", Name = "variable")]
	//[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	//[System.SerializableAttribute()]
	//[System.Diagnostics.DebuggerStepThroughAttribute()]
	//[System.ComponentModel.DesignerCategoryAttribute("code")]
	//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2007/SPARQL/results#")]	
    public partial class variable : object, System.ComponentModel.INotifyPropertyChanged
    {

        private string nameField;

        /// <remarks/>		
		[XmlAttribute(AttributeName="name", DataType="NMTOKEN")]
        public string name
        {
            get
            {
                return this.nameField;
            }
            set
            {
                this.nameField = value;
                this.RaisePropertyChanged("name");
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    /// <remarks/>
	//[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	//[System.SerializableAttribute()]
	//[System.Diagnostics.DebuggerStepThroughAttribute()]
	//[System.ComponentModel.DesignerCategoryAttribute("code")]
	//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2007/SPARQL/results#")]
    public partial class link : object, System.ComponentModel.INotifyPropertyChanged
    {

        private string hrefField;

        /// <remarks/>
		[XmlAttribute(AttributeName = "href", DataType = "anyURI")]
        public string href
        {
            get
            {
                return this.hrefField;
            }
            set
            {
                this.hrefField = value;
                this.RaisePropertyChanged("href");
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    /// <remarks/>
	//[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	//[System.SerializableAttribute()]
	//[System.Diagnostics.DebuggerStepThroughAttribute()]
	//[System.ComponentModel.DesignerCategoryAttribute("code")]
	//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2007/SPARQL/results#")]
    public partial class results : object, System.ComponentModel.INotifyPropertyChanged
    {

        private resultCollection resultField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("result")]
        public resultCollection result
        {
            get
            {
                return this.resultField;
            }
            set
            {
                this.resultField = value;
                this.RaisePropertyChanged("result");
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    /// <remarks/>
	//[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	//[System.SerializableAttribute()]
	//[System.Diagnostics.DebuggerStepThroughAttribute()]
	//[System.ComponentModel.DesignerCategoryAttribute("code")]
	//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2007/SPARQL/results#")]
    public partial class result : object, System.ComponentModel.INotifyPropertyChanged
    {

        private bindingCollection bindingField;

        private string indexField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("binding")]		
        public bindingCollection binding
        {
            get
            {
                return this.bindingField;
            }
            set
            {
                this.bindingField = value;
                this.RaisePropertyChanged("binding");
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(DataType = "positiveInteger")]		
        public string index
        {
            get
            {
                return this.indexField;
            }
            set
            {
                this.indexField = value;
                this.RaisePropertyChanged("index");
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    /// <remarks/>
	//[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	//[System.SerializableAttribute()]
	//[System.Diagnostics.DebuggerStepThroughAttribute()]
	//[System.ComponentModel.DesignerCategoryAttribute("code")]
	//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2007/SPARQL/results#")]
    public partial class binding : object, System.ComponentModel.INotifyPropertyChanged
    {

        private object itemField;

        private ItemChoiceType itemElementNameField;

        private string nameField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("bnode", typeof(string))]
        [System.Xml.Serialization.XmlElementAttribute("literal", typeof(literal))]
        [System.Xml.Serialization.XmlElementAttribute("uri", typeof(string))]
        [System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemElementName")]		
        public object Item
        {
            get
            {
                return this.itemField;
            }
            set
            {
                this.itemField = value;
                this.RaisePropertyChanged("Item");
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public ItemChoiceType ItemElementName
        {
            get
            {
                return this.itemElementNameField;
            }
            set
            {
                this.itemElementNameField = value;
                this.RaisePropertyChanged("ItemElementName");
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(DataType = "NMTOKEN")]		
        public string name
        {
            get
            {
                return this.nameField;
            }
            set
            {
                this.nameField = value;
                this.RaisePropertyChanged("name");
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    /// <remarks/>
	//[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	//[System.SerializableAttribute()]
	//[System.Diagnostics.DebuggerStepThroughAttribute()]
	//[System.ComponentModel.DesignerCategoryAttribute("code")]
	//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2007/SPARQL/results#")]
    public partial class literal : object, System.ComponentModel.INotifyPropertyChanged
    {

        private string datatypeField;

        private string langField;

        private StringCollection textField;

        /// <remarks/>		
        [System.Xml.Serialization.XmlAttributeAttribute(DataType = "anyURI")]
        public string datatype
        {
            get
            {
                return this.datatypeField;
            }
            set
            {
                this.datatypeField = value;
                this.RaisePropertyChanged("datatype");
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(Form = System.Xml.Schema.XmlSchemaForm.Qualified, Namespace = "http://www.w3.org/XML/1998/namespace")]		
        public string lang
        {
            get
            {
                return this.langField;
            }
            set
            {
                this.langField = value;
                this.RaisePropertyChanged("lang");
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]		
        public StringCollection Text
        {
            get
            {
                return this.textField;
            }
            set
            {
                this.textField = value;
                this.RaisePropertyChanged("Text");
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    /// <remarks/>
	//[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	//[System.SerializableAttribute()]
	//[System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://www.w3.org/2007/SPARQL/results#", IncludeInSchema = false)]
    public enum ItemChoiceType
    {

        /// <remarks/>
        bnode,

        /// <remarks/>
        literal,

        /// <remarks/>
        uri,
    }

    /// <remarks/>
	//[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	//[System.SerializableAttribute()]
	//[System.Diagnostics.DebuggerStepThroughAttribute()]
	//[System.ComponentModel.DesignerCategoryAttribute("code")]
	//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2007/SPARQL/protocol-types#")]
	//[System.Xml.Serialization.XmlRootAttribute("malformed-query", Namespace = "http://www.w3.org/2007/SPARQL/protocol-types#", IsNullable = false)]
	[Serializable]
	[XmlType(TypeName = "malformed-query")]
    public partial class malformedquery : object, System.ComponentModel.INotifyPropertyChanged
    {

        private string faultdetailsField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("fault-details")]
        public string faultdetails
        {
            get
            {
                return this.faultdetailsField;
            }
            set
            {
                this.faultdetailsField = value;
                this.RaisePropertyChanged("faultdetails");
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    /// <remarks/>
	//[System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927")]
	//[System.SerializableAttribute()]
	//[System.Diagnostics.DebuggerStepThroughAttribute()]
	//[System.ComponentModel.DesignerCategoryAttribute("code")]
	//[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2007/SPARQL/protocol-types#")]
	//[System.Xml.Serialization.XmlRootAttribute("query-request-refused", Namespace = "http://www.w3.org/2007/SPARQL/protocol-types#", IsNullable = false)]
	public partial class queryrequestrefused : object, System.ComponentModel.INotifyPropertyChanged
    {

        private string faultdetailsField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("fault-details")]
        public string faultdetails
        {
            get
            {
                return this.faultdetailsField;
            }
            set
            {
                this.faultdetailsField = value;
                this.RaisePropertyChanged("faultdetails");
            }
        }

        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null))
            {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }

    public class StringCollection : System.Collections.ObjectModel.Collection<string>
    {
    }

    public class variableCollection : System.Collections.ObjectModel.Collection<variable>
    {
    }

    public class linkCollection : System.Collections.ObjectModel.Collection<link>
    {
    }

    public class resultCollection : System.Collections.ObjectModel.Collection<result>
    {
    }

    public class bindingCollection : System.Collections.ObjectModel.Collection<binding>
    {
    }
}
