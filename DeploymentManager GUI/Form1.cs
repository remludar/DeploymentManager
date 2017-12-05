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
            //Set variables from user selection form to pass to DeploymentManager
            var selectedEnvironment = gbEnvironment.Controls.OfType<RadioButton>().FirstOrDefault(r => r.Checked);
            var trimmedEnvironmentName = selectedEnvironment.Name.Split(new string[] { "rb" }, StringSplitOptions.None)[1];
            var progressLabel = lblProgress;
            var selectedBranch = gbBranch.Controls.OfType<RadioButton>().FirstOrDefault(r => r.Checked).Name;
            var sqlComparePath = gbSqlComparePath.Controls.OfType<Label>().FirstOrDefault();
            var sourcePath = gbSourcePath.Controls.OfType<Label>().FirstOrDefault().Text;

            DeploymentManager.Init(backgroundWorker1, progressLabel, selectedBranch, sqlComparePath.Text, sourcePath, trimmedEnvironmentName);
            DeploymentManager.Run();
        }

        private void BackgroundWorker1_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            try
            {
                pbProgressBar.Value = e.ProgressPercentage;
            }
            catch(Exception ex)
            {
                DeploymentManager.Log("_ManageServices", DeploymentManager.LogEventType.ERROR, "Message: " + ex.Message);
                DeploymentManager.Log("_ManageServices", DeploymentManager.LogEventType.ERROR, "Stack Trace: " + ex.StackTrace);
            }
        }

        private void BackgroundWorker1_RunWorkerCompleted1(object sender, RunWorkerCompletedEventArgs e)
        {
            MessageBox.Show("Deployment Successful!\nThanks for using the Big Ole Deployment Button.");
            Close();
        }

       




    }
}
