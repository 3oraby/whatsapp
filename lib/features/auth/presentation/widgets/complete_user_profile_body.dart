// import 'dart:developer';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:whatsapp/core/utils/app_constants.dart';
// import 'package:whatsapp/core/utils/app_text_styles.dart';
// import 'package:whatsapp/core/utils/validators.dart';
// import 'package:whatsapp/core/widgets/custom_text_form_field.dart';
// import 'package:whatsapp/core/widgets/horizontal_gap.dart';
// import 'package:whatsapp/core/widgets/vertical_gap.dart';

// class CompleteUserProfileBody extends StatefulWidget {
//   const CompleteUserProfileBody({super.key});

//   @override
//   State<CompleteUserProfileBody> createState() =>
//       _CompleteUserProfileBodyState();
// }

// class _CompleteUserProfileBodyState extends State<CompleteUserProfileBody> {
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

//   @override
//   void dispose() {
//     super.dispose();
//     firstNameController.dispose();
//     lastNameController.dispose();
//     ageController.dispose();
//     phoneNumberController.dispose();
//   }

//   _onCompleteProfileButtonPressed() {
//     // if (_formKey.currentState!.validate()) {
//     //   _formKey.currentState!.save();

//     //   User currentFirebaseAuthUser = getCurrentFirebaseAuthUser();

//     //   final UserModel userModel = UserModel(
//     //     userId: currentFirebaseAuthUser.uid,
//     //     firstName: firstNameController.text,
//     //     lastName: lastNameController.text,
//     //     email: currentFirebaseAuthUser.email!,
//     //     age: int.parse(ageController.text),
//     //     gender: selectedGender,
//     //     phoneNumber: phoneNumberController.text,
//     //     joinedAt: Timestamp.now(),
//     //   );
//     //   log("complete User Profile Data: ${userModel.toJson().toString()}");

//     //   BlocProvider.of<CompleteUserProfileCubit>(context).addUserToFirestore(
//     //     data: userModel.toJson(),
//     //     documentId: userModel.userId,
//     //   );
//     // } else {
//     //   setState(() {
//     //     autovalidateMode = AutovalidateMode.always;
//     //   });
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//           horizontal: AppConstants.horizontalPadding),
//       child: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const VerticalGap(16),
//               Text(
//                 context.tr('Tell us about yourself'),
//                 style: AppTextStyles.specialGothicCondensedOneBold(context, 22),
//               ),
//               const VerticalGap(16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: CustomTextFormFieldWidget(
//                       autovalidateMode: autovalidateMode,
//                       labelText: context.tr('First Name'),
//                       hintText: context.tr('Enter your first name'),
//                       controller: firstNameController,
//                       validator: (value) =>
//                           Validators.validateNormalText(context, value),
//                     ),
//                   ),
//                   const HorizontalGap(16),
//                   Expanded(
//                     child: CustomTextFormFieldWidget(
//                       autovalidateMode: autovalidateMode,
//                       labelText: context.tr('Last Name'),
//                       hintText: context.tr('Enter your last name'),
//                       controller: lastNameController,
//                       validator: (value) =>
//                           Validators.validateNormalText(context, value),
//                     ),
//                   ),
//                 ],
//               ),
//               const VerticalGap(24),
//               CustomTextFormFieldWidget(
//                 autovalidateMode: autovalidateMode,
//                 labelText: context.tr('Age'),
//                 hintText: context.tr('Enter your age'),
//                 keyboardType: TextInputType.number,
//                 controller: ageController,
//                 validator: (value) => Validators.validateAge(context, value),
//               ),
//               const VerticalGap(16),
//               CustomTextFormFieldWidget(
//                 autovalidateMode: autovalidateMode,
//                 labelText: context.tr('Phone Number'),
//                 hintText: context.tr('Enter your phone number'),
//                 keyboardType: TextInputType.phone,
//                 controller: phoneNumberController,
//                 validator: (value) =>
//                     Validators.validatePhoneNumber(context, value),
//               ),
//               const VerticalGap(16),
//               Text(
//                 context.tr('Gender'),
//                 style: AppTextStyles.uberMoveBold16,
//               ),
//               const VerticalGap(8),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 4,
//                     child: SizedBox(),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: CustomTriggerButton(
//                       onPressed: _onCompleteProfileButtonPressed,
//                       buttonDescription: Text(
//                         context.tr("Next"),
//                         style: AppTextStyles.uberMoveBold18
//                             .copyWith(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const VerticalGap(16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension StringExtension on String {
//   String capitalize() => this[0].toUpperCase() + substring(1);
// }
