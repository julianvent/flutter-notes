// login exceptions
class InvalidCredentialException implements Exception {

}

//register exceptions
class WeakPasswordAuthException implements Exception {

}

class EmailAlreadyInUseAuthException implements Exception {

}

class InvalidEmailAuthException implements Exception {

}

//generic exceptions
class GenericAuthException implements Exception {

}

class UserNotLoggedInAuthException implements Exception {

}

class UserNotFoundException implements Exception {}