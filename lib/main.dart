import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const ListApp());
}

class ListApp extends StatelessWidget {
  const ListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter List BLoC Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => ItemBloc(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter List BLoC Demo'),
          ),
          body: const ItemList(),
          floatingActionButton: const AddItemButton(),
        ),
      ),
    );
  }
}

class ItemBloc extends Bloc<ItemEvent, List<String>> {
  ItemBloc() : super([]) {
    on<ItemEvent>((event, Emitter<List<String>> emit) {
        if (event is AddItemEvent) {
          // Handle AddItem event
          List<String> currentItems = List.from(state);
          currentItems.add(event.item);
          emit(currentItems);
        }
    });
  }

  Stream<List<String>> mapEventToState(ItemEvent event) async* {
    if (event is AddItemEvent) {
      // Logic to handle AddItem event
      List<String> currentItems = List.from(state);
      currentItems.add(event.item);
      yield currentItems;
    }
  }
}

abstract class ItemEvent {}

class AddItemEvent extends ItemEvent {
  final String item;
  AddItemEvent(this.item);
}

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemBloc, List<String>>(
      builder: (context, items) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
              items.map((item) => ListTile(title: Text(item,
                style: const TextStyle(
                  fontSize: 16.0, // You can adjust text style here
                ),
              ))).toList(),
          ),
        );
      },
    );
  }
}

class AddItemButton extends StatelessWidget {
  const AddItemButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final bloc = BlocProvider.of<ItemBloc>(context);
        int number = bloc.state.length + 1;
        final item = 'Item: $number'; //'Item ${random.nextInt(100)}';
        bloc.add(AddItemEvent(item)); // Dispatch AddItem event to the bloc
      },
      child: const Icon(Icons.add),
    );
  }
}