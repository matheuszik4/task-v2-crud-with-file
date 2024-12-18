class TaskModel {
  final String objectId;
  final String nomePessoa;
  final String descricaoTarefa;
  bool tarefaIsOk;
  final String fotoPessoaPath;

  TaskModel({
    required this.nomePessoa,
    required this.descricaoTarefa,
    required this.tarefaIsOk,
    required this.fotoPessoaPath,
    this.objectId = '',
  });


  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      nomePessoa: json['nomePessoa'],
      descricaoTarefa: json['descricaoTarefa'],
      tarefaIsOk: json['tarefaIsOk'],
      fotoPessoaPath: json['fotoPessoaPath'],
      objectId: json['objectId'] != null ? json['objectId'] : '',
    );
  }

  static List<TaskModel> fromJsonCollection(json) {
      List<TaskModel> taskModel = [];
      
      if (json['results'] != null) {
        json['results'].forEach((v) {
          taskModel.add(TaskModel.fromJson(v));
        });
      }

      return taskModel;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['nomePessoa'] = nomePessoa;
    data['descricaoTarefa']  = descricaoTarefa;
    data['tarefaIsOk'] = tarefaIsOk;
    data['fotoPessoaPath'] = fotoPessoaPath;
    
    return data;
  }
  
}