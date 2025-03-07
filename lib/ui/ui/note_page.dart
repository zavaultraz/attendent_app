part of '../pages.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _addNote() async {
    if (_titleController.text.isNotEmpty &&
        _imageUrlController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      await _firebaseService.addNote(
        _titleController.text,
        _imageUrlController.text,
        _contentController.text,
      );
      _clearFields();
    }
  }

  void _deleteNote(String noteId) async {
    await _firebaseService.deleteNote(noteId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Note berhasil dihapus")),
    );
  }

  void _clearFields() {
    _titleController.clear();
    _imageUrlController.clear();
    _contentController.clear();
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.blueAccent.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: GestureDetector(
          onTap: (){
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Text(
            'Woku Notes',
            style: GoogleFonts.concertOne(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildTextField(_titleController, 'Title', Icons.title),
            const SizedBox(height: 10),
            _buildTextField(_imageUrlController, 'Image URL', Icons.image),
            const SizedBox(height: 10),
            _buildTextField(_contentController, 'Content', Icons.description, maxLines: 3),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity, // Makes the button span the full width
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _addNote,
                child: const Text(
                  'Add Notes',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Text('Your Notes',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 24),),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: _firebaseService.getNotes(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No notes available'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var note = snapshot.data!.docs[index].data();
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: note['imageUrl'] != null && note['imageUrl'].isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              note['imageUrl'],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          )
                              : const Icon(Icons.image, size: 50, color: Colors.grey),
                          title: Text(
                            note['title'] ?? 'No Title',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueAccent.shade700),
                          ),
                          subtitle: Text(note['content'] ?? 'No Content',
                              maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever, color: Colors.red),
                                onPressed: () => _deleteNote(snapshot.data!.docs[index].id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
