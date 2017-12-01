using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace DeploymentManager_GUI.CustomConfig
{
    class EnvironmentCollectionSection : ConfigurationSection
    {
        [ConfigurationProperty("environmentCollection", IsDefaultCollection = true, IsKey = false, IsRequired = true)]
        public EnvironmentCollection Members
        {
            get
            {
                return base["environmentCollection"] as EnvironmentCollection;

            }
            set
            {
                base["environmentCollection"] = value;
            }
        }

        [ConfigurationProperty("appServerCollection", IsDefaultCollection = true, IsKey = false, IsRequired = true)]
        public AppServerCollection AppServerMembers
        {
            get
            {
                return base["appServerCollection"] as AppServerCollection;

            }
            set
            {
                base["appServerCollection"] = value;
            }
        }
    }
}
