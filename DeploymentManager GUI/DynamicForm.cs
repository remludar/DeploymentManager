using DeploymentManager_GUI.CustomConfig;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DeploymentManager_GUI
{
    public partial class DynamicForm : Form
    {
        private const int _FORM_WIDTH = 270;
        private const int _FORM_HEIGHT = 375;
        private const int _COMBO_BOX_WIDTH = 100;

        private List<string> _environmentNames = new List<string>();
        private List<string> _branchNames = new List<string>();

        private Font _font = new Font("Segoe UI", 10);
        private PictureBox _motivaLogo;
        private Label _environmentLabel;
        private Label _branchLabel;
        private Label _progressLabel;
        private ComboBox _environmentComboBox;
        private ComboBox _branchComboBox;
        private Button _sqlPathButton;
        private Button _sourcePathButton;
        private Button _deployButton;
        private FolderBrowserDialog _sqlPathDialog;
        private FolderBrowserDialog _sourcePathDialog;
        private ProgressBar _progressBar;
        private BackgroundWorker _bgWorker;

        private string _selectedEnvironment = string.Empty;
        private string _selectedBranch = string.Empty;
        private string _selectedSqlPath = string.Empty;
        private string _selectedSourcePath = string.Empty;

        private class CustomItem
        {
            public string Name;
            public CustomItem(string name)
            {
                Name = name;
            }

            public override string ToString()
            {
                return Name;
            }
        }

        public DynamicForm()
        {
            InitializeComponent();

            // Set Starting Form properties
            Text = "Deployment Manager";
            Width = _FORM_WIDTH;
            Height = _FORM_HEIGHT;
            CenterToScreen();
            FormBorderStyle = FormBorderStyle.FixedSingle;
            MaximizeBox = false;
            MinimizeBox = false;

            _bgWorker = new BackgroundWorker();
            _bgWorker.WorkerReportsProgress = true;
            _bgWorker.DoWork += _bgWorker_DoWork;
            _bgWorker.ProgressChanged += _bgWorker_ProgressChanged;
            _bgWorker.RunWorkerCompleted += _bgWorker_RunWorkerCompleted;
        }

        private void DynamicForm_Load(object sender, EventArgs e)
        {
            _branchNames.Add("Development");
            _branchNames.Add("Main");
            _branchNames.Add("Release");
            _branchNames.Add("Dev-GL");

            _ParseAppConfig();
            _BuildControls();
            _AddControls();
        }

        // Helpers
        private void _ParseAppConfig()
        {
            var environmentCollectionSection = ConfigurationManager.GetSection("environmentCollectionSection") as EnvironmentCollectionSection;
            foreach (CustomConfig.Environment environment in environmentCollectionSection.Members)
            {
                _environmentNames.Add(environment.Name);
            }
        }

        private void _BuildControls()
        {
            _BuildMotivaLogo();
            _BuildEnvironmentComboBox();
            _BuildBranchComboBox();
            _BuildSqlPathBrowserDialog();
            _BuildSqlPathBrowserButton();
            _BuildSourcePathBrowserDialog();
            _BuildSourcePathBrowserButton();
            _BuildDeployButton();
            _BuildProgressBar();
        }

        private void _BuildMotivaLogo()
        {
            _motivaLogo = new PictureBox();
            _motivaLogo.Image = Properties.Resources.Motiva_Logo;
            _motivaLogo.Width = _motivaLogo.Image.Width;
            _motivaLogo.Height = _motivaLogo.Image.Height;
            _motivaLogo.Location = new Point(35, 20);
        }

        private void _BuildEnvironmentComboBox()
        {
            _environmentLabel = new Label(); _environmentLabel.Text = "Environment";
            _environmentLabel.Location = new Point(_motivaLogo.Location.X - 20, _motivaLogo.Location.Y + 50);
            _environmentLabel.Font = _font;

            _environmentComboBox = new ComboBox();
            _environmentComboBox.Location = new Point(_environmentLabel.Location.X, _environmentLabel.Location.Y + 25);
            _environmentComboBox.Width = _COMBO_BOX_WIDTH;
            _environmentComboBox.DropDownWidth = _COMBO_BOX_WIDTH;
            foreach(string name in _environmentNames)
            {
                _environmentComboBox.Items.Add(new CustomItem(name));
            }
        }

        private void _BuildBranchComboBox()
        {
            _branchLabel = new Label(); _branchLabel.Text = "Branch";
            _branchLabel.Location = new Point(_environmentLabel.Location.X + _environmentLabel.Width + 25, _environmentLabel.Location.Y);
            _branchLabel.Font = _font;

            _branchComboBox = new ComboBox();
            _branchComboBox.Location = new Point(_branchLabel.Location.X, _branchLabel.Location.Y + 25);
            _branchComboBox.Width = _COMBO_BOX_WIDTH;
            _branchComboBox.DropDownWidth = _COMBO_BOX_WIDTH;
            foreach(string name in _branchNames)
            {
                _branchComboBox.Items.Add(new CustomItem(name));
            }
        }

        private void _BuildSqlPathBrowserButton()
        {
            _sqlPathButton = new Button(); _sqlPathButton.Text = "Select SQL Folder Path";
            _sqlPathButton.Font = _font;
            _sqlPathButton.Width = 225;
            _sqlPathButton.Height = 30;
            _sqlPathButton.Location = new Point(_environmentComboBox.Location.X, _environmentComboBox.Location.Y + 40);

            _sqlPathButton.Click += new EventHandler(_sqlPathButton_Click);
        }

        private void _BuildSourcePathBrowserButton()
        {
            _sourcePathButton = new Button(); _sourcePathButton.Text = "Select Source Folder Path";
            _sourcePathButton.Font = _font;
            _sourcePathButton.Width = 225;
            _sourcePathButton.Height = 30;
            _sourcePathButton.Location = new Point(_sqlPathButton.Location.X, _sqlPathButton.Location.Y + 40);

            _sourcePathButton.Click += new EventHandler(_sourcePathButton_Click);
        }

        private void _BuildSqlPathBrowserDialog()
        {
            _sqlPathDialog = new FolderBrowserDialog();
            _sqlPathDialog.SelectedPath = @"\\10.58.40.18\deployment\Builds\SQL\";
        }

        private void _BuildSourcePathBrowserDialog()
        {
            _sourcePathDialog = new FolderBrowserDialog();
            _sourcePathDialog.SelectedPath = @"C:\"; ;
        }

        private void _BuildDeployButton()
        {
            _deployButton = new Button(); _deployButton.Text = "Deploy";
            _deployButton.Font = _font;
            _deployButton.BackColor = Color.LightBlue;
            _deployButton.Width = 225;
            _deployButton.Height = 40;
            _deployButton.Location = new Point(_sourcePathButton.Location.X, _sourcePathButton.Location.Y + 40);

            _deployButton.Click += new EventHandler(_deployButton_Click);

        }
       
        private void _BuildProgressBar()
        {
            _progressBar = new ProgressBar();
            _progressBar.Location = new Point(_deployButton.Location.X, _deployButton.Location.Y + 50);
            _progressBar.Width = 225;
            _progressBar.Height = 40;
            _progressBar.Hide();

            _progressLabel = new Label(); _progressLabel.Text = "This is test text";
            _progressLabel.Location = new Point(_progressBar.Location.X , _progressBar.Location.Y + 45);
            _progressLabel.Font = _font;
            _progressLabel.Width = 225;
            _progressLabel.Hide();
        }

        private void _AddControls()
        {
            Controls.Add(_motivaLogo);

            Controls.Add(_environmentLabel);
            Controls.Add(_environmentComboBox);

            Controls.Add(_branchLabel);
            Controls.Add(_branchComboBox);

            Controls.Add(_sqlPathButton);

            Controls.Add(_sourcePathButton);

            Controls.Add(_deployButton);

            Controls.Add(_progressBar);
            Controls.Add(_progressLabel);

        }

        private void _sqlPathButton_Click(object sender, EventArgs e)
        {
            _sqlPathDialog.ShowDialog();
        }

        private void _sourcePathButton_Click(object sender, EventArgs e)
        {
            _sourcePathDialog.ShowDialog();
        }

        private void _deployButton_Click(object sender, EventArgs e)
        {
            _progressBar.Show();
            _progressLabel.Show();

            _selectedBranch = _branchComboBox.Text;
            _selectedSqlPath = _sqlPathDialog.SelectedPath;
            _selectedSourcePath = _sourcePathDialog.SelectedPath;
            _selectedEnvironment = _environmentComboBox.Text;

            _bgWorker.ProgressChanged += _bgWorker_ProgressChanged;
            _bgWorker.RunWorkerCompleted += _bgWorker_RunWorkerCompleted;
            _bgWorker.RunWorkerAsync();
        }

        private void _bgWorker_DoWork(object sender, DoWorkEventArgs e)
        {
            
            DeploymentManager.Init(_bgWorker, _progressLabel, _selectedBranch, _selectedSqlPath, _selectedSourcePath, _selectedEnvironment);
            DeploymentManager.Run();
        }

        private void _bgWorker_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            try
            {
                _progressBar.Value = e.ProgressPercentage;
            }
            catch (Exception ex)
            {
                DeploymentManager.Log("_ManageServices", DeploymentManager.LogEventType.ERROR, "Message: " + ex.Message);
                DeploymentManager.Log("_ManageServices", DeploymentManager.LogEventType.ERROR, "Stack Trace: " + ex.StackTrace);
            }
        }

        private void _bgWorker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            MessageBox.Show("Deployment Successful!\nThanks for using the Big Ole Deployment Button.");
            Close();
        }


    }
}
