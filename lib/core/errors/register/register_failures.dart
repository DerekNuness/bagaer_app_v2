abstract class RegisterFailure {
  final String message;
  const RegisterFailure(this.message);
}

/// Send Code
class UserAlreadyRegistered extends RegisterFailure {
  const UserAlreadyRegistered() : super("Usuário já cadastrado");
}



/// Code
class InvalidRegisterCode extends RegisterFailure {
  const InvalidRegisterCode() : super("Código inválido");
}

class NoMoreAttempts extends RegisterFailure {
  const NoMoreAttempts() : super("Sem mais tentativas");
}

class CodeExpired extends RegisterFailure {
  const CodeExpired() : super("Seu código expirou");
}

/// Create User
class PasswordFailure extends RegisterFailure {
  const PasswordFailure() : super("A sua senha deve ter pelo menos 6 dígitos");
}

class PasswordDoesntMatch extends RegisterFailure {
  const PasswordDoesntMatch() : super("A senha de confirmação não confere");
}

class PhoneNotVerified extends RegisterFailure {
  const PhoneNotVerified() : super("Telefone não verificado");
}

class SessionExpired extends RegisterFailure {
  const SessionExpired() : super("Seu tempo de restante para cadastro expirou. Reenvie o código SMS e tente novamente");
}

// Set User Country


// Add user info
class NameRequired extends RegisterFailure {
  const NameRequired() : super("Informe seu nome para continuar");
}

class SurnameRequired extends RegisterFailure {
  const SurnameRequired() : super("Informe seu sobrenome para continuar");
}

class EmailRequired extends RegisterFailure {
  const EmailRequired() : super("Informe seu email para continuar");
}

class DocIdentRequired extends RegisterFailure {
  const DocIdentRequired() : super("Informe o numero do seu documento por favor");
}

class DocTypeRequired extends RegisterFailure {
  const DocTypeRequired() : super("Informe qual o tipo do seu documento por favor");
}

class EmailAlreadyInUse extends RegisterFailure {
  const EmailAlreadyInUse() : super("Esse email ja esta sendo usado por outra conta");
}

class DocumentAlreadyInUse extends RegisterFailure {
  const DocumentAlreadyInUse() : super("Esse documento ja esta sendo usado por outra conta");
}

// User Travel preferences

// Set User Profile Picture
class WrongDimensions extends RegisterFailure {
  const WrongDimensions() : super("Essa imagem está com dimensões inválidas");
}

/// Global errors
class RegisterUnknownAuthFailure extends RegisterFailure {
  const RegisterUnknownAuthFailure([String msg = 'Erro inesperado']) : super(msg);
}

class RegisterNetworkFailure extends RegisterFailure {
  const RegisterNetworkFailure() : super("Parece que você está sem conexão");
}

class UserUnathenticated extends RegisterFailure {
  const UserUnathenticated() : super("Usuario não autenticado");
}