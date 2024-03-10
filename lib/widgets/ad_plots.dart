import 'package:flutter/material.dart';

class AdPlotSmall extends StatelessWidget {
  const AdPlotSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.indigo[300],
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Center(
          child: Text(
            'Advertisement Plot',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class AdPlotMedium extends StatelessWidget {
  const AdPlotMedium({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.indigo[300], borderRadius: BorderRadius.circular(6)),
        child: const Center(
          child: Text(
            'Advertisement Plot',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
