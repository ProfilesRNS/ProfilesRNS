using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.Activity.Utilities
{


    public class Activity : IComparable<Activity>
    {
        public Int64 Id { get; set; }

        /// <summary>
        /// Who created the activity
        /// </summary>
        public string CreatedById { get; set; }

        public Profile Profile { get; set; }

        /// <summary>
        /// Simple TimeStamp 
        /// </summary>
        public DateTime CreatedDT { get; set; }

        public string Date
        {
            get { return String.Format("{0:MMMM d, yyyy}", CreatedDT); }
            set { }
        }

        public string Message { get; set; }

        public string LinkUrl { get; set; }

        public string Title { get; set; }

        public int CompareTo(Activity o)
        {
            return o.Id.CompareTo(this.Id);
        }

    }

    public class Profile
    {
        public string Name { get; set; }

        public long NodeID { get; set; }

        public int PersonId { get; set; }

        public string URL { get; set; }

        public string Thumbnail { get; set; }
    }

    public class ReverseComparer : IComparer<Int64>
    {
        public int Compare(Int64 x, Int64 y)
        {
            return y.CompareTo(x);
        }
    }
}
