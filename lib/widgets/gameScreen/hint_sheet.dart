// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/models/genContent%20Models/gen_content_model.dart';
// import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
// import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

// final hintSheetBooleanProvider = StateProvider<bool>((ref) => false);

// class HintSheet extends ConsumerStatefulWidget {
//   final VoidCallback onCancelPressed;
//   final GenContent genContent;
//   const HintSheet(
//       {super.key, required this.genContent, required this.onCancelPressed});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HintSheetState();
// }

// class _HintSheetState extends ConsumerState<HintSheet> {
//   @override
//   Widget build(BuildContext context) {
//     final themePreference = ref.watch(themeProvider);
//     final isLightTheme = themePreference == ThemePreference.light;
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color:
//             isLightTheme ? LColor.backgroundPrimary : TColors.backgroundPrimary,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           spacing: 16,
//           children: [
//             Row(
//               spacing: 10,
//               children: [
//                 Text(
//                   "GenHints",
//                   style: TTextThemes.defaultTextTheme.titleLarge!.copyWith(
//                     fontSize: 25,
//                   ),
//                 ),
//                 HugeIcon(
//                   icon: HugeIcons.strokeRoundedGoogleGemini,
//                   size: 35,
//                   color: TColors.majorHighlight,
//                 ),
//               ],
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(
//                     10,
//                   ),
//                 ),
//                 color: isLightTheme
//                     ? LColor.dullBackground
//                     : TColors.dullBackground,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                     "Something Something Something Something Something Something Something Something \nSomething Something Something Something "),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     ref.read(hintSheetBooleanProvider.notifier).state = false;
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: isLightTheme
//                           ? LColor.dullBackground
//                           : TColors.dullBackground,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Center(
//                         child: Text(
//                           "Cancel",
//                           style: isLightTheme
//                               ? TTextThemes.lightTextTheme.bodyLarge!
//                                   .copyWith(fontSize: 18)
//                               : TTextThemes.defaultTextTheme.bodyLarge!
//                                   .copyWith(fontSize: 18),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: isLightTheme
//                         ? LColor.buttonDefault
//                         : TColors.buttonDefault,
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(
//                       child: Text(
//                         "Next",
//                         style: isLightTheme
//                             ? TTextThemes.lightTextTheme.bodyLarge!
//                                 .copyWith(fontSize: 18)
//                             : TTextThemes.defaultTextTheme.bodyLarge!
//                                 .copyWith(fontSize: 18),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:sudokumania/constants/colors.dart';
// import 'package:sudokumania/models/genContent%20Models/gen_content_model.dart';
// import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
// import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
// import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

// final hintSheetBooleanProvider = StateProvider<bool>((ref) => false);
// final hintStepProvider = StateProvider<int>((ref) => 0);
// final hintLoadingProvider = StateProvider<bool>((ref) => false);

// class HintSheet extends ConsumerStatefulWidget {
//   final VoidCallback onCancelPressed;
//   final Future<GenContent>? genContentFuture;
//   final VoidCallback onLastStepReached;
//   final VoidCallback fetchHintData;

//   const HintSheet({
//     super.key,
//     required this.onCancelPressed,
//     required this.onLastStepReached,
//     required this.fetchHintData,
//     this.genContentFuture,
//   });

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HintSheetState();
// }

// class _HintSheetState extends ConsumerState<HintSheet> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch data when sheet is opened if not already provided
//     if (widget.genContentFuture == null) {
//       widget.fetchHintData();
//     }
//   }

//   List<String> _extractNumbersFromExplanation(String? explanation) {
//     if (explanation == null) return [];
//     return RegExp(r'the only valid value is (\d+)')
//         .allMatches(explanation)
//         .map((match) => match.group(1)!)
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themePreference = ref.watch(themeProvider);
//     final isLightTheme = themePreference == ThemePreference.light;
//     final currentStep = ref.watch(hintStepProvider);
//     final isLoading = ref.watch(hintLoadingProvider);

//     return Container(
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color:
//             isLightTheme ? LColor.backgroundPrimary : TColors.backgroundPrimary,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: FutureBuilder<GenContent>(
//           future: widget.genContentFuture,
//           builder: (context, snapshot) {
//             if (isLoading ||
//                 snapshot.connectionState == ConnectionState.waiting) {
//               return const Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(height: 40),
//                   Center(child: CircularProgressIndicator()),
//                   SizedBox(height: 20),
//                   Text("Generating hint..."),
//                   SizedBox(height: 40),
//                 ],
//               );
//             }

//             if (snapshot.hasError) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.error_outline, color: Colors.red, size: 40),
//                   const SizedBox(height: 16),
//                   Text("Failed to generate hint",
//                       style: TTextThemes.defaultTextTheme.titleMedium),
//                   const SizedBox(height: 8),
//                   Text(snapshot.error.toString(),
//                       style: TTextThemes.defaultTextTheme.bodySmall),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       ref.read(hintLoadingProvider.notifier).state = true;
//                       widget.fetchHintData();
//                     },
//                     child: const Text("Retry"),
//                   ),
//                 ],
//               );
//             }

//             if (!snapshot.hasData) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.help_outline, size: 40),
//                   const SizedBox(height: 16),
//                   Text("No hint available",
//                       style: TTextThemes.defaultTextTheme.titleMedium),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       ref.read(hintLoadingProvider.notifier).state = true;
//                       widget.fetchHintData();
//                     },
//                     child: const Text("Generate Hint"),
//                   ),
//                 ],
//               );
//             }

//             final genContent = snapshot.data!;
//             final numbers =
//                 _extractNumbersFromExplanation(genContent.explanation);
//             final isLastStep = currentStep == numbers.length;

//             String getCurrentContent() {
//               if (currentStep == 0) {
//                 return genContent.explanation
//                         ?.split('the only valid value is')
//                         .first ??
//                     '';
//               }
//               if (currentStep <= numbers.length) {
//                 return 'The correct value is ${numbers[currentStep - 1]}';
//               }
//               return genContent.explanation ?? '';
//             }

//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       "GenHints",
//                       style: TTextThemes.defaultTextTheme.titleLarge!.copyWith(
//                         fontSize: 25,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     HugeIcon(
//                       icon: HugeIcons.strokeRoundedGoogleGemini,
//                       size: 35,
//                       color: TColors.majorHighlight,
//                     ),
//                     const Spacer(),
//                     if (numbers.isNotEmpty)
//                       Text(
//                         "${currentStep + 1}/${numbers.length + 1}",
//                         style: TTextThemes.defaultTextTheme.bodyMedium,
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(Radius.circular(10)),
//                     color: isLightTheme
//                         ? LColor.dullBackground
//                         : TColors.dullBackground,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (genContent.row != null && genContent.column != null)
//                           Text(
//                             "Cell (${genContent.row! + 1}, ${genContent.column! + 1})",
//                             style: TTextThemes.defaultTextTheme.titleMedium!
//                                 .copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         const SizedBox(height: 8),
//                         Text(
//                           getCurrentContent(),
//                           style: TTextThemes.defaultTextTheme.bodyMedium,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         ref.read(hintSheetBooleanProvider.notifier).state =
//                             false;
//                         ref.read(hintStepProvider.notifier).state = 0;
//                         widget.onCancelPressed();
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: isLightTheme
//                               ? LColor.dullBackground
//                               : TColors.dullBackground,
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(10)),
//                         ),
//                         child: const Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Center(
//                             child: Text("Cancel"),
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         if (isLastStep) {
//                           widget.onLastStepReached();
//                           ref.read(hintSheetBooleanProvider.notifier).state =
//                               false;
//                           ref.read(hintStepProvider.notifier).state = 0;
//                           Navigator.pop(context);
//                         } else {
//                           ref.read(hintStepProvider.notifier).state++;
//                         }
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: isLightTheme
//                               ? LColor.buttonDefault
//                               : TColors.buttonDefault,
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(10)),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Center(
//                             child: Text("Finish"),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sudokumania/constants/colors.dart';
import 'package:sudokumania/models/genContent%20Models/gen_content_model.dart';
import 'package:sudokumania/models/themeSwitch%20Models/themeModel.dart';
import 'package:sudokumania/providers/themeProviders/themeProvider.dart';
import 'package:sudokumania/screens/gameScreens/game_screen.dart';
import 'package:sudokumania/theme/custom_themes.dart/text_themes.dart';

final hintSheetBooleanProvider = StateProvider<bool>((ref) => false);
final hintLoadingProvider = StateProvider<bool>((ref) => false);

class HintSheet extends ConsumerStatefulWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onFinishPressed;
  final Future<GenContent> genContentFuture;
  final VoidCallback fetchHintData;

  const HintSheet({
    super.key,
    required this.onCancelPressed,
    required this.onFinishPressed,
    required this.genContentFuture,
    required this.fetchHintData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HintSheetState();
}

class _HintSheetState extends ConsumerState<HintSheet> {
//   @override
//   Widget build(BuildContext context) {
//     final themePreference = ref.watch(themeProvider);
//     final isLightTheme = themePreference == ThemePreference.light;

//     return FutureBuilder<GenContent>(
//       future: widget.genContentFuture,
//       builder: (context, snapshot) {
//         // Show loading state only if we have no data and are waiting
//         if (snapshot.connectionState == ConnectionState.waiting &&
//             !snapshot.hasData) {
//           return _buildLoadingState();
//         }

//         // Handle error state
//         if (snapshot.hasError) {
//           return _buildErrorState(ref);
//         }

//         // Get the generated content
//         final genContent = snapshot.data!;
//         return _buildContent(genContent, isLightTheme, ref);
//       },
//     );
//   }

//   Widget _buildLoadingState() {
//     return Container(
//       decoration: BoxDecoration(
//         color: ref.watch(themeProvider) == ThemePreference.light
//             ? LColor.backgroundPrimary
//             : TColors.backgroundPrimary,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: const Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(height: 40),
//           Center(child: CircularProgressIndicator()),
//           SizedBox(height: 20),
//           Text("Generating hint..."),
//           SizedBox(height: 40),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState(WidgetRef ref) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ref.watch(themeProvider) == ThemePreference.light
//             ? LColor.backgroundPrimary
//             : TColors.backgroundPrimary,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.error_outline, color: Colors.red, size: 40),
//           const SizedBox(height: 16),
//           Text("Failed to generate hint",
//               style: TTextThemes.defaultTextTheme.titleMedium),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               ref.read(hintLoadingProvider.notifier).state = true;
//               widget.fetchHintData();
//             },
//             child: const Text("Retry"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent(
//       GenContent genContent, bool isLightTheme, WidgetRef ref) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color:
//             isLightTheme ? LColor.backgroundPrimary : TColors.backgroundPrimary,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   "GenHints",
//                   style: TTextThemes.defaultTextTheme.titleLarge!.copyWith(
//                     fontSize: 25,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 HugeIcon(
//                   icon: HugeIcons.strokeRoundedGoogleGemini,
//                   size: 35,
//                   color: TColors.majorHighlight,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.all(Radius.circular(10)),
//                 color: isLightTheme
//                     ? LColor.dullBackground
//                     : TColors.dullBackground,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: genContent == null
//                     ? Column(
//                         children: [
//                           Text("Generating Hint..."),
//                           CircularProgressIndicator(),
//                         ],
//                       )
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (genContent.row != null &&
//                               genContent.column != null)
//                             Text(
//                               "Cell (${genContent.row! + 1}, ${genContent.column! + 1})",
//                               style: TTextThemes.defaultTextTheme.titleMedium!
//                                   .copyWith(fontWeight: FontWeight.bold),
//                             ),
//                           if (genContent.possibleNumber != null)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 8),
//                               child: Text(
//                                 "Possible number: ${genContent.possibleNumber}",
//                                 style: TTextThemes.defaultTextTheme.bodyLarge!
//                                     .copyWith(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           if (genContent.explanation != null)
//                           const SizedBox(height: 12),
//                           if (genContent.explanation != null)
//                           Text(
//                             genContent.explanation! ,
//                             style: TTextThemes.defaultTextTheme.bodyMedium,
//                           ),
//                         ],
//                       ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     ref.read(hintSheetBooleanProvider.notifier).state = false;
//                     widget.onCancelPressed();
//                     Navigator.of(context).pop();
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: isLightTheme
//                           ? LColor.dullBackground
//                           : TColors.dullBackground,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Padding(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                       child: Center(child: Text("Cancel")),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     widget.onFinishPressed();
//                     ref.read(hintSheetBooleanProvider.notifier).state = false;
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: isLightTheme
//                           ? LColor.buttonDefault
//                           : TColors.buttonDefault,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Padding(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                       child: Center(child: Text("Finish")),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
  // @override
  // void initState() {
  //   super.initState();
  //   // Schedule the state update for after the build is complete
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.read(hintLoadingProvider.notifier).state = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final themePreference = ref.watch(themeProvider);
    final isLightTheme = themePreference == ThemePreference.light;
    final isLoading = ref.watch(hintLoadingProvider);

    return PopScope(
      canPop: false,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: isLightTheme
              ? LColor.backgroundPrimary
              : TColors.backgroundPrimary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<GenContent>(
            future: widget.genContentFuture,
            builder: (context, snapshot) {
              // Handle loading state
              if (isLoading ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 40),
                    Center(child: CircularProgressIndicator()),
                    SizedBox(height: 20),
                    Text("Generating hint..."),
                    SizedBox(height: 40),
                  ],
                );
              }
              final hintData = ref.watch(hintDataProvider);
              // Handle error state
              if (snapshot.hasError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      "Failed to generate hint",
                      style: TTextThemes.defaultTextTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: TTextThemes.defaultTextTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(hintLoadingProvider.notifier).state = true;
                        widget.fetchHintData();
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                );
              }

              // Get the generated content
              final genContent = snapshot.data!;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Text(
                        "GenHints",
                        style:
                            TTextThemes.defaultTextTheme.titleLarge!.copyWith(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(width: 10),
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedGoogleGemini,
                        size: 35,
                        color: TColors.majorHighlight,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Content Container
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isLightTheme
                          ? LColor.dullBackground
                          : TColors.dullBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display cell coordinates if available
                          if (hintData!.row != null && hintData.column != null)
                            Text(
                              "Cell (${hintData.row! + 1}, ${hintData.column! + 1})",
                              style: TTextThemes.defaultTextTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),

                          // Display possible number if available
                          if (hintData.possibleNumber != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "Possible number: ${hintData.possibleNumber}",
                                style: TTextThemes.defaultTextTheme.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),

                          // Display the explanation
                          const SizedBox(height: 12),
                          Text(
                            hintData.explanation ?? "No explanation available",
                            style: TTextThemes.defaultTextTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cancel Button
                      GestureDetector(
                        onTap: () {
                          ref.read(hintSheetBooleanProvider.notifier).state =
                              false;
                          widget.onCancelPressed();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isLightTheme
                                ? LColor.dullBackground
                                : TColors.dullBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            child: Center(child: Text("Cancel")),
                          ),
                        ),
                      ),

                      // Finish Button
                      GestureDetector(
                        onTap: () {
                          widget.onFinishPressed();
                          ref.read(hintSheetBooleanProvider.notifier).state =
                              false;
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isLightTheme
                                ? LColor.buttonDefault
                                : TColors.buttonDefault,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            child: Center(child: Text("Finish")),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
