package com.querodoar.querodoar_api.utils;

import net.coobird.thumbnailator.Thumbnails;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.IOException;

public class ImageProcessor {

    public static void processImage(File inputFile, File outputFile, int x, int y, int width, int height,
                             int targetWidth, int targetHeight) throws IOException {
        Thumbnails.of(inputFile)
                .sourceRegion(x, y, width, height)      // Area de corte
                .size(targetWidth, targetHeight)        // Tamanho final
                .outputFormat("webp")
                .toFile(outputFile);
    }
}