import 'package:tflite_flutter_helper/src/common/support_preconditions.dart';
import 'operator.dart';
import 'processor.dart';
import 'package:meta/meta.dart';

class SequentialProcessor<T> implements Processor<T> {
  @protected
  List<Operator<T>> operatorList;

  @protected
  Map<String, List<int>> operatorIndex;

  @protected
  SequentialProcessor(SequentialProcessorBuilder<T> builder) {
    operatorList = builder._operatorList;
    operatorIndex = Map.unmodifiable(builder._operatorIndex);
  }

  @override
  T process(T input) {
    operatorList.forEach((op) {
      input = op.apply(input);
    });
    return input;
  }
}

class SequentialProcessorBuilder<T> {
  final List<Operator<T>> _operatorList;
  final Map<String, List<int>> _operatorIndex;

  @protected
  SequentialProcessorBuilder()
      : _operatorList = [],
        _operatorIndex = {};

  SequentialProcessorBuilder<T> add(Operator<T> op) {
    SupportPreconditions.checkNotNull(op,
        message: 'Adding null Op is illegal.');
    _operatorList.add(op);

    String operatorName = op.runtimeType.toString();
    if (!_operatorIndex.containsKey(operatorName)) {
      _operatorIndex[operatorName] = <int>[];
    }
    _operatorIndex[operatorName].add(_operatorList.length - 1);
    return this;
  }

  SequentialProcessor<T> build() {
    return SequentialProcessor<T>(this);
  }
}
