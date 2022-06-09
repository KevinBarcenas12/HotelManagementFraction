package backend;

public class Request {
    public static class Attributes {
        public static String Type = "req-type";
        public static String Command = "req-command";
    }
    public static class Result {
        public static String Success = "req-success";
        public static class Error {
            public static String DatabaseConnectionError = "database-connection-error";
            public static String DatabaseError = "database-error";
            public static String InvalidRequestType = "invalid-req-type";
            public static String InvalidRequestParameters = "invalid-req-params";
            public static String NullRequest = "null-request";
        }
    }
    public static class Type {
        public static final String RoomModify = "req-room-modify";
        public static final String RoomDelete = "req-room-delete";
        public static final String UserModify = "req-user-modify";
        public static final String UserDelete = "req-user-delete";
        public static final String InfoModify = "req-info-modify";
        public static final String InfoDelete = "req-info-delete";
        public static final String RoomRquest = "req-room-reserv";
    }
    public static class Element {
        public static class Room {
            public static String Price = "room-price";
            public static String DiscountPercent = "room-discount-percent";
            public static String Capacity = "room-capacity";
            public static String Services = "room-services";
            public static String Number = "room-Number";
            public static String Res_Start = "room-res-start";
            public static String Res_End = "room-res-end";
        }
        public static class Employee {
            public static String AdminLevel = "employee-admin-level";
            public static String FirstName = "employee-first-name";
            public static String LastName = "employee-last-name";
        }
        public static class Client {
            public static String FirstName = "client-first-name";
            public static String LastName = "client-last-name";
            public static String Email = "client-email";
        }
        public static class Info {
            public static String Mision = "info-mision";
            public static String Vision = "info-vision";
            public static String Phone = "info-phone";
            public static String Name = "info-name";
            public static String Date = "info-date";
        }
    }
}
