using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.Framework.Utilities
{
	public static class StringExtensions
	{
	
		public static bool IsNullOrEmpty(this string s)
		{
			return String.IsNullOrEmpty(s);		
		}
	}
}
