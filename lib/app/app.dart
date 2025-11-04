import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasirsuper/app/routes.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/home/blocs/blocs.dart';
import 'package:kasirsuper/features/settings/settings.dart';
import 'package:kasirsuper/features/product/blocs/product/product_bloc.dart';
import 'package:kasirsuper/features/pos/blocs/cart/cart_bloc.dart';
import 'package:kasirsuper/features/transaction/blocs/transaction/transaction_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => ProductBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => TransactionBloc()),
      ],
      child: MaterialApp(
        title: 'Kasir Super',
        debugShowCheckedModeBanner: false,
  theme: LightTheme(AppColors.blue).theme,
        home: const SplashScreen(),
        onGenerateRoute: routes,
      ),
    );
  }
}
