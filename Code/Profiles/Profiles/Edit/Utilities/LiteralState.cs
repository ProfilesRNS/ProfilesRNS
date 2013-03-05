using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.Edit.Utilities
{
    public class LiteralState
    {

        public LiteralState(Int64 subject, Int64 predicate, Int64 _object,
            string literal, bool editexisting, bool editdelete)
        {
            this.Literal = literal;
            this.Subject = subject;
            this.Predicate = predicate;
            this.Object = _object;
            this.EditDelete = editdelete;
            this.EditExisting = editexisting;
        }

        public Int64 Subject { get; set; }
        public Int64 Predicate { get; set; }
        public Int64 Object { get; set; }
        public string Literal { get; set; }

        public bool EditExisting { get; set; }
        public bool EditDelete { get; set; }

    }



}
