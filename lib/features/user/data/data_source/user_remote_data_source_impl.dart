import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chat_application/features/user/data/data_source/user_remote_data_source.dart';
import 'package:chat_application/features/user/data/models/user_model.dart';
import 'package:chat_application/features/user/domain/entities/contact_entity.dart';
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
          userId: uid,
          username: user.username,
          email: user.email,
          phoneNumber: user.phoneNumber,
          isOnline: user.isOnline,
          status: user.status,
          profileUrl: user.profileUrl,
        ).toJson();

    final newUserWithUid = {...newUser, 'user_id': uid};
    try {
      await supabase.from('users').insert(newUserWithUid);
    } catch (e) {
      throw Exception("Error occur while creating user $e");
    }
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    return supabase
        .from('users')
        .stream(primaryKey: ['user_id'])
        .map((data) => data.map((e) => UserModel.fromJson(e)).toList());
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
        .eq('user_id', uid)
        .single()
        .asStream()
        .map((data) {
          return [UserModel.fromJson(data)];
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
    final userModel = UserModel.fromEntity(user);
    final fullData = userModel.toJson();

    if (fullData.isEmpty) return;

    try {
      await supabase
          .from('users')
          .update(fullData)
          .eq('user_id', fullData['user_id']);
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
