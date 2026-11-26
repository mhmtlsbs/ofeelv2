import 'package:flutter_test/flutter_test.dart';
import 'package:obo/main.dart';
void main(){test('Expiry',(){final n=DateTime(2026);expect(life(n,n),1);expect(life(n,n.add(const Duration(minutes:30))),.5);expect(life(n,n.add(const Duration(hours:1))),0);});}
