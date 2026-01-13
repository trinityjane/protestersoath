import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'The Protester\'s Oath'**
  String get loginTitle;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Protester\'s Oath'**
  String get appTitle;

  /// No description provided for @point00.
  ///
  /// In en, this message translates to:
  /// **'I will not be violent.'**
  String get point00;

  /// No description provided for @point01.
  ///
  /// In en, this message translates to:
  /// **'I will not bring a weapon, defensive or offensive, to a protest.'**
  String get point01;

  /// No description provided for @point02.
  ///
  /// In en, this message translates to:
  /// **'I will stop violence, crime and vandalism, or record it, if I feel it is safe to do so.'**
  String get point02;

  /// No description provided for @point03.
  ///
  /// In en, this message translates to:
  /// **'I will bear witness and record peaceful and nonviolent acts of protest.'**
  String get point03;

  /// No description provided for @point04.
  ///
  /// In en, this message translates to:
  /// **'I will help those who are hurt when I am able.'**
  String get point04;

  /// No description provided for @point05.
  ///
  /// In en, this message translates to:
  /// **'I will listen to the direction of protest leaders and report problems I see.'**
  String get point05;

  /// No description provided for @point06.
  ///
  /// In en, this message translates to:
  /// **'I will eat and sleep beforehand so that I can control my emotions.'**
  String get point06;

  /// No description provided for @point07.
  ///
  /// In en, this message translates to:
  /// **'I will recognize when I am out of control and remove myself to calm down.'**
  String get point07;

  /// No description provided for @point08.
  ///
  /// In en, this message translates to:
  /// **'I will not protest at night during a riot or a curfew ordered to quell violence.'**
  String get point08;

  /// No description provided for @shortPoint00.
  ///
  /// In en, this message translates to:
  /// **'I will not be violent,'**
  String get shortPoint00;

  /// No description provided for @shortPoint01.
  ///
  /// In en, this message translates to:
  /// **'not bring a weapon to a protest,'**
  String get shortPoint01;

  /// No description provided for @shortPoint02.
  ///
  /// In en, this message translates to:
  /// **'stop violence, crime and vandalism, if safe,'**
  String get shortPoint02;

  /// No description provided for @shortPoint03.
  ///
  /// In en, this message translates to:
  /// **'witness and record peaceful protest acts,'**
  String get shortPoint03;

  /// No description provided for @shortPoint04.
  ///
  /// In en, this message translates to:
  /// **'help those who are hurt when able,'**
  String get shortPoint04;

  /// No description provided for @shortPoint05.
  ///
  /// In en, this message translates to:
  /// **'listen to the direction of protest leaders,'**
  String get shortPoint05;

  /// No description provided for @shortPoint06.
  ///
  /// In en, this message translates to:
  /// **'eat and sleep to control emotions,'**
  String get shortPoint06;

  /// No description provided for @shortPoint07.
  ///
  /// In en, this message translates to:
  /// **'leave when emotionally out of control,'**
  String get shortPoint07;

  /// No description provided for @shortPoint08.
  ///
  /// In en, this message translates to:
  /// **'not protest in a riot or curfew for violence.'**
  String get shortPoint08;

  /// No description provided for @invalidPhoneLength.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 10-14 digits long'**
  String get invalidPhoneLength;

  /// No description provided for @invalidPhoneRegex.
  ///
  /// In en, this message translates to:
  /// **'Phone number is in an invalid format'**
  String get invalidPhoneRegex;

  /// No description provided for @iCommitButton.
  ///
  /// In en, this message translates to:
  /// **'I Commit'**
  String get iCommitButton;

  /// No description provided for @somethingWrong1.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get somethingWrong1;

  /// No description provided for @networkIssues2.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get networkIssues2;

  /// No description provided for @somethingWrong3.
  ///
  /// In en, this message translates to:
  /// **'Something has gone wrong, please try again later.'**
  String get somethingWrong3;

  /// No description provided for @somethingWrong4.
  ///
  /// In en, this message translates to:
  /// **'Something has gone wrong, please try again later.'**
  String get somethingWrong4;

  /// No description provided for @somethingWrong5.
  ///
  /// In en, this message translates to:
  /// **'Something has gone wrong, please try again later.'**
  String get somethingWrong5;

  /// No description provided for @somethingWrong6.
  ///
  /// In en, this message translates to:
  /// **'You have entered a wrong pin code, please try again.'**
  String get somethingWrong6;

  /// No description provided for @invalidOtp7.
  ///
  /// In en, this message translates to:
  /// **'The wrong code was given or the phone number given is incorrect.'**
  String get invalidOtp7;

  /// No description provided for @somethingWrong8.
  ///
  /// In en, this message translates to:
  /// **'Something has gone wrong, please try again later.'**
  String get somethingWrong8;

  /// No description provided for @invalidOtp2_9.
  ///
  /// In en, this message translates to:
  /// **'The sms verification code entered is incorrect. Please check the number and try again.'**
  String get invalidOtp2_9;

  /// No description provided for @authTimeout10.
  ///
  /// In en, this message translates to:
  /// **'Authentication Timed Out'**
  String get authTimeout10;

  /// No description provided for @somethingWrong11.
  ///
  /// In en, this message translates to:
  /// **'Cannot evaluate the phone number for an unknown reason.'**
  String get somethingWrong11;

  /// No description provided for @somethingWrong12.
  ///
  /// In en, this message translates to:
  /// **'This device does not have cellular connectivity. Something has gone wrong, please try again later.'**
  String get somethingWrong12;

  /// No description provided for @urlProblem.
  ///
  /// In en, this message translates to:
  /// **'Oops... the URL couldn\'t be opened!'**
  String get urlProblem;

  /// No description provided for @enterPhoneTip.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to sign the oath'**
  String get enterPhoneTip;

  /// No description provided for @enterVerifyPhoneTip.
  ///
  /// In en, this message translates to:
  /// **'Enter another\'s phone number to verify'**
  String get enterVerifyPhoneTip;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Retake Oath'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Take The Oath'**
  String get login;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Proof of Oath'**
  String get home;

  /// No description provided for @theoath.
  ///
  /// In en, this message translates to:
  /// **'The Oath'**
  String get theoath;

  /// No description provided for @thereason.
  ///
  /// In en, this message translates to:
  /// **'Reason for the Oath'**
  String get thereason;

  /// No description provided for @oathTaken.
  ///
  /// In en, this message translates to:
  /// **'I Took the Protester\'s Oath'**
  String get oathTaken;

  /// No description provided for @reasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Reasoning'**
  String get reasonTitle;

  /// No description provided for @reason0.
  ///
  /// In en, this message translates to:
  /// **'This app helps you as a protester show to outside observers that you are not participating in violence. If non-protesters see other groups being violent, they are able to say to themselves: \'The protesters took an oath to be nonviolent, the violence must not be coming from them\'. This simple idea, that protesters take an oath, will distinguish them in the minds of observers from rioters, criminals, vandals and the violent.'**
  String get reason0;

  /// No description provided for @reason1.
  ///
  /// In en, this message translates to:
  /// **'When you enter your phone number and press the \'I Commit\' button below the oath, you are taking an oath to be nonviolent. Note: Your phone will not be sent or saved anywhere other than your phone and is not accessible by any party other than yourself.'**
  String get reason1;

  /// No description provided for @reason2.
  ///
  /// In en, this message translates to:
  /// **'Your phone number will be used to create a unique picture of your commitment to nonviolence.'**
  String get reason2;

  /// No description provided for @reason3.
  ///
  /// In en, this message translates to:
  /// **'The power of protest is to reveal truth in the face of unjust power through nonviolent action.'**
  String get reason3;

  /// No description provided for @reason4.
  ///
  /// In en, this message translates to:
  /// **'Violence negates that revelation, burying the truth in a haze of fear and anger. If the audience of the protest fears you, they will not hear you. Nonviolence means peaceful civil disobedience and useful mischief against immoral laws and power.'**
  String get reason4;

  /// No description provided for @reason5.
  ///
  /// In en, this message translates to:
  /// **'People who are out of power, minorities, immigrants, the non traditional and those at the fringes of society have learned this. But we all must learn this if there is to be change.'**
  String get reason5;

  /// No description provided for @reason6.
  ///
  /// In en, this message translates to:
  /// **'We are taught to meet injustice with violence, that violence is somehow justified in that context. Violence is never justified, and further, the reacting person gives up their power when they respond with violence. The power of nonviolence is its ability to win sympathy and to clearly demonstrate the injustice of an aggressor, an oppressor, the object of the protest.'**
  String get reason6;

  /// No description provided for @reason7.
  ///
  /// In en, this message translates to:
  /// **'Please take this oath so that your voice will be heard and the real power of nonviolence activated.'**
  String get reason7;

  /// No description provided for @explainTitle.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explainTitle;

  /// No description provided for @explain1.
  ///
  /// In en, this message translates to:
  /// **'Being nonviolent is the power that a protest holds, that gives it a voice for change.'**
  String get explain1;

  /// No description provided for @explain2.
  ///
  /// In en, this message translates to:
  /// **'Protesting involves committing of acts of useful civil disobedience that is peaceful, nonviolent and non-vengeful. These acts may be inconvenient to others, but brings attention to the injustices that are being protested. Indiscriminate vandalism isn’t useful mischief, throwing things is not useful mischief. Examples of useful mischief are blocking traffic, sit-ins, disobeying immoral laws, or defacing of symbols of oppression and hate.'**
  String get explain2;

  /// No description provided for @explain3.
  ///
  /// In en, this message translates to:
  /// **'Violence is where protest ends and riots begin. Violence gives the object of a protest an excuse to commit violent acts and to suppress the protest. Violence overshadows the reason for the protest.'**
  String get explain3;

  /// No description provided for @explain4.
  ///
  /// In en, this message translates to:
  /// **'Vandalizing bystander property, breaking windows or spraying graffiti does not help a cause because the object of the protest will use that as an excuse to discount its message. Vandalism will be used as an excuse to respond with disproportionate force which endangers the protest. Vandalism will be seen as violence by many bystanders. One exception is vandalism of symbols of oppression.'**
  String get explain4;

  /// No description provided for @explain5.
  ///
  /// In en, this message translates to:
  /// **'Throwing things at police, military or anyone will be seen as an act of violence and will be responded to with disproportionate force. Throwing any projectile will be seen as an act of violence even if it is non-lethal. Water bottles, rocks, eggs, fireworks, shoes and other like objects can hurt someone if they hit them in unfortunate ways. One exception is glitter or soap bubbles which can’t be construed as violent.'**
  String get explain5;

  /// No description provided for @explain6.
  ///
  /// In en, this message translates to:
  /// **'Weapons must not be brought to a protest because it enables violence whether that weapon is used defensively or offensively. Do not bring a weapon to a protest, no guns, knives, batons or any instrument that can be used to hurt someone. A weapon is not a means of defence, it is a temptation to use violence.'**
  String get explain6;

  /// No description provided for @explain7.
  ///
  /// In en, this message translates to:
  /// **'Stopping violence around the protest helps people stay focused on what is important- staying nonviolent. This must be done in a nonviolent way. Help each other to quell anger and respond with love so that the message of the protest will be heard.'**
  String get explain7;

  /// No description provided for @explain8.
  ///
  /// In en, this message translates to:
  /// **'Being a witness to the protest helps to bring the protest’s message to a wider audience and gain the sympathy of potential allies. The protest will be understood if violence is met with love and by example over time.'**
  String get explain8;

  /// No description provided for @explain9.
  ///
  /// In en, this message translates to:
  /// **'Help people who are hurt only if you are coming to help from a place of certainty, safety, knowledge of your surroundings and of the risk you are taking. Helping the hurt will keep people healthy so that they can continue to participate.'**
  String get explain9;

  /// No description provided for @explain10.
  ///
  /// In en, this message translates to:
  /// **'By listening to the leaders of the protest, you can coordinate with protest activities and help communicate coherent and clear messages. The first responsibility of the protest and protesters is to communicate to bystanders what the problem is and what remedy is required.'**
  String get explain10;

  /// No description provided for @explain11.
  ///
  /// In en, this message translates to:
  /// **'When the police are informed, they do not have an excuse to work against the protest. Police should come to see their duty as protecting the protester, property and bystanders. By cooperating with police, they can come to understand the motivations of the protest. Committing crimes is self serving and not the purpose of protest.'**
  String get explain11;

  /// No description provided for @explain12.
  ///
  /// In en, this message translates to:
  /// **'Eating and sleeping before attending a protest will help to control feelings of anger. The human body is built to short circuit the brain in dangerous situations and will create the desire for violence. This short circuit becomes more sensitive as we become tired and hungry.'**
  String get explain12;

  /// No description provided for @explain13.
  ///
  /// In en, this message translates to:
  /// **'When we become emotional it is more difficult to control ourselves. We must not respond to violence with violence, even when feeling angry or fearful. We must stand if we can, run to protect ourselves if we must, or remove ourselves if we cannot control our actions. If we feel self righteous we will feel we have an excuse for retribution. But, we should not take that path because this will hurt the cause.'**
  String get explain13;

  /// No description provided for @explain14.
  ///
  /// In en, this message translates to:
  /// **'Finally, nighttime protests are more difficult because it is much easier to get away with violence, crime and vandalism. It is also much harder to distinguish rioter from protester. If a protest must take place at night, more coordination with the protest leaders and police will be necessary to keep the things peaceful, identify vandals and thieves and keep protesters safe.'**
  String get explain14;

  /// No description provided for @explain15.
  ///
  /// In en, this message translates to:
  /// **'3 Jane'**
  String get explain15;

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Oath'**
  String get verifyTitle;

  /// No description provided for @oathVerified.
  ///
  /// In en, this message translates to:
  /// **'Oath Verified!'**
  String get oathVerified;

  /// No description provided for @verifyAnOath.
  ///
  /// In en, this message translates to:
  /// **'Verify An Oath'**
  String get verifyAnOath;

  /// No description provided for @verify1.
  ///
  /// In en, this message translates to:
  /// **'Each \'Proof of Oath\' is a unique picture contructed from your phone number.'**
  String get verify1;

  /// No description provided for @verify2.
  ///
  /// In en, this message translates to:
  /// **'Enter someone else\'s phone number here and press \'confirm\' to see that their picture matches the \'proof of oath\' on their phone.'**
  String get verify2;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyTitle;

  /// No description provided for @privacy1.
  ///
  /// In en, this message translates to:
  /// **'Privacy section 1.'**
  String get privacy1;

  /// No description provided for @privacy2.
  ///
  /// In en, this message translates to:
  /// **'Privacy section 2.'**
  String get privacy2;

  /// No description provided for @verifyOther.
  ///
  /// In en, this message translates to:
  /// **'Verify Other'**
  String get verifyOther;

  /// No description provided for @theOath.
  ///
  /// In en, this message translates to:
  /// **'The Oath'**
  String get theOath;

  /// No description provided for @theReason.
  ///
  /// In en, this message translates to:
  /// **'The Reason'**
  String get theReason;

  /// No description provided for @stories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get stories;

  /// No description provided for @protests.
  ///
  /// In en, this message translates to:
  /// **'Protests'**
  String get protests;

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @exitAppPrompt.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit the app?'**
  String get exitAppPrompt;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get no;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
