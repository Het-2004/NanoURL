package com.NanoURL.util;

public class Base62 {
    private static final String CHARSET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    private static final int BASE = 62;

    public static String encode(Long num) {
        if (num == 0) {
            return "0";
        }

        StringBuilder sb = new StringBuilder();
        while (num > 0) {
            sb.append(CHARSET.charAt((int) (num % BASE)));
            num /= BASE;
        }

        return sb.reverse().toString();
    }

    public static Long decode(String str) {
        Long num = 0L;
        for (char c : str.toCharArray()) {
            num = num * BASE + CHARSET.indexOf(c);
        }
        return num;
    }
}
