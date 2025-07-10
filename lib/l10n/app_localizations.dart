import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @loginToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get loginToYourAccount;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// No description provided for @logoutSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logoutSuccessful;

  /// No description provided for @errorLoggingOut.
  ///
  /// In en, this message translates to:
  /// **'Error logging out'**
  String get errorLoggingOut;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @waterMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Water Monitoring'**
  String get waterMonitoring;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @requestWater.
  ///
  /// In en, this message translates to:
  /// **'Request Water'**
  String get requestWater;

  /// No description provided for @viewRequestHistory.
  ///
  /// In en, this message translates to:
  /// **'View Request History'**
  String get viewRequestHistory;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @noEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No events found.'**
  String get noEventsFound;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdated;

  /// No description provided for @photoUploadComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Photo upload coming soon!'**
  String get photoUploadComingSoon;

  /// No description provided for @waterRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Water request sent!'**
  String get waterRequestSent;

  /// No description provided for @newReport.
  ///
  /// In en, this message translates to:
  /// **'New Report'**
  String get newReport;

  /// No description provided for @createReport.
  ///
  /// In en, this message translates to:
  /// **'Create Report'**
  String get createReport;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @enterReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter report title'**
  String get enterReportTitle;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @describeTheIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue...'**
  String get describeTheIssue;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get pleaseEnterDescription;

  /// No description provided for @reportDetails.
  ///
  /// In en, this message translates to:
  /// **'Report Details'**
  String get reportDetails;

  /// No description provided for @reviewReportDetails.
  ///
  /// In en, this message translates to:
  /// **'1. Review report details'**
  String get reviewReportDetails;

  /// No description provided for @updateStatusIfNeeded.
  ///
  /// In en, this message translates to:
  /// **'2. Update status if needed'**
  String get updateStatusIfNeeded;

  /// No description provided for @contactSupportForAssistance.
  ///
  /// In en, this message translates to:
  /// **'3. Contact support for assistance'**
  String get contactSupportForAssistance;

  /// No description provided for @eventDetails.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetails;

  /// No description provided for @waterLevel.
  ///
  /// In en, this message translates to:
  /// **'Water Level'**
  String get waterLevel;

  /// No description provided for @waterQuality.
  ///
  /// In en, this message translates to:
  /// **'Water Quality'**
  String get waterQuality;

  /// No description provided for @recommendedActions.
  ///
  /// In en, this message translates to:
  /// **'Recommended Actions'**
  String get recommendedActions;

  /// No description provided for @monitorAnalyticsQualityLevels.
  ///
  /// In en, this message translates to:
  /// **'1. Monitor analytics quality levels'**
  String get monitorAnalyticsQualityLevels;

  /// No description provided for @checkTankAnalyticsLevel.
  ///
  /// In en, this message translates to:
  /// **'2. Check tank analytics level'**
  String get checkTankAnalyticsLevel;

  /// No description provided for @contactSupportIfIssuesPersist.
  ///
  /// In en, this message translates to:
  /// **'3. Contact support if issues persist'**
  String get contactSupportIfIssuesPersist;

  /// No description provided for @liters.
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get liters;

  /// No description provided for @enterAmountOfWater.
  ///
  /// In en, this message translates to:
  /// **'Enter amount of water'**
  String get enterAmountOfWater;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// No description provided for @waterSupplyRequest.
  ///
  /// In en, this message translates to:
  /// **'Water Supply Request'**
  String get waterSupplyRequest;

  /// No description provided for @requested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requested;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @requestedAmount.
  ///
  /// In en, this message translates to:
  /// **'Requested Amount'**
  String get requestedAmount;

  /// No description provided for @deliveredAt.
  ///
  /// In en, this message translates to:
  /// **'Delivered At'**
  String get deliveredAt;

  /// No description provided for @monitorRequestStatus.
  ///
  /// In en, this message translates to:
  /// **'1. Monitor request status'**
  String get monitorRequestStatus;

  /// No description provided for @contactSupportIfNeeded.
  ///
  /// In en, this message translates to:
  /// **'2. Contact support if needed'**
  String get contactSupportIfNeeded;

  /// No description provided for @checkWaterSupplyUpdates.
  ///
  /// In en, this message translates to:
  /// **'3. Check water supply updates'**
  String get checkWaterSupplyUpdates;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @withoutWater.
  ///
  /// In en, this message translates to:
  /// **'Without Water'**
  String get withoutWater;

  /// No description provided for @noWaterAnalysisMessage.
  ///
  /// In en, this message translates to:
  /// **'No water analysis available'**
  String get noWaterAnalysisMessage;

  /// No description provided for @loadingMessage.
  ///
  /// In en, this message translates to:
  /// **''**
  String get loadingMessage;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @tanksEvents.
  ///
  /// In en, this message translates to:
  /// **'TANKS EVENTS'**
  String get tanksEvents;

  /// No description provided for @searchEvents.
  ///
  /// In en, this message translates to:
  /// **'Search events...'**
  String get searchEvents;

  /// No description provided for @pullDownToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get pullDownToRefresh;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @noWaterSupplyRequestsFound.
  ///
  /// In en, this message translates to:
  /// **'No water supply requests found'**
  String get noWaterSupplyRequestsFound;

  /// No description provided for @requestHistory.
  ///
  /// In en, this message translates to:
  /// **'Request History'**
  String get requestHistory;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tank.
  ///
  /// In en, this message translates to:
  /// **'Tank 1'**
  String get tank;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @ph.
  ///
  /// In en, this message translates to:
  /// **'pH'**
  String get ph;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @waterMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Water Measurement'**
  String get waterMeasurement;

  /// No description provided for @searchReports.
  ///
  /// In en, this message translates to:
  /// **'Search reports...'**
  String get searchReports;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'REPORTS'**
  String get reports;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @acceptable.
  ///
  /// In en, this message translates to:
  /// **'Acceptable'**
  String get acceptable;

  /// No description provided for @bad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get bad;

  /// No description provided for @nonPotable.
  ///
  /// In en, this message translates to:
  /// **'Non-potable'**
  String get nonPotable;

  /// No description provided for @contaminated.
  ///
  /// In en, this message translates to:
  /// **'Contaminated'**
  String get contaminated;

  /// Message showing requested water amount
  ///
  /// In en, this message translates to:
  /// **'Requested {liters} liters of water'**
  String requestedLitersOfWater(int liters);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
