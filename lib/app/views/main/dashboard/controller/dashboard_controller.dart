import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/views/main/home/home_view.dart';
import 'package:qr_code_inventory/app/views/main/favourite/favourite_view.dart';
import 'package:qr_code_inventory/app/views/main/notifications/notifications_view.dart';
import 'package:qr_code_inventory/app/views/main/profile/profile_view.dart';

class DashboardController extends GetxController {
  var currentTabIndex = 0.obs;
  
  final List<Widget> tabViews = [
    const HomeView(),
    const FavouriteView(),
    const NotificationsView(),
    const ProfileView(),
  ];

  void changeTabIndex(int index) {
    if (index >= 0 && index < tabViews.length && index != currentTabIndex.value) {
      currentTabIndex.value = index;
    }
  }
}
