import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:appfinance/main.dart';
import 'package:appfinance/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:appfinance/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:appfinance/features/auth/domain/usecases/login_usecase.dart';

void main() {
  testWidgets('App finance smoke test', (WidgetTester tester) async {
    // Initialize dependencies
    final remoteDataSource = AuthRemoteDataSourceImpl();
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    final loginUseCase = LoginUseCase(authRepository);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(loginUseCase: loginUseCase));

    // Verify that MaterialApp is built
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
