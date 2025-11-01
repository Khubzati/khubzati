import 'package:equatable/equatable.dart';

class ProfileData extends Equatable {
  final String id;
  final String bakeryName;
  final String address;
  final String phoneNumber;
  final String? profileImageUrl;
  final DateTime? lastUpdated;

  const ProfileData({
    required this.id,
    required this.bakeryName,
    required this.address,
    required this.phoneNumber,
    this.profileImageUrl,
    this.lastUpdated,
  });

  ProfileData copyWith({
    String? id,
    String? bakeryName,
    String? address,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? lastUpdated,
  }) {
    return ProfileData(
      id: id ?? this.id,
      bakeryName: bakeryName ?? this.bakeryName,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bakeryName,
        address,
        phoneNumber,
        profileImageUrl,
        lastUpdated,
      ];
}
