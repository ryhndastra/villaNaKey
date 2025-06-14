import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:villanakey/auth/login_page.dart';
import 'package:villanakey/pages/payment_page.dart';
import 'package:villanakey/providers/user_provider.dart';
import 'package:villanakey/components/decorated_box_container.dart';

class Reservation extends StatefulWidget {
  const Reservation({super.key});

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
  List<DateTime> selectedDates = [];
  List<DateTime> bookedDates = [];

  int totalPrice = 0;
  final int pricePerDay = 1500000;

  @override
  void initState() {
    super.initState();
    _selectedDay = null;
    _focusedDay = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user == null) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
      } else {
        fetchBookedDates();
      }
    });
  }

  Future<void> fetchBookedDates() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('reservations').get();

    List<DateTime> dates = [];
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final status = data['status'];

      final checkInRaw = data['checkIn'];
      final checkOutRaw = data['checkOut'];

      if (checkInRaw != null &&
          checkOutRaw != null &&
          status == 'Pembayaran berhasil') {
        DateTime start;
        DateTime end;

        if (checkInRaw is Timestamp) {
          start = checkInRaw.toDate();
        } else if (checkInRaw is String) {
          start = DateTime.tryParse(checkInRaw) ?? DateTime.now();
        } else {
          continue;
        }

        if (checkOutRaw is Timestamp) {
          end = checkOutRaw.toDate();
        } else if (checkOutRaw is String) {
          end = DateTime.tryParse(checkOutRaw) ?? DateTime.now();
        } else {
          continue;
        }

        for (int i = 0; i <= end.difference(start).inDays; i++) {
          dates.add(start.add(Duration(days: i)));
        }
      }
    }

    setState(() {
      bookedDates = dates;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (bookedDates.any((d) => isSameDay(d, selectedDay))) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Tanggal tidak tersedia")));
      return;
    }

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
    if (start != null && end != null) {
      for (
        DateTime d = start;
        d.isBefore(end.add(Duration(days: 1)));
        d = d.add(Duration(days: 1))
      ) {
        if (bookedDates.any((bd) => isSameDay(bd, d))) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Beberapa tanggal dalam rentang sudah dibooking"),
            ),
          );
          return;
        }
      }
    }

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
    final DateTime? checkInDate = _rangeStart;
    final DateTime? checkOutDate = _rangeEnd;

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

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => PaymentPage(
                amountToPay: totalPrice,
                checkIn: checkInDate,
                checkOut: checkOutDate,
              ),
        ),
      );

      if (result == true) {
        fetchBookedDates();
      }
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

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBoxContainer(
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
            SizedBox(height: 25),

            // Calendar
            DecoratedBoxContainer(
              child: Column(
                children: [
                  TableCalendar(
                    locale: "en_US",
                    rowHeight: 40,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      headerPadding: EdgeInsets.zero,
                      headerMargin: EdgeInsets.only(bottom: 4),
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
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final isBooked = bookedDates.any(
                          (d) => isSameDay(d, day),
                        );
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isBooked ? Colors.red[300] : null,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: isBooked ? Colors.white : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            DecoratedBoxContainer(
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
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${user?.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "${user?.email}",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "${user?.phone}",
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
                              Text(
                                'Stay Duration: ${DateFormat('d MMMM yyyy').format(_rangeStart!)}'
                                ' - ${DateFormat('d MMMM yyyy').format(_rangeEnd!)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF42754C),
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                          ],
                        ),
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
                            color:
                                isDateSelected
                                    ? const Color(0xFF42754C)
                                    : Colors.black26,
                          ),
                        ),
                      ),

                      // Tombol Booking
                      ElevatedButton.icon(
                        onPressed:
                            isDateSelected ? showConfirmationReservation : null,
                        icon: const Icon(Icons.calendar_month_rounded),
                        label: const Text("Booking Sekarang"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF42754C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14.0,
                            horizontal: 20.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
