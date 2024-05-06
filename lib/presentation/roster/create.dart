import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wh40k_command_center/domain/entities/catalogue.dart';
import '../../domain/entities/roster.dart';
import '../../domain/interfaces/repository.dart';
import '../widgets/index.dart';

GetIt _getIt = GetIt.instance;

class RosterCreatorPage extends StatefulWidget {
  const RosterCreatorPage({super.key});

  @override
  State<RosterCreatorPage> createState() => _ScreenState();
}

class _ScreenState extends State<RosterCreatorPage> {
  final IRepository<Roster> _repo = _getIt<IRepository<Roster>>();
  final IRepository<Catalogue> _catalogueRepo = _getIt<IRepository<Catalogue>>();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  String? _catalogueId;
  final _catalogues = <Catalogue>[];

  @override
  void initState() {
    super.initState();

    _catalogueRepo.list().then((value) {
      setState(() {
        _catalogues.addAll(value);
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit()  {
    _repo.insert(Roster(id: 0, name: _nameController.text, catalogueId: _catalogueId ?? '')).then((value) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Editar roster'),
      ),
        body:  Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextInput(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese un texto valido';
                    }
                    return null;
                  },
                  label: 'Nombre',
                ),
                const LineSpacer(),
                DropdownButton(
                  value: _catalogueId,
                  items: _catalogues.map((e) {
                    return DropdownMenuItem(value: e.id, child: Text(e.name));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _catalogueId = newValue;
                    });
                  }
                ),
                const LineSpacer(),
                PrimaryButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submit();
                      }
                    },
                    text: 'Iniciar sesion'
                )
              ],
            ),
          ),
        ),
    );
  }
}
