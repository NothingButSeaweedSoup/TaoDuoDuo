package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.service.ProductService;
import com.TaoDuoDuo.service.OrderService;
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

@WebServlet(name = "PaymentServlet", value = "/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private ProductService productService;
    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        orderService = new OrderService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            // 获取参数
            String productIdStr = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");

            if (productIdStr == null || quantityStr == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少必要参数");
                return;
            }

            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            // 使用OrderService进行订单验证
            OrderService.OrderValidationResult validation = orderService.validateSingleProductOrder(1, productId,
                    quantity); // 这里暂时用1作为用户ID，实际应该从session获取

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
            String totalAmountStr = totalAmount.setScale(2, RoundingMode.HALF_UP).toString();

            // 生成订单号（时间戳 + 商品ID + 随机数）
            String outTradeNo = generateOrderNo(productId);

            // 商品标题
            String subject = product.getProduct_name();

            // 调用支付宝支付
            String paymentForm = PayUtil.createPaymentForm(outTradeNo, totalAmountStr, subject);

            // 输出支付表单
            PrintWriter out = response.getWriter();
            out.println(paymentForm);
            out.flush();

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "参数格式错误");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "支付请求失败: " + e.getMessage());
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
    private String generateOrderNo(int productId) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String timestamp = sdf.format(new Date());
        int random = (int) (Math.random() * 10000);
        return timestamp + productId + random;
    }
}
