using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace DeploymentManager_GUI.CustomConfig
{
    public class Environment : ConfigurationElement
    {
        [ConfigurationProperty("name", IsKey = true)]
        public string Name { get { return (string)this["name"];} }

        [ConfigurationProperty("appServerCollection")]
        public AppServerCollection AppServers { get { return this["appServerCollection"] as AppServerCollection; } }

        [ConfigurationProperty("smServerCollection")]
        public SMServerCollection SMServers { get { return this["smServerCollection"] as SMServerCollection; } }

        [ConfigurationProperty("ramqServerCollection")]
        public RAMQServerCollection RAMQServers { get { return this["ramqServerCollection"] as RAMQServerCollection; } }

        [ConfigurationProperty("virtualDirectory")]
        public VirtualDirectory VirtualDirectory { get { return this["virtualDirectory"] as VirtualDirectory; } }

        [ConfigurationProperty("dbServer")]
        public DBServer DBServer { get { return this["dbServer"] as DBServer; } }

        [ConfigurationProperty("database")]
        public DBName DBName { get { return this["database"] as DBName; } }

        
    }


}
