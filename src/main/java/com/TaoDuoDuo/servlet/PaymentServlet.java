package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.entity.Order;
import com.TaoDuoDuo.entity.OrderDetail;
import com.TaoDuoDuo.entity.OrderStatus;
import com.TaoDuoDuo.service.ProductService;
import com.TaoDuoDuo.service.OrderService;
import com.TaoDuoDuo.service.OrderManagementService;
import com.TaoDuoDuo.dao.OrderDao;
import com.TaoDuoDuo.dao.OrderDetailDao;
import com.TaoDuoDuo.util.PayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Optional;

@WebServlet(name = "PaymentServlet", value = "/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private ProductService productService;
    private OrderService orderService;
    private OrderManagementService orderManagementService;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        orderService = new OrderService();
        orderManagementService = new OrderManagementService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // 检查用户登录状态和角色权限
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        Integer userRole = (Integer) request.getSession().getAttribute("role");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=required");
            return;
        }

        // 检查用户角色，只有用户身份才能购买商品
        if (userRole == null || userRole != 1) {
            response.sendRedirect(request.getContextPath() + "/view/error.jsp?error=" +
                    java.net.URLEncoder.encode("只有用户身份才能购买商品", "UTF-8"));
            return;
        }

        try {
            // 获取参数 - 支持两种支付方式
            String orderIdStr = request.getParameter("orderId");
            String productIdStr = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");

            if (orderIdStr != null) {
                // 方式1：从订单页面支付（传递orderId）
                handleOrderPayment(request, response, userId, Integer.parseInt(orderIdStr));
            } else if (productIdStr != null && quantityStr != null) {
                // 方式2：直接商品支付（传递productId和quantity）
                handleDirectProductPayment(request, response, userId, Integer.parseInt(productIdStr), Integer.parseInt(quantityStr));
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少必要参数：需要orderId或者(productId和quantity)");
                return;
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "参数格式错误");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "支付请求失败: " + e.getMessage());
        }
    }

    /**
     * 处理订单支付（从订单页面跳转过来的支付）
     */
    private void handleOrderPayment(HttpServletRequest request, HttpServletResponse response, 
                                  int userId, int orderId) throws IOException {
        try {
            // 获取订单信息
            OrderDao orderDao = new OrderDao();
            Optional<Order> orderOpt = orderDao.getOrderById(orderId);
            if (!orderOpt.isPresent()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "订单不存在");
                return;
            }

            Order order = orderOpt.get();

            // 验证订单所有权
            if (order.getUser_id() != userId) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权限访问此订单");
                return;
            }

            // 验证订单状态
            if (!"unpaid".equals(order.getOrder_status())) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "订单状态不允许支付");
                return;
            }

            // 生成支付宝订单号（如果还没有）
            String outTradeNo;
            if (order.getAlipay_order_no() != null && !order.getAlipay_order_no().trim().isEmpty()) {
                outTradeNo = order.getAlipay_order_no();
            } else {
                outTradeNo = generateOrderNo(orderId);
                // 更新订单的支付宝订单号
                order.setAlipay_order_no(outTradeNo);
                orderDao.updateOrder(order);
            }

            // 订单总金额
            String totalAmountStr = BigDecimal.valueOf(order.getTotal_amount())
                    .setScale(2, RoundingMode.HALF_UP).toString();

            // 商品标题（使用订单ID作为标题）
            String subject = "淘多多订单 #" + orderId;

            // 调用支付宝支付
            String paymentForm = PayUtil.createPaymentForm(outTradeNo, totalAmountStr, subject);

            // 输出支付表单
            PrintWriter out = response.getWriter();
            out.println(paymentForm);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "订单支付失败: " + e.getMessage());
        }
    }

    /**
     * 处理直接商品支付（从商品页面直接支付）
     */
    private void handleDirectProductPayment(HttpServletRequest request, HttpServletResponse response,
                                          int userId, int productId, int quantity) throws IOException {
        try {
            // 使用OrderService进行订单验证
            OrderService.OrderValidationResult validation = orderService.validateSingleProductOrder(userId, productId, quantity);

            if (!validation.isValid()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, validation.getErrorMessage());
                return;
            }

            // 获取商品信息
            Product product = productService.getProductById(productId);
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "商品不存在");
                return;
            }

            // 计算总价
            BigDecimal unitPrice = BigDecimal.valueOf(product.getPrice());
            BigDecimal totalAmount = unitPrice.multiply(BigDecimal.valueOf(quantity));

            // 先创建订单
            OrderDao orderDao = new OrderDao();
            Order order = new Order(userId, product.getShop_id(), OrderStatus.UNPAID.getValue(), totalAmount.doubleValue());
            
            boolean orderCreated = orderDao.addOrder(order);
            if (!orderCreated) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "创建订单失败");
                return;
            }

            // 生成支付宝订单号
            String outTradeNo = generateOrderNo(order.getOrder_id());
            
            // 更新订单的支付宝订单号
            order.setAlipay_order_no(outTradeNo);
            orderDao.updateOrder(order);

            // 创建订单详情
            OrderDetailDao orderDetailDao = new OrderDetailDao();
            OrderDetail detail = new OrderDetail(
                order.getOrder_id(),
                productId,
                quantity,
                product.getPrice(),
                outTradeNo
            );
            orderDetailDao.addOrderDetail(detail);

            String totalAmountStr = totalAmount.setScale(2, RoundingMode.HALF_UP).toString();

            // 商品标题
            String subject = product.getProduct_name();

            // 调用支付宝支付
            String paymentForm = PayUtil.createPaymentForm(outTradeNo, totalAmountStr, subject);

            // 输出支付表单
            PrintWriter out = response.getWriter();
            out.println(paymentForm);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "商品支付失败: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    /**
     * 生成订单号
     */
    private String generateOrderNo(int orderId) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String timestamp = sdf.format(new Date());
        int random = (int) (Math.random() * 10000);
        return timestamp + orderId + random;
    }
}
