import 'data_access.dart';
import 'addnew_page.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OnMyWayPage extends StatefulWidget {
  @override
  OnMyWayPageState createState() => new OnMyWayPageState();
}

class OnMyWayPageState extends State<OnMyWayPage> {
  List<globals.SavedContact> _contactsSaved;
  DataAccess _dataAccess;

  @override
  initState() {
    super.initState();
    _contactsSaved = new List();
    _dataAccess = new DataAccess();
    getSavedContacts();
  }

  getSavedContacts() async {
    List<Map> contacts = await _dataAccess.getContacts();
    await new Future.delayed(const Duration(seconds: 2));
    setState(() {
      _contactsSaved = parseContactsList(contacts);
    });
  }

  parseContactsList(List<Map> contacts) {
    List<globals.SavedContact> retContacts = new List();
    for (var contact in contacts) {
      globals.SavedContact savedContact =
      globals.SavedContact(contact["displayName"],
          contact["phoneNumber"],
          contact["latitude"],
          contact["longitde"]);
      print("yo yo bitch");
      print(contact);
      print(savedContact.toString());
      retContacts.add(savedContact);
    }

    return retContacts;
  }

  saveContact(globals.SavedContact newContact) {
    _dataAccess.insertContact(newContact);
  }

  selectCallback() async {
    final data = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewPage()));
    globals.SavedContact selectedContact = data;

    print("Check this shit outttttt: " + selectedContact.toString());

    saveContact(selectedContact);

    getSavedContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("On My Way")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: selectCallback,
      ),
      body: SafeArea(
        child: _contactsSaved != null
            ? ListView.builder(
          itemCount: _contactsSaved?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            globals.SavedContact savedContact = _contactsSaved?.elementAt(index);
            return Container(
              child: ListTile(
                onTap: () {
                  // TODO update location of a contact already picked
                },
                leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(savedContact.Name().length > 1
                        ? savedContact.Name()?.substring(0, 2)
                        : "")),
                title: Text(savedContact.Name() ?? ""),
              ),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black26))),
            );
          },
        )
            : Center(child: Text("Click the button below to add new stuff")),
      ),
    );
  }
}
