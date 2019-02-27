import 'package:example/src/design/painter/process_painter.dart';
import 'package:flutter/material.dart';

class PercentRoundButton extends AnimatedWidget {
  final StatelessWidget child;
  final Color lineColor;
  final Color completeColor;
  final double from;
  final double to;

  PercentRoundButton(
      {this.from = 0.0,
      this.to = 100,
      this.lineColor,
      this.completeColor,
      this.child,
      key,
      Animation<double> animation})
      : assert(from >= 0),
        assert(to <= 100),
        assert(from <= to),
        assert(child != null),
        super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Animation<double> animation = listenable;
    return Container(
      height: 200.0,
      width: 200.0,
      child: CustomPaint(
        foregroundPainter: CycleProcessPainter(
            lineColor: lineColor ?? theme.primaryColorLight,
            completeColor: completeColor ?? theme.primaryColor,
            completePercent: from + animation.value * (to - from),
            width: 8.0),
        child: Padding(padding: const EdgeInsets.all(0), child: child),
      ),
    );
  }
}
