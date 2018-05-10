using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Profiles.Framework.Utilities;
using System.Web.UI;

namespace Profiles.ORNG.Utilities
{
    public abstract class ORNGRPCService
    {
        private static readonly string KEY_PREFIX = "ORNG.ORNGRPCService :";

        private static List<WeakReference> managers = new List<WeakReference>();

        private OpenSocialManager om;

        public ORNGRPCService(string uri, Page page, bool editMode)
        {
            this.om = OpenSocialManager.GetOpenSocialManager(uri, page, false);
            // Add to Session so that it does not get prematurely garbage collected
            HttpContext.Current.Session[KEY_PREFIX + ":" + om.GetGuid().ToString()] = this;
            managers.Add(new WeakReference(this));
        }

        public OpenSocialManager GetOpenSocialManager()
        {
            return this.om;
        }

        public static ORNGRPCService GetRPCService(Guid guid)
        {
            DebugLogging.Log("ORNGRPCService guid :" + guid);
            ORNGRPCService retval = null;
            foreach (WeakReference wr in managers.ToArray<WeakReference>())
            {
                if (wr.Target == null)
                {
                    DebugLogging.Log("ORNGRPCService removing WeakReference :" + wr);
                    managers.Remove(wr);
                }
                else if (guid.Equals(((ORNGRPCService)wr.Target).om.GetGuid()))
                {
                    retval = wr.Target as ORNGRPCService;
                }
            }
            return retval;
        }

        public abstract string call(string request);
    }

}