class Validators {
  //Validar el correo y dominio
  static String? emailValidator(String? value){
    if (value == null || value.isEmpty){
      return 'El correo es obligatorio';
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())){
      return 'Ingresa un correo válido (ej: usuario@gmail.com)';
    }
    return null;
  }

  //Valida la contraseña
  static String? passwordValidator(String? value){
    if (value == null || value.isEmpty){
      return 'La contraseña es obligatoria';
    }
    if (value.length < 6){
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  //Valida el nombre 
  static String? nameValidator(String? value){
    if (value == null || value.isEmpty){
      return 'El nombre es obligatorio';
    }
    return null;
  }

  //Valida que las contraseñas coincidan
  static String? confirmPasswordValidator(String? value, String password){
    if (value == null || value.isEmpty){
      return 'Confirma la contraseña';
    }
    if (value != password){
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}