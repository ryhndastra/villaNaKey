import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:villanakey/providers/user_provider.dart';

class Reservation extends StatefulWidget {
  Reservation({super.key});

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  late DateTime _focusedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? _selectedDay;

  DateTime? selectedDate;
  DateTime? selectedRangeStart;
  DateTime? selectedRangeEnd;

  int totalPrice = 0;
  final int pricePerDay = 1500000;

  @override
  void initState() {
    super.initState();
    _selectedDay = null;
    _focusedDay = DateTime.now();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_rangeStart != null && _rangeEnd != null) {
        if ((isSameDay(selectedDay, _rangeStart) ||
                isSameDay(selectedDay, _rangeEnd)) &&
            isSameDay(selectedDay, _selectedDay)) {
          _rangeStart = null;
          _rangeEnd = null;
          _selectedDay = null;
        } else {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        }
      } else {
        if (isSameDay(_selectedDay, selectedDay)) {
          _selectedDay = null;
          totalPrice = 0;
        } else {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          totalPrice = pricePerDay;
        }
      }
    });
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _selectedDay = null;

      if (start != null && end == null) {
        _selectedDay = start;
        totalPrice = pricePerDay;
      } else if (start != null && end != null) {
        int days = end.difference(start).inDays;
        if (days < 1) days = 1;
        totalPrice = pricePerDay * days;
      } else {
        totalPrice = 0;
      }
    });
  }

  Future<void> showConfirmationReservation() async {
    String tanggalInfo = '';

    if (_selectedDay != null) {
      tanggalInfo =
          'Booking Date: ${DateFormat('d MMMM yyyy').format(_selectedDay!)}';
    } else if (_rangeStart != null && _rangeEnd != null) {
      tanggalInfo =
          'Stay Duration: ${DateFormat('d MMMM yyyy').format(_rangeStart!)} - ${DateFormat('d MMMM yyyy').format(_rangeEnd!)}';
    }

    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.payment_outlined, color: Color(0xFF42754C)),
              SizedBox(width: 10),
              Text(
                "Konfirmasi Booking",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tanggalInfo,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF42754C),
                ),
              ),
              if (totalPrice > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Total Price: Rp. ${NumberFormat('#,###', 'id_ID').format(totalPrice)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF42754C),
                    ),
                  ),
                ),

              const SizedBox(height: 10),
              const Text(
                "Cek kembali, apakah harga dan tanggal yang dipesan sudah sesuai?",
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.only(bottom: 12, right: 12),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Batal', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF42754C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (shouldProceed == true) {
      DateConfirmation();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reservasi Villa berhasil disimpan!'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pushNamed(context, '/payment');
    }
  }

  void DateConfirmation() {
    if (_selectedDay != null) {
      selectedDate = _selectedDay;
    } else if (_rangeStart != null && _rangeEnd != null) {
      selectedRangeStart = _rangeStart;
      selectedRangeEnd = _rangeEnd;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDateSelected =
        _rangeStart != null || _rangeEnd != null || _selectedDay != null;

    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Villa Na Key',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Rp. 1,500,000',
                              style: TextStyle(
                                color: Color(0xFF42754C),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: '/day',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),

                  // Location + Ratings star
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 3.0),
                          Text(
                            'Cihanjawar Bojong, Purwakarta',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Icon(Icons.star, color: Color(0xFFFFD400), size: 15),
                          Icon(Icons.star, color: Color(0xFFFFD400), size: 15),
                          Icon(Icons.star, color: Color(0xFFFFD400), size: 15),
                          Icon(Icons.star, color: Color(0xFFFFD400), size: 15),
                          Icon(
                            Icons.star_half,
                            color: Color(0xFFFFD400),
                            size: 15,
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            '4,8',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Calendar
            Container(
              padding: EdgeInsets.only(bottom: 20, left: 40, right: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TableCalendar(
                    locale: "en_US",
                    rowHeight: 40,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    availableGestures: AvailableGestures.all,
                    selectedDayPredicate: (day) {
                      if (_selectedDay == null) return false;
                      return isSameDay(day, _selectedDay);
                    },
                    daysOfWeekStyle: DaysOfWeekStyle(
                      dowTextFormatter:
                          (date, locale) =>
                              DateFormat.E(locale).format(date)[0],
                      weekendStyle: TextStyle(color: Colors.grey),
                      weekdayStyle: TextStyle(color: Colors.grey),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.green.shade200,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Color(0xFF42754C),
                        shape: BoxShape.circle,
                      ),
                      rangeStartDecoration: BoxDecoration(
                        color: Color(0xFF42754C),
                        shape: BoxShape.circle,
                      ),
                      rangeEndDecoration: BoxDecoration(
                        color: Color(0xFF42754C),
                        shape: BoxShape.circle,
                      ),
                      withinRangeDecoration: BoxDecoration(
                        color: Color(0xFFB5D2C1),
                        shape: BoxShape.circle,
                      ),
                      rangeHighlightColor: Color(0x5542754C),
                    ),

                    focusedDay: _focusedDay,
                    firstDay: DateTime.now(),
                    lastDay: DateTime(2030, 3, 14),
                    onDaySelected: _onDaySelected,
                    rangeStartDay: _rangeStart,
                    rangeEndDay: _rangeEnd,
                    rangeSelectionMode: RangeSelectionMode.toggledOn,
                    onRangeSelected: _onRangeSelected,
                    enabledDayPredicate: (day) {
                      if (_rangeStart != null) {
                        return !day.isBefore(_rangeStart!);
                      }
                      return true;
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Details",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/profile_circle.png',
                        color: Color(0xFF42754C),
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user.name}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "${user.email}",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "${user.phone}",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Price: Rp. ${NumberFormat('#,###', 'id_ID').format(totalPrice)}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 5),

                          // Tanggal Yang dipilih
                          if (_selectedDay != null &&
                              _rangeStart == null &&
                              _rangeEnd == null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Booking Date: ${DateFormat('d MMMM yyyy').format(_selectedDay!)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF42754C),
                                ),
                              ),
                            )
                          else if (_rangeStart != null && _rangeEnd != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Stay Duration: ${DateFormat('d MMMM yyyy').format(_rangeStart!)}'
                                ' - ${DateFormat('d MMMM yyyy').format(_rangeEnd!)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF42754C),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol X untuk reset tanggal
                      GestureDetector(
                        onTap:
                            isDateSelected
                                ? () {
                                  setState(() {
                                    _rangeStart = null;
                                    _rangeEnd = null;
                                    _selectedDay = null;
                                    totalPrice = 0;
                                  });
                                }
                                : null,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isDateSelected
                                      ? Color(0xFF42754C)
                                      : Colors.black12,
                              width: 2.5,
                            ),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 26,
                            color:
                                isDateSelected
                                    ? Color(0xFF42754C)
                                    : Colors.black12,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              isDateSelected
                                  ? () {
                                    showConfirmationReservation();
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isDateSelected
                                    ? Color(0xFF4B7752)
                                    : Colors.grey,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Booking Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
