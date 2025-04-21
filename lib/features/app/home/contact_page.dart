import 'package:chat_application/features/app/constants/page_const.dart';
import 'package:chat_application/features/app/global/widgets/prodile_widget.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_application/features/user/presentation/cubit/get_single/get_single_user_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/get_single/get_single_user_state.dart';

import 'package:chat_application/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactPage extends StatefulWidget {
  final String userId;
  const ContactPage({super.key, required this.userId});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getAllUsers();
    BlocProvider.of<GetSingleUserCubit>(
      context,
    ).getSingleUser(userId: widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Contatc")),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, state) {
          if (state is GetSingleUserLoaded) {
            final currentUser = state.singleUser;

            return BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  final contacts =
                      state.users
                          .where((user) => user.userId != widget.userId)
                          .toList();
                  if (contacts.isEmpty) {
                    return const Center(child: Text("No contacts Yets"));
                  }
                  return ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PageConst.singleChatPage,
                            arguments: ChatEntity(
                              senderId: currentUser.userId,
                              recipientId: currentUser.userId,
                              senderName: currentUser.username,
                              recipientName: currentUser.username,
                              senderProfile: currentUser.profileUrl,
                              recipientProfile: currentUser.profileUrl,
                            ),
                          );
                        },
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: profileWidget(imageUrl: contact.profileUrl),
                          ),
                        ),
                        title: Text("${contact.username}"),
                        subtitle: const Text("Hey there! I'm using chat app"),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(color: tabColor),
                );
              },
            );
          }
          ;
          return const Center(child: Text("No contacts Yets"));
        },
      ),
    );
  }
}

// Logic to fetch contecs of the phone
// BlocBuilder<GetDeviceNumberCubit, GetDeviceNumberState>(
//         builder: (context, state) {
//           if (state is GetDeviceNumberLoaded) {
//             final contacts = state.contacts;
//             return ListView.builder(
//               itemCount: contacts.length,
//               itemBuilder: (context, index) {
//                 final contact = contacts[index];
//                 return ListTile(
//                   leading: SizedBox(
//                     width: 50,
//                     height: 50,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Image.memory(
//                         contact.photo ?? Uint8List(0),
//                         errorBuilder: (context, error, stack) {
//                           return Image.asset(AppAssets.defaultAvatar);
//                         },
//                       ),

//                       // profileWidget(),
//                     ),
//                   ),
//                   title: Text("${contact.name?.first} ${contact.name?.last}"),
//                   subtitle: const Text("Hey there! I'm using chat app"),
//                 );
//               },
//             );
//           }
//           return const Center(
//             child: CircularProgressIndicator(color: tabColor),
//           );
//         },
//       ),
