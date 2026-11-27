import 'dart:async';
import 'feelo_art.dart';
import 'dart:ui' as ui;
import 'dart:math' as m;
import 'package:flutter/material.dart';
void main()=>runApp(const FeeloApp());
const people=['Ali','Ayşe','Can','Zeynep','Mert','Elif','Fatih','Selin'];
const art=['Kedi','Gezegen','Roket','Kahve','Dağ','Kamera','Oyun','Kulaklık','Kalp','Onay','Alkış','Yıldız','Ateş','Neşe','Ay','Parıltı'];
double life(DateTime sent,DateTime now)=>(1-now.difference(sent).inMilliseconds/3600000).clamp(0.0,1.0).toDouble();
class FeeloApp extends StatelessWidget{
 const FeeloApp({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(title:'Feelo',debugShowCheckedModeBanner:false,theme:ThemeData(useMaterial3:true,colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xff64508d)),scaffoldBackgroundColor:const Color(0xfffaf0e9),bottomSheetTheme:const BottomSheetThemeData(backgroundColor:Color(0xfffff8f4))),home:const Field());
}
class Field extends StatefulWidget{
 const Field({super.key});
 @override State<Field> createState()=>_FieldState();
}
class _FieldState extends State<Field>{
 final start=DateTime.now();
 late DateTime now=start;
 late Timer timer;
 int? selected,favorite;
 bool composing=false;
 final sent=<({int person,int emoji,DateTime at})>[];
 bool alternate=false;
 final anchors=const [Offset(.5,.40),Offset(.22,.12),Offset(.77,.13),Offset(.19,.61),Offset(.80,.61),Offset(.32,.80),Offset(.76,.81),Offset(.5,.94)];
 double remaining(int i)=>life(start.subtract(Duration(minutes:i*8)),now);
 @override void initState(){super.initState();timer=Timer.periodic(const Duration(milliseconds:100),(_){if(mounted)setState((){now=DateTime.now();sent.removeWhere((v)=>life(v.at,now)==0);if(selected!=null&&!composing&&remaining(selected!)<=0)selected=null;});});}
 @override void dispose(){timer.cancel();super.dispose();}
 void send(int p,int e){setState((){selected=null;composing=false;sent.add((person:p,emoji:e,at:DateTime.now()));});ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('${people[p]} · ${art[e]} · Demo gönderim')));}
 Future<void> choose([int? p]) async{
 setState((){selected=null;composing=false;});
 final person=p??await showModalBottomSheet<int>(context:context,isScrollControlled:true,builder:(c)=>SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[const Text('Kime göndermek istiyorsun?',style:TextStyle(fontSize:25,fontWeight:FontWeight.bold)),const SizedBox(height:20),GridView.count(shrinkWrap:true,crossAxisCount:3,children:[for(int i=0;i<people.length;i++)InkWell(onTap:()=>Navigator.pop(c,i),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[CircleAvatar(radius:28,backgroundColor:const Color(0xffe9d9d4),child:Text(people[i][0],style:const TextStyle(fontSize:24))),const SizedBox(height:6),Text(people[i])]))])]))));
 if(p==null&&person!=null&&mounted){setState((){selected=person;composing=true;});return;}
 if(person==null||!mounted)return;
 final e=await showModalBottomSheet<int>(context:context,builder:(c)=>SafeArea(child:Padding(padding:const EdgeInsets.all(16),child:Column(mainAxisSize:MainAxisSize.min,children:[Text('${people[person]} · Bir emoji seç'),GridView.count(shrinkWrap:true,crossAxisCount:4,children:[for(int i=0;i<art.length;i++)InkWell(onTap:()=>Navigator.pop(c,i),child:Center(child:FeeloArt(i,64)))])]))));
 if(e!=null&&mounted)send(person,e);
 }
 void profile(){showModalBottomSheet<void>(context:context,builder:(c)=>StreamBuilder<int>(stream:Stream.periodic(const Duration(seconds:1),(i)=>i),builder:(c,snapshot)=>SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[const Text('Profilim',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),const SizedBox(height:16),const Text('Gönderdiklerim'),if(sent.isEmpty)const Padding(padding:EdgeInsets.all(24),child:Text('Henüz gönderim yok')),Flexible(child:ListView(shrinkWrap:true,children:[for(final v in sent.reversed.where((v)=>life(v.at,DateTime.now())>0))ListTile(leading:CircleAvatar(child:Text(people[v.person][0])),title:Text(people[v.person]),subtitle:Text('${(life(v.at,DateTime.now())*60).ceil()} dk kaldı'),trailing:FeeloArt(v.emoji,46))]))])))));}
 void settings(){showModalBottomSheet<void>(context:context,builder:(c)=>StatefulBuilder(builder:(c,refresh)=>SafeArea(child:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisSize:MainAxisSize.min,children:[SwitchListTile(title:const Text('Alternatif arka plan'),value:alternate,onChanged:(v){setState(()=>alternate=v);refresh((){});}),DropdownButtonFormField<int>(value:favorite,decoration:const InputDecoration(labelText:'Favori kişi'),items:[for(int i=0;i<people.length;i++)DropdownMenuItem(value:i,child:Text(people[i]))],onChanged:(v){setState(()=>favorite=v);refresh((){});}),Text('İkon önizlemesi: ${favorite==null?"feelo":art[favorite!]}'),const Text('Telefon ikonu henüz değişmez.')])))));}
 Widget token(int i,double size)=>Column(mainAxisSize:MainAxisSize.min,children:[FeeloArt(i,size),Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4),decoration:BoxDecoration(color:const Color(0xddfff8f3),borderRadius:BorderRadius.circular(18),border:Border.all(color:Colors.white70),boxShadow:const [BoxShadow(color:Color(0x187c4e53),blurRadius:12,offset:Offset(0,5))]),child:Text('${people[i]} · ${(60-(remaining(i)*60).ceil())==0?"Şimdi":"${60-(remaining(i)*60).ceil()} dk"}',style:const TextStyle(fontSize:11,fontWeight:FontWeight.w500)))]);
 @override Widget build(BuildContext context)=>Scaffold(body:Container(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:alternate?[const Color(0xfff4eee6),const Color(0xffe2e7d9)]:[const Color(0xfffff9f5),const Color(0xfff9e5d9),const Color(0xfff4e9e6)])),child:Stack(children:[const Positioned.fill(child:CustomPaint(painter:BackdropArt())),SafeArea(child:Column(children:[
 Padding(padding:const EdgeInsets.all(12),child:Row(children:[IconButton(onPressed:profile,icon:const Icon(Icons.person_outline)),const Spacer(),const Column(children:[Text('Feelo',style:TextStyle(fontSize:38,fontStyle:FontStyle.italic,fontWeight:FontWeight.w800,letterSpacing:-2,color:Color(0xff242132))),SizedBox(width:48,height:9,child:CustomPaint(painter:SmileMark()))]),const Spacer(),IconButton(onPressed:settings,icon:const Icon(Icons.settings_outlined))])),
 Expanded(child:LayoutBuilder(builder:(c,b){final w=b.maxWidth,h=b.maxHeight,t=now.difference(start).inMilliseconds/1000;return Stack(children:[
 Positioned.fill(child:GestureDetector(behavior:HitTestBehavior.opaque,onTap:()=>setState(()=>selected=null))),
 for(int i=7;i>=0;i--)if(remaining(i)>0&&selected!=i)Builder(builder:(_){final l=remaining(i),s=m.min(w*(i==0 ? 0.55 : 0.32),i==0 ? 210.0 : 120.0)*m.sqrt(l);final x=(anchors[i].dx*w+m.sin(t*.6+i)*8).clamp(55.0,m.max(55.0,w-55)).toDouble();final y=(anchors[i].dy*h+m.cos(t*.5+i)*8).clamp(45.0,m.max(45.0,h-65)).toDouble();return Positioned(left:x-m.max(55.0,s/2),top:y-(s+24)/2,width:m.max(110.0,s),child:Opacity(opacity:m.min(1.0,l*4),child:GestureDetector(onTap:()=>setState((){selected=i;composing=false;}),child:token(i,s))));}),
 if(selected!=null)...[
 Positioned.fill(child:GestureDetector(onTap:()=>setState(()=>selected=null),child:BackdropFilter(filter:ui.ImageFilter.blur(sigmaX:7,sigmaY:7),child:Container(color:const Color(0x665b4950))))),
 Positioned(left:w/2-60,top:h/2-60,width:120,child:composing?Column(children:[CircleAvatar(radius:40,child:Text(people[selected!][0],style:const TextStyle(fontSize:32))),Text(people[selected!])]):token(selected!,80)),
 for(int j=0;j<6;j++)Builder(builder:(_){final a=-m.pi/2+j*m.pi/3,r=m.min(112.0,m.min(w,h)/2-30);return Positioned(left:w/2+m.cos(a)*r-25,top:h/2+m.sin(a)*r-25,child:Material(color:const Color(0xfffff8f4),shape:const CircleBorder(),child:InkWell(customBorder:const CircleBorder(),onTap:(){final p=selected!;if(j==5){choose(p);}else{send(p,j+8);}},child:SizedBox(width:50,height:50,child:Center(child:j==5?const Icon(Icons.add):FeeloArt(j+8,39))))));})
 ]
 ]); })),
 Padding(padding:const EdgeInsets.fromLTRB(20,0,20,16),child:Row(children:[const Text('Son 60 dakika',style:TextStyle(color:Color(0xff776a76),fontSize:11)),const Spacer(),GestureDetector(onTap:()=>choose(),child:Container(width:62,height:62,decoration:BoxDecoration(shape:BoxShape.circle,gradient:const LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xffa78bd0),Color(0xff453267)]),border:Border.all(color:Colors.white,width:2),boxShadow:const [BoxShadow(color:Color(0x55644c88),blurRadius:18,offset:Offset(0,7))]),child:const Icon(Icons.add,color:Colors.white,size:34)))]))
 ]))])));
}

class SmileMark extends CustomPainter{
 const SmileMark();
 @override void paint(Canvas c,Size s){c.drawPath(Path()..moveTo(2,1)..quadraticBezierTo(s.width/2,s.height*1.6,s.width-2,1),Paint()..color=const Color(0xffe47750)..style=PaintingStyle.stroke..strokeWidth=4..strokeCap=StrokeCap.round);}
 @override bool shouldRepaint(covariant CustomPainter old)=>false;
}
class BackdropArt extends CustomPainter{
 const BackdropArt();
 @override void paint(Canvas c,Size s){
 final p=Path()..moveTo(0,s.height*.69)..cubicTo(s.width*.12,s.height*.77,s.width*.22,s.height*.93,s.width*.65,s.height)..lineTo(0,s.height)..close();
 c.drawPath(p,Paint()..shader=const LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xff9385bb),Color(0xff514775)]).createShader(Offset.zero&s));
 c.drawCircle(Offset(s.width*1.04,s.height*.47),s.width*.15,Paint()..color=const Color(0xfff5c798));
 }
 @override bool shouldRepaint(covariant CustomPainter old)=>false;
}
