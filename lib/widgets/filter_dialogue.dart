import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/blocs/movie_bloc.dart';
import 'package:movie_mania/models/genre/genre_model.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:movie_mania/widgets/gap.dart';
import 'package:sizer/sizer.dart';

// Filter dialogue
Future<void> filterDialogue({
  required BuildContext context,
}) async {
  var listOfGenreModel = context.read<MovieBloc>().state.listOfGenreModel;
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      final movieBloc = BlocProvider.of<MovieBloc>(context);
      return BlocProvider.value(
        value: movieBloc,
        child: FilterDialogue(
          optionsTitle: listOfGenreModel.first,
          optionsList: listOfGenreModel,
          selectedOption: listOfGenreModel.isNotEmpty ? listOfGenreModel.first : null,
          onApplyFilter: (String? selectedOption) {
            debugPrint('Selected option for the filter === $selectedOption');
            // Apply filter
            context.read<MovieBloc>().add(
                  ApplyFilterRequested(
                    filter: selectedOption ?? 'Horror',
                  ),
                );
          },
          onClearFilter: () {
            // Clear filter
            context.read<MovieBloc>().add(
                  const ApplyFilterRequested(filter: ''),
                );
          },
        ),
      );
    },
  );
}

// Filter dialogue
class FilterDialogue extends StatefulWidget {
  const FilterDialogue({
    super.key,
    required this.optionsTitle,
    required this.optionsList,
    required this.onApplyFilter,
    required this.selectedOption,
    required this.onClearFilter,
  });

  final GenreModel optionsTitle;
  final List<GenreModel> optionsList;
  final GenreModel? selectedOption;
  final void Function(String? selectedOption) onApplyFilter;
  final void Function() onClearFilter;

  @override
  State<FilterDialogue> createState() => _FilterDialogueState();
}

class _FilterDialogueState extends State<FilterDialogue> {
  String? selectedDropdownOption;

  @override
  void initState() {
    super.initState();
    selectedDropdownOption = widget.selectedOption?.name;
  }

  final alertBoxFilter = ImageFilter.blur(sigmaX: 10, sigmaY: 10);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: alertBoxFilter,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.sp),
        ),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(),
                  const CustomText(text: 'Select Genre'),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    margin: EdgeInsets.only(
                      top: 14.sp,
                      bottom: 14.sp,
                      right: 25.sp,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
                      border: Border.all(width: 0.5.sp),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton2(
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          icon: const Icon(Icons.arrow_drop_down),
                          dropdownWidth: 60.w,
                          buttonWidth: 62.w,
                          dropdownMaxHeight: 20.h,
                          offset: const Offset(-10, -12),
                          iconOnClick:
                              const Icon(Icons.keyboard_arrow_up_rounded),
                          underline: Container(),
                          isExpanded: true,
                          hint: CustomText(text: widget.optionsTitle.name),
                          value: selectedDropdownOption,
                          items: widget.optionsList.map((item) {
                            return DropdownMenuItem(
                              value: item.name,
                              child: Text(item.name.toString()),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            debugPrint('New selected value === ${newValue.toString()}');
                           setState(() => selectedDropdownOption = newValue);
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Call back for clear filter
                          widget.onClearFilter.call();
                          Navigator.of(context).pop();
                        },
                        child: const CustomText(text: 'Clear Filter'),
                      ),
                      const Gap(),
                      ElevatedButton(
                        onPressed: () {
                          // Call back for filter applied
                          widget.onApplyFilter.call(selectedDropdownOption);
                          Navigator.of(context).pop();
                        },
                        child: const CustomText(text: 'Apply'),
                      ),
                    ],
                  ),
                  const Gap(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
