package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.User;
import com.TaoDuoDuo.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "RegisterServlet", value = "/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/view/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 参数验证
        if (username == null || username.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view/register.jsp?error=empty");
            return;
        }

        // 验证两次密码是否一致
        if (!password.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/view/register.jsp?error=mismatch");
            return;
        }

        // 调用服务层进行注册
        Optional<User> userOptional = userService.register(
                username.trim(),
                password,
                email.trim(),
                phone.trim());

        if (userOptional.isPresent()) {
            // 注册成功，跳转到登录页面
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?success=true");
        } else {
            // 注册失败（用户名、邮箱或手机号已存在）
            response.sendRedirect(request.getContextPath() + "/view/register.jsp?error=exists");
        }
    }
}
