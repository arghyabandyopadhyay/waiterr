import 'package:waiterr/Model/menu_item_model.dart';
import 'package:waiterr/Pages/Restaurant/Product/product_specification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme.dart';
import 'product_about.dart';
import 'product_reviews.dart';

class TabData {
  TabData(this.label, this.child);
  final Widget child;
  final String label;
}

class ProductTab extends StatelessWidget {
  final MenuItemModel? item;
  ProductTab({Key? key, this.item}) : super(key: key);
  final List<TabData> _tabs = [
    TabData("Abouts", const ProductAbout()),
    TabData("Specs", const ProductSpecification()),
    TabData("Reviews", const ProductReviews()),
  ];

  Widget _buildTabBar() {
    return TabBar(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      labelPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2,
      indicatorColor: GlobalTheme.primaryColor,
      tabs: _tabs
          .map((tab) => Text(
                tab.label,
                textScaleFactor: 1,
              ))
          .toList(),
    );
  }

  Widget _buildTabContent() {
    return Expanded(
      child: TabBarView(
        children: _tabs.map((tab) => tab.child).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scrollController = Provider.of<AnimationController>(context);
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Container(
        width: screenWidth,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: GlobalTheme.primaryText,
              blurRadius: 25.0, // soften the shadow
              spreadRadius: 5.0, //extend the shadow
              offset: Offset(
                15.0, // Move to right 10  horizontally
                15.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AnimatedBuilder(
              animation: scrollController,
              builder: (context, _) =>
                  SizedBox(height: (1 - scrollController.value) * 16 + 6),
            ),
            _buildTabBar(),
            const SizedBox(
              height: 10,
            ),
            _buildTabContent(),
          ],
        ),
      ),
    );
  }
}
