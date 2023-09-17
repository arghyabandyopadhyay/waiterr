import 'package:flutter/material.dart';
import 'package:waiterr/Pages/TableManagement/table_management_page.dart';
import 'package:waiterr/theme.dart';

import '../../global_class.dart';
import '../Restaurant/Management/employee_manager_page.dart';
import '../Restaurant/Management/menu_manager_page.dart';
import '../Restaurant/Management/outlet_manager_page.dart';
import '../Restaurant/Management/stock_group_manager_page.dart';
import '../Restaurant/Management/tax_class_manager_page.dart';

class ClientManagementPage extends StatefulWidget {
  const ClientManagementPage({Key? key}) : super(key: key);
  @override
  State<ClientManagementPage> createState() => _ClientManagementPageState();
}

class _ClientManagementPageState extends State<ClientManagementPage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const TableManagementPage(),
    if (UserClientAllocationData.ucaRoleId == 3 ||
        UserClientAllocationData.ucaRoleId == 4)
      const MenuManagerPage(),
    if (UserClientAllocationData.ucaRoleId == 3 ||
        UserClientAllocationData.ucaRoleId == 4)
      const StockGroupManagerPage(),
    if (UserClientAllocationData.ucaRoleId == 3 ||
        UserClientAllocationData.ucaRoleId == 4)
      const TaxClassManagerPage(),
    if (UserClientAllocationData.ucaRoleId == 4) const OutletManagerPage(),
    if (UserClientAllocationData.ucaRoleId == 3 ||
        UserClientAllocationData.ucaRoleId == 4)
      const EmployeeManagerPage(
          key: GlobalObjectKey("EmployeeManager"), isForAdminManagement: false),
    if (UserClientAllocationData.ucaRoleId == 4)
      const EmployeeManagerPage(
          key: GlobalObjectKey("AdminManager"), isForAdminManagement: true)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
                icon: Icon(Icons.timelapse_outlined),
                label: 'Orders',
                backgroundColor: GlobalTheme.bottomNavBarBackgroundColor),
            if (UserClientAllocationData.ucaRoleId == 3 ||
                UserClientAllocationData.ucaRoleId == 4)
              const BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_rounded),
                  label: 'Menu',
                  backgroundColor: GlobalTheme.bottomNavBarBackgroundColor),
            if (UserClientAllocationData.ucaRoleId == 3 ||
                UserClientAllocationData.ucaRoleId == 4)
              const BottomNavigationBarItem(
                  icon: Icon(Icons.fastfood_outlined),
                  label: 'Stock Groups',
                  backgroundColor: GlobalTheme.bottomNavBarBackgroundColor),
            if (UserClientAllocationData.ucaRoleId == 3 ||
                UserClientAllocationData.ucaRoleId == 4)
              const BottomNavigationBarItem(
                  icon: Icon(Icons.pending_actions_outlined),
                  label: 'Tax Classes',
                  backgroundColor: GlobalTheme.bottomNavBarBackgroundColor),
            if (UserClientAllocationData.ucaRoleId == 4)
              const BottomNavigationBarItem(
                  icon: Icon(Icons.add_business_outlined),
                  label: 'Outlets',
                  backgroundColor: GlobalTheme.bottomNavBarBackgroundColor),
            if (UserClientAllocationData.ucaRoleId == 3 ||
                UserClientAllocationData.ucaRoleId == 4)
              const BottomNavigationBarItem(
                icon: Icon(Icons.group_outlined),
                label: 'Employee',
                backgroundColor: GlobalTheme.bottomNavBarBackgroundColor,
              ),
            if (UserClientAllocationData.ucaRoleId == 4)
              const BottomNavigationBarItem(
                  icon: Icon(Icons.admin_panel_settings_outlined),
                  label: 'Admins',
                  backgroundColor: GlobalTheme.bottomNavBarBackgroundColor),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
