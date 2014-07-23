using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.BO.Elements
{
    public class StringField : FieldBase<string>
    {
        public override void SetValue(string value)
        {
            IsNull = value.Trim().Equals(string.Empty);
            Value = value.Trim();
        }
    }
}
