class Endereco{

  late String _rua;
  late String _bairro;
  late String _cidade;
  late String _numeroCasa;
  late String _uf;
  late String _complemento;

  Endereco();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'rua' : 'Albino',
      'bairro' : 'Campo das Palmeiras',
      'cidade' : 'Maria',
      'numero' : '67',
      'uf' : 'RJ',
      'complemento' : 'Fundo'
    };
    return map;
  }

  String get complemento => _complemento;

  set complemento(String value) {
    _complemento = value;
  }

  String get uf => _uf;

  set uf(String value) {
    _uf = value;
  }

  String get numeroCasa => _numeroCasa;

  set numeroCasa(String value) {
    _numeroCasa = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  String get rua => _rua;

  set rua(String value) {
    _rua = value;
  }
}