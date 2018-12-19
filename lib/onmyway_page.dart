import 'addnew_page.dart';
import 'contacts_helper.dart';
import 'location_picker.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:easy_alert/easy_alert.dart';

import 'new_locationpicker.dart';
import 'locationpicker_leaflet.dart';
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

  Icon _deleteIcon = Icon(Icons.delete);
  bool _deleteClicked = false;
  Map<int, bool> _whichContactsToDelete;

  Iterable<globals.SavedContact> _filteredSavedContacts;

  @override
  initState() {
    super.initState();
    _contactsSaved = new List();
    _whichContactsToDelete = new Map();
    _contactsHelper = new ContactsHelper();
    getSavedContacts();
    initContactsDeletionMap();
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

  initContactsDeletionMap() {
    Map<int, bool> tempMap = new Map();
    for(var contact in _contactsSaved) {
      tempMap[contact.id] = false;
    }

    setState(() {
      _whichContactsToDelete = tempMap;
    });
  }

  searchPress() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        enterSearchMode();
      } else {
        exitSearchMode();
      }
    });
  }

  enterSearchMode() {
    _searchIcon = Icon(Icons.close);
    _appBarTitle = TextField(
        controller: _filter,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search), hintText: 'Search...'
        )
    );
  }

  exitSearchMode() {
    _searchIcon = Icon(Icons.search);
    _appBarTitle = Text("On My Way");
    _filteredSavedContacts = _contactsSaved;
    _filter.clear();
  }

  // TODO
  deletePress() {
    if(_deleteClicked && extractPickedContactsToDelete().length > 0) {
     Alert.confirm(context, title: "Are you sure you want to delete these").then((int ret) {
       if (ret == Alert.OK) {
         Map pickedContacts = extractPickedContactsToDelete();
         deleteContacts(pickedContacts.keys.toList());
       }
     });
    } else {
      initContactsDeletionMap();
    }

    if (_contactsSaved.length > 0) {
      setState(() {
        _deleteClicked = !_deleteClicked;
      });
    }
  }

  extractPickedContactsToDelete() {
    return Map.fromIterable(_whichContactsToDelete.keys.where((key) => _whichContactsToDelete[key]), key: (k) => k, value: (k) => _whichContactsToDelete[k]);
  }

  backPress() {
    setState(() {
      _deleteClicked = false;
    });
  }

  getSavedContacts() async {
    var contacts = await _contactsHelper.getSavedContacts();
    setState(() {
      _contactsSaved = contacts;
      _filteredSavedContacts = contacts;
    });
    print("Contacts list length: " + _contactsSaved.length.toString());
  }

  addContact() async {
    exitSearchMode();
    final data = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewPage(_contactsSaved)));

    if(data != null) {
      _contactsHelper.addContact(data);
      await getSavedContacts();
    }
    _deleteClicked = false;
  }

  updateContact(globals.SavedContact contactToUpdate) async {
    exitSearchMode();
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

  deleteContacts(List contactIdsToDelete) async {
    await _contactsHelper.deleteContacts(contactIdsToDelete);
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: searchPress
          ),
          IconButton(
            icon: _deleteIcon,
            onPressed: deletePress,
          )
        ],
        leading: (!_deleteClicked) ? null :
        IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: backPress
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: addContact,
      ),
      body: SafeArea(
        child: (_filteredSavedContacts != null && _filteredSavedContacts.length > 0)
            ? showMainListView()
            : (_searchIcon.icon == Icons.search) ? Center(child: Text("Click the button below to add new stuff"))
                                                 : Text(""),
      ),
    );
  }

  Widget showMainListView() {
    return ListView.builder(
      itemCount: _filteredSavedContacts?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        globals.SavedContact savedContact = _filteredSavedContacts?.elementAt(index);
        return Container(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: ListTile(
                      onTap: () => (!_deleteClicked) ? updateContact(savedContact) : {},
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
                        child: _deleteClicked
                            ? Checkbox(
                              value: _whichContactsToDelete[savedContact.id],
                              onChanged: (boolChangedValue) {
                                setState(() {
                                  _whichContactsToDelete[savedContact.id] = boolChangedValue;
                                });
                              }
                            )
                            : FlatButton(
                            onPressed: () {
                              onMyWayButtonPressed(savedContact, context);
                            },
                            color: Colors.blue,
                            child: Text("On My Way", style: TextStyle(color: Colors.white))
                        )
                    )
                )
              ]
          ),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black26))),
        );
      },
    );
  }
}
