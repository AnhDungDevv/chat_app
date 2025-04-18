import 'package:chat_application/features/app/constants/page_const.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/call/presentation/pages/call_history_page.dart';
import 'package:chat_application/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_application/features/app/home/contact_page.dart';
import 'package:chat_application/features/status/presentation/pages/status_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({super.key, required this.uid});

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
                              arguments: widget.uid,
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
        children: [ChatPage(uid: widget.uid), StatusPage(), CallHistoryPage()],
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
                  builder: (context) => ContactPage(uid: widget.uid),
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
