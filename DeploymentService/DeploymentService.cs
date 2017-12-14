using DeploymentManager_GUI;
using Microsoft.SqlServer.Management.Common;
using Microsoft.SqlServer.Management.Smo;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceProcess;
using System.Text;

namespace DeploymentManagerWCFService
{
    public class DeploymentService : IDeploymentService
    {
        DeploymentDTO dto;
        string now = DateTime.Now.ToString("yyyyMMdd-HHmm");
        string nantBuildFilePath = ConfigurationManager.AppSettings.Get("nantBuildFilePath");

        private enum ServiceActionType { STOP, START };
        public enum LogEventType { MESSAGE, WARNING, ERROR };

        public void Deploy(DeploymentDTO deploymentDTO)
        {
            Stopwatch sw = Stopwatch.StartNew();

            dto = deploymentDTO;

            _LogHeader();
            _Log("Deploy", LogEventType.MESSAGE, "started.");

            _DecompressSource();
            _AggregateNonSQL();
            _AggregateSQL();
            _RunSQLDeploymentBuilder();
            _CopyFilesToDeploymentStaging();
            _BackupCurrentDeployment();
            _ManageServices(ServiceActionType.STOP);
            _Deploy();
            _ExecuteSql();
            _ManageServices(ServiceActionType.START);

            sw.Stop();
            _Log("Deploy", LogEventType.MESSAGE, "finished.");
            string elapsed = sw.Elapsed.Minutes + ":" + sw.Elapsed.Seconds + ":" + sw.Elapsed.Milliseconds;
            _Log("Deploy", LogEventType.MESSAGE, "Elapsed Service Time " + elapsed);

        }

        //Helpers
        private void _DecompressSource()
        {
            _Log("_DecompressSource", LogEventType.MESSAGE, "started.");

            var argString = "x \"" + dto.ServerSourcePath + "\\source.7z\" -o\"" + dto.ServerSourcePath + "\"";
            var zipProcess = Process.Start("C:\\DeploymentManager\\bin\\7zip\\7za.exe", argString);
            while (!zipProcess.HasExited) { }

            _Log("_DecompressSource", LogEventType.MESSAGE, "finished.");
        }
        private void _AggregateNonSQL()
        {
            _BuildNantFile();
            _RunNant();
        }
        private void _BuildNantFile()
        {
            _Log("_BuildNantFile", LogEventType.MESSAGE, "started");

            dto.NonSQLOutputPath += "\\" + dto.VirtualEnvironmentName + "-" + now;
            Directory.CreateDirectory(dto.NonSQLOutputPath);

            string tempFileName = Path.GetTempFileName();
            string templatePath = ConfigurationManager.AppSettings.Get("nantBuildFileTemplatePath");
            using (StreamWriter streamWriter = new StreamWriter(tempFileName))
            {
                using (StreamReader streamReader = new StreamReader(templatePath))
                {
                    streamWriter.WriteLine("<project name=\"YourApp\" default=\"do-build\" xmlns=\"http://nant.sf.net/release/0.85-rc4/nant.xsd\">");
                    streamWriter.WriteLine("<!-- Version settings -->");
                    streamWriter.WriteLine();
                    streamWriter.WriteLine("<property name=\"EnvName\" value=\"" + dto.VirtualEnvironmentName + "\"/> <!-- must match IIS virtual directory name -->");
                    streamWriter.WriteLine("<property name=\"NantOutputPath\" value=\"" + dto.NonSQLOutputPath + "\\\"/>");
                    streamWriter.WriteLine("<property name=\"TargetAppServer\" value=\"" + dto.TargetAppServers[0] + "/${EnvName}\"/>");
                    streamWriter.WriteLine("<property name=\"build.output\" value=\"" + dto.ServerSourcePath + "\\" + dto.Branch + "\\Motiva.RightAngle\"/>");
                    streamWriter.WriteLine("<property name=\"build.powerbuilder\" value=\"" + dto.ServerSourcePath + "\\" + dto.Branch + "\\Motiva.RightAngle.PB\"/>");
                    streamWriter.WriteLine("<property name=\"build.outputAcctgFrmeWrk\" value=\"" + dto.ServerSourcePath + "\\" + dto.Branch + "\\CustomAccountingFramework\\Custom.Server.ConfigurationData\"/>");
                    streamWriter.WriteLine("<property name=\"build.outputExchangeFrmeWrk\" value=\"" + dto.ServerSourcePath + "\\" + dto.Branch + "\\Exchange Integration\\\"/>");
                    streamWriter.WriteLine("<property name=\"build.outputGlobalViewFrmeWrk\" value=\"" + dto.ServerSourcePath + "\\" + dto.Branch + "\\GlobalView\\\"/>");
                    streamWriter.WriteLine("<property name=\"build.outputMovementLifeCycle\" value=\"" + dto.ServerSourcePath + "\\" + dto.Branch + "\\MTVMovementLifeCycle\\OutPut\\\"/>");
                    streamWriter.WriteLine("<property name=\"Interfacebuild.output\" value=\"" + dto.ServerSourcePath + "\\" + dto.Branch + "\\Motiva.RightAngle.Interfaces\"/>");
                    while (!streamReader.EndOfStream)
                        streamWriter.WriteLine(streamReader.ReadLine());
                }
            }
            string destFileName = ConfigurationManager.AppSettings.Get("nantBuildFilePath");
            File.Copy(tempFileName, destFileName, true);

            _Log("_BuildNantFile", LogEventType.MESSAGE, "finished");
        }
        private void _RunNant()
        {
            _Log("_RunNant", LogEventType.MESSAGE, "started.");

            var argString = "/f:C:\\DeploymentManager\\bin\\Nant\\DeploymentNantBuild.build";
            var nantProcess = Process.Start("C:\\DeploymentManager\\bin\\Nant\\bin\\NAnt.exe", argString);
            while (!nantProcess.HasExited) { }

            _Log("_RunNant", LogEventType.MESSAGE, "finished.");
        }
        private void _AggregateSQL()
        {
            _Log("_AggregateSQL", LogEventType.MESSAGE, "started");
            dto.RootSQLPath = dto.ServerSourcePath + "\\" + dto.Branch;
            dto.MotivaSQLPath = dto.RootSQLPath + "\\Motiva.SQL\\Motiva.RightAngle.SQL";
            dto.MovementLifecyclePath = dto.RootSQLPath + "\\MTVMovementLifeCycle\\SQL";
            dto.BuildNumber = "SQL_" + ((IEnumerable<string>)dto.VirtualEnvironmentName.Split('.')).Last<string>() + "_" + now;

            _CopyRoot();
            _CopyMovementLifeCycle();
            _CopyAdditionalScripts();
            _CombineGrantScripts();

            _Log("_AggregateSQL", LogEventType.MESSAGE, "finished");
        }
        private void _CopyRoot()
        {
            _Log("_CopyRoot", LogEventType.MESSAGE, "started.");

            dto.PostBuildOutputPath = dto.SQLOutputPath + "\\" + dto.BuildNumber + "\\PostBuild";
            Directory.CreateDirectory(dto.PostBuildOutputPath);
            foreach (string rootSqlDirectory in dto.RootSQLDirectories)
            {
                string str1 = rootSqlDirectory;
                if (rootSqlDirectory == "\\OneOffs")
                    str1 = "\\SeedScripts";
                if (rootSqlDirectory == "\\Sequence")
                    str1 = "\\Tables";
                string str2 = dto.SQLOutputPath + "\\" + dto.BuildNumber + str1;
                if (!Directory.Exists(str2) && !str2.Contains("CustomAccountingFramework"))
                    Directory.CreateDirectory(str2);
                string[] files = Directory.GetFiles(dto.MotivaSQLPath + rootSqlDirectory, "*.sql");
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
                                    File.Copy(files[index], Path.Combine(dto.PostBuildOutputPath, ((IEnumerable<string>)files[index].Split('\\')).Last<string>()), true);
                                    continue;
                                }
                                continue;
                            }
                        }
                        else if (rootSqlDirectory.Contains("CustomAccountingFramework"))
                        {
                            string str3 = ((IEnumerable<string>)rootSqlDirectory.Split('\\')).Last<string>();
                            string path1 = dto.SQLOutputPath + "\\" + dto.BuildNumber + "\\" + str3;
                            File.Copy(files[index], Path.Combine(path1, ((IEnumerable<string>)files[index].Split('\\')).Last<string>()), true);
                            continue;
                        }
                        File.Copy(files[index], Path.Combine(str2, ((IEnumerable<string>)files[index].Split('\\')).Last<string>()), true);
                    }
                }
            }

            _Log("_CopyRoot", LogEventType.MESSAGE, "finished.");

        }
        private void _CopyMovementLifeCycle()
        {
            _Log("_CopyMovementLifeCycle", LogEventType.MESSAGE, "started.");

            string str1 = dto.SQLOutputPath + "\\" + dto.BuildNumber + "\\";
            string str2 = string.Empty;
            string[] files = Directory.GetFiles(dto.MovementLifecyclePath, "*.sql");
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

            _Log("_CopyMovementLifeCycle", LogEventType.MESSAGE, "finished.");
        }
        private void _CopyAdditionalScripts()
        {
            _Log("_CopyAdditionalScripts", LogEventType.MESSAGE, "started.");

            string path1_1 = "C:\\DeploymentManager\\bin\\SQL\\GrantScript";
            string path1_2 = dto.SQLOutputPath + "\\" + dto.BuildNumber;
            File.Copy(Path.Combine(path1_1, "DB - Database_Grants_20160616.sql"), Path.Combine(path1_2, "DB - Database_Grants_20160616.sql"));
            File.Copy(Path.Combine("C:\\DeploymentManager\\bin\\SQL\\DeploymentScript", "SQLDeploymentPrepAndCopy_Add_Grants_Dev_Motiva.bat"), Path.Combine(path1_2, "SQLDeploymentPrepAndCopy_Add_Grants_Dev_Motiva.bat"));
            File.Copy(Path.Combine("C:\\DeploymentManager\\bin\\SQL\\DeploymentBuilder", "DeploymentBuilder.exe"), Path.Combine(path1_2, "DeploymentBuilder.exe"));

            _Log("_CopyAdditionalScripts", LogEventType.MESSAGE, "finished.");
        }
        private void _CombineGrantScripts()
        {
            _Log("_CombineGrantScripts", LogEventType.MESSAGE, "started.");

            string[] files = Directory.GetFiles(dto.PostBuildOutputPath);
            using (FileStream fileStream1 = File.Create(dto.SQLOutputPath + "\\" + dto.BuildNumber + "\\PostBuildScripts.sql"))
            {
                foreach (string path in files)
                {
                    using (FileStream fileStream2 = File.OpenRead(path))
                        fileStream2.CopyTo((Stream)fileStream1);
                }
            }

            _Log("_CombineGrantScripts", LogEventType.MESSAGE, "finished.");
        }
        private void _RunSQLDeploymentBuilder()
        {
            _Log("_RunSQLDeploymentBuilder", LogEventType.MESSAGE, "started.");

            //Run what used to be the "Deployment Builder" that compares the 2 sql files
            DeploymentBuilder.Run(dto.SQLComparePath, dto.SQLOutputPath + "\\" + dto.BuildNumber);

            string sqlBuildFilePath = dto.SQLOutputPath + "\\" + dto.BuildNumber + "\\SQLBuild.sql";
            string baseGrantsFilePath = dto.SQLOutputPath + "\\" + dto.BuildNumber + "\\DB - Database_Grants_20160616.sql";

            using (Stream input = File.OpenRead(baseGrantsFilePath))
            using (Stream output = new FileStream(sqlBuildFilePath, FileMode.Append,
                                                  FileAccess.Write, FileShare.None))
            {
                input.CopyTo(output);
            }

            string fileName = "\\SQLDeploy_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".sql";
            string sqlDeployFilePath = dto.SQLOutputPath + "\\" + dto.BuildNumber + fileName;

            //Rename the file
            File.Move(sqlBuildFilePath, sqlDeployFilePath);

            //Copy the final sql output back to its .NET directory for easy deployment
            File.Copy(sqlDeployFilePath, dto.NonSQLOutputPath + fileName);

            _Log("_RunSQLDeploymentBuilder", LogEventType.MESSAGE, "finished.");

        }
        private void _CopyFilesToDeploymentStaging()
        {
            _Log("_CopyFilesToDeploymentStaging", LogEventType.MESSAGE, "started.");

            if (dto.VirtualEnvironmentName.Contains("15.0"))
                dto.DeploymentStagingPath += "\\15.0." + dto.EnvironmentName;
            else
                dto.DeploymentStagingPath += "\\" + dto.EnvironmentName;

            //Create the directory if its missing
            Directory.CreateDirectory(dto.DeploymentStagingPath);

            //delete old sql file from previous deployment
            foreach (string fileToDelete in Directory.GetFiles(dto.DeploymentStagingPath, "*.sql"))
                File.Delete(fileToDelete);

            //Delete uploaded source
            _SetAllAttributesNormal(dto.ServerSourcePath);
            Directory.Delete(dto.ServerSourcePath, true);

            //Copy to Staging Directory
            _Robocopy(dto.NonSQLOutputPath, dto.DeploymentStagingPath);

            _Log("_CopyFilesToDeploymentStaging", LogEventType.MESSAGE, "finished.");
        }
        private void _BackupCurrentDeployment()
        {
            _Log("_BackupCurrentDeployment", LogEventType.MESSAGE, "started.");

            if (dto.VirtualEnvironmentName.Contains("15.0"))
            {
                dto.DeploymentPath += "\\15.0." + dto.EnvironmentName;
                dto.BackupPath += "\\15.0." + dto.EnvironmentName;
            }
            else
            {
                dto.DeploymentPath += "\\" + dto.EnvironmentName;
                dto.BackupPath += "\\" + dto.EnvironmentName;
            }

            var backupPathRoot = dto.BackupPath;
            var timeStamp = DateTime.Now.ToString("yyyyMMddTHHmmss");

            _Log("_BackupCurrentDeployment", LogEventType.MESSAGE, "Backing up app servers.");
            foreach (string server in dto.TargetAppServers)
            {
                var currentDeploymentPath = "\\\\" + server + "\\" + dto.DeploymentPath + "\\Server";
                var backupPath = "\\\\" + server + "\\" + dto.BackupPath + "\\" + timeStamp + "\\Server";
                Directory.CreateDirectory(backupPath);
                _Robocopy(currentDeploymentPath, backupPath);
            }

            _Log("_BackupCurrentDeployment", LogEventType.MESSAGE, "Backing up SM servers.");
            foreach (string server in dto.TargetSMServers)
            {
                var currentDeploymentPath = "\\\\" + server + "\\" + dto.DeploymentPath + "\\Server";
                var backupPath = "\\\\" + server + "\\" + dto.BackupPath + "\\" + timeStamp + "\\Server";
                Directory.CreateDirectory(backupPath);
                _Robocopy(currentDeploymentPath, backupPath);
            }

            _Log("_BackupCurrentDeployment", LogEventType.MESSAGE, "Backing up RAMQ servers.");
            foreach (string server in dto.TargetRAMQServers)
            {
                var currentDeploymentPath = "\\\\" + server + "\\" + dto.DeploymentPath + "\\RightAngleIV";
                var backupPath = "\\\\" + server + "\\" + dto.BackupPath + "\\" + timeStamp + "\\RightAngleIV";
                Directory.CreateDirectory(backupPath);
                _Robocopy(currentDeploymentPath, backupPath);
            }

            _Log("_BackupCurrentDeployment", LogEventType.MESSAGE, "finished.");
        }
        private void _ManageServices(ServiceActionType type)
        {
            _Log("_ManageServices", LogEventType.MESSAGE, "Setting services to " + type);

            //iis
            try
            {
                _Log("_ManageServices", LogEventType.MESSAGE, type + " services on App servers.");
                foreach (string serverName in dto.TargetAppServers)
                {
                    ServiceController[] appServerServices = ServiceController.GetServices(serverName);
                    foreach (ServiceController service in appServerServices)
                    {
                        if (service.DisplayName.Contains(dto.EnvironmentName))
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
            }catch(Exception ex)
            {
                _Log("_ManageServices", LogEventType.ERROR, ex.Message);
            }

            //sm
            try
            {
                _Log("_ManageServices", LogEventType.MESSAGE, type + " services on SM servers.");
                foreach (string serverName in dto.TargetSMServers)
                {
                    ServiceController[] appServerServices = ServiceController.GetServices(serverName);
                    foreach (ServiceController service in appServerServices)
                    {
                        if (service.DisplayName.Contains("Service Monitor"))
                        {
                            if (service.DisplayName.Contains(dto.EnvironmentName))
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
            }
            catch (Exception ex)
            {
                _Log("_ManageServices", LogEventType.ERROR, ex.Message);
            }

            //ramq
            try { 
                _Log("_ManageServices", LogEventType.MESSAGE, type + " services on RAMQ servers.");
                foreach (string serverName in dto.TargetRAMQServers)
                {
                    ServiceController[] appServerServices = ServiceController.GetServices(serverName);
                    foreach (ServiceController service in appServerServices)
                    {
                        if (service.DisplayName.Contains("RAMQ"))
                        {
                            if (service.DisplayName.Contains(dto.EnvironmentName))
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
            }
            catch (Exception ex)
            {
                _Log("_ManageServices", LogEventType.ERROR, ex.Message);
            }

            _Log("_ManageServices", LogEventType.MESSAGE, "finished.");
        }
        private void _Deploy()
        {
            _Log("_Deploy", LogEventType.MESSAGE, "started.");

            _Log("_Deploy", LogEventType.MESSAGE, "Deploying to App servers.");
            foreach (string server in dto.TargetAppServers)
            {
                var destinationPath = "\\\\" + server + "\\" + dto.DeploymentPath + "\\Server";
                var stagingPath = dto.DeploymentStagingPath + "\\Server";
                _Robocopy(stagingPath, destinationPath);
            }

            _Log("_Deploy", LogEventType.MESSAGE, "Deploying to SM servers.");
            foreach (string server in dto.TargetSMServers)
            {
                var destinationPath = "\\\\" + server + "\\" + dto.DeploymentPath + "\\Server";
                var stagingPath = dto.DeploymentStagingPath + "\\serviceServer";
                _Robocopy(stagingPath, destinationPath);
            }

            _Log("_Deploy", LogEventType.MESSAGE, "Deploying to RAMQ servers.");
            foreach (string server in dto.TargetRAMQServers)
            {
                var destinationPath = "\\\\" + server + "\\" + dto.DeploymentPath + "\\RightAngleIV";
                var stagingPath = dto.DeploymentStagingPath + "\\RightAngleIV";
                _Robocopy(stagingPath, destinationPath);
            }

            _Log("_Deploy", LogEventType.MESSAGE, "finished.");
        }
        private void _ExecuteSql()
        {
            _Log("_ExecuteSql", LogEventType.MESSAGE, "started.");

            try
            {
                #region old way
                //var connectionString = "Persist Security Info=False;Integrated Security=true;Initial Catalog=" + dto.Database + ";server=" + dto.SQLServer;
                //using (SqlConnection conn = new SqlConnection(connectionString))
                //{
                //    Server db = new Server(new ServerConnection(conn));

                //    var sqlFileName = Directory.GetFiles(dto.DeploymentStagingPath, "*sql", System.IO.SearchOption.TopDirectoryOnly).First();

                //    string data = File.ReadAllText(sqlFileName);

                //    db.ConnectionContext.ExecuteNonQuery(data);
                //}
                #endregion
                var sqlFileName = Directory.GetFiles(dto.DeploymentStagingPath, "*sql", System.IO.SearchOption.TopDirectoryOnly).First();
                var argString = @"-S " + dto.SQLServer + "-E -i" + sqlFileName;
                var zipProcess = Process.Start("sqlcmd.exe", argString);

            }
            catch(Exception ex)
            {
                _Log("_ExecuteSql", LogEventType.ERROR, ex.Message);
            }

            _Log("_ExecuteSql", LogEventType.MESSAGE, "finished.");
        }

        // File/Folder Attribute Helper
        private void _SetAllAttributesNormal(string directory)
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

        //Robocopy Helper
        private void _Robocopy(string sourcePath, string destinationPath)
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

        //Log Helpers
        private void _LogHeader()
        {
            File.AppendAllText("C:\\DeploymentManager\\log.txt", "-------------------------------------------------------------------------------" + System.Environment.NewLine);
            File.AppendAllText("C:\\DeploymentManager\\log.txt", "-Deployment Manager Started" + System.Environment.NewLine);
            File.AppendAllText("C:\\DeploymentManager\\log.txt", "-------------------------------------------------------------------------------" + System.Environment.NewLine);
        }
        private void _LogFooter()
        {
            File.AppendAllText("C:\\DeploymentManager\\log.txt", "-------------------------------------------------------------------------------\n");
            File.AppendAllText("C:\\DeploymentManager\\log.txt", "-Deployment Manager Ended\n");
            File.AppendAllText("C:\\DeploymentManager\\log.txt", "-------------------------------------------------------------------------------\n");
        }
        private void _Log(string methodName, LogEventType type, string message)
        {
            string logEntry = String.Format("{0,-15} | {1,-7} | {2,-30} | {3}", DateTime.Now.ToString("yyyyMMdd_HHmmss"), type, methodName, message + System.Environment.NewLine);
            File.AppendAllText("C:\\DeploymentManager\\log.txt", logEntry);
        }

    }
}
