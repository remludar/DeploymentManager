using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace DeploymentManager_GUI.CustomConfig
{
    public class RAMQServer : ConfigurationElement
    {
        [ConfigurationProperty("name", IsKey = true)]
        public string Name { get { return (string)this["name"]; } }
    }
}
