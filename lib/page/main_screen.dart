import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_1/data/api/api_service.dart';
import 'package:restaurant_app_1/data/db/database_helper.dart';
import 'package:restaurant_app_1/data/provider/database_provider.dart';
import 'package:restaurant_app_1/data/provider/home_provider.dart';
import 'package:restaurant_app_1/page/favorite_screen.dart';
import 'package:restaurant_app_1/page/search_screen.dart';
import 'package:restaurant_app_1/page/home_screen.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/';
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentTabIndex = 0;

  List<Widget> widgetToBuild = const <Widget>[
    HomeScreen(),
    FavoriteScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    /// [ChangeNotifierProvider] is used so we can use the [Consumer] so we
    /// can use the state
    return MultiProvider(
      providers: [
        ListenableProvider(
          create: (context) => HomeProvider(apiService: ApiService()),
        ),
        ListenableProvider(
          create: (context) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: (_currentTabIndex == 0)
              ? const Text('Local Restaurants')
              : const Text('Favorite Restaurants'),
          backgroundColor: const Color.fromRGBO(255, 106, 106, 1),

          /// Search Icon
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, SearchScreen.routeName);
                },
                child: const Icon(
                  Icons.search_rounded,
                ),
              ),
            ),
          ],
        ),

        /// Each Restaurant List
        body: widgetToBuild[_currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentTabIndex,
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_sharp),
              label: 'Favorite',
            ),
          ],
        ),
      ),
    );
  }
}
