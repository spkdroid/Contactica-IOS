import 'Promotion.dart';
import 'Service.dart';

class MenuPageObj {
  String username;
  String userprofile;
  List<Service> service;
  List<Promotion> promo;

  MenuPageObj(String userName, String profileImageUrl, List<Service> service,
      List<Promotion> promo) {
    this.username = userName;
    this.userprofile = profileImageUrl;
    this.service = service;
    this.promo = promo;
  }
}
