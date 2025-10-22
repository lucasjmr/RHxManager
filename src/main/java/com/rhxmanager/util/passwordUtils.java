package com.rhxmanager.util;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class passwordUtils {
    public static String hashPassword(String pwd)
            throws NoSuchAlgorithmException
    {
        // We will use MD5
        String hashedPassword = null;

        try {
            // Create MessageDigest instance for MD5
            MessageDigest md = MessageDigest.getInstance("MD5");

            // Add password bytes to digest
            md.update(pwd.getBytes());

            // Get the hash's bytes
            byte[] bytes = md.digest();

            // This bytes[] has bytes in decimal format. Convert it to hexadecimal format
            StringBuilder sb = new StringBuilder();
            for (byte aByte : bytes) {
                sb.append(Integer.toString((aByte & 0xff) + 0x100, 16).substring(1));
            }

            // Get complete hashed password in hex format
            hashedPassword = sb.toString();
        } catch (NoSuchAlgorithmException e)
        {
            e.printStackTrace();
        }

        return hashedPassword;
    }

    public static boolean verifyPasswords(String inputPassword, String hashedPassword)
    {
        boolean result = false;

        try {
            String hashedInputPassword = passwordUtils.hashPassword(inputPassword);
            if (hashedInputPassword.equals(hashedPassword))
            {
                result = true;
            }
        } catch (NoSuchAlgorithmException e)
        {
            e.printStackTrace();
        }

        return result;
    }
}
