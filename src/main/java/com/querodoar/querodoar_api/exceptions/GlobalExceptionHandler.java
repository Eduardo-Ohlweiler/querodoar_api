package com.querodoar.querodoar_api.exceptions;

import com.querodoar.querodoar_api.exceptions.dto.ExceptionResponseDto;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<ExceptionResponseDto> handlerNotFoundException(NotFoundException ex){
        ExceptionResponseDto response = new ExceptionResponseDto(ex.getMessage());
        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(ConflictException.class)
    public ResponseEntity<ExceptionResponseDto> handleConflictException(ConflictException ex){
        ExceptionResponseDto response = new ExceptionResponseDto(ex.getMessage());
        return new ResponseEntity<>(response, HttpStatus.CONFLICT);
    }

    @ExceptionHandler(ForbiddenException.class)
    public ResponseEntity<ExceptionResponseDto> handleConflictException(ForbiddenException ex){
        ExceptionResponseDto response = new ExceptionResponseDto(ex.getMessage());
        return new ResponseEntity<>(response, HttpStatus.FORBIDDEN);
    }

    @ExceptionHandler(UnauthorizedException.class)
    public ResponseEntity<ExceptionResponseDto> handleUnauthorizedException(UnauthorizedException ex){
        ExceptionResponseDto response = new ExceptionResponseDto(ex.getMessage());
        return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ExceptionResponseDto> handleException(Exception ex){
        ExceptionResponseDto response = new ExceptionResponseDto(ex.getMessage());
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
