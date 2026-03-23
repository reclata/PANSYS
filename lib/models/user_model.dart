class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // Administrador, Gerente, RH, Lider, Funcionario
  final bool isActive;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.isActive = true,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'Funcionario',
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name, 'role': role, 'isActive': isActive};
  }
}
