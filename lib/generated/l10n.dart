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

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to logout?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutConfirmation',
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

  /// `An error occurred while posting!`
  String get postFailed {
    return Intl.message(
      'An error occurred while posting!',
      name: 'postFailed',
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

  /// `Register to receive`
  String get registerToReceive {
    return Intl.message(
      'Register to receive',
      name: 'registerToReceive',
      desc: '',
      args: [],
    );
  }

  /// `Your password was reset`
  String get resetPasswordSuccess {
    return Intl.message(
      'Your password was reset',
      name: 'resetPasswordSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Recovery link is expired`
  String get resetPasswordFailed {
    return Intl.message(
      'Recovery link is expired',
      name: 'resetPasswordFailed',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Registered`
  String get registered {
    return Intl.message(
      'Registered',
      name: 'registered',
      desc: '',
      args: [],
    );
  }

  /// `Cancel registration`
  String get cancelRegister {
    return Intl.message(
      'Cancel registration',
      name: 'cancelRegister',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get accepted {
    return Intl.message(
      'Accepted',
      name: 'accepted',
      desc: '',
      args: [],
    );
  }

  /// `Unregistered`
  String get unregistered {
    return Intl.message(
      'Unregistered',
      name: 'unregistered',
      desc: '',
      args: [],
    );
  }

  /// `Registrations`
  String get registrations {
    return Intl.message(
      'Registrations',
      name: 'registrations',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm sent`
  String get confirmSent {
    return Intl.message(
      'Confirm sent',
      name: 'confirmSent',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get complete {
    return Intl.message(
      'Complete',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `Message can't be empty`
  String get messageEmptyError {
    return Intl.message(
      'Message can\'t be empty',
      name: 'messageEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of Birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Phone number can't be empty`
  String get emptyPhoneError {
    return Intl.message(
      'Phone number can\'t be empty',
      name: 'emptyPhoneError',
      desc: '',
      args: [],
    );
  }

  /// `Your registration isn't accepted`
  String get contactDenied {
    return Intl.message(
      'Your registration isn\'t accepted',
      name: 'contactDenied',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Send thanks`
  String get sendThanks {
    return Intl.message(
      'Send thanks',
      name: 'sendThanks',
      desc: '',
      args: [],
    );
  }

  /// `Thank you so much!`
  String get thanks {
    return Intl.message(
      'Thank you so much!',
      name: 'thanks',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Thanks message`
  String get thanksMessage {
    return Intl.message(
      'Thanks message',
      name: 'thanksMessage',
      desc: '',
      args: [],
    );
  }

  /// `Thanks sent!`
  String get thanksSent {
    return Intl.message(
      'Thanks sent!',
      name: 'thanksSent',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Donation`
  String get donation {
    return Intl.message(
      'Donation',
      name: 'donation',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Email`
  String get confirmEmail {
    return Intl.message(
      'Confirm Email',
      name: 'confirmEmail',
      desc: '',
      args: [],
    );
  }

  /// `Confirm email successful`
  String get confirmEmailSuccess {
    return Intl.message(
      'Confirm email successful',
      name: 'confirmEmailSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Confirm email is not correct. Check your confirm email`
  String get confirmEmailFail {
    return Intl.message(
      'Confirm email is not correct. Check your confirm email',
      name: 'confirmEmailFail',
      desc: '',
      args: [],
    );
  }

  /// `Press button CONFIRM to complete process register account on our system`
  String get confirmEmailHint {
    return Intl.message(
      'Press button CONFIRM to complete process register account on our system',
      name: 'confirmEmailHint',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `You haven't selected category of your item yet!`
  String get categoryUnselectedError {
    return Intl.message(
      'You haven\'t selected category of your item yet!',
      name: 'categoryUnselectedError',
      desc: '',
      args: [],
    );
  }

  /// `Send message`
  String get sendMessage {
    return Intl.message(
      'Send message',
      name: 'sendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel accept`
  String get cancelAccept {
    return Intl.message(
      'Cancel accept',
      name: 'cancelAccept',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to cancel {fullName}'s accept?`
  String cancelAlert(Object fullName) {
    return Intl.message(
      'Do you want to cancel $fullName\'s accept?',
      name: 'cancelAlert',
      desc: '',
      args: [fullName],
    );
  }

  /// `Are you sure? Just confirm when the item was sent. The item will be closed after confirm sent!`
  String get confirmationSentMessage {
    return Intl.message(
      'Are you sure? Just confirm when the item was sent. The item will be closed after confirm sent!',
      name: 'confirmationSentMessage',
      desc: '',
      args: [],
    );
  }

  /// `{fullName} registered to receive your {itemName} with message: {message}`
  String incomingReceiveRequest(Object fullName, Object itemName, Object message) {
    return Intl.message(
      '$fullName registered to receive your $itemName with message: $message',
      name: 'incomingReceiveRequest',
      desc: '',
      args: [fullName, itemName, message],
    );
  }

  /// `registered to receive your`
  String get registeredItem {
    return Intl.message(
      'registered to receive your',
      name: 'registeredItem',
      desc: '',
      args: [],
    );
  }

  /// `with message:`
  String get withMessage {
    return Intl.message(
      'with message:',
      name: 'withMessage',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `This item is donated for {fullName}`
  String sentNotification(Object fullName) {
    return Intl.message(
      'This item is donated for $fullName',
      name: 'sentNotification',
      desc: '',
      args: [fullName],
    );
  }

  /// `{fullName} registered to receive your item`
  String incomingReceiveRequestSnackBar(Object fullName) {
    return Intl.message(
      '$fullName registered to receive your item',
      name: 'incomingReceiveRequestSnackBar',
      desc: '',
      args: [fullName],
    );
  }

  /// `{fullName} cancelled his request`
  String cancelReceiveRequestSnackBar(Object fullName) {
    return Intl.message(
      '$fullName cancelled his request',
      name: 'cancelReceiveRequestSnackBar',
      desc: '',
      args: [fullName],
    );
  }

  /// `Your registration was`
  String get yourRegistrationWas {
    return Intl.message(
      'Your registration was',
      name: 'yourRegistrationWas',
      desc: '',
      args: [],
    );
  }

  /// `Your accepted registration was`
  String get yourAcceptedRegistrationWas {
    return Intl.message(
      'Your accepted registration was',
      name: 'yourAcceptedRegistrationWas',
      desc: '',
      args: [],
    );
  }

  /// `accepted`
  String get acceptedLowerCase {
    return Intl.message(
      'accepted',
      name: 'acceptedLowerCase',
      desc: '',
      args: [],
    );
  }

  /// `canceled`
  String get canceledLowerCase {
    return Intl.message(
      'canceled',
      name: 'canceledLowerCase',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to cancel this registrations?`
  String get cancelRegistrationMessage {
    return Intl.message(
      'Do you want to cancel this registrations?',
      name: 'cancelRegistrationMessage',
      desc: '',
      args: [],
    );
  }

  /// `you`
  String get you {
    return Intl.message(
      'you',
      name: 'you',
      desc: '',
      args: [],
    );
  }

  /// `Thanks: {content}`
  String thanksNotification(Object content) {
    return Intl.message(
      'Thanks: $content',
      name: 'thanksNotification',
      desc: '',
      args: [content],
    );
  }

  /// `sent thanks to you:`
  String get sentThanksToYou {
    return Intl.message(
      'sent thanks to you:',
      name: 'sentThanksToYou',
      desc: '',
      args: [],
    );
  }

  /// `Item owner have confirmed donate the item for {receiver}`
  String confirmSentNotification(Object receiver) {
    return Intl.message(
      'Item owner have confirmed donate the item for $receiver',
      name: 'confirmSentNotification',
      desc: '',
      args: [receiver],
    );
  }

  /// `Item owner have confirmed donate the item for`
  String get confirmSentTo {
    return Intl.message(
      'Item owner have confirmed donate the item for',
      name: 'confirmSentTo',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `You confirmed donate for {receiver}`
  String confirmSentSuccess(Object receiver) {
    return Intl.message(
      'You confirmed donate for $receiver',
      name: 'confirmSentSuccess',
      desc: '',
      args: [receiver],
    );
  }

  /// `There is no more notification`
  String get emptyNotification {
    return Intl.message(
      'There is no more notification',
      name: 'emptyNotification',
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