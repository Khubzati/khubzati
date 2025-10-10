import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:khubzati/features/customer/address/data/services/address_service.dart';

part 'address_event.dart';
part 'address_state.dart';

@injectable
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressService addressService;

  AddressBloc({required this.addressService}) : super(AddressInitial()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<AddAddress>(_onAddAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<SetDefaultAddress>(_onSetDefaultAddress);
  }

  Future<void> _onLoadAddresses(
      LoadAddresses event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      final addresses = await addressService.getAddresses();
      emit(AddressesLoaded(addresses: addresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onAddAddress(
      AddAddress event, Emitter<AddressState> emit) async {
    if (state is AddressesLoaded) {
      final currentState = state as AddressesLoaded;
      emit(AddressLoading());
      try {
        final newAddress = await addressService.addAddress(
          label: event.label,
          address: event.address,
          city: event.city,
          state: event.state,
          postalCode: event.postalCode,
          country: event.country,
          latitude: event.latitude,
          longitude: event.longitude,
          isDefault: event.isDefault,
        );

        final updatedAddresses = [...currentState.addresses, newAddress];
        emit(AddressesLoaded(addresses: updatedAddresses));
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateAddress(
      UpdateAddress event, Emitter<AddressState> emit) async {
    if (state is AddressesLoaded) {
      final currentState = state as AddressesLoaded;
      emit(AddressLoading());
      try {
        final updatedAddress = await addressService.updateAddress(
          addressId: event.addressId,
          label: event.label,
          address: event.address,
          city: event.city,
          state: event.state,
          postalCode: event.postalCode,
          country: event.country,
          latitude: event.latitude,
          longitude: event.longitude,
          isDefault: event.isDefault,
        );

        final updatedAddresses = currentState.addresses.map((addr) {
          return addr['id'] == event.addressId ? updatedAddress : addr;
        }).toList();

        emit(AddressesLoaded(addresses: updatedAddresses));
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteAddress(
      DeleteAddress event, Emitter<AddressState> emit) async {
    if (state is AddressesLoaded) {
      final currentState = state as AddressesLoaded;
      emit(AddressLoading());
      try {
        await addressService.deleteAddress(event.addressId);

        final updatedAddresses = currentState.addresses
            .where((addr) => addr['id'] != event.addressId)
            .toList();

        emit(AddressesLoaded(addresses: updatedAddresses));
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    }
  }

  Future<void> _onSetDefaultAddress(
      SetDefaultAddress event, Emitter<AddressState> emit) async {
    if (state is AddressesLoaded) {
      final currentState = state as AddressesLoaded;
      emit(AddressLoading());
      try {
        await addressService.setDefaultAddress(event.addressId);

        final updatedAddresses = currentState.addresses.map((addr) {
          return {
            ...addr,
            'is_default': addr['id'] == event.addressId,
          };
        }).toList();

        emit(AddressesLoaded(addresses: updatedAddresses));
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    }
  }
}
