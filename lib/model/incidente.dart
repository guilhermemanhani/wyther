import 'package:flutter/material.dart';

class Incidente {
  final String descricao;
  final double latitude;
  final double longitude;
  final String userId;
  final String token;

  Incidente({
    @required this.descricao,
    @required this.latitude,
    @required this.longitude,
    @required this.userId,
    @required this.token
  });
  
}
