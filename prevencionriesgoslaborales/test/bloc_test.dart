

import 'package:bloc_test/bloc_test.dart';
import 'package:prevencionriesgoslaborales/src/bloc/inspeccion_bloc.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';


class MockRepository extends Mock implements DBProvider{}

void main() {
  // test.TestWidgetsFlutterBinding.ensureInitialized();
  MockRepository mockDBProvider;
  

  setUp(() {
    mockDBProvider = MockRepository();
  });
  
  group('GetSomething', () {

    test('description', () async {

      when(mockDBProvider.getAllInspectores()).thenAnswer((_) async => 
      [Inspector(id: 1, usuario: 'Javi', contrasena: 'Javi')]);

      final bloc = InspeccionBloc();
      bloc.agregarInspector(Inspector(id: 1, usuario: 'Javi', contrasena: 'Javi'));

      bloc.inspectores;
    });

    // blocTest('description', 
    //   build: () {
    //     when(mockDBProvider.getAllInspectores()).thenAnswer((_) async => 
    //       [Inspector(id: 1, usuario: 'Javi', contrasena: 'Javi')]);
    //     return InspeccionBloc();
    //   },
    //   expect: null
    // );

  });




}