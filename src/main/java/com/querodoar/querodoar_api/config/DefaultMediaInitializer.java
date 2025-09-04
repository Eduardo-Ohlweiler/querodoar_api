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

    private static final String DEFAULT_USER_PHOTO_PATH = "media/user/default.webp";
    private static final String DEFAULT_USER_PHOTO_FILENAME = "default.webp";

    @EventListener(ApplicationReadyEvent.class)
    public void ensureDefaultMedia() {
        try {
            // USER
            Path dir = Paths.get(userPhotoPath);
            Files.createDirectories(dir);
            Path target = dir.resolve(DEFAULT_USER_PHOTO_FILENAME);
            if (Files.notExists(target)) {
                try (InputStream in = getClass().getClassLoader().getResourceAsStream(DEFAULT_USER_PHOTO_PATH)) {
                    if (in == null) {
                        log.warn("Imagem padrão não encontrada no classpath: {}", DEFAULT_USER_PHOTO_PATH);
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
}