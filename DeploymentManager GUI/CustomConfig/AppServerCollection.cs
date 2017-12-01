using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace DeploymentManager_GUI.CustomConfig
{
    public class AppServerCollection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new AppServer();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((AppServer)element).Name;
        }

        protected override string ElementName
        {
            get
            {
                return "appServer";
            }
        }

        protected override bool IsElementName(string elementName)
        {
            return !String.IsNullOrEmpty(elementName) && elementName == "appServer";
        }

        public override ConfigurationElementCollectionType CollectionType
        {
            get
            {
                return ConfigurationElementCollectionType.BasicMap;
            }
        }

        public AppServer this[int index]
        {
            get
            {
                return base.BaseGet(index) as AppServer;
            }
        }

        public new AppServer this[string key]
        {
            get
            {
                return base.BaseGet(key) as AppServer;
            }
        }
    }
}
