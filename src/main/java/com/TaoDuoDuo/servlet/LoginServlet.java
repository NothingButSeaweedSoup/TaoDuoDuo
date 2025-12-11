package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.User;
import com.TaoDuoDuo.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/view/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=empty");
            return;
        }

        Optional<User> userOptional = userService.login(username.trim(), password);

        if (userOptional.isPresent()) {
            User user = userOptional.get();
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUser_id());
            session.setAttribute("username", user.getUsername());
            // 默认以用户身份登录 (1-用户，2-商家，3-管理员)
            session.setAttribute("role", 1);

            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=invalid");
        }
    }
}
