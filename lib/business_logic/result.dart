abstract class Result<T> {
  bool get success => this is _ResultSuccess;
  T get data => (this as _ResultSuccess)._data;
  String get error => (this as _ResultFailure)._error;

  Result._();

  factory Result.success(T data) {
    return _ResultSuccess(data);
  }

  factory Result.failure(String error) {
    return _ResultFailure(error);
  }
}

class _ResultSuccess<T> extends Result<T> {
  final T _data;

  _ResultSuccess(this._data) : super._();
}

class _ResultFailure<T> extends Result<T> {
  final String _error;

  _ResultFailure(this._error) : super._();
}
