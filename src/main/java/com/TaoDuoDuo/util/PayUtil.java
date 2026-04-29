package com.TaoDuoDuo.util;

import com.alipay.easysdk.factory.Factory;
import com.alipay.easysdk.kernel.Config;
import com.alipay.easysdk.kernel.util.ResponseChecker;
import com.alipay.easysdk.payment.page.models.AlipayTradePagePayResponse;
import com.alipay.easysdk.payment.common.models.AlipayTradeQueryResponse;
import com.alipay.easysdk.payment.common.models.AlipayTradeRefundResponse;

import jakarta.servlet.http.HttpServletRequest;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * 支付宝支付工具类
 */
public class PayUtil {

    // 配置参数
    private static String APP_ID;
    private static String APP_PRIVATE_KEY;
    private static String ALIPAY_PUBLIC_KEY;
    private static String NOTIFY_URL;
    private static String RETURN_URL;
    private static String GATEWAY_HOST;
    private static String PROTOCOL;
    private static String SIGN_TYPE;

    // 懒加载初始化标志
    private static volatile boolean initialized = false;
    private static final Object lock = new Object();

    /**
     * 初始化配置（懒加载，避免类加载时出错）
     */
    private static void init() {
        if (initialized) {
            return;
        }

        synchronized (lock) {
            if (initialized) {
                return;
            }

            try {
                // 加载配置文件
                Properties props = new Properties();
                InputStream is = PayUtil.class.getClassLoader().getResourceAsStream("alipay.properties");

                if (is == null) {
                    throw new RuntimeException("找不到配置文件 alipay.properties");
                }

                props.load(is);
                is.close();

                // 读取配置
                APP_ID = props.getProperty("alipay.app.id");
                APP_PRIVATE_KEY = props.getProperty("alipay.app.private.key");
                ALIPAY_PUBLIC_KEY = props.getProperty("alipay.public.key");
                NOTIFY_URL = props.getProperty("alipay.notify.url");
                RETURN_URL = props.getProperty("alipay.return.url");
                GATEWAY_HOST = props.getProperty("alipay.gateway.host", "openapi-sandbox.dl.alipaydev.com");
                PROTOCOL = props.getProperty("alipay.protocol", "https");
                SIGN_TYPE = props.getProperty("alipay.sign.type", "RSA2");

                // 清理私钥和公钥中的空白字符
                if (APP_PRIVATE_KEY != null) {
                    APP_PRIVATE_KEY = APP_PRIVATE_KEY.replaceAll("\\s+", "");
                }
                if (ALIPAY_PUBLIC_KEY != null) {
                    ALIPAY_PUBLIC_KEY = ALIPAY_PUBLIC_KEY.replaceAll("\\s+", "");
                }

                // 验证必要参数
                if (APP_ID == null || APP_ID.trim().isEmpty()) {
                    throw new RuntimeException("alipay.app.id 不能为空");
                }
                if (APP_PRIVATE_KEY == null || APP_PRIVATE_KEY.trim().isEmpty()) {
                    throw new RuntimeException("alipay.app.private.key 不能为空");
                }
                if (ALIPAY_PUBLIC_KEY == null || ALIPAY_PUBLIC_KEY.trim().isEmpty()) {
                    throw new RuntimeException("alipay.public.key 不能为空");
                }
                if (RETURN_URL == null || RETURN_URL.trim().isEmpty()) {
                    throw new RuntimeException("alipay.return.url 不能为空");
                }

                // 初始化支付宝SDK
                Config config = new Config();
                config.protocol = PROTOCOL;
                config.gatewayHost = GATEWAY_HOST;
                config.signType = SIGN_TYPE;
                config.appId = APP_ID;
                config.merchantPrivateKey = APP_PRIVATE_KEY;
                config.alipayPublicKey = ALIPAY_PUBLIC_KEY;
                config.notifyUrl = NOTIFY_URL;

                Factory.setOptions(config);
                initialized = true;

                System.out.println("支付宝SDK初始化成功 - AppId: " + APP_ID);

            } catch (Exception e) {
                System.err.println("支付宝SDK初始化失败: " + e.getMessage());
                e.printStackTrace();
                throw new RuntimeException("支付宝SDK初始化失败: " + e.getMessage(), e);
            }
        }
    }

    /**
     * 生成支付表单
     */
    public static String createPaymentForm(String outTradeNo, String totalAmount, String subject) {
        init();

        try {
            AlipayTradePagePayResponse response = Factory.Payment.Page()
                    .pay(subject, outTradeNo, totalAmount, RETURN_URL);

            if (ResponseChecker.success(response)) {
                return response.getBody();
            } else {
                throw new RuntimeException("生成支付表单失败: " + response.getBody());
            }
        } catch (Exception e) {
            System.err.println("支付请求异常: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("支付请求异常: " + e.getMessage(), e);
        }
    }

    /**
     * 查询订单
     */
    public static AlipayTradeQueryResponse queryOrder(String outTradeNo) {
        init();

        try {
            AlipayTradeQueryResponse response = Factory.Payment.Common().query(outTradeNo);
            return response;
        } catch (Exception e) {
            System.err.println("查询订单异常: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("查询订单异常: " + e.getMessage(), e);
        }
    }

    /**
     * 申请退款
     */
    public static AlipayTradeRefundResponse refund(String outTradeNo, String refundAmount) {
        init();

        try {
            AlipayTradeRefundResponse response = Factory.Payment.Common().refund(outTradeNo, refundAmount);
            return response;
        } catch (Exception e) {
            System.err.println("退款异常: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("退款异常: " + e.getMessage(), e);
        }
    }

    /**
     * 验证异步通知签名
     */
    public static boolean verifyNotify(HttpServletRequest request) {
        init();

        try {
            Map<String, String> params = new HashMap<>();
            request.getParameterMap().forEach((key, values) -> {
                if (values != null && values.length > 0) {
                    params.put(key, values[0]);
                }
            });

            return Factory.Payment.Common().verifyNotify(params);
        } catch (Exception e) {
            System.err.println("验证签名异常: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}