class Config {

  static const String agoraVcKey = "942c66d6342c4468a94c41b04db60b20";


  static const Map<String, dynamic> header = {
    "Content-Type": "application/json"
  };

  static const String firebaseKey = 'AIzaSyAQsrPQVAUnYFRYLOvzB1lseZx9wIJz2H8';
  static const String notificationUrl = 'https://fcm.googleapis.com/fcm/send';
  static const String baseUrl = "http://192.168.1.34:8000";   // https://gomeet.tiendev.id.vn
  static const String baseUrlApi = "$baseUrl/api";



  static const String relationGoalList = "/relation/all";
  static const String getInterestList = "/interest/all";
  static const String languagelist = "/language/all";
  static const String religionlist = "/religion/all";
  static const String regiseruser = "/auth/register";
  static const String socialLogin = "/auth/login-social";
  static const String mobileCheck = "/auth/check-mobile";
  static const String homeData = "/action/home-page";
  static const String profileInfo = "/action/infor-profile";
  static const String userLogin = "/auth/login";
  static const String mapInfo = "/action/map-data";
  static const String likeDislike = "/action/toggle-like";
  static const String editProfile = "/user/update";
  static const String likeMe = "/action/list-like-me";
  static const String favourite = "/action/list-favorite";
  static const String passed = "/action/list-passed";
  static const String newMatch = "/action/match-user";
  static const String delUnlike = "/action/unlike";
  static const String profileView = "/action/view-profile";
  static const String filter = "/action/filter-user";
  static const String plan = "/plan/all";
  static const String paymentGateway = "/payment/all";
  static const String planPurchase = "/plan-purchase/plan-purchase-history";
  static const String faq = "/faq/all";
  static const String accDelete = "/user/delete-account";
  static const String pageList = "/page/all";
  static const String notificationList = "/notification/list";
  static const String userInfo = "/user/infor";
  static const String forgetPassword = "/user/forgot-pass";
  static const String pro_pic = "/user/uploads-image-profiles";
  static const String profileblock = "/action/block-profile";
  static const String reportapi = "/report/all";
  static const String blocklist = "/action/list-block";
  static const String unblockapikey = "/action/unblock";
  static const String getblockapi = "/action/list-block";
  static const String identifyapi = "/user/identify-profile";

  static String oneSignel = "cb406f9c-3953-42e7-a2dd-fe2af172f3a2";

}
