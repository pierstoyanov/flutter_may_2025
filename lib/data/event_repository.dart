import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter_application_1/models/event_item.dart';

class EventRepository extends ChangeNotifier {
  static const String _localStorageKey = 'event_items'; 

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  List<EventItem> _events = [];
  bool _isLoading = false;

  EventRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth, _firestore = firestore {
      _auth.authStateChanges().listen((user) {
        if (user != null) {_syncEventsWithFirebase(); // Sync when user logs in
      }
    });
    _loadEventsFromLocal(); // Always load local data first
  }

  List<EventItem> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> _setLoading(bool value) async {
    _isLoading = value;
    notifyListeners();
  }

  // --- Local Storage Operations (shared_preferences) ---
  Future<void> _loadEventsFromLocal() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_localStorageKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _events = jsonList.map((e) => EventItem.fromMap(e as Map<String, dynamic>)).toList();
      } else {
        _events = []; // No local data yet
      }
    } catch (e) {
      print('Error loading events from local storage: $e');
      _events = [];
    } finally {
      _setLoading(false);
      notifyListeners(); // Notify after loading
    }
  }

  Future<void> _saveEventsToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> eventMaps = _events.map((e) => e.toMap()).toList();
    await prefs.setString(_localStorageKey, json.encode(eventMaps));
  }

  // --- Firebase Operations (Firestore) ---
  CollectionReference<Map<String, dynamic>>? _getUserCollection() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection('users').doc(user.uid).collection('events');
    }
    return null; // No logged-in user
  }

  Future<void> _syncEventsWithFirebase() async {
    final userEventsCollection = _getUserCollection();
    if (userEventsCollection == null) return; // No logged-in user

    _setLoading(true);
    try {
      // 1. Fetch remote events
      final QuerySnapshot<Map<String, dynamic>> snapshot = await userEventsCollection.get();
      final List<EventItem> remoteEvents = snapshot.docs
          .map((doc) => EventItem.fromMap(doc.data()))
          .toList();

      // 2. Merge/Reconcile (Example: prioritize remote, or implement more complex logic)
      final Map<String, EventItem> mergedEventsMap = { for (var event in _events) event.id: event }; // Start with local
      for (var remoteEvent in remoteEvents) {
        // Simple merge: remote wins if IDs match, otherwise add remote
        mergedEventsMap[remoteEvent.id] = remoteEvent;
      }
      _events = mergedEventsMap.values.toList();

      // 3. Update local storage with merged data
      await _saveEventsToLocal();

      // 4. Push local changes (new or updated local items) to Firebase
      for (var event in _events) {
        // If the event from the merged list was not present in the original remote fetch,
        // it means it's a new local item that needs to be uploaded.
        if (remoteEvents.every((rt) => rt.id != event.id)) {
          await userEventsCollection.doc(event.id).set(event.toMap());
        }
      }

      // Add a listener for real-time updates (optional, but common for Firestore)
      // This will ensure _events stays up-to-date in real-time
      userEventsCollection.snapshots().listen((event) {
        final List<EventItem> newRemoteEvents = event.docs.map((doc) => EventItem.fromMap(doc.data())).toList();
        // Implement merging logic here for real-time updates as well
        final Map<String, EventItem> liveMergedEventsMap = { for (var event in _events) event.id: event };
        for (var newEvent in newRemoteEvents) {
            liveMergedEventsMap[newEvent.id] = newEvent;
        }
        _events = liveMergedEventsMap.values.toList();
        // Remove deleted items if needed
        _events.removeWhere((localEvent) => !newRemoteEvents.any((remoteEvent) => remoteEvent.id == localEvent.id));

        notifyListeners(); // Notify UI of real-time changes
      });


    } catch (e) {
      print('Error syncing events with Firebase: $e');
    } finally {
      _setLoading(false);
    }
  }

  // --- CRUD Operations for UI Interaction ---

  Future<void> addEvent(EventItem newEvent) async {
    _events.add(newEvent);
    notifyListeners(); // Update UI immediately
    await _saveEventsToLocal(); // Save to local storage

    final userEventsCollection = _getUserCollection();
    if (userEventsCollection != null) {
      try {
        await userEventsCollection.doc(newEvent.id).set(newEvent.toMap());
      } catch (e) {
        print('Error adding event to Firebase: $e');
        // Handle sync failure (e.g., mark for retry, show error)
      }
    }
  }

  Future<void> updateEvent(EventItem updatedEvent) async {
    final index = _events.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      notifyListeners(); // Update UI immediately
      await _saveEventsToLocal(); // Save to local storage

      final userEventsCollection = _getUserCollection();
      if (userEventsCollection != null) {
        try {
          await userEventsCollection.doc(updatedEvent.id).set(updatedEvent.toMap());
        } catch (e) {
          print('Error updating event in Firebase: $e');
        }
      }
    }
  }

  Future<void> deleteEvent(String id) async {
    _events.removeWhere((event) => event.id == id);
    notifyListeners(); // Update UI immediately
    await _saveEventsToLocal(); // Save to local storage

    final userEventsCollection = _getUserCollection();
    if (userEventsCollection != null) {
      try {
        await userEventsCollection.doc(id).delete();
      } catch (e) {
        print('Error deleting event from Firebase: $e');
      }
    }
  }
}