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
using System.IO.Compression;
using Microsoft.VisualBasic.FileIO;

namespace DeploymentManager_GUI
{
    static class DeploymentManager
    {
        private static string _nonSQLOutputPathLocal = ConfigurationManager.AppSettings.Get("NonSQLOutputPathLocal");
        private static string _nonSQLOutputPath = ConfigurationManager.AppSettings.Get("NonSQLOutputPath");
        private static string _sqlOutputPathLocal = ConfigurationManager.AppSettings.Get("SQLOutputPathLocal");
        private static string _sqlOutputPath = ConfigurationManager.AppSettings.Get("SQLOutputPath");
        private static string _deploymentStagingPath = ConfigurationManager.AppSettings.Get("DeploymentStagingPath");
        private static string _oldSqlPathLocal = ConfigurationManager.AppSettings.Get("OldSQLPathLocal");


        private static List<string> _targetAppServers = new List<string>();
        private static List<string> _targetSMServers = new List<string>();
        private static List<string> _targetRAMQServers = new List<string>();
        private static List<string> _rootSQLDirectories = new List<string>();

        private static string _targetEnvironment = string.Empty;
        private static string _targetVirtualDirectory = string.Empty;
        private static string _targetSQLServer = string.Empty;
        private static string _targetDatabase = string.Empty;
        private static string _targetDeploymentPath = string.Empty;
        private static string _oldSqlPath = string.Empty;
        private static string _sourcePath = string.Empty;
        private static string _branch = string.Empty;
        private static string _nantBuildFilePath = string.Empty;
        private static string _rootSQLPath = string.Empty;
        private static string _motivaSQLPath = string.Empty;
        private static string _movementLiveCycleSQLPath = string.Empty;
        private static string _buildNumber = string.Empty;
        private static string _postBuildOutputPath = string.Empty;
        private static string _nonSQLStagingPath = string.Empty;
        private static string _sqlStatingPath = string.Empty;
        private static int _progressCounter = 0;

        private static Label progressLabel;
        private static BackgroundWorker backgroundWorker;

        private enum _ServiceActionType { STOP, START };
        public enum LogEventType { MESSAGE, WARNING, ERROR };

        public static void Init(BackgroundWorker bgw, Label progressBarLabel, string branch, string sqlComparePath, string sourcePath, string environmentName)
        {
            _LogHeader();
            Log("_Init", LogEventType.MESSAGE, "_Init started.");

            backgroundWorker = bgw;
            progressLabel = progressBarLabel;

            #region Set Branch
            switch (branch)
            {
                case "Development":
                    _branch = "Development";
                    break;
                case "Main":
                    _branch = "Main";
                    break;
                case "Release":
                    _branch = "Release";
                    break;
                case "DevGL":
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
            Directory.CreateDirectory(_nonSQLOutputPath);
            Directory.CreateDirectory(_nonSQLOutputPathLocal);
            Directory.CreateDirectory(_sqlOutputPath);
            Directory.CreateDirectory(_sqlOutputPathLocal);
            Directory.CreateDirectory(_oldSqlPathLocal);
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
            _SetAllAttributesNormal("Builds");
            Directory.Delete("Builds", true);
            _AggregateNonSQL();
            _AggregateSQL();
            _RunSQLDeploymentBuilder(_oldSqlPath, _sqlOutputPathLocal + "\\" + _buildNumber);
            _CopyFilesToBuildsDirectory();
            _CopyFilesToDeploymentStaging();
            _BackupCurrentDeployment();
            _ManageServices(_ServiceActionType.STOP);
            _Deploy();
            _ExecuteSql();
            _ManageServices(_ServiceActionType.START);
            LogFooter();
        }

        private static void _AggregateNonSQL()
        {
            Log("_AggregateNonSQL", LogEventType.MESSAGE, "AggregateNonSQL started.");
            DeploymentManager._nantBuildFilePath = Directory.GetCurrentDirectory();
            DeploymentManager._BuildNantFile();
        }
        private static void _BuildNantFile()
        {
            Log("_BuildNantFile", LogEventType.MESSAGE, "_BuildNantFile started.");
            var nantStatusUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Running Nant", _progressCounter, _progressCounter += 10));
            nantStatusUpdateThread.Start();

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
                    streamWriter.WriteLine("<property name=\"NantOutputPath\" value=\"" + _nonSQLOutputPathLocal + "\\\"/>");
                    streamWriter.WriteLine("<property name=\"TargetAppServer\" value=\"" + DeploymentManager._targetAppServers[0] + "/${EnvName}\"/>");
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
            Log("_BuildNantFile", LogEventType.MESSAGE, "Nant.exe Process started.");
            var nantProcess = Process.Start("\"C:\\Program Files (x86)\\Nant\\bin\\NAnt.exe\"", "/f:\"" + Directory.GetCurrentDirectory() + "\\DeploymentNantBuild.build\"");

            while (!nantProcess.HasExited) { }
            File.Delete(tempFileName);
            nantStatusUpdateThread.Abort();
        }
        private static void _AggregateSQL()
        {
            Log("_AggregateSQL", LogEventType.MESSAGE, "_AggregateSQL started.");
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
            Log("_CopyRoot", LogEventType.MESSAGE, "_CopyRoot started.");
            var copyRootUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Copying Root", _progressCounter, _progressCounter += 10));
            copyRootUpdateThread.Start();

            DeploymentManager._postBuildOutputPath = DeploymentManager._sqlOutputPathLocal + "\\" + DeploymentManager._buildNumber + "\\PostBuild";
            Directory.CreateDirectory(DeploymentManager._postBuildOutputPath);
            foreach (string rootSqlDirectory in DeploymentManager._rootSQLDirectories)
            {
                string str1 = rootSqlDirectory;
                if (rootSqlDirectory == "\\OneOffs")
                    str1 = "\\SeedScripts";
                if (rootSqlDirectory == "\\Sequence")
                    str1 = "\\Tables";
                string str2 = DeploymentManager._sqlOutputPathLocal + "\\" + DeploymentManager._buildNumber + str1;
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
                            string path1 = DeploymentManager._sqlOutputPathLocal + "\\" + DeploymentManager._buildNumber + "\\" + str3;
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
            Log("_CopyMovementLifeCycle", LogEventType.MESSAGE, "_CopyMovementLifeCycle started.");
            var copyMovementLifeCycleProgressUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Combining Movement LifeCycle", _progressCounter, _progressCounter += 5));
            copyMovementLifeCycleProgressUpdateThread.Start();

            string str1 = DeploymentManager._sqlOutputPathLocal + "\\" + DeploymentManager._buildNumber + "\\";
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
            var copyAdditionalScriptsProgressUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Copying Additional Scripts", _progressCounter, _progressCounter += 5));
            copyAdditionalScriptsProgressUpdateThread.Start();

            string path1_1 = "GrantScript";
            string path1_2 = DeploymentManager._sqlOutputPathLocal + "\\" + DeploymentManager._buildNumber;
            File.Copy(Path.Combine(path1_1, "DB - Database_Grants_20160616.sql"), Path.Combine(path1_2, "DB - Database_Grants_20160616.sql"));
            File.Copy(Path.Combine("DeploymentScript", "SQLDeploymentPrepAndCopy_Add_Grants_Dev_Motiva.bat"), Path.Combine(path1_2, "SQLDeploymentPrepAndCopy_Add_Grants_Dev_Motiva.bat"));
            File.Copy(Path.Combine("DeploymentBuilder", "DeploymentBuilder.exe"), Path.Combine(path1_2, "DeploymentBuilder.exe"));

            copyAdditionalScriptsProgressUpdateThread.Abort();
        }
        private static void _CombineGrantScripts()
        {
            var combineGrantScriptsProgressUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Combining Grant Scripts", _progressCounter, _progressCounter += 5));
            combineGrantScriptsProgressUpdateThread.Start();

            string[] files = Directory.GetFiles(DeploymentManager._postBuildOutputPath);
            using (FileStream fileStream1 = File.Create(DeploymentManager._sqlOutputPathLocal + "\\" + DeploymentManager._buildNumber + "\\PostBuildScripts.sql"))
            {
                foreach (string path in files)
                {
                    using (FileStream fileStream2 = File.OpenRead(path))
                        fileStream2.CopyTo((Stream)fileStream1);
                }
            }

            combineGrantScriptsProgressUpdateThread.Abort();
        }
        private static void _RunSQLDeploymentBuilder(string oldSqlPath, string sqlOutputPath)
        {
            Log("_RunSQLDeploymentBuilder", LogEventType.MESSAGE, "_RunSQLDeploymentBuilder started.");
            var createSQLProgressUpdateThread = new Thread(() => DeploymentManager._StartNewProgressUpdateThread("Creating SQL File", _progressCounter, _progressCounter += 15));
            createSQLProgressUpdateThread.Start();

            #region compress decompress too slow
            //Copy old sql down to local

            //Log("_RunSQLDeploymentBuilder", LogEventType.MESSAGE, "Compressing and copying remote sql file.");

            ////Compress, Copy down, and Decompress
            //ZipFile.CreateFromDirectory(oldSqlPath, _oldSqlPathLocal+"\\tmp");

            //Log("_RunSQLDeploymentBuilder", LogEventType.MESSAGE, "Decompressing copied sql file.");
            //ZipFile.ExtractToDirectory(_oldSqlPathLocal+"\\tmp", _oldSqlPathLocal);
            //Log("_RunSQLDeploymentBuilder", LogEventType.MESSAGE, "Finished with copy.");

            //File.Delete(_oldSqlPathLocal + "\\tmp");
            #endregion

            _Robocopy(oldSqlPath, _oldSqlPathLocal);

            //Run what used to be the "Deployment Builder" that compares the 2 sql files
            DeploymentBuilder.Run(_oldSqlPathLocal, sqlOutputPath);

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

            //Rename the file
            File.Move(sqlBuildFilePath, sqlDeployFilePath);

            //Copy the final sql output back to its .NET directory for easy deployment
            File.Copy(sqlDeployFilePath, _nonSQLOutputPathLocal + fileName);

            //Delete our temporary local copy of the old sql
            //Directory.Delete(_oldSqlPathLocal, true);

            createSQLProgressUpdateThread.Abort();

        }
        private static void _CopyFilesToBuildsDirectory()
        {
            var copyToBuildsThread = new Thread(() => _StartNewProgressUpdateThread("Copying Files to Builds Directory", _progressCounter, _progressCounter += 5));
            copyToBuildsThread.Start();

            //Copy to Builds Directory
            _nonSQLOutputPath += "\\" + DeploymentManager._targetVirtualDirectory + "-" + DateTime.Now.ToString("yyyyMMdd-HHmm");
            Directory.CreateDirectory(_nonSQLOutputPath);
            Log("_CopyFilesToBuildsDirectory", LogEventType.MESSAGE, "Uploading nonsql files started.");
            _Robocopy(_nonSQLOutputPathLocal, _nonSQLOutputPath);
            Log("_CopyFilesToBuildsDirectory", LogEventType.MESSAGE, "Uploading sql files started.");
            _Robocopy(_sqlOutputPathLocal, _sqlOutputPath);

            copyToBuildsThread.Abort();
        }
        private static void _CopyFilesToDeploymentStaging()
        {
            var copyToStagingThread = new Thread(() => _StartNewProgressUpdateThread("Copying Files to Staging", _progressCounter, _progressCounter += 5));
            copyToStagingThread.Start();

            //delete old sql file
            foreach (string fileToDelete in Directory.GetFiles(_deploymentStagingPath, "*.sql"))
                File.Delete(fileToDelete);
            
            //Copy to Staging Directory
            Log("_CopyFilesToDeploymentStaging", LogEventType.MESSAGE, "Moving files to staging path.");
            _Robocopy(_nonSQLOutputPath, _deploymentStagingPath);

            Log("_CopyFilesToDeploymentStaging", LogEventType.MESSAGE, "CopyFilesToDeploymentStaging finished.");
            copyToStagingThread.Abort();
        }
        private static void _BackupCurrentDeployment()
        {
            Log("_BackupCurrentDeployment", LogEventType.MESSAGE, "BackupCurrentDeployment started.");
            var backupStatusUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Backing up current deployments", _progressCounter, _progressCounter += 10));
            backupStatusUpdateThread.Start();

            var backupPathRoot = ConfigurationManager.AppSettings.Get("BackupPath");
            var timeStamp = DateTime.Now.ToString("yyyymmddThhmmss");

            foreach (string server in _targetAppServers)
            {
                var currentDeploymentPath = "\\\\" + server + "\\" + _targetDeploymentPath + "\\Server";
                var backupPath = "\\\\" + server + "\\" + backupPathRoot + _targetEnvironment + "\\" + timeStamp + "\\Server";
                Directory.CreateDirectory(backupPath);
                _Robocopy(currentDeploymentPath, backupPath);
            }

            foreach (string server in _targetSMServers)
            {
                var currentDeploymentPath = "\\\\" + server + "\\" + _targetDeploymentPath + "\\Server";
                var backupPath = "\\\\" + server + "\\" + backupPathRoot + _targetEnvironment + "\\" + timeStamp + "\\Server";
                Directory.CreateDirectory(backupPath);
                _Robocopy(currentDeploymentPath, backupPath);
            }

            foreach (string server in _targetRAMQServers)
            {
                var currentDeploymentPath = "\\\\" + server + "\\" + _targetDeploymentPath + "\\RightAngleIV";
                var backupPath = "\\\\" + server + "\\" + backupPathRoot + _targetEnvironment + "\\" + timeStamp + "\\RightAngleIV";
                Directory.CreateDirectory(backupPath);
                _Robocopy(currentDeploymentPath, backupPath);
            }
            backupStatusUpdateThread.Abort();
        }
        private static void _ManageServices(_ServiceActionType type)
        {            
            Log("_ManageServices", LogEventType.MESSAGE, "Setting services to " + type);
            var manageServicesStatusUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Setting services to " + type, _progressCounter, _progressCounter += 5));
            manageServicesStatusUpdateThread.Start();
            try
            {
                //iis
                foreach (string serverName in _targetAppServers)
                {
                    ServiceController[] appServerServices = ServiceController.GetServices(serverName);
                    foreach (ServiceController service in appServerServices)
                    {
                        if (service.DisplayName.Contains(_targetEnvironment))
                        {
                            if (type == _ServiceActionType.STOP && service.CanStop)
                            {
                                service.Stop();
                            }
                            else if (type == _ServiceActionType.START)
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
                                if (type == _ServiceActionType.STOP && service.CanStop)
                                {
                                    service.Stop();
                                }
                                else if (type == _ServiceActionType.START)
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
                                if (type == _ServiceActionType.STOP && service.CanStop)
                                {
                                    service.Stop();
                                }
                                else if (type == _ServiceActionType.START)
                                {
                                    service.WaitForStatus(ServiceControllerStatus.Stopped);
                                    service.Start();
                                }
                            }
                        }
                    }
                }
            }catch(Exception ex)
            {
                manageServicesStatusUpdateThread.Abort();
                Log("_ManageServices", LogEventType.ERROR, "Message: " + ex.Message);
                Log("_ManageServices", LogEventType.ERROR, "Stack Trace: " + ex.StackTrace);
                LogFooter();
            }

            manageServicesStatusUpdateThread.Abort();

        }
        private static void _Deploy()
        {
            Log("_Deploy", LogEventType.MESSAGE, "_Deploy started.");
            var deployStatusUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Deploying app, sm, and ramq", _progressCounter, _progressCounter += 15));
            deployStatusUpdateThread.Start();

            foreach (string server in _targetAppServers)
            {
                var destinationPath = "\\\\" + server + "\\" + _targetDeploymentPath + "\\Server";
                var stagingPath = ConfigurationManager.AppSettings.Get("DeploymentStagingPath") + "\\" + _targetEnvironment + "\\Server";
                _Robocopy(stagingPath, destinationPath);

                ////Create all of the directories
                //var directories = Directory.GetDirectories(stagingPath, "*", System.IO.SearchOption.AllDirectories);
                //if (directories.Count() > 0)
                //{
                //    foreach (string dirPath in directories)
                //        Directory.CreateDirectory(dirPath.Replace(stagingPath, destinationPath));

                //    //Copy all the files & Replaces any files with the same name
                //    foreach (string newPath in Directory.GetFiles(stagingPath, "*.*", System.IO.SearchOption.AllDirectories))
                //    {
                //        //TODO: Need a better solution for this
                //        File.Copy(newPath, newPath.Replace(stagingPath, destinationPath), true);
                //    }
                //}
            }

            foreach (string server in _targetSMServers)
            {
                var destinationPath = "\\\\" + server + "\\" + _targetDeploymentPath + "\\Server";
                var stagingPath = ConfigurationManager.AppSettings.Get("DeploymentStagingPath") + "\\" + _targetEnvironment + "\\serviceServer";
                _Robocopy(stagingPath, destinationPath);
                ////Create all of the directories
                //var directories = Directory.GetDirectories(stagingPath, "*", System.IO.SearchOption.AllDirectories);
                //if (directories.Count() > 0)
                //{
                //    foreach (string dirPath in directories)
                //        Directory.CreateDirectory(dirPath.Replace(stagingPath, destinationPath));

                //    //Copy all the files & Replaces any files with the same name
                //    foreach (string newPath in Directory.GetFiles(stagingPath, "*.*", System.IO.SearchOption.AllDirectories))
                //    {
                //        //TODO: Need a better solution for this
                //        File.Copy(newPath, newPath.Replace(stagingPath, destinationPath), true);
                //    }
                //}
            }

            foreach (string server in _targetRAMQServers)
            {
                var destinationPath = "\\\\" + server + "\\" + _targetDeploymentPath + "\\RightAngleIV";
                var stagingPath = ConfigurationManager.AppSettings.Get("DeploymentStagingPath") + "\\" + _targetEnvironment + "\\RightAngleIV";
                _Robocopy(stagingPath, destinationPath);

                ////Create all of the directories
                //var directories = Directory.GetDirectories(stagingPath, "*", System.IO.SearchOption.AllDirectories);
                //if (directories.Count() > 0)
                //{
                //    foreach (string dirPath in directories)
                //        Directory.CreateDirectory(dirPath.Replace(stagingPath, destinationPath));

                //    //Copy all the files & Replaces any files with the same name
                //    foreach (string newPath in Directory.GetFiles(stagingPath, "*.*", System.IO.SearchOption.AllDirectories))
                //    {
                //        //TODO: Need a better solution for this
                //        File.Copy(newPath, newPath.Replace(stagingPath, destinationPath), true);
                //    }
                //}
            }
            deployStatusUpdateThread.Abort();
        }
        private static void _ExecuteSql()
        {
            Log("_ExecuteSql", LogEventType.MESSAGE, "_ExecuteSql started.");
            var executeSqlUpdateThread = new Thread(() => _StartNewProgressUpdateThread("Executing SQL", _progressCounter, _progressCounter += 5));
            executeSqlUpdateThread.Start();

            var connectionString = "Persist Security Info=False;Integrated Security=true;Initial Catalog=" + _targetDatabase + ";server=" + _targetSQLServer;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                Server db = new Server(new ServerConnection(conn));

                var sqlFileName = Directory.GetFiles(_deploymentStagingPath, "*sql", System.IO.SearchOption.TopDirectoryOnly).First();

                string data = File.ReadAllText(sqlFileName);

                db.ConnectionContext.ExecuteNonQuery(data);
            }
            executeSqlUpdateThread.Abort();
        }

        //Helpers
        private static void _SetAllAttributesNormal(string directory)
        {
            foreach (var subDir in Directory.GetDirectories(directory))
            {
                var directoryInfo = new DirectoryInfo(directory);
                directoryInfo.Attributes = FileAttributes.Normal; 
                _SetAllAttributesNormal(subDir);
            }
            foreach (var file in Directory.GetFiles(directory))
            {
                File.SetAttributes(file, FileAttributes.Normal);
            }
        }
        private static void _Robocopy(string sourcePath, string destinationPath)
        {
            using (Process p = new Process())
            {
                p.StartInfo.Arguments = string.Format("/C ROBOCOPY {0} {1} {2}", "/E /MT", "\"" + sourcePath + "\"", "\"" + destinationPath + "\"");
                p.StartInfo.FileName = "CMD.EXE";
                p.StartInfo.CreateNoWindow = true;
                p.StartInfo.UseShellExecute = false;
                p.Start();
                p.WaitForExit();
            }
        }
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
        private static void _LogHeader()
        {
            File.AppendAllText("log.txt", "-------------------------------------------------------------------------------" + System.Environment.NewLine);
            File.AppendAllText("log.txt", "-Deployment Manager Started" + System.Environment.NewLine);
            File.AppendAllText("log.txt", "-------------------------------------------------------------------------------" + System.Environment.NewLine);
        }
        public static void LogFooter()
        {
            File.AppendAllText("log.txt", "-------------------------------------------------------------------------------\n");
            File.AppendAllText("log.txt", "-Deployment Manager Ended\n");
            File.AppendAllText("log.txt", "-------------------------------------------------------------------------------\n");
        }
        public static void Log(string methodName, LogEventType type, string message)
        {
            string logEntry = String.Format("{0,-15} | {1,-7} | {2,-30} | {3}", DateTime.Now.ToString("yyyyMMdd_HHmmss"), type, methodName, message + System.Environment.NewLine);
            File.AppendAllText("log.txt", logEntry);
        }

    }
}

