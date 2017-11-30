using System;
using System.Configuration;

namespace DeploymentManager
{
    class CustomConfiguration : ConfigurationSection
    {
        public class ConnectionManagerDataSection : ConfigurationSection
        {
            // The name of this section in the app.config.
            public const string SectionName = "EnvironmentManagerDataSection";

            private const string EnvironmentCollectionName = "Environments";

            [ConfigurationProperty(EnvironmentCollectionName)]
            [ConfigurationCollection(typeof(ConnectionManagerEnvironmentsCollection), AddItemName = "add")]
            public ConnectionManagerEnvironmentsCollection ConnectionManagerEndpoints { get { return (ConnectionManagerEnvironmentsCollection)base[EnvironmentCollectionName]; } }
        }

        public class ConnectionManagerEnvironmentsCollection : ConfigurationElementCollection
        {
            protected override ConfigurationElement CreateNewElement()
            {
                return new ConnectionManagerEnvironmentElement();
            }

            protected override object GetElementKey(ConfigurationElement element)
            {
                return ((ConnectionManagerEnvironmentElement)element).Name;
            }
        }

        public class ConnectionManagerEnvironmentElement : ConfigurationElement
        {
            [ConfigurationProperty("name", IsRequired = true)]
            public string Name
            {
                get { return (string)this["name"]; }
                set { this["name"] = value; }
            }

            [ConfigurationProperty("appServer", IsRequired = true)]
            public string AppServer
            {
                get { return (string)this["appServer"]; }
                set { this["appServer"] = value; }
            }

            [ConfigurationProperty("virtualDirectory", IsRequired = true)]
            public string VirtualDirectory
            {
                get { return (string)this["virtualDirectory"]; }
                set { this["virtualDirectory"] = value; }
            }

            [ConfigurationProperty("smServer", IsRequired = false)]
            public string SMServer
            {
                get { return (string)this["smServer"]; }
                set { this["smServer"] = value; }
            }

            [ConfigurationProperty("ramqServer", IsRequired = false)]
            public string RAMQServer
            {
                get { return (string)this["ramqServer"]; }
                set { this["ramqServer"] = value; }
            }

            [ConfigurationProperty("databaseServer", IsRequired = false)]
            public string DatabaseServer
            {
                get { return (string)this["databaseServer"]; }
                set { this["databaseServer"] = value; }
            }

            [ConfigurationProperty("database", IsRequired = false)]
            public string Database
            {
                get { return (string)this["database"]; }
                set { this["database"] = value; }
            }
        }
    }

    
    
}
