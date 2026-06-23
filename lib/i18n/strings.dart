import 'language.dart';

/// Central UI string table. Every entry has a Hebrew and Arabic form.
/// Access via `tr(context-free)` using the current language.
class Strings {
  final AppLang lang;
  const Strings(this.lang);

  String _pick(String he, String ar) => lang == AppLang.ar ? ar : he;

  // --- App / general ---
  String get appName => _pick('קידני', 'كيدني');
  String get tagline => _pick('לומדים לאכול נכון', 'نتعلّم أن نأكل بشكل صحيح');
  String get menu => _pick('תפריט', 'القائمة');
  String get back => _pick('חזרה', 'رجوع');
  String get close => _pick('סגור', 'إغلاق');

  // --- Home: about dialog ---
  String get aboutTitle => _pick('אודות קידני', 'حول كيدني');
  String get aboutHeading => _pick('קידני — לומדים לאכול נכון', 'كيدني — نتعلّم أن نأكل بشكل صحيح');
  String get aboutBody => _pick(
        'אפליקציה חינוכית לילדים עם מחלת כליות כרונית ולהוריהם. ללמוד ביחד על בחירות מזון נכונות, טכניקות בישול ותוויות מזון.',
        'تطبيق تعليمي للأطفال المصابين بمرض الكلى المزمن ولأهاليهم. نتعلّم معًا عن اختيارات الطعام الصحيحة وتقنيات الطهي وملصقات الأطعمة.',
      );
  String get aboutDisclaimer => _pick(
        'המידע במשחק הוא לצורך למידה בלבד. תמיד התייעצו עם הרופא והדיאטנית של הילד.',
        'المعلومات في اللعبة لغرض التعلّم فقط. استشيروا دائمًا طبيب وأخصائية تغذية الطفل.',
      );
  String get about => _pick('אודות', 'حول');

  // --- Home: reset ---
  String get resetProgress => _pick('איפוס התקדמות', 'إعادة ضبط التقدّم');
  String get resetConfirm => _pick(
        'האם אתה בטוח שברצונך למחוק את כל ההתקדמות ולהתחיל מחדש?',
        'هل أنت متأكد من رغبتك في حذف كل التقدّم والبدء من جديد؟',
      );
  String get cancel => _pick('ביטול', 'إلغاء');
  String get reset => _pick('אפס', 'إعادة ضبط');
  String get resetDone => _pick('ההתקדמות אופסה בהצלחה', 'تمت إعادة ضبط التقدّم بنجاح');

  // --- Home: levels ---
  String levelLabel(int level) => _pick('שלב $level', 'المرحلة $level');
  String levelOutOf(int current) => _pick('שלב $current מתוך 5', 'المرحلة $current من 5');
  String correctOutOf(int score, int total) =>
      _pick('$score/$total תשובות נכונות', '$score/$total إجابات صحيحة');
  String lockedHint(int prevLevel) => _pick(
        'נעול - השלם שלב $prevLevel כדי לפתוח',
        'مقفل - أكمِل المرحلة $prevLevel للفتح',
      );
  String lockedSnack(int prevLevel, int points) => _pick(
        'צריך להשלים שלב $prevLevel עם לפחות $points תשובות נכונות כדי לפתוח שלב זה',
        'يجب إكمال المرحلة $prevLevel بما لا يقل عن $points إجابات صحيحة لفتح هذه المرحلة',
      );

  // --- Avatar titles by level ---
  String avatarTitle(int level) {
    switch (level) {
      case 1:
        return _pick('מתחיל', 'مبتدئ');
      case 2:
        return _pick('לומד', 'متعلّم');
      case 3:
        return _pick('מתקדם', 'متقدّم');
      case 4:
        return _pick('מומחה', 'خبير');
      case 5:
        return _pick('דוקטור', 'دكتور');
      default:
        return _pick('מתחיל', 'مبتدئ');
    }
  }

  // --- Quiz: exit dialog ---
  String get exitTitle => _pick('לצאת מהמשחק?', 'الخروج من اللعبة؟');
  String get exitBody => _pick('ההתקדמות בשלב זה לא תישמר.', 'لن يُحفظ التقدّم في هذه المرحلة.');
  String get keepPlaying => _pick('להמשיך לשחק', 'متابعة اللعب');
  String get exit => _pick('צא', 'اخرج');

  // --- Quiz: in-progress ---
  String get quizTitle => _pick('שאלון', 'اختبار');
  String get noQuestions => _pick('אין שאלות זמינות', 'لا توجد أسئلة متاحة');
  String questionProgress(int index, int total) =>
      _pick('שאלה $index מתוך $total', 'السؤال $index من $total');
  String streak(int count) => _pick('רצף $count', 'سلسلة $count');
  String points(int score) => _pick('$score נקודות', '$score نقاط');
  String get correctTitle => _pick('כל הכבוד!', 'أحسنت!');
  String get wrongTitle => _pick('לא נורא!', 'لا بأس!');
  String get correctSub => _pick('תשובה נכונה! +1 נקודה', 'إجابة صحيحة! +1 نقطة');
  String get wrongSub => _pick('בפעם הבאה יהיה יותר טוב', 'في المرة القادمة سيكون أفضل');
  String get explanation => _pick('הסבר', 'تفسير');
  String get nextQuestion => _pick('שאלה הבאה', 'السؤال التالي');
  String get finishLevel => _pick('סיים שלב', 'إنهاء المرحلة');

  // --- Quiz: completion summary ---
  String get finishedAll => _pick('כל הכבוד! סיימת הכל!', 'أحسنت! أنهيت كل شيء!');
  String get finishedLevel => _pick('סיימת את השלב!', 'أنهيت المرحلة!');
  String answeredCorrectly(int score, int total) => _pick(
        'ענית נכון על $score מתוך $total שאלות',
        'أجبت بشكل صحيح على $score من $total أسئلة',
      );
  String get newHighScore => _pick('שיא חדש!', 'رقم قياسي جديد!');
  String yourHighScore(int score, int total) =>
      _pick('השיא שלך: $score/$total', 'رقمك القياسي: $score/$total');
  String get masteredAll => _pick(
        'השלמת את כל השלבים! אתה מומחה לתזונה נכונה לכליות',
        'أكملت جميع المراحل! أنت خبير في التغذية الصحيحة للكلى',
      );
  String needMoreToUnlock(int points) => _pick(
        'צריך $points תשובות נכונות כדי לפתוח את השלב הבא. נסו שוב!',
        'تحتاج $points إجابات صحيحة لفتح المرحلة التالية. حاول مرة أخرى!',
      );
  String get review => _pick('סקור', 'مراجعة');
  String get playAgain => _pick('שחק שוב', 'العب مرة أخرى');
  String get tryAgain => _pick('נסה שוב', 'حاول مرة أخرى');

  // --- Review screen ---
  String reviewTitle(String levelTitle) =>
      _pick('סקירת $levelTitle', 'مراجعة $levelTitle');
  String get correctAnswer => _pick('תשובה נכונה', 'الإجابة الصحيحة');

  // --- Triumph dialog ---
  String get unlockedRank => _pick('פתחת דרגה חדשה!', 'فتحت رتبة جديدة!');
  String levelUnlocked(int level) =>
      _pick('שלב $level נפתח!', 'فُتحت المرحلة $level!');
  String get backToMenu => _pick('חזרה לתפריט', 'العودة إلى القائمة');

  // --- Level titles ---
  String levelTitle(int level) {
    switch (level) {
      case 1:
        return _pick('ארוחת בוקר ובסיס', 'الفطور والأساسيات');
      case 2:
        return _pick('טכניקות בישול', 'تقنيات الطهي');
      case 3:
        return _pick('חטיפים ושתייה', 'الوجبات الخفيفة والمشروبات');
      case 4:
        return _pick('מזון מעובד', 'الأطعمة المصنّعة');
      case 5:
        return _pick('תוויות ותוספים', 'الملصقات والإضافات');
      default:
        return levelLabel(level);
    }
  }
}

/// Convenience accessor for the current language's strings.
Strings get t => Strings(LanguageController.instance.lang.value);
