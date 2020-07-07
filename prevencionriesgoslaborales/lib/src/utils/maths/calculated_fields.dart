
  int calculoNP(int nivelDeficiencia, int nivelExposicion) {

    return nivelDeficiencia * nivelExposicion;
  }

  int calculoNR( int nivelConsecuencias, int nivelP) {

    return nivelConsecuencias * nivelP;
  }

  String calculoNI( int nivelRiesgo ) {

    if ( nivelRiesgo <= 20 ) {
      return 'IV';
    } else if ( nivelRiesgo >= 40 && nivelRiesgo <= 120 ) {
      return 'III';
    } else if ( nivelRiesgo >= 150 && nivelRiesgo <= 500 ) {
      return 'II';
    } else if ( nivelRiesgo >= 600 && nivelRiesgo <= 4000 ) {
      return 'I';
    }
    return null;
  }