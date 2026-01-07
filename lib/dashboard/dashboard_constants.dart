class Constants {
  const Constants._();
  static RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\.]+\.(com|pk)+",
  );
  static RegExp contactRegex = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
  static const invalidEmailError = 'Please enter a valid email address';
  static const emptyPasswordInputError = 'Please enter your password';
  static const emptyConfirmPasswordInputError =
      'Please enter a confirm password';
  static const passwordgreaterthansix =
      'Password must be greater than 6 character';
  static const emptyEmailInputError = 'Please enter your email';
  static const nameInputEmptyError = "Please enter your name";
  static const dateInputEmptyError = "Purchase Date can not be empty";
  static const warrantyInputEmptyError = "Warranty Time can not be empty";
  static const calimInputEmptyError = "Claim Time can not be empty";
  static const nameLengthInputEmptyError = "Name Length can not be less than 3";
  static const confirmPasswordNotMatched = "Confirm password do not match";
  static const invalidContactError = 'Please enter a valid contact';
  static const emptyContactError = 'Please enter your contact number';
  static const emptysubjectError = "Please enter feedback subject";
  static const subjectLessthanThree = "Subject must be greater than 3";
  static const emptyDetailsError = "Please enter feedback details";
  static const feedbackLessthanTen = "Details must be greater than 10";
  static const emptyurlError = "Please enter url";
  static const urllessthan10 = "Url must be greater than 4";
  static const dummyProfilePicture =
      "https://firebasestorage.googleapis.com/v0/b/my2cents-5dc71.appspot.com/o/profile_image.jpg?alt=media&token=a5a313b6-fb4e-4939-b008-2e9628c37255";

  // error for adding post request
  static const categoryNameEmptyError = "Please enter category name";
  static const companyDetailsEmptyError = "Please enter details";
  static const companyDetailsSizeError = "Details must be greater than 10";
  static const companyAddressEmptyError = "Please enter address";
  static const companyAddressSizeError = "Address size must be greater than 4";

  static const ayaEmptyError = "Please enter aya";
  static const ayaLengthError = "Aya must be greater than 3";
}
