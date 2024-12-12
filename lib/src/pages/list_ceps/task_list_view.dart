
import 'dart:io';

import 'package:flutter/material.dart';
import '../../model/task_model.dart';
import '../../repository/task_repository.dart';
import 'package:image_picker/image_picker.dart';


class TaskListView extends StatefulWidget {
  const TaskListView({super.key, required this.title});

  final String title;

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {

  final _nomePessoaController = TextEditingController();
  final _descricaoTarefaController = TextEditingController();
  final _filePathController = TextEditingController();

  List<TaskModel> tarefaModel = [];

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  getData() async {
    final taskRepository = TaskRepository();
    this.tarefaModel = await taskRepository.index();
    setState(() {});
  }

  deleteCep(String objectId) async {
    final taskRepository = TaskRepository();
    await taskRepository.delete(objectId);
    this.getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: tarefaModel.length, 
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tarefaModel[index].nomePessoa), 
            subtitle: Text('${tarefaModel[index].descricaoTarefa}'),
            leading: Image.file(File(tarefaModel[index].fotoPessoaPath)), 
            trailing: Checkbox(
              tristate: true,
              value: tarefaModel[index].tarefaIsOk,
              onChanged: (bool? value) async {
                TaskRepository taskRepository = TaskRepository();
                await taskRepository.toggleCheck(tarefaModel[index]);
                getData();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context) {
            _nomePessoaController.text = '';
            _descricaoTarefaController.text = '';
            _filePathController.text = '';

            return AlertDialog(
              title: const Text('Tarefa'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _nomePessoaController,
                      decoration: const InputDecoration(
                        labelText: 'Nome da Pessoa',
                        hintText: 'Digite o nome da pessoa',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    TextField(
                      controller: _descricaoTarefaController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição da Tarefa',
                        hintText: 'Digite a descrição da Tarefa',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    TextButton(
                      onPressed: () async { 
                        ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                        if (image != null) { 
                          _filePathController.text = image.path;
                          print(image.path);
                        } else {
                          _filePathController.text = '';
                        }
                      },
                      child: Text('Abrir Galeria')
                    ),
                    // TextField(
                    //   controller: _filePathController,
                    //   decoration: const InputDecoration(
                    //     labelText: 'File Path',
                    //     hintText: 'Digite a path file',
                    //   ),
                    //   keyboardType: TextInputType.text,
                    // ),
                  ],
                ),
              ),
              actions: <Widget> [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o modal
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    String nomePessoa = _nomePessoaController.text;
                    String descricaoTarefa = _descricaoTarefaController.text;
                    String filePath = _filePathController.text;

                    if (nomePessoa.isEmpty 
                    || descricaoTarefa.isEmpty 
                    || filePath.isEmpty) {
                      return;
                    }

                    final taskRepository = TaskRepository();

                    taskRepository.create(
                          TaskModel(
                            nomePessoa: nomePessoa,
                            descricaoTarefa: descricaoTarefa,
                            tarefaIsOk: false,
                            fotoPessoaPath: filePath
                          )
                      );
                    print('Adicionando Tarefa...');

                    Navigator.of(context).pop();
                    
                    this.getData();
                  },
                  child: const Text('Adicionar Tarefa'),
                ),
              ]
            );
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
