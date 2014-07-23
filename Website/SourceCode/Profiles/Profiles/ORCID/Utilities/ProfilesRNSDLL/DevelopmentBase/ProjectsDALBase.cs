using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public class ProjectsDALBase : DevelopmentBase.DALBase
    {

        protected static string MyConnectionStringQuery = "Data Source=SQL;Initial Catalog=BUMC_Project;User ID=BUMC_Project_DAL;Password=kvcC0TjbUmQCruow;Max Pool Size=10000;Connection Timeout=120";
        protected static string MyConnectionStringEdit = "Data Source=SQL;Initial Catalog=BUMC_Project;User ID=BUMC_Project_DAL;Password=kvcC0TjbUmQCruow;Max Pool Size=10000;Connection Timeout=120";
        protected static string MyProviderName = "System.Data.SqlClient";

        protected override string ConnectionStringQuery
        {
            get { return MyConnectionStringQuery; }
        }
        protected override string ConnectionStringEdit
        {
            get { return MyConnectionStringEdit; }
        }
        protected override string ProviderName
        {
            get { return MyProviderName; }
        }

        //public SFSDLL.BO.User user { get; private set; }
        public List<DbCommand> dbCommands { get; set; }
    }
}
