using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.ORNG.Utilities
{

    public class PreparedGadget : IComparable<PreparedGadget>
    {
        private GadgetSpec gadgetSpec;
        private OpenSocialManager openSocialManager;
        private int moduleId;
        private string securityToken;

        public PreparedGadget(GadgetSpec gadgetSpec, OpenSocialManager openSocialManager, int moduleId, string securityToken)
        {
            this.gadgetSpec = gadgetSpec;
            this.openSocialManager = openSocialManager;
            this.moduleId = moduleId;
            this.securityToken = securityToken;
        }

        public int CompareTo(PreparedGadget other)
        {
            GadgetViewRequirements gvr1 = this.GetGadgetViewRequirements();
            GadgetViewRequirements gvr2 = other.GetGadgetViewRequirements();
            return ("" + this.GetView() + (gvr1 != null ? 1000 + gvr1.GetDisplayOrder() : Int32.MaxValue)).CompareTo("" + other.GetView() + (gvr2 != null ? 1000 + gvr2.GetDisplayOrder() : Int32.MaxValue));
        }

        public GadgetSpec GetGadgetSpec()
        {
            return gadgetSpec;
        }

        public String GetSecurityToken()
        {
            return securityToken;
        }

        public int GetAppId()
        {
            return gadgetSpec.GetAppId();
        }

        public string GetName()
        {
            return gadgetSpec.GetName();
        }

        public int GetModuleId()
        {
            return moduleId;
        }

        public String GetGadgetURL()
        {
            return gadgetSpec.GetGadgetURL();
        }

        GadgetViewRequirements GetGadgetViewRequirements()
        {
            return gadgetSpec.GetGadgetViewRequirements(openSocialManager.GetPageName());
        }

        public String GetView()
        {
            GadgetViewRequirements reqs = GetGadgetViewRequirements();
            if (reqs != null)
            {
                return reqs.GetView();
            }
            // default behavior that will get invoked when there is no reqs.  Useful for sandbox gadgets
            else if (openSocialManager.GetPageName().Equals("edit/default.aspx"))
            {
                return "home";
            }
            else if (openSocialManager.GetPageName().Equals("profile/display.aspx"))
            {
                return "profile";
            }
            else if (openSocialManager.GetPageName().Equals("orng/gadgetdetails.aspx"))
            {
                return "canvas";
            }
            else if (gadgetSpec.GetGadgetURL().Contains("Tool"))
            {
                return "small";
            }
            else
            {
                return null;
            }
        }

        public string GetOptParams()
        {
            GadgetViewRequirements reqs = GetGadgetViewRequirements();
            return reqs != null ? reqs.GetOptParams() : "{}";
        }

        public string GetChromeId()
        {
            GadgetViewRequirements reqs = GetGadgetViewRequirements();
            if (reqs != null)
            {
                return reqs.GetChromeId();
            }
            // default behavior that will get invoked when there is no reqs.  Useful for sandbox gadgets
            else if (gadgetSpec.GetGadgetURL().Contains("Tool"))
            {
                return "gadgets-tools";
            }
            else if (openSocialManager.GetPageName().Equals("edit/default.aspx"))
            {
                return "gadgets-edit";
            }
            else if (openSocialManager.GetPageName().Equals("profile/display.aspx"))
            {
                return "gadgets-view";
            }
            else if (openSocialManager.GetPageName().Equals("orng/gadgetdetails.aspx"))
            {
                return "gadgets-detail";
            }
            else if (openSocialManager.GetPageName().Equals("search/default.aspx"))
            {
                return "gadgets-search";
            }
            else
            {
                return null;
            }
        }

        public string Name
        {
            get { return gadgetSpec.GetName(); }
        }

        public string CanvasURL
        {
            get { return "~/orng/gadgetdetails.aspx?appId=" + GetAppId() + "&Person=" + HttpUtility.UrlEncode(openSocialManager.ownerId); }
        }

        public int AppId
        {
            get { return GetAppId(); }
        }

        public int ModuleId
        {
            get { return GetModuleId(); }
        }

    }

}