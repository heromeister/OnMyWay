import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'addnew_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  Iterable<Contact> _contactsSaved;

  @override
  initState() {
    super.initState();
    readSavedContactsFromFile();
  }

  readSavedContactsFromFile() {

  }

  selectCallback() async {
    final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewPage()));
    Contact selectedContact = data["contact"];
    Map<String, double> selectedLocation = data["location"];

    print("contact: " + selectedContact.displayName);
    print("location: " + selectedLocation.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("On My Way")
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
        onPressed: selectCallback,
      ),
      body: SafeArea(
        child: _contactsSaved != null
            ? ListView.builder(
          itemCount: _contactsSaved?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            Contact c = _contactsSaved?.elementAt(index);
            return ListTile(
              onTap: () {
                // TODO update location of a contact already picked
              },
              leading: ((c.avatar != null && c.avatar.length > 0)
                  ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                  : CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Text(c.displayName.length > 1
                      ? c.displayName?.substring(0, 2)
                      : "")
              )
              ),
              title: Text(c.displayName ?? ""),
            );
          },
        )
        : Center(
          child: Text("Click the button below to add new stuff")
        ),
      ),
    );
  }
}