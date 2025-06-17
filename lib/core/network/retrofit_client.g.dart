// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrofit_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _RetrofitClient implements RetrofitClient {
  _RetrofitClient(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  });

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<ApiResponse<String>> studentSubscription(
    String firstName,
    String? middleName,
    String lastName,
    String phoneNumber,
    int programId,
    int genderId,
    String dateOfBirth,
    int nationalityId,
    int mainLanguageId,
    int placeOfResidenceId,
    int identityTypeId,
    List<String>? otherLanguagesIds,
    List<File> images,
    File video,
    int recitationId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'User.FirstName',
      firstName,
    ));
    if (middleName != null) {
      _data.fields.add(MapEntry(
        'User.MiddleName',
        middleName,
      ));
    }
    _data.fields.add(MapEntry(
      'User.LastName',
      lastName,
    ));
    _data.fields.add(MapEntry(
      'User.PhoneNumber',
      phoneNumber,
    ));
    _data.fields.add(MapEntry(
      'ProgramId',
      programId.toString(),
    ));
    _data.fields.add(MapEntry(
      'User.GenderId',
      genderId.toString(),
    ));
    _data.fields.add(MapEntry(
      'User.DateOfBirth',
      dateOfBirth,
    ));
    _data.fields.add(MapEntry(
      'User.NationalityId',
      nationalityId.toString(),
    ));
    _data.fields.add(MapEntry(
      'User.MainLanguageId',
      mainLanguageId.toString(),
    ));
    _data.fields.add(MapEntry(
      'User.PlaceOfResidenceId',
      placeOfResidenceId.toString(),
    ));
    _data.fields.add(MapEntry(
      'UserIdentityDto.UserIdentityTypeId',
      identityTypeId.toString(),
    ));
    otherLanguagesIds?.forEach((i) {
      _data.fields.add(MapEntry('User.OtherLanguagesIds', i));
    });
    _data.files.addAll(images.map((i) => MapEntry(
        'UserIdentityDto.UserIdentityFiles',
        MultipartFile.fromFileSync(
          i.path,
          filename: i.path.split(Platform.pathSeparator).last,
        ))));
    _data.files.add(MapEntry(
      'Video',
      MultipartFile.fromFileSync(
        video.path,
        filename: video.path.split(Platform.pathSeparator).last,
      ),
    ));
    _data.fields.add(MapEntry(
      'RecitationId',
      recitationId.toString(),
    ));
    final _options = _setStreamType<ApiResponse<String>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          '/Student/StudentSubscription',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiResponse<String> _value;
    try {
      _value = ApiResponse<String>.fromJson(
        _result.data!,
        (json) => json as String,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
