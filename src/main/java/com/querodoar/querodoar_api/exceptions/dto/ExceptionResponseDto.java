package com.querodoar.querodoar_api.exceptions.dto;

public class ExceptionResponseDto {
    private String message;

    public ExceptionResponseDto(String message) {
        this.setMessage(message);
    }

    public String getMessage(){
        return message;
    }

    public void setMessage(String message){
        this.message = message;
    }
}
