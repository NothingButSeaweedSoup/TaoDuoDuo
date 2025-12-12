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

@WebServlet(name = "UpdateProfileServlet", value = "/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=required");
            return;
        }

        // 获取表单参数
        String username = request.getParameter("username");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        try {
            // 验证新密码和确认密码
            if ((newPassword != null && !newPassword.trim().isEmpty()) ||
                    (confirmPassword != null && !confirmPassword.trim().isEmpty())) {

                if (newPassword == null || confirmPassword == null ||
                        !newPassword.equals(confirmPassword)) {
                    response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=" +
                            java.net.URLEncoder.encode("新密码和确认密码不一致", "UTF-8"));
                    return;
                }

                if (newPassword.length() < 6) {
                    response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=" +
                            java.net.URLEncoder.encode("新密码长度不能少于6位", "UTF-8"));
                    return;
                }
            }

            // 获取当前用户信息
            User currentUser = userService.getUserById(userId);
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=" +
                        java.net.URLEncoder.encode("用户不存在", "UTF-8"));
                return;
            }

            // 验证用户名是否已被其他用户使用
            if (username != null && !username.trim().isEmpty() &&
                    !username.equals(currentUser.getUsername())) {
                User existingUser = userService.getUserByUsername(username);
                if (existingUser != null && existingUser.getUser_id() != userId) {
                    response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=" +
                            java.net.URLEncoder.encode("用户名已被使用", "UTF-8"));
                    return;
                }
            }

            // 验证邮箱是否已被其他用户使用
            if (email != null && !email.trim().isEmpty() &&
                    !email.equals(currentUser.getEmail())) {
                User existingUser = userService.getUserByEmail(email);
                if (existingUser != null && existingUser.getUser_id() != userId) {
                    response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=" +
                            java.net.URLEncoder.encode("邮箱已被使用", "UTF-8"));
                    return;
                }
            }

            // 验证手机号是否已被其他用户使用
            if (phone != null && !phone.trim().isEmpty() &&
                    !phone.equals(currentUser.getPhone())) {
                User existingUser = userService.getUserByPhone(phone);
                if (existingUser != null && existingUser.getUser_id() != userId) {
                    response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=" +
                            java.net.URLEncoder.encode("手机号已被使用", "UTF-8"));
                    return;
                }
            }

            // 如果要修改密码，验证旧密码
            boolean passwordChanged = false;
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                if (oldPassword == null || oldPassword.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=" +
                            java.net.URLEncoder.encode("修改密码时必须输入旧密码", "UTF-8"));
                    return;
                }

                if (!userService.verifyPassword(currentUser.getUsername(), oldPassword)) {
                    response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=" +
                            java.net.URLEncoder.encode("旧密码不正确", "UTF-8"));
                    return;
                }
                passwordChanged = true;
            }

            // 更新用户信息
            boolean success = userService.updateUserProfile(userId, username,
                    passwordChanged ? newPassword : null, email, phone);

            if (success) {
                if (passwordChanged) {
                    // 密码修改成功，销毁session并重定向到登录页面
                    session.invalidate();
                    response.sendRedirect(request.getContextPath() + "/view/login.jsp?success=" +
                            java.net.URLEncoder.encode("密码修改成功，请重新登录", "UTF-8"));
                } else {
                    // 只修改了其他信息，更新session中的用户名
                    if (username != null && !username.trim().isEmpty()) {
                        session.setAttribute("username", username);
                    }
                    response.sendRedirect(request.getContextPath() + "/ProfileServlet?success=" +
                            java.net.URLEncoder.encode("个人信息修改成功", "UTF-8"));
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=" +
                        java.net.URLEncoder.encode("修改失败，请重试", "UTF-8"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=" +
                    java.net.URLEncoder.encode("系统错误，请重试", "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}