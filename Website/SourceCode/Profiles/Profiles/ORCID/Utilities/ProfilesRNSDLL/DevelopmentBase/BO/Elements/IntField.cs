using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.BO.Elements
{
    [DefaultProperty("Value")]
    public class IntField : FieldBase<int>
    {
        public override void SetValue(string value)
        {
            try
            {
                Value = int.Parse(value);
            }
            catch
            {
                IsNull = true;
                Errors += "The value that you enetered is not an integer.";
            }
        }
    }
}
