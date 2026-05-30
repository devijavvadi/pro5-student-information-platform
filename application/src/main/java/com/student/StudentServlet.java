package com.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/student")
public class StudentServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String course = request.getParameter("course");

        response.setContentType("text/html");

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "INSERT INTO students(name,email,course) VALUES(?,?,?)";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, course);

            int rows = ps.executeUpdate();

            PrintWriter out = response.getWriter();

            if (rows > 0) {
                out.println("<h2>Student Saved Successfully</h2>");
            } else {
                out.println("<h2>Failed To Save Student</h2>");
            }

            con.close();

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter()
                    .println("<h2>Error : " + e.getMessage() + "</h2>");
        }
    }
}