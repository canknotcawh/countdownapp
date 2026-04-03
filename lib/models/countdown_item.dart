// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CountdownItem {
  CountdownItem({
    String? id,
    required this.title,
    required this.target,
    this.color,
    IconData? icon,
    this.note,
  }) : id = id ?? const Uuid().v4(),
       icon = icon ?? LucideIcons.smile;

  String id;
  String title;
  DateTime target;
  Color? color;
  IconData? icon;
  String? note;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'target': target.toIso8601String(),
    'color': color?.toARGB32(),
    'icon': _iconToString(icon),
    'note': note,
  };

  factory CountdownItem.fromJson(Map<String, dynamic> json) {
    IconData? icon;
    if (json['icon'] is int) {
      final int code = json['icon'];
      icon = CountdownItem._icons.values
          .firstWhere((e) => e.codePoint == code, orElse: () => LucideIcons.smile);
    } 
    else if (json['icon'] is String) {
      icon = CountdownItem._stringToIcon(json['icon']);
    } 
    else {
      icon = LucideIcons.smile;
    }

    return CountdownItem(
      id: json['id'],
      title: json['title'],
      target: DateTime.parse(json['target']),
      color: json['color'] != null ? Color(json['color']) : null,
      icon: icon,
      note: json['note'],
    );
  }

  CountdownItem copyWith({
    String? id,
    String? title,
    DateTime? target,
    Color? color,
    IconData? icon,
    String? note,
  }) {
    return CountdownItem(
      id: id ?? this.id,
      title: title ?? this.title,
      target: target ?? this.target,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      note: note ?? this.note,
    );
  }

  static const Map<String, IconData> _icons = {
    'smile': LucideIcons.smile,
    'heart': LucideIcons.heart,
    'star': LucideIcons.star,
    'sun': LucideIcons.sun,
    'moon': LucideIcons.moon,
    'bell': LucideIcons.bell,
    'cake': LucideIcons.cake,
    'gift': LucideIcons.gift,
    'partyPopper': LucideIcons.partyPopper,
    'plane': LucideIcons.plane,
    'car': LucideIcons.car,
    'home': LucideIcons.home,
    'briefcase': LucideIcons.briefcase,
    'book': LucideIcons.book,
    'camera': LucideIcons.camera,
    'music': LucideIcons.music,
    'film': LucideIcons.film,
    'gamepad': LucideIcons.gamepad,
    'pizza': LucideIcons.pizza,
    'trees': LucideIcons.trees,
    'flame': LucideIcons.flame,
    'coffee': LucideIcons.coffee,
    'package': LucideIcons.package,
    'shoppingCart': LucideIcons.shoppingCart,
    'clock': LucideIcons.clock,
    'mapPin': LucideIcons.mapPin,
    'wine': LucideIcons.wine,
    'bookmarkPlus': LucideIcons.bookmarkPlus,
  };

  static String _iconToString(IconData? icon) {
    if (icon == null) return 'smile';
    return _icons.entries
        .firstWhere(
          (e) => e.value.codePoint == icon.codePoint,
          orElse: () => const MapEntry('smile', LucideIcons.smile),
        )
        .key;
  }

  static IconData _stringToIcon(String? name) {
    if (name == null) return LucideIcons.smile;
    return _icons[name] ?? LucideIcons.smile;
  }
}

