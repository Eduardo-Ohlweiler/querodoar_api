package com.querodoar.querodoar_api.common.service;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Arrays;
import java.util.List;

/**
 * Serviço responsável por extrair o endereço IP real do cliente da requisição HTTP.
 * Considera proxies, load balancers e CDNs que podem estar na frente da aplicação.
 */
@Service
public class ClientIpService {

    private static final Logger log = LoggerFactory.getLogger(ClientIpService.class);

    @Value("${spring.profiles.active:prd}")
    private String activeProfile;

    @Value("${app.client-ip.test-ip:179.219.209.34}")
    private String testIp;

    // Lista de headers comumente usados por proxies para armazenar o IP original
    private static final List<String> IP_HEADER_CANDIDATES = Arrays.asList(
            "X-Forwarded-For",
            "X-Real-IP",
            "Proxy-Client-IP",
            "WL-Proxy-Client-IP",
            "HTTP_X_FORWARDED_FOR",
            "HTTP_X_FORWARDED",
            "HTTP_X_CLUSTER_CLIENT_IP",
            "HTTP_CLIENT_IP",
            "HTTP_FORWARDED_FOR",
            "HTTP_FORWARDED",
            "HTTP_VIA",
            "REMOTE_ADDR"
    );

    private static final String UNKNOWN = "unknown";

    /**
     * Extrai o endereço IP real do cliente da requisição HTTP.
     * Em ambiente de desenvolvimento/teste, retorna um IP fixo configurado.
     *
     * @param request A requisição HTTP
     * @return O endereço IP do cliente
     */
    public String getClientIpAddress(HttpServletRequest request) {
        // Em ambiente não produtivo, retorna IP de teste
        if (!isProdEnvironment()) {
            log.debug("Using test IP for non-production environment: {}", testIp);
            return testIp;
        }

        String clientIp = extractIpFromHeaders(request);

        if (!isValidIp(clientIp)) {
            clientIp = request.getRemoteAddr();
            log.debug("Using remote address as client IP: {}", clientIp);
        }

        log.debug("Resolved client IP: {}", clientIp);
        return clientIp;
    }

    /**
     * Extrai o IP dos headers HTTP, considerando múltiplos headers possíveis.
     */
    private String extractIpFromHeaders(HttpServletRequest request) {
        for (String header : IP_HEADER_CANDIDATES) {
            String ip = request.getHeader(header);
            if (isValidIp(ip)) {
                // X-Forwarded-For pode conter múltiplos IPs separados por vírgula
                // O primeiro é geralmente o IP original do cliente
                if (ip.contains(",")) {
                    ip = ip.split(",")[0].trim();
                }
                if (isValidIp(ip)) {
                    log.debug("Found valid IP '{}' in header '{}'", ip, header);
                    return ip;
                }
            }
        }
        return null;
    }

    /**
     * Verifica se um IP é válido (não nulo, não vazio, não "unknown").
     */
    private boolean isValidIp(String ip) {
        return StringUtils.hasText(ip) && !UNKNOWN.equalsIgnoreCase(ip);
    }

    /**
     * Verifica se está em ambiente de produção.
     */
    private boolean isProdEnvironment() {
        return "prd".equals(activeProfile) || "prod".equals(activeProfile) || "production".equals(activeProfile);
    }

    /**
     * Verifica se um IP é localhost ou IP privado.
     * Útil para logging e debugging.
     */
    public boolean isLocalOrPrivateIp(String ip) {
        if (!StringUtils.hasText(ip)) {
            return false;
        }

        // Localhost
        if ("127.0.0.1".equals(ip) || "::1".equals(ip) || "localhost".equals(ip)) {
            return true;
        }

        // IPs privados (RFC 1918)
        return ip.startsWith("10.") ||
               ip.startsWith("172.") ||
               ip.startsWith("192.168.") ||
               ip.startsWith("169.254."); // Link-local
    }
}
