import 'data_access.dart';
import 'addnew_page.dart';
import 'location_picker.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
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
    _dataAccess.clearTable("Contacts");
    getSavedContacts();
  }

  getSavedContacts() async {
    List<Map> contacts = await _dataAccess.getContacts();
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
          contact["id"],
          contact["latitude"],
          contact["longitude"]);

      print("blaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      print(contact['latitude']);
      print(contact['longitude']);
      print("yo yo bitch");
      print(contact);
      print(savedContact.toString());
      retContacts.add(savedContact);
    }

    return retContacts;
  }

  addContact() async {
    final data = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewPage()));
    globals.SavedContact selectedContact = data;

    selectedContact.setId(await _dataAccess.insertContact(selectedContact));
    print("Contact saved. New id: " + selectedContact.id.toString());

    await getSavedContacts();
  }

  updateContact(globals.SavedContact contactToUpdate) async {
    print("updateContact: Contact's location");
    print(contactToUpdate.location);
    print(contactToUpdate.toString());

    final locationPicked = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => LocationPickerPage(location: contactToUpdate.location)));

    contactToUpdate.location(locationPicked);

    await _dataAccess.updateContact(contactToUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("On My Way")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: addContact,
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
                  updateContact(savedContact);
                },
                leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(savedContact.name.length > 1
                        ? savedContact.name?.substring(0, 2)
                        : "")),
                title: Text(savedContact.name ?? ""),
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
