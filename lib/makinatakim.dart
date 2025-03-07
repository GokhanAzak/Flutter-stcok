import 'package:flutter/material.dart';
import 'database.dart';

class StokTakip extends StatefulWidget {
  @override
  _StokTakipState createState() => _StokTakipState();
}

class _StokTakipState extends State<StokTakip> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final data = await DatabaseHelper.instance.getProducts();
    setState(() {
      products = data;
    });
  }

  Future<void> _addProduct(
    String name,
    String type,
    String desc,
    int price,
    int stok,
  ) async {
    await DatabaseHelper.instance.insertProduct({
      'Name': name,
      'Type': type,
      'Desc': desc,
      'Price': price,
      'Stok': stok,
    });
    _loadProducts();
  }

  Future<void> _deleteProduct(int id) async {
    await DatabaseHelper.instance.deleteProduct(id);
    _loadProducts();
  }

  void _showAddProductDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController typeController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController stokController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Yeni Ürün Ekle",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, "Ürün Adı"),
                _buildTextField(typeController, "Türü"),
                _buildTextField(descController, "Açıklama"),
                _buildTextField(priceController, "Fiyat", isNumber: true),
                _buildTextField(stokController, "Stok", isNumber: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("İptal", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                final String name = nameController.text;
                final String type = typeController.text;
                final String desc = descController.text;
                final int price = int.tryParse(priceController.text) ?? 0;
                final int stok = int.tryParse(stokController.text) ?? 0;

                if (name.isNotEmpty && type.isNotEmpty && desc.isNotEmpty) {
                  _addProduct(name, type, desc, price, stok);
                  Navigator.pop(context);
                }
              },
              child: Text("Ekle"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Stok Takip Sistemi"),
        backgroundColor: Colors.blue,
      ),
      body:
          products.isEmpty
              ? Center(
                child: Text(
                  "Henüz ürün eklenmedi.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15),
                      title: Text(
                        product['Name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "Tür: ${product['Type']} | Açıklama: ${product['Desc']} \nFiyat: ${product['Price']}₺ | Stok: ${product['Stok']}",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduct(product['id']),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _showAddProductDialog,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
