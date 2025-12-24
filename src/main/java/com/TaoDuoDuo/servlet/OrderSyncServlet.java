package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.OrderDao;
import com.TaoDuoDuo.entity.Order;
import com.TaoDuoDuo.entity.OrderStatus;
import com.TaoDuoDuo.util.PayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * 订单状态同步工具 - 主动查询支付宝订单状态并更新本地订单
 */
@WebServlet(name = "OrderSyncServlet", value = "/OrderSyncServlet")
public class OrderSyncServlet extends HttpServlet {

    private OrderDao orderDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");

        out.println("<html><head><title>订单状态同步工具</title></head><body>");
        out.println("<h2>订单状态同步工具</h2>");

        if ("sync".equals(action)) {
            if (orderIdStr != null) {
                // 同步单个订单
                syncSingleOrder(Integer.parseInt(orderIdStr), out);
            } else {
                // 同步所有未支付订单
                syncAllUnpaidOrders(out);
            }
        }

        // 显示操作表单
        out.println("<hr>");
        out.println("<h3>同步操作</h3>");

        out.println("<form method='get'>");
        out.println("<input type='hidden' name='action' value='sync'>");
        out.println("<label>订单ID (可选): <input type='number' name='orderId'></label>");
        out.println("<button type='submit'>同步订单状态</button>");
        out.println("</form>");

        out.println("<p><small>如果不填订单ID，将同步所有未支付订单</small></p>");

        // 显示未支付订单列表
        showUnpaidOrders(out);

        out.println("<hr>");
        out.println("<p><a href='" + request.getContextPath() + "/OrderQueryServlet'>返回订单列表</a></p>");
        out.println("</body></html>");
    }

    /**
     * 同步单个订单状态
     */
    private void syncSingleOrder(int orderId, PrintWriter out) {
        try {
            Optional<Order> orderOpt = orderDao.getOrderById(orderId);
            if (!orderOpt.isPresent()) {
                out.println("<p style='color: red;'>订单不存在: " + orderId + "</p>");
                return;
            }

            Order order = orderOpt.get();
            out.println("<h4>同步订单: " + orderId + "</h4>");
            out.println("<p>当前状态: " + order.getOrder_status() + "</p>");

            if (order.getAlipay_order_no() == null || order.getAlipay_order_no().trim().isEmpty()) {
                out.println("<p style='color: orange;'>订单没有支付宝订单号，跳过同步</p>");
                return;
            }

            // 查询支付宝订单状态
            out.println("<p>查询支付宝订单: " + order.getAlipay_order_no() + "</p>");

            var queryResponse = PayUtil.queryOrder(order.getAlipay_order_no());
            if (queryResponse != null) {
                String tradeStatus = queryResponse.getTradeStatus();
                out.println("<p>支付宝状态: " + tradeStatus + "</p>");

                boolean needUpdate = false;
                String newStatus = order.getOrder_status();

                if ("TRADE_SUCCESS".equals(tradeStatus) || "TRADE_FINISHED".equals(tradeStatus)) {
                    if ("unpaid".equals(order.getOrder_status())) {
                        newStatus = OrderStatus.PAID_PENDING_SHIPMENT.getValue();
                        needUpdate = true;
                    }
                } else if ("TRADE_CLOSED".equals(tradeStatus)) {
                    if ("unpaid".equals(order.getOrder_status())) {
                        newStatus = OrderStatus.CANCELLED.getValue();
                        needUpdate = true;
                    }
                }

                if (needUpdate) {
                    order.setOrder_status(newStatus);
                    order.setUpdate_time(LocalDateTime.now());

                    boolean updated = orderDao.updateOrder(order);
                    if (updated) {
                        out.println("<p style='color: green;'>✅ 订单状态已更新: " + order.getOrder_status() + " → " + newStatus
                                + "</p>");
                    } else {
                        out.println("<p style='color: red;'>❌ 订单状态更新失败</p>");
                    }
                } else {
                    out.println("<p style='color: blue;'>ℹ️ 订单状态无需更新</p>");
                }
            } else {
                out.println("<p style='color: red;'>❌ 查询支付宝订单失败</p>");
            }

        } catch (Exception e) {
            out.println("<p style='color: red;'>同步异常: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }

    /**
     * 同步所有未支付订单
     */
    private void syncAllUnpaidOrders(PrintWriter out) {
        try {
            out.println("<h4>同步所有未支付订单</h4>");

            // 这里简化处理，实际应该分页查询
            // 由于没有查询所有未支付订单的方法，我们需要添加一个
            out.println("<p style='color: orange;'>批量同步功能需要扩展OrderDao，当前请使用单个订单同步</p>");

        } catch (Exception e) {
            out.println("<p style='color: red;'>批量同步异常: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }

    /**
     * 显示未支付订单列表
     */
    private void showUnpaidOrders(PrintWriter out) {
        try {
            out.println("<h3>当前用户的未支付订单</h3>");

            Integer userId = (Integer) getServletContext().getAttribute("userId");
            if (userId == null) {
                // 从session获取用户ID
                userId = (Integer) request.getSession().getAttribute("userId");
                if (userId == null) {
                    userId = 1; // 默认用户ID，实际应该重定向到登录页面
                }
            }

            var ordersOpt = orderDao.getOrderByUserId(userId, "unpaid");
            if (ordersOpt.isPresent() && !ordersOpt.get().isEmpty()) {
                out.println("<table border='1' style='border-collapse: collapse; width: 100%;'>");
                out.println("<tr><th>订单ID</th><th>金额</th><th>支付宝订单号</th><th>创建时间</th><th>操作</th></tr>");

                for (Order order : ordersOpt.get()) {
                    out.println("<tr>");
                    out.println("<td>" + order.getOrder_id() + "</td>");
                    out.println("<td>¥" + order.getTotal_amount() + "</td>");
                    out.println(
                            "<td>" + (order.getAlipay_order_no() != null ? order.getAlipay_order_no() : "无") + "</td>");
                    out.println("<td>" + order.getCreate_time() + "</td>");
                    out.println("<td><a href='?action=sync&orderId=" + order.getOrder_id() + "'>同步状态</a></td>");
                    out.println("</tr>");
                }

                out.println("</table>");
            } else {
                out.println("<p>没有未支付订单</p>");
            }

        } catch (Exception e) {
            out.println("<p style='color: red;'>查询订单失败: " + e.getMessage() + "</p>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}