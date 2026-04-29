package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.util.PayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * 支付Servlet - 处理支付请求
 */
@WebServlet("/pay")
public class PayServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String outTradeNo = request.getParameter("outTradeNo");
        String totalAmount = request.getParameter("totalAmount");
        String subject = request.getParameter("subject");

        PrintWriter out = response.getWriter();

        try {
            // 参数验证
            if (outTradeNo == null || outTradeNo.trim().isEmpty()) {
                out.println("错误：订单号不能为空");
                return;
            }
            if (totalAmount == null || totalAmount.trim().isEmpty()) {
                out.println("错误：金额不能为空");
                return;
            }
            if (subject == null || subject.trim().isEmpty()) {
                out.println("错误：商品名称不能为空");
                return;
            }

            // 生成支付表单
            String paymentForm = PayUtil.createPaymentForm(outTradeNo, totalAmount, subject);

            // 返回支付表单，浏览器会自动提交
            out.println(paymentForm);

        } catch (Exception e) {
            e.printStackTrace();
            out.println("支付请求失败: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
