package com.querodoar.querodoar_api.utils;

import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@Component
public class StringUtil {
    /**
     * Gera uma string baseada em um seed, tamanho e charset.
     * @param seed Valor base para geração da string.
     * @param length Tamanho da string final.
     * @param charset Caracteres permitidos na string final. Se null, usa alfanumérico padrão.
     * @return String gerada.
     */
    public static String generateStringFromSeed(String seed, int length, String charset) {
        if (seed == null) throw new IllegalArgumentException("Seed não pode ser nulo");
        if (length <= 0) throw new IllegalArgumentException("Tamanho deve ser maior que zero");
        String chars = (charset != null && !charset.isEmpty()) ? charset : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        byte[] expandedHash = expandHashForLength(seed, length);
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int idx = Byte.toUnsignedInt(expandedHash[i]) % chars.length();
            sb.append(chars.charAt(idx));
        }
        return sb.toString();
    }

    private static byte[] expandHashForLength(String seed, int length) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] result = new byte[length];
            int bytesGenerated = 0;
            int counter = 0;

            while (bytesGenerated < length) {
                md.reset();
                md.update(seed.getBytes(StandardCharsets.UTF_8));
                md.update((byte) length); // Inclui tamanho para garantir unicidade
                md.update(intToBytes(counter)); // Adiciona contador para gerar bytes únicos
                byte[] hash = md.digest();

                int bytesToCopy = Math.min(hash.length, length - bytesGenerated);
                System.arraycopy(hash, 0, result, bytesGenerated, bytesToCopy);
                bytesGenerated += bytesToCopy;
                counter++;
            }

            return result;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 não disponível", e);
        }
    }

    private static byte[] intToBytes(int value) {
        return new byte[] {
            (byte) (value >>> 24),
            (byte) (value >>> 16),
            (byte) (value >>> 8),
            (byte) value
        };
    }
}
