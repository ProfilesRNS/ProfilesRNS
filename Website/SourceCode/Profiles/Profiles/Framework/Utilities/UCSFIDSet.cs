using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.Framework.Utilities
{

    public class UCSFIDSet
    {
        public static Dictionary<Int64, UCSFIDSet> ByPersonId = new Dictionary<Int64, UCSFIDSet>();
        public static Dictionary<Int64, UCSFIDSet> ByNodeId = new Dictionary<Int64, UCSFIDSet>();
        public static Dictionary<string, UCSFIDSet> ByEmployeeID = new Dictionary<string, UCSFIDSet>();
        public static Dictionary<string, UCSFIDSet> ByPrettyURL = new Dictionary<string, UCSFIDSet>();
        public static Dictionary<string, UCSFIDSet> ByFNO = new Dictionary<string, UCSFIDSet>();

        public Int64 PersonId { get; set; }
        public Int64 NodeId { get; set; }
        public string EmployeeID { get; set; }
        public string PrettyURL { get; set; }
        public string FNO { get; set; }

        public UCSFIDSet(Int64 PersonId, Int64 NodeId, string EmployeeID, string PrettyURL, string FNO)
        {
            this.PersonId = PersonId;
            this.NodeId = NodeId;
            this.EmployeeID = EmployeeID;
            this.PrettyURL = PrettyURL.ToLower();
            this.FNO = FNO.ToLower();

            ByPersonId[this.PersonId] = this;
            ByNodeId[this.NodeId] = this;
            ByEmployeeID[this.EmployeeID] = this;
            ByPrettyURL[this.PrettyURL] = this;
            ByFNO[this.FNO] = this;
        }
    }
}