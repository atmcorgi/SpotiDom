import 'package:flutter/material.dart';
import 'package:SpotiDom/widgets/footer_widget.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Library',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recently Added',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.music_note, color: Colors.white),
                    title: Text(
                      'Song ${index + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Artist ${index + 1}',
                      style: TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      // Handle song selection
                    },
                  );
                },
              ),
            ),
            Footer(),
          ],
        ),
      ),
    );
  }
}
