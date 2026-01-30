// Kidni - Educational Quiz Data
// Hebrew questions about nutrition for children on dialysis
// Based on The Phosphate Poster and The Potassium Guide

const List<Map<String, dynamic>> rawQuestions = [
  // ============================================
  // LEVEL 1: Breakfast & Basics (4 questions)
  // ============================================
  {
    "id": 1,
    "level": 1,
    "topic": "ארוחת בוקר ובסיס",
    "question_text": "איזה לחם עדיף לכריך לבית הספר?",
    "options": [
      {
        "id": "A",
        "text": "לחם מלא או שיפון",
        "is_correct": false,
        "image": "assets/images/whole wheat bread.png"
      },
      {
        "id": "B",
        "text": "לחם לבן או פיתה מקמח לבן",
        "is_correct": true,
        "image": "assets/images/sliced white bread.png"
      }
    ],
    "explanation":
        "לפי המדריך, לחם לבן, פיתות ולחמניות מקמח לבן מכילים פחות זרחן ואשלגן מאשר לחם מלא ודגנים מלאים."
  },
  {
    "id": 2,
    "level": 1,
    "topic": "ארוחת בוקר ובסיס",
    "question_text": "מה עדיף למרוח על הלחם?",
    "options": [
      {
        "id": "A",
        "text": "ממרח שוקולד או חמאת אגוזים",
        "is_correct": false,
        "image": "assets/images/bowl of mixed nuts and almonds.png"
      },
      {
        "id": "B",
        "text": "ריבה, דבש או גבינת שמנת",
        "is_correct": true,
        "image": "assets/images/strawberry jam jar.png"
      }
    ],
    "explanation":
        "ממרחי שוקולד, טחינה וחמאת אגוזים עשירים מאוד בזרחן ואשלגן. ריבה, דבש ומרמלדה הם בחירה בטוחה יותר."
  },
  {
    "id": 3,
    "level": 1,
    "topic": "ארוחת בוקר ובסיס",
    "question_text": "באילו דגני בוקר כדאי לבחור?",
    "options": [
      {
        "id": "A",
        "text": "דגנים עם שוקולד או אגוזים",
        "is_correct": false,
        "image": "assets/images/bowl of mixed nuts and almonds.png"
      },
      {
        "id": "B",
        "text": "קורנפלקס רגיל או פצפוצי אורז",
        "is_correct": true,
        "image": "assets/images/bowl of white popcorn.png"
      }
    ],
    "explanation":
        "דגני בוקר המבוססים על שוקולד או אגוזים מכילים רמות גבוהות של זרחן ואשלגן. קורנפלקס ופצפוצי אורז הם דלי אשלגן."
  },
  {
    "id": 4,
    "level": 1,
    "topic": "ארוחת בוקר ובסיס",
    "question_text": "בחרו את המשקה הידידותי לכליות:",
    "options": [
      {
        "id": "A",
        "text": "משקה שוקו",
        "is_correct": false,
        "image": "assets/images/Chocolate milk.png"
      },
      {
        "id": "B",
        "text": "מים או משקה תוסס בצבע בהיר",
        "is_correct": true,
        "image": "assets/images/glass of fresh water.png"
      }
    ],
    "explanation":
        "משקאות שוקו עשירים בזרחן. מים או משקאות תוססים בצבעים בהירים (כמו לימונדה) עדיפים על פני משקאות כהים."
  },

  // ============================================
  // LEVEL 2: Cooking Skills (4 questions)
  // ============================================
  {
    "id": 5,
    "level": 2,
    "topic": "טכניקות בישול",
    "question_text": "מהו השלב הראשון והחשוב לפני בישול תפוחי אדמה?",
    "options": [
      {
        "id": "A",
        "text": "שטיפה קלה במים",
        "is_correct": false,
        "image": "assets/images/glass of fresh water.png"
      },
      {
        "id": "B",
        "text": "קילוף וחיתוך לחתיכות קטנות",
        "is_correct": true,
        "image": "assets/images/cutting raw potatoes on cutting board.jpg"
      }
    ],
    "explanation":
        "קילוף וחיתוך מגדילים את שטח הפנים ומאפשרים לאשלגן 'לצאת' מתפוח האדמה אל המים בזמן הבישול."
  },
  {
    "id": 6,
    "level": 2,
    "topic": "טכניקות בישול",
    "question_text": "מהי שיטת 'ההרתחה הכפולה'?",
    "options": [
      {
        "id": "A",
        "text": "להרתיח, לזרוק את המים, למלא מים חדשים ולהרתיח שוב",
        "is_correct": true,
        "image": "assets/images/boiling water.png"
      },
      {
        "id": "B",
        "text": "לבשל במיקרוגל ואז בתנור",
        "is_correct": false,
        "image": "assets/images/homemade french fries oven baked.png"
      }
    ],
    "explanation":
        "החלפת המים באמצע הבישול (הרתחה כפולה) היא השיטה היעילה ביותר להפחתת כמות האשלגן בתפוחי האדמה."
  },
  {
    "id": 7,
    "level": 2,
    "topic": "טכניקות בישול",
    "question_text": "האם מותר להשתמש במי הבישול של הירקות להכנת רוטב?",
    "options": [
      {
        "id": "A",
        "text": "כן, זה מוסיף טעם",
        "is_correct": false,
        "image": "assets/images/boiling water.png"
      },
      {
        "id": "B",
        "text": "לא, יש לזרוק אותם",
        "is_correct": true,
        "image": "assets/images/draining boiled vegetables in colander.png"
      }
    ],
    "explanation":
        "אין להשתמש במי הבישול להכנת רטבים או מרקים, כיוון שהם מכילים את האשלגן שיצא מהירקות."
  },
  {
    "id": 8,
    "level": 2,
    "topic": "טכניקות בישול",
    "question_text": "איזה צ'יפס מותר לילד לאכול?",
    "options": [
      {
        "id": "A",
        "text": "צ'יפס קפוא תעשייתי",
        "is_correct": false,
        "image": "assets/images/bowl of white popcorn.png"
      },
      {
        "id": "B",
        "text": "צ'יפס ביתי שעבר הרתחה במים",
        "is_correct": true,
        "image": "assets/images/homemade french fries oven baked.png"
      }
    ],
    "explanation":
        "צ'יפס ביתי שהורתח במים לפני הטיגון הוא בטוח יותר. מוצרים תעשייתיים כמו וופלי תפוחי אדמה וצ'יפס קפוא עשירים בזרחן ואשלגן."
  },

  // ============================================
  // LEVEL 3: Snacks & Drinks (4 questions)
  // ============================================
  {
    "id": 9,
    "level": 3,
    "topic": "חטיפים ושתייה",
    "question_text": "איזה פרי נחשב דל באשלגן?",
    "options": [
      {
        "id": "A",
        "text": "פירות יבשים ובננות",
        "is_correct": false,
        "image": "assets/images/dried fruits.png"
      },
      {
        "id": "B",
        "text": "תפוחים (טריים)",
        "is_correct": true,
        "image": "assets/images/fresh red apple.png"
      }
    ],
    "explanation":
        "תפוחים מופיעים ברשימת המזונות המכילים פחות אשלגן, לעומת פירות יבשים ומוצרי פירות מרוכזים שעשירים באשלגן."
  },
  {
    "id": 10,
    "level": 3,
    "topic": "חטיפים ושתייה",
    "question_text": "בא לי משהו מלוח! במה נבחר?",
    "options": [
      {
        "id": "A",
        "text": "שקית חטיף צ'יפס",
        "is_correct": false,
        "image": "assets/images/cutting raw potatoes on cutting board.jpg"
      },
      {
        "id": "B",
        "text": "פופקורן ללא מלח או קרקרים מקמח לבן",
        "is_correct": true,
        "image": "assets/images/bowl of white popcorn.png"
      }
    ],
    "explanation":
        "חטיפי צ'יפס תעשייתיים עמוסים באשלגן. פופקורן ללא מלח וקרקרים מקמח לבן הם חלופות דלות אשלגן."
  },
  {
    "id": 11,
    "level": 3,
    "topic": "חטיפים ושתייה",
    "question_text": "איזה ממתק בטוח יותר לכליות?",
    "options": [
      {
        "id": "A",
        "text": "שוקולד חלב",
        "is_correct": false,
        "image": "assets/images/Chocolate bar.png"
      },
      {
        "id": "B",
        "text": "מרשמלו או סוכריות גומי",
        "is_correct": true,
        "image": "assets/images/colorful marshmallows and gummy candies.png"
      }
    ],
    "explanation":
        "שוקולד עשיר בזרחן ואשלגן. מרשמלו, סוכריות גומי וסוכריות קשות הן דלות במינרלים אלו."
  },
  {
    "id": 12,
    "level": 3,
    "topic": "חטיפים ושתייה",
    "question_text": "איזו שתייה עדיפה בארוחה חגיגית?",
    "options": [
      {
        "id": "A",
        "text": "משקה תוסס כהה (כמו קולה)",
        "is_correct": false,
        "image": "assets/images/cola drink.png"
      },
      {
        "id": "B",
        "text": "לימונדה או משקה תוסס בהיר",
        "is_correct": true,
        "image": "assets/images/lemonade .png"
      }
    ],
    "explanation":
        "משקאות כהים מכילים לרוב תוספי פוספט (זרחן) מזיקים. משקאות בהירים כמו לימונדה עדיפים."
  },

  // ============================================
  // LEVEL 4: Processed Foods (4 questions)
  // ============================================
  {
    "id": 13,
    "level": 4,
    "topic": "מזון מעובד",
    "question_text": "איזו מנה בשרית בטוחה יותר?",
    "options": [
      {
        "id": "A",
        "text": "נקניקיות או המבורגר מעובד",
        "is_correct": false,
        "image": "assets/images/Hot dogs.png"
      },
      {
        "id": "B",
        "text": "חזה עוף טרי או דג טרי",
        "is_correct": true,
        "image": "assets/images/raw chicken breast fillet.png"
      }
    ],
    "explanation":
        "בשר מעובד כמו נקניקיות והמבורגר קפוא מכיל תוספי פוספט. עוף ודג טריים, שאינם מעובדים, הם בחירה מצוינת."
  },
  {
    "id": 14,
    "level": 4,
    "topic": "מזון מעובד",
    "question_text": "איזו גבינה עדיפה לכריך?",
    "options": [
      {
        "id": "A",
        "text": "פרוסות גבינה מעובדת",
        "is_correct": false,
        "image": "assets/images/Processed cheese slices.png"
      },
      {
        "id": "B",
        "text": "גבינה לבנה או קוטג'",
        "is_correct": true,
        "image": "assets/images/bowl of cottage cheese with spoon.png"
      }
    ],
    "explanation":
        "גבינות מעובדות (כמו פרוסות להמבורגר) עשירות בתוספי זרחן. גבינה לבנה וקוטג' מכילות פחות זרחן."
  },
  {
    "id": 15,
    "level": 4,
    "topic": "מזון מעובד",
    "question_text": "אנחנו אופים עוגה. באיזה חומר התפחה עדיף להשתמש?",
    "options": [
      {
        "id": "A",
        "text": "סודה לשתייה (סודיום ביקרבונט)",
        "is_correct": true,
        "image": "assets/images/baking soda powder.png"
      },
      {
        "id": "B",
        "text": "אבקת אפייה",
        "is_correct": false,
        "image": "assets/images/salt shaker on table.png"
      }
    ],
    "explanation":
        "אבקת אפייה עשירה בתוספי פוספט. מומלץ להשתמש בסודה לשתייה או קרם טרטר כחלופה ללא פוספט."
  },
  {
    "id": 16,
    "level": 4,
    "topic": "מזון מעובד",
    "question_text": "האם מותר לאכול אגוזים וגרעינים?",
    "options": [
      {
        "id": "A",
        "text": "כן, זה בריא מאוד לכולם",
        "is_correct": false,
        "image": "assets/images/bowl of mixed nuts and almonds.png"
      },
      {
        "id": "B",
        "text": "יש להגביל מאוד",
        "is_correct": true,
        "image": "assets/images/fresh red apple.png"
      }
    ],
    "explanation":
        "אגוזים, גרעינים, טחינה ושקדים עשירים באופן טבעי בזרחן ואשלגן, ולכן יש להגביל את צריכתם בהתאם להמלצת הדיאטנית."
  },

  // ============================================
  // LEVEL 5: Labels & Additives (4 questions)
  // ============================================
  {
    "id": 17,
    "level": 5,
    "topic": "תוויות ותוספים",
    "question_text": "ראיתם את המילה 'פוספט' (Phosphate) ברכיבים. מה עושים?",
    "options": [
      {
        "id": "A",
        "text": "קונים, זה מינרל חשוב",
        "is_correct": false,
        "image": "assets/images/strawberry jam jar.png"
      },
      {
        "id": "B",
        "text": "מחזירים למדף",
        "is_correct": true,
        "image": "assets/images/person reading food ingredient label cartoon.jpg"
      }
    ],
    "explanation":
        "תוספי פוספט (זרחן) במזון מעובד נספגים בגוף בקלות רבה ומזיקים לכליות ולעצמות. יש להימנע מהם."
  },
  {
    "id": 18,
    "level": 5,
    "topic": "תוויות ותוספים",
    "question_text": "האם תחליפי מלח (דל נתרן) הם בטוחים?",
    "options": [
      {
        "id": "A",
        "text": "כן, זה בריא ללב",
        "is_correct": false,
        "image": "assets/images/salt shaker on table.png"
      },
      {
        "id": "B",
        "text": "לא, הם לרוב מכילים המון אשלגן",
        "is_correct": true,
        "image": "assets/images/person reading food ingredient label cartoon.jpg"
      }
    ],
    "explanation":
        "תחליפי מלח רבים מחליפים את הנתרן ב'אשלגן כלורי', שהוא מסוכן מאוד לילדים המוגבלים באשלגן."
  },
  {
    "id": 19,
    "level": 5,
    "topic": "תוויות ותוספים",
    "question_text": "זהו את הרכיב המסוכן: E450",
    "options": [
      {
        "id": "A",
        "text": "צבע מאכל טבעי",
        "is_correct": false,
        "image": "assets/images/colorful marshmallows and gummy candies.png"
      },
      {
        "id": "B",
        "text": "תוסף זרחן (פוספט)",
        "is_correct": true,
        "image": "assets/images/E450.jpg"
      }
    ],
    "explanation":
        "תוספים ממשפחת ה-E450 הם תוספי פוספט (כמו אשלגן פוליפוספט) שיש להימנע מהם."
  },
  {
    "id": 20,
    "level": 5,
    "topic": "תוויות ותוספים",
    "question_text": "זהו את הרכיב המסוכן: E202",
    "options": [
      {
        "id": "A",
        "text": "אשלגן סורבט (חומר משמר)",
        "is_correct": true,
        "image": "assets/images/E202.jpg"
      },
      {
        "id": "B",
        "text": "סוכר ענבים",
        "is_correct": false,
        "image": "assets/images/strawberry jam jar.png"
      }
    ],
    "explanation":
        "E202 הוא 'אשלגן סורבט', חומר משמר נפוץ שמוסיף כמות גדולה של אשלגן למזון."
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
const int questionsPerLevel = 4;

// Points to unlock next level (need 3 out of 4 correct)
const int pointsToUnlock = 3;
