import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Funcionários'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.go('/employees/new'),
            tooltip: "Novo Funcionário",
          ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/employees/new'),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Novo Cadastro'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho da Lista
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Equipe Ativa',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Botões de filtro mockados
                Row(
                  children: [
                    FilterChip(
                      label: const Text('Todos'),
                      selected: true,
                      onSelected: (val) {},
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Ativos'),
                      selected: false,
                      onSelected: (val) {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Tabela/Lista de Funcionários Real time Database
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('employees').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Nenhum funcionário cadastrado ainda.'));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final isActive = data['isActive'] ?? false;

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            child: Icon(Icons.person_outline_rounded, color: Theme.of(context).colorScheme.primary),
                          ),
                          title: Text(
                            data['name'] ?? 'Sem Nome',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('${data['role'] ?? 'Cargo N/A'} - ${data['sector'] ?? ''}'),
                              const SizedBox(height: 8),
                              // Badges (Etiquetas visuais)
                              Row(
                                children: [
                                  _badge(context, data['scaleType'] ?? 'N/A', Colors.blue),
                                  const SizedBox(width: 8),
                                  _badge(context, isActive ? 'Ativo' : 'Inativo', isActive ? Colors.green : Colors.red),
                                ],
                              )
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'suspend') {
                                FirebaseFirestore.instance.collection('employees').doc(docs[index].id).update({'isActive': !isActive});
                              } else if (value == 'delete') {
                                FirebaseFirestore.instance.collection('employees').doc(docs[index].id).delete();
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'edit', child: Text('Editar')),
                              PopupMenuItem(value: 'suspend', child: Text(isActive ? 'Inativar/Suspender' : 'Reativar')),
                              const PopupMenuItem(value: 'docs', child: Text('Ver Documentos')),
                              const PopupMenuItem(value: 'delete', child: Text('Excluir', style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
