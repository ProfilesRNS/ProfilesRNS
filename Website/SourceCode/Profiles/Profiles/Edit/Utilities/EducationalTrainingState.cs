using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.Edit.Utilities
{

    public class EducationalTrainingState
    {

        public EducationalTrainingState(string subjecturi, Int64 predicate, Int64 _object, string school, string enddate
            , string institution, string degree,bool editexisting,bool editdelete)
        {
            this.SubjectURI = subjecturi;
            this.Predicate = predicate;
            this.Object = _object;
            this.School = school;
            this.EndDate = enddate;
            this.Institution = institution;
            this.Degree = degree;
            this.EditExisting = editexisting;        
            this.EditDelete = editdelete;
        }


        public string SubjectURI { get; set; }
        public Int64 Predicate { get; set; }
        public Int64 Object { get; set; }

        public string School { get; set; }
        public string EndDate { get; set; }
        public string Institution { get; set; }
        public string Degree { get; set; }

        public bool EditExisting { get; set; }
        
        public bool EditDelete { get; set; }


    }
}
