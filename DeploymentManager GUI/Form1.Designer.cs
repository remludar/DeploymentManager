namespace DeploymentManager_GUI
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.rbDevelopment = new System.Windows.Forms.RadioButton();
            this.rbMain = new System.Windows.Forms.RadioButton();
            this.rbRelease = new System.Windows.Forms.RadioButton();
            this.gbBranch = new System.Windows.Forms.GroupBox();
            this.rbDevGL = new System.Windows.Forms.RadioButton();
            this.fbdSourceFolderBrowser = new System.Windows.Forms.FolderBrowserDialog();
            this.btnSqlFileBrowser = new System.Windows.Forms.Button();
            this.lblSqlComparePath = new System.Windows.Forms.Label();
            this.gbSqlComparePath = new System.Windows.Forms.GroupBox();
            this.pfdSqlFolderDialog = new System.Windows.Forms.OpenFileDialog();
            this.bttnDeploy = new System.Windows.Forms.Button();
            this.gbSourcePath = new System.Windows.Forms.GroupBox();
            this.btnSourcePathBrowser = new System.Windows.Forms.Button();
            this.lblSourcePath = new System.Windows.Forms.Label();
            this.rbRedbox = new System.Windows.Forms.RadioButton();
            this.rbTrainingClass = new System.Windows.Forms.RadioButton();
            this.rbFunctional1 = new System.Windows.Forms.RadioButton();
            this.rbProd_Triage = new System.Windows.Forms.RadioButton();
            this.rbUAT2 = new System.Windows.Forms.RadioButton();
            this.rbProduction = new System.Windows.Forms.RadioButton();
            this.rbTEST = new System.Windows.Forms.RadioButton();
            this.rbRegressDev = new System.Windows.Forms.RadioButton();
            this.rbFunctional2 = new System.Windows.Forms.RadioButton();
            this.rbSandbox = new System.Windows.Forms.RadioButton();
            this.rbDataLoadTest = new System.Windows.Forms.RadioButton();
            this.rbRAIVStarterS15 = new System.Windows.Forms.RadioButton();
            this.gbEnvironment = new System.Windows.Forms.GroupBox();
            this.pbProgressBar = new System.Windows.Forms.ProgressBar();
            this.backgroundWorker1 = new System.ComponentModel.BackgroundWorker();
            this.lblProgress = new System.Windows.Forms.Label();
            this.gbBranch.SuspendLayout();
            this.gbSqlComparePath.SuspendLayout();
            this.gbSourcePath.SuspendLayout();
            this.gbEnvironment.SuspendLayout();
            this.SuspendLayout();
            // 
            // rbDevelopment
            // 
            this.rbDevelopment.AutoSize = true;
            this.rbDevelopment.Checked = true;
            this.rbDevelopment.Location = new System.Drawing.Point(6, 26);
            this.rbDevelopment.Name = "rbDevelopment";
            this.rbDevelopment.Size = new System.Drawing.Size(88, 17);
            this.rbDevelopment.TabIndex = 14;
            this.rbDevelopment.TabStop = true;
            this.rbDevelopment.Text = "Development";
            this.rbDevelopment.UseVisualStyleBackColor = true;
            // 
            // rbMain
            // 
            this.rbMain.AutoSize = true;
            this.rbMain.Location = new System.Drawing.Point(6, 49);
            this.rbMain.Name = "rbMain";
            this.rbMain.Size = new System.Drawing.Size(48, 17);
            this.rbMain.TabIndex = 15;
            this.rbMain.Text = "Main";
            this.rbMain.UseVisualStyleBackColor = true;
            // 
            // rbRelease
            // 
            this.rbRelease.AutoSize = true;
            this.rbRelease.Location = new System.Drawing.Point(6, 72);
            this.rbRelease.Name = "rbRelease";
            this.rbRelease.Size = new System.Drawing.Size(64, 17);
            this.rbRelease.TabIndex = 16;
            this.rbRelease.Text = "Release";
            this.rbRelease.UseVisualStyleBackColor = true;
            // 
            // gbBranch
            // 
            this.gbBranch.Controls.Add(this.rbDevGL);
            this.gbBranch.Controls.Add(this.rbMain);
            this.gbBranch.Controls.Add(this.rbDevelopment);
            this.gbBranch.Controls.Add(this.rbRelease);
            this.gbBranch.Location = new System.Drawing.Point(151, 13);
            this.gbBranch.Name = "gbBranch";
            this.gbBranch.Size = new System.Drawing.Size(109, 174);
            this.gbBranch.TabIndex = 22;
            this.gbBranch.TabStop = false;
            this.gbBranch.Text = "Branch";
            // 
            // rbDevGL
            // 
            this.rbDevGL.AutoSize = true;
            this.rbDevGL.Location = new System.Drawing.Point(6, 95);
            this.rbDevGL.Name = "rbDevGL";
            this.rbDevGL.Size = new System.Drawing.Size(62, 17);
            this.rbDevGL.TabIndex = 17;
            this.rbDevGL.Text = "Dev-GL";
            this.rbDevGL.UseVisualStyleBackColor = true;
            // 
            // btnSqlFileBrowser
            // 
            this.btnSqlFileBrowser.AutoSize = true;
            this.btnSqlFileBrowser.Location = new System.Drawing.Point(6, 46);
            this.btnSqlFileBrowser.Name = "btnSqlFileBrowser";
            this.btnSqlFileBrowser.Size = new System.Drawing.Size(116, 23);
            this.btnSqlFileBrowser.TabIndex = 23;
            this.btnSqlFileBrowser.Text = "Open File Browser";
            this.btnSqlFileBrowser.UseVisualStyleBackColor = true;
            this.btnSqlFileBrowser.Click += new System.EventHandler(this.btnSqlFileBrowser_Click);
            // 
            // lblSqlComparePath
            // 
            this.lblSqlComparePath.AutoSize = true;
            this.lblSqlComparePath.Location = new System.Drawing.Point(6, 27);
            this.lblSqlComparePath.Name = "lblSqlComparePath";
            this.lblSqlComparePath.Size = new System.Drawing.Size(0, 13);
            this.lblSqlComparePath.TabIndex = 24;
            // 
            // gbSqlComparePath
            // 
            this.gbSqlComparePath.Controls.Add(this.btnSqlFileBrowser);
            this.gbSqlComparePath.Controls.Add(this.lblSqlComparePath);
            this.gbSqlComparePath.Location = new System.Drawing.Point(151, 193);
            this.gbSqlComparePath.Name = "gbSqlComparePath";
            this.gbSqlComparePath.Size = new System.Drawing.Size(427, 77);
            this.gbSqlComparePath.TabIndex = 25;
            this.gbSqlComparePath.TabStop = false;
            this.gbSqlComparePath.Text = "Sql Compare Path";
            // 
            // pfdSqlFolderDialog
            // 
            this.pfdSqlFolderDialog.FileName = "SqlFolderDialog";
            // 
            // bttnDeploy
            // 
            this.bttnDeploy.BackColor = System.Drawing.Color.Orchid;
            this.bttnDeploy.Font = new System.Drawing.Font("Microsoft Sans Serif", 35F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.bttnDeploy.ForeColor = System.Drawing.SystemColors.ControlText;
            this.bttnDeploy.Location = new System.Drawing.Point(276, 15);
            this.bttnDeploy.Name = "bttnDeploy";
            this.bttnDeploy.Size = new System.Drawing.Size(302, 172);
            this.bttnDeploy.TabIndex = 26;
            this.bttnDeploy.Text = "Big Ole Deploy Button!";
            this.bttnDeploy.UseVisualStyleBackColor = false;
            this.bttnDeploy.Click += new System.EventHandler(this.bttnDeploy_Click);
            // 
            // gbSourcePath
            // 
            this.gbSourcePath.Controls.Add(this.btnSourcePathBrowser);
            this.gbSourcePath.Controls.Add(this.lblSourcePath);
            this.gbSourcePath.Location = new System.Drawing.Point(151, 282);
            this.gbSourcePath.Name = "gbSourcePath";
            this.gbSourcePath.Size = new System.Drawing.Size(427, 77);
            this.gbSourcePath.TabIndex = 26;
            this.gbSourcePath.TabStop = false;
            this.gbSourcePath.Text = "Source Path";
            // 
            // btnSourcePathBrowser
            // 
            this.btnSourcePathBrowser.AutoSize = true;
            this.btnSourcePathBrowser.Location = new System.Drawing.Point(6, 46);
            this.btnSourcePathBrowser.Name = "btnSourcePathBrowser";
            this.btnSourcePathBrowser.Size = new System.Drawing.Size(116, 23);
            this.btnSourcePathBrowser.TabIndex = 23;
            this.btnSourcePathBrowser.Text = "Open File Browser";
            this.btnSourcePathBrowser.UseVisualStyleBackColor = true;
            this.btnSourcePathBrowser.Click += new System.EventHandler(this.btnSourcePathBrowser_Click);
            // 
            // lblSourcePath
            // 
            this.lblSourcePath.AutoSize = true;
            this.lblSourcePath.Location = new System.Drawing.Point(6, 27);
            this.lblSourcePath.Name = "lblSourcePath";
            this.lblSourcePath.Size = new System.Drawing.Size(0, 13);
            this.lblSourcePath.TabIndex = 24;
            // 
            // rbRedbox
            // 
            this.rbRedbox.AutoSize = true;
            this.rbRedbox.Location = new System.Drawing.Point(6, 134);
            this.rbRedbox.Name = "rbRedbox";
            this.rbRedbox.Size = new System.Drawing.Size(62, 17);
            this.rbRedbox.TabIndex = 5;
            this.rbRedbox.Text = "Redbox";
            this.rbRedbox.UseVisualStyleBackColor = true;
            // 
            // rbTrainingClass
            // 
            this.rbTrainingClass.AutoSize = true;
            this.rbTrainingClass.Location = new System.Drawing.Point(6, 203);
            this.rbTrainingClass.Name = "rbTrainingClass";
            this.rbTrainingClass.Size = new System.Drawing.Size(88, 17);
            this.rbTrainingClass.TabIndex = 8;
            this.rbTrainingClass.Text = "TrainingClass";
            this.rbTrainingClass.UseVisualStyleBackColor = true;
            // 
            // rbFunctional1
            // 
            this.rbFunctional1.AutoSize = true;
            this.rbFunctional1.Location = new System.Drawing.Point(6, 42);
            this.rbFunctional1.Name = "rbFunctional1";
            this.rbFunctional1.Size = new System.Drawing.Size(80, 17);
            this.rbFunctional1.TabIndex = 2;
            this.rbFunctional1.Text = "Functional1";
            this.rbFunctional1.UseVisualStyleBackColor = true;
            // 
            // rbProd_Triage
            // 
            this.rbProd_Triage.AutoSize = true;
            this.rbProd_Triage.Location = new System.Drawing.Point(6, 88);
            this.rbProd_Triage.Name = "rbProd_Triage";
            this.rbProd_Triage.Size = new System.Drawing.Size(83, 17);
            this.rbProd_Triage.TabIndex = 4;
            this.rbProd_Triage.Text = "Prod_Triage";
            this.rbProd_Triage.UseVisualStyleBackColor = true;
            // 
            // rbUAT2
            // 
            this.rbUAT2.AutoSize = true;
            this.rbUAT2.Location = new System.Drawing.Point(6, 249);
            this.rbUAT2.Name = "rbUAT2";
            this.rbUAT2.Size = new System.Drawing.Size(53, 17);
            this.rbUAT2.TabIndex = 10;
            this.rbUAT2.Text = "UAT2";
            this.rbUAT2.UseVisualStyleBackColor = true;
            // 
            // rbProduction
            // 
            this.rbProduction.AutoSize = true;
            this.rbProduction.Location = new System.Drawing.Point(6, 269);
            this.rbProduction.Name = "rbProduction";
            this.rbProduction.Size = new System.Drawing.Size(76, 17);
            this.rbProduction.TabIndex = 11;
            this.rbProduction.Text = "Production";
            this.rbProduction.UseVisualStyleBackColor = true;
            // 
            // rbTEST
            // 
            this.rbTEST.AutoSize = true;
            this.rbTEST.Location = new System.Drawing.Point(6, 226);
            this.rbTEST.Name = "rbTEST";
            this.rbTEST.Size = new System.Drawing.Size(53, 17);
            this.rbTEST.TabIndex = 9;
            this.rbTEST.Text = "TEST";
            this.rbTEST.UseVisualStyleBackColor = true;
            // 
            // rbRegressDev
            // 
            this.rbRegressDev.AutoSize = true;
            this.rbRegressDev.Location = new System.Drawing.Point(6, 157);
            this.rbRegressDev.Name = "rbRegressDev";
            this.rbRegressDev.Size = new System.Drawing.Size(84, 17);
            this.rbRegressDev.TabIndex = 6;
            this.rbRegressDev.Text = "RegressDev";
            this.rbRegressDev.UseVisualStyleBackColor = true;
            // 
            // rbFunctional2
            // 
            this.rbFunctional2.AutoSize = true;
            this.rbFunctional2.Location = new System.Drawing.Point(6, 65);
            this.rbFunctional2.Name = "rbFunctional2";
            this.rbFunctional2.Size = new System.Drawing.Size(80, 17);
            this.rbFunctional2.TabIndex = 3;
            this.rbFunctional2.Text = "Functional2";
            this.rbFunctional2.UseVisualStyleBackColor = true;
            // 
            // rbSandbox
            // 
            this.rbSandbox.AutoSize = true;
            this.rbSandbox.Location = new System.Drawing.Point(6, 180);
            this.rbSandbox.Name = "rbSandbox";
            this.rbSandbox.Size = new System.Drawing.Size(67, 17);
            this.rbSandbox.TabIndex = 7;
            this.rbSandbox.Text = "Sandbox";
            this.rbSandbox.UseVisualStyleBackColor = true;
            // 
            // rbDataLoadTest
            // 
            this.rbDataLoadTest.AutoSize = true;
            this.rbDataLoadTest.Checked = true;
            this.rbDataLoadTest.Location = new System.Drawing.Point(6, 19);
            this.rbDataLoadTest.Name = "rbDataLoadTest";
            this.rbDataLoadTest.Size = new System.Drawing.Size(93, 17);
            this.rbDataLoadTest.TabIndex = 1;
            this.rbDataLoadTest.Text = "DataLoadTest";
            this.rbDataLoadTest.UseVisualStyleBackColor = true;
            // 
            // rbRAIVStarterS15
            // 
            this.rbRAIVStarterS15.AutoSize = true;
            this.rbRAIVStarterS15.Location = new System.Drawing.Point(6, 111);
            this.rbRAIVStarterS15.Name = "rbRAIVStarterS15";
            this.rbRAIVStarterS15.Size = new System.Drawing.Size(100, 17);
            this.rbRAIVStarterS15.TabIndex = 12;
            this.rbRAIVStarterS15.Text = "RAIVStarterS15";
            this.rbRAIVStarterS15.UseVisualStyleBackColor = true;
            // 
            // gbEnvironment
            // 
            this.gbEnvironment.Controls.Add(this.rbRAIVStarterS15);
            this.gbEnvironment.Controls.Add(this.rbDataLoadTest);
            this.gbEnvironment.Controls.Add(this.rbSandbox);
            this.gbEnvironment.Controls.Add(this.rbFunctional2);
            this.gbEnvironment.Controls.Add(this.rbRegressDev);
            this.gbEnvironment.Controls.Add(this.rbTEST);
            this.gbEnvironment.Controls.Add(this.rbProduction);
            this.gbEnvironment.Controls.Add(this.rbUAT2);
            this.gbEnvironment.Controls.Add(this.rbProd_Triage);
            this.gbEnvironment.Controls.Add(this.rbFunctional1);
            this.gbEnvironment.Controls.Add(this.rbTrainingClass);
            this.gbEnvironment.Controls.Add(this.rbRedbox);
            this.gbEnvironment.Location = new System.Drawing.Point(16, 13);
            this.gbEnvironment.Name = "gbEnvironment";
            this.gbEnvironment.Size = new System.Drawing.Size(117, 346);
            this.gbEnvironment.TabIndex = 21;
            this.gbEnvironment.TabStop = false;
            this.gbEnvironment.Text = "Environment";
            // 
            // pbProgressBar
            // 
            this.pbProgressBar.Location = new System.Drawing.Point(16, 396);
            this.pbProgressBar.Name = "pbProgressBar";
            this.pbProgressBar.Size = new System.Drawing.Size(562, 30);
            this.pbProgressBar.TabIndex = 27;
            this.pbProgressBar.Visible = false;
            // 
            // backgroundWorker1
            // 
            this.backgroundWorker1.WorkerReportsProgress = true;
            this.backgroundWorker1.DoWork += new System.ComponentModel.DoWorkEventHandler(this.BackgroundWorker1_DoWork);
            // 
            // lblProgress
            // 
            this.lblProgress.AutoSize = true;
            this.lblProgress.Location = new System.Drawing.Point(22, 377);
            this.lblProgress.Name = "lblProgress";
            this.lblProgress.Size = new System.Drawing.Size(0, 13);
            this.lblProgress.TabIndex = 28;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(609, 438);
            this.Controls.Add(this.lblProgress);
            this.Controls.Add(this.pbProgressBar);
            this.Controls.Add(this.gbSourcePath);
            this.Controls.Add(this.bttnDeploy);
            this.Controls.Add(this.gbSqlComparePath);
            this.Controls.Add(this.gbBranch);
            this.Controls.Add(this.gbEnvironment);
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Deployment Manager";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.gbBranch.ResumeLayout(false);
            this.gbBranch.PerformLayout();
            this.gbSqlComparePath.ResumeLayout(false);
            this.gbSqlComparePath.PerformLayout();
            this.gbSourcePath.ResumeLayout(false);
            this.gbSourcePath.PerformLayout();
            this.gbEnvironment.ResumeLayout(false);
            this.gbEnvironment.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.RadioButton rbDevelopment;
        private System.Windows.Forms.RadioButton rbMain;
        private System.Windows.Forms.RadioButton rbRelease;
        private System.Windows.Forms.GroupBox gbBranch;
        private System.Windows.Forms.FolderBrowserDialog fbdSourceFolderBrowser;
        private System.Windows.Forms.Button btnSqlFileBrowser;
        private System.Windows.Forms.Label lblSqlComparePath;
        private System.Windows.Forms.GroupBox gbSqlComparePath;
        private System.Windows.Forms.OpenFileDialog pfdSqlFolderDialog;
        private System.Windows.Forms.Button bttnDeploy;
        private System.Windows.Forms.GroupBox gbSourcePath;
        private System.Windows.Forms.Button btnSourcePathBrowser;
        private System.Windows.Forms.Label lblSourcePath;
        private System.Windows.Forms.RadioButton rbRedbox;
        private System.Windows.Forms.RadioButton rbTrainingClass;
        private System.Windows.Forms.RadioButton rbFunctional1;
        private System.Windows.Forms.RadioButton rbProd_Triage;
        private System.Windows.Forms.RadioButton rbUAT2;
        private System.Windows.Forms.RadioButton rbProduction;
        private System.Windows.Forms.RadioButton rbTEST;
        private System.Windows.Forms.RadioButton rbRegressDev;
        private System.Windows.Forms.RadioButton rbFunctional2;
        private System.Windows.Forms.RadioButton rbSandbox;
        private System.Windows.Forms.RadioButton rbDataLoadTest;
        private System.Windows.Forms.RadioButton rbRAIVStarterS15;
        private System.Windows.Forms.GroupBox gbEnvironment;
        private System.Windows.Forms.RadioButton rbDevGL;
        private System.Windows.Forms.ProgressBar pbProgressBar;
        private System.ComponentModel.BackgroundWorker backgroundWorker1;
        private System.Windows.Forms.Label lblProgress;
    }
}

