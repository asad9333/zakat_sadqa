import 'package:flutter/material.dart';
import 'app_state.dart';

const _t = {
  'title': ['Zakat & Sadqa', 'زکوٰۃ و صدقہ'],
  'login': ['Login', 'لاگ اِن'], 'register': ['Register', 'رجسٹر'], 'newuser': ['New user? Register', 'نیا صارف؟ رجسٹر'], 'have': ['Have account? Login', 'اکاؤنٹ ہے؟ لاگ اِن'],
  'name': ['Full name', 'نام'], 'email': ['Email or phone', 'ای میل یا فون'], 'password': ['Password (min 6)', 'پاس ورڈ (کم از کم 6)'],
  'fill': ['Fill all fields', 'تمام خانے پُر کریں'], 'exists': ['Already registered', 'پہلے سے رجسٹر ہے'], 'wrong': ['Wrong login or password', 'غلط لاگ اِن یا پاس ورڈ'],
  'calculate': ['Calculate', 'حساب'], 'payments': ['Payments', 'ادائیگیاں'], 'summary': ['Summary', 'خلاصہ'], 'islamic': ['Islamic', 'اسلامی'], 'admin': ['Admin', 'ایڈمن'],
  'cash': ['Cash in hand', 'نقد رقم'], 'bank': ['Bank / wallets', 'بینک / والٹ'], 'gw': ['Gold weight', 'سونے کا وزن'], 'carat': ['Carat', 'کیرٹ'], 'sw': ['Silver weight', 'چاندی کا وزن'],
  'biz': ['Business stock', 'کاروباری مال'], 'inv': ['Investments', 'سرمایہ کاری'], 'rec': ['Money receivable', 'وصول طلب رقم'], 'liab': ['Debts payable', 'قابلِ ادا قرض'],
  'tola': ['Tola', 'تولہ'], 'gram': ['Gram', 'گرام'], 'jewel': ['Include jewellery', 'زیورات شامل کریں'], 'silverBasis': ['Silver Nisab (52.5 tola)', 'چاندی کا نصاب (52.5 تولہ)'],
  'calc': ['Calculate Zakat', 'زکوٰۃ نکالیں'], 'gold': ['Gold', 'سونا'], 'silver': ['Silver', 'چاندی'], 'total': ['Total assets', 'کل اثاثے'], 'net': ['Net wealth', 'خالص دولت'],
  'nisab': ['Nisab used', 'نصاب'], 'due': ['Zakat payable', 'واجب زکوٰۃ'], 'notdue': ['Zakat not due. Needed to reach Nisab:', 'زکوٰۃ واجب نہیں۔ نصاب تک مزید درکار:'],
  'paid': ['Paid', 'ادا شدہ'], 'left': ['Remaining', 'باقی'], 'done': ['Zakat completed for this year', 'اس سال کی زکوٰۃ مکمل'], 'ratesMissing': ['Admin must set gold/silver rates first', 'پہلے ایڈمن سونے/چاندی کے نرخ درج کرے'],
  'rateDate': ['Rates dated', 'نرخ کی تاریخ'], 'disclaimer': ['Results are guidance only. Confirm with a scholar.', 'نتائج صرف رہنمائی ہیں۔ عالمِ دین سے تصدیق کریں۔'],
  'add': ['Payment', 'ادائیگی'], 'amount': ['Amount', 'رقم'], 'receiver': ['Receiver', 'وصول کنندہ'], 'note': ['Note', 'نوٹ'], 'save': ['Save', 'محفوظ کریں'], 'cancel': ['Cancel', 'منسوخ'],
  'search': ['Search', 'تلاش'], 'none': ['Nothing yet', 'کچھ نہیں'], 'yearly': ['Yearly Zakat & Sadqa', 'سالانہ زکوٰۃ و صدقہ'], 'remind': ['Reminder: unpaid Zakat', 'یاد دہانی: زکوٰۃ باقی ہے'],
  'goldRate': ['Gold rate per tola (PKR)', 'سونے کا نرخ فی تولہ'], 'silverRate': ['Silver rate per tola (PKR)', 'چاندی کا نرخ فی تولہ'], 'saveRates': ['Save rates', 'نرخ محفوظ کریں'], 'audit': ['Audit log', 'آڈٹ لاگ'],
  'stats': ['Users / Calculations / Payments', 'صارفین / حساب / ادائیگیاں'], 'tasbeeh': ['Tasbeeh', 'تسبیح'], 'reset': ['Reset', 'ری سیٹ'], 'fitrana': ['Fitrana', 'فطرانہ'],
  'persons': ['Persons', 'افراد'], 'wheat': ['Wheat price / kg', 'گندم فی کلو'], 'fitCalc': ['Fitrana (2 kg wheat each)', 'فطرانہ (فی کس 2 کلو گندم)'],
  'learn': ['Learn', 'معلومات'], 'learnText': ['Zakat is 2.5% of net wealth held for one lunar year, if it reaches Nisab (52.5 tola silver or 7.5 tola gold). Recipients: the poor, the needy, zakat workers, those in debt, travellers and others in Quran 9:60. Sadqa is voluntary. Fitrana is paid before Eid ul Fitr.', 'زکوٰۃ ایک قمری سال گزرنے پر نصاب (52.5 تولہ چاندی یا 7.5 تولہ سونا) کے برابر خالص دولت کا 2.5% ہے۔ مستحقین: فقراء، مساکین، عاملین، مقروض، مسافر اور سورۃ التوبہ (9:60) کے دیگر۔ صدقہ نفلی ہے۔ فطرانہ عید الفطر سے پہلے ادا کیا جاتا ہے۔'],
  'duas': ['Duas', 'دعائیں'],
};
String tr(String k) => (_t[k] ?? [k, k])[app.ur ? 1 : 0];
String fmt(num v) => v.round().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
Widget live(Widget Function() b) => ListenableBuilder(listenable: app, builder: (_, __) => b());
void snack(BuildContext c, String m) => ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));
