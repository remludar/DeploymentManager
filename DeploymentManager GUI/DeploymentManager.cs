using DeploymentManager_GUI.CustomConfig;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.SqlServer.Management.Sdk.Sfc;
using Microsoft.SqlServer.Management.Smo;
using Microsoft.SqlServer.Management.Common;

namespace DeploymentManager_GUI
{
    static class DeploymentManager
    {
        private static List<string> _targetAppServers = new List<string>();
        private static List<string> _targetSMServers = new List<string>();
        private static List<string> _targetRAMQServers = new List<string>();
        private static string _targetEnvironment = string.Empty;
        private static string _targetVirtualDirectory = string.Empty;
        private static string _targetSQLServer = string.Empty;
        private static string _targetDatabase = string.Empty;
        private static string _targetDeploymentPath = string.Empty;

        private static string _nonSQLOutputPath = ConfigurationManager.AppSettings.Get("NonSQLOutputPath");
        private static string _sqlOutputPath = ConfigurationManager.AppSettings.Get("SQLOutputPath");
        private static string _deploymentStagingPath = ConfigurationManager.AppSettings.Get("DeploymentStagingPath");
        private static string _sourcePath = string.Empty;
        private static string _branch = string.Empty;
        private static string _nantBuildFilePath = "";
        private static string _rootSQLPath = string.Empty;
        private static string _motivaSQLPath = string.Empty;
        private static string _movementLiveCycleSQLPath = string.Empty;
        private static string _buildNumber = string.Empty;
        private static string _postBuildOutputPath = string.Empty;
        private static List<string> _rootSQLDirectories = new List<string>();
        private static Label progressLabel;
        private static Label _oldSqlPath;

        private static BackgroundWorker backgroundWorker;

        public enum ServiceActionType { STOP, START };

        public static void Init(BackgroundWorker bgw, Label progressBarLabel, string branch, Label sqlComparePath, string sourcePath, string environmentName)
        {
            backgroundWorker = bgw;
            progressLabel = progressBarLabel;

            #region Set Branch
            switch (branch)
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
            #endregion
            #region Set Source
            // Set source
            _sourcePath = sourcePath;
            #endregion
            #region Set Environment Data from App.Config
            // Grab the Environments listed in the App.config and add them to our lists.
            _targetEnvironment = environmentName;
            _deploymentStagingPath += "\\" + environmentName;
            _targetDeploymentPath = ConfigurationManager.AppSettings.Get("DeploymentPath") + _targetEnvironment;
            var environmentCollectionSection = ConfigurationManager.GetSection("environmentCollectionSection") as EnvironmentCollectionSection;
            var environment = environmentCollectionSection.Members[environmentName];


            foreach (AppServer appServer in environment.AppServers)
            {
                _targetAppServers.Add(appServer.Name);
            }

            foreach (SMServer smServer in environment.SMServers)
            {
                _targetSMServers.Add(smServer.Name);
            }

            foreach (RAMQServer ramqServer in environment.RAMQServers)
            {
                _targetRAMQServers.Add(ramqServer.Name);
            }

            _targetVirtualDirectory = environment.VirtualDirectory.Name;
            _targetSQLServer = environment.DBServer.Name;
            _targetDatabase = environment.DBName.Name;
            _oldSqlPath = sqlComparePath;
            #endregion
            #region Nant Prep
            // Nant Prep
            if (!Directory.Exists(_nonSQLOutputPath))
                Directory.CreateDirectory(_nonSQLOutputPath);
            if (!Directory.Exists(_sqlOutputPath))
                Directory.CreateDirectory(_sqlOutputPath);
            _rootSQLDirectories.Add("\\SeedScripts");
            _rootSQLDirectories.Add("\\OneOffs");
            _rootSQLDirectories.Add("\\Tables");
            _rootSQLDirectories.Add("\\Views");
            _rootSQLDirectories.Add("\\StoredProcedures");
            _rootSQLDirectories.Add("\\Functions");
            _rootSQLDirectories.Add("\\Sequence");
            _rootSQLDirectories.Add("\\Triggers");
            _rootSQLDirectories.Add("\\CustomAccountingFramework\\Tables");
            _rootSQLDirectories.Add("\\CustomAccountingFramework\\Functions");
            _rootSQLDirectories.Add("\\CustomAccountingFramework\\SeedScripts");
            _rootSQLDirectories.Add("\\CustomAccountingFramework\\StoredProcedures");
            _rootSQLDirectories.Add("\\CustomAccountingFramework\\Triggers");
            _rootSQLDirectories.Add("\\CustomAccountingFramework\\Views");
            #endregion

        }

        public static void Run()
        {
            _AggregateNonSQL();
            _AggregateSQL();
            _RunSQLDeploymentBuilder(_oldSqlPath, _sqlOutputPath + "\\" + _buildNumber);
            _CopyFilesToDeploymentStaging();
            _BackupCurrentDeployment();
            _ManageServices(ServiceActionType.STOP);
            _Deploy();
            _ExecuteSql();
            _ManageServices(ServiceActionType.START);
        }

        private static void _AggregateNonSQL()
        {
            Directory.CreateDirectory(DeploymentManager._nonSQLOutputPath);
            DeploymentManager._nantBuildFilePath = Directory.GetCurrentDirectory();
            DeploymentManager._BuildNantFile();
        }
        private static void _BuildNantFile()
        {
            var nantStatusUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Running Nant", 0, 10));
            nantStatusUpdateThread.Start();

            string tempFileName = Path.GetTempFileName();
            string path = "DeploymentNantBuildTemplate.build";
            using (StreamWriter streamWriter = new StreamWriter(tempFileName))
            {
                using (StreamReader streamReader = new StreamReader(path))
                {
                    _nonSQLOutputPath += "\\" + DeploymentManager._targetVirtualDirectory + "-" + DateTime.Now.ToString("yyyyMMdd-HHmm");
                    streamWriter.WriteLine("<project name=\"YourApp\" default=\"do-build\" xmlns=\"http://nant.sf.net/release/0.85-rc4/nant.xsd\">");
                    streamWriter.WriteLine("<!-- Version settings -->");
                    streamWriter.WriteLine();
                    streamWriter.WriteLine("<property name=\"EnvName\" value=\"" + DeploymentManager._targetVirtualDirectory + "\"/> <!-- must match IIS virtual directory name -->");
                    //streamWriter.WriteLine("<property name=\"NantOutputPath\" value=\"" + DeploymentManager._nonSQLOutputPath + "\\${EnvName}-${datetime::format-to-string(datetime::now(), 'yyyyMMdd-HHmm')}\\\"/>");
                    streamWriter.WriteLine("<property name=\"NantOutputPath\" value=\"" + _nonSQLOutputPath + "\\\"/>");
                    streamWriter.WriteLine("<property name=\"TargetAppServer\" value=\"" + DeploymentManager._targetAppServers + "/${EnvName}\"/>");
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

            while (!nantProcess.HasExited) { }
            nantStatusUpdateThread.Abort();
            File.Delete(tempFileName);
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
        private static void _CopyRoot()
        {
            var copyRootUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Copying Root", 10, 20));
            copyRootUpdateThread.Start();

            DeploymentManager._postBuildOutputPath = DeploymentManager._sqlOutputPath + "\\" + DeploymentManager._buildNumber + "\\PostBuild";
            Directory.CreateDirectory(DeploymentManager._postBuildOutputPath);
            foreach (string rootSqlDirectory in DeploymentManager._rootSQLDirectories)
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
            var copyMovementLifeCycleProgressUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Combining Movement LifeCycle", 20, 25));
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
            var copyAdditionalScriptsProgressUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Copying Additional Scripts", 25, 30));
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
            var combineGrantScriptsProgressUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Combining Grant Scripts", 30, 35));
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
        private static void _RunSQLDeploymentBuilder(Label oldSqlPath, string sqlOutputPath)
        {
            var createSQLProgressUpdateThread = new Thread(() => DeploymentManager._StartNewProgressUpdateThread("Creating SQL File", 35, 50));
            createSQLProgressUpdateThread.Start();

            //Run what used to be the "Deployment Builder" that compares the 2 sql files
            DeploymentBuilder.Run(oldSqlPath.Text, sqlOutputPath);

            string sqlBuildFilePath = sqlOutputPath + "\\SQLBuild.sql";
            string baseGrantsFilePath = sqlOutputPath + "\\DB - Database_Grants_20160616.sql";

            using (Stream input = File.OpenRead(baseGrantsFilePath))
            using (Stream output = new FileStream(sqlBuildFilePath, FileMode.Append,
                                                  FileAccess.Write, FileShare.None))
            {
                input.CopyTo(output);
            }

            string fileName = "\\SQLDeploy_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".sql";
            string sqlDeployFilePath = sqlOutputPath + fileName;
            string sqlNonSQLFilePath = ConfigurationManager.AppSettings.Get("NonSQLOutputPath");
            var mostRecentNonSQLDirectory = new DirectoryInfo(sqlNonSQLFilePath).GetDirectories()
                       .OrderByDescending(d => d.LastWriteTimeUtc).First().FullName;
            mostRecentNonSQLDirectory += fileName;

            File.Move(sqlBuildFilePath, sqlDeployFilePath);

            //Copy the final sql output back to its .NET directory for easy deployment
            File.Copy(sqlDeployFilePath, mostRecentNonSQLDirectory);

            createSQLProgressUpdateThread.Abort();

        }
        private static void _CopyFilesToDeploymentStaging()
        {
            var copyToStagingStatusUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Copying Files to Staging", 50, 65));
            copyToStagingStatusUpdateThread.Start();

            //Create all of the directories
            string destinationPath = ConfigurationManager.AppSettings.Get("DeploymentStagingPath") + "\\" + _targetEnvironment;
            foreach (string dirPath in Directory.GetDirectories(_nonSQLOutputPath, "*", SearchOption.AllDirectories))
                Directory.CreateDirectory(dirPath.Replace(_nonSQLOutputPath, destinationPath));

            //Delete the sql file
            foreach (string newPath in Directory.GetFiles(destinationPath, "*sql", SearchOption.TopDirectoryOnly))
                File.Delete(newPath);

            //Copy all the files & Replaces any files with the same name
            foreach (string newPath in Directory.GetFiles(_nonSQLOutputPath, "*.*", SearchOption.AllDirectories))
                File.Copy(newPath, newPath.Replace(_nonSQLOutputPath, destinationPath), true);

            copyToStagingStatusUpdateThread.Abort();
        }
        private static void _ManageServices(ServiceActionType type)
        {
            int min = (type == ServiceActionType.STOP) ? 65 : 95;
            int max = (type == ServiceActionType.STOP) ? 70 : 100;
            var manageServicesStatusUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Setting services to " + type, min, max));
            manageServicesStatusUpdateThread.Start();

            //iis
            foreach (string serverName in _targetAppServers)
            {
                ServiceController[] appServerServices = ServiceController.GetServices(serverName);
                foreach (ServiceController service in appServerServices)
                {
                    if (service.DisplayName.Contains(_targetEnvironment))
                    {
                        if (type == ServiceActionType.STOP && service.CanStop)
                        {
                            service.Stop();
                        }
                        else if (type == ServiceActionType.START)
                        {
                            service.WaitForStatus(ServiceControllerStatus.Stopped);
                            service.Start();
                        }

                    }
                }
            }

            //sm
            foreach (string serverName in _targetSMServers)
            {
                ServiceController[] appServerServices = ServiceController.GetServices(serverName);
                foreach (ServiceController service in appServerServices)
                {
                    if (service.DisplayName.Contains("Service Monitor"))
                    {
                        if (service.DisplayName.Contains(_targetEnvironment))
                        {
                            if (type == ServiceActionType.STOP && service.CanStop)
                            {
                                service.Stop();
                            }
                            else if (type == ServiceActionType.START)
                            {
                                service.WaitForStatus(ServiceControllerStatus.Stopped);
                                service.Start();
                            }
                        }
                    }
                }
            }

            //ramq
            foreach (string serverName in _targetRAMQServers)
            {
                ServiceController[] appServerServices = ServiceController.GetServices(serverName);
                foreach (ServiceController service in appServerServices)
                {
                    if (service.DisplayName.Contains("RAMQ"))
                    {
                        if (service.DisplayName.Contains(_targetEnvironment))
                        {
                            if (type == ServiceActionType.STOP && service.CanStop)
                            {
                                service.Stop();
                            }
                            else if (type == ServiceActionType.START)
                            {
                                service.WaitForStatus(ServiceControllerStatus.Stopped);
                                service.Start();
                            }
                        }
                    }
                }
            }
            manageServicesStatusUpdateThread.Abort();
        }
        private static void _BackupCurrentDeployment()
        {
            var backupStatusUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Backing up current deployments", 75, 85));
            backupStatusUpdateThread.Start();

            var backupPathRoot = ConfigurationManager.AppSettings.Get("BackupPath");
            var timeStamp = DateTime.Now.ToString("yyyymmddThhmmss");

            foreach (string server in _targetAppServers)
            {
                var destinationPath = "\\\\" + server + "\\" + _targetDeploymentPath + "\\Server";
                var backupPath = "\\\\" + server + "\\" + backupPathRoot + _targetEnvironment + "\\" + timeStamp + "\\Server";

                //Create all of the directories
                var directories = Directory.GetDirectories(destinationPath, "*", SearchOption.AllDirectories);
                if (directories.Count() > 0)
                {
                    foreach (string dirPath in directories)
                        Directory.CreateDirectory(dirPath.Replace(destinationPath, backupPath));

                    //Copy all the files & Replaces any files with the same name
                    foreach (string newPath in Directory.GetFiles(destinationPath, "*.*", SearchOption.AllDirectories))
                    {
                        //TODO: Need a better solution for this
                        if (newPath.Contains("Scraps") ||
                            newPath.Contains("ReportViews") ||
                            newPath.Length >= 260)
                            continue;
                        File.Copy(newPath, newPath.Replace(destinationPath, backupPath), true);
                    }
                }
            }

            foreach (string server in _targetSMServers)
            {
                var destinationPath = "\\\\" + server + "\\" + _targetDeploymentPath + "\\Server";
                var backupPath = "\\\\" + server + "\\" + backupPathRoot + _targetEnvironment + "\\" + timeStamp + "\\Server";

                //Create all of the directories
                var directories = Directory.GetDirectories(destinationPath, "*", SearchOption.AllDirectories);
                if (directories.Count() > 0)
                {
                    foreach (string dirPath in directories)
                        Directory.CreateDirectory(dirPath.Replace(destinationPath, backupPath));

                    //Copy all the files & Replaces any files with the same name
                    foreach (string newPath in Directory.GetFiles(destinationPath, "*.*", SearchOption.AllDirectories))
                    {
                        //TODO: Need a better solution for this
                        if (newPath.Length > 260)
                            continue;
                        File.Copy(newPath, newPath.Replace(destinationPath, backupPath), true);
                    }
                }
            }

            foreach (string server in _targetRAMQServers)
            {
                var destinationPath = "\\\\" + server + "\\" + _targetDeploymentPath + "\\RightAngleIV";
                var backupPath = "\\\\" + server + "\\" + backupPathRoot + _targetEnvironment + "\\" + timeStamp + "\\RightAngleIV";

                //Create all of the directories
                var directories = Directory.GetDirectories(destinationPath, "*", SearchOption.AllDirectories);
                if (directories.Count() > 0)
                {
                    foreach (string dirPath in directories)
                        Directory.CreateDirectory(dirPath.Replace(destinationPath, backupPath));

                    //Copy all the files & Replaces any files with the same name
                    foreach (string newPath in Directory.GetFiles(destinationPath, "*.*", SearchOption.AllDirectories))
                    {
                        //TODO: Need a better solution for this
                        if (newPath.Length > 260)
                            continue;
                        File.Copy(newPath, newPath.Replace(destinationPath, backupPath), true);
                    }
                }
            }
            backupStatusUpdateThread.Abort();
        }
        private static void _Deploy()
        {
            var deployStatusUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Deploying app, sm, and ramq", 85, 95));
            deployStatusUpdateThread.Start();

            foreach (string server in _targetAppServers)
            {
                var destinationPath = "\\\\" + server + "\\" + _targetDeploymentPath + "\\Server";
                var stagingPath = ConfigurationManager.AppSettings.Get("DeploymentStagingPath") + "\\" + _targetEnvironment + "\\Server";

                //Create all of the directories
                var directories = Directory.GetDirectories(stagingPath, "*", SearchOption.AllDirectories);
                if (directories.Count() > 0)
                {
                    foreach (string dirPath in directories)
                        Directory.CreateDirectory(dirPath.Replace(stagingPath, destinationPath));

                    //Copy all the files & Replaces any files with the same name
                    foreach (string newPath in Directory.GetFiles(stagingPath, "*.*", SearchOption.AllDirectories))
                    {
                        //TODO: Need a better solution for this
                        File.Copy(newPath, newPath.Replace(stagingPath, destinationPath), true);
                    }
                }
            }

            foreach (string server in _targetSMServers)
            {
                var destinationPath = "\\\\" + server + "\\" + _targetDeploymentPath + "\\Server";
                var stagingPath = ConfigurationManager.AppSettings.Get("DeploymentStagingPath") + "\\" + _targetEnvironment + "\\serviceServer";

                //Create all of the directories
                var directories = Directory.GetDirectories(stagingPath, "*", SearchOption.AllDirectories);
                if (directories.Count() > 0)
                {
                    foreach (string dirPath in directories)
                        Directory.CreateDirectory(dirPath.Replace(stagingPath, destinationPath));

                    //Copy all the files & Replaces any files with the same name
                    foreach (string newPath in Directory.GetFiles(stagingPath, "*.*", SearchOption.AllDirectories))
                    {
                        //TODO: Need a better solution for this
                        File.Copy(newPath, newPath.Replace(stagingPath, destinationPath), true);
                    }
                }
            }

            foreach (string server in _targetRAMQServers)
            {
                var destinationPath = "\\\\" + server + "\\" + _targetDeploymentPath + "\\RightAngleIV";
                var stagingPath = ConfigurationManager.AppSettings.Get("DeploymentStagingPath") + "\\" + _targetEnvironment + "\\RightAngleIV";

                //Create all of the directories
                var directories = Directory.GetDirectories(stagingPath, "*", SearchOption.AllDirectories);
                if (directories.Count() > 0)
                {
                    foreach (string dirPath in directories)
                        Directory.CreateDirectory(dirPath.Replace(stagingPath, destinationPath));

                    //Copy all the files & Replaces any files with the same name
                    foreach (string newPath in Directory.GetFiles(stagingPath, "*.*", SearchOption.AllDirectories))
                    {
                        //TODO: Need a better solution for this
                        File.Copy(newPath, newPath.Replace(stagingPath, destinationPath), true);
                    }
                }
            }
            deployStatusUpdateThread.Abort();
        }
        private static void _ExecuteSql()
        {
            var executeSqlUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Executing SQL", 95, 100));
            executeSqlUpdateThread.Start();

            var connectionString = "Persist Security Info=False;Integrated Security=true;Initial Catalog=" + _targetDatabase + ";server=" + _targetSQLServer;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                Server db = new Server(new ServerConnection(conn));

                var sqlFileName = Directory.GetFiles(_deploymentStagingPath, "*sql", SearchOption.TopDirectoryOnly).First();

                string data = File.ReadAllText(sqlFileName);

                db.ConnectionContext.ExecuteNonQuery(data);
            }



            executeSqlUpdateThread.Abort();
        }

        //Helpers
        private static void _UpdateProgressLabel(string text)
        {
            progressLabel.Invoke((Action)delegate { progressLabel.Text = text; });
        }
        private static void _StartNewProgressUpdateThread(string text, int min, int max)
        {
            _UpdateProgressLabel(text);
            Thread.CurrentThread.IsBackground = true;
            int progress = min;
            while (progress < max)
            {
                Thread.Sleep(5000);
                backgroundWorker.ReportProgress(progress++);
            }
        }
    }
}

