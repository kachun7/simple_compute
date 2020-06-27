import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'service.dart';

class BodyWidget extends StatefulWidget {
  const BodyWidget({Key key, @required this.service}) : super(key: key);

  final MyService service;

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void dispose() {
    widget.service.dipose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Compute'),
      ),
      body: RefreshIndicator(
        onRefresh: widget.service.runExpensiveTasks,
        child: AnimatedList(
          key: _listKey,
          itemBuilder: (_, index, animation) => SizeTransition(
            sizeFactor: animation,
            child: Slidable(
              actionPane: const SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              closeOnScroll: true,
              secondaryActions: <Widget>[
                IconSlideAction(caption: 'Delete', color: Colors.red, icon: Icons.delete, onTap: () => removeAt(index)),
              ],
              child: ListTile(
                leading: Icon(Icons.face),
                title: Text(widget.service.tasks[index].itemTitle),
                trailing: _progressIndicator(widget.service.tasks[index].itemId),
              ),
            ),
          ),
          initialItemCount: widget.service.tasks.length,
        ),
      ),
    );
  }

  /// Display CircularProgressIndicator) if [inProgress] is true,
  /// otherwise we display empty container
  Widget _progressIndicator(int itemId) => ValueListenableBuilder<bool>(
        valueListenable: widget.service.taskNotifiers[itemId],
        builder: (_, inProgress, child) => SizedBox(
          width: 10.0,
          height: 10.0,
          child: inProgress ? child : Container(),
        ),
        child: const CircularProgressIndicator(strokeWidth: 1.0),
      );

  void removeAt(int index) {
    _listKey.currentState.removeItem(index, (context, animation) => Container());
    widget.service.removeAt(index);
  }
}
