package backend;

import java.util.Random;

public class User {
    public static String generateName(String first, String last) {
        String username = "";
        if (first.length() + last.length() < 8) {
            username = first + last;
        }
        else while (username.length() < 5 && username.length() > 16) {
            int Case = new Random().nextInt(2) + 1;
            switch(Case) {
                case 1:
                    username = first.charAt(0) + last;
                    break;
                case 2:
                    username = last + first.charAt(0);
                    break;
                case 3:
                    int f_str = new Random().nextInt(first.length() - 1);
                    int l_str = new Random().nextInt(last.length() - 1);
                    username = first.substring(f_str) + last.substring(l_str);
                    break;
            }
        }
        return username;
    }
    public static String generatePassword(String key) {
        String password = "";
        while (password.length() < 9) {
            int p_str = new Random().nextInt(key.length() / 2 - 1);
            int _p_str = new Random().nextInt(key.length() / 2 - 1) + key.length() / 2;
            
            password = key.substring(p_str, _p_str);
        }
        return password;
    }
    public static class Type {
        public static String Admin = "admin";
        public static String Employee = "employee";
        public static String Client = "client";
    }
}
