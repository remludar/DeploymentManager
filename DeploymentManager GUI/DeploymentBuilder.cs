using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace DeploymentManager_GUI
{
    public static class DeploymentBuilder
    {
        private static string sqlFileNameShort = "SQLBuild";
        private static string sqlBuildFileName = String.Empty;
        private static string pathOld;
        private static string pathNew;
        private static List<string> subDirectories = new List<string>()
        {
          "Tables",
          "Constraints",
          "Triggers",
          "Functions",
          "Views",
          "StoredProcedures",
          "SeedScripts"
        };
        private static string breakLine = "------------------------------------------------------------------------------------------------------------------";
        private static string beginOf = "--Begining Of {0}";
        private static string endOf = "--Ending Of {0}";

        public static void Run(string oldPath, string newPath)
        {
            pathOld = oldPath;
            pathNew = newPath;
            BuildSQLFile();
        }

        private static void BuildSQLFile()
        {
            sqlBuildFileName = sqlFileNameShort + ".sql";
            BuildSQLFile(pathNew, pathOld, pathNew);
        }

        private static void BuildSQLFile(string sourceDirectory, string compareDirectory, string outputDirectory)
        {

            var createSQLProgressUpdateThread = new Thread(() => DeploymentManager.StartNewProgressUpdateThread("Creating SQL File", 65, 100));
            createSQLProgressUpdateThread.Start();

            DirectoryInfo directory1 = new DirectoryInfo(sourceDirectory);
            DirectoryInfo directoryInfo = new DirectoryInfo(outputDirectory);
            DirectoryInfo directory2 = ((IEnumerable<DirectoryInfo>)directory1.GetDirectories("PreBuild")).FirstOrDefault<DirectoryInfo>();
            DirectoryInfo directory3 = ((IEnumerable<DirectoryInfo>)directory1.GetDirectories("PostBuild")).FirstOrDefault<DirectoryInfo>();
            DirectoryInfo compareDirectory1 = (DirectoryInfo)null;
            DirectoryInfo compareDirectory2 = (DirectoryInfo)null;
            DirectoryInfo compareDirectory3 = (DirectoryInfo)null;
            if (!string.IsNullOrEmpty(compareDirectory))
            {
                compareDirectory1 = new DirectoryInfo(compareDirectory);
                compareDirectory2 = ((IEnumerable<DirectoryInfo>)compareDirectory1.GetDirectories("PreBuild")).FirstOrDefault<DirectoryInfo>();
                compareDirectory3 = ((IEnumerable<DirectoryInfo>)compareDirectory1.GetDirectories("PostBuild")).FirstOrDefault<DirectoryInfo>();
            }
            using (StreamWriter sw = new StreamWriter(Path.Combine(directoryInfo.FullName, sqlBuildFileName), false))
            {
                BeginOf(sw, "Script");
                if (directory2 != null)
                    BuildScript(directory2, compareDirectory2, sw);
                BuildScript(directory1, compareDirectory1, sw);
                if (directory3 != null)
                    BuildScript(directory3, compareDirectory3, sw);
                EndOf(sw, "Script");
                sw.Flush();
                sw.Close();
            }

            createSQLProgressUpdateThread.Abort();
        }

        private static void BeginOf(StreamWriter sw, string text)
        {
            sw.WriteLine(string.Empty);
            sw.WriteLine(breakLine);
            sw.WriteLine(string.Format(beginOf, (object)text));
            sw.WriteLine(breakLine);
            sw.WriteLine(string.Empty);
        }

        private static void BuildScript(DirectoryInfo directory, DirectoryInfo compareDirectory, StreamWriter sw)
        {
            foreach (string subDirectory in subDirectories)
            {
                DirectoryInfo directoryInfo = ((IEnumerable<DirectoryInfo>)directory.GetDirectories(subDirectory)).FirstOrDefault<DirectoryInfo>();
                if (directoryInfo != null)
                {
                    foreach (FileInfo file in directoryInfo.GetFiles())
                    {
                        if (compareDirectory == null || ((IEnumerable<DirectoryInfo>)compareDirectory.GetDirectories(subDirectory)).FirstOrDefault<DirectoryInfo>() == null || !FileHasNotChanged(((IEnumerable<DirectoryInfo>)compareDirectory.GetDirectories(subDirectory)).FirstOrDefault<DirectoryInfo>(), file))
                        {
                            BeginOf(sw, Path.Combine(directory.Name, Path.Combine(directoryInfo.Name, file.Name)));
                            AddSettings(sw);
                            StreamReader streamReader = File.OpenText(file.FullName);
                            for (string str = streamReader.ReadLine(); str != null; str = streamReader.ReadLine())
                                sw.WriteLine(str);
                            sw.WriteLine("Go");
                            EndOf(sw, Path.Combine(directory.Name, Path.Combine(directoryInfo.Name, file.Name)));
                            streamReader.Close();
                        }
                    }
                }
            }
        }

        private static bool FileHasNotChanged(DirectoryInfo compareDirectory, FileInfo file)
        {
            if (compareDirectory != null)
            {
                FileInfo[] files = compareDirectory.GetFiles(file.Name);
                if (((IEnumerable<FileInfo>)files).Count<FileInfo>() == 0)
                    return false;
                if (((IEnumerable<FileInfo>)files).Count<FileInfo>() == 1)
                {

                    file.Attributes = FileAttributes.Archive;
                    file.Refresh();

                    FileStream fileStream1 = new FileStream(file.FullName, FileMode.Open);
                    FileStream fileStream2 = new FileStream(files[0].FullName, FileMode.Open);
                    if (fileStream1.Length != fileStream2.Length)
                    {
                        fileStream1.Close();
                        fileStream2.Close();
                        return false;
                    }
                    int num1;
                    int num2;

                    do
                    {
                        num1 = fileStream1.ReadByte();
                        num2 = fileStream2.ReadByte();
                    }
                    while (num1 == num2 && num2 != -1);

                    fileStream1.Close();
                    fileStream2.Close();
                    return num1 - num2 == 0;
                }
            }
            return true;
        }

        private static void AddSettings(StreamWriter sw)
        {
            sw.WriteLine(breakLine);
            sw.WriteLine("SET ANSI_NULLS ON");
            sw.WriteLine("Go");
            sw.WriteLine("SET QUOTED_IDENTIFIER OFF");
            sw.WriteLine("Go");
            sw.WriteLine(breakLine);
        }

        private static void EndOf(StreamWriter sw, string text)
        {
            sw.WriteLine(string.Empty);
            sw.WriteLine(breakLine);
            sw.WriteLine(string.Format(endOf, (object)text));
            sw.WriteLine(breakLine);
            sw.WriteLine(string.Empty);
        }
    }
}
