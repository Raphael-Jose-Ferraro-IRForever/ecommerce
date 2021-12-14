
class Pedido{

  late String _idPedido;
  late String _estado;
  late String _data;
  late num _numPedido;
  late String _numTelefone;
  late String _nomeUsuario;
  late String _pagamento;
  late Map<String, dynamic> _produtos;
  late num _total;
  late num _troco;
  late Map _endereco;

  Pedido();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'data' : this.data,
      'produtos' : this.produtos,
      'idPedido' : this.idPedido,
      'estado' : this.estado,
      'nomeUsuario' : this.nomeUsuario,
      'total' : this.total,
      'troco' : this.troco,
      'pagamento' : this.pagamento,
      'numPedido' : this.numPedido,
      'endereco' : this.endereco,
      'numTelefone' : this.numTelefone
    };
    return map;
  }

  String get numTelefone => _numTelefone;

  set numTelefone(String value) {
    _numTelefone = value;
  }

  num get troco => _troco;

  set troco(num value) {
    _troco = value;
  }

  String get nomeUsuario => _nomeUsuario;

  set nomeUsuario(String value) {
    _nomeUsuario = value;
  }

  num get numPedido => _numPedido;

  set numPedido(num value) {
    _numPedido = value;
  }

  String get pagamento => _pagamento;

  set pagamento(String value) {
    _pagamento = value;
  }

  Map get endereco => _endereco;

  set endereco(Map value) {
    _endereco = value;
  }

  num get total => _total;

  set total(num value) {
    _total = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  Map<String, dynamic> get produtos => _produtos;

  set produtos(Map<String, dynamic> value) {
    _produtos = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get idPedido => _idPedido;

  set idPedido(String value) {
    _idPedido = value;
  }

}