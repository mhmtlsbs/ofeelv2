import 'package:flutter/material.dart';
import 'dart:math' as math;
class FeeloArt extends StatelessWidget {
 final int index; final double size;
 const FeeloArt(this.index,this.size,{super.key});
 @override Widget build(BuildContext context)=>SizedBox(width:size,height:size,child:CustomPaint(painter:_Art(index)));
}
class _Art extends CustomPainter {
 final int i; const _Art(this.i);
 @override bool shouldRepaint(covariant _Art old)=>old.i!=i;
 @override void paint(Canvas c,Size s){
 c.scale(s.width/100,s.height/100);
 Paint shade(Rect r,Color a,Color b)=>Paint()..shader=RadialGradient(center:const Alignment(-.45,-.6),radius:1.15,colors:[a,b]).createShader(r);
 void oval(double x,double y,double w,double h,Color a,Color b){final r=Rect.fromLTWH(x,y,w,h);c.drawOval(r,shade(r,a,b));}
 void shape(Path p,Color a,Color b){c.drawPath(p,shade(p.getBounds(),a,b));}
 void round(double x,double y,double w,double h,double r,Color a,Color b){final rect=Rect.fromLTWH(x,y,w,h);c.drawRRect(RRect.fromRectAndRadius(rect,Radius.circular(r)),shade(rect,a,b));}
 const cream=Color(0xfffff2dd),orange=Color(0xffdf7728),dark=Color(0xff30263e),purple=Color(0xff65509a),light=Color(0xffc7b6ef),gold=Color(0xffffc24c),red=Color(0xffd83e42);
 c.drawOval(const Rect.fromLTWH(19,85,62,9),Paint()..color=const Color(0x307d4d52)..maskFilter=const MaskFilter.blur(BlurStyle.normal,5));
 switch(i){
 case 0:
 shape(Path()..moveTo(17,43)..quadraticBezierTo(8,1,24,8)..lineTo(45,31)..lineTo(56,31)..lineTo(78,8)..quadraticBezierTo(92,2,84,45)..close(),gold,orange);
 shape(Path()..moveTo(22,31)..lineTo(21,15)..lineTo(38,33)..close(),cream,orange);
 shape(Path()..moveTo(64,33)..lineTo(79,15)..lineTo(78,35)..close(),cream,orange);
 oval(13,24,76,62,cream,orange);oval(30,51,48,33,Colors.white,cream);
 c.drawArc(const Rect.fromLTWH(9,12,82,72),3.4,2.6,false,Paint()..color=dark..style=PaintingStyle.stroke..strokeWidth=6);
 round(5,43,16,34,8,cream,orange);round(79,43,16,34,8,cream,orange);
 round(22,39,28,21,7,const Color(0xff71677e),dark);round(53,39,28,21,7,const Color(0xff71677e),dark);
 c.drawLine(const Offset(48,45),const Offset(55,45),Paint()..color=dark..strokeWidth=4);
 oval(47,60,10,6,orange,red);break;
 case 1:
 oval(22,19,57,62,light,purple);
 c.save();c.translate(50,50);c.rotate(-.4);c.drawOval(const Rect.fromLTWH(-45,-15,90,30),Paint()..color=gold..style=PaintingStyle.stroke..strokeWidth=8);c.restore();break;
 case 2:
 c.save();c.translate(50,49);c.rotate(.65);
 shape(Path()..moveTo(-12,17)..lineTo(-24,31)..lineTo(-20,5)..close(),gold,red);
 shape(Path()..moveTo(12,17)..lineTo(24,31)..lineTo(20,5)..close(),gold,red);
 shape(Path()..moveTo(0,-42)..quadraticBezierTo(27,-18,15,22)..lineTo(-15,22)..quadraticBezierTo(-27,-18,0,-42)..close(),Colors.white,const Color(0xffb7a4a4));
 shape(Path()..moveTo(0,-42)..quadraticBezierTo(14,-30,17,-19)..lineTo(-17,-19)..quadraticBezierTo(-14,-30,0,-42)..close(),gold,red);
 oval(-9,-12,18,18,light,dark);shape(Path()..moveTo(-8,24)..lineTo(0,44)..lineTo(8,24)..close(),gold,orange);c.restore();break;
 case 3:
 c.drawOval(const Rect.fromLTWH(65,43,25,26),Paint()..color=orange..style=PaintingStyle.stroke..strokeWidth=7);
 round(18,36,55,46,13,cream,orange);oval(18,30,55,17,cream,orange);oval(24,34,43,10,const Color(0xff94613e),dark);
 for(int j=0;j<2;j++){c.drawPath(Path()..moveTo(37.0+j*15,27)..quadraticBezierTo(26.0+j*15,16,39.0+j*15,7),Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=4..strokeCap=StrokeCap.round);}break;
 case 4:
 for(int j=0;j<3;j++){final x=8.0+j*23;final y=j==1?10.0:30.0;shape(Path()..moveTo(x,79)..lineTo(x+24,y)..lineTo(x+48,79)..close(),light,purple);shape(Path()..moveTo(x+12,y+34)..lineTo(x+24,y)..lineTo(x+36,y+34)..lineTo(x+25,y+26)..close(),Colors.white,cream);}break;
 case 5:
 round(10,29,80,51,10,cream,dark);round(22,21,26,14,4,cream,orange);oval(31,32,43,43,gold,dark);oval(38,39,29,29,light,dark);oval(43,43,9,9,Colors.white,light);break;
 case 6:
 round(8,35,84,43,20,Colors.white,purple);round(22,46,8,23,2,light,dark);round(15,53,22,8,2,light,dark);for(int j=0;j<4;j++){oval(66+(j%2)*10.0,45+(j~/2)*10.0,8,8,gold,orange);}break;
 case 7:
 c.drawArc(const Rect.fromLTWH(19,13,62,68),3.1,3.2,false,Paint()..color=dark..strokeWidth=9..style=PaintingStyle.stroke);round(12,43,23,36,10,cream,purple);round(65,43,23,36,10,cream,purple);break;
 case 8:
 shape(Path()..moveTo(50,82)..cubicTo(0,49,9,15,32,19)..quadraticBezierTo(45,18,50,34)..quadraticBezierTo(65,7,83,25)..cubicTo(105,49,65,75,50,82)..close(),const Color(0xffffa49a),red);break;
 case 12:
 shape(Path()..moveTo(50,87)..cubicTo(8,85,13,46,38,24)..quadraticBezierTo(36,43,48,45)..quadraticBezierTo(65,24,57,8)..cubicTo(95,39,96,83,50,87)..close(),gold,red);oval(37,53,27,31,cream,gold);break;
 default:
 if(i==11||i==15){final p=Path();for(int j=0;j<10;j++){final a=j*0.6283185-1.5707963;final r=j.isEven?39.0:18.0;final x=50+r*_cos(a),y=49+r*_sin(a);if(j==0){p.moveTo(x,y);}else{p.lineTo(x,y);}}p.close();shape(p,cream,orange);}
 else {oval(13,13,74,74,cream,gold);oval(29,37,9,12,dark,dark);oval(62,37,9,12,dark,dark);c.drawArc(const Rect.fromLTWH(34,43,32,26),0,3.14,false,Paint()..color=dark..style=PaintingStyle.stroke..strokeWidth=4..strokeCap=StrokeCap.round);}
 }
 }
 double _sin(double x){return math.sin(x);}
 double _cos(double x){return math.cos(x);}
}
