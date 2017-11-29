using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;

namespace DeploymentManager
{
  static class DeploymentManager
  {
    private static bool ISDEBUG = false;
    private static string _environment = string.Empty;
    private static string _targetAppServer = string.Empty;
    private static string _sourcePath = string.Empty;
    private static string _branch = string.Empty;
    private static string _nonSQLOutputPath = ConfigurationManager.AppSettings.Get("LocalNonSQLOutputPath"); 
    private static string _sqlOutputPath = ConfigurationManager.AppSettings.Get("LocalSQLOutputPath"); 
    private static string _nantBuildFilePath = "";
    private static string _rootSQLPath = string.Empty;
    private static string _motivaSQLPath = string.Empty;
    private static string _movementLiveCycleSQLPath = string.Empty;
    private static string _buildNumber = string.Empty;
    private static string _postBuildOutputPath = string.Empty;
    private static List<string> rootSQLDirectories = new List<string>();

    public static void Run()
    {
        DeploymentManager._Init();
        DeploymentManager._AggregateNonSQL();
        DeploymentManager._AggregateSQL();
        if (!DeploymentManager.ISDEBUG)
        return;
        DeploymentManager._DebugOutput();
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
        while (DeploymentManager._targetAppServer == string.Empty)
        DeploymentManager._GetUserSelectionEnvironment();
        while (DeploymentManager._branch == string.Empty)
        DeploymentManager._GetUserSelectionBranch();
        while (DeploymentManager._sourcePath == string.Empty)
        DeploymentManager._GetUserSourcePath();
        DeploymentManager._BuildNantFile();
    }

    private static void _AggregateSQL()
    {
        DeploymentManager._rootSQLPath = DeploymentManager._sourcePath + "\\RightAngle\\" + DeploymentManager._branch;
        DeploymentManager._motivaSQLPath = DeploymentManager._rootSQLPath + "\\Motiva.SQL\\Motiva.RightAngle.SQL";
        DeploymentManager._movementLiveCycleSQLPath = DeploymentManager._rootSQLPath + "\\MTVMovementLifeCycle\\SQL";
        DeploymentManager._buildNumber = "SQL_" + ((IEnumerable<string>) DeploymentManager._environment.Split('.')).Last<string>() + "_" + DateTime.Now.ToString("yyyyMMdd_HHmmss");
        DeploymentManager._CopyRoot();
        DeploymentManager._CopyMovementLifeCycle();
        DeploymentManager._CopyAdditionalScripts();
        DeploymentManager._CombineGrantScripts();
    }

    private static void _DebugOutput()
    {
        Console.WriteLine("\n**Debug Output**");
        Console.WriteLine("Target App Server: " + DeploymentManager._targetAppServer);
        Console.WriteLine("Envrionment:" + DeploymentManager._environment);
        Console.WriteLine("Branch: " + DeploymentManager._branch);
        Console.WriteLine("Source Path: " + DeploymentManager._sourcePath);
        Console.ReadKey();
    }

    private static void _GetUserSelectionEnvironment()
    {
        Console.WriteLine("\nPlease select target environment");
        Console.WriteLine("(1) Sandbox");
        Console.WriteLine("(2) Functional2");
        Console.WriteLine("(3) TEST");
        Console.WriteLine("(4) RegressDev");
        Console.WriteLine("(5) RA_UAT2");
        Console.WriteLine("(6) RAIVStarterS15");
        Console.WriteLine("(7) RAProd_Triage");
        Console.WriteLine("(8) Functional1");
        Console.WriteLine("(9) TrainingClass");
        Console.WriteLine("(10) DataLoadTest");
        Console.WriteLine("(11) Redbox");
        Console.WriteLine("(000) Production");
        string s = Console.ReadLine();
        
        if (s == "1")
        {
            DeploymentManager._targetAppServer = "MOTAPPDEV3001.motivadev.dev";
            DeploymentManager._environment = "RightAngle.15.0.Sandbox";
            return;
        }
        else if (s == "2")
        {
            DeploymentManager._targetAppServer = "MOTAPPDEV3001.motivadev.dev";
            DeploymentManager._environment = "RightAngle.15.0.Functional2";
            return;
        }
        else if (s == "3")
        {
            DeploymentManager._targetAppServer = "MOTAPPDEV3001.motivadev.dev";
            DeploymentManager._environment = "RightAngle.Test";
            return;
        }
        else if (s == "4")
        {
            DeploymentManager._targetAppServer = "MOTAPPDEV3001.motivadev.dev";
            DeploymentManager._environment = "RightAngle.15.0.RegressDev";
            return;
        }
        else if (s == "5")
        {
            DeploymentManager._targetAppServer = "MOTAPPQA13001.MotivaDev.Dev";
            DeploymentManager._environment = "RightAngle.RAUAT2";
            return;
        }
        else if (s == "6")
        {
            DeploymentManager._targetAppServer = "MOTAPPQA13001.MotivaDev.Dev";
            DeploymentManager._environment = "RightAngle.Starter";
            return;
        }
        else if (s == "7")
        {
            DeploymentManager._targetAppServer = "MOTAPPQA13001.MotivaDev.Dev";
            DeploymentManager._environment = "RightAngle.15.0.ProdTriage";
            return;
        }
        else if (s == "8")
        {
            DeploymentManager._targetAppServer = "MOTAPPTST3001.MotivaDev.Dev";
            DeploymentManager._environment = "RightAngle.Functional1";
            return;
        }
        else if (s == "9")
        {
            DeploymentManager._targetAppServer = "MOTAPPTST3001.MotivaDev.Dev";
            DeploymentManager._environment = "RightAngle.15.0.TrainingClass";
            return;
        }
        else if (s == "10")
        {
            DeploymentManager._targetAppServer = "MOTAPPTST3001.MotivaDev.Dev";
            DeploymentManager._environment = "RightAngle.DataLoadTest";
            return;
        }
        else if (s == "11")
        {
            DeploymentManager._targetAppServer = "MOTAPPQA13001.MotivaDev.Dev";
            DeploymentManager._environment = "RightAngle.Redbox";
            return;
        }
        else if (s == "000")
        {
            DeploymentManager._targetAppServer = "Motiisprdvip5.motiva.prv";
            DeploymentManager._environment = "RightAngle.Prod";
            DeploymentManager._branch = "Release";
            return;
        }
        else
        {
            Console.WriteLine("Please make a valid selection\n");
        }
        }

    private static void _GetUserSelectionBranch()
    {
        Console.WriteLine("\nPlease select target branch");
        Console.WriteLine("(1) Development");
        Console.WriteLine("(2) Main");
        Console.WriteLine("(3) Release");
        string str = Console.ReadLine();
        if (!(str == "1"))
        {
            if (!(str == "2"))
            {
                if (str == "3")
                    DeploymentManager._branch = "Release";
                else
                    Console.WriteLine("Please make a valid selection\n");
            }
            else
                DeploymentManager._branch = "Main";
        }
        else
            DeploymentManager._branch = "Development";
    }

    private static void _GetUserSourcePath()
    {
        Console.WriteLine("\nPlease provide source filepath:");
        string path = Console.ReadLine();
        if (Directory.Exists(path))
            DeploymentManager._sourcePath = path;
        else
            Console.WriteLine("Path doesn't exist.  Please enter a valid source path.");
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
                streamWriter.WriteLine("<property name=\"EnvName\" value=\"" + DeploymentManager._environment + "\"/> <!-- must match IIS virtual directory name -->");
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
        Process.Start("\"C:\\Program Files (x86)\\Nant\\bin\\NAnt.exe\"", "/f:\"" + Directory.GetCurrentDirectory() + "\\DeploymentNantBuild.build\"");
        File.Delete(tempFileName);
    }

    private static void _CopyRoot()
    {
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
    }

    private static void _CopyMovementLifeCycle()
    {
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
    }

    private static void _CopyAdditionalScripts()
    {
        string path1_1 = "GrantScript";
        string path1_2 = DeploymentManager._sqlOutputPath + "\\" + DeploymentManager._buildNumber;
        File.Copy(Path.Combine(path1_1, "DB - Database_Grants_20160616.sql"), Path.Combine(path1_2, "DB - Database_Grants_20160616.sql"));
        File.Copy(Path.Combine("DeploymentScript", "SQLDeploymentPrepAndCopy_Add_Grants_Dev_Motiva.bat"), Path.Combine(path1_2, "SQLDeploymentPrepAndCopy_Add_Grants_Dev_Motiva.bat"));
        File.Copy(Path.Combine("DeploymentBuilder", "DeploymentBuilder.exe"), Path.Combine(path1_2, "DeploymentBuilder.exe"));
    }

    private static void _CombineGrantScripts()
    {
        string[] files = Directory.GetFiles(DeploymentManager._postBuildOutputPath);
        using (FileStream fileStream1 = File.Create(DeploymentManager._sqlOutputPath + "\\" + DeploymentManager._buildNumber + "\\PostBuildScripts.sql"))
        {
            foreach (string path in files)
            {
                using (FileStream fileStream2 = File.OpenRead(path))
                    fileStream2.CopyTo((Stream)fileStream1);
            }
        }
    }
    }
}
