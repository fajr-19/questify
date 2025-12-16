import 'package:flutter/material.dart';
import '../storage_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Questify')),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Hello, Fajar!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Your XP: 120', style: TextStyle(color: Colors.grey))
            ]),
            const CircleAvatar(radius: 26, backgroundImage: AssetImage('assets/icons/profile.jpg'))
          ]),
          const SizedBox(height: 20),
          const Text('Today\'s Quests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(child: ListView(children: const [
            _QuestCard(title:'Finish backend API', xp:40, done:false),
            _QuestCard(title:'Create Login UI', xp:30, done:true),
            _QuestCard(title:'Connect Flutter ↔ Node', xp:50, done:false),
          ]))
        ],
      )),
      floatingActionButton: FloatingActionButton(onPressed: (){}, child: const Icon(Icons.add)),
      drawer: Drawer(child: Column(children: [
        const DrawerHeader(child: Text('Questify')),
        ListTile(title: const Text('Logout'), onTap: () async { await StorageService.deleteToken(); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())); }),
      ])),
    );
  }
}

class _QuestCard extends StatelessWidget {
  final String title; final int xp; final bool done;
  const _QuestCard({super.key, required this.title, required this.xp, required this.done});
  @override Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom:12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: done?Colors.green.shade50:Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
    child: Row(children: [
      Icon(done?Icons.check_circle:Icons.circle_outlined, color: done?Colors.green:Colors.grey),
      const SizedBox(width:12),
      Expanded(child: Text(title, style: TextStyle(decoration: done?TextDecoration.lineThrough:null))),
      Text('+$xp XP', style: TextStyle(color: done?Colors.green:Colors.deepPurple, fontWeight: FontWeight.bold))
    ]),
  );
}
