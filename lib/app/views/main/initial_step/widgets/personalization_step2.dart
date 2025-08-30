import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';
import 'package:qr_code_inventory/app/views/main/initial_step/controllers/initial_controller.dart';

class PersonalizationStep2 extends StatelessWidget {
  PersonalizationStep2({super.key});

  // Use lazy getter to access controller when it's needed, not during initialization
  InitialController get _controller => Get.find<InitialController>();

  // Method to show year/month picker dialog
  void _showYearMonthPicker(BuildContext context) {
    final DateTime currentMonth = _controller.focusedDay.value;
    int selectedYear = currentMonth.year;
    int selectedMonth = currentMonth.month;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Year and Month'),
          content: Container(
            width: double.maxFinite,
            height: 300.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Year selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Year:', style: TextStyle(fontWeight: FontWeight.bold)),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return DropdownButton<int>(
                          value: selectedYear,
                          items: List.generate(10, (index) => DateTime.now().year + index - 5)
                              .map((int year) {
                            return DropdownMenuItem<int>(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }).toList(),
                          onChanged: (int? value) {
                            if (value != null) {
                              setState(() {
                                selectedYear = value;
                              });
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Month grid
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.0,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          final month = index + 1; // 1-indexed month
                          return GestureDetector(
                            onTap: () {
                              _controller.focusedDay.value = DateTime(selectedYear, month, 1);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: month == selectedMonth ? AppColors.accent : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: month == selectedMonth ? AppColors.accent : AppColors.textFieldBorder,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                DateFormat('MMM').format(DateTime(selectedYear, month)),
                                style: TextStyle(
                                  color: month == selectedMonth ? Colors.white : AppColors.primaryText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What’s your date of birth?',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
        ),
        SizedBox(height: 20.h),
        Obx(() => _buildCustomCalendar(context)),
      ],
    );
  }
  
  Widget _buildCustomCalendar(BuildContext context) {
    final DateTime currentMonth = _controller.focusedDay.value;
    final DateTime selectedDate = _controller.selectedDay.value ?? DateTime.now();
    
    return Column(
      children: [
        // Month header with navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Month and year display
            Row(
              children: [
                InkWell(
                  onTap: () => _showYearMonthPicker(context),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(currentMonth),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: AppColors.primaryText),
                    ],
                  ),
                ),
              ],
            ),
            // Navigation arrows
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: AppColors.primaryText),
                  onPressed: () {
                    _controller.focusedDay.value = DateTime(
                      currentMonth.year,
                      currentMonth.month - 1,
                      1,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: AppColors.primaryText),
                  onPressed: () {
                    _controller.focusedDay.value = DateTime(
                      currentMonth.year,
                      currentMonth.month + 1,
                      1,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 15.h),
        
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Mo', 'Tu', 'Wed', 'Th', 'Fr', 'Sa', 'Su'].map((day) => 
            SizedBox(
              width: 30.w,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: day == 'Th' || day == 'Sa' || day == 'Su' ? AppColors.accent : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ).toList(),
        ),
        SizedBox(height: 15.h),
        
        // Calendar grid
        ...buildCalendarDays(currentMonth, selectedDate),
      ],
    );
  }
  
  List<Widget> buildCalendarDays(DateTime currentMonth, DateTime selectedDate) {
    // Get the first day of the month
    final DateTime firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    
    // Calculate the number of days in the month
    final int daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    
    // Calculate the day of week for the first day (0 = Monday, 6 = Sunday in our format)
    int firstWeekday = firstDayOfMonth.weekday - 1; // Adjust to make Monday = 0
    if (firstWeekday == -1) firstWeekday = 6; // Sunday becomes 6
    
    // Calculate total number of slots needed (days + empty slots for alignment)
    final List<Widget> rows = [];
    int dayCounter = 1;
    
    // Build weeks as rows
    while (dayCounter <= daysInMonth) {
      final List<Widget> rowChildren = [];
      
      for (int i = 0; i < 7; i++) {
        if ((dayCounter == 1 && i < firstWeekday) || dayCounter > daysInMonth) {
          // Empty slot for alignment
          rowChildren.add(SizedBox(width: 30.w));
        } else {
          final DateTime currentDate = DateTime(currentMonth.year, currentMonth.month, dayCounter);
          final bool isSelected = currentDate.year == selectedDate.year &&
              currentDate.month == selectedDate.month &&
              currentDate.day == selectedDate.day;
          
          rowChildren.add(
            GestureDetector(
              onTap: () {
                _controller.selectedDay.value = currentDate;
                _controller.focusedDay.value = currentDate;
              },
              child: Container(
                width: 30.w,
                height: 30.w,
                alignment: Alignment.center,
                decoration: isSelected ? BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ) : null,
                child: Text(
                  dayCounter.toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : AppColors.primaryText,
                  ),
                ),
              ),
            ),
          );
          dayCounter++;
        }
      }
      
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: rowChildren,
          ),
        ),
      );
    }
    
    return rows;
  }
}
