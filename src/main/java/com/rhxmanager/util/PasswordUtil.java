package com.rhxmanager.util;

import java.security.NoSuchAlgorithmException;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;

public class PasswordUtil {

    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final int ITERATIONS = 1000;
    private static final int KEY_LENGTH = 256;
    private static final int SALT_SIZE = 16;

    public static String hashPassword(String password) {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_SIZE];
        random.nextBytes(salt);

        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);

        try {
            SecretKeyFactory skf = SecretKeyFactory.getInstance(ALGORITHM);
            byte[] hash = skf.generateSecret(spec).getEncoded();

            // combine salt and hash
            return Base64.getEncoder().encodeToString(salt) + ":" + Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException("Cannot hash password", e);
        }
    }

    public static boolean verifyPassword(String originalPassword, String storedPassword) {
        String[] parts = storedPassword.split(":");
        if (parts.length != 2) {
            // stored pwd format is incorrect
            return false;
        }

        try {
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] hash = Base64.getDecoder().decode(parts[1]);

            PBEKeySpec spec = new PBEKeySpec(originalPassword.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
            SecretKeyFactory skf = SecretKeyFactory.getInstance(ALGORITHM);

            byte[] testHash = skf.generateSecret(spec).getEncoded();

            int diff = hash.length ^ testHash.length;
            for (int i = 0; i < hash.length && i < testHash.length; i++) {
                diff |= hash[i] ^ testHash[i];
            }
            return diff == 0;

        } catch (NoSuchAlgorithmException | InvalidKeySpecException | IllegalArgumentException e) {
            e.printStackTrace();
            return false;
        }
    }
}
