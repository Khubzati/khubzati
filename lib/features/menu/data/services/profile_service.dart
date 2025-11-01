import 'package:injectable/injectable.dart';
import 'package:khubzati/features/menu/domain/models/profile_data.dart';

@injectable
class ProfileService {
  Future<ProfileData> getProfile() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    return const ProfileData(
      id: '1',
      bakeryName: 'مخبز البدر',
      address: 'عمان، وادي السير، الدوار السابع',
      phoneNumber: '+962 70 000 0000',
      profileImageUrl: null,
      lastUpdated: null,
    );
  }

  Future<ProfileData> updateProfile({
    required String bakeryName,
    required String address,
    required String phoneNumber,
    String? profileImageUrl,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    return ProfileData(
      id: '1',
      bakeryName: bakeryName,
      address: address,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      lastUpdated: DateTime.now(),
    );
  }

  Future<String> uploadProfileImage(String imagePath) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate upload delay
    return 'https://example.com/profile_images/$imagePath';
  }
}
