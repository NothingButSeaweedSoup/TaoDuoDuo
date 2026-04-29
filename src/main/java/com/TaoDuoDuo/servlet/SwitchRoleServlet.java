package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.service.UserRoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "SwitchRoleServlet", value = "/SwitchRoleServlet")
public class SwitchRoleServlet extends HttpServlet {
    private UserRoleService userRoleService;

    @Override
    public void init() throws ServletException {
        userRoleService = new UserRoleService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=required");
            return;
        }

        String roleIdStr = request.getParameter("roleId");
        if (roleIdStr == null || roleIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=invalid_role");
            return;
        }

        try {
            int roleId = Integer.parseInt(roleIdStr);

            // 验证用户是否拥有该角色
            if (userRoleService.hasRole(userId, roleId)) {
                // 更新session中的当前角色
                session.setAttribute("role", roleId);
                response.sendRedirect(request.getContextPath() + "/ProfileServlet?success=role_switched");
            } else {
                response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=no_permission");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ProfileServlet?error=invalid_role");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}