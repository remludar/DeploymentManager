// Decompiled with JetBrains decompiler
// Type: DeploymentBuilder.DeploymentBuilderForm
// Assembly: DeploymentBuilder, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 6DC3A0D0-93E6-492C-8406-B8C6AF25D2EB
// Assembly location: C:\Users\jason.ewton\Dropbox\Work\Projects\Motiva\_repos\DeploymentManager\bin\Debug\DeploymentBuilder\DeploymentBuilder.exe

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace DeploymentBuilder
{
  public class DeploymentBuilderForm : Form
  {
    private string sqlFileNameShort = "SQLBuild";
    private string sqlBuildFileName = "";
    private string breakLine = "------------------------------------------------------------------------------------------------------------------";
    private string beginOf = "--Begining Of {0}";
    private string endOf = "--Ending Of {0}";
    private List<string> subDirectories = new List<string>()
    {
      "Tables",
      "Constraints",
      "Triggers",
      "Functions",
      "Views",
      "StoredProcedures",
      "SeedScripts"
    };
    private IContainer components = (IContainer) null;
    private Button btn_BuildSQL;
    private Button btn_sqlfolder;
    private FolderBrowserDialog folderBrowserSql;
    private TextBox txt_sqlFolder;
    private Button btn_copyToClip;
    private Label label1;
    private TextBox txt_CompareToFolder;
    private Button btn_CompareToFolder;
    private Label label2;
    private CheckBox checkBox1;

    public DeploymentBuilderForm()
    {
      this.InitializeComponent();
    }

    private void saveFileDialog1_FileOk(object sender, CancelEventArgs e)
    {
    }

    private void button1_Click(object sender, EventArgs e)
    {
      int num = (int) this.folderBrowserSql.ShowDialog();
      this.txt_sqlFolder.Text = this.folderBrowserSql.SelectedPath + "\\";
    }

    private void btn_BuildSQL_Click(object sender, EventArgs e)
    {
      this.BuildSQLFile();
      if (!this.checkBox1.Checked)
        return;
      this.BuildBackoutFile();
    }

    private void BuildSQLFile()
    {
      this.sqlBuildFileName = this.sqlFileNameShort + ".sql";
      this.BuildSQLFile(this.txt_sqlFolder.Text, this.txt_CompareToFolder.Text, this.txt_sqlFolder.Text);
      int num = (int) MessageBox.Show("File " + this.sqlBuildFileName + " has been generated");
    }

    private void BuildBackoutFile()
    {
      this.sqlBuildFileName = this.sqlFileNameShort + "Backout.sql";
      this.subDirectories.Remove("Table");
      this.subDirectories.Remove("Constraints");
      this.subDirectories.Remove("Triggers");
      this.subDirectories.Remove("Seedscripts");
      this.BuildSQLFile(this.txt_CompareToFolder.Text, this.txt_sqlFolder.Text, this.txt_sqlFolder.Text);
      int num = (int) MessageBox.Show("File " + this.sqlBuildFileName + " has been generated");
    }

    private void btn_copyToClip_Click(object sender, EventArgs e)
    {
      string[] strArray = File.ReadAllLines(this.txt_sqlFolder.Text + this.sqlBuildFileName);
      StringBuilder stringBuilder = new StringBuilder();
      foreach (string str in strArray)
        stringBuilder.AppendLine(str);
      Clipboard.SetText(stringBuilder.ToString());
      int num = (int) MessageBox.Show("File Text for " + this.sqlBuildFileName + " has been copied to the clipboard");
    }

    private void btn_CompareToFolder_Click(object sender, EventArgs e)
    {
      int num = (int) this.folderBrowserSql.ShowDialog();
      this.txt_CompareToFolder.Text = this.folderBrowserSql.SelectedPath + "\\";
    }

    public void BuildSQLFile(string sourceDirectory, string compareDirectory, string outputDirectory)
    {
      DirectoryInfo directory1 = new DirectoryInfo(sourceDirectory);
      DirectoryInfo directoryInfo = new DirectoryInfo(outputDirectory);
      DirectoryInfo directory2 = ((IEnumerable<DirectoryInfo>) directory1.GetDirectories("PreBuild")).FirstOrDefault<DirectoryInfo>();
      DirectoryInfo directory3 = ((IEnumerable<DirectoryInfo>) directory1.GetDirectories("PostBuild")).FirstOrDefault<DirectoryInfo>();
      DirectoryInfo compareDirectory1 = (DirectoryInfo) null;
      DirectoryInfo compareDirectory2 = (DirectoryInfo) null;
      DirectoryInfo compareDirectory3 = (DirectoryInfo) null;
      if (!string.IsNullOrEmpty(compareDirectory))
      {
        compareDirectory1 = new DirectoryInfo(compareDirectory);
        compareDirectory2 = ((IEnumerable<DirectoryInfo>) compareDirectory1.GetDirectories("PreBuild")).FirstOrDefault<DirectoryInfo>();
        compareDirectory3 = ((IEnumerable<DirectoryInfo>) compareDirectory1.GetDirectories("PostBuild")).FirstOrDefault<DirectoryInfo>();
      }
      using (StreamWriter sw = new StreamWriter(Path.Combine(directoryInfo.FullName, this.sqlBuildFileName), false))
      {
        this.BeginOf(sw, "Script");
        if (directory2 != null)
          this.BuildScript(directory2, compareDirectory2, sw);
        this.BuildScript(directory1, compareDirectory1, sw);
        if (directory3 != null)
          this.BuildScript(directory3, compareDirectory3, sw);
        this.EndOf(sw, "Script");
        sw.Flush();
        sw.Close();
      }
    }

    public void BuildScript(DirectoryInfo directory, DirectoryInfo compareDirectory, StreamWriter sw)
    {
      foreach (string subDirectory in this.subDirectories)
      {
        DirectoryInfo directoryInfo = ((IEnumerable<DirectoryInfo>) directory.GetDirectories(subDirectory)).FirstOrDefault<DirectoryInfo>();
        if (directoryInfo != null)
        {
          foreach (FileInfo file in directoryInfo.GetFiles())
          {
            if (compareDirectory == null || ((IEnumerable<DirectoryInfo>) compareDirectory.GetDirectories(subDirectory)).FirstOrDefault<DirectoryInfo>() == null || !this.FileHasNotChanged(((IEnumerable<DirectoryInfo>) compareDirectory.GetDirectories(subDirectory)).FirstOrDefault<DirectoryInfo>(), file))
            {
              this.BeginOf(sw, Path.Combine(directory.Name, Path.Combine(directoryInfo.Name, file.Name)));
              this.AddSettings(sw);
              StreamReader streamReader = File.OpenText(file.FullName);
              for (string str = streamReader.ReadLine(); str != null; str = streamReader.ReadLine())
                sw.WriteLine(str);
              sw.WriteLine("Go");
              this.EndOf(sw, Path.Combine(directory.Name, Path.Combine(directoryInfo.Name, file.Name)));
              streamReader.Close();
            }
          }
        }
      }
    }

    private bool FileHasNotChanged(DirectoryInfo compareDirectory, FileInfo file)
    {
      if (compareDirectory != null)
      {
        FileInfo[] files = compareDirectory.GetFiles(file.Name);
        if (((IEnumerable<FileInfo>) files).Count<FileInfo>() == 0)
          return false;
        if (((IEnumerable<FileInfo>) files).Count<FileInfo>() == 1)
        {
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

    private void BeginOf(StreamWriter sw, string text)
    {
      sw.WriteLine(string.Empty);
      sw.WriteLine(this.breakLine);
      sw.WriteLine(string.Format(this.beginOf, (object) text));
      sw.WriteLine(this.breakLine);
      sw.WriteLine(string.Empty);
    }

    private void EndOf(StreamWriter sw, string text)
    {
      sw.WriteLine(string.Empty);
      sw.WriteLine(this.breakLine);
      sw.WriteLine(string.Format(this.endOf, (object) text));
      sw.WriteLine(this.breakLine);
      sw.WriteLine(string.Empty);
    }

    private void AddSettings(StreamWriter sw)
    {
      sw.WriteLine(this.breakLine);
      sw.WriteLine("SET ANSI_NULLS ON");
      sw.WriteLine("Go");
      sw.WriteLine("SET QUOTED_IDENTIFIER OFF");
      sw.WriteLine("Go");
      sw.WriteLine(this.breakLine);
    }

    private void DeploymentBuilderForm_Load(object sender, EventArgs e)
    {
      this.txt_sqlFolder.Text = Directory.GetCurrentDirectory();
    }

    protected override void Dispose(bool disposing)
    {
      if (disposing && this.components != null)
        this.components.Dispose();
      base.Dispose(disposing);
    }

    private void InitializeComponent()
    {
      this.btn_BuildSQL = new Button();
      this.btn_sqlfolder = new Button();
      this.folderBrowserSql = new FolderBrowserDialog();
      this.txt_sqlFolder = new TextBox();
      this.btn_copyToClip = new Button();
      this.label1 = new Label();
      this.txt_CompareToFolder = new TextBox();
      this.btn_CompareToFolder = new Button();
      this.label2 = new Label();
      this.checkBox1 = new CheckBox();
      this.SuspendLayout();
      this.btn_BuildSQL.Location = new Point(211, 74);
      this.btn_BuildSQL.Name = "btn_BuildSQL";
      this.btn_BuildSQL.Size = new Size(108, 23);
      this.btn_BuildSQL.TabIndex = 2;
      this.btn_BuildSQL.Text = "Build SQL File";
      this.btn_BuildSQL.UseVisualStyleBackColor = true;
      this.btn_BuildSQL.Click += new EventHandler(this.btn_BuildSQL_Click);
      this.btn_sqlfolder.Location = new Point(403, 16);
      this.btn_sqlfolder.Name = "btn_sqlfolder";
      this.btn_sqlfolder.Size = new Size(28, 23);
      this.btn_sqlfolder.TabIndex = 1;
      this.btn_sqlfolder.Text = "....";
      this.btn_sqlfolder.UseVisualStyleBackColor = true;
      this.btn_sqlfolder.Click += new EventHandler(this.button1_Click);
      this.txt_sqlFolder.Location = new Point(109, 18);
      this.txt_sqlFolder.Name = "txt_sqlFolder";
      this.txt_sqlFolder.Size = new Size(288, 20);
      this.txt_sqlFolder.TabIndex = 0;
      this.btn_copyToClip.Location = new Point(325, 73);
      this.btn_copyToClip.Name = "btn_copyToClip";
      this.btn_copyToClip.Size = new Size(107, 23);
      this.btn_copyToClip.TabIndex = 3;
      this.btn_copyToClip.Text = "Copy to Clipboard";
      this.btn_copyToClip.UseVisualStyleBackColor = true;
      this.btn_copyToClip.Click += new EventHandler(this.btn_copyToClip_Click);
      this.label1.AutoSize = true;
      this.label1.Location = new Point(9, 21);
      this.label1.Name = "label1";
      this.label1.Size = new Size(100, 13);
      this.label1.TabIndex = 4;
      this.label1.Text = "Source SQL Folder:";
      this.txt_CompareToFolder.Location = new Point(109, 44);
      this.txt_CompareToFolder.Name = "txt_CompareToFolder";
      this.txt_CompareToFolder.Size = new Size(288, 20);
      this.txt_CompareToFolder.TabIndex = 5;
      this.btn_CompareToFolder.Location = new Point(403, 44);
      this.btn_CompareToFolder.Name = "btn_CompareToFolder";
      this.btn_CompareToFolder.Size = new Size(28, 23);
      this.btn_CompareToFolder.TabIndex = 6;
      this.btn_CompareToFolder.Text = "....";
      this.btn_CompareToFolder.UseVisualStyleBackColor = true;
      this.btn_CompareToFolder.Click += new EventHandler(this.btn_CompareToFolder_Click);
      this.label2.AutoSize = true;
      this.label2.Location = new Point(9, 47);
      this.label2.Name = "label2";
      this.label2.Size = new Size(102, 13);
      this.label2.TabIndex = 8;
      this.label2.Text = "Compare Files (Opt):";
      this.checkBox1.AutoSize = true;
      this.checkBox1.Location = new Point(22, 74);
      this.checkBox1.Name = "checkBox1";
      this.checkBox1.Size = new Size(80, 17);
      this.checkBox1.TabIndex = 9;
      this.checkBox1.Text = "Generate Backout";
      this.checkBox1.UseVisualStyleBackColor = true;
      this.AutoScaleDimensions = new SizeF(6f, 13f);
      this.AutoScaleMode = AutoScaleMode.Font;
      this.ClientSize = new Size(455, 106);
      this.Controls.Add((Control) this.checkBox1);
      this.Controls.Add((Control) this.label2);
      this.Controls.Add((Control) this.btn_CompareToFolder);
      this.Controls.Add((Control) this.txt_CompareToFolder);
      this.Controls.Add((Control) this.label1);
      this.Controls.Add((Control) this.btn_copyToClip);
      this.Controls.Add((Control) this.txt_sqlFolder);
      this.Controls.Add((Control) this.btn_sqlfolder);
      this.Controls.Add((Control) this.btn_BuildSQL);
      this.Name = nameof (DeploymentBuilderForm);
      this.Text = "Deployment Builder";
      this.Load += new EventHandler(this.DeploymentBuilderForm_Load);
      this.ResumeLayout(false);
      this.PerformLayout();
    }
  }
}
