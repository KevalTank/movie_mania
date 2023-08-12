// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../local_storage/shared_pref_helper.dart' as _i4;
import '../network/dio_http_service.dart' as _i3;
import '../repository/app_repository.dart' as _i5;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.DioHttpService>(() => _i3.DioHttpService());
    gh.singleton<_i4.SharedPrefHelper>(_i4.SharedPrefHelper());
    gh.singleton<_i5.AppRepository>(
        _i5.AppRepository(gh<_i3.DioHttpService>()));
    return this;
  }
}
