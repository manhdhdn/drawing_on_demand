import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'data.dart';

// const kMainColor = Color(0xFF3F8CFF);
const kPrimaryColor = Color(0xFF69B22A);
const kNeutralColor = Color(0xFF121F3E);
const kSubTitleColor = Color(0xFF4F5350);
const kLightNeutralColor = Color(0xFF8E8E8E);
const kDarkWhite = Color(0xFFF6F6F6);
const kWhite = Color(0xFFFFFFFF);
const kBorderColorTextField = Color(0xFFE3E3E3);
const ratingBarColor = Color(0xFFFFB33E);

final kTextStyle = GoogleFonts.inter(
  color: kNeutralColor,
);

const kButtonDecoration = BoxDecoration(
  color: kPrimaryColor,
  borderRadius: BorderRadius.all(
    Radius.circular(40.0),
  ),
);

InputDecoration kInputDecoration = const InputDecoration(
  hintStyle: TextStyle(color: kSubTitleColor),
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8.0),
    ),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(6.0),
    ),
    borderSide: BorderSide(color: kNeutralColor, width: 2),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(
      color: kBorderColorTextField,
    ),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

bool isCustomer = false;
bool isArtist = false;
bool isFavorite = false;
const String currencySign = '\$';
double menuMaxHeight = 170.0;

//__________Gender______________________________________________________
List<String> gender = [
  'Male',
  'Female',
];
String selectedGender = 'Male';

List<String> catName = ['Graphics Design', 'Video Editing', 'Digital Marketing', 'Business', 'Writing & Translation', 'Programming', 'Lifestyle'];

List<String> catIcon = ['images/graphic.png', 'images/videoicon.png', 'images/dm.png', 'images/b.png', 'images/t.png', 'images/p.png', 'images/l.png'];

//__________Language List_______________________________________________
List<String> language = [
  'English',
  'Vietnamese',
];

String selectedLanguage = 'Vietnamese';

//__________Language Level_______________________________________________
List<String> languageLevel = [
  'Fluent',
  'Weak',
];
String selectedLanguageLevel = 'Fluent';

//__________Skill Level_______________________________________________
List<String> skillLevel = [
  'Expert',
  'Fresher',
];
String selectedSkillLevel = 'Expert';

//__________performance_period___________________________________________________
List<String> period = [
  'Last Month',
  'This Month',
];
String selectedPeriod = 'Last Month';

//__________statistics_period___________________________________________________
List<String> staticsPeriod = [
  'Last Month',
  'This Month',
];

String selectedStaticsPeriod = 'Last Month';

//__________statistics_period___________________________________________________
List<String> earningPeriod = [
  'Last Month',
  'This Month',
];
String selectedEarningPeriod = 'Last Month';

Map<String, double> dataMap = {
  "Impressions": 5,
  "Interaction": 3,
  "Reached-Out": 2,
};

List<TitleModel> list = [
  TitleModel("DodResponsive design", false),
  TitleModel("Prototype", false),
  TitleModel("Source file", false),
];

String selectedArtworkCreateTab = 'All';

String selectedTopSeller = 'Top Artists';

String selectedJobApplyTab = 'Public';

String selectedServiceList = 'All';

String selectedOrderTab = 'Pending';

List<String> reportTitle = [
  'Non original content',
  'Trademark Violations',
  'Copyright Violations',
  'Other reasons',
];

String selectedReportTitle = 'Non original content';

List<String> gateWay = [
  'PayPal',
  'Credit Card',
  'Bkash',
];

String selectedGateWay = 'PayPal';

List<String> currency = [
  'USD',
  'BDT',
];

String selectedCurrency = 'USD';

List<int> pieces = [
  1,
  2,
  3,
  4,
  5,
  6,
];

List<XFile> images = [];

List<Color> colorList = [
  const Color(0xFF69B22A),
  const Color(0xFF144BD6),
  const Color(0xFFFF3B30),
];

String defaultImage = 'https://firebasestorage.googleapis.com/v0/b/drawing-on-demand.appspot.com/o/images%2Fdrawing_on_demand.jpg?alt=media&token=c1801df1-f2d7-485d-8715-9e7aed83c3cf';
