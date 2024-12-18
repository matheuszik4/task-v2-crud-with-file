
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_dio_v2/src/provider/task_provider.dart';
import '../../model/task_model.dart';
import '../../repository/task_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

     final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: taskProvider.listTasks.length, 
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(taskProvider.listTasks[index].nomePessoa), 
            subtitle: Text('${taskProvider.listTasks[index].descricaoTarefa}'),
            leading: Image.file(File(taskProvider.listTasks[index].fotoPessoaPath)), 
            trailing: Checkbox(
              tristate: true,
              value: taskProvider.listTasks[index].tarefaIsOk,
              onChanged: (bool? value) async {
                taskProvider.toggleCheck(taskProvider.listTasks[index]);
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

                    taskProvider.create(
                          TaskModel(
                            nomePessoa: nomePessoa,
                            descricaoTarefa: descricaoTarefa,
                            tarefaIsOk: false,
                            fotoPessoaPath: filePath
                          )
                    );
                    
                    print('Adicionando Tarefa...');

                    Navigator.of(context).pop();
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
