package com.querodoar.querodoar_api.validation;

import com.querodoar.querodoar_api.enums.UsuarioRole;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import java.util.Arrays;

public class RoleValidatior implements  ConstraintValidator<ValidRole, UsuarioRole> {
    @Override
    public boolean isValid(UsuarioRole role, ConstraintValidatorContext context){
        return role != null && Arrays.asList(UsuarioRole.values()).contains(role);
    }
}
