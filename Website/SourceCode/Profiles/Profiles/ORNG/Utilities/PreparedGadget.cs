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
        private string securityToken;
        private string view;
        private string optParams;
        private string chromeId;
        private bool personalGadget = false;

        public PreparedGadget(GadgetSpec gadgetSpec, OpenSocialManager openSocialManager, string securityToken)
        {
            this.gadgetSpec = gadgetSpec;
            this.openSocialManager = openSocialManager;
            this.securityToken = securityToken;
            this.view = null;
            this.optParams = null;
        }

        // OntologyGadgets
        public PreparedGadget(GadgetSpec gadgetSpec, OpenSocialManager openSocialManager, string securityToken, string view, string optParams, string chromeId)
        {
            this.gadgetSpec = gadgetSpec;
            this.openSocialManager = openSocialManager;
            this.securityToken = securityToken;
            this.view = view;
            this.optParams = optParams == null || optParams == string.Empty ? "{}" : optParams;
            this.chromeId = chromeId;
            personalGadget = true;
        }


        // temp hack,
        public bool GetRegisteredVisibility()
        {
            return personalGadget || GetGadgetSpec().HasRegisteredVisibility();
        }

        public int CompareTo(PreparedGadget other)
        {
            GadgetViewRequirements gvr1 = this.GetGadgetViewRequirements();
            GadgetViewRequirements gvr2 = other.GetGadgetViewRequirements();
            return ("" + this.GetChromeId() + (gvr1 != null ? 1000 + gvr1.GetDisplayOrder() : Int32.MaxValue)).CompareTo("" + other.GetChromeId() + (gvr2 != null ? 1000 + gvr2.GetDisplayOrder() : Int32.MaxValue));
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
            if (view != null)
            {
                return view;
            }
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
            if (optParams != null)
            {
                return optParams;
            }
            GadgetViewRequirements reqs = GetGadgetViewRequirements();
            return reqs != null ? reqs.GetOptParams() : "{}";
        }

        public string GetChromeId()
        {
            if (chromeId != null)
            {
                return chromeId;
            }
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

    }

}