using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Data.SqlClient;
using System.Web.Http.Cors;

using onlineshopping.Models.Customer;

namespace onlineshopping.Controllers
{
    public class CustomerController : ApiController
    {
        //[EnableCors(origins: "*", headers: "*", methods: "*")]
        [Route("api/customer/login")]
        [HttpPost]
        public HttpResponseMessage LogInUser(LogIn customer) {
            HttpResponseMessage response = new HttpResponseMessage();
            int result = 3;
            SqlConnection cn = new SqlConnection(ConfigManager.connectionString);
            try 
            {
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = cn;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.CommandText = "Customer.sp_LogIn";
                cmd.Parameters.AddWithValue("@UserName", customer.username);
                cmd.Parameters.AddWithValue("@Password", customer.password);
                cn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        if (dr["Result"].ToString() == "1")
                        {
                            //OK
                            result = 1;
                        }
                        else
                        {
                            //Username is only correct
                            result = 2;
                        }
                    }
                }
                else
                {
                    //User not exists
                    result = 3;
                }
                response = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch(SqlException sqlex)
            {
                ConfigManager.addErrorLogsToDB(sqlex.Message);
                response = Request.CreateResponse(HttpStatusCode.InternalServerError, result);
            }
            catch(Exception ex)
            {
                ConfigManager.addErrorLogsToDB(ex.Message);
                response = Request.CreateResponse(HttpStatusCode.InternalServerError, result);
            }

            cn.Close();
            return response;
        }
    }
}