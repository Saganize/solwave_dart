import 'package:flutter/material.dart';

class SolwaveLoader extends StatelessWidget {
  final double size;
  const SolwaveLoader({
    Key? key,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          backgroundColor: Colors.black,
          strokeWidth: 5.0,
        ),
      ),
    );
  }
}
