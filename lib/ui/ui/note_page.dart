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
    if (_titleController.text.isEmpty ||
        _imageUrlController.text.isEmpty ||
        _contentController.text.isEmpty) {
      return;
    } else {
      await _firebaseService.addNote(_titleController.text,
          _imageUrlController.text, _contentController.text);
    }
  }
  void _deleteNote(String noteId) async {
    try {
      await _firebaseService.deleteNote(noteId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Note berhasil dihapus")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus note: $e")),
      );
    }
  }
  void _updateNote(
      String noteId,
      String title,
      String content,
      String imageurl,
      )async{
    _titleController.text = title;
    _imageUrlController.text = imageurl;
    _contentController.text = content;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Update Note',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(Icons.title, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      prefixIcon: Icon(Icons.image, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _contentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      prefixIcon: Icon(Icons.description, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _firebaseService.updateNote(
                  noteId,
                  _titleController.text,
                  _contentController.text,
                  _imageUrlController.text,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Update Notes'),
            ),
          ],
        );
      },
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  controller: _titleController,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                  controller: _imageUrlController,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  controller: _contentController,
                  maxLines: 2,
                ),
                ElevatedButton(
                  onPressed: _addNote,
                  child: const Text('Save Notes'),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firebaseService.getNotes(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No notes available'));
                }

                var notes = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (BuildContext context, int index) {
                    var note = notes[index].data();
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: note['imageUrl'] != null && note['imageUrl'].isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            note['imageUrl'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        )
                            : Icon(Icons.image, size: 50, color: Colors.grey.shade400), // Placeholder
                        title: Text(
                          note['title'] ?? 'No Title',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          note['content'] ?? 'No Content',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                _updateNote(
                                    snapshot.data!.docs[index].id,
                                    snapshot.data!.docs[index]['title'],
                                    snapshot.data!.docs[index]['content'],
                                    snapshot.data!.docs[index]['imageUrl']);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(Icons.edit, size: 20, color: Colors.orange),
                              ),
                            ),
                            SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                _deleteNote(snapshot.data!.docs[index].id);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(Icons.delete_forever, size: 20, color: Colors.red),
                              ),
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
    );
  }
}
