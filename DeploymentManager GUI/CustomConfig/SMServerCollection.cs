using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace DeploymentManager_GUI.CustomConfig 
{
    public class SMServerCollection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new SMServer();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((SMServer)element).Name;
        }

        protected override string ElementName
        {
            get
            {
                return "smServer";
            }
        }

        protected override bool IsElementName(string elementName)
        {
            return !String.IsNullOrEmpty(elementName) && elementName == "smServer";
        }

        public override ConfigurationElementCollectionType CollectionType
        {
            get
            {
                return ConfigurationElementCollectionType.BasicMap;
            }
        }

        public SMServer this[int index]
        {
            get
            {
                return base.BaseGet(index) as SMServer;
            }
        }

        public new SMServer this[string key]
        {
            get
            {
                return base.BaseGet(key) as SMServer;
            }
        }
    }
}
