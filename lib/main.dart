import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as m;
import 'package:flutter/material.dart';
void main()=>runApp(const FeeloApp());
const people=['Ali','Ayşe','Can','Zeynep','Mert','Elif','Fatih','Selin'];
const art=['🐱','🪐','🚀','☕','🏔️','📷','🎮','🎧','❤️','👍','👏','⭐','🔥','😂','🌙','✨'];
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
 bool alternate=false;
 final anchors=const [Offset(.5,.40),Offset(.22,.12),Offset(.77,.13),Offset(.19,.61),Offset(.80,.61),Offset(.32,.80),Offset(.76,.81),Offset(.5,.94)];
 double remaining(int i)=>life(start.subtract(Duration(minutes:i*8)),now);
 @override void initState(){super.initState();timer=Timer.periodic(const Duration(milliseconds:100),(_){if(mounted)setState((){now=DateTime.now();if(selected!=null&&remaining(selected!)<=0)selected=null;});});}
 @override void dispose(){timer.cancel();super.dispose();}
 void send(int p,int e){setState(()=>selected=null);ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('${people[p]} · ${art[e]} · Demo gönderim')));}
 Future<void> choose([int? p]) async{
 setState(()=>selected=null);
 final person=p??await showModalBottomSheet<int>(context:context,builder:(c)=>SafeArea(child:ListView(shrinkWrap:true,children:[const ListTile(title:Text('Kime göndermek istersin?')),for(int i=0;i<people.length;i++)ListTile(title:Text(people[i]),onTap:()=>Navigator.pop(c,i))])));
 if(person==null||!mounted)return;
 final e=await showModalBottomSheet<int>(context:context,builder:(c)=>SafeArea(child:Padding(padding:const EdgeInsets.all(16),child:Column(mainAxisSize:MainAxisSize.min,children:[Text('${people[person]} · Bir emoji seç'),GridView.count(shrinkWrap:true,crossAxisCount:4,children:[for(int i=0;i<art.length;i++)InkWell(onTap:()=>Navigator.pop(c,i),child:Center(child:Text(art[i],style:const TextStyle(fontSize:36))))])]))));
 if(e!=null&&mounted)send(person,e);
 }
 void settings(){showModalBottomSheet<void>(context:context,builder:(c)=>StatefulBuilder(builder:(c,refresh)=>SafeArea(child:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisSize:MainAxisSize.min,children:[SwitchListTile(title:const Text('Alternatif arka plan'),value:alternate,onChanged:(v){setState(()=>alternate=v);refresh((){});}),DropdownButtonFormField<int>(value:favorite,decoration:const InputDecoration(labelText:'Favori kişi'),items:[for(int i=0;i<people.length;i++)DropdownMenuItem(value:i,child:Text(people[i]))],onChanged:(v){setState(()=>favorite=v);refresh((){});}),Text('İkon önizlemesi: ${favorite==null?"feelo":art[favorite!]}'),const Text('Telefon ikonu henüz değişmez.')])))));}
 Widget token(int i,double size)=>Column(mainAxisSize:MainAxisSize.min,children:[Text(art[i],style:TextStyle(fontSize:size,height:1.1)),Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4),decoration:BoxDecoration(color:const Color(0xddfff8f3),borderRadius:BorderRadius.circular(12)),child:Text('${people[i]} · ${i==0?"Şimdi":"${60-(remaining(i)*60).ceil()} dk"}',style:const TextStyle(fontSize:11,fontWeight:FontWeight.w600)))]);
 @override Widget build(BuildContext context)=>Scaffold(body:Container(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:alternate?[const Color(0xfff4eee6),const Color(0xffe2e7d9)]:[const Color(0xfffff9f5),const Color(0xfff9e5d9),const Color(0xfff4e9e6)])),child:Stack(children:[const Positioned.fill(child:CustomPaint(painter:BackdropArt())),SafeArea(child:Column(children:[
 Padding(padding:const EdgeInsets.all(12),child:Row(children:[IconButton(onPressed:settings,icon:const Icon(Icons.person_outline)),const Spacer(),const Column(children:[Text('Feelo',style:TextStyle(fontSize:38,fontStyle:FontStyle.italic,fontWeight:FontWeight.w800,letterSpacing:-2,color:Color(0xff242132))),SizedBox(width:48,height:9,child:CustomPaint(painter:SmileMark()))]),const Spacer(),IconButton(onPressed:settings,icon:const Icon(Icons.settings_outlined))])),
 Expanded(child:LayoutBuilder(builder:(c,b){final w=b.maxWidth,h=b.maxHeight,t=now.difference(start).inMilliseconds/1000;return Stack(children:[
 Positioned.fill(child:GestureDetector(behavior:HitTestBehavior.opaque,onTap:()=>setState(()=>selected=null))),
 for(int i=7;i>=0;i--)if(remaining(i)>0&&selected!=i)Builder(builder:(_){final l=remaining(i),s=m.min(w*(i==0?.49:.25),i==0?190.0:96.0)*l;final x=(anchors[i].dx*w+m.sin(t*.6+i)*8).clamp(55.0,m.max(55.0,w-55)).toDouble();final y=(anchors[i].dy*h+m.cos(t*.5+i)*8).clamp(45.0,m.max(45.0,h-65)).toDouble();return Positioned(left:x-m.max(55.0,s/2),top:y-(s+24)/2,width:m.max(110.0,s),child:Opacity(opacity:m.min(1.0,l*4),child:GestureDetector(onTap:()=>setState(()=>selected=i),child:token(i,s))));}),
 if(selected!=null)...[
 Positioned.fill(child:GestureDetector(onTap:()=>setState(()=>selected=null),child:BackdropFilter(filter:ui.ImageFilter.blur(sigmaX:7,sigmaY:7),child:Container(color:const Color(0x665b4950))))),
 Positioned(left:w/2-60,top:h/2-60,width:120,child:token(selected!,80)),
 for(int j=0;j<6;j++)Builder(builder:(_){final a=-m.pi/2+j*m.pi/3,r=m.min(112.0,m.min(w,h)/2-30);return Positioned(left:w/2+m.cos(a)*r-25,top:h/2+m.sin(a)*r-25,child:Material(color:const Color(0xfffff8f4),shape:const CircleBorder(),child:InkWell(customBorder:const CircleBorder(),onTap:(){final p=selected!;if(j==5){choose(p);}else{send(p,j+8);}},child:SizedBox(width:50,height:50,child:Center(child:j==5?const Icon(Icons.add):Text(art[j+8],style:const TextStyle(fontSize:26)))))));})
 ]
 ]); })),
 Padding(padding:const EdgeInsets.fromLTRB(20,0,20,16),child:Row(children:[const Text('Son 60 dakika · Demo',style:TextStyle(color:Color(0xff776a76))),const Spacer(),FloatingActionButton(onPressed:()=>choose(),backgroundColor:const Color(0xff55447f),foregroundColor:Colors.white,child:const Icon(Icons.add))]))
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
