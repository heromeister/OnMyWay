import 'data_access.dart';
import 'addnew_page.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  List<globals.SavedContact> _contactsSaved;
  DataAccess _dataAccess;

  @override
  initState() {
    super.initState();
    _dataAccess = new DataAccess();
    getSavedContacts();
  }

  getSavedContacts() {
    List<Map> contacts = _dataAccess.getContacts();
    _contactsSaved = parseContactsList(contacts);
  }

  parseContactsList(List<Map> contacts) {
    for (var contact in contacts) {
      globals.SavedContact savedContact =
        globals.SavedContact(contact["displayName"],
            contact["phoneNumber"],
            contact["latitude"],
            contact["longitde"]);

      _contactsSaved.add(savedContact);
    }
  }

  saveContact(globals.SavedContact newContact) {
    _dataAccess.insertContact(newContact);
  }

  selectCallback() async {
    final data = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewPage()));
    globals.SavedContact selectedContact = data["contact"];

    print(selectedContact.toString());

    saveContact(selectedContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("On My Way")),
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
                  globals.SavedContact savedContact = _contactsSaved?.elementAt(index);
                  return ListTile(
                    onTap: () {
                      // TODO update location of a contact already picked
                    },
                    leading: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Text(savedContact.Name().length > 1
                            ? savedContact.Name()?.substring(0, 2)
                            : "")),
                    title: Text(savedContact.Name() ?? ""),
                  );
                },
              )
            : Center(child: Text("Click the button below to add new stuff")),
      ),
    );
  }
}
