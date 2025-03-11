import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final String attendanceId;

  const AttendanceCardWidget({
    super.key,
    required this.data,
    required this.attendanceId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  (data['name']?.isNotEmpty ?? false)
                      ? data['name'][0].toUpperCase()
                      : '?',
                  style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 24),
                ),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Name: ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        data['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Status: ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        data['description'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        'Date: ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        data['datetime'].toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Optional for better alignment
                    children: [
                      Text(
                        'Location: ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded( // Ensure location text properly fits within Row constraints
                        child: Text(
                          data['address'].toString(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black

                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
