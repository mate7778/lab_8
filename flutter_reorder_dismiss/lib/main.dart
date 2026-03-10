import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reorder + Dismiss ListView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ReorderDismissPage(),
    );
  }
}

class ReorderDismissPage extends StatefulWidget {
  const ReorderDismissPage({super.key});

  @override
  State<ReorderDismissPage> createState() => _ReorderDismissPageState();
}

class _ReorderDismissPageState extends State<ReorderDismissPage> {
  final List<String> _items = List.generate(15, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reorderable + Dismissible List'),
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _items.length,
        buildDefaultDragHandles: false,
        onReorder: _onReorder,
        itemBuilder: (context, index) {
          final item = _items[index];

          return Dismissible(
            key: ValueKey(item),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (_) => _removeItem(index),
            child: Card(
              key: ValueKey('card_$item'),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
                title: Text(item),
                subtitle: const Text('Swipe to dismiss, drag to reorder'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      // When moving down the list, newIndex includes the original item.
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final movedItem = _items.removeAt(oldIndex);
      _items.insert(newIndex, movedItem);
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }
}
