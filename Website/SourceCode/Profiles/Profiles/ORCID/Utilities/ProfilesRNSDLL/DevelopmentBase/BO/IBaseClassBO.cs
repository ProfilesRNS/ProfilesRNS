using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.BO
{
    public interface IBaseClassBO
    {
        int TableId { get; }
        string TableSchemaName { get; }
        bool Exists { get; set; }
        bool HasError { get; set; }
        string Error { get; set; }
        string Message { get; set; }
        string IdentityValue { get; set; }
        bool IdentityIsNull { get; set; }
        string Tablename { get; }
    }
}
