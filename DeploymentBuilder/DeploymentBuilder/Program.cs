// Decompiled with JetBrains decompiler
// Type: DeploymentBuilder.Program
// Assembly: DeploymentBuilder, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 6DC3A0D0-93E6-492C-8406-B8C6AF25D2EB
// Assembly location: C:\Users\jason.ewton\Dropbox\Work\Projects\Motiva\_repos\DeploymentManager\bin\Debug\DeploymentBuilder\DeploymentBuilder.exe

using System;
using System.Windows.Forms;

namespace DeploymentBuilder
{
    public static class Program
    {
        [STAThread]
        public static void Main(string[] args)
        {
            if(args.Length == 2)
            {
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);
                Application.Run((Form)new DeploymentBuilderForm(args[0], args[1]));
            }
            //else
            //{
            //    Application.EnableVisualStyles();
            //    Application.SetCompatibleTextRenderingDefault(false);
            //    Application.Run((Form)new DeploymentBuilderForm());
            //}
        }
    }
}
