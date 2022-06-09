package backend;

public class Form {
    public static class LogIn {
        public static String Username = "username";
        public static String Password = "userpass";
    }
    public static class Register {
        public static String FirstName = "firstname";
        public static String LastName = "lastname";
        public static String Email = "email";
        public static String Gender = "gender";
        public static String Age = "age";
    }
    public static class Type {
        public static String LogIn = "log-in";
        public static String Register = "register";
    }
    public static class Result {
        public static String DatabaseError = "database-error";
        public static String DatabaseConnectionError = "database-connection-error";
        public static String UserNotFound = "user-not-found";
        public static String WrongPassword = "wrong-password";
        public static String InvalidEmail = "invalid-email";
        public static String FormError = "form-error";
        public static String UncaughError = "uncaugh-error";
        public static String NullParameters = "null-parameters";
        public static String Success = "success";
    }
}
