using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.ORNG.Utilities
{
    public class GadgetViewRequirements
    {
        private string page;
        private string view;
        private string chromeId;
        private string visibility;
        private string optParams;
        private Int32 display_order;

        public GadgetViewRequirements(string page, string view, string chromeId, string visibility, Int32 display_order, String optParams)
        {
            this.page = page;
            this.view = view;
            this.chromeId = chromeId;
            this.visibility = visibility;
            this.display_order = display_order;
            this.optParams = optParams;
        }

        public string GetVisiblity()
        {
            return visibility;
        }

        public string GetView()
        {
            return view;
        }

        public string GetChromeId()
        {
            return chromeId;
        }

        public string GetOptParams()
        {
            return optParams != null && optParams.Trim().Length > 0 ? optParams : "{}";
        }

        internal Int32 GetDisplayOrder()
        {
            return display_order;
        }
    }
}