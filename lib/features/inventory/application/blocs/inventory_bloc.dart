import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadInventory extends InventoryEvent {
  const LoadInventory();
}

class AddInventoryItem extends InventoryEvent {
  final String name;
  final String description;
  final String price;
  final String quantity;
  final String unit;
  final String imageUrl;

  const AddInventoryItem({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.imageUrl,
  });

  @override
  List<Object?> get props =>
      [name, description, price, quantity, unit, imageUrl];
}

class UpdateInventoryItem extends InventoryEvent {
  final String id;
  final String name;
  final String description;
  final String price;
  final String quantity;
  final String unit;
  final String imageUrl;

  const UpdateInventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.imageUrl,
  });

  @override
  List<Object?> get props =>
      [id, name, description, price, quantity, unit, imageUrl];
}

class DeleteInventoryItem extends InventoryEvent {
  final String id;

  const DeleteInventoryItem({required this.id});

  @override
  List<Object?> get props => [id];
}

// States
abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<InventoryItem> items;

  const InventoryLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class InventoryError extends InventoryState {
  final String message;

  const InventoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Model
class InventoryItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String price;
  final String quantity;
  final String unit;
  final String imageUrl;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.imageUrl,
  });

  @override
  List<Object?> get props =>
      [id, name, description, price, quantity, unit, imageUrl];
}

// BLoC
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc() : super(InventoryInitial()) {
    on<LoadInventory>(_onLoadInventory);
    on<AddInventoryItem>(_onAddInventoryItem);
    on<UpdateInventoryItem>(_onUpdateInventoryItem);
    on<DeleteInventoryItem>(_onDeleteInventoryItem);
  }

  void _onLoadInventory(
      LoadInventory event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      final items = [
        const InventoryItem(
          id: '1',
          name: 'خبز توست أبيض',
          description: 'الوصف: ماكسيم',
          price: '1.25',
          quantity: '240',
          unit: 'بالكيس',
          imageUrl: 'https://via.placeholder.com/150x100?text=Product+1',
        ),
        const InventoryItem(
          id: '2',
          name: 'خبز أسمر',
          description: 'الوصف: صحي',
          price: '1.50',
          quantity: '180',
          unit: 'بالرغيف',
          imageUrl: 'https://via.placeholder.com/150x100?text=Product+2',
        ),
        const InventoryItem(
          id: '3',
          name: 'خبز فرنسي',
          description: 'الوصف: طازج',
          price: '2.00',
          quantity: '120',
          unit: 'بالكيس',
          imageUrl: 'https://via.placeholder.com/150x100?text=Product+3',
        ),
        const InventoryItem(
          id: '4',
          name: 'خبز عربي',
          description: 'الوصف: تقليدي',
          price: '1.00',
          quantity: '300',
          unit: 'بالرغيف',
          imageUrl: 'https://via.placeholder.com/150x100?text=Product+4',
        ),
      ];

      emit(InventoryLoaded(items: items));
    } catch (e) {
      emit(InventoryError(message: 'Failed to load inventory: $e'));
    }
  }

  void _onAddInventoryItem(
      AddInventoryItem event, Emitter<InventoryState> emit) {
    if (state is InventoryLoaded) {
      final currentState = state as InventoryLoaded;
      final newItem = InventoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        description: event.description,
        price: event.price,
        quantity: event.quantity,
        unit: event.unit,
        imageUrl: event.imageUrl,
      );

      emit(InventoryLoaded(items: [...currentState.items, newItem]));
    }
  }

  void _onUpdateInventoryItem(
      UpdateInventoryItem event, Emitter<InventoryState> emit) {
    if (state is InventoryLoaded) {
      final currentState = state as InventoryLoaded;
      final updatedItems = currentState.items.map((item) {
        if (item.id == event.id) {
          return InventoryItem(
            id: event.id,
            name: event.name,
            description: event.description,
            price: event.price,
            quantity: event.quantity,
            unit: event.unit,
            imageUrl: event.imageUrl,
          );
        }
        return item;
      }).toList();

      emit(InventoryLoaded(items: updatedItems));
    }
  }

  void _onDeleteInventoryItem(
      DeleteInventoryItem event, Emitter<InventoryState> emit) {
    if (state is InventoryLoaded) {
      final currentState = state as InventoryLoaded;
      final filteredItems =
          currentState.items.where((item) => item.id != event.id).toList();

      emit(InventoryLoaded(items: filteredItems));
    }
  }
}
