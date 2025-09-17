import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  Future<Uint8List> generateInvoice({
    required String name,
    required String address,
    required String whatsapp,
    required String bookedOn,
    required String treatmentDate,
    required String treatmentTime,
    required List<Map<String, dynamic>> treatments,
    required double total,
    required double discount,
    required double advance,
    required double balance,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          // Header
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("KUMARAKOM",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text("GST No: 32AABCU9603R1ZW"),
            ],
          ),
          pw.SizedBox(height: 10),

          // Patient Details
          pw.Text("Patient Details",
              style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green)),
          pw.SizedBox(height: 5),
          pw.Text("Name: $name"),
          pw.Text("Address: $address"),
          pw.Text("WhatsApp: $whatsapp"),
          pw.SizedBox(height: 10),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Booked On: $bookedOn"),
              pw.Text("Treatment Date: $treatmentDate"),
              pw.Text("Treatment Time: $treatmentTime"),
            ],
          ),
          pw.SizedBox(height: 20),

          // Treatments Table
          pw.Table.fromTextArray(
            headers: ["Treatment", "Price", "Male", "Female", "Total"],
            data: treatments.map((t) {
              return [
                t["name"],
                "₹${t["price"]}",
                "${t["male"]}",
                "${t["female"]}",
                "₹${t["total"]}"
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 20),

          // Amount Section
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Total Amount: ₹$total",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Discount: ₹$discount"),
                  pw.Text("Advance: ₹$advance"),
                  pw.Text("Balance: ₹$balance",
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 40),

          // pw.Center(
          //     child: pw.Text("Thank you for choosing us",
          //         style: pw.TextStyle(
          //             color: PdfColors.green,
          //             fontSize: 16,
          //             fontWeight: pw.FontWeight.bold))),
        ],
      ),
    );

    return pdf.save();
  }

  Future<void> previewPdf(Uint8List pdfData) async {
    await Printing.layoutPdf(onLayout: (_) async => pdfData);
  }
}