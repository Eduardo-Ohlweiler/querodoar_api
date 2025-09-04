package com.querodoar.querodoar_api.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class ResourceConfig implements WebMvcConfigurer {
    @Value("${file.media.user.path:./media/user/}")
    private String userPhotoPath;

    //Implementação necessária quando a lógica de donation for desenvolvida
    //@Value("${file.media.donation.path:./media/donation/}")
    //private String donationPhotoPath;

    @Override
    public void addResourceHandlers(org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/media/user/**")
                .addResourceLocations("file:" + userPhotoPath)
                .setCachePeriod(60 * 60); // Cache por 1 hora
    }
}
