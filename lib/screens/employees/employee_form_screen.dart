import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeFormScreen extends StatefulWidget {
  const EmployeeFormScreen({super.key});

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores básicos (Módulo 2)
  final _nameCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _rgCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _sectorCtrl = TextEditingController();
  final _salaryCtrl = TextEditingController();
  final _workLoadCtrl = TextEditingController();

  String _contractType = 'CLT';
  String _scaleType = '6x1';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cpfCtrl.dispose();
    _rgCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _roleCtrl.dispose();
    _sectorCtrl.dispose();
    _salaryCtrl.dispose();
    _workLoadCtrl.dispose();
    super.dispose();
  }

  void _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
      
      try {
        await FirebaseFirestore.instance.collection('employees').add({
          'name': _nameCtrl.text.trim(),
          'cpf': _cpfCtrl.text.trim(),
          'rg': _rgCtrl.text.trim(),
          'phone': _phoneCtrl.text.trim(),
          'address': _addressCtrl.text.trim(),
          'role': _roleCtrl.text.trim(),
          'sector': _sectorCtrl.text.trim(),
          'salary': _salaryCtrl.text.trim(),
          'workLoad': _workLoadCtrl.text.trim(),
          'contractType': _contractType,
          'scaleType': _scaleType,
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        if (mounted) {
          Navigator.pop(context); // Fechar loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Colaborador(a) \${_nameCtrl.text} cadastrado(a) com sucesso!'), backgroundColor: Colors.green),
          );
          context.pop(); // Voltar pra listagem
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar: \$e'), backgroundColor: Colors.red));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo(a) Colaborador(a)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Dados Pessoais',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Responsivo: linha em desktop, coluna em mobile
                  LayoutBuilder(builder: (context, constraints) {
                    final bool isDesktop = constraints.maxWidth > 600;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildField(isDesktop ? constraints.maxWidth / 2 - 8 : constraints.maxWidth, _nameCtrl, 'Nome Completo*', Icons.person_rounded),
                        _buildField(isDesktop ? (constraints.maxWidth / 4) - 8 : constraints.maxWidth, _cpfCtrl, 'CPF*', Icons.badge_rounded),
                        _buildField(isDesktop ? (constraints.maxWidth / 4) - 8 : constraints.maxWidth, _rgCtrl, 'RG*', Icons.perm_identity_rounded),
                        _buildField(isDesktop ? (constraints.maxWidth / 3) - 8 : constraints.maxWidth, _phoneCtrl, 'Telefone*', Icons.phone_rounded),
                        _buildField(isDesktop ? (constraints.maxWidth * 2 / 3) - 8 : constraints.maxWidth, _addressCtrl, 'Endereço Completo*', Icons.home_rounded),
                      ],
                    );
                  }),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  Text(
                    'Dados Contratuais e Escala',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  LayoutBuilder(builder: (context, constraints) {
                    final bool isDesktop = constraints.maxWidth > 600;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildField(isDesktop ? constraints.maxWidth / 3 - 8 : constraints.maxWidth, _roleCtrl, 'Cargo (Ex: Confeiteiro)*', Icons.work_rounded),
                        _buildField(isDesktop ? constraints.maxWidth / 3 - 8 : constraints.maxWidth, _sectorCtrl, 'Setor (Ex: Produção)*', Icons.category_rounded),
                        _buildField(isDesktop ? constraints.maxWidth / 3 - 8 : constraints.maxWidth, _salaryCtrl, 'Salário (R\$)*', Icons.attach_money_rounded),
                        
                        // Selects (Dropdowns mockados via Textfields por brevidade)
                        _buildField(isDesktop ? constraints.maxWidth / 3 - 8 : constraints.maxWidth, _workLoadCtrl, 'Jornada (Ex: 08:00 - 16:20)*', Icons.access_time_rounded),
                      ],
                    );
                  }),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                       const Text('Tipo de Contrato: '),
                       const SizedBox(width: 8),
                       DropdownButton<String>(
                         value: _contractType,
                         items: ['CLT', 'PJ', 'Autônomo', 'Estágio'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                         onChanged: (val) => setState(() => _contractType = val!),
                       ),
                       const SizedBox(width: 32),
                       
                       const Text('Escala: '),
                       const SizedBox(width: 8),
                       DropdownButton<String>(
                         value: _scaleType,
                         items: ['6x1', '5x1', '12x36', 'Turno Fixo', 'Rotativo'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                         onChanged: (val) => setState(() => _scaleType = val!),
                       ),
                    ],
                  ),
                  
                  const SizedBox(height: 48),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Salvar Cadastro', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _saveEmployee,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(double width, TextEditingController ctrl, String label, IconData icon) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        validator: (value) => value == null || value.isEmpty ? 'Obrigatório' : null,
      ),
    );
  }
}
