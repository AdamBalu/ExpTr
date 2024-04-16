import 'package:flutter/material.dart';

class CustomStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final AsyncWidgetBuilder<T> builder;
  final String emptyMessage;

  const CustomStreamBuilder({
    Key? key,
    required this.stream,
    required this.builder,
    this.emptyMessage = "No data available",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return builder(context, snapshot);
      },
    );
  }
}
