import 'package:flutter/material.dart';


class InternationalizingWrapper extends StatefulWidget {
  const InternationalizingWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  static InternationalizingWrapperState of(BuildContext context) {
    return context.findAncestorStateOfType<InternationalizingWrapperState>()!;
  }

  @override
  InternationalizingWrapperState createState() =>
      InternationalizingWrapperState();
}

class InternationalizingWrapperState extends State<InternationalizingWrapper> {
  InternationalizingState data =
      InternationalizingState(locale: const Locale('ru'));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InternationalizingScope(data: data, child: widget.child);
  }


  Future<void> selectEn() async {
    setState(() {
      data = InternationalizingState(locale: Locale('en'));
    });
  }

  Future<void> selectRu() async {
    setState(() {
      data = InternationalizingState(locale: Locale('ru'));
    });
  }
}

class InternationalizingScope extends InheritedWidget {
  const InternationalizingScope({
    super.key,
    required this.data,
    required super.child,
  });

  final InternationalizingState data;

  static InternationalizingScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InternationalizingScope>();
  }

  static InternationalizingScope of(BuildContext context) {
    final InternationalizingScope? result = maybeOf(context);
    assert(result != null, 'No InternationalizingScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InternationalizingScope oldWidget) =>
      data != oldWidget.data;
}

class InternationalizingState {
  InternationalizingState({required this.locale});

  Locale locale;
}
