class Produto {
  late String _avaliacao;
  late String _descricao;
  late String _idProduto;
  late String _nome;
  late num _preco;
  late String _observacoes;
  late List<String> _fotos;

  Produto();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'nome' : this._nome,
      'preco' : this._preco,
      'idProduto' : this._idProduto,
      'observacoes' : this._observacoes,
    };
    return map;
  }

  String get observacoes => _observacoes;

  set observacoes(String value) {
    _observacoes = value;
  }

  List<String> get fotos => _fotos;

  set fotos(List<String> value) {
    _fotos = value;
  }

  String get avaliacao => _avaliacao;

  set avaliacao(String value) {
    _avaliacao = value;
  }

  num get preco => _preco;

  set preco(num value) {
    _preco = value;
  }

  String get idProduto => _idProduto;

  set idProduto(String value) {
    _idProduto = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

}
