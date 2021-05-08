// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Login to share your items`
  String get loginHint {
    return Intl.message(
      'Login to share your items',
      name: 'loginHint',
      desc: '',
      args: [],
    );
  }

  /// `Register for free`
  String get registerForFree {
    return Intl.message(
      'Register for free',
      name: 'registerForFree',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPassword {
    return Intl.message(
      'Forgot password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the required information below to proceed with the registration`
  String get registerHint {
    return Intl.message(
      'Please enter the required information below to proceed with the registration',
      name: 'registerHint',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get name {
    return Intl.message(
      'Full name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `2Hand - Sharing`
  String get brand {
    return Intl.message(
      '2Hand - Sharing',
      name: 'brand',
      desc: '',
      args: [],
    );
  }

  /// `Please give us email address access your account`
  String get forgotPasswordHint {
    return Intl.message(
      'Please give us email address access your account',
      name: 'forgotPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message(
      'Continue',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `Enter verify code`
  String get verifyCode {
    return Intl.message(
      'Enter verify code',
      name: 'verifyCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter the 4-digit verification code sent to your email`
  String get verifyCodeHint {
    return Intl.message(
      'Enter the 4-digit verification code sent to your email',
      name: 'verifyCodeHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Send Code`
  String get sendCode {
    return Intl.message(
      'Send Code',
      name: 'sendCode',
      desc: '',
      args: [],
    );
  }

  /// `Use another Email`
  String get anotherEmail {
    return Intl.message(
      'Use another Email',
      name: 'anotherEmail',
      desc: '',
      args: [],
    );
  }

  /// `Note: Do not share your authentication code and password with anyone to avoid unexpected events`
  String get resetPasswordNote {
    return Intl.message(
      'Note: Do not share your authentication code and password with anyone to avoid unexpected events',
      name: 'resetPasswordNote',
      desc: '',
      args: [],
    );
  }

  /// `Email can't be empty`
  String get emptyEmailError {
    return Intl.message(
      'Email can\'t be empty',
      name: 'emptyEmailError',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get invalidEmail {
    return Intl.message(
      'Invalid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Username must be at least 6 characters`
  String get invalidUsername {
    return Intl.message(
      'Username must be at least 6 characters',
      name: 'invalidUsername',
      desc: '',
      args: [],
    );
  }

  /// `Password can't be empty`
  String get emptyPasswordError {
    return Intl.message(
      'Password can\'t be empty',
      name: 'emptyPasswordError',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least eight characters, at least one letter and one number`
  String get validatePassword {
    return Intl.message(
      'Password must contain at least eight characters, at least one letter and one number',
      name: 'validatePassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password must match with password`
  String get matchPassword {
    return Intl.message(
      'Confirm password must match with password',
      name: 'matchPassword',
      desc: '',
      args: [],
    );
  }

  /// `Donate`
  String get donate {
    return Intl.message(
      'Donate',
      name: 'donate',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get post {
    return Intl.message(
      'Post',
      name: 'post',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message(
      'Try again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get failed {
    return Intl.message(
      'Failed',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `Username or password is incorrect.`
  String get loginFailedNotification {
    return Intl.message(
      'Username or password is incorrect.',
      name: 'loginFailedNotification',
      desc: '',
      args: [],
    );
  }

  /// `Select photos`
  String get selectPhotos {
    return Intl.message(
      'Select photos',
      name: 'selectPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Register Successful. Check your confirm email`
  String get registerSuccess {
    return Intl.message(
      'Register Successful. Check your confirm email',
      name: 'registerSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Register information is incorrect`
  String get registerFailedNotification {
    return Intl.message(
      'Register information is incorrect',
      name: 'registerFailedNotification',
      desc: '',
      args: [],
    );
  }

  /// `Full Name can't be empty`
  String get emptyFullNameError {
    return Intl.message(
      'Full Name can\'t be empty',
      name: 'emptyFullNameError',
      desc: '',
      args: [],
    );
  }

  /// `Add photo`
  String get addPhoto {
    return Intl.message(
      'Add photo',
      name: 'addPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get postItem {
    return Intl.message(
      'Post',
      name: 'postItem',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Clothes`
  String get clothes {
    return Intl.message(
      'Clothes',
      name: 'clothes',
      desc: '',
      args: [],
    );
  }

  /// `Sport`
  String get sport {
    return Intl.message(
      'Sport',
      name: 'sport',
      desc: '',
      args: [],
    );
  }

  /// `Study`
  String get study {
    return Intl.message(
      'Study',
      name: 'study',
      desc: '',
      args: [],
    );
  }

  /// `Houseware`
  String get houseware {
    return Intl.message(
      'Houseware',
      name: 'houseware',
      desc: '',
      args: [],
    );
  }

  /// `Electronic`
  String get electronic {
    return Intl.message(
      'Electronic',
      name: 'electronic',
      desc: '',
      args: [],
    );
  }

  /// `Furniture`
  String get furniture {
    return Intl.message(
      'Furniture',
      name: 'furniture',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get day {
    return Intl.message(
      'day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `month`
  String get month {
    return Intl.message(
      'month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `year`
  String get year {
    return Intl.message(
      'year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `hour`
  String get hour {
    return Intl.message(
      'hour',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `minute`
  String get minute {
    return Intl.message(
      'minute',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `second`
  String get second {
    return Intl.message(
      'second',
      name: 'second',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Number, street`
  String get addressHint {
    return Intl.message(
      'Number, street',
      name: 'addressHint',
      desc: '',
      args: [],
    );
  }

  /// `Ward`
  String get ward {
    return Intl.message(
      'Ward',
      name: 'ward',
      desc: '',
      args: [],
    );
  }

  /// `District`
  String get district {
    return Intl.message(
      'District',
      name: 'district',
      desc: '',
      args: [],
    );
  }

  /// `Province`
  String get province {
    return Intl.message(
      'Province',
      name: 'province',
      desc: '',
      args: [],
    );
  }

  /// `Viet Nam`
  String get vietNam {
    return Intl.message(
      'Viet Nam',
      name: 'vietNam',
      desc: '',
      args: [],
    );
  }

  /// `Receive address`
  String get receiveAddress {
    return Intl.message(
      'Receive address',
      name: 'receiveAddress',
      desc: '',
      args: [],
    );
  }

  /// `Province can't be empty!`
  String get provinceEmptyError {
    return Intl.message(
      'Province can\'t be empty!',
      name: 'provinceEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `District can't be empty!`
  String get districtEmptyError {
    return Intl.message(
      'District can\'t be empty!',
      name: 'districtEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Ward can't be empty!`
  String get wardEmptyError {
    return Intl.message(
      'Ward can\'t be empty!',
      name: 'wardEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Address can't be empty!`
  String get addressEmptyError {
    return Intl.message(
      'Address can\'t be empty!',
      name: 'addressEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Address must be filled completely!`
  String get addressError {
    return Intl.message(
      'Address must be filled completely!',
      name: 'addressError',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number!`
  String get invalidPhoneNumber {
    return Intl.message(
      'Invalid phone number!',
      name: 'invalidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Title can't be empty!`
  String get titleEmptyError {
    return Intl.message(
      'Title can\'t be empty!',
      name: 'titleEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Description can't be empty!`
  String get descriptionEmptyError {
    return Intl.message(
      'Description can\'t be empty!',
      name: 'descriptionEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Item must have at least one images!`
  String get notEnoughImages {
    return Intl.message(
      'Item must have at least one images!',
      name: 'notEnoughImages',
      desc: '',
      args: [],
    );
  }

  /// `Images`
  String get images {
    return Intl.message(
      'Images',
      name: 'images',
      desc: '',
      args: [],
    );
  }

  /// `Posted`
  String get posted {
    return Intl.message(
      'Posted',
      name: 'posted',
      desc: '',
      args: [],
    );
  }

  /// `Your item is posted! Thank you so much!`
  String get postedNotification {
    return Intl.message(
      'Your item is posted! Thank you so much!',
      name: 'postedNotification',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while posting`
  String get postError {
    return Intl.message(
      'An error occurred while posting',
      name: 'postError',
      desc: '',
      args: [],
    );
  }

  /// `Check your email`
  String get checkMailForgotPassword {
    return Intl.message(
      'Check your email',
      name: 'checkMailForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPassword {
    return Intl.message(
      'Reset password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Insert your new password to change`
  String get resetPasswordHint {
    return Intl.message(
      'Insert your new password to change',
      name: 'resetPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Your email does not exist`
  String get notExistEmail {
    return Intl.message(
      'Your email does not exist',
      name: 'notExistEmail',
      desc: '',
      args: [],
    );
  }

  /// `Your have seen all posts`
  String get endNotifyMessage {
    return Intl.message(
      'Your have seen all posts',
      name: 'endNotifyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Allow 2Hand-Sharing access device's storage`
  String get grantStoragePermission {
    return Intl.message(
      'Allow 2Hand-Sharing access device\'s storage',
      name: 'grantStoragePermission',
      desc: '',
      args: [],
    );
  }

  /// `Grant access permission in settings to upload your item's images`
  String get grantStoragePermissionHint {
    return Intl.message(
      'Grant access permission in settings to upload your item\'s images',
      name: 'grantStoragePermissionHint',
      desc: '',
      args: [],
    );
  }

  /// `Allow access`
  String get allowAccess {
    return Intl.message(
      'Allow access',
      name: 'allowAccess',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get detail {
    return Intl.message(
      'Detail',
      name: 'detail',
      desc: '',
      args: [],
    );
  }

  /// `Request`
  String get request {
    return Intl.message(
      'Request',
      name: 'request',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}