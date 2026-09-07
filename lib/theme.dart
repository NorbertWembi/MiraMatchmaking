import 'package:flutter/material.dart';

/// Colors tuned to your mockups
const kBrandRed = Color(0xFFE53935); // rich red for heart/progress/CTA
const kHeaderBlack = Colors.black;   // black app bar
const kMuted = Color(0xFF6B7280);    // gray-500-ish for helper text
const kBorder = Color(0xFFE5E7EB);   // gray-200 border
const kFieldBg = Colors.white;

final kFieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(16),
  borderSide: const BorderSide(color: kBorder, width: 1),
);

InputDecoration fieldDeco(String hint) => InputDecoration(
  hintText: hint,
  filled: true,
  fillColor: kFieldBg,
  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
  enabledBorder: kFieldBorder,
  focusedBorder: kFieldBorder.copyWith(
    borderSide: const BorderSide(color: kBrandRed, width: 1.2),
  ),
  disabledBorder: kFieldBorder,
);
