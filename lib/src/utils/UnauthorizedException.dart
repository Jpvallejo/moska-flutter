class UnauthorizedException implements Exception {
  final String msg;
  const UnauthorizedException(this.msg);
  String toString() => 'UnauthorizedException: $msg';
}