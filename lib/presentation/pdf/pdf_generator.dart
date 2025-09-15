import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

import '../../domain/entities/experience.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/stop.dart';
import '../../domain/entities/travel.dart';
import '../../util/date_utils.dart';

String _encodePolyline(List<List<double>> latLngs, {int precision = 5}) {
  int encodeValue(int v) {
    v = v < 0 ? ~(v << 1) : (v << 1);
    final out = StringBuffer();
    while (v >= 0x20) {
      out.writeCharCode((0x20 | (v & 0x1f)) + 63);
      v >>= 5;
    }
    out.writeCharCode(v + 63);
    return 0;
  }

  final factor = math.pow(10, precision);
  var lastLat = 0, lastLng = 0;
  final out = StringBuffer();

  for (final p in latLngs) {
    final lat = (p[0] * factor).round();
    final lng = (p[1] * factor).round();
    encodeValue(lat - lastLat);
    encodeValue(lng - lastLng);
    lastLat = lat;
    lastLng = lng;
  }
  return out.toString();
}

Future<pdf.ImageProvider?> _fetchGoogleStaticMapFromTravel({
  required String apiKey,
  required Travel travel,
  required List<Stop> stops,
  int width = 900,
  int height = 600,
  bool debugDumpFile = false,
}) async {
  try {
    final orderedStops = [...stops]..sort((a, b) => a.order.compareTo(b.order));

    final points = <List<double>>[
      [travel.originPlace.latitude, travel.originPlace.longitude],
      ...orderedStops.map((s) => [s.place.latitude, s.place.longitude]),
      [travel.destinationPlace.latitude, travel.destinationPlace.longitude],
    ];

    final markers = <String>[];

    final o = points.first;
    markers.add('markers=color:green|label:O|${o[0]},${o[1]}');

    final d = points.last;
    markers.add('markers=color:red|label:D|${d[0]},${d[1]}');

    for (var i = 0; i < orderedStops.length; i++) {
      final s = orderedStops[i];
      final lat = s.place.latitude;
      final lng = s.place.longitude;
      final idx = i + 1;

      if (idx <= 9) {
        markers.add('markers=color:blue|label:$idx|$lat,$lng');
      } else {
        markers.add('markers=color:blue|$lat,$lng');
      }
    }

    // Polyline
    String pathFrom(List<List<double>> pts) {
      final enc = _encodePolyline(pts);
      return 'path=weight:5|color:0x285A98B3|enc:$enc';
    }

    var path = pathFrom(points);

    final params = <String>[
      'size=${width}x$height',
      'scale=2',
      'maptype=roadmap',
      'format=png',
      'language=pt-BR',
      ...markers,
      path,
      'key=$apiKey',
    ];

    var url =
        'https://maps.googleapis.com/maps/api/staticmap?${params.join('&')}';
    print(url);

    final resp = await http.get(Uri.parse(url));

    if (resp.statusCode != 200) {
      return null;
    }

    final bytes = resp.bodyBytes;

    bool looksPng(Uint8List b) =>
        b.length >= 8 &&
        b[0] == 0x89 &&
        b[1] == 0x50 &&
        b[2] == 0x4E &&
        b[3] == 0x47 &&
        b[4] == 0x0D &&
        b[5] == 0x0A &&
        b[6] == 0x1A &&
        b[7] == 0x0A;
    bool looksJpeg(Uint8List b) =>
        b.length >= 4 &&
        b[0] == 0xFF &&
        b[1] == 0xD8 &&
        b[b.length - 2] == 0xFF &&
        b[b.length - 1] == 0xD9;

    if (!(looksPng(bytes) || looksJpeg(bytes))) {}

    if (debugDumpFile) {
      final file = File('/storage/emulated/0/Download/static_map_debug.png');
      await file.writeAsBytes(bytes, flush: true);
    }

    return pdf.MemoryImage(bytes);
  } catch (e) {
    return null;
  }
}

Future<pdf.ImageProvider?> _memoryImageFromFile(File? file) async {
  if (file == null) return null;
  try {
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) return null;
    return pdf.MemoryImage(bytes);
  } catch (_) {
    return null;
  }
}


Future<void> _addStopPages({
  required pdf.Document doc,
  required List<Stop> stops,
  required List<Experience> experiences,
}) async {
  final ordered = [...stops]..sort((a, b) => a.order.compareTo(b.order));
  final dateFormat = DateFormat('dd MMM yyyy', 'pt_BR');

  for (final stop in ordered) {
    final stopExperiences = experiences.where((exp) => exp.stopId == stop.id).toList();

    // ✅ Pré-carrega as fotos de TODAS as experiências desta parada
    final expViews = <pdf.Widget>[];
    for (final exp in stopExperiences) {
      final imgs = <pdf.ImageProvider>[];
      for (final f in [exp.photo1, exp.photo2, exp.photo3]) {
        final prov = await _memoryImageFromFile(f); // ← File -> MemoryImage
        if (prov != null) imgs.add(prov);
      }

      expViews.add(
        pdf.Container(
          margin: const pdf.EdgeInsets.only(bottom: 8),
          padding: const pdf.EdgeInsets.all(8),
          decoration: pdf.BoxDecoration(
            border: pdf.Border.all(color: PdfColors.blueGrey),
            borderRadius: pdf.BorderRadius.circular(5),
          ),
          child: pdf.Column(
            crossAxisAlignment: pdf.CrossAxisAlignment.start,
            children: [
              pdf.Text('Relato:', style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold)),
              pdf.Text(exp.description),
              if (imgs.isNotEmpty) ...[
                pdf.SizedBox(height: 8),
                pdf.Text('Fotos:', style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold)),
                pdf.SizedBox(height: 4),
                pdf.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: imgs
                      .map((p) => pdf.Image(p, width: 100, height: 100, fit: pdf.BoxFit.cover))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // 🔒 Agora montamos a página — sem async dentro do build
    doc.addPage(
      pdf.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pdf.EdgeInsets.fromLTRB(24, 32, 24, 32),
        build: (_) {
          return pdf.Column(
            crossAxisAlignment: pdf.CrossAxisAlignment.start,
            children: [
              pdf.Text(
                'Parada ${stop.order}: ${stop.label}',
                style: pdf.TextStyle(
                  fontSize: 20, fontWeight: pdf.FontWeight.bold, color: PdfColors.blue,
                ),
              ),
              pdf.SizedBox(height: 8),
              pdf.Text(
                'Coordenadas: ${stop.place.latitude.toStringAsFixed(5)}, '
                    '${stop.place.longitude.toStringAsFixed(5)}',
                style: const pdf.TextStyle(fontSize: 12),
              ),
              if (stop.startDate != null && stop.endDate != null) ...[
                pdf.SizedBox(height: 12),
                pdf.Container(
                  padding: const pdf.EdgeInsets.all(12),
                  decoration: pdf.BoxDecoration(
                    gradient: pdf.LinearGradient(
                      begin: pdf.Alignment.topCenter,
                      end: pdf.Alignment.bottomCenter,
                      colors: [PdfColors.lightBlue, PdfColors.blue],
                    ),
                    borderRadius: pdf.BorderRadius.circular(10),
                  ),
                  child: pdf.Column(
                    crossAxisAlignment: pdf.CrossAxisAlignment.start,
                    children: [
                      pdf.Text(
                        'Informações da Parada',
                        style: pdf.TextStyle(
                          fontSize: 14, fontWeight: pdf.FontWeight.bold, color: PdfColors.white,
                        ),
                      ),
                      pdf.SizedBox(height: 6),
                      pdf.Text(
                        'Nome: ${stop.label}\n'
                            'Período: ${dateFormat.format(stop.startDate!)} - '
                            '${dateFormat.format(stop.endDate!)}',
                        style: pdf.TextStyle(fontSize: 12, color: PdfColors.white),
                      ),
                    ],
                  ),
                ),
              ],
              pdf.SizedBox(height: 12),
              pdf.Text(
                'Experiências da Parada',
                style: pdf.TextStyle(
                  fontSize: 16, fontWeight: pdf.FontWeight.bold, color: PdfColors.blue,
                ),
              ),
              pdf.SizedBox(height: 8),
              ...expViews, // ← usa as views com imagens já carregadas
            ],
          );
        },
      ),
    );
  }
}


/// Generates a PDF cover for a trip.
Future<Uint8List> generateTripCoverPdf({
  required Travel travel,
  required List<Participant> participants,
  required List<Stop> stops,
  required List<Experience> experiences,
  required String mapsApiKey,
}) async {
  final doc = pdf.Document();

  // Pre-load assets to avoid using await inside build callbacks
  final logoHorizoneImage = pdf.MemoryImage(
    (await rootBundle.load('assets/images/logo_horizone.png'))
        .buffer
        .asUint8List(),
  );

  final image = pdf.MemoryImage(
    (await rootBundle.load(
      'assets/images/airplane_icon.png',
    )).buffer.asUint8List(),
  );

  DateTime parseTravelDate(String stringDate) {
    final parsedDate = tryParseTravelDate(stringDate);
    if (parsedDate == null) {
      throw FormatException(
        'Invalid date: "$stringDate" (expected format $travelDatePattern)',
      );
    }
    return parsedDate;
  }

  String period(String startStr, String endStr) {
    final dateFormat = DateFormat('dd MMM yyyy', 'pt_BR');
    final start = parseTravelDate(startStr);
    final end = parseTravelDate(endStr);
    return '${dateFormat.format(start)} - ${dateFormat.format(end)}';
  }

  final defaultAvatar = pdf.MemoryImage(
    (await rootBundle.load(
      'assets/images/user_default_photo.png',
    )).buffer.asUint8List(),
  );

  ///
  final participantAvatars = await Future.wait(
    participants.map((p) async {
      try {
        if (p.photo != null) {
          final bytes = await (p.photo!).readAsBytes();
          if (bytes.isNotEmpty) {
            return pdf.MemoryImage(bytes);
          }
        }
      } catch (_) {}
      return defaultAvatar;
    }).toList(),
  );

  final periodText = period(travel.startDate, travel.endDate);
  final durationDays =
      parseTravelDate(
        travel.endDate,
      ).difference(parseTravelDate(travel.startDate)).inDays +
      1;

  doc.addPage(
    pdf.Page(
      pageFormat: PdfPageFormat.a5,
      margin: pdf.EdgeInsets.zero,
      build: (ctx) {
        return pdf.Stack(
          children: [
            pdf.Positioned(
              bottom: -40,
              left: -50,
              child: pdf.Image(image, width: 300, height: 300),
            ),
            pdf.Padding(
              padding: const pdf.EdgeInsets.all(32),
              child: pdf.Column(
                crossAxisAlignment: pdf.CrossAxisAlignment.start,
                children: [
                  pdf.SizedBox(height: 24),
                  pdf.Text(
                    travel.title,
                    style: pdf.TextStyle(
                      fontSize: 36,
                      fontWeight: pdf.FontWeight.bold,
                      color: PdfColors.blue,
                    ),
                  ),
                  pdf.SizedBox(height: 24),
                  pdf.Container(
                    padding: const pdf.EdgeInsets.all(16),
                    decoration: pdf.BoxDecoration(
                      gradient: pdf.LinearGradient(
                        begin: pdf.Alignment.topCenter,
                        end: pdf.Alignment.bottomCenter,
                        colors: [PdfColors.lightBlue, PdfColors.blue],
                      ),
                      borderRadius: pdf.BorderRadius.circular(10),
                    ),
                    child: pdf.Column(
                      crossAxisAlignment: pdf.CrossAxisAlignment.start,
                      children: [
                        pdf.Text(
                          periodText,
                          style: pdf.TextStyle(
                            fontSize: 14,
                            color: PdfColors.white,
                            fontWeight: pdf.FontWeight.bold,
                          ),
                        ),
                        pdf.SizedBox(height: 8),
                        pdf.Text(
                          '$durationDays dia${durationDays > 1 ? 's' : ''}'
                          ' de viagem',
                          style: pdf.TextStyle(
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                        pdf.SizedBox(height: 8),
                        pdf.Text(
                          'Meio de transporte: ${travel.meansOfTransportation}',
                          style: pdf.TextStyle(
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pdf.Spacer(),
                  pdf.Row(
                    mainAxisAlignment: pdf.MainAxisAlignment.end,
                    children: [
                      pdf.Container(
                        padding: const pdf.EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: pdf.BoxDecoration(
                          gradient: pdf.LinearGradient(
                            begin: pdf.Alignment.topCenter,
                            end: pdf.Alignment.bottomCenter,
                            colors: [PdfColors.lightBlue, PdfColors.blue],
                          ),
                          borderRadius: pdf.BorderRadius.circular(12),
                        ),
                        child: pdf.Text(
                          'Horizone Company',
                          style: pdf.TextStyle(
                            fontSize: 10,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  /// Page 2
  doc.addPage(
    pdf.MultiPage(
      pageFormat: PdfPageFormat.a5,
      margin: const pdf.EdgeInsets.fromLTRB(24, 32, 24, 32),
      build: (ctx) {
        pdf.Widget participantTile({
          required String name,
          required String email,
          required pdf.ImageProvider avatar,
        }) {
          const avatarSize = 56.0;
          final avatarWidget = pdf.ClipOval(
            child: pdf.Image(
              avatar,
              width: avatarSize,
              height: avatarSize,
              fit: pdf.BoxFit.cover,
            ),
          );

          return pdf.Container(
            width: 112,
            padding: const pdf.EdgeInsets.all(8),
            decoration: pdf.BoxDecoration(
              color: PdfColors.blue,
              borderRadius: pdf.BorderRadius.circular(10),
            ),
            child: pdf.Column(
              mainAxisSize: pdf.MainAxisSize.min,
              crossAxisAlignment: pdf.CrossAxisAlignment.center,
              children: [
                avatarWidget,
                pdf.SizedBox(height: 6),
                pdf.Text(
                  name,
                  textAlign: pdf.TextAlign.center,
                  style: pdf.TextStyle(
                    fontSize: 11,
                    fontWeight: pdf.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                  maxLines: 2,
                ),
                pdf.SizedBox(height: 3),
                pdf.Text(
                  email,
                  textAlign: pdf.TextAlign.center,
                  style: pdf.TextStyle(fontSize: 9, color: PdfColors.white),
                  maxLines: 1,
                ),
              ],
            ),
          );
        }

        final tiles = <pdf.Widget>[];
        for (var i = 0; i < participants.length; i++) {
          final participant = participants[i];
          final avatar = participantAvatars[i];
          tiles.add(
            participantTile(
              name: participant.name,
              email: participant.email,
              avatar: avatar,
            ),
          );
        }

        return [
          pdf.Text(
            'Participantes da Viagem',
            style: pdf.TextStyle(
              fontSize: 20,
              fontWeight: pdf.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
          pdf.SizedBox(height: 12),

          pdf.Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: pdf.WrapAlignment.start,
            children: tiles,
          ),
        ];
      },
    ),
  );

  try {
    final mapImage = await _fetchGoogleStaticMapFromTravel(
      apiKey: mapsApiKey,
      travel: travel,
      stops: stops,
      width: 900,
      height: 600,
      debugDumpFile: false,
    );

    doc.addPage(
      pdf.Page(
        pageFormat: PdfPageFormat.a5,
        build: (_) {
          if (mapImage == null) {
            return pdf.Container(
              padding: const pdf.EdgeInsets.all(12),
              decoration: pdf.BoxDecoration(color: PdfColors.grey200),
              child: pdf.Text(
                'Não foi possível carregar o mapa estático.\n'
                'Veja logs no console e o '
                'arquivo static_map_debug.png (se salvo).',
                style: const pdf.TextStyle(fontSize: 12),
              ),
            );
          }

          return pdf.Column(
            crossAxisAlignment: pdf.CrossAxisAlignment.start,
            children: [
              pdf.Text(
                'Mapa da Viagem',
                style: pdf.TextStyle(
                  fontSize: 20,
                  fontWeight: pdf.FontWeight.bold,
                  color: PdfColors.blue,
                ),
              ),
              pdf.SizedBox(height: 12),
              pdf.Image(mapImage, fit: pdf.BoxFit.contain),
              pdf.SizedBox(height: 12),
              pdf.Container(
                padding: const pdf.EdgeInsets.all(16),
                decoration: pdf.BoxDecoration(
                  gradient: pdf.LinearGradient(
                    begin: pdf.Alignment.topCenter,
                    end: pdf.Alignment.bottomCenter,
                    colors: [PdfColors.lightBlue, PdfColors.blue],
                  ),
                  borderRadius: pdf.BorderRadius.circular(10),
                ),
                child: pdf.Column(
                  crossAxisAlignment: pdf.CrossAxisAlignment.start,
                  children: [
                    pdf.Text(
                      'Local de Origem: ${travel.originLabel}',
                      style: pdf.TextStyle(
                        fontSize: 12,
                        color: PdfColors.white,
                      ),
                    ),
                    pdf.SizedBox(height: 8),
                    pdf.Text(
                      'Local de Destino: ${travel.destinationLabel}',
                      style: pdf.TextStyle(
                        fontSize: 12,
                        color: PdfColors.white,
                      ),
                    ),
                    pdf.SizedBox(height: 8),
                    pdf.Text(
                      'Paradas:',
                      style: pdf.TextStyle(
                        fontSize: 12,
                        color: PdfColors.white,
                      ),
                    ),
                    ...() {
                      final orderedStops = [...stops]
                        ..sort((a, b) => a.order.compareTo(b.order));
                      return orderedStops.map(
                        (stop) => pdf.Text(
                          '${stop.order}. ${stop.label}',
                          style: pdf.TextStyle(
                            fontSize: 12,
                            color: PdfColors.white,
                          ),
                        ),
                      );
                    }(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  } catch (e) {
    doc.addPage(
      pdf.MultiPage(
        pageFormat: PdfPageFormat.a5,
        margin: const pdf.EdgeInsets.fromLTRB(24, 32, 24, 32),
        build: (_) => [
          pdf.Text(
            'Mapa da Viagem',
            style: pdf.TextStyle(
              fontSize: 20,
              fontWeight: pdf.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
          pdf.SizedBox(height: 12),
          pdf.Container(
            padding: const pdf.EdgeInsets.all(12),
            decoration: pdf.BoxDecoration(
              color: PdfColors.grey200,
              borderRadius: pdf.BorderRadius.circular(8),
            ),
            child: pdf.Text(
              'Não foi possível carregar o mapa estático. '
              'Confira a MAPS_API_KEY e a conexão.',
              style: const pdf.TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  await _addStopPages(doc: doc, stops: stops, experiences: experiences);

  const closingMessage =
      'UMA VIAGEM NÃO SE MEDE EM MILHAS, MAS EM MOMENTOS.\n'
      'CADA PÁGINA DESTE LIVRETO GUARDA MAIS DO QUE PAISAGENS: '
      'SÃO SORRISOS ESPONTÂNEOS, DESCOBERTAS INESPERADAS, '
      'CONVERSAS QUE FICARAM '
      'NA ALMA E SILÊNCIOS QUE FALARAM MAIS QUE PALAVRAS.';

  doc.addPage(
    pdf.Page(
      pageFormat: PdfPageFormat.a5,
      margin: const pdf.EdgeInsets.fromLTRB(24, 32, 24, 32),
      build: (_) => pdf.Center(
        child: pdf.Column(
          mainAxisAlignment: pdf.MainAxisAlignment.center,
          crossAxisAlignment: pdf.CrossAxisAlignment.center,
          children: [
            pdf.Container(
              padding: const pdf.EdgeInsets.all(16),
              decoration: pdf.BoxDecoration(
                color: PdfColors.blue,
                borderRadius: pdf.BorderRadius.circular(15),
              ),
              child: pdf.Image(logoHorizoneImage,
                width: 250,
              ),
            ),
            pdf.SizedBox(height: 20),
            pdf.Text(
              closingMessage,
              textAlign: pdf.TextAlign.center,
              style: pdf.TextStyle(
                fontSize: 12,
                fontStyle: pdf.FontStyle.italic,
                color: PdfColors.blueGrey800,
                lineSpacing: 2,
              ),
            ),
            pdf.SizedBox(height: 32),
            pdf.Align(
              alignment: pdf.Alignment.centerRight,
              child: pdf.Text(
                '- Horizone Company',
                style: pdf.TextStyle(
                  fontSize: 12,
                  fontWeight: pdf.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  return doc.save();
}
