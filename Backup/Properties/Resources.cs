// Decompiled with JetBrains decompiler
// Type: DeploymentBuilder.Properties.Resources
// Assembly: DeploymentBuilder, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 6DC3A0D0-93E6-492C-8406-B8C6AF25D2EB
// Assembly location: C:\Users\jason.ewton\Dropbox\Work\Projects\Motiva\_repos\DeploymentManager\bin\Debug\DeploymentBuilder\DeploymentBuilder.exe

using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Globalization;
using System.Resources;
using System.Runtime.CompilerServices;

namespace DeploymentBuilder.Properties
{
  [DebuggerNonUserCode]
  [CompilerGenerated]
  [GeneratedCode("System.Resources.Tools.StronglyTypedResourceBuilder", "2.0.0.0")]
  internal class Resources
  {
    private static ResourceManager resourceMan;
    private static CultureInfo resourceCulture;

    internal Resources()
    {
    }

    [EditorBrowsable(EditorBrowsableState.Advanced)]
    internal static ResourceManager ResourceManager
    {
      get
      {
        if (DeploymentBuilder.Properties.Resources.resourceMan == null)
          DeploymentBuilder.Properties.Resources.resourceMan = new ResourceManager("DeploymentBuilder.Properties.Resources", typeof (DeploymentBuilder.Properties.Resources).Assembly);
        return DeploymentBuilder.Properties.Resources.resourceMan;
      }
    }

    [EditorBrowsable(EditorBrowsableState.Advanced)]
    internal static CultureInfo Culture
    {
      get
      {
        return DeploymentBuilder.Properties.Resources.resourceCulture;
      }
      set
      {
        DeploymentBuilder.Properties.Resources.resourceCulture = value;
      }
    }
  }
}
