import 'package:flutter/material.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/extensions/context_extension.dart';
import 'package:how_to_cook/models/tab.dart';
import 'package:how_to_cook/widgets/pages/home/home_screen.dart';
import 'package:how_to_cook/widgets/pages/products_cart/products_cart_screen.dart';
import 'package:how_to_cook/widgets/pages/search/search_screen.dart';
import 'package:how_to_cook/widgets/views/animated_indexed_stack.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedTabIndex = 0;

  final tabs = [
    TabData(icon: Icons.home, widget: const HomeScreen()),
    TabData(icon: Icons.search, widget: const SearchScreen()),
    TabData(icon: Icons.shopping_cart_rounded, widget: const ProductsCartScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    AppColors.initializeColors(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.colorScheme.primaryContainer,
            width: 3,
          ),
        ),
        child: AnimatedIndexedStack(
          index: selectedTabIndex,
          children: tabs.map((e) => e.widget).toList(),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: context.bottomSaveArea),
        width: context.screenWidth,
        height: 100,
        color: AppColors.colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            tabs.length,
            (index) {
              return AnimatedScale(
                duration: Durations.short4,
                scale: selectedTabIndex == index ? 1.5 : 1,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        tabs[index].icon,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
