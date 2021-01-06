import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

enum MainDataProviderSource {
  None,
  MockUp,
  HTTPClient,
  SQLite,
}

class MainDataProviderOptions {
  MockUpOptions? mockUpOptions;
  HTTPClientOptions? httpClientOptions;
  SQLiteOptions? sqLiteOptions;

  /// MainDataProviderOptions initialization
  MainDataProviderOptions({
    this.mockUpOptions,
    this.httpClientOptions,
    this.sqLiteOptions,
  });
}

class MainDataProvider {
  static MainDataProvider? get instance => _instance;

  static MainDataProvider? _instance;

  List<AbstractSource> get initializedSources => _initializedSources.toList(growable: false);

  final MainDataProviderOptions _options;
  List<AbstractSource> _initializedSources = <AbstractSource>[];

  /// MainDataProvider initialization
  MainDataProvider({
    required MainDataProviderOptions options,
  }) : _options = options {
    _instance = this;

    final theMockUpOptions = options.mockUpOptions;
    if (theMockUpOptions != null) {
      _initializedSources.add(MockUpSource(options: theMockUpOptions));
    }

    final theHttpClientOptions = options.httpClientOptions;
    if (theHttpClientOptions != null) {
      _initializedSources.add(HTTPSource(options: theHttpClientOptions));
    }

    final theSqLiteOptions = options.sqLiteOptions;
    if (theSqLiteOptions != null) {
      _initializedSources.add(SQLiteSource(options: theSqLiteOptions));
    }
  }
}

enum MainDataProviderSourceState {
  UnAvailable,
  Ready,
  Connecting,
}

abstract class AbstractSource {
  ValueNotifier<MainDataProviderSourceState> state = ValueNotifier(MainDataProviderSourceState.UnAvailable);

//TODO
}

class MockUpOptions {}

class MockUpSource extends AbstractSource {
  final MockUpOptions _options;

  /// MockUpSource initialization
  MockUpSource({
    required MockUpOptions options,
  }) : _options = options;
}

class HTTPClientOptions {
  final String hostUrl;

  /// HTTPClientOptions initialization
  HTTPClientOptions({
    required this.hostUrl,
  }) : assert(hostUrl.isNotEmpty);
}

class HTTPSource extends AbstractSource {
  final HTTPClientOptions _options;

  /// HTTPSource initialization
  HTTPSource({
    required HTTPClientOptions options,
  }) : _options = options;
}

class SQLiteOptions {
  final String databasePath;
  final int version;
  final OnDatabaseCreateFn onCreate;

  /// SQLiteOptions initialization
  SQLiteOptions({
    required this.databasePath,
    required this.version,
    required this.onCreate,
  });
}

class SQLiteSource extends AbstractSource {
  final SQLiteOptions _options;

  /// SQLiteSource initialization
  SQLiteSource({
    required SQLiteOptions options,
  }) : _options = options;
}
