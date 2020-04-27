import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class Particles extends StatefulWidget {
  final int numberOfParticles;

  Particles(this.numberOfParticles);

  @override
  _ParticlesState createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles> {
  final Random randomSize = Random();

  final List<ParticleModel> particles = [];

  @override
  void initState() {
    List.generate(widget.numberOfParticles, (index) {
      particles.add(ParticleModel(randomSize, Random().nextInt(50) + 10));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Rendering(
      builder: (context, time) {
        _simulateParticles(time);
        return CustomPaint(
          painter: ParticlePainter(particles, time),
        );
      },
    );
  }

  _simulateParticles(Duration time) {
    particles.forEach((particle) => particle.maintainRestart(time));
  }
}

class ParticleModel {
  Animatable tween;
  double size;
  int randomAlphaColor;
  AnimationProgress animationProgress;
  Random randomSize;

  ParticleModel(this.randomSize, this.randomAlphaColor) {
    restart();
  }

  restart({Duration time = Duration.zero}) {
    final startPosition = Offset(-0.2 + 1.4 * randomSize.nextDouble(), 1.2);
    final endPosition = Offset(-0.2 + 1.4 * randomSize.nextDouble(), -0.2);
    final duration =
        Duration(milliseconds: 500 + (randomSize.nextInt(5000) + 3000));

    tween = MultiTrackTween([
      Track("x").add(
          duration, Tween(begin: startPosition.dx, end: endPosition.dx),
          curve: Curves.easeInOutSine),
      Track("y").add(
          duration, Tween(begin: startPosition.dy, end: endPosition.dy),
          curve: Curves.easeIn),
    ]);
    animationProgress = AnimationProgress(duration: duration, startTime: time);
    size = 0.2 + randomSize.nextDouble() * 0.4;
  }

  maintainRestart(Duration time) {
    if (animationProgress.progress(time) == 1.0) {
      restart(time: time);
    }
  }
}

class ParticlePainter extends CustomPainter {
  List<ParticleModel> particles;
  Duration time;

  ParticlePainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size) {
//    final paint = Paint()..color = Colors.pink.withAlpha(50);

    particles.forEach((particle) {
      var progress = particle.animationProgress.progress(time);
      final animation = particle.tween.transform(progress);
      //    final paint = Paint()..color = Colors.pink.withAlpha(50);
//      print('== ${particle.randomAlphaColor}');

      final position =
          Offset(animation["x"] * size.width, animation["y"] * size.height);
//      canvas.drawCircle(position, size.width * 0.2 * particle.size, paint);
      canvas.drawCircle(position, size.width * 0.2 * particle.size,
          Paint()..color = Colors.pink.withAlpha(particle.randomAlphaColor));
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
