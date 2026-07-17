import 'package:flutter/material.dart';
import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/presentation/widgets/shared/shared.dart';

class CardResumo extends StatelessWidget {
  final String titulo;
  final double? fontSizeTitle;
  final double valor;
  final double? fontSizeValor;
  final Color? color;

  const CardResumo({
    super.key,
    required this.titulo,
    required this.valor,
    this.color,
    this.fontSizeTitle,
    this.fontSizeValor,
  });

  @override
  Widget build(BuildContext context) {
    return CardItem(
      title: titulo,
      fontSizeTitle: fontSizeTitle,
      subtitle: HumanFormats.monuted(valor),
      fontSizeSubtitle: fontSizeValor,
      colortext: color,
    );
  }
}
