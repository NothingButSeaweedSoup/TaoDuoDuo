package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.service.UserRoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "TestRoleServlet", value = "/TestRoleServlet")
public class TestRoleServlet extends HttpServlet {
    private UserRoleService userRoleService;

    @Override
    public void init() throws ServletException {
        userRoleService = new UserRoleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            out.println("<h3>请先登录</h3>");
            out.println("<a href='" + request.getContextPath() + "/view/login.jsp'>去登录</a>");
            return;
        }

        String action = request.getParameter("action");

        out.println("<!DOCTYPE html>");
        out.println("<html><head><meta charset='UTF-8'><title>角色测试</title></head><body>");
        out.println("<h2>用户角色测试页面</h2>");
        out.println("<p>当前用户ID: " + userId + "</p>");

        // 显示当前角色数量
        int roleCount = userRoleService.getUserRoleCount(userId);
        out.println("<p>当前角色数量: " + roleCount + "</p>");

        // 显示各角色状态
        out.println("<p>角色状态:</p>");
        out.println("<ul>");
        out.println("<li>用户角色: " + (userRoleService.hasRole(userId, 1) ? "✓" : "✗") + "</li>");
        out.println("<li>商家角色: " + (userRoleService.hasRole(userId, 2) ? "✓" : "✗") + "</li>");
        out.println("<li>管理员角色: " + (userRoleService.hasRole(userId, 3) ? "✓" : "✗") + "</li>");
        out.println("</ul>");

        if ("addMerchant".equals(action)) {
            boolean success = userRoleService.addUserRole(userId, 2);
            out.println("<p style='color: " + (success ? "green" : "red") + "'>添加商家角色: " + (success ? "成功" : "失败")
                    + "</p>");
        } else if ("addAdmin".equals(action)) {
            boolean success = userRoleService.addUserRole(userId, 3);
            out.println("<p style='color: " + (success ? "green" : "red") + "'>添加管理员角色: " + (success ? "成功" : "失败")
                    + "</p>");
        } else if ("removeMerchant".equals(action)) {
            boolean success = userRoleService.removeUserRole(userId, 2);
            out.println("<p style='color: " + (success ? "green" : "red") + "'>移除商家角色: " + (success ? "成功" : "失败")
                    + "</p>");
        } else if ("removeAdmin".equals(action)) {
            boolean success = userRoleService.removeUserRole(userId, 3);
            out.println("<p style='color: " + (success ? "green" : "red") + "'>移除管理员角色: " + (success ? "成功" : "失败")
                    + "</p>");
        }

        out.println("<h3>操作:</h3>");
        out.println("<a href='?action=addMerchant' style='margin-right: 10px;'>添加商家角色</a>");
        out.println("<a href='?action=addAdmin' style='margin-right: 10px;'>添加管理员角色</a>");
        out.println("<a href='?action=removeMerchant' style='margin-right: 10px;'>移除商家角色</a>");
        out.println("<a href='?action=removeAdmin' style='margin-right: 10px;'>移除管理员角色</a>");

        out.println("<br><br>");
        out.println("<a href='" + request.getContextPath() + "/ProfileServlet'>查看个人中心</a>");
        out.println("<br>");
        out.println("<a href='" + request.getContextPath() + "/index.jsp'>返回首页</a>");

        out.println("</body></html>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}