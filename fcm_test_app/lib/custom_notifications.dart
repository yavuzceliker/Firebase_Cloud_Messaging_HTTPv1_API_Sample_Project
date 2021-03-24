import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//Plugin tanımlaması yapıldı.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Özelleştirilmiş bildirimlerimizi bir class haline getirerek karmaşıklığı azaltıyoruz.
// Sadece CustomNotifications.showNotification(message) diyerek özelleştirilmiş bildirimleri alacağız.
class CustomNotifications {

  // Her defasında yeni bir nesne oluşturmaması için sınıfı singleton bir yapıya getiriyoruz.

  static final CustomNotifications _singleton = CustomNotifications._internal();
  factory CustomNotifications() {
    return _singleton;
  }
  CustomNotifications._internal();

  // Bu fonksiyon içerisinde özelleştirilmiş bildirimlere ait gerekli tanımlamalar yapılmaktadaır.
  initializeNotification() async {

    // app_icon bildiriminize ait icon bilgisini tutar ve android/app/src/main/res/drawable klasörüne bir app_icon.png isimli dosya atmalısınız.
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    // iOS 'a ait ayarlamalar yapılıyor.
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    //iOS ve android için yapılan ayarlamalar birleştirilerek genel bir ayarlama nesnesi haline getiriliyor.
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      //macOS için ayarlama seçeneği de bulunuyor. Detaylar için pub.dev sayfasından paket detaylarına bakabilirsiniz.
    );

    //Hazırlanan ayarlar ile custom notification hale getiriliyor.
    //Onselect metodu ile bildirim ile birlikte gönderilen data alınıyor.
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future<void> _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {
    print('notification payload: $payload');
    return null;
  }

  Future<void> _onSelectNotification(String payload) {
    if (payload != null) {
      print('notification payload: $payload');
    }
    return null;
  }


  /*
  * showNotification metodu ile bildirim gösterme işlemini gerçekleştiriyoruz.
  * Paket sayfasına girdiğiniz zaman çok sayıda farklı özelleştirilebilir bildirim çeşitleri bulabilirsiniz.
  * */
  static showNotification(RemoteMessage message) async {
    //RemoteMessage türündeki parametremiz FCM tarafından oluşturulan
    // onMessage, onbackGroundMessage ve onMessageOpenedApp metodlarından gelen message datasıdır.
    //FCM tarafından bildirim alındıktan sonra burada işlenerek customNotification oluşturuluyor.

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        '1234567890', 'Channel Name', 'Channel Description', //Channel kısmı ayarlardan uygulama bilgilerine girdiğinizde göreceğiniz bilgilerdir.
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    //Bildirimimizi gösterecek metod burası. Buraya parametre olarak gelen message verimizden istediğimiz alanları ekliyoruz.
    // message.data["firstName"] bildirim başlığını ifade ediyor.
    // message.data["webSite"] bildirim metnini ifade ediyor.
    // payload kısmı ise bildirime tıklandıktan sonra işlenmesini istediğiniz verileri ifade ediyor.
    await flutterLocalNotificationsPlugin.show(0, message.data["firstName"],
        message.data["webSite"], platformChannelSpecifics,
        payload: json.encode(message.data));
  }

}
