// Kidni - Educational Quiz Data
// 40 Hebrew questions about nutrition for children on dialysis
// Based on The Phosphate Poster and The Potassium Guide
// 5 levels × 8 questions = 40 total. Difficulty increases per level.

const List<Map<String, dynamic>> rawQuestions = [
  // ============================================
  // LEVEL 1: Breakfast & Basics (Difficulty 1/5)
  // ============================================
  {
    "id": 1,
    "level": 1,
    "topic": "ארוחת בוקר ובסיס",
    "question_text": "איזה לחם עדיף לכריך לבית הספר?",
    "image": "assets/images/q01_bread.png",
    "options": [
      {"id": "A", "text": "לחם מלא או שיפון", "is_correct": false},
      {"id": "B", "text": "לחם לבן או פיתה מקמח לבן", "is_correct": true}
    ],
    "explanation":
        "לפי המדריך, לחם לבן, פיתות ולחמניות מקמח לבן מכילים פחות זרחן ואשלגן מאשר לחם מלא ודגנים מלאים."
  },
  {
    "id": 2,
    "level": 1,
    "topic": "ארוחת בוקר ובסיס",
    "question_text": "מה עדיף למרוח על הלחם?",
    "image": "assets/images/q02_spread.png",
    "options": [
      {"id": "A", "text": "ממרח שוקולד או חמאת אגוזים", "is_correct": false},
      {"id": "B", "text": "ריבה, מרמלדה או חמאה", "is_correct": true}
    ],
    "explanation":
        "ממרחי שוקולד, טחינה וחמאת אגוזים עשירים מאוד בזרחן ואשלגן. ריבה, מרמלדה וחמאה רגילה הן בחירה בטוחה יותר."
  },
  {
    "id": 3,
    "level": 1,
    "topic": "ארוחת בוקר ובסיס",
    "question_text": "באילו דגני בוקר כדאי לבחור?",
    "image": "assets/images/q03_cereal.png",
    "options": [
      {"id": "A", "text": "דגנים עם שוקולד או אגוזים", "is_correct": false},
      {"id": "B", "text": "קורנפלקס רגיל או פצפוצי אורז", "is_correct": true}
    ],
    "explanation":
        "דגני בוקר המבוססים על שוקולד או אגוזים מכילים רמות גבוהות של זרחן ואשלגן. קורנפלקס ופצפוצי אורז הם דלי אשלגן."
  },
  {
    "id": 4,
    "level": 1,
    "topic": "ארוחת בוקר ובסיס",
    "question_text": "בחרו את המשקה הידידותי לכליות:",
    "image": "assets/images/q04_drink.png",
    "options": [
      {"id": "A", "text": "משקה שוקו", "is_correct": false},
      {"id": "B", "text": "מים או משקה תוסס בצבע בהיר", "is_correct": true}
    ],
    "explanation":
        "משקאות שוקו עשירים בזרחן. מים או משקאות תוססים בצבעים בהירים (כמו לימונדה) עדיפים על פני משקאות כהים."
  },
  {
    "id": 5,
    "level": 1,
    "topic": "ארוחת בוקר ובסיס",
    "question_text": "איזה פרי דל יותר באשלגן ומתאים כנשנוש בטוח?",
    "image": "assets/images/q05_fruit.png",
    "options": [
      {"id": "A", "text": "בננה", "is_correct": false},
      {"id": "B", "text": "תפוח (ללא הקליפה) או רסק תפוחים", "is_correct": true}
    ],
    "explanation":
        "בננה אחת שלמה עלולה לעבור בקלות את כמות האשלגן המותרת לארוחה. תפוחים (במיוחד ללא קליפה) הם דרך מצוינת ודלת אשלגן ליהנות מפרי פריך וטעים!"
  },
  {
    "id": 6,
    "level": 1,
    "topic": "ארוחת בוקר ובסיס",
    "question_text": "מה עדיף לארוז לילד לבית הספר?",
    "image": "assets/images/q06_dried_vs_fresh.png",
    "options": [
      {"id": "A", "text": "שקית פירות יבשים", "is_correct": false},
      {"id": "B", "text": "תפוח או אפרסק טרי", "is_correct": true}
    ],
    "explanation":
        "פירות יבשים הם מרוכזים ועשירים מאוד באשלגן. פרי טרי במנה מתאימה הוא בחירה בטוחה בהרבה."
  },
  {
    "id": 7,
    "level": 1,
    "topic": "ארוחת בוקר ובסיס",
    "question_text": "איזה פרי עדיף לבחור כקינוח או פרי טרי?",
    "image": "assets/images/q07_melons_berries.png",
    "options": [
      {"id": "A", "text": "מלון או קנטלופ", "is_correct": false},
      {"id": "B", "text": "אוכמניות או פטל", "is_correct": true}
    ],
    "explanation":
        "מלונים עשירים מאוד בנוזלים ומכילים רמות גבוהות של אשלגן. אוכמניות ופטל הם פירות דלי אשלגן שמתאימים הרבה יותר לתזונה ידידותית לכליות."
  },
  {
    "id": 8,
    "level": 1,
    "topic": "ארוחת בוקר ובסיס",
    "question_text": "הילד רוצה משהו מתוק. מה עדיף?",
    "image": "assets/images/q08_sweet_treat.png",
    "options": [
      {"id": "A", "text": "חטיף שוקולד", "is_correct": false},
      {"id": "B", "text": "מרשמלו או סוכריות גומי", "is_correct": true}
    ],
    "explanation":
        "שוקולד עשיר בזרחן ואשלגן. מרשמלו וסוכריות גומי דלים במינרלים אלו ולכן הם בחירה בטוחה יותר כפינוק מתוק."
  },

  // ============================================
  // LEVEL 2: Cooking Skills (Difficulty 2/5)
  // ============================================
  {
    "id": 9,
    "level": 2,
    "topic": "טכניקות בישול",
    "question_text": "מהו השלב הראשון והחשוב לפני בישול תפוחי אדמה?",
    "image": "assets/images/q09_potato_prep.png",
    "options": [
      {"id": "A", "text": "שטיפה קלה במים", "is_correct": false},
      {"id": "B", "text": "קילוף וחיתוך לחתיכות קטנות", "is_correct": true}
    ],
    "explanation":
        "קילוף וחיתוך מגדילים את שטח הפנים ומאפשרים לאשלגן 'לצאת' מתפוח האדמה אל המים בזמן הבישול."
  },
  {
    "id": 10,
    "level": 2,
    "topic": "טכניקות בישול",
    "question_text": "מהי שיטת 'ההרתחה הכפולה'?",
    "image": "assets/images/q10_double_boil.png",
    "options": [
      {
        "id": "A",
        "text": "להרתיח, לזרוק את המים, למלא מים חדשים ולהרתיח שוב",
        "is_correct": true
      },
      {"id": "B", "text": "לבשל במיקרוגל ואז בתנור", "is_correct": false}
    ],
    "explanation":
        "החלפת המים באמצע הבישול (הרתחה כפולה) היא השיטה היעילה ביותר להפחתת כמות האשלגן בתפוחי האדמה."
  },
  {
    "id": 11,
    "level": 2,
    "topic": "טכניקות בישול",
    "question_text": "האם מותר להשתמש במי הבישול של הירקות להכנת רוטב?",
    "image": "assets/images/q11_cooking_water.png",
    "options": [
      {"id": "A", "text": "כן, זה מוסיף טעם", "is_correct": false},
      {"id": "B", "text": "לא, יש לזרוק אותם", "is_correct": true}
    ],
    "explanation":
        "אין להשתמש במי הבישול להכנת רטבים או מרקים, כיוון שהם מכילים את האשלגן שיצא מהירקות."
  },
  {
    "id": 12,
    "level": 2,
    "topic": "טכניקות בישול",
    "question_text": "איזה צ'יפס מותר לילד לאכול?",
    "image": "assets/images/q12_chips.png",
    "options": [
      {"id": "A", "text": "צ'יפס קפוא תעשייתי", "is_correct": false},
      {
        "id": "B",
        "text": "צ'יפס ביתי שעבר הרתחה במים",
        "is_correct": true
      }
    ],
    "explanation":
        "צ'יפס ביתי שהורתח במים לפני הטיגון הוא בטוח יותר. מוצרים תעשייתיים כמו וופלי תפוחי אדמה וצ'יפס קפוא עשירים בזרחן ואשלגן."
  },
  {
    "id": 13,
    "level": 2,
    "topic": "טכניקות בישול",
    "question_text": "למה כדאי להשרות ירקות חתוכים במים לפני הבישול?",
    "image": "assets/images/q13_soak_veggies.png",
    "options": [
      {
        "id": "A",
        "text": "כדי שיישארו פריכים וטריים",
        "is_correct": false
      },
      {
        "id": "B",
        "text": "כדי שאשלגן ייצא מהירקות אל המים",
        "is_correct": true
      }
    ],
    "explanation":
        "השריית ירקות חתוכים במים רבים למשך מספר שעות (או לילה שלם) עוזרת לאשלגן לצאת מהירקות. את מי ההשרייה יש לזרוק."
  },
  {
    "id": 14,
    "level": 2,
    "topic": "טכניקות בישול",
    "question_text": "איזו תוספת פחמימה עדיפה ועדיפה באופן טבעי לכליות?",
    "image": "assets/images/q14_potatoes_rice.png",
    "options": [
      {"id": "A", "text": "תפוח אדמה לבן או בטטה", "is_correct": false},
      {"id": "B", "text": "אורז לבן או פסטה לבנה", "is_correct": true}
    ],
    "explanation":
        "תפוחי אדמה מכילים כמויות גדולות מאוד של אשלגן שנשאר בפנים. כדי לאכול אותם, חולי דיאליזה חייבים לבצע הרתחה כפולה. אורז לבן ופסטה לבנה דלים מאוד באשלגן באופן טבעי."
  },
  {
    "id": 15,
    "level": 2,
    "topic": "טכניקות בישול",
    "question_text":
        "כיצד עדיף לבשל אורז או פסטה לילד עם בעיות כליות?",
    "image": "assets/images/q15_pasta_rice.png",
    "options": [
      {
        "id": "A",
        "text": "במעט מים כדי לשמור על ערכים תזונתיים",
        "is_correct": false
      },
      {
        "id": "B",
        "text": "בהרבה מים ולסנן היטב אחרי הבישול",
        "is_correct": true
      }
    ],
    "explanation":
        "בישול בכמות גדולה של מים מאפשר ליותר מינרלים לצאת מהמזון. סננו היטב לאחר הבישול. זה חשוב במיוחד לחולי כליות."
  },
  {
    "id": 16,
    "level": 2,
    "topic": "טכניקות בישול",
    "question_text":
        "השרינו ירקות חתוכים במים למשך לילה. מה עושים עם המים?",
    "image": "assets/images/q16_discard_soak.png",
    "options": [
      {
        "id": "A",
        "text": "משתמשים בהם לבישול — הם מועשרים במינרלים",
        "is_correct": false
      },
      {
        "id": "B",
        "text": "שופכים לכיור ומתחילים לבשל במים חדשים",
        "is_correct": true
      }
    ],
    "explanation":
        "מי ההשרייה מכילים את האשלגן שיצא מהירקות. יש לזרוק אותם ולבשל במים חדשים ונקיים. לעולם אל תשתמשו במים אלו למרק או לרוטב."
  },

  // ============================================
  // LEVEL 3: Snacks & Drinks (Difficulty 3/5)
  // ============================================
  {
    "id": 17,
    "level": 3,
    "topic": "חטיפים ושתייה",
    "question_text": "איזה משקה הכי טוב לקחת לבית הספר?",
    "image": "assets/images/q17_school_drink.png",
    "options": [
      {"id": "A", "text": "מיץ פירות טבעי סחוט", "is_correct": false},
      {"id": "B", "text": "בקבוק מים עם פרוסת לימון", "is_correct": true}
    ],
    "explanation":
        "מיץ פירות סחוט טבעי הוא מרוכז ועשיר באשלגן. מים (גם עם טעם) הם תמיד הבחירה הבטוחה והבריאה ביותר לכליות."
  },
  {
    "id": 18,
    "level": 3,
    "topic": "חטיפים ושתייה",
    "question_text": "בא לי משהו מלוח! במה נבחר?",
    "image": "assets/images/q18_salty_snack.png",
    "options": [
      {"id": "A", "text": "שקית חטיף צ'יפס", "is_correct": false},
      {
        "id": "B",
        "text": "פופקורן ללא מלח או קרקרים מקמח לבן",
        "is_correct": true
      }
    ],
    "explanation":
        "חטיפי צ'יפס תעשייתיים עמוסים באשלגן. פופקורן ללא מלח וקרקרים מקמח לבן הם חלופות דלות אשלגן."
  },
  {
    "id": 19,
    "level": 3,
    "topic": "חטיפים ושתייה",
    "question_text": "איזו שתייה עדיפה בארוחה חגיגית?",
    "image": "assets/images/q19_festive_drink.png",
    "options": [
      {"id": "A", "text": "משקה תוסס כהה (כמו קולה)", "is_correct": false},
      {"id": "B", "text": "לימונדה או משקה תוסס בהיר", "is_correct": true}
    ],
    "explanation":
        "משקאות כהים מכילים לרוב תוספי פוספט (זרחן) מזיקים. משקאות בהירים כמו לימונדה עדיפים."
  },
  {
    "id": 20,
    "level": 3,
    "topic": "חטיפים ושתייה",
    "question_text": "יוצאים לקולנוע. איזה חטיף עדיף?",
    "image": "assets/images/q20_movie_snack.png",
    "options": [
      {"id": "A", "text": "נאצ'וס עם רוטב גבינה", "is_correct": false},
      {"id": "B", "text": "פופקורן רגיל ללא מלח", "is_correct": true}
    ],
    "explanation":
        "רוטב הגבינה המעובד בנאצ'וס עשיר בתוספי זרחן. פופקורן רגיל ללא מלח הוא חלופה בטוחה לחולי כליות."
  },
  {
    "id": 21,
    "level": 3,
    "topic": "חטיפים ושתייה",
    "question_text": "הילד רוצה גלידה. מה עדיף?",
    "image": "assets/images/q21_ice_cream.png",
    "options": [
      {"id": "A", "text": "גלידת שוקולד עם אגוזים", "is_correct": false},
      {"id": "B", "text": "ארטיק פירות או סורבה", "is_correct": true}
    ],
    "explanation":
        "שוקולד ואגוזים מוסיפים כמות משמעותית של זרחן ואשלגן. ארטיק פירות או סורבה מכילים הרבה פחות מינרלים אלו."
  },
  {
    "id": 22,
    "level": 3,
    "topic": "חטיפים ושתייה",
    "question_text": "מה חטיף טוב יותר בין ארוחות?",
    "image": "assets/images/q22_snack_between.png",
    "options": [
      {
        "id": "A",
        "text": "חטיף גרנולה עם אגוזים ושוקולד",
        "is_correct": false
      },
      {"id": "B", "text": "פריכיות אורז עם מעט ריבה", "is_correct": true}
    ],
    "explanation":
        "חטיפי גרנולה עם אגוזים ושוקולד עמוסים בזרחן ואשלגן. פריכיות אורז עם ריבה הן בחירה בטוחה בהרבה."
  },
  {
    "id": 23,
    "level": 3,
    "topic": "חטיפים ושתייה",
    "question_text": "ליום הולדת של הילד, איזו עוגה עדיפה?",
    "image": "assets/images/q23_birthday_cake.png",
    "options": [
      {
        "id": "A",
        "text": "עוגת שוקולד עם ציפוי שוקולד",
        "is_correct": false
      },
      {"id": "B", "text": "עוגת וניל עם ריבה", "is_correct": true}
    ],
    "explanation":
        "שוקולד בכל צורותיו (עוגה, ציפוי, קקאו) עשיר בזרחן. עוגת וניל פשוטה עם ריבה היא בחירה בטוחה יותר לחגיגה."
  },
  {
    "id": 24,
    "level": 3,
    "topic": "חטיפים ושתייה",
    "question_text": "קונים שימורי פירות. במה לבחור?",
    "image": "assets/images/q24_canned_fruit.png",
    "options": [
      {"id": "A", "text": "פירות בסירופ מתוק", "is_correct": false},
      {
        "id": "B",
        "text": "פירות במים או במיץ טבעי",
        "is_correct": true
      }
    ],
    "explanation":
        "שימורי פירות בסירופ מרוכז מכילים יותר אשלגן. בחרו תמיד פירות משומרים במים או במיץ טבעי, וסננו את הנוזל לפני ההגשה."
  },

  // ============================================
  // LEVEL 4: Processed Foods (Difficulty 4/5)
  // ============================================
  {
    "id": 25,
    "level": 4,
    "topic": "מזון מעובד",
    "question_text": "איזו מנה בשרית בטוחה יותר?",
    "image": "assets/images/q25_meat.png",
    "options": [
      {
        "id": "A",
        "text": "נקניקיות או המבורגר מעובד",
        "is_correct": false
      },
      {"id": "B", "text": "חזה עוף טרי או דג טרי", "is_correct": true}
    ],
    "explanation":
        "בשר מעובד כמו נקניקיות והמבורגר קפוא מכיל תוספי פוספט. עוף ודג טריים, שאינם מעובדים, הם בחירה מצוינת."
  },
  {
    "id": 26,
    "level": 4,
    "topic": "מזון מעובד",
    "question_text": "איזו גבינה עדיפה לכריך?",
    "image": "assets/images/q26_cheese.png",
    "options": [
      {"id": "A", "text": "פרוסות גבינה מעובדת", "is_correct": false},
      {"id": "B", "text": "גבינה לבנה או קוטג'", "is_correct": true}
    ],
    "explanation":
        "גבינות מעובדות (כמו פרוסות להמבורגר) עשירות בתוספי זרחן. גבינה לבנה וקוטג' מכילות פחות זרחן."
  },
  {
    "id": 27,
    "level": 4,
    "topic": "מזון מעובד",
    "question_text":
        "אנחנו אופים עוגה. באיזה חומר התפחה עדיף להשתמש?",
    "image": "assets/images/q27_baking.png",
    "options": [
      {
        "id": "A",
        "text": "סודה לשתייה (סודיום ביקרבונט)",
        "is_correct": true
      },
      {"id": "B", "text": "אבקת אפייה", "is_correct": false}
    ],
    "explanation":
        "אבקת אפייה עשירה בתוספי פוספט. מומלץ להשתמש בסודה לשתייה או קרם טרטר כחלופה ללא פוספט."
  },
  {
    "id": 28,
    "level": 4,
    "topic": "מזון מעובד",
    "question_text": "האם מותר לאכול אגוזים וגרעינים?",
    "image": "assets/images/q28_nuts.png",
    "options": [
      {"id": "A", "text": "כן, זה בריא מאוד לכולם", "is_correct": false},
      {"id": "B", "text": "יש להגביל מאוד", "is_correct": true}
    ],
    "explanation":
        "אגוזים, גרעינים, טחינה ושקדים עשירים באופן טבעי בזרחן ואשלגן, ולכן יש להגביל את צריכתם בהתאם להמלצת הדיאטנית."
  },
  {
    "id": 29,
    "level": 4,
    "topic": "מזון מעובד",
    "question_text": "איזה מקור לשומן בריא בטוח יותר לשימוש יומיומי?",
    "image": "assets/images/q29_avocado_vs_oil.png",
    "options": [
      {"id": "A", "text": "אבוקדו או גוואקמולי", "is_correct": false},
      {"id": "B", "text": "שמן זית או גבינת שמנת", "is_correct": true}
    ],
    "explanation":
        "למרות שאבוקדו מכיל שומנים בריאים, הוא אחד הפירות העשירים ביותר באשלגן שיש. שמן זית וגבינת שמנת מספקים שומנים בריאים ללא סכנת אשלגן."
  },
  {
    "id": 30,
    "level": 4,
    "topic": "מזון מעובד",
    "question_text": "לארוחת ערב מהירה, מה עדיף?",
    "image": "assets/images/q30_dinner.png",
    "options": [
      {
        "id": "A",
        "text": "ארוחה קפואה מוכנה מהמקפיא",
        "is_correct": false
      },
      {
        "id": "B",
        "text": "ארוחה ביתית פשוטה מרכיבים טריים",
        "is_correct": true
      }
    ],
    "explanation":
        "ארוחות קפואות מוכנות עמוסות בתוספי זרחן לשימור הצבע, המרקם וחיי המדף. בישול ביתי מרכיבים טריים הוא תמיד עדיף."
  },
  {
    "id": 31,
    "level": 4,
    "topic": "מזון מעובד",
    "question_text": "מה עדיף להוסיף כממרח או רוטב לכריך או פסטה?",
    "image": "assets/images/q31_tomato_vs_pepper.png",
    "options": [
      {"id": "A", "text": "קטשופ או רסק עגבניות", "is_correct": false},
      {"id": "B", "text": "ממרח פלפלים אדומים קלויים", "is_correct": true}
    ],
    "explanation":
        "עגבניות עשירות מאוד באשלגן באופן טבעי, וריכוזן ברטבים או קטשופ מכפיל את הכמות. פלפלים אדומים נותנים צבע וטעם עשיר דומים, אך עם הרבה פחות אשלגן!"
  },
  {
    "id": 32,
    "level": 4,
    "topic": "מזון מעובד",
    "question_text": "כיצד עדיף לתבל את המזון של הילד במקום מלח רגיל?",
    "image": "assets/images/q32_salt_sub.png",
    "options": [
      {"id": "A", "text": "תחליפי מלח \"דלי נתרן\"", "is_correct": false},
      {"id": "B", "text": "עשבי תיבול, תבלינים, מיץ לימון או אבקת שום", "is_correct": true}
    ],
    "explanation":
        "תחליפי מלח מסחריים \"דלי נתרן\" מחליפים את הנתרן באשלגן כלורי, שעלול להיות רעיל ומסוכן ביותר לחולי כליות. עשבי תיבול ולימון מעניקים טעם נהדר ובטוח."
  },

  // ============================================
  // LEVEL 5: Labels & Additives (Difficulty 5/5)
  // ============================================
  {
    "id": 33,
    "level": 5,
    "topic": "תוויות ותוספים",
    "question_text":
        "ראיתם את המילה 'פוספט' (Phosphate) ברכיבים. מה עושים?",
    "image": "assets/images/q33_phosphate.png",
    "options": [
      {"id": "A", "text": "קונים, זה מינרל חשוב", "is_correct": false},
      {"id": "B", "text": "מחזירים למדף", "is_correct": true}
    ],
    "explanation":
        "תוספי פוספט (זרחן) במזון מעובד נספגים בגוף בקלות רבה (עד 100%) ומזיקים לכליות ולעצמות. יש להימנע מהם."
  },
  {
    "id": 34,
    "level": 5,
    "topic": "תוויות ותוספים",
    "question_text": "זהו את הרכיב המסוכן: E450",
    "image": "assets/images/q34_e450.png",
    "options": [
      {"id": "A", "text": "צבע מאכל טבעי", "is_correct": false},
      {"id": "B", "text": "תוסף זרחן (דיפוספט)", "is_correct": true}
    ],
    "explanation":
        "E450 הוא דיפוספט — תוסף זרחן שנספג בגוף במלואו. תוספים ממשפחת E450-E452 הם תוספי פוספט שיש להימנע מהם."
  },
  {
    "id": 35,
    "level": 5,
    "topic": "תוויות ותוספים",
    "question_text": "זהו את הרכיב המסוכן: E202",
    "image": "assets/images/q35_e202.png",
    "options": [
      {"id": "A", "text": "אשלגן סורבט (חומר משמר)", "is_correct": true},
      {"id": "B", "text": "סוכר ענבים", "is_correct": false}
    ],
    "explanation":
        "E202 הוא 'אשלגן סורבט', חומר משמר נפוץ שמוסיף כמות גדולה של אשלגן למזון."
  },
  {
    "id": 36,
    "level": 5,
    "topic": "תוויות ותוספים",
    "question_text":
        "כמה זרחן הגוף סופג מתוספי זרחן במזון מעובד?",
    "image": "assets/images/q36_absorption.png",
    "options": [
      {"id": "A", "text": "כ-20% עד 40% בלבד", "is_correct": false},
      {"id": "B", "text": "עד 100% — כמעט הכל נספג", "is_correct": true}
    ],
    "explanation":
        "תוספי זרחן במזון מעובד נספגים כמעט במלואם (עד 100%), לעומת 20-40% בלבד מזרחן צמחי טבעי. לכן הגבלת מזון מעובד היא הצעד הראשון והחשוב ביותר."
  },
  {
    "id": 37,
    "level": 5,
    "topic": "תוויות ותוספים",
    "question_text": "מתי הילד צריך לקחת תרופת קושר זרחן?",
    "image": "assets/images/q37_binder_med.png",
    "options": [
      {
        "id": "A",
        "text": "על קיבה ריקה, בין הארוחות",
        "is_correct": false
      },
      {
        "id": "B",
        "text": "יחד עם האוכל, בזמן הארוחה או החטיף",
        "is_correct": true
      }
    ],
    "explanation":
        "קושרי זרחן חייבים להילקח יחד עם האוכל, לא לפני ולא אחרי. הם פועלים על ידי קשירת הזרחן שבמזון לפני שהגוף סופג אותו."
  },
  {
    "id": 38,
    "level": 5,
    "topic": "תוויות ותוספים",
    "question_text": "ראיתם E341 על תווית יוגורט. מהו?",
    "image": "assets/images/q38_e341.png",
    "options": [
      {"id": "A", "text": "תוסף סידן — טוב לעצמות", "is_correct": false},
      {
        "id": "B",
        "text": "סידן פוספט — תוסף זרחן שיש להימנע ממנו",
        "is_correct": true
      }
    ],
    "explanation":
        "E341 הוא סידן פוספט, תוסף זרחן. למרות שהשם מכיל 'סידן', תכולת הזרחן שלו מזיקה לחולי כליות. החזירו את המוצר למדף."
  },
  {
    "id": 39,
    "level": 5,
    "topic": "תוויות ותוספים",
    "question_text": "מאיזה מקור הגוף סופג הכי פחות זרחן?",
    "image": "assets/images/q39_plant_protein.png",
    "options": [
      {"id": "A", "text": "עוף טרי (מקור מן החי)", "is_correct": false},
      {
        "id": "B",
        "text": "עדשים ושעועית (מקור מן הצומח)",
        "is_correct": true
      }
    ],
    "explanation":
        "זרחן ממקור צמחי נספג בשיעור של 20-40% בלבד, לעומת 40-60% ממקור מן החי. לכן לחולי כליות חלבון צמחי עדיף כשאפשר."
  },
  {
    "id": 40,
    "level": 5,
    "topic": "תוויות ותוספים",
    "question_text":
        "חלק מהתרופות מכילות אשלגן. מה חשוב לעשות?",
    "image": "assets/images/q40_medications.png",
    "options": [
      {
        "id": "A",
        "text": "לא צריך לדאוג, תרופות הן בטוחות תמיד",
        "is_correct": false
      },
      {
        "id": "B",
        "text": "לוודא שהרופא יודע על כל התרופות והתוספים שהילד לוקח",
        "is_correct": true
      }
    ],
    "explanation":
        "תרופות מסוימות ותוספי תזונה מכילים אשלגן. חשוב מאוד שהרופא המטפל יהיה מודע לכל התרופות, הויטמינים והתוספים שהילד נוטל."
  },
];

// Level configuration - Hebrew titles
const Map<int, String> levelTitles = {
  1: "ארוחת בוקר ובסיס",
  2: "טכניקות בישול",
  3: "חטיפים ושתייה",
  4: "מזון מעובד",
  5: "תוויות ותוספים",
};

// Questions per level
const int questionsPerLevel = 8;

// Points to unlock next level (need 6 out of 8 correct = 75%)
const int pointsToUnlock = 6;
