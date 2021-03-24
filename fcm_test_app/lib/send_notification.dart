import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

//İndirdiğimiz json dosyasından istenilen değerleri alıp buraya yerleştiriyoruz.
var serviceAccountJson = {
  "type": "service_account",
  "project_id": "your-project-id",
  "private_key_id": "your-private-key-id",
  "private_key":"your-private-key",
  "client_email":"your-client-email",
  "client_id": "your-client-id",
};

Future<bool> sendNotification(Map<String, dynamic> notification) async {
  /*
  * sendNotification fonksiyonu ile parametre olarak aldığımız notification nesnesini kullanarak bir bildirim göndermeyi hedefliyoruz.
  */

  //yukarıda oluşturduğumuz json dosyasını parametre olarak geçerek bir accountCredential elde ediyoruz.
  //Bu credential bize API için gerekli olan accessToken'i verecek.
  final accountCredentials =
      ServiceAccountCredentials.fromJson(serviceAccountJson);
  //Scope ile hangi platforma erişmek istediğimize dair bir bilgilendirme yapıyoruz.
  List<String> scopes = ["https://www.googleapis.com/auth/cloud-platform"];

  //Oluşturduğumuz credential ve scopes değişkenlerini parametre olarak verdiğimiz fonksiyon bize access tokeni içeren bir client döndürüyor.
  //Future bir metod olduğu için then metodu içerisinde bildirim gönderme işlemini gerçekleştireceğiz.
  try {
    try {
      clientViaServiceAccount(accountCredentials, scopes)
          .then((AuthClient client) async {
        //Hazırlanan uri ile gerçekleştireceğimiz post işleminin adresini belirliyoruz.
        //URL içerisindeki your-project-name kısmına firebase'de geçerli olan proje adınızı yazacaksınız.
        //(Firebase konsoldayken tarayıcıdan URL'ye bakarsanız proje adnız orada bulunmaktadır.)
        Uri _url = Uri.https(
            "fcm.googleapis.com", "/v1/projects/your-project-name/messages:send");

        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<accessToken:${client.credentials.accessToken}");
        //client ile yeni bir post işlemi tanımlıyoruz.
        //Yukarıda tanımlanan uri ile nereye post işlemi yapacağımızı belirtiyoruz
        //header kısmında gerekli Authorization işlemi için aldığımız accessToken'i yerleştiriyoruz.
        // yük olarak ise notification nesnesini json olarak ayarlayıp gönderiyoruz.
        http.Response _response = await client.post(
          _url,
          headers: {"Authorization": "Bearer ${client.credentials.accessToken}"},
          body: json.encode(notification),
        );
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<${_response.body}");
        client.close();
      });
    } catch (e, s) {
      print(s);
    }
  } catch (e, s) {
    print(s);
  }
  return true;
}
