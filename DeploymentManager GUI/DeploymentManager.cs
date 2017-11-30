using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using static DeploymentManager_GUI.ConnectionManagerDataSection;

namespace DeploymentManager_GUI
{
    static class DeploymentManager
    {
        private static bool ISDEBUG = false;
        private static string _targetVirtualDirectory = string.Empty;
        private static string _targetAppServer = string.Empty;
        private static string _sourcePath = string.Empty;
        private static string _branch = string.Empty;
        private static string _targetSMServer = string.Empty;
        private static string _targetRAMQServer = string.Empty;
        private static string _targetSQLServer = string.Empty;
        private static string _targetDatabase = string.Empty;
        private static string _nonSQLOutputPath = ConfigurationManager.AppSettings.Get("NonSQLOutputPath");
        private static string _sqlOutputPath = ConfigurationManager.AppSettings.Get("SQLOutputPath");
        private static string _nantBuildFilePath = "";
        private static string _rootSQLPath = string.Empty;
        private static string _motivaSQLPath = string.Empty;
        private static string _movementLiveCycleSQLPath = string.Empty;
        private static string _buildNumber = string.Empty;
        private static string _postBuildOutputPath = string.Empty;
        private static List<string> rootSQLDirectories = new List<string>();
        private static Label progressLabel;
        private static BackgroundWorker backgroundWorker;

        public static string Run(BackgroundWorker bgw, Label lbl)
        {
            backgroundWorker = bgw;
            progressLabel = lbl;

            DeploymentManager._Init();
            DeploymentManager._AggregateNonSQL();
            DeploymentManager._AggregateSQL();

            if (!DeploymentManager.ISDEBUG)
                return _sqlOutputPath + "\\" + _buildNumber;
            DeploymentManager._DebugOutput();

            return _sqlOutputPath + "\\" + _buildNumber;
        }

        private static void _Init()
        {
            if (!Directory.Exists(DeploymentManager._nonSQLOutputPath))
                Directory.CreateDirectory(DeploymentManager._nonSQLOutputPath);
            if (!Directory.Exists(DeploymentManager._sqlOutputPath))
                Directory.CreateDirectory(DeploymentManager._sqlOutputPath);
            DeploymentManager.rootSQLDirectories.Add("\\SeedScripts");
            DeploymentManager.rootSQLDirectories.Add("\\OneOffs");
            DeploymentManager.rootSQLDirectories.Add("\\Tables");
            DeploymentManager.rootSQLDirectories.Add("\\Views");
            DeploymentManager.rootSQLDirectories.Add("\\StoredProcedures");
            DeploymentManager.rootSQLDirectories.Add("\\Functions");
            DeploymentManager.rootSQLDirectories.Add("\\Sequence");
            DeploymentManager.rootSQLDirectories.Add("\\Triggers");
            DeploymentManager.rootSQLDirectories.Add("\\CustomAccountingFramework\\Tables");
            DeploymentManager.rootSQLDirectories.Add("\\CustomAccountingFramework\\Functions");
            DeploymentManager.rootSQLDirectories.Add("\\CustomAccountingFramework\\SeedScripts");
            DeploymentManager.rootSQLDirectories.Add("\\CustomAccountingFramework\\StoredProcedures");
            DeploymentManager.rootSQLDirectories.Add("\\CustomAccountingFramework\\Triggers");
            DeploymentManager.rootSQLDirectories.Add("\\CustomAccountingFramework\\Views");
        }

        private static void _AggregateNonSQL()
        {
            Directory.CreateDirectory(DeploymentManager._nonSQLOutputPath);
            DeploymentManager._nantBuildFilePath = Directory.GetCurrentDirectory();
            DeploymentManager._BuildNantFile();
        }

        private static void _AggregateSQL()
        {
            DeploymentManager._rootSQLPath = DeploymentManager._sourcePath + "\\RightAngle\\" + DeploymentManager._branch;
            DeploymentManager._motivaSQLPath = DeploymentManager._rootSQLPath + "\\Motiva.SQL\\Motiva.RightAngle.SQL";
            DeploymentManager._movementLiveCycleSQLPath = DeploymentManager._rootSQLPath + "\\MTVMovementLifeCycle\\SQL";
            DeploymentManager._buildNumber = "SQL_" + ((IEnumerable<string>)DeploymentManager._targetVirtualDirectory.Split('.')).Last<string>() + "_" + DateTime.Now.ToString("yyyyMMdd_HHmmss");

            
            DeploymentManager._CopyRoot();
            DeploymentManager._CopyMovementLifeCycle();
            DeploymentManager._CopyAdditionalScripts();
            DeploymentManager._CombineGrantScripts();
        }

        private static void _DebugOutput()
        {
            Console.WriteLine("\n**Debug Output**");
            Console.WriteLine("Target App Server: " + DeploymentManager._targetAppServer);
            Console.WriteLine("Envrionment:" + DeploymentManager._targetVirtualDirectory);
            Console.WriteLine("Branch: " + DeploymentManager._branch);
            Console.WriteLine("Source Path: " + DeploymentManager._sourcePath);
            Console.ReadKey();
        }

        private static void _BuildNantFile()
        {
            string tempFileName = Path.GetTempFileName();
            string path = "DeploymentNantBuildTemplate.build";
            using (StreamWriter streamWriter = new StreamWriter(tempFileName))
            {
                using (StreamReader streamReader = new StreamReader(path))
                {
                    streamWriter.WriteLine("<project name=\"YourApp\" default=\"do-build\" xmlns=\"http://nant.sf.net/release/0.85-rc4/nant.xsd\">");
                    streamWriter.WriteLine("<!-- Version settings -->");
                    streamWriter.WriteLine();
                    streamWriter.WriteLine("<property name=\"EnvName\" value=\"" + DeploymentManager._targetVirtualDirectory + "\"/> <!-- must match IIS virtual directory name -->");
                    streamWriter.WriteLine("<property name=\"NantOutputPath\" value=\"" + DeploymentManager._nonSQLOutputPath + "\\${EnvName}-${datetime::format-to-string(datetime::now(), 'yyyyMMdd-HHmm')}\\\"/>");
                    streamWriter.WriteLine("<property name=\"TargetAppServer\" value=\"" + DeploymentManager._targetAppServer + "/${EnvName}\"/>");
                    streamWriter.WriteLine("<property name=\"build.output\" value=\"" + DeploymentManager._sourcePath + "\\RightAngle\\" + DeploymentManager._branch + "\\Motiva.RightAngle\"/>");
                    streamWriter.WriteLine("<property name=\"build.powerbuilder\" value=\"" + DeploymentManager._sourcePath + "\\RightAngle\\" + DeploymentManager._branch + "\\Motiva.RightAngle.PB\"/>");
                    streamWriter.WriteLine("<property name=\"build.outputAcctgFrmeWrk\" value=\"" + DeploymentManager._sourcePath + "\\RightAngle\\" + DeploymentManager._branch + "\\CustomAccountingFramework\\Custom.Server.ConfigurationData\"/>");
                    streamWriter.WriteLine("<property name=\"build.outputExchangeFrmeWrk\" value=\"" + DeploymentManager._sourcePath + "\\RightAngle\\" + DeploymentManager._branch + "\\Exchange Integration\\\"/>");
                    streamWriter.WriteLine("<property name=\"build.outputGlobalViewFrmeWrk\" value=\"" + DeploymentManager._sourcePath + "\\RightAngle\\" + DeploymentManager._branch + "\\GlobalView\\\"/>");
                    streamWriter.WriteLine("<property name=\"build.outputMovementLifeCycle\" value=\"" + DeploymentManager._sourcePath + "\\RightAngle\\" + DeploymentManager._branch + "\\MTVMovementLifeCycle\\OutPut\\\"/>");
                    streamWriter.WriteLine("<property name=\"Interfacebuild.output\" value=\"" + DeploymentManager._sourcePath + "\\RightAngle\\" + DeploymentManager._branch + "\\Motiva.RightAngle.Interfaces\"/>");
                    while (!streamReader.EndOfStream)
                        streamWriter.WriteLine(streamReader.ReadLine());
                }
            }
            string destFileName = "DeploymentNantBuild.build";
            File.Copy(tempFileName, destFileName, true);
            string str = "\"c:\\Program Files (x86)\\Nant\\bin\\NAnt.exe\" /f:\"" + Directory.GetCurrentDirectory() + "\\DeploymentNantBuild.build\"";
            var nantProcess = Process.Start("\"C:\\Program Files (x86)\\Nant\\bin\\NAnt.exe\"", "/f:\"" + Directory.GetCurrentDirectory() + "\\DeploymentNantBuild.build\"");

            var nantStatusUpdateThread  = new Thread(() => StartNewProgressUpdateThread("Running Nant", 0, 25));
            nantStatusUpdateThread.Start();

            while (nantStatusUpdateThread.IsAlive) { }
            File.Delete(tempFileName);
        }

        private static void _CopyRoot()
        {
            var copyRootUpdateThread = new Thread(() => StartNewProgressUpdateThread("Copying Root", 25, 50));
            copyRootUpdateThread.Start();

            DeploymentManager._postBuildOutputPath = DeploymentManager._sqlOutputPath + "\\" + DeploymentManager._buildNumber + "\\PostBuild";
            Directory.CreateDirectory(DeploymentManager._postBuildOutputPath);
            foreach (string rootSqlDirectory in DeploymentManager.rootSQLDirectories)
            {
                string str1 = rootSqlDirectory;
                if (rootSqlDirectory == "\\OneOffs")
                    str1 = "\\SeedScripts";
                if (rootSqlDirectory == "\\Sequence")
                    str1 = "\\Tables";
                string str2 = DeploymentManager._sqlOutputPath + "\\" + DeploymentManager._buildNumber + str1;
                if (!Directory.Exists(str2) && !str2.Contains("CustomAccountingFramework"))
                    Directory.CreateDirectory(str2);
                string[] files = Directory.GetFiles(DeploymentManager._motivaSQLPath + rootSqlDirectory, "*.sql");
                for (int index = 0; index < files.Length; ++index)
                {
                    if (!(((IEnumerable<string>)files[index].Split('\\')).Last<string>() == "T_MotivaBuildStatistics.sql"))
                    {
                        if (rootSqlDirectory == "\\Tables" || rootSqlDirectory == "\\Views" || (rootSqlDirectory == "\\StoredProcedures" || rootSqlDirectory == "\\Functions") || rootSqlDirectory == "\\Sequence")
                        {
                            string upper = ((IEnumerable<string>)files[index].Split('\\')).Last<string>().ToUpper();
                            if (upper.Contains("GRANT"))
                            {
                                if (upper != "FN_FUCTIONNAME.GRANT.sql" && upper != "SP_STOREDPROCEDURENAME.GRANT.sql" && upper != "T_TABLNAME.GRANT.sql " && upper != "V_VIEWNAME.GRANT.sql")
                                {
                                    File.Copy(files[index], Path.Combine(DeploymentManager._postBuildOutputPath, ((IEnumerable<string>)files[index].Split('\\')).Last<string>()), true);
                                    continue;
                                }
                                continue;
                            }
                        }
                        else if (rootSqlDirectory.Contains("CustomAccountingFramework"))
                        {
                            string str3 = ((IEnumerable<string>)rootSqlDirectory.Split('\\')).Last<string>();
                            string path1 = DeploymentManager._sqlOutputPath + "\\" + DeploymentManager._buildNumber + "\\" + str3;
                            File.Copy(files[index], Path.Combine(path1, ((IEnumerable<string>)files[index].Split('\\')).Last<string>()), true);
                            continue;
                        }
                        File.Copy(files[index], Path.Combine(str2, ((IEnumerable<string>)files[index].Split('\\')).Last<string>()), true);
                    }
                }
            }

            copyRootUpdateThread.Abort();
        }

        private static void _CopyMovementLifeCycle()
        {
            var copyMovementLifeCycleProgressUpdateThread = new Thread(() => StartNewProgressUpdateThread("Combining Movement LifeCycle", 50, 51));
            copyMovementLifeCycleProgressUpdateThread.Start();

            string str1 = DeploymentManager._sqlOutputPath + "\\" + DeploymentManager._buildNumber + "\\";
            string str2 = string.Empty;
            string[] files = Directory.GetFiles(DeploymentManager._movementLiveCycleSQLPath, "*.sql");
            for (int index = 0; index < files.Length; ++index)
            {
                if (((IEnumerable<string>)((IEnumerable<string>)files[index].Split('\\')).Last<string>().Split('_')).First<string>() == "sd")
                    str2 = "SeedScripts";
                if (((IEnumerable<string>)((IEnumerable<string>)files[index].Split('\\')).Last<string>().Split('_')).First<string>() == "t")
                    str2 = "Tables";
                if (((IEnumerable<string>)((IEnumerable<string>)files[index].Split('\\')).Last<string>().Split('_')).First<string>() == "v")
                    str2 = "Views";
                if (((IEnumerable<string>)((IEnumerable<string>)files[index].Split('\\')).Last<string>().Split('_')).First<string>() == "sp")
                    str2 = "StoredProcedures";
                if (((IEnumerable<string>)((IEnumerable<string>)files[index].Split('\\')).Last<string>().Split('_')).First<string>() == "f")
                    str2 = "Functions";
                if (((IEnumerable<string>)((IEnumerable<string>)files[index].Split('\\')).Last<string>().Split('_')).First<string>() == "ti")
                    str2 = "Triggers";
                File.Copy(files[index], Path.Combine(str1 + str2, ((IEnumerable<string>)files[index].Split('\\')).Last<string>()), true);
            }

            copyMovementLifeCycleProgressUpdateThread.Abort();
        }

        private static void _CopyAdditionalScripts()
        {
            var copyAdditionalScriptsProgressUpdateThread = new Thread(() => StartNewProgressUpdateThread("Copying Additional Scripts", 51, 52));
            copyAdditionalScriptsProgressUpdateThread.Start();

            string path1_1 = "GrantScript";
            string path1_2 = DeploymentManager._sqlOutputPath + "\\" + DeploymentManager._buildNumber;
            File.Copy(Path.Combine(path1_1, "DB - Database_Grants_20160616.sql"), Path.Combine(path1_2, "DB - Database_Grants_20160616.sql"));
            File.Copy(Path.Combine("DeploymentScript", "SQLDeploymentPrepAndCopy_Add_Grants_Dev_Motiva.bat"), Path.Combine(path1_2, "SQLDeploymentPrepAndCopy_Add_Grants_Dev_Motiva.bat"));
            File.Copy(Path.Combine("DeploymentBuilder", "DeploymentBuilder.exe"), Path.Combine(path1_2, "DeploymentBuilder.exe"));

            copyAdditionalScriptsProgressUpdateThread.Abort();
        }

        private static void _CombineGrantScripts()
        {
            var combineGrantScriptsProgressUpdateThread = new Thread(() => StartNewProgressUpdateThread("Combining Grant Scripts", 52, 65));
            combineGrantScriptsProgressUpdateThread.Start();

            string[] files = Directory.GetFiles(DeploymentManager._postBuildOutputPath);
            using (FileStream fileStream1 = File.Create(DeploymentManager._sqlOutputPath + "\\" + DeploymentManager._buildNumber + "\\PostBuildScripts.sql"))
            {
                foreach (string path in files)
                {
                    using (FileStream fileStream2 = File.OpenRead(path))
                        fileStream2.CopyTo((Stream)fileStream1);
                }
            }

            combineGrantScriptsProgressUpdateThread.Abort();
        }

        private static void UpdateLabel(string text)
        {
            progressLabel.Invoke((Action)delegate { progressLabel.Text = text; });
        }

        public static void StartNewProgressUpdateThread(string text, int min, int max)
        {
            UpdateLabel(text);
            Thread.CurrentThread.IsBackground = true;
            int progress = min;
            while (progress < max)
            {
                Thread.Sleep(5000);
                backgroundWorker.ReportProgress(progress++);
            }
        }

        public static void SetBranch(string rbSelection)
        {
            switch (rbSelection)
            {
                case "rbDevelopment":
                    _branch = "Development";
                    break;
                case "rbMain":
                    _branch = "Main";
                    break;
                case "rbRelease":
                    _branch = "Release";
                    break;
                case "rbDevGL":
                    _branch = "Dev-GL";
                    break;

            }
        }

        public static void SetSourcePath(string btnSourcePathBrowser)
        {
            _sourcePath = btnSourcePathBrowser;
        }

        public static void SetEnvironmentInformation(string rbSelection)
        {
            // Grab the Environments listed in the App.config and add them to our list.
            var environmentManagerDataSection = ConfigurationManager.GetSection(ConnectionManagerDataSection.SectionName) as ConnectionManagerDataSection;
            foreach (ConnectionManagerEnvironmentElement environmentElement in environmentManagerDataSection.ConnectionManagerEnvironments)
            {
                if(environmentElement.Name == rbSelection)
                {
                    _targetAppServer = environmentElement.AppServer;
                    _targetVirtualDirectory = environmentElement.VirtualDirectory;
                    _targetSMServer = environmentElement.SMServer;
                    _targetRAMQServer = environmentElement.RAMQServer;
                    _targetSQLServer = environmentElement.DatabaseServer;
                    _targetDatabase = environmentElement.Database;
                    return;
                }
            }
        }
        
    }
}

