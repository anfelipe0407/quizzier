class Objeto {
  final int id;
  final String nombre;
  final String imagen;
  final int precio;

  Objeto({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.precio,
  });

  // Método para crear una instancia de Objeto desde un JSON
  factory Objeto.fromJson(Map<String, dynamic> json) {
    return Objeto(
      id: json['id'],
      nombre: json['nombre'],
      imagen: json['imagen'],
      precio: json['precio'],
    );
  }

  // Método para convertir a Map (para si alguna vez necesitas convertirlo de nuevo a JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'imagen': imagen,
      'precio': precio,
    };
  }
}
