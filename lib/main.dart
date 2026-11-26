import 'package:flutter/material.dart';
void main() => runApp(const OboApp());
const emojis = ['😀','🥰','😂','😍','😎','🥹','😭','😡','❤️','💜','🔥','🎉','👍','👏','👋','🙏','🤔','😴','🚀','✨','💯','🌈','🐱','☕'];
const contacts = {'Ayşe':'🌸','Mert':'🦊','Zeynep':'🌻','Deniz':'🐼'};
class OboApp extends StatelessWidget {
  const OboApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(title:'OBO',debugShowCheckedModeBanner:false,theme:ThemeData(colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFF6652D9)),useMaterial3:true),home:const Home());
}
class Home extends StatefulWidget {
  const Home({super.key});
  @override State<Home> createState()=>_HomeState();
}
class _HomeState extends State<Home> {
  int tab=0;
  final chats=<String,List<({String emoji,bool mine})>>{'Ayşe':[(emoji:'👋',mine:false),(emoji:'🥰',mine:true)],'Mert':[(emoji:'🔥',mine:false)]};
  Future<void> open(String name) async {
    final messages=chats.putIfAbsent(name,()=>[]);
    await Navigator.of(context).push(MaterialPageRoute<void>(builder:(_)=>Chat(name:name,messages:messages)));
    if(mounted) setState((){});
  }
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('obo',style:TextStyle(fontSize:34,fontWeight:FontWeight.w900))),
    body:tab==2?const Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Text('😎',style:TextStyle(fontSize:64)),Text('OBO Kullanıcısı'),Text('Demo · v0.2')])):ListView(children:[
      if(tab==1) const Padding(padding:EdgeInsets.all(16),child:Text('Örnek kişiler · Demo rehber')),
      for(final name in contacts.keys.where((n)=>tab==1||(chats[n]?.isNotEmpty??false)))
        ListTile(leading:CircleAvatar(child:Text(contacts[name]!)),title:Text(name),subtitle:tab==0?Text(chats[name]!.last.emoji):null,trailing:const Icon(Icons.chevron_right),onTap:()=>open(name))
    ]),
    bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(i)=>setState(()=>tab=i),destinations:const [NavigationDestination(icon:Icon(Icons.chat_bubble_outline),label:'Sohbetler'),NavigationDestination(icon:Icon(Icons.people_outline),label:'Kişiler'),NavigationDestination(icon:Icon(Icons.person_outline),label:'Profil')]),
    floatingActionButton:tab==0?FloatingActionButton(onPressed:()=>setState(()=>tab=1),child:const Icon(Icons.add_comment_outlined)):null);
}
class Chat extends StatefulWidget {
  final String name;
  final List<({String emoji,bool mine})> messages;
  const Chat({super.key,required this.name,required this.messages});
  @override State<Chat> createState()=>_ChatState();
}
class _ChatState extends State<Chat> {
  final scroll=ScrollController();
  void send(String emoji){
    setState(()=>widget.messages.add((emoji:emoji,mine:true)));
    WidgetsBinding.instance.addPostFrameCallback((_){if(mounted&&scroll.hasClients)scroll.jumpTo(scroll.position.maxScrollExtent);});
  }
  @override void dispose(){scroll.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(widget.name)),body:SafeArea(child:Column(children:[
    Expanded(child:ListView(controller:scroll,padding:const EdgeInsets.all(16),children:[for(final m in widget.messages) Align(alignment:m.mine?Alignment.centerRight:Alignment.centerLeft,child:Card(color:m.mine?const Color(0xFFE7E1FF):null,child:Padding(padding:const EdgeInsets.all(12),child:Text(m.emoji,style:const TextStyle(fontSize:42)))))])),
    const Text('Bir emoji seç'),
    SizedBox(height:210,child:GridView.builder(padding:const EdgeInsets.all(8),gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:6),itemCount:emojis.length,itemBuilder:(_,i)=>InkWell(key:Key('emoji_$i'),onTap:()=>send(emojis[i]),child:Center(child:Text(emojis[i],style:const TextStyle(fontSize:30))))))
  ])));
}
