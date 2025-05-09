import 'package:chat_application/features/app/constants/page_const.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/call/presentation/pages/call_history_page.dart';
import 'package:chat_application/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_application/features/app/home/contact_page.dart';
import 'package:chat_application/features/status/presentation/pages/status_page.dart';
import 'package:chat_application/features/user/domain/entities/user_entity.dart';
import 'package:chat_application/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final int? index;
  final String userId;
  const HomePage({super.key, required this.userId, this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _currentTabIndex = _tabController!.index;
      });
    });
    if (widget.index != null) {
      setState(() {
        _currentTabIndex = widget.index!;
        _tabController!.animateTo(1);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        BlocProvider.of<UserCubit>(
          context,
        ).updateUser(user: UserEntity(userId: widget.userId, isOnline: true));
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        BlocProvider.of<UserCubit>(
          context,
        ).updateUser(user: UserEntity(userId: widget.userId, isOnline: false));
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat App',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          Row(
            children: [
              const Icon(Icons.camera_alt_outlined, color: greyColor, size: 28),
              const SizedBox(width: 25),
              const Icon(Icons.search, color: greyColor, size: 28),
              const SizedBox(width: 10),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: greyColor, size: 28),
                color: appBarColor,
                iconSize: 28,
                onSelected: (value) {},
                itemBuilder:
                    (context) => [
                      PopupMenuItem<String>(
                        value: "Settings",
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PageConst.settingsPage,
                              arguments: widget.userId,
                            );
                          },
                          child: const Text("Settings"),
                        ),
                      ),
                    ],
              ),
            ],
          ),
        ],
        bottom: TabBar(
          labelColor: tabColor,
          unselectedLabelColor: greyColor,
          indicatorColor: tabColor,
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                "Chats",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Tab(
              child: Text(
                "Status",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Tab(
              child: Text(
                "Calls",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatPage(userId: widget.userId),
          StatusPage(userId: widget.userId),
          CallHistoryPage(),
        ],
      ),
      floatingActionButton: switchFloatingActionButtonOnTabIndex(
        _currentTabIndex,
      ),
    );
  }

  switchFloatingActionButtonOnTabIndex(int index) {
    switch (index) {
      case 0:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactPage(userId: widget.userId),
                ),
              );
            },
            child: const Icon(Icons.message, color: Colors.white),
          );
        }
      case 1:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {},
            child: const Icon(Icons.camera_alt, color: Colors.white),
          );
        }
      case 2:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              Navigator.pushNamed(context, PageConst.callContactsPage);
            },
            child: const Icon(Icons.add_call, color: Colors.white),
          );
        }
      default:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,

            onPressed: () {},
            child: Icon(Icons.message),
          );
        }
    }
  }
}
