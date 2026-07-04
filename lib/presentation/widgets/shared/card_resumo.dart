import 'package:flutter/material.dart';

import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/presentation/widgets/shared/card_item.dart';

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
      onTap: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$titulo tocado'))),
      title: titulo,
      fontSizeTitle: fontSizeTitle,
      subtitle: HumanFormats.monuted(valor),
      fontSizeSubtitle: fontSizeValor,
      colortext: color,
    );
  }
}
