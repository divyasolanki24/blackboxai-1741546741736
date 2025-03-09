import 'package:get/get.dart';
import 'package:shop_management_app/modules/auth/bindings/auth_binding.dart';
import 'package:shop_management_app/modules/auth/views/login_view.dart';
import 'package:shop_management_app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:shop_management_app/modules/dashboard/views/dashboard_view.dart';
import 'package:shop_management_app/modules/shop/bindings/shop_binding.dart';
import 'package:shop_management_app/modules/shop/views/shop_list_view.dart';
import 'package:shop_management_app/modules/shop/views/shop_form_view.dart';
import 'package:shop_management_app/modules/shop/views/shop_detail_view.dart';
import 'package:shop_management_app/routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    // Shop Module Routes
    GetPage(
      name: Routes.SHOPS,
      page: () => const ShopListView(),
      binding: ShopBinding(),
      children: [
        GetPage(
          name: '/create',
          page: () => const ShopFormView(),
        ),
        GetPage(
          name: '/:id',
          page: () => ShopDetailView(
            shopId: Get.parameters['id']!,
          ),
        ),
        GetPage(
          name: '/:id/edit',
          page: () => ShopFormView(
            isEditing: true,
            shop: Get.arguments,
          ),
        ),
      ],
    ),
  ];
}
