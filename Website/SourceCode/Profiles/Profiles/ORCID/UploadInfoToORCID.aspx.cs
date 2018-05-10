/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/

using System;

namespace Profiles.ORCID
{
    public partial class UploadInfoToORCID : Profiles.ORCID.Utilities.ProfileData
    {
        public override string PathToPresentationXMLFile
        {
            get { return AppDomain.CurrentDomain.BaseDirectory + "/ORCID/PresentationXML/UploadInfoToORCIDPresentation.xml"; }
        }
        public void Page_Init(object sender, EventArgs e)
        {
            base.Initialize();
            UploadInfoToORCID1.Initialize(base.RDFData, base.RDFNamespaces, base.RDFTriple);
        }

        protected void btnSubmitToORCID_Click(object sender, EventArgs e)
        {
            try
            {
                if (UploadInfoToORCID1.ResearchExpertiseAndProfessionalInterests.Length > 5000)
                {
                    UploadInfoToORCID1.ResearchExpertiseAndProfessionalInterestsErrors += "Error! Biography cannot be longer then 5000 characters";
                    return;
                }
                Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person person = UploadInfoToORCID1.GetPersonWithPageData();
                Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.PersonMessage personMessageBLL = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.PersonMessage();
                personMessageBLL.CreateUploadMessages(person, LoggedInInternalUsername);
            }
            catch (Exception ex)
            {
                lblErrorsUpload.Text = ex.Message;
                LogException(ex);
            }
            Response.Redirect("~/ORCID/Default.aspx", true);
        }
        private void AddError(string errorMessage)
        {
            lblErrorsUpload.Text = errorMessage;
        }
        private void LogException(Exception ex)
        {
            if (ex.GetType().IsSubclassOf(typeof(Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.BO.ExceptionSafeToDisplay)) || ex.GetType().IsSubclassOf(typeof(Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.BO.ExceptionSafeToDisplay)))
            {
                AddError(ex.Message);
            }
            else
            {
                AddError("An unexpected error occurred.  Please contact the help desk for assistance.");
            }
            LogExceptionOnly(ex);
        }
        private void LogExceptionOnly(Exception ex)
        {
            Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.ErrorLog.LogError(ex, LoggedInInternalUsername);
        }
    }
}