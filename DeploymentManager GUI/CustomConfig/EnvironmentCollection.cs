using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace DeploymentManager_GUI.CustomConfig
{
    public class EnvironmentCollection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new Environment();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((Environment)element).Name;
        }

        protected override string ElementName
        {
            get
            {
                return "environment";
            }
        }

        protected override bool IsElementName(string elementName)
        {
            return !String.IsNullOrEmpty(elementName) && elementName == "environment";
        }

        public override ConfigurationElementCollectionType CollectionType
        {
            get
            {
                return ConfigurationElementCollectionType.BasicMap;
            }
        }

        public Environment this[int index]
        {
            get
            {
                return base.BaseGet(index) as Environment;
            }
        }

        public new Environment this[string key]
        {
            get
            {
                return base.BaseGet(key) as Environment;
            }
        }
    }
}
