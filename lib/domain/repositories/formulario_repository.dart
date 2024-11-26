import 'package:quizzier/domain/entities/formulario.dart';

abstract class FormularioRepository {
  Future<void> guardarFormulario(Formulario formulario);
  Future<List<Formulario>> obtenerFormularios();
}
