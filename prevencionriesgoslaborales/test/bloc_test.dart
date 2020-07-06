

import 'package:bloc_test/bloc_test.dart';
import 'package:prevencionriesgoslaborales/src/bloc/inspeccion_bloc.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as test;
// import 'package:mockito/mockito.dart';
import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';


// class MockRepository extends Mock implements DBProvider{}

void main() {
  test.TestWidgetsFlutterBinding.ensureInitialized();
  // MockRepository mockDBProvider;
  

  setUp(() {
    // mockDBProvider = MockRepository();
  });
  
  group('GetSomething', () {

    test.test('description', () async {

      // when(mockDBProvider.getAllInspectores()).thenAnswer((_) async => 
      // [Inspector(id: 1, usuario: 'Javi', contrasena: 'Javi')]);
      

      final bloc = InspeccionBloc();

      bloc.agregarInspector(Inspector(usuario: 'Javi', contrasena: 'Javi'));
      // bloc.agregarInspector(Inspector(id: 1, usuario: 'Javi', contrasena: 'Javi'));
      await bloc.obtenerInspectores();
      expect(bloc.inspectores, equals([Inspector(id: 1, usuario: 'Javi', contrasena: 'Javi')]));
      
    });

  });




}