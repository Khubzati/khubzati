import 'dart:io';

import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';
import 'api_response.dart';

part 'retrofit_client.g.dart';

@RestApi()
abstract class RetrofitClient {
  factory RetrofitClient(Dio dio, {String baseUrl}) = _RetrofitClient;

  //S--------------------Student--------------------S//

  // @POST('/Student/Register')
  // Future<ApiResponse<UserSignupResponse>> signup(
  //     @Body() UserSignupRequest userSignupRequest);

  @POST('/Student/StudentSubscription')
  @MultiPart()
  Future<ApiResponse<String>> studentSubscription(
    @Part(name: "User.FirstName") String firstName,
    @Part(name: "User.MiddleName") String? middleName,
    @Part(name: "User.LastName") String lastName,
    @Part(name: "User.PhoneNumber") String phoneNumber,
    @Part(name: "ProgramId") int programId,
    @Part(name: "User.GenderId") int genderId,
    @Part(name: "User.DateOfBirth") String dateOfBirth,
    @Part(name: "User.NationalityId") int nationalityId,
    @Part(name: "User.MainLanguageId") int mainLanguageId,
    @Part(name: "User.PlaceOfResidenceId") int placeOfResidenceId,
    @Part(name: "UserIdentityDto.UserIdentityTypeId") int identityTypeId,
    @Part(name: "User.OtherLanguagesIds") List<String>? otherLanguagesIds,
    @Part(name: "UserIdentityDto.UserIdentityFiles") List<File> images,
    @Part(name: 'Video') File video,
    @Part(name: 'RecitationId') int recitationId,
  );
}
