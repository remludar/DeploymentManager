﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace DeploymentManager_GUI.DeploymentManagerServiceReference {
    using System.Runtime.Serialization;
    using System;
    
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "4.0.0.0")]
    [System.Runtime.Serialization.DataContractAttribute(Name="DeploymentDTO", Namespace="http://schemas.datacontract.org/2004/07/DeploymentManagerWCFService")]
    [System.SerializableAttribute()]
    public partial class DeploymentDTO : object, System.Runtime.Serialization.IExtensibleDataObject, System.ComponentModel.INotifyPropertyChanged {
        
        [System.NonSerializedAttribute()]
        private System.Runtime.Serialization.ExtensionDataObject extensionDataField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private System.ComponentModel.BackgroundWorker BackGroundWorkerField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string BackupPathField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string BranchField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string BuildNumberField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string DatabaseField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string DeploymentPathField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string DeploymentStagingPathField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string EnvironmentNameField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string MotivaSQLPathField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string MovementLifecyclePathField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NonSQLOutputPathField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string PostBuildOutputPathField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string ProgressLabelTextField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string[] RootSQLDirectoriesField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string RootSQLPathField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string SQLComparePathField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string SQLOutputPathField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string SQLServerField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string ServerSourcePathField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string SourcePathField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string[] TargetAppServersField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string[] TargetRAMQServersField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string[] TargetSMServersField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string VirtualEnvironmentNameField;
        
        [global::System.ComponentModel.BrowsableAttribute(false)]
        public System.Runtime.Serialization.ExtensionDataObject ExtensionData {
            get {
                return this.extensionDataField;
            }
            set {
                this.extensionDataField = value;
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public System.ComponentModel.BackgroundWorker BackGroundWorker {
            get {
                return this.BackGroundWorkerField;
            }
            set {
                if ((object.ReferenceEquals(this.BackGroundWorkerField, value) != true)) {
                    this.BackGroundWorkerField = value;
                    this.RaisePropertyChanged("BackGroundWorker");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string BackupPath {
            get {
                return this.BackupPathField;
            }
            set {
                if ((object.ReferenceEquals(this.BackupPathField, value) != true)) {
                    this.BackupPathField = value;
                    this.RaisePropertyChanged("BackupPath");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Branch {
            get {
                return this.BranchField;
            }
            set {
                if ((object.ReferenceEquals(this.BranchField, value) != true)) {
                    this.BranchField = value;
                    this.RaisePropertyChanged("Branch");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string BuildNumber {
            get {
                return this.BuildNumberField;
            }
            set {
                if ((object.ReferenceEquals(this.BuildNumberField, value) != true)) {
                    this.BuildNumberField = value;
                    this.RaisePropertyChanged("BuildNumber");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Database {
            get {
                return this.DatabaseField;
            }
            set {
                if ((object.ReferenceEquals(this.DatabaseField, value) != true)) {
                    this.DatabaseField = value;
                    this.RaisePropertyChanged("Database");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string DeploymentPath {
            get {
                return this.DeploymentPathField;
            }
            set {
                if ((object.ReferenceEquals(this.DeploymentPathField, value) != true)) {
                    this.DeploymentPathField = value;
                    this.RaisePropertyChanged("DeploymentPath");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string DeploymentStagingPath {
            get {
                return this.DeploymentStagingPathField;
            }
            set {
                if ((object.ReferenceEquals(this.DeploymentStagingPathField, value) != true)) {
                    this.DeploymentStagingPathField = value;
                    this.RaisePropertyChanged("DeploymentStagingPath");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string EnvironmentName {
            get {
                return this.EnvironmentNameField;
            }
            set {
                if ((object.ReferenceEquals(this.EnvironmentNameField, value) != true)) {
                    this.EnvironmentNameField = value;
                    this.RaisePropertyChanged("EnvironmentName");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string MotivaSQLPath {
            get {
                return this.MotivaSQLPathField;
            }
            set {
                if ((object.ReferenceEquals(this.MotivaSQLPathField, value) != true)) {
                    this.MotivaSQLPathField = value;
                    this.RaisePropertyChanged("MotivaSQLPath");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string MovementLifecyclePath {
            get {
                return this.MovementLifecyclePathField;
            }
            set {
                if ((object.ReferenceEquals(this.MovementLifecyclePathField, value) != true)) {
                    this.MovementLifecyclePathField = value;
                    this.RaisePropertyChanged("MovementLifecyclePath");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string NonSQLOutputPath {
            get {
                return this.NonSQLOutputPathField;
            }
            set {
                if ((object.ReferenceEquals(this.NonSQLOutputPathField, value) != true)) {
                    this.NonSQLOutputPathField = value;
                    this.RaisePropertyChanged("NonSQLOutputPath");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string PostBuildOutputPath {
            get {
                return this.PostBuildOutputPathField;
            }
            set {
                if ((object.ReferenceEquals(this.PostBuildOutputPathField, value) != true)) {
                    this.PostBuildOutputPathField = value;
                    this.RaisePropertyChanged("PostBuildOutputPath");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string ProgressLabelText {
            get {
                return this.ProgressLabelTextField;
            }
            set {
                if ((object.ReferenceEquals(this.ProgressLabelTextField, value) != true)) {
                    this.ProgressLabelTextField = value;
                    this.RaisePropertyChanged("ProgressLabelText");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string[] RootSQLDirectories {
            get {
                return this.RootSQLDirectoriesField;
            }
            set {
                if ((object.ReferenceEquals(this.RootSQLDirectoriesField, value) != true)) {
                    this.RootSQLDirectoriesField = value;
                    this.RaisePropertyChanged("RootSQLDirectories");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string RootSQLPath {
            get {
                return this.RootSQLPathField;
            }
            set {
                if ((object.ReferenceEquals(this.RootSQLPathField, value) != true)) {
                    this.RootSQLPathField = value;
                    this.RaisePropertyChanged("RootSQLPath");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string SQLComparePath {
            get {
                return this.SQLComparePathField;
            }
            set {
                if ((object.ReferenceEquals(this.SQLComparePathField, value) != true)) {
                    this.SQLComparePathField = value;
                    this.RaisePropertyChanged("SQLComparePath");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string SQLOutputPath {
            get {
                return this.SQLOutputPathField;
            }
            set {
                if ((object.ReferenceEquals(this.SQLOutputPathField, value) != true)) {
                    this.SQLOutputPathField = value;
                    this.RaisePropertyChanged("SQLOutputPath");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string SQLServer {
            get {
                return this.SQLServerField;
            }
            set {
                if ((object.ReferenceEquals(this.SQLServerField, value) != true)) {
                    this.SQLServerField = value;
                    this.RaisePropertyChanged("SQLServer");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string ServerSourcePath {
            get {
                return this.ServerSourcePathField;
            }
            set {
                if ((object.ReferenceEquals(this.ServerSourcePathField, value) != true)) {
                    this.ServerSourcePathField = value;
                    this.RaisePropertyChanged("ServerSourcePath");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string SourcePath {
            get {
                return this.SourcePathField;
            }
            set {
                if ((object.ReferenceEquals(this.SourcePathField, value) != true)) {
                    this.SourcePathField = value;
                    this.RaisePropertyChanged("SourcePath");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string[] TargetAppServers {
            get {
                return this.TargetAppServersField;
            }
            set {
                if ((object.ReferenceEquals(this.TargetAppServersField, value) != true)) {
                    this.TargetAppServersField = value;
                    this.RaisePropertyChanged("TargetAppServers");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string[] TargetRAMQServers {
            get {
                return this.TargetRAMQServersField;
            }
            set {
                if ((object.ReferenceEquals(this.TargetRAMQServersField, value) != true)) {
                    this.TargetRAMQServersField = value;
                    this.RaisePropertyChanged("TargetRAMQServers");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string[] TargetSMServers {
            get {
                return this.TargetSMServersField;
            }
            set {
                if ((object.ReferenceEquals(this.TargetSMServersField, value) != true)) {
                    this.TargetSMServersField = value;
                    this.RaisePropertyChanged("TargetSMServers");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string VirtualEnvironmentName {
            get {
                return this.VirtualEnvironmentNameField;
            }
            set {
                if ((object.ReferenceEquals(this.VirtualEnvironmentNameField, value) != true)) {
                    this.VirtualEnvironmentNameField = value;
                    this.RaisePropertyChanged("VirtualEnvironmentName");
                }
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(ConfigurationName="DeploymentManagerServiceReference.IDeploymentService")]
    public interface IDeploymentService {
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDeploymentService/Deploy", ReplyAction="http://tempuri.org/IDeploymentService/DeployResponse")]
        void Deploy(DeploymentManager_GUI.DeploymentManagerServiceReference.DeploymentDTO deploymentDTO);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDeploymentService/Deploy", ReplyAction="http://tempuri.org/IDeploymentService/DeployResponse")]
        System.Threading.Tasks.Task DeployAsync(DeploymentManager_GUI.DeploymentManagerServiceReference.DeploymentDTO deploymentDTO);
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface IDeploymentServiceChannel : DeploymentManager_GUI.DeploymentManagerServiceReference.IDeploymentService, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class DeploymentServiceClient : System.ServiceModel.ClientBase<DeploymentManager_GUI.DeploymentManagerServiceReference.IDeploymentService>, DeploymentManager_GUI.DeploymentManagerServiceReference.IDeploymentService {
        
        public DeploymentServiceClient() {
        }
        
        public DeploymentServiceClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public DeploymentServiceClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public DeploymentServiceClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public DeploymentServiceClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public void Deploy(DeploymentManager_GUI.DeploymentManagerServiceReference.DeploymentDTO deploymentDTO) {
            base.Channel.Deploy(deploymentDTO);
        }
        
        public System.Threading.Tasks.Task DeployAsync(DeploymentManager_GUI.DeploymentManagerServiceReference.DeploymentDTO deploymentDTO) {
            return base.Channel.DeployAsync(deploymentDTO);
        }
    }
}
