using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.BO.Elements
{
    [DefaultProperty("Value")]
    public abstract class FieldBase<T>
    {
        T _value = default(T);
        public T Value
        {
            get { return _value; }
            set { _value = value; IsNull = false; }
        }
        public bool IsNull { get; set; }
        public string Errors { get; set; }
        public string Messages { get; set; }
        public abstract void SetValue(string value);
    }
}
