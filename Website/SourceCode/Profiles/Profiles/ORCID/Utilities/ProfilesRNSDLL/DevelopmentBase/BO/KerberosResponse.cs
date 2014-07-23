using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.BO
{
    public class KerberosResponse : LoginCredentials
    {
        public override string BUID
        {
            get
            {
                if (ResponseBO != null)
                {
                    return ResponseBO.getId();
                }
                else
                {
                    return "";
                }
            }
        }
        public override string Alias
        {
            get
            {
                if (ResponseBO != null)
                {
                    return ResponseBO.getAlias();
                }
                else
                {
                    return "";
                }
            }
        }
        public override string Email
        {
            get
            {
                if (ResponseBO != null)
                {
                    return ResponseBO.getEmail();
                }
                else
                {
                    return "";
                }
            }
        }
        public override string Name
        {
            get
            {
                if (ResponseBO != null)
                {
                    return ResponseBO.getName();
                }
                else
                {
                    return "";
                }
            }
        }
        public override string Message
        {
            get
            {
                if (ResponseBO != null)
                {
                    return ResponseBO.getMessage();
                }
                else
                {
                    return "";
                }
            }
        }

        public override string XMLResponse
        {
            get
            {
                if (ResponseBO != null)
                {
                    return ResponseBO.getXml();
                }
                else
                {
                    return "";
                }
            }
        }
        private bool _issuccessful = false;
        public override bool IsSuccessful
        {
            get
            {
                return _issuccessful;
            }
        }

        public edu.bu.uis.XmlGateway.Connector.BuResponse ResponseBO { get; private set; }

        public KerberosResponse()
        {
            _issuccessful = false;
            FailureMsg = "";
        }
        public KerberosResponse(edu.bu.uis.XmlGateway.Connector.BuResponse response, bool success)
        {
            ResponseBO = response;
            _issuccessful = success;
            FailureMsg = "";
        }
    }
}
