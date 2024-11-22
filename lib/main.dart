import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengelompokan Nilai Siswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
  final List<TextEditingController> _nilaiControllers = [];
  String _kategori = "";
  double? _rataRata;

  void _hitungKategori() {
    if (_formKey.currentState!.validate()) {
      List<int> nilaiList = [];
      for (var controller in _nilaiControllers) {
        nilaiList.add(int.parse(controller.text));
      }
      double rataRata = nilaiList.reduce((a, b) => a + b) / nilaiList.length;

      setState(() {
        _rataRata = rataRata;
        if (rataRata >= 88 && rataRata <= 100) {
          _kategori = "A";
        } else if (rataRata >= 75 && rataRata <= 87) {
          _kategori = "B";
        } else if (rataRata >= 55 && rataRata <= 69) {
          _kategori = "C";
        } else if (rataRata >= 0 && rataRata <= 54) {
          _kategori = "D";
        } else {
          _kategori = "Nilai tidak valid!";
        }
      });
    }
  }

  void _tambahNilaiField() {
    setState(() {
      _nilaiControllers.add(TextEditingController());
    });
  }

  void _hapusNilaiField(int index) {
    setState(() {
      _nilaiControllers[index].dispose();
      _nilaiControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var controller in _nilaiControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengelompokan Nilai Siswa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: _nilaiControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nilaiControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Masukkan Nilai Siswa',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap masukkan nilai';
                                }
                                final nilai = int.tryParse(value);
                                if (nilai == null || nilai < 0 || nilai > 100) {
                                  return 'Masukkan nilai antara 0 100';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _hapusNilaiField(index);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // warna hijau
                ),
                onPressed: _tambahNilaiField,
                child: Text('Tambah Nilai'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // warna hijau
                ),
                onPressed: _hitungKategori,
                child: Text('Hitung Rata-rata dan Kategori'),
              ),
              SizedBox(height: 20),
              if (_rataRata != null)
                Text(
                  'Rata-Rata: ${_rataRata!.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 18, color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              SizedBox(height: 10),
              Text(
                _kategori.isNotEmpty ? 'Kategori Nilai: $_kategori' : '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
