// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
// import 'package:whatsapp/core/services/get_it_service.dart';
// import 'package:whatsapp/core/utils/app_colors.dart';
// import 'package:whatsapp/core/utils/app_text_styles.dart';
// import 'package:whatsapp/core/widgets/custom_action_box.dart';
// import 'package:whatsapp/features/contacts/domain/repos/contacts_repo.dart';
// import 'package:whatsapp/features/contacts/presentation/cubits/create_new_contact_cubit.dart/create_new_contact_cubit.dart';

// class CustomAddNewContactButton extends StatelessWidget {
//   const CustomAddNewContactButton({
//     super.key,
//     required this.userId,
//   });

//   final int userId;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CreateNewContactCubit(
//         contactsRepo: getIt<ContactsRepo>(),
//       ),
//       child: CustomAddNewContactButtonBlocConsumerBody(
//         userId: userId,
//       ),
//     );
//   }
// }

// class CustomAddNewContactButtonBlocConsumerBody extends StatefulWidget {
//   const CustomAddNewContactButtonBlocConsumerBody({
//     super.key,
//     required this.userId,
//   });

//   final int userId;

//   @override
//   State<CustomAddNewContactButtonBlocConsumerBody> createState() =>
//       _CustomAddNewContactButtonBlocConsumerBodyState();
// }

// class _CustomAddNewContactButtonBlocConsumerBodyState
//     extends State<CustomAddNewContactButtonBlocConsumerBody> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   _toggleFollow() async {
//     BlocProvider.of<CreateNewContactCubit>(context)
//         .createNewContact(userId: widget.userId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<CreateNewContactCubit, CreateNewContactState>(
//       listener: (context, state) {
//         if (state is CreateNewContactFailureState) {
//           showCustomSnackBar(context, context.tr(state.message));
//         }
//       },
//       builder: (context, state) {
//         return CustomActionBox(
//           width: 115,
//           height: 40,
//           internalVerticalPadding: 0,
//           internalHorizontalPadding: 0,
//           borderColor: AppColors.inputBorderLight,
//           borderWidth: 1,
//           backgroundColor: AppColors.primaryLight,
//           onPressed: _toggleFollow,
//           // onPressed:
//           //     state is CreateNewContactLoadingState ? null : _toggleFollow,
//           child: Center(
//             child: FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(
//                 context.tr("Add contact"),
//                 style: AppTextStyles.poppinsBold(context, 14).copyWith(
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
