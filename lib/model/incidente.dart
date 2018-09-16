import 'package:flutter/material.dart';

class Incidente {
  final String descricao;
  final double latitute;
  final double longitude;
  final String userId;

  Incidente({
    @required this.descricao,
    @required this.latitute,
    @required this.longitude,
    @required this.userId
  });
  
}
