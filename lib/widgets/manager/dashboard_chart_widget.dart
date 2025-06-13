import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

enum ChartType { events, awards }

class DashboardChartWidget extends StatelessWidget {
  final String title;
  final ChartType chartType;
  final Color color;
  final List<int>? data;

  const DashboardChartWidget({
    super.key,
    required this.title,
    required this.chartType,
    required this.color,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: const Icon(
                  Icons.bar_chart,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          // Legend
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                chartType == ChartType.events 
                    ? 'Sự kiện toàn trường'
                    : 'Giải thưởng toàn trường',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          // Chart Area
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: LineChartPainter(
                color: color,
                chartType: chartType,
                data: data,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final Color color;
  final ChartType chartType;
  final List<int>? data;

  LineChartPainter({
    required this.color,
    required this.chartType,
    this.data,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    // Draw grid lines
    _drawGrid(canvas, size, gridPaint);

    // Draw chart line
    _drawChartLine(canvas, size, paint);

    // Draw data points
    _drawDataPoints(canvas, size, paint);

    // Draw labels
    _drawLabels(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size, Paint gridPaint) {
    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Vertical grid lines
    for (int i = 0; i <= 12; i++) {
      final x = size.width * i / 12;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }
  }

  void _drawChartLine(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final dataPoints = _getDataPoints(chartType);
    
    if (dataPoints.isEmpty) return;

    // Move to first point
    final firstPoint = _getPointPosition(0, dataPoints[0], size);
    path.moveTo(firstPoint.dx, firstPoint.dy);

    // Draw lines to other points
    for (int i = 1; i < dataPoints.length; i++) {
      final point = _getPointPosition(i, dataPoints[i], size);
      path.lineTo(point.dx, point.dy);
    }

    canvas.drawPath(path, paint);
  }

  void _drawDataPoints(Canvas canvas, Size size, Paint paint) {
    final dataPoints = _getDataPoints(chartType);
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < dataPoints.length; i++) {
      final point = _getPointPosition(i, dataPoints[i], size);
      canvas.drawCircle(point, 4, pointPaint);
      
      // Draw white border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(point, 4, borderPaint);
    }
  }

  void _drawLabels(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 10,
    );

    // X-axis labels (months)
    final months = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];
    for (int i = 0; i < months.length; i++) {
      final x = size.width * i / 11;
      final textPainter = TextPainter(
        text: TextSpan(text: months[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height + 5),
      );
    }

    // Y-axis labels - now using integer values
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (4 - i) / 4;
      final maxValue = chartType == ChartType.events ? 10 : 5; // Sự kiện: max 10, Giải thưởng: max 5
      final value = (i * maxValue / 4).round().toString();
      final textPainter = TextPainter(
        text: TextSpan(text: value, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width - 5, y - textPainter.height / 2),
      );
    }
  }

  List<double> _getDataPoints(ChartType type) {
    if (type == ChartType.events) {
      // Sample data for events
      final List<int> rawData = [1, 2, 2, 3, 3, 4, 4, 6, 8, 10, 7, 3]; // Số sự kiện theo tháng
      return rawData.map((e) => e / 10).toList(); // Chuyển thành tỷ lệ trên thang điểm 0-1
    } else {
      // Sample data for awards
      final List<int> rawData = [0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 3]; // Số giải thưởng theo tháng
      return rawData.map((e) => e / 5).toList(); // Chuyển thành tỷ lệ trên thang điểm 0-1
    }
  }

  Offset _getPointPosition(int index, double value, Size size) {
    final x = size.width * index / 11; // 12 months, 11 intervals
    final y = size.height * (1 - value); // Invert Y axis
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}