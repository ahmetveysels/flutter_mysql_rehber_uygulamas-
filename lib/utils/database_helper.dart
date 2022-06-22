import 'package:flutter_mysql_avdisx/model/sozluk_model.dart';
import 'package:mysql1/mysql1.dart';

/* Code by avdisx */

class DATABASEISLEMLERI {
  final String _host = 'localhost';
  final int _port = 3306;
  final String _user = "database_user";
  final String _password = "database_password";
  final String _db = "database_name";

  DATABASEISLEMLERI();

  Future<List<SozlukGirisModel>> verileriGetir() async {
    try {
      final baglan = await MySqlConnection.connect(
        ConnectionSettings(host: _host, port: _port, user: _user, password: _password, db: _db),
      );

      List<SozlukGirisModel> listem = [];
      var verilerinListesi = await baglan.query('select *from persons order by id DESC');
      print(verilerinListesi.toList());
      for (var item in verilerinListesi) {
        listem.add(
          SozlukGirisModel(
            item["id"],
            item["isim"],
            item["soyisim"],
            item["telefon"],
          ),
        );
      }
      await baglan.close();
      return listem;
    } catch (e) {
      return [];
    }
  }

  Future<bool> veriEkle({required String isim, required String soyisim, required String telefon}) async {
    try {
      final baglan = await MySqlConnection.connect(
        ConnectionSettings(host: _host, port: _port, user: _user, password: _password, db: _db),
      );
      // ekleme kodları sonra eklerse true döndür

      await baglan.query("insert into persons (isim,soyisim,telefon) values (?,?,?)", [isim, soyisim, telefon]);
      await baglan.close();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> veriGuncelle({required int id, required String isim, required String soyisim, required String telefon}) async {
    try {
      final baglan = await MySqlConnection.connect(
        ConnectionSettings(host: _host, port: _port, user: _user, password: _password, db: _db),
      );
      // güncelledikte  sonra  true döndür

      await baglan.query("update persons set isim=? , soyisim=? , telefon = ? where id = ?", [isim, soyisim, telefon, id]);
      await baglan.close();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> veriSil({required int id}) async {
    try {
      final baglan = await MySqlConnection.connect(
        ConnectionSettings(host: _host, port: _port, user: _user, password: _password, db: _db),
      );
      // sildikten sonra  true döndür

      await baglan.query('delete from persons where id=?', [id]);
      await baglan.close();
      return true;
    } catch (e) {
      return false;
    }
  }
}
