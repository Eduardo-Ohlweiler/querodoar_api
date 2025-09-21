package com.querodoar.querodoar_api.config;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Component
public class GeoLiteInitializer {
    private final Logger log = LoggerFactory.getLogger(GeoLiteInitializer.class);

    @Value("${geolite2.path:./db/maxmind/}")
    private String geoLite2Path;

    @Value("${geolite2.file-name:GeoLite2-City.mmdb}")
    private String geoLiteFileName;

    @PostConstruct
    public void copyGeoLite2Database() {
        try {
            Path dir = Paths.get(geoLite2Path);
            Files.createDirectories(dir);
            Path target = dir.resolve(geoLiteFileName);
            if (Files.notExists(target)) {
                try (InputStream in = getClass().getClassLoader().getResourceAsStream(geoLite2Path + geoLiteFileName)) {
                    if (in == null) {
                        log.warn("GeoLite2 database not found in classpath: {}", geoLite2Path + geoLiteFileName);
                        return;
                    }
                    java.nio.file.Files.copy(in, target);
                    log.info("GeoLite2 database copied to {}", target);
                }
            } else {
                log.debug("GeoLite2 database already exists at {}", target);
            }
        } catch (Exception e) {
            log.error("Failed to ensure directory/database at {}", geoLite2Path, e);
        }
    }
}
