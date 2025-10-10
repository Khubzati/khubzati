part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddresses extends AddressEvent {
  const LoadAddresses();
}

class AddAddress extends AddressEvent {
  final String label;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  const AddAddress({
    required this.label,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.latitude,
    this.longitude,
    required this.isDefault,
  });

  @override
  List<Object?> get props => [
        label,
        address,
        city,
        state,
        postalCode,
        country,
        latitude,
        longitude,
        isDefault,
      ];
}

class UpdateAddress extends AddressEvent {
  final String addressId;
  final String label;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  const UpdateAddress({
    required this.addressId,
    required this.label,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.latitude,
    this.longitude,
    required this.isDefault,
  });

  @override
  List<Object?> get props => [
        addressId,
        label,
        address,
        city,
        state,
        postalCode,
        country,
        latitude,
        longitude,
        isDefault,
      ];
}

class DeleteAddress extends AddressEvent {
  final String addressId;

  const DeleteAddress({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

class SetDefaultAddress extends AddressEvent {
  final String addressId;

  const SetDefaultAddress({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}
