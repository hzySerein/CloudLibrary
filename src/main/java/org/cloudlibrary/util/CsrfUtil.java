package org.cloudlibrary.util;

import java.security.SecureRandom;
import java.util.UUID;

/**
 * CSRF Token 工具类
 */
public class CsrfUtil {

    public static final String CSRF_TOKEN_ATTR = "_csrf_token";
    public static final String CSRF_PARAM_NAME = "_csrf";

    /**
     * 生成不可预测的 CSRF Token
     *
     * @return 32位十六进制字符串
     */
    public static String generateToken() {
        return UUID.randomUUID().toString().replace("-", "")
                + Long.toHexString(System.nanoTime())
                + Integer.toHexString(new SecureRandom().nextInt());
    }
}
