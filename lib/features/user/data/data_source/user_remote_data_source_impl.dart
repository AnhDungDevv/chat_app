import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chat_application/features/user/data/data_source/user_remote_data_source.dart';
import 'package:chat_application/features/user/data/models/user_model.dart';
import 'package:chat_application/features/user/domain/entities/contact-entity.dart';
import 'package:chat_application/features/user/domain/entities/user_entity.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient supabase;

  UserRemoteDataSourceImpl({required this.supabase});

  String _phoneNumberState = "";
  @override
  Future<void> createUser(UserEntity user) async {
    final uid = await getCurrentUID();
    final newUser =
        UserModel(
          email: user.email,
          uid: uid,
          isOnline: user.isOnline,
          phoneNumber: user.phoneNumber,
          username: user.username,
          profileUrl: user.profileUrl,
          status: user.status,
        ).toDocument();

    try {
      final response = await supabase
          .from('users')
          .upsert(newUser)
          .eq('uid', uid);

      if (response.error != null) {
        throw Exception(
          "Error occurred while creating/updating user: ${response.error!.message}",
        );
      }
    } catch (e) {
      throw Exception("Error occur while creating user");
    }
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    return supabase
        .from('users')
        .stream(primaryKey: [])
        .map((data) => data.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<String> getCurrentUID() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User not signed in");
    return user.id;
  }

  @override
  Future<List<ContactEntity>> getDeviceNumber() async {
    List<ContactEntity> contactsList = [];

    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );

      for (var contact in contacts) {
        contactsList.add(
          ContactEntity(
            name: contact.name,
            photo: contact.photo,
            phones: contact.phones,
          ),
        );
      }
    }

    return contactsList;
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    return supabase
        .from('users')
        .select()
        .eq('uid', uid)
        .single()
        .asStream()
        .map((data) {
          return [UserModel.fromSnapshot(data)];
        });
  }

  @override
  Future<bool> isSignIn() async {
    final user = supabase.auth.currentUser;
    return user != null;
  }

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) async {
    try {
      final response = await supabase.auth.verifyOTP(
        phone: _phoneNumberState,
        token: smsPinCode,
        type: OtpType.sms,
      );
      print("response ${response.user}");
      if (response.user == null) {
        throw Exception('Please enter a valid code');
      }
    } catch (e) {
      throw Exception("Unknown exception please try again");
    }
  }

  @override
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    Map<String, dynamic> userInfo = {};

    if (user.username != "" && user.username != null) {
      userInfo['username'] = user.username;
    }
    if (user.status != "" && user.status != null) {
      userInfo['status'] = user.status;
    }
    if (user.profileUrl != "" && user.profileUrl != null) {
      userInfo['profileUrl'] = user.profileUrl;
    }
    if (user.isOnline != null) userInfo['isOnline'] = user.isOnline;

    try {
      final response = await supabase
          .from('users')
          .update(userInfo)
          .eq('uid', user.uid as Object);

      if (response.error != null) {
        throw Exception(
          "Error occurred while updating user: ${response.error!.message}",
        );
      }
    } catch (e) {
      throw Exception("Error occurred while updating user");
    }
  }

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      _phoneNumberState = phoneNumber;
      await supabase.auth.signInWithOtp(phone: phoneNumber);
    } catch (e) {
      throw Exception("Error during phone number verification");
    }
  }
}
