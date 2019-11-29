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
    public class ProductController : ApiController
    {
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        [Route("api/customer/getproduct")]
        [HttpPost]
        public HttpResponseMessage GetProducts(ProductParam productparam)
        {
            HttpResponseMessage response = new HttpResponseMessage();
            SqlConnection cn = new SqlConnection(ConfigManager.connectionString);
            String result = "";
            try
            {
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = cn;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.CommandText = "Customer.sp_GetProducts";
                cmd.Parameters.AddWithValue("@Name", productparam.name);
                cmd.Parameters.AddWithValue("@StartPage", productparam.startPage);
                cmd.Parameters.AddWithValue("@RowsPerPage", productparam.rowsPerPage);
                cn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                List<ProductListDetail> lpld = new List<ProductListDetail>();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        ProductListDetail pld = new ProductListDetail();
                        pld.name = dr["name"].ToString();
                        pld.description = dr["description"].ToString();
                        pld.price = float.Parse(dr["price"].ToString());

                        lpld.Add(pld);
                    }
                }

                response = Request.CreateResponse(HttpStatusCode.OK, lpld);
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
