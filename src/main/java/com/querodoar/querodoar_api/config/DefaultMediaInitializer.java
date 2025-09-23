// java
package com.querodoar.querodoar_api.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Component
public class DefaultMediaInitializer {

    private final Logger log = LoggerFactory.getLogger(DefaultMediaInitializer.class);

    @Value("${file.media.user.path:./media/user/}")
    private String userPhotoPath;

    @Value("${file.media.donation.path:./media/donation/}")
    private String donationMediaPath;

    private String defaultMediaFileName = "default.webp";

    @EventListener(ApplicationReadyEvent.class)
    public void ensureDefaultUserMedia() {
        // USER
        try {
            Path dir = Paths.get(userPhotoPath);
            Files.createDirectories(dir);
            Path target = dir.resolve(defaultMediaFileName);
            if (Files.notExists(target)) {
                try (InputStream in = getClass().getClassLoader().getResourceAsStream(userPhotoPath + defaultMediaFileName)) {
                    if (in == null) {
                        log.warn("Imagem padrão não encontrada no classpath: {}", userPhotoPath + defaultMediaFileName);
                        return;
                    }
                    Files.copy(in, target);
                    log.info("Imagem padrão copiada para {}", target);
                }
            } else {
                log.debug("Imagem padrão já existe em {}", target);
            }
        } catch (Exception e) {
            log.error("Falha ao garantir diretório/imagem padrão em {}", userPhotoPath, e);
        }
    }

    @EventListener(ApplicationReadyEvent.class)
    public void ensureDefaultDonationMedia() {
        // DONATION
        try {
            Path dir = Paths.get(donationMediaPath);
            Files.createDirectories(dir);
            Path target = dir.resolve(defaultMediaFileName);
            if (Files.notExists(target)) {
                try (InputStream in = getClass().getClassLoader().getResourceAsStream(donationMediaPath + defaultMediaFileName)) {
                    if (in == null) {
                        log.warn("Imagem padrão não encontrada no classpath: {}", donationMediaPath + defaultMediaFileName);
                        return;
                    }
                    Files.copy(in, target);
                    log.info("Imagem padrão copiada para {}", target);
                }
            } else {
                log.debug("Imagem padrão já existe em {}", target);
            }
        } catch (Exception e) {
            log.error("Falha ao garantir diretório/imagem padrão em {}", donationMediaPath, e);
        }
    }
}