part of 'switch_bloc.dart';

class SwitchState extends Equatable {
  final bool switchValue;
  const SwitchState({
    required this.switchValue,
  });

  @override
  List<Object> get props => [switchValue];

  SwitchState copyWith({
    bool? switchValue,
  }) {
    return SwitchState(
      switchValue: switchValue ?? this.switchValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'switchValue': switchValue,
    };
  }

  factory SwitchState.fromMap(Map<String, dynamic> map) {
    return SwitchState(
      switchValue: map['switchValue'] ?? false,
    );
  }
}

class SwitchInitial extends SwitchState {
  const SwitchInitial({required switchValue}) : super(switchValue: switchValue);
}
