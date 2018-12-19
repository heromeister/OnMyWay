import 'data_access.dart';
import 'addnew_page.dart';
import 'location_picker.dart';
import 'new_locationpicker.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ContactsHelper {
  List<globals.SavedContact> _contactsSaved;
  DataAccess _dataAccess;

  ContactsHelper() {
    _dataAccess = new DataAccess();
    _dataAccess.init();
  }

  getSavedContacts() async {
    List<Map> contacts = await _dataAccess.getContacts();
    return parseContactsList(contacts);
  }

  parseContactsList(List<Map> contacts) {
    List<globals.SavedContact> retContacts = new List();
    for (var contact in contacts) {
      globals.SavedContact savedContact =
      globals.SavedContact(
          contact["displayName"],
          contact["phoneNumber"],
          contact["identifier"],
          contact["latitude"],
          contact["longitude"],
          contact["id"]);

      print(contact);
      print(savedContact.toString());
      retContacts.add(savedContact);
    }

    return retContacts;
  }

  addContact(data) async {
    globals.SavedContact selectedContact = data;
    selectedContact.setId(await _dataAccess.insertContact(selectedContact));
    print("Contact saved. New id: " + selectedContact.id.toString());
  }

  updateContact(globals.SavedContact contactToUpdate) async {
    await _dataAccess.updateContact(contactToUpdate);
  }

  deleteContact(globals.SavedContact contactToDelete) async {
    await _dataAccess.deleteContact(contactToDelete);
  }

  deleteContacts(List contactIdsToDelete) async {
    await _dataAccess.deleteContacts(contactIdsToDelete);
  }
}