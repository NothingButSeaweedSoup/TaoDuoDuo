package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.util.PayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * 异步通知Servlet - 处理支付宝支付结果通知
 */
@WebServlet("/notify")
public class NotifyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        PrintWriter out = response.getWriter();

        try {
            // 验证签名
            boolean verifyResult = PayUtil.verifyNotify(request);

            if (!verifyResult) {
                System.err.println("异步通知签名验证失败");
                out.println("fail");
                return;
            }

            // 获取通知参数
            Map<String, String> params = new HashMap<>();
            request.getParameterMap().forEach((key, values) -> {
                if (values != null && values.length > 0) {
                    params.put(key, values[0]);
                }
            });

            // 获取交易状态
            String tradeStatus = params.get("trade_status");
            String outTradeNo = params.get("out_trade_no");
            String tradeNo = params.get("trade_no");
            String totalAmount = params.get("total_amount");

            System.out.println("收到异步通知 - 订单号: " + outTradeNo + ", 交易号: " + tradeNo + ", 状态: " + tradeStatus);

            // 处理业务逻辑
            if ("TRADE_SUCCESS".equals(tradeStatus) || "TRADE_FINISHED".equals(tradeStatus)) {
                // 支付成功，更新订单状态
                System.out.println("订单支付成功 - 订单号: " + outTradeNo + ", 金额: " + totalAmount);

                // TODO: 在这里更新数据库订单状态
                // 例如: orderService.updateOrderStatus(outTradeNo, "PAID");

                out.println("success");
            } else {
                System.out.println("订单状态: " + tradeStatus);
                out.println("success");
            }

        } catch (Exception e) {
            System.err.println("处理异步通知异常: " + e.getMessage());
            e.printStackTrace();
            out.println("fail");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
