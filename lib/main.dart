import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Not Ortalaması Hesaplama',
      theme: ThemeData(primaryColor: Colors.white),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double secilenHarfDegeri = 4;
  int secilenKredi = 1;
  String dersAdi = "";
  var formKeyy = GlobalKey<FormState>();
  List<Ders> tumDersler;
  double ortalama = 0;
  static int sayac=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKeyy.currentState.validate()) {
            formKeyy.currentState.save();
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.black54,
      ),
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Not Ortalaması Hesaplayıcısı",
          style: TextStyle(color: Colors.black54),
        ),
      ),
      body: uygulamaGovdesi(),
    );
  }

  uygulamaGovdesi() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Container(
              child: Form(
                  key: formKeyy,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepOrange),
                              borderRadius: BorderRadius.circular(20)),
                          //hintText: "Notunuzu Giriniz",
                          labelText: "Dersin Adını Giriniz:",
                          labelStyle: TextStyle(color: Colors.deepOrange),
                          hintText: "Dersinizin Adı:",
                          hintStyle: TextStyle(color: Colors.black54),
                          icon: Icon(Icons.forward, color: Colors.black54),
                          prefixIcon:
                              Icon(Icons.mode_edit, color: Colors.black54),
                          //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
                          helperText:
                              "Aldığınız dersin ismini kutucuğa girmeniz gerekmektedir.",
                        ),
                        onSaved: (kaydedilecekDers) {
                          dersAdi = kaydedilecekDers;
                          setState(() {
                            tumDersler.add(
                                Ders(dersAdi, secilenHarfDegeri, secilenKredi));
                            ortalama = 0;
                            ortalamayiHesapla();
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 2),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black54, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: secilenKredi,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (int newValue) {
                                    setState(() {
                                      secilenKredi = newValue;
                                    });
                                  },
                                  items: kredilerItems(),
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 2),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black54, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<double>(
                                  value: secilenHarfDegeri,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (newValue) {
                                    setState(() {
                                      secilenHarfDegeri = newValue;
                                    });
                                  },
                                  items: dersHarfDegerleriItems()),
                            ),
                          )
                        ],
                      ),
                    ],
                  ))),

          ///Dinamik olarak kaydedilecek dersler, kredileri ve harfnotları
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: BorderDirectional(
                    top: BorderSide(color: Colors.black54),
                    bottom: BorderSide(color: Colors.black54))),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: tumDersler.length==0 ? "Lutfen Ders Ekleyin " : "Ortalama:",
                      style: TextStyle(fontSize: 30, color: Colors.black)),
                  TextSpan(
                      text:  tumDersler.length==0 ? "" : "${ortalama.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  kredilerItems() {
    List<DropdownMenuItem<int>> krediler = [];

    for (int i = 1; i <= 5; i++) {
      krediler.add(DropdownMenuItem(
        child: Text("$i Kredi"),
        value: i,
      ));
    }
    return krediler;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {

    sayac ++;

    return Dismissible(
        key: Key(sayac.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction){
          setState(() {
            tumDersler.removeAt(index);
            ortalamayiHesapla();
          });
        },
        child: Card(
          child: ListTile(
            title: Text(tumDersler[index].ad),
            subtitle: Text(tumDersler[index].kredi.toString() +
                " Kredilik Ders ve Kredisi: " +
                tumDersler[index].harfDegeri.toString()),
          ),
        ));
  }

  dersHarfDegerleriItems() {
    List<DropdownMenuItem<double>> harfler = [];
    harfler.add(DropdownMenuItem(
      child: Text(
        "AA",
      ),
      value: 4,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "BA",
      ),
      value: 3.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "BB",
      ),
      value: 3,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "CB",
      ),
      value: 2.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "CC",
      ),
      value: 2,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "DC",
      ),
      value: 1.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "DD",
      ),
      value: 1,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "FF",
      ),
      value: 0,
    ));
    return harfler;
  }

  void ortalamayiHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;

    for (var oankiDers in tumDersler) {
      var kredi = oankiDers.kredi;
      var harfDegeri = oankiDers.harfDegeri;
      toplamNot = toplamNot + (harfDegeri * kredi);
      toplamKredi += kredi;
    }

    ortalama = toplamNot / toplamKredi;
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;

  Ders(this.ad, this.harfDegeri, this.kredi);
}
