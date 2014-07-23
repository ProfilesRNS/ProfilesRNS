using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL
{
    public abstract class DALGeneric<BO> : DevelopmentBase.DALTemplate<BO> where BO : DevelopmentBase.BaseClassBO
    {

        internal const int SUPER_USER = 1;

        public DALGeneric()
            : base()
        {

        }

        protected override string ConnectionStringEdit
        {
            get
            {
                return System.Configuration.ConfigurationManager.ConnectionStrings["ProfilesDB"].ToString();
            }
        }
        protected override string ConnectionStringQuery
        {
            get
            {
                return System.Configuration.ConfigurationManager.ConnectionStrings["ProfilesDB"].ToString();
            }
        }
        protected override string ProviderName
        {
            get
            {
                return "System.Data.SqlClient";
            }
        }

        protected override BO GetBOBefore(BO bo)
        {
            throw new NotImplementedException();
        }

        //public override bool HasRequiredRole(DevelopmentBase.BaseClassBO.ProjectRoles RequiredRole)
        //{
        //    if (base.HasRequiredRole(DevelopmentBase.BaseClassBO.ProjectRoles.BUMC_Project_Super_User))
        //    {
        //        return true;
        //    }
        //    return base.HasRequiredRole(RequiredRole);
        //}
        //public override bool IsUserInAnyRole(List<DevelopmentBase.BaseClassBO.ProjectRoles> RequiredRoles)
        //{
        //    if (base.HasRequiredRole(DevelopmentBase.BaseClassBO.ProjectRoles.BUMC_Project_Super_User))
        //    {
        //        return true;
        //    }
        //    return base.IsUserInAnyRole(RequiredRoles);
        //}
    }
}