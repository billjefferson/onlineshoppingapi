using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;

public class ConfigManager
{
    private static string p_connectionString;

    static ConfigManager(){
        connectionString = ConfigurationManager.AppSettings["cs"];
    }

    public static string connectionString {
        get {
            return p_connectionString;
        }
        set {
            p_connectionString = value;
        }
    }

    public static int addErrorLogsToDB(string errorMsg) 
    {
        int result = 0;
        DateTime currentDate = DateTime.Now;

        SqlConnection cn = new SqlConnection(connectionString);

        try {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = cn;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.CommandText = "Error.sp_AddLogs";
            cmd.Parameters.AddWithValue("@LogDate", currentDate);
            cmd.Parameters.AddWithValue("@ErrorMsg", errorMsg);
            cn.Open();

            result = cmd.ExecuteNonQuery();
        }
        catch(SqlException sqlex){
            addErrorLogToTxtFile(sqlex.Message);
        }
        catch(Exception ex){
            addErrorLogToTxtFile(ex.Message);
        }

        cn.Close();
        return result;
    }

    public static int addErrorLogToTxtFile(string errorMsg) {
        int result = 0;
        string errorLine = "";
        DateTime currentDate= DateTime.Now;
        string strCurrentDate = currentDate.ToString("yyyy_MM_dd");
        var folder = System.Web.HttpContext.Current.Server.MapPath("~/ErrorLogs/" + strCurrentDate);
        var file = Path.Combine(folder, "Errors.txt");
        errorLine = currentDate + "\t" + errorMsg + "\n";
        if (File.Exists(file))
        {
            File.AppendAllText(file, errorLine);
        }
        else
        {
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }
            File.WriteAllText(file, errorLine);
        }
        return result;
    }
}
