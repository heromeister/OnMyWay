import 'data_access.dart';
import 'addnew_page.dart';
import 'contacts_helper.dart';
import 'location_picker.dart';
import 'new_locationpicker.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OnMyWayPage extends StatefulWidget {
  @override
  OnMyWayPageState createState() => new OnMyWayPageState();
}

class OnMyWayPageState extends State<OnMyWayPage> {
  BuildContext scaffoldContext;
  List<globals.SavedContact> _contactsSaved;
  ContactsHelper _contactsHelper;

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Widget _appBarTitle = Text("On My Way");
  Icon _searchIcon = Icon(Icons.search);
  Iterable<globals.SavedContact> _filteredSavedContacts;

  @override
  initState() {
    super.initState();
    _contactsSaved = new List();
    _contactsHelper = new ContactsHelper();
    getSavedContacts();
  }

  OnMyWayPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _filter.clear();
          _searchText = "";
          _filteredSavedContacts = _contactsSaved;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          _filteredSavedContacts = _contactsSaved
              .where((c) => c.name
              .toLowerCase()
              .contains(_searchText.toLowerCase()))
              .toList();
        });
      }
    });
  }

  searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = Text("On My Way");
        _filteredSavedContacts = _contactsSaved;
        _filter.clear();
      }
    });
  }

  getSavedContacts() async {
    var contacts = await _contactsHelper.getSavedContacts();
    setState(() {
      _contactsSaved = contacts;
      _filteredSavedContacts = contacts;
    });
  }

  addContact() async {
    final data = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewPage()));

    _contactsHelper.addContact(data);
    await getSavedContacts();
  }

  updateContact(globals.SavedContact contactToUpdate) async {
    final locationPicked = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => LocationPickerPage(location: contactToUpdate.location)));

    contactToUpdate.location(locationPicked);
    await _contactsHelper.updateContact(contactToUpdate);
    await getSavedContacts();
  }

  deleteContact(globals.SavedContact contactToDelete) async {
    await _contactsHelper.deleteContact(contactToDelete);
    await getSavedContacts();
  }

  onMyWayButtonPressed(globals.SavedContact contactClicked, BuildContext context) {
    showUndoSnackBar(contactClicked, context);
  }

  showUndoSnackBar(globals.SavedContact contactClicked, BuildContext context) {
    SnackBar snackBar = SnackBar(
        content: Text("You're on Your way to " + contactClicked.name),
        action: SnackBarAction(label: "Undo", onPressed: () {})
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: _appBarTitle,
          actions: <Widget>[
            IconButton(
              icon: _searchIcon,
              onPressed: searchPressed,
            )
          ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: addContact,
      ),
      body: SafeArea(
        child: _filteredSavedContacts != null
            ? ListView.builder(
          itemCount: _filteredSavedContacts?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            globals.SavedContact savedContact = _filteredSavedContacts?.elementAt(index);
            return Container(
              child: Slidable(
                delegate: SlidableDrawerDelegate(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(savedContact.name.length > 1
                              ? savedContact.name?.substring(0, 2)
                              : "")),
                        title: Text(savedContact.name ?? ""),
                      )
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(right: 8.0),
                        child: RaisedButton(
                          onPressed: () {
                            onMyWayButtonPressed(savedContact, context);
                          },
                          color: Colors.orange,
                          child: Text("On My Way",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      )
                    )
                  ]
                ),
                secondaryActions: <Widget>[
                  new IconSlideAction(
                    onTap: () {
                      updateContact(savedContact);
                    },
                    icon: Icons.edit,
                    caption: "Edit",
                  ),
                  new IconSlideAction(
                    onTap: () {
                      deleteContact(savedContact);
                    },
                    color: Colors.red,
                    icon: Icons.delete,
                    caption: "Delete",
                  )
                ],
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
