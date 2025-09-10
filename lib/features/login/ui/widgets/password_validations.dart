import 'package:doc_app/core/helpers/spacing.dart';
import 'package:doc_app/core/theming/colors.dart';
import 'package:doc_app/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PasswordValidations extends StatelessWidget {
  final bool hasLowerCase;
  final bool hasUpperCase;
  final bool hasSpecialCharacter;
  final bool hasNumber;
  final bool hasMinimamLenth;
  const PasswordValidations({
    super.key,
    required this.hasLowerCase,
    required this.hasUpperCase,
    required this.hasSpecialCharacter,
    required this.hasNumber,
    required this.hasMinimamLenth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildValidateMethod('At Least 1 lowercase latter', hasLowerCase),
        verticalSpace(2),
        buildValidateMethod('At Least 1 Uppercase latter', hasUpperCase),
        verticalSpace(2),
        buildValidateMethod('At Least 1 special latter', hasSpecialCharacter),
        verticalSpace(2),
        buildValidateMethod('At Least 1  number', hasNumber),
        verticalSpace(2),
        buildValidateMethod('At Least 8 Character', hasMinimamLenth),
      ],
    );
  }

  Widget buildValidateMethod(String text, bool hasValidated) {
    return Row(
      children: [
        CircleAvatar(radius: 2.5, backgroundColor: ColorsManager.gray),
        horizontalSpace(6),
        Text(
          text,
          style: TextStyles.font13BlueRegular.copyWith(
            decoration: hasValidated ? TextDecoration.lineThrough : null,
            decorationThickness: 2,
            decorationColor: Colors.green,
            color: hasValidated ? ColorsManager.gray : ColorsManager.darkBlue,
          ),
        ),
      ],
    );
  }
}
