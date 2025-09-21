package com.querodoar.querodoar_api.geoIp;

import com.maxmind.geoip2.DatabaseReader;
import com.maxmind.geoip2.exception.AddressNotFoundException;
import com.maxmind.geoip2.exception.GeoIp2Exception;
import com.maxmind.geoip2.model.CityResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;

@Service
public class GeoIpService {

    private final DatabaseReader databaseReader;

    public GeoIpService(DatabaseReader databaseReader) {
        this.databaseReader = databaseReader;
    }

    public String getCityByIp(String ip) {
        try {
            InetAddress ipAddress = InetAddress.getByName(ip);
            CityResponse response = databaseReader.city(ipAddress);
            return response.getCity().getNames().get("pt-BR");
        } catch (Exception  e) {
            //Erro ao buscar a cidade pelo IP
            return null;
        }
    }
}
