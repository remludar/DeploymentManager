using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace DeploymentManager_GUI.CustomConfig
{
    public class RAMQServerCollection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new RAMQServer();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((RAMQServer)element).Name;
        }

        protected override string ElementName
        {
            get
            {
                return "ramqServer";
            }
        }

        protected override bool IsElementName(string elementName)
        {
            return !String.IsNullOrEmpty(elementName) && elementName == "ramqServer";
        }

        public override ConfigurationElementCollectionType CollectionType
        {
            get
            {
                return ConfigurationElementCollectionType.BasicMap;
            }
        }

        public RAMQServer this[int index]
        {
            get
            {
                return base.BaseGet(index) as RAMQServer;
            }
        }

        public new RAMQServer this[string key]
        {
            get
            {
                return base.BaseGet(key) as RAMQServer;
            }
        }
    }
}
