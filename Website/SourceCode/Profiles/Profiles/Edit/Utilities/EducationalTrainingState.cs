using System;

namespace Profiles.Edit.Utilities
{

    public class EducationalTrainingState
    {

        public EducationalTrainingState(string subjecturi, Int64 predicate, Int64 _object, string institution, string location
            , string degree, string enddate, string fieldofstudy, bool editexisting,bool editdelete)
        {
            this.SubjectURI = subjecturi;
            this.Predicate = predicate;
            this.Object = _object;
            this.Institution = institution;
            this.Location = location;
            this.Degree = degree;
            this.EndDate = enddate;
            this.FieldOfStudy = fieldofstudy;
            this.EditExisting = editexisting;        
            this.EditDelete = editdelete;
        }


        public string SubjectURI { get; set; }
        public Int64 Predicate { get; set; }
        public Int64 Object { get; set; }

        public string Institution { get; set; }
        public string Location { get; set; }
        public string Degree { get; set; }
        public string EndDate { get; set; }
        public string FieldOfStudy { get; set; }

        public bool EditExisting { get; set; }
        
        public bool EditDelete { get; set; }


    }
}
