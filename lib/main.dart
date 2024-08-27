import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_gmedia_test/data/datasources/product_remote_datasource.dart';
import 'package:pos_gmedia_test/presentation/auth/pages/login_page.dart';
import 'package:pos_gmedia_test/presentation/home/pages/home_page.dart';

import 'data/datasources/auth_local_datasource.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/category_remote_datasource.dart';
import 'presentation/auth/bloc/login/login_bloc.dart';
import 'presentation/auth/bloc/logout/logout_bloc.dart';
import 'presentation/home/bloc/get_category/get_category_bloc.dart';
import 'presentation/home/bloc/get_product/get_product_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Periksa status login
  final authLocalDatasource = AuthLocalDatasource();
  final isLoggedIn = await authLocalDatasource.isAuth();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetCategoryBloc(CategoryRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => GetProductBloc(ProductRemoteDataSource()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          dialogTheme: const DialogTheme(elevation: 0),
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: isLoggedIn ? const HomePage() : const LoginPage(),
      ),
    );
  }
}
