using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.RDF
{
    public partial class Triple
    {
        internal System.Data.DataView GetPublications(Int64 subject)
        {
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].GetPublications");
            AddParam(ref cmd, "@Subject", subject);
            return FillTable(cmd).DefaultView; 
        }
        internal BO.ORCID.Narrative GetNarrative(Int64 subject)
        {
            BO.ORCID.Narrative narrative = new BO.ORCID.Narrative();

            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].GetNarrative");
            AddParam(ref cmd, "@Subject", subject);
            System.Data.DataTable dt = FillTable(cmd);

            if (dt.Rows.Count == 0 || dt.Rows[0].IsNull("Overview"))
            {
                narrative.Overview = string.Empty;
            }
            else
            {
                narrative.Overview = dt.Rows[0]["Overview"].ToString();
            }       

            // ORCID only accepts Public for this field.  If the security group implies anything but ORCID public, default to excluding the overview.
            if (dt.Rows.Count == 0 || dt.Rows[0].IsNull("DefaultORCIDDecisionID") || !dt.Rows[0]["DefaultORCIDDecisionID"].ToString().Equals(((int)BO.ORCID.REFDecision.REFDecisions.Public).ToString()))
            {
                narrative.Decision = new DAL.ORCID.REFDecision().Get((int)BO.ORCID.REFDecision.REFDecisions.Exclude);
            }
            else
            {
                narrative.Decision = new DAL.ORCID.REFDecision().Get((int)BO.ORCID.REFDecision.REFDecisions.Public);
            }
                 
            return narrative;
        }
    }
}