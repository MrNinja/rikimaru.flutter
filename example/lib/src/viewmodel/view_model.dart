import 'package:architecture_component/architecture_component.dart';

class HomeViewModel extends ViewModel {
  final LiveData<int> _counter = LiveData.init(initialData: 10);

  Function get increase => () => _counter.value++;

  LiveData<int> get counter {
    return _counter;
  }
}
