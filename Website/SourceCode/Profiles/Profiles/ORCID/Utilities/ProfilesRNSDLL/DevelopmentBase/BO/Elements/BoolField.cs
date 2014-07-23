using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.BO.Elements
{
    public class BoolField : FieldBase<bool>
    {
        public override void SetValue(string value)
        {
            switch (value.ToLower())
            { 
                case "true":
                case "y":
                case "1":
                    Value = true;
                    break;
                default:
                    Value = false;
                    break;
            }
        }
    }
}
