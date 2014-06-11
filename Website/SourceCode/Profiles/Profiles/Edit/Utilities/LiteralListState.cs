using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.Edit.Utilities
{
    public class LiteralListState
    {

        public LiteralListState(string _objects, string literal, bool editexisting, bool editdelete)
        {
            this.Literal = literal;
            this.Objects = _objects;
            this.EditDelete = editdelete;
            this.EditExisting = editexisting;
        }

        public string Objects { get; set; }
        public string Literal { get; set; }

        public bool EditExisting { get; set; }
        public bool EditDelete { get; set; }

    }



}
