import 'package:flutter/material.dart';

void main() {
  runApp(const ShoesVaultApp());
}

class ShoesVaultApp extends StatelessWidget {
  const ShoesVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShoesVault',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Shoe {
  String id;
  String brand;
  String size;
  String year;

  Shoe({
    required this.id,
    required this.brand,
    required this.size,
    required this.year,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Shoe> shoesList = [];

  void _goToFormPage({Shoe? existingShoe, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EntryPage(shoe: existingShoe)),
    );

    if (result != null && result is Shoe) {
      setState(() {
        if (index == null) {
          shoesList.add(result);
        } else {
          shoesList[index] = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShoesVault 👟'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: shoesList.isEmpty
          ? const Center(child: Text('Belum ada koleksi sepatu.'))
          : ListView.builder(
              itemCount: shoesList.length,
              itemBuilder: (context, index) {
                final item = shoesList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      item.brand,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Size: ${item.size} | Tahun: ${item.year}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _goToFormPage(existingShoe: item, index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              shoesList.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToFormPage(),
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class EntryPage extends StatefulWidget {
  final Shoe? shoe;
  const EntryPage({super.key, this.shoe});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  final TextEditingController _brandCtrl = TextEditingController();
  final TextEditingController _sizeCtrl = TextEditingController();
  final TextEditingController _yearCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.shoe != null) {
      _brandCtrl.text = widget.shoe!.brand;
      _sizeCtrl.text = widget.shoe!.size;
      _yearCtrl.text = widget.shoe!.year;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoe == null ? 'Tambah Sepatu' : 'Edit Sepatu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _brandCtrl,
              decoration: const InputDecoration(
                labelText: 'Merk Sepatu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _sizeCtrl,
              decoration: const InputDecoration(
                labelText: 'Ukuran (Size)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _yearCtrl,
              decoration: const InputDecoration(
                labelText: 'Tahun Rilis/Pembelian',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_brandCtrl.text.isNotEmpty) {
                    final newEntry = Shoe(
                      id: widget.shoe?.id ?? DateTime.now().toString(),
                      brand: _brandCtrl.text,
                      size: _sizeCtrl.text,
                      year: _yearCtrl.text,
                    );
                    Navigator.pop(context, newEntry);
                  }
                },
                child: const Text('Simpan Ke Vault'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
