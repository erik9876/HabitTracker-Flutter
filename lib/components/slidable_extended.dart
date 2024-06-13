import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableExtended extends StatefulWidget {
  final Function(bool isOpen) onChange;
  final Widget child;
  final ActionPane? endActionPane;

  const SlidableExtended({
    super.key,
    required this.onChange,
    required this.child,
    this.endActionPane,
  });

  @override
  State<SlidableExtended> createState() => _SlidableExtendedState();
}

class _SlidableExtendedState extends State<SlidableExtended>
    with TickerProviderStateMixin {
  late SlidableController _slidableController;

  @override
  void initState() {
    _slidableController = SlidableController(this);
    _slidableController.actionPaneType.addListener(() {
      widget.onChange(
          _slidableController.actionPaneType.value == ActionPaneType.end);
    });
    super.initState();
  }

  @override
  void dispose() {
    _slidableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.key,
      endActionPane: widget.endActionPane,
      controller: _slidableController,
      child: widget.child,
    );
  }
}
