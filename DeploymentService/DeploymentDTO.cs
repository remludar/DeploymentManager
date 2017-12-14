using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DeploymentManagerWCFService
{
    public class DeploymentDTO
    {
        private BackgroundWorker _bgw;
        private string _progressLabelText;
        private string _branch;
        private string _sqlComparePath;
        private string _sourcePath;
        private string _serverSourcePath;
        private string _environmentName;
        private string _virtualEnvironmentName;
        private string _sqlServer;
        private string _database;
        private string _deploymentPath;
        private string _rootSQLPath;
        private string _motivaSQLPath;
        private string _movementLiveCycleSQLPath;
        private string _buildNumber;
        private string _postBuildOutputPath;
        private string _nonSQLOutputPath;
        private string _sqlOutputPath;
        private string _deploymentStagingPath;
        private string _backupPath;

        private List<string> _targetAppServers = new List<string>();
        private List<string> _targetSMServers = new List<string>();
        private List<string> _targetRAMQServers = new List<string>();
        private List<string> _rootSQLDirectories = new List<string>();

        //private string _nonSQLStagingPath = string.Empty;
        //private string _sqlStatingPath = string.Empty;
        //private int _progressCounter = 0;

        public BackgroundWorker BackGroundWorker
        {
            get { return _bgw; }
            set { _bgw = value; }
        }
        public string ProgressLabelText
        {
            get { return _progressLabelText; }
            set { _progressLabelText = value; }
        }
        public string Branch
        {
            get { return _branch; }
            set { _branch = value; }
        }
        public string SQLComparePath
        {
            get { return _sqlComparePath; }
            set { _sqlComparePath = value; }
        }
        public string SourcePath
        {
            get { return _sourcePath; }
            set { _sourcePath = value; }
        }
        public string ServerSourcePath
        {
            get { return _serverSourcePath; }
            set { _serverSourcePath = value; }
        }
        public string EnvironmentName
        {
            get { return _environmentName; }
            set { _environmentName = value; }
        }
        public string VirtualEnvironmentName
        {
            get { return _virtualEnvironmentName; }
            set { _virtualEnvironmentName = value; }
        }
        public string SQLServer
        {
            get { return _sqlServer; }
            set { _sqlServer = value; }
        }
        public string Database
        {
            get { return _database; }
            set { _database = value; }
        }
        public string DeploymentPath
        {
            get { return _deploymentPath; }
            set { _deploymentPath = value; }
        }
        public string RootSQLPath
        {
            get { return _rootSQLPath; }
            set { _rootSQLPath = value; }
        }
        public string MotivaSQLPath
        {
            get { return _motivaSQLPath; }
            set { _motivaSQLPath = value; }
        }
        public string MovementLifecyclePath
        {
            get { return _movementLiveCycleSQLPath; }
            set { _movementLiveCycleSQLPath = value; }
        }
        public string BuildNumber
        {
            get { return _buildNumber; }
            set { _buildNumber = value; }
        }
        public string PostBuildOutputPath
        {
            get { return _postBuildOutputPath; }
            set { _postBuildOutputPath = value; }
        }
        public string NonSQLOutputPath
        {
            get { return _nonSQLOutputPath; }
            set { _nonSQLOutputPath = value; }
        }
        public string SQLOutputPath
        {
            get { return _sqlOutputPath; }
            set { _sqlOutputPath = value; }
        }
        public string DeploymentStagingPath
        {
            get { return _deploymentStagingPath; }
            set { _deploymentStagingPath = value; }
        }
        public string BackupPath
        {
            get { return _backupPath; }
            set { _backupPath = value; }
        }
        public List<string> TargetAppServers
        {
            get { return _targetAppServers; }
            set { _targetAppServers = value; }
        }
        public List<string> TargetSMServers
        {
            get { return _targetSMServers; }
            set { _targetSMServers = value; }
        }
        public List<string> TargetRAMQServers
        {
            get { return _targetRAMQServers; }
            set { _targetRAMQServers = value; }
        }
        public List<string> RootSQLDirectories
        {
            get { return _rootSQLDirectories; }
            set { _rootSQLDirectories = value; }
        }
    }
}
