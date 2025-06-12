import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(AlisverisUygulamasi());
}

class AlisverisUygulamasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alışveriş Listesi',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AlisverisSayfasi(),
      debugShowCheckedModeBanner: false,

    );
  }
}


class AlisverisSayfasi extends StatefulWidget {
  @override
  _AlisverisSayfasiState createState() => _AlisverisSayfasiState();
}


class _AlisverisSayfasiState extends State<AlisverisSayfasi> {
  List<String> kategoriler = ['Elektronik', 'Giyim', 'Yiyecek', 'Ev Eşyası'];
  String? secilenKategori;  // Seçilen kategoriyi tutan değişken
  List<String> urunler = [];  // Ürünler listesi
  final TextEditingController kontrolcu = TextEditingController();

  @override
  void initState() {
    super.initState();
    urunleriYukle();
  }

  Future<void> urunleriYukle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      urunler = prefs.getStringList('urunler') ?? [];
    });
  }

  Future<void> urunleriKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('urunler', urunler);
    print('Veriler Kaydedildi: $urunler'); // Konsola yazdırıyoruz
  }

  void urunEkle() {
    final urun = kontrolcu.text.trim();
    if (urun.isNotEmpty) {
      setState(() {
        urunler.add(urun);
        kontrolcu.clear();
      });
      urunleriKaydet();

    }
  }


  void urunSil(int index) {
    setState(() {
      urunler.removeAt(index);
    });
    urunleriKaydet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alışveriş Listem'),backgroundColor: Colors.indigo.shade400,),
      backgroundColor: Colors.indigo.shade300,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: kontrolcu,
              decoration: InputDecoration(
                labelText: 'Ürün adı',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0),),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0), // Odaklanıldığında sınır rengi
                ),
              ),
              onSubmitted: (_) => urunEkle(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: urunEkle,
              child: Text('Ekle'),


            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: urunler.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(urunler[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => urunSil(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

  }
}
