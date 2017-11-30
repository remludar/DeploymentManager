using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Configuration;
using System.ServiceProcess;
using static DeploymentManager_GUI.ConnectionManagerDataSection;

namespace DeploymentManager_GUI
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void radioButton11_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void btnSqlFileBrowser_Click(object sender, EventArgs e)
        {
            fbdSourceFolderBrowser.SelectedPath = @"\\10.58.40.18\deployment\Builds\SQL\";
            if (fbdSourceFolderBrowser.ShowDialog() == DialogResult.OK)
            {
                this.lblSqlComparePath.Text = fbdSourceFolderBrowser.SelectedPath;
            }

        }

        private void btnSourcePathBrowser_Click(object sender, EventArgs e)
        {
            fbdSourceFolderBrowser.SelectedPath = @"C:\";
            if (fbdSourceFolderBrowser.ShowDialog() == DialogResult.OK)
            {
                this.lblSourcePath.Text = fbdSourceFolderBrowser.SelectedPath;
            }

        }

        private void bttnDeploy_Click(object sender, EventArgs e)
        {
            pbProgressBar.Visible = true;
            // Hook up event handlers
            backgroundWorker1.ProgressChanged += BackgroundWorker1_ProgressChanged;
            backgroundWorker1.RunWorkerCompleted += BackgroundWorker1_RunWorkerCompleted1;


            backgroundWorker1.RunWorkerAsync();
        }



        private void BackgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            //Set variables from user selection and run the main deployment
            var selectedEnvironment = gbEnvironment.Controls.OfType<RadioButton>().FirstOrDefault(r => r.Checked);
            var trimmedEnvironmentName = selectedEnvironment.Name.Split(new string[] { "rb" }, StringSplitOptions.None)[1];
            DeploymentManager.SetEnvironmentInformation(trimmedEnvironmentName);

            var selectedBranch = gbBranch.Controls.OfType<RadioButton>().FirstOrDefault(r => r.Checked);
            DeploymentManager.SetBranch(selectedBranch.Name);

            var sourcePath = gbSourcePath.Controls.OfType<Label>().FirstOrDefault();
            DeploymentManager.SetSourcePath(sourcePath.Text);

            var progressLabel = lblProgress;

            var sqlOutputPath = DeploymentManager.Run(backgroundWorker1, progressLabel);


            //Run what used to be the "Deployment Builder" that compares the 2 sql files
            var oldSqlPath = gbSqlComparePath.Controls.OfType<Label>().FirstOrDefault();
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

            ////Stop appropriate services
            //ServiceController[] services = ServiceController.GetServices("motappdev4001.motivadev.dev");
            //foreach (ServiceController service in services)
            //{
            //    if (service.DisplayName.Contains("Service Monitor"))
            //    {
            //        if (service.DisplayName.Contains("RegressDev"))
            //        {
            //            Console.WriteLine(service.DisplayName + "\t" + service.Status);
            //            service.Stop();
            //            for (int wait = 0; wait < 1000000; wait++)
            //            {
            //                int i = 0;
            //            }
            //            Console.WriteLine(service.DisplayName + "\t" + service.Status);
            //        }

            //    }
            //}

            //Console.ReadKey();


            //Copy code to where it goes
            //Execute sql script
            //Start services
            //Do health check


        }

        private void BackgroundWorker1_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            pbProgressBar.Value = e.ProgressPercentage;
        }

        private void BackgroundWorker1_RunWorkerCompleted1(object sender, RunWorkerCompletedEventArgs e)
        {
            MessageBox.Show("Deployment Successful!\nThanks for using the Big Ole Deployment Button.");
            Close();
        }

       




    }
}
