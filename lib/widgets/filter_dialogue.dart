import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_mania/blocs/movie_bloc.dart';
import 'package:movie_mania/constants/enums.dart';
import 'package:movie_mania/widgets/custom_text.dart';
import 'package:movie_mania/widgets/gap.dart';
import 'package:sizer/sizer.dart';

Future<void> filterDialogue({
  required BuildContext context,
}) async {
  var tabStatus = context.read<MovieBloc>().state.tabBarStatus.name;
  List<int> genreIds = [];
  if (tabStatus == TabBarStatus.popular.name) {
    genreIds = context.read<MovieBloc>().state.genreIdsForPopular;
  } else if (tabStatus == TabBarStatus.topRated.name) {
    genreIds = context.read<MovieBloc>().state.genreIdsForTopRated;
  } else {
    genreIds = context.read<MovieBloc>().state.genreIdsForUpComing;
  }
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      final movieBloc = BlocProvider.of<MovieBloc>(context);
      debugPrint('Genre Ids Length === ${genreIds.length}');
      return BlocProvider.value(
        value: movieBloc,
        child: FilterDialogue(
          optionsTitle: 'Genre List',
          optionsList: genreIds,
          selectedOption: genreIds.isNotEmpty ? genreIds[0].toString() : null,
          onApplyFilter: (String? selectedOption) {
            context.read<MovieBloc>().add(
                  ApplyFilterRequested(
                    filter: selectedOption.toString(),
                  ),
                );
          },
          onClearFilter: () {
            context.read<MovieBloc>().add(
                  const ApplyFilterRequested(filter: ''),
                );
          },
        ),
      );
    },
  );
}

class FilterDialogue extends StatefulWidget {
  const FilterDialogue({
    super.key,
    required this.optionsTitle,
    required this.optionsList,
    required this.onApplyFilter,
    required this.selectedOption,
    required this.onClearFilter,
  });

  final String optionsTitle;
  final List<int> optionsList;
  final String? selectedOption;
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
    selectedDropdownOption = widget.selectedOption;
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
                        const CustomText(text: 'Select Genre'),
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
                          hint: CustomText(text: widget.optionsTitle),
                          value: selectedDropdownOption,
                          items: widget.optionsList.map((int item) {
                            return DropdownMenuItem(
                              value: item.toString(),
                              child: Text(item.toString()),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
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
                          widget.onClearFilter.call();
                          Navigator.of(context).pop();
                        },
                        child: const CustomText(text: 'Clear Filter'),
                      ),
                      const Gap(),
                      ElevatedButton(
                        onPressed: () {
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
