namespace onlineshopping.Models.Customer {
    public class LogIn {
        public string username { get; set; }
        public string password { get; set; }
    }

    public class ProductParam
    {
        public string name { get; set; }
        public int startPage { get; set; }
        public int rowsPerPage { get; set; }
    }

    public class ProductListDetail 
    {
        public string name { get; set; }
        public string description { get; set; }
        public float price { get; set; }
    }
}