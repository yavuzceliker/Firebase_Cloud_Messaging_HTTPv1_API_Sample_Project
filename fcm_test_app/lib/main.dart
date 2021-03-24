import 'package:fcm_test_app/custom_notifications.dart';
import 'package:fcm_test_app/send_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> _onBackgroundMessage(RemoteMessage message) async {
  CustomNotifications.showNotification(message);
  //onBackgroundMessage fonksiyonu tetiklendiği zaman bu fonksiyon çalışacak.
  //Parametre olarak aldığı RemoteMessage nesnesi okunarak istenen işlemler gerçekleştirilecek.
  print(
      ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>_onBackgroundMessage Tetiklendi");
  print(
      ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>message.notification.title:" +
          message.notification.title);
  print(
      ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>message.notification.body:" +
          message.notification.body);
  return;
}

String token = "";

void main() {
  runApp(MyApp());
  CustomNotifications().initializeNotification(); //Eklenecek satır burası.
  // Bu kısımda FCM üzerinden gelecek bildirimleri dinleyeceğiz.

  // Öncelikle firebase servisini başlatıyoruz.
  // Bu bir future olduğu için then metodu içerisinde gerekli dinlemeleri yapacağız.
  Firebase.initializeApp().then((value) {
    //Cihaza ait token bilgisini almak için getToken fonksiyonu kullanılıyor. Future<String> olarak token'i döndürüyor.
    FirebaseMessaging.instance.getToken().then((value) {
      print("Device Token: $value");
      token = value;
    });

    //bu topic'e üye olan tüm cihazlara bu topic üzerinden bildirim gönderebilirsiniz.
    FirebaseMessaging.instance.subscribeToTopic("default");
    //bu topic'e üye olan tüm cihazlara bu topic üzerinden bildirim gönderebilirsiniz.
    FirebaseMessaging.instance.subscribeToTopic("test");

    //Asıl bildirim işlemleri için kullanılacak 3 adet metodumuz var. Bunlar sırasıyla şu şekildedir.
    // 1. onMessage: Bu strem yapısı, uygulama açıkken bildirimleri dinliyor ve alındığında tetikleniyor.
    // 2. onBackgroundMessage: Bu metod, uygulama kapalıyken veya arkaplandayken bildirim alındığında tetikleniyor.
    // 3. onMessageOpenedApp: Bu stream yapısı ise, bildirim tıklandı mı diye dinliyor ve tıklandığı zaman tetikleniyor.

    FirebaseMessaging.onMessage.listen((message) {
      CustomNotifications.showNotification(message);
      //onMessage yapısı bir stream olduğu için listen metodu ile dinliyoruz ve tetiklendiği zaman
      //döndüreceği RemoteMessage nesnesini okuyoruz.
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>onMessage Tetiklendi");
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>message.notification.title:" +
              message.notification.title);
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>message.notification.body:" +
              message.notification.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      CustomNotifications.showNotification(message);
      //onMessageOpenedApp yapısı da bir stream olduğu için listen metodu ile dinliyoruz ve tetiklendiği zaman
      //döndüreceği RemoteMessage nesnesini okuyoruz.
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>onMessageOpenedApp Tetiklendi");
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>message.notification.title:" +
              message.notification.title);
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>message.notification.body:" +
              message.notification.body);
    });

    //onBackgroundMessage bir stream değil Future<void> tipinde bir fonksiyondur.
    //Önemli olan şart bağımsız bir alanda çalışıyor olmasıdır. Yani class dışında tanımlanan bir fonksiyon çağrılmalıdır.
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM HTTP v1 API',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  String _firstName;
  String _lastName;
  String _eMail;
  String _webSite;
  String _title;
  String _body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FCM HTTP v1 API"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: "Örnek Bildirim Başlığı",
                    autovalidateMode: AutovalidateMode.always,
                    decoration: InputDecoration(
                      labelText: "Bildirim Başlığı",
                      labelStyle: TextStyle(fontSize: 20),
                      hintText: "Bildirim başlığını giriniz.",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    onSaved: (e) => _title = e,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: "Örnek bildirim metni",
                    autovalidateMode: AutovalidateMode.always,
                    decoration: InputDecoration(
                      labelText: "Bildirim Gövdesi",
                      labelStyle: TextStyle(fontSize: 20),
                      hintText: "Bildirim metnini giriniz.",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.content_paste),
                    ),
                    onSaved: (e) => _body = e,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: "Yavuz",
                    autovalidateMode: AutovalidateMode.always,
                    decoration: InputDecoration(
                      labelText: "Ad",
                      labelStyle: TextStyle(fontSize: 20),
                      hintText: "Adınızı giriniz.",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_circle),
                    ),
                    onSaved: (e) => _firstName = e,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: "ÇELİKER",
                    autovalidateMode: AutovalidateMode.always,
                    decoration: InputDecoration(
                      labelText: "Soyad",
                      labelStyle: TextStyle(fontSize: 20),
                      hintText: "Soyadınızı giriniz.",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_circle),
                    ),
                    onSaved: (e) => _lastName = e,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: "contact@yavuzceliker.com.tr",
                    autovalidateMode: AutovalidateMode.always,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      labelStyle: TextStyle(fontSize: 20),
                      hintText: "E-mail adresinizi giriniz.",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    onSaved: (e) => _eMail = e,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: "yavuzceliker.com.tr",
                    autovalidateMode: AutovalidateMode.always,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      labelText: "Web Site",
                      labelStyle: TextStyle(fontSize: 20),
                      hintText: "Web sitenizin linkini giriniz.",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.web),
                    ),
                    onSaved: (e) => _webSite = e,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendNotification,
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendNotification() {
    _formKey.currentState.save();

    Map<String, dynamic> _notification = {
      "message": {
        "condition":"('default' in topics && 'test' in topics) || 'monkeys' in topics",
        "notification": {"title": _title, "body": _body},
        "data": {
          "firstName": _firstName,
          "lastName": _lastName,
          "eMail": _eMail,
          "webSite": _webSite,
        }
      }
    };


    sendNotification(_notification).then((value) {
      if (value)
        print("Bildirim gönderildi.");
      else
        print("Bildirim gönderilemedi.");
    });
  }
}
