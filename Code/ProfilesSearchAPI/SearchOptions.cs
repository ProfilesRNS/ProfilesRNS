using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Serialization;

namespace Search
{
	[Serializable]
	public class SearchOptions
	{
        // Sample xml query
		string xml = @"<SearchOptions>
						<MatchOptions>							
							<SearchFiltersList>
								<SearchFilter Property='http://xmlns.com/foaf/0.1/lastName' MatchType='Left'>Smit</SearchFilter>
							</SearchFiltersList>	
							<SearchString ExactMatch='false'>lung cancer genomics</SearchString>														
							<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>																				
						</MatchOptions>
						<OutputOptions>
							<Offset>0</Offset>
							<Limit>5</Limit>
							<SortByList>
								<SortBy IsDesc='1' Property='http://xmlns.com/foaf/0.1/firstName' />
								<SortBy IsDesc='0' Property='http://xmlns.com/foaf/0.1/lastName' />
							</SortByList>
						</OutputOptions>
					</SearchOptions>";

		[XmlElement]
		public MatchOptions MatchOptions { get; set; }
		
		[XmlElement]
		public OutputOptions OutputOptions { get; set; }
		
	}
	
	public class MatchOptions
	{
		[XmlElement]
		public SearchString SearchString { get; set; }
		
		[XmlElement]
		public ClassURI ClassURI { get; set; }

        [XmlElement]
        public ClassGroupURI ClassGroupURI { get; set; }

		[XmlArray]
		public List<SearchFilter> SearchFiltersList { get; set; }
	}

	public class OutputOptions
	{
		[XmlElement]
		public short Offset { get; set; }
		
		[XmlElement]
		public short Limit { get; set; }
		
		[XmlArray]
		public List<SortBy> SortByList { get; set; }
		
	}

	public class SearchString
	{
		[XmlText]
		public string Text { get; set; }

		[XmlAttribute]
		public bool ExactMatch { get; set; }
	}

	public class ClassURI
	{
		[XmlText]
		public string Text { get; set; }
	}

    public class ClassGroupURI
    {
        [XmlText]
        public string Text { get; set; }
    }

    
    public class SearchFilter
	{
		[XmlText]
		public string Text { get; set; }

		[XmlAttribute]
		public string Property { get; set; }

		[XmlAttribute]
		public string Property2 { get; set; }

		[XmlAttribute]
		public string Property3 { get; set; }

		[XmlAttribute]
		public string MatchType { get; set; }

		[XmlAttribute]
		public int IsExcluded { get; set; }
	}

	public class SortBy
	{
		[XmlAttribute]
		public int IsDesc { get; set; }

		[XmlAttribute]
		public string Property { get; set; }

		[XmlAttribute]
		public string Property2 { get; set; }
	}
}
