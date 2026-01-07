import 'package:appwidgetflutter/dashboard/dashboard_constants.dart';
import 'package:appwidgetflutter/dashboard/extensions/string_extentions.dart';

class FormValidator {
  FormValidator._();
  static String? emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return Constants.emptyEmailInputError;
    } else if (!email.isValidEmail) {
      return Constants.invalidEmailError;
    }
    return null;
  }

  static String? nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return Constants.nameInputEmptyError;
    } else if (name.length < 3) {
      return Constants.nameLengthInputEmptyError;
    }
    return null;
  }

  static String? contactValidator(String? contact) {
    if (contact == null || contact.isEmpty) return Constants.emptyContactError;
    if (contact.isValidContact) return null;
    return Constants.invalidContactError;
  }

  static String? datevalidator(String? date) {
    if (date == null || date.isEmpty) {
      return Constants.dateInputEmptyError;
    }
    return null;
  }

  static String? timevalidator(String? time) {
    if (time == null || time.isEmpty) {
      return Constants.warrantyInputEmptyError;
    }
    return null;
  }

  static String? clainvalidator(String? time) {
    if (time == null || time.isEmpty) {
      return Constants.calimInputEmptyError;
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return Constants.emptyPasswordInputError;
    } else if (password.length < 6) {
      return Constants.passwordgreaterthansix;
    }
    return null;
  }

  static String? confirmPasswordValidator(
      {String? firstPassword, String? confirmPassword}) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return Constants.emptyConfirmPasswordInputError;
    } else if (firstPassword != confirmPassword) {
      return Constants.confirmPasswordNotMatched;
    }
    return null;
  }

  static String? feedbackSubjectValidator(String? subject) {
    if (subject == null || subject.isEmpty) {
      return Constants.emptysubjectError;
    } else if (subject.length < 3) {
      return Constants.subjectLessthanThree;
    }
    return null;
  }

  static String? feedbackDetailsValidator(String? details) {
    if (details == null || details.isEmpty) {
      return Constants.emptyDetailsError;
    } else if (details.length < 10) {
      return Constants.feedbackLessthanTen;
    }
    return null;
  }

  //admin

  static String? urlController(String? url) {
    if (url == null || url.isEmpty) {
      return Constants.emptyurlError;
    } else if (url.length < 4) {
      return Constants.urllessthan10;
    }
    return null;
  }

  // validators for adding post request
  static String? categoryNameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return Constants.categoryNameEmptyError;
    } else if (name.length < 3) {
      return Constants.nameLengthInputEmptyError;
    }
    return null;
  }
  static String? ayaValidator(String? name) {
    if (name == null || name.isEmpty) {
      return Constants.ayaEmptyError;
    } else if (name.length < 3) {
      return Constants.ayaLengthError;
    }
    return null;
  }
  //

  static String? detailsErrorValidator(String? name) {
    if (name == null || name.isEmpty) {
      return Constants.companyDetailsEmptyError;
    } else if (name.length < 3) {
      return Constants.companyDetailsSizeError;
    }
    return null;
  }

  static String? addressErrorValidator(String? name) {
    if (name == null || name.isEmpty) {
      return Constants.companyDetailsEmptyError;
    } else if (name.length < 4) {
      return Constants.companyAddressSizeError;
    }
    return null;
  }

  static String? validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return Constants.emptyContactError;
    } else if (!regExp.hasMatch(value)) {
      return Constants.invalidContactError;
    }
    return null;
  }
}
