import 'package:flutter/material.dart';
import 'package:om_paie_flutter/ui/screen/custom.clip_path.dart';

class MyClipPath extends StatelessWidget {
  const MyClipPath({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipPath(
        clipper: CustomClipPath(),
        child: Container(
          height: 400,
          color: Colors.deepPurple,
          child: const Center(
            child: Text(
              "Clip Path",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
