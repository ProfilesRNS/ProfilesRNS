/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Xml;
using Profiles.Framework.Utilities;
namespace Profiles.Activity.Modules.LatestUpdates
{
    public partial class LatestUpdates : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }
        public LatestUpdates() { }
        public LatestUpdates(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {


        }
        private void DrawProfilesModule()
        {
            Statistics.DrawProfilesModule();
            List<ModuleParams> mp = new List<ModuleParams>();
            //          <Param Name="Show">3</Param>
            //<Param Name="SeeMore">True</Param>
            
            string showXmlContent = "<Param Name=\"Show\">2</Param>";
            XmlDocument showDoc = new XmlDocument();
            showDoc.LoadXml(showXmlContent);
            XmlNode showNode = showDoc.DocumentElement;
            mp.Add(new ModuleParams(showNode));

            string seemoreXmlContent = "<Param Name=\"SeeMore\">True</Param>";
            XmlDocument seemoreDoc = new XmlDocument();
            seemoreDoc.LoadXml(seemoreXmlContent);
            XmlNode seemoreNode = seemoreDoc.DocumentElement;
            mp.Add(new ModuleParams(seemoreNode));

            ActivityHistory.setModuleParams(mp);
            ActivityHistory.DrawProfilesModule();
            //Profiles.Framework.Utilities.Module module;
            //module = new Profiles.Framework.Utilities.Module("~/About/Modules/Statistics/Statistics.ascx", "Statistics", null, "");
            //PlaceHolder placeholder = null;
            //placeholder = phStatistics;
            //phStatistics.Controls.Add(mp.LoadControl(module.Path, this, this.RDFData, module.ParamList, this.RDFNamespaces));
        }

    }





}