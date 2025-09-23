package com.querodoar.querodoar_api.config;

import com.maxmind.geoip2.DatabaseReader;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;

import java.io.File;
import java.io.IOException;

@Configuration
@DependsOn("geoLiteInitializer")
public class GeoLiteConfig {
    @Value("${geolite2.path:./db/maxmind/}")
    private String geoLite2Path;

    @Value("${geolite2.file-name:GeoLite2-City.mmdb}")
    private String geoLiteFileName;

    @Bean
    public DatabaseReader databaseReader() throws IOException {
        File file = new File(geoLite2Path + geoLiteFileName);
        if (!file.exists()) {
            throw new IOException("Arquivo GeoLite2 não foi encontrado em " + geoLite2Path + geoLiteFileName + " após a tentativa de inicialização.");
        }

        return new DatabaseReader.Builder(file).build();
    }
}
