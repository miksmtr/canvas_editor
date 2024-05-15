import 'package:flutter/material.dart';
import 'package:scroll_save/scroll_save.dart';

typedef PointMoveCallback = void Function(Offset offset, Key? key);

class OverlayedWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onDragStart;
  final PointMoveCallback onDragEnd;
  final PointMoveCallback onDragUpdate;

  const OverlayedWidget(
      {super.key,
      required this.child,
      required this.onDragStart,
      required this.onDragEnd,
      required this.onDragUpdate});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    late Offset offset;
    return Listener(
      onPointerMove: (event) {
        offset = event.position;
        onDragUpdate(offset, key);
      },
      child: MatrixGestureDetector(
        onMatrixUpdate: (m, tm, sm, rm) {
          print(m);
          notifier.value = m;
        },
        onScaleStart: () {
          onDragStart();
        },
        onScaleEnd: () {
          onDragEnd(offset, key);
        },
        child: AnimatedBuilder(
          animation: notifier,
          builder: (ctx, childWidhet) {
            return Transform(
                transform: notifier.value,
                child: Align(
                  alignment: Alignment.center,
                  child: FittedBox(fit: BoxFit.contain, child: child),
                ));
          },
        ),
      ),
    );
  }
}
