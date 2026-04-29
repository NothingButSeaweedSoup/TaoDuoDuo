package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.UserRole;
import com.TaoDuoDuo.service.UserRoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "ProfileServlet", value = "/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private UserRoleService userRoleService;

    @Override
    public void init() throws ServletException {
        userRoleService = new UserRoleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        Integer userId = (Integer) session.getAttribute("userId");
        Integer userRole = (Integer) session.getAttribute("role");

        // 检查用户是否登录
        if (username == null || userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=required");
            return;
        }

        // 获取用户角色数量，判断是否可以切换身份
        int roleCount = userRoleService.getUserRoleCount(userId);
        boolean canSwitchRole = roleCount >= 2;

        // 获取用户拥有的所有角色
        Optional<List<UserRole>> userRolesOpt = userRoleService.getUserRoles(userId);
        List<UserRole> userRoles = userRolesOpt.orElse(null);

        // 处理消息参数
        String success = request.getParameter("success");
        String error = request.getParameter("error");

        // 设置request属性
        request.setAttribute("profileUsername", username);
        request.setAttribute("profileUserId", userId);
        request.setAttribute("profileUserRole", userRole);
        request.setAttribute("profileUser", session.getAttribute("user"));
        request.setAttribute("canSwitchRole", canSwitchRole);
        request.setAttribute("roleCount", roleCount);
        request.setAttribute("userRoles", userRoles);
        request.setAttribute("success", success);
        request.setAttribute("error", error);

        // 转发到个人中心页面
        request.getRequestDispatcher("/view/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}