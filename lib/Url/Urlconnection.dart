class UrlCollection{
   static String baseApi="http://foodtruck.websquareit.com/index.php/welcome/";

   static String login_url=baseApi+"user_login";

   static String reg_url=baseApi+"insert_user_data";
   static String add_user_url=baseApi+"user_regis";
   static String token_genrate=baseApi+"token_generate";
   static String logout=baseApi+"logout";
   static String contact_us=baseApi+"contact_us";
   //static String token_genrate="http://foodtruck.websquareit.com/token.php";

   static String login(String email, String password) {
      return baseApi + 'login?email=' + email + '&password=' + password;
   }
}


