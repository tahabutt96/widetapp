import 'package:flutter/material.dart';

class BaseModel with ChangeNotifier {
  Map<String, dynamic> data = <String, dynamic>{};
  Map<String, Status> status = {"main": Status.Idle};
  Map<String, String> error = {};

  setStatus(String taskName, Status _status) {
    this.status[taskName] = _status;
    notifyListeners();
  }

  setData(String taskName, dynamic _data) {
    this.data[taskName] = _data;
  }

  setError(String taskName, String _error, [Status? _status]) {
    if (_error.isNotEmpty) {
      error[taskName] = _error;
      status[taskName] = Status.Error;
    } else {
      this.error[taskName] = '';
      this.status[taskName] = _status!;
    }
    notifyListeners();
  }

  reset(String taskName) {
    this.data.remove(taskName);
    this.error.remove(taskName);
    this.status.remove(taskName);
  }

  notify() {
    notifyListeners();
  }
}
enum Status { Idle, Loading, Done, Error }