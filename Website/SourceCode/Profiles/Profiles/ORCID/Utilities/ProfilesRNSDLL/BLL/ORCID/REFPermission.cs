using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class REFPermission
    {
        public new BO.ORCID.REFPermission Get(int permissionID)
        {
            return base.Get(permissionID);
        }
        internal static int GetPermissionID(string permissionScope)
        {
            ProfilesRNSDLL.BO.ORCID.REFPermission permission =
                new ProfilesRNSDLL.BLL.ORCID.REFPermission().GetByPermissionScope(permissionScope);
            if (permission.Exists)
            {
                return permission.PermissionID;
            }
            else
            {
                throw new NotImplementedException("The specified scope (" + permissionScope + ") is unexpected.");
            }
        }
    }
}
