package com.student;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

   // private static final String URL =
    //        "jdbc:mysql://YOUR-RDS-ENDPOINT:3306/studentdb";

    private static final String URL =
        "jdbc:mysql://localhost:3306/studentdb";

    private static final String USERNAME = "admin";
    private static final String PASSWORD = "Student@123456";

    public static Connection getConnection() {

        Connection con = null;

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    URL,
                    USERNAME,
                    PASSWORD);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return con;
    }
}