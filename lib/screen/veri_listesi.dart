import 'package:flutter/material.dart';

import 'package:flutter_mysql_avdisx/model/sozluk_model.dart';
import 'package:flutter_mysql_avdisx/utils/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'veri_ekle.dart';

/* Code by avdisx */
class VERILISTESI extends StatefulWidget {
  bool durum = false;
  VERILISTESI({
    Key? key,
  }) : super(key: key);

  @override
  _VERILISTESIState createState() => _VERILISTESIState();
}

class _VERILISTESIState extends State<VERILISTESI> {
  DATABASEISLEMLERI _databaseislemleri = new DATABASEISLEMLERI();
  List<SozlukGirisModel> tumVeriler = [];

  @override
  void initState() {
    super.initState();
    verileriGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Kayıtlı Veriler||avdisx"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Duration(seconds: 3);
            Navigator.push<bool>(context, MaterialPageRoute(builder: (context) => VERIEKLE())).then((value) {
              print("  value");
              if (value == true) {
                snackbarGoster("Kayıt Eklendi");
                verileriGetir();
                setState(() {});
              }
            });
          },
          child: Icon(Icons.add),
        ),
        body: Container(
          child: tumVeriler.length != 0
              ? ListView.builder(
                  itemCount: tumVeriler.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        title: Text(tumVeriler[index].isim + " " + tumVeriler[index].soyisim),
                        subtitle: Text("Telefon : " + tumVeriler[index].telefon),
                        leading: Text(tumVeriler[index].id.toString()),
                        trailing: IconButton(
                            tooltip: "Kişiyi Sil",
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              //silme kodu
                              bool sonuc = await _databaseislemleri.veriSil(id: tumVeriler[index].id);
                              if (sonuc) {
                                setState(() {
                                  snackbarGoster("Kayıt silindi");
                                  verileriGetir();
                                });
                              }
                            }),
                      ),
                    );
                  })
              : Center(
                  child: Text("Kayıtlı Veri Yok."),
                ),
        ),
      ),
    );
  }

  void verileriGetir() async {
    tumVeriler = await _databaseislemleri.verileriGetir();
    debugPrint("Gelen veriler: $tumVeriler");
    setState(() {});

    /* _databaseislemleri.verileriGetir().then((value) {
     
      setState(() { tumVeriler = value;});
    }); */
  }

  void snackbarGoster(String mesaj) {
    Fluttertoast.showToast(
        msg: mesaj, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
  }

  /*  Widget teksatir() {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        title: Text("data"),
      ),
    );
  } */
}
