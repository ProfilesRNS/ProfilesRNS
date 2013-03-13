using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.Edit.Utilities
{

    public class AwardState
    {

        public AwardState(string subjecturi,Int64 predicate,Int64 _object, string startdate, string enddate
            , string institution, string name,bool editexisting,bool editdelete)
        {
            this.SubjectURI = subjecturi;
            this.Predicate = predicate;
            this.Object = _object;
            this.StartDate = startdate;
            this.EndDate = enddate;
            this.Institution = institution;
            this.Name = name;
            this.EditExisting = editexisting;        
            this.EditDelete = editdelete;
        }


        public string SubjectURI { get; set; }
        public Int64 Predicate { get; set; }
        public Int64 Object { get; set; }

        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Institution { get; set; }
        public string Name { get; set; }

        public bool EditExisting { get; set; }
        
        public bool EditDelete { get; set; }


    }
}
