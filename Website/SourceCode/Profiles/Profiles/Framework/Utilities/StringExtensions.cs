using System;

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
