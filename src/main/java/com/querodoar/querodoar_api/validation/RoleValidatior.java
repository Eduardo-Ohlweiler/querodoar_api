package com.querodoar.querodoar_api.validation;

import com.querodoar.querodoar_api.usuario.Role;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import java.util.Arrays;

public class RoleValidatior implements  ConstraintValidator<ValidRole, Role> {
    @Override
    public boolean isValid(Role role, ConstraintValidatorContext context){
        return role != null && Arrays.asList(Role.values()).contains(role);
    }
}
