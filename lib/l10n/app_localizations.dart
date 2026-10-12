import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// Judul aplikasi
  ///
  /// In en, this message translates to:
  /// **'App Finance'**
  String get appTitle;

  /// Label navigasi Beranda
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Label navigasi Analisis
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navAnalytics;

  /// Label navigasi Dompet
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get navWallet;

  /// Label navigasi Profil
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Label total saldo di dashboard
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// Label pemasukan
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// Label pengeluaran
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// Label transaksi terbaru
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// Tombol lihat semua
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// Teks saat belum ada transaksi
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactions;

  /// Pesan selamat datang di auth
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Tombol login
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Label input email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label input kata sandi
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Tombol keluar
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Pesan konfirmasi keluar akun
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmation;

  /// Judul bagian detail pribadi
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// Subjudul bagian detail pribadi
  ///
  /// In en, this message translates to:
  /// **'Keep your information up to date'**
  String get personalDetailsSubtitle;

  /// Label nama lengkap
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Label nomor telepon
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Status email/nomor terverifikasi
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// Tombol edit detail profil
  ///
  /// In en, this message translates to:
  /// **'Edit Details'**
  String get editDetails;

  /// Judul pengaturan umum
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// Subjudul pengaturan umum
  ///
  /// In en, this message translates to:
  /// **'Your preferences and app settings'**
  String get generalSettingsSubtitle;

  /// Menu pengaturan bahasa
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Judul halaman pengaturan bahasa
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// Keterangan pemilihan bahasa
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language for the app'**
  String get chooseLanguageSubtitle;

  /// Judul dialog/halaman pilih bahasa
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Nama bahasa Indonesia
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// Nama bahasa Inggris
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Menu pengaturan tema
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Judul halaman pengaturan tema
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// Bagian tampilan tema
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Opsi mode terang
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Keterangan mode terang
  ///
  /// In en, this message translates to:
  /// **'Bright and clean look'**
  String get lightModeSubtitle;

  /// Opsi mode gelap
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Keterangan mode gelap
  ///
  /// In en, this message translates to:
  /// **'Easy on the eyes'**
  String get darkModeSubtitle;

  /// Opsi mengikuti sistem
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Keterangan opsi mengikuti sistem
  ///
  /// In en, this message translates to:
  /// **'Follows your phone settings'**
  String get systemDefaultSubtitle;

  /// Menu pengaturan notifikasi
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Status aktif
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// Status tidak aktif
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// Judul dialog sukses
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Tombol simpan
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Tombol batal
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Tombol hapus
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Tombol ubah
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Tombol coba lagi
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Teks saat memuat
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Tombol tambah dompet
  ///
  /// In en, this message translates to:
  /// **'Add Wallet'**
  String get addWallet;

  /// Informasi dompet
  ///
  /// In en, this message translates to:
  /// **'Wallet Information'**
  String get walletInformation;

  /// Nama dompet
  ///
  /// In en, this message translates to:
  /// **'Wallet Name'**
  String get walletName;

  /// Contoh nama dompet
  ///
  /// In en, this message translates to:
  /// **'e.g. Main Bank Account'**
  String get walletNameHint;

  /// Tipe dompet
  ///
  /// In en, this message translates to:
  /// **'Wallet Type'**
  String get walletType;

  /// Pilih tipe
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get selectType;

  /// Rekening bank
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get bankAccount;

  /// Dompet elektronik
  ///
  /// In en, this message translates to:
  /// **'E-Wallet'**
  String get eWallet;

  /// Uang tunai
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// Kartu kredit
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// Investasi
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get investment;

  /// Nomor rekening
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// Nomor kartu
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// Masa berlaku
  ///
  /// In en, this message translates to:
  /// **'Valid Thru'**
  String get validThru;

  /// CVV
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// Simpan dompet
  ///
  /// In en, this message translates to:
  /// **'Save Wallet'**
  String get saveWallet;

  /// Pesan sukses tambah dompet
  ///
  /// In en, this message translates to:
  /// **'Wallet has been added successfully'**
  String get walletAddedSuccess;

  /// Semua transaksi
  ///
  /// In en, this message translates to:
  /// **'All Transactions'**
  String get allTransactions;

  /// Dompet saya
  ///
  /// In en, this message translates to:
  /// **'My Wallets'**
  String get myWallets;

  /// Total pemasukan
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// Total pengeluaran
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalExpense;

  /// Arus kas bersih
  ///
  /// In en, this message translates to:
  /// **'Net Cash Flow'**
  String get netCashFlow;

  /// Tambah target keuangan
  ///
  /// In en, this message translates to:
  /// **'Add Financial Goal'**
  String get addFinancialGoal;

  /// Ubah target keuangan
  ///
  /// In en, this message translates to:
  /// **'Edit Financial Goal'**
  String get editFinancialGoal;

  /// Detail target
  ///
  /// In en, this message translates to:
  /// **'Goal Details'**
  String get goalDetails;

  /// Nama target
  ///
  /// In en, this message translates to:
  /// **'Goal Name'**
  String get goalName;

  /// Contoh nama target
  ///
  /// In en, this message translates to:
  /// **'e.g. New Car, Vacation'**
  String get goalNameHint;

  /// Jumlah saat ini opsional
  ///
  /// In en, this message translates to:
  /// **'Current Amount (Optional)'**
  String get currentAmountOptional;

  /// Jumlah target
  ///
  /// In en, this message translates to:
  /// **'Target Amount'**
  String get targetAmount;

  /// Simpan target
  ///
  /// In en, this message translates to:
  /// **'Save Goal'**
  String get saveGoal;

  /// Perbarui target
  ///
  /// In en, this message translates to:
  /// **'Update Goal'**
  String get updateGoal;

  /// Pesan sukses tambah target
  ///
  /// In en, this message translates to:
  /// **'Financial Goal has been added successfully'**
  String get goalAddedSuccess;

  /// Pesan sukses update target
  ///
  /// In en, this message translates to:
  /// **'Financial Goal has been updated successfully'**
  String get goalUpdatedSuccess;

  /// Tambah tagihan mendatang
  ///
  /// In en, this message translates to:
  /// **'Add Upcoming Bill'**
  String get addUpcomingBill;

  /// Detail tagihan
  ///
  /// In en, this message translates to:
  /// **'Bill Details'**
  String get billDetails;

  /// Deskripsi
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Contoh deskripsi tagihan
  ///
  /// In en, this message translates to:
  /// **'e.g. Netflix Subscription, Rent'**
  String get descriptionHint;

  /// Tanggal
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Pilih tanggal
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Harga / Jumlah tagihan
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Simpan tagihan
  ///
  /// In en, this message translates to:
  /// **'Save Bill'**
  String get saveBill;

  /// Pesan sukses tambah tagihan
  ///
  /// In en, this message translates to:
  /// **'Upcoming Bill has been added successfully'**
  String get billAddedSuccess;

  /// Pesan validasi form belum lengkap
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillRequiredFields;

  /// Target keuangan
  ///
  /// In en, this message translates to:
  /// **'Financial Goals'**
  String get financialGoals;

  /// Tagihan mendatang
  ///
  /// In en, this message translates to:
  /// **'Upcoming Bills'**
  String get upcomingBills;

  /// Semua tagihan mendatang
  ///
  /// In en, this message translates to:
  /// **'All Upcoming Bills'**
  String get allUpcomingBills;

  /// Semua target keuangan
  ///
  /// In en, this message translates to:
  /// **'All Financial Goals'**
  String get allFinancialGoals;

  /// Salam selamat siang
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// Pemasukan bulan ini
  ///
  /// In en, this message translates to:
  /// **'income this month'**
  String get incomeThisMonth;

  /// Pengeluaran bulan ini
  ///
  /// In en, this message translates to:
  /// **'expense this month'**
  String get expenseThisMonth;

  /// Bulan ini
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// Total aset
  ///
  /// In en, this message translates to:
  /// **'Total Assets'**
  String get totalAssets;

  /// Total hutang
  ///
  /// In en, this message translates to:
  /// **'Total Debt'**
  String get totalDebt;

  /// Kekayaan bersih
  ///
  /// In en, this message translates to:
  /// **'Net Worth'**
  String get netWorth;

  /// Distribusi saldo
  ///
  /// In en, this message translates to:
  /// **'Balance Distribution'**
  String get balanceDistribution;

  /// Tidak ada data
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// Jumlah dompet
  ///
  /// In en, this message translates to:
  /// **'wallets'**
  String get walletsCount;

  /// Transfer
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// Transaksi
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// Arus bersih
  ///
  /// In en, this message translates to:
  /// **'Net Flow'**
  String get netFlow;

  /// Hari ini
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Kemarin
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Belum ada transaksi
  ///
  /// In en, this message translates to:
  /// **'No Transactions Yet'**
  String get noTransactionsYet;

  /// Keterangan belum ada transaksi pada dompet
  ///
  /// In en, this message translates to:
  /// **'Transactions made with this wallet will appear here.'**
  String get noTransactionsDescription;

  /// Informasi transaksi
  ///
  /// In en, this message translates to:
  /// **'Transaction Information'**
  String get transactionInformation;

  /// Merchant
  ///
  /// In en, this message translates to:
  /// **'Merchant'**
  String get merchant;

  /// Metode pembayaran
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// ID Transaksi
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// Waktu
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Catatan
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Jatuh tempo hari ini
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// Jatuh tempo dalam x hari
  ///
  /// In en, this message translates to:
  /// **'Due in {days} days'**
  String dueInDays(int days);

  /// Riwayat transaksi
  ///
  /// In en, this message translates to:
  /// **'Transactions History'**
  String get transactionsHistory;

  /// Semua transaksi modal judul
  ///
  /// In en, this message translates to:
  /// **'All Transactions'**
  String get allTransactionsTitle;

  /// Pemasukan vs Pengeluaran
  ///
  /// In en, this message translates to:
  /// **'Income vs Expense'**
  String get incomeVsExpense;

  /// Rincian pengeluaran
  ///
  /// In en, this message translates to:
  /// **'Expense Breakdown'**
  String get expenseBreakdown;

  /// Sumber pemasukan
  ///
  /// In en, this message translates to:
  /// **'Income Sources'**
  String get incomeSources;

  /// Perbandingan bulanan
  ///
  /// In en, this message translates to:
  /// **'Monthly Comparison'**
  String get monthlyComparison;

  /// Analisis arus kas
  ///
  /// In en, this message translates to:
  /// **'Cash Flow Analysis'**
  String get cashFlowAnalysis;

  /// Wawasan keuangan
  ///
  /// In en, this message translates to:
  /// **'Financial Insights'**
  String get financialInsights;

  /// Tabungan dan target
  ///
  /// In en, this message translates to:
  /// **'Savings & Goals'**
  String get savingsAndGoals;

  /// Tabungan bulanan
  ///
  /// In en, this message translates to:
  /// **'Monthly Savings'**
  String get monthlySavings;

  /// Tingkat tabungan
  ///
  /// In en, this message translates to:
  /// **'Savings Rate'**
  String get savingsRate;

  /// Contoh nominal saat ini
  ///
  /// In en, this message translates to:
  /// **'e.g. 1,000,000'**
  String get currentAmountHint;

  /// Contoh nominal target
  ///
  /// In en, this message translates to:
  /// **'e.g. 50,000,000'**
  String get targetAmountHint;

  /// Contoh nominal harga tagihan
  ///
  /// In en, this message translates to:
  /// **'e.g. 150,000'**
  String get priceHint;

  /// Subjudul halaman analisis
  ///
  /// In en, this message translates to:
  /// **'Track and understand your financial performance'**
  String get analyticsSubtitle;

  /// Perbandingan dengan periode lalu
  ///
  /// In en, this message translates to:
  /// **'vs last period'**
  String get vsLastPeriod;

  /// Judul filter analisis
  ///
  /// In en, this message translates to:
  /// **'Filter Analytics'**
  String get filterAnalytics;

  /// Rentang tanggal
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// Akun
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Terapkan filter
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get applyFilter;

  /// Minggu ini
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// 3 bulan terakhir
  ///
  /// In en, this message translates to:
  /// **'Last 3 Months'**
  String get last3Months;

  /// Tahun ini
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// Rentang kustom
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get customRange;

  /// Semua akun
  ///
  /// In en, this message translates to:
  /// **'All Accounts'**
  String get allAccounts;

  /// Pengeluaran menurun
  ///
  /// In en, this message translates to:
  /// **'Your spending decreased by {percentage}%'**
  String spendingDecreased(String percentage);

  /// Subjudul pengeluaran menurun
  ///
  /// In en, this message translates to:
  /// **'You spent {amount} less than last month.'**
  String spendingDecreasedSubtitle(String amount);

  /// Pemasukan meningkat
  ///
  /// In en, this message translates to:
  /// **'Income is growing'**
  String get incomeGrowing;

  /// Subjudul pemasukan meningkat
  ///
  /// In en, this message translates to:
  /// **'Your income increased by {percentage}% compared to last month.'**
  String incomeGrowingSubtitle(String percentage);

  /// Pengeluaran kategori tinggi
  ///
  /// In en, this message translates to:
  /// **'{category} spending is high'**
  String spendingHigh(String category);

  /// Subjudul pengeluaran tinggi
  ///
  /// In en, this message translates to:
  /// **'It represents {percentage}% of your monthly expenses.'**
  String spendingHighSubtitle(String percentage);

  /// Target berjalan baik
  ///
  /// In en, this message translates to:
  /// **'You\'re on track'**
  String get onTrack;

  /// Subjudul target berjalan baik
  ///
  /// In en, this message translates to:
  /// **'You saved {percentage}% of your total income this month.'**
  String onTrackSubtitle(String percentage);

  /// Lihat detail dompet
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// Hapus dompet
  ///
  /// In en, this message translates to:
  /// **'Delete Wallet'**
  String get deleteWallet;

  /// Konfirmasi hapus dompet
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this wallet? This action cannot be undone.'**
  String get deleteWalletConfirmation;

  /// Status sudah dihapus
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// Pesan sukses dompet dihapus
  ///
  /// In en, this message translates to:
  /// **'Wallet has been deleted successfully.'**
  String get walletDeletedSuccess;

  /// Dari total saldo
  ///
  /// In en, this message translates to:
  /// **'of total'**
  String get ofTotal;

  /// Aktivitas terakhir dompet
  ///
  /// In en, this message translates to:
  /// **'Last activity'**
  String get lastActivity;

  /// Judul dompet kosong
  ///
  /// In en, this message translates to:
  /// **'Your Wallet is Empty'**
  String get emptyWallet;

  /// Keterangan dompet kosong
  ///
  /// In en, this message translates to:
  /// **'Add your first wallet to start managing your finances.'**
  String get emptyWalletSubtitle;

  /// Subjudul halaman dompet
  ///
  /// In en, this message translates to:
  /// **'Manage your money in one place'**
  String get walletSubtitle;

  /// Saldo
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Riwayat saldo
  ///
  /// In en, this message translates to:
  /// **'Balance History'**
  String get balanceHistory;

  /// Kategori transaksi
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Tombol OK
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Tombol tutup
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Tombol mengerti
  ///
  /// In en, this message translates to:
  /// **'Understand'**
  String get understand;

  /// Judul halaman pengaturan notifikasi
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// Pusat notifikasi
  ///
  /// In en, this message translates to:
  /// **'Notification Center'**
  String get notificationCenter;

  /// Header bagian mode hening
  ///
  /// In en, this message translates to:
  /// **'QUIET MODE'**
  String get quietModeSection;

  /// Opsi jangan ganggu
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb'**
  String get doNotDisturb;

  /// Keterangan opsi jangan ganggu
  ///
  /// In en, this message translates to:
  /// **'Mute all notification sounds, vibrations, and banners'**
  String get doNotDisturbSubtitle;

  /// Pesan snackbar DND aktif
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb mode is enabled'**
  String get dndEnabledSnackbar;

  /// Pesan snackbar DND nonaktif
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb mode is disabled'**
  String get dndDisabledSnackbar;

  /// Judul jadwal jam hening
  ///
  /// In en, this message translates to:
  /// **'Automatic Quiet Hours Schedule'**
  String get quietScheduleTitle;

  /// Keterangan jadwal jam hening
  ///
  /// In en, this message translates to:
  /// **'Notifications are muted from {startTime} to {endTime} every day.'**
  String quietScheduleSubtitle(String startTime, String endTime);

  /// Tombol ubah jam hening
  ///
  /// In en, this message translates to:
  /// **'Change Quiet Hours'**
  String get changeQuietHours;

  /// Dialog pilih jam mulai hening
  ///
  /// In en, this message translates to:
  /// **'SELECT QUIET START TIME'**
  String get selectQuietStart;

  /// Dialog pilih jam selesai hening
  ///
  /// In en, this message translates to:
  /// **'SELECT QUIET END TIME'**
  String get selectQuietEnd;

  /// Header notifikasi utama
  ///
  /// In en, this message translates to:
  /// **'MAIN NOTIFICATIONS'**
  String get mainNotificationsSection;

  /// Izinkan semua notifikasi
  ///
  /// In en, this message translates to:
  /// **'Allow All Notifications'**
  String get allowAllNotifications;

  /// Keterangan izinkan semua notifikasi
  ///
  /// In en, this message translates to:
  /// **'Enable all reminders and system notifications'**
  String get allowAllNotificationsSubtitle;

  /// Header kategori notifikasi
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATION CATEGORIES'**
  String get alertCategoriesSection;

  /// Transaksi & transfer
  ///
  /// In en, this message translates to:
  /// **'Transactions & Transfers'**
  String get transactionsAndTransfers;

  /// Keterangan transaksi & transfer
  ///
  /// In en, this message translates to:
  /// **'Income alerts, QRIS & card payments'**
  String get transactionsAndTransfersSubtitle;

  /// Pengingat tagihan
  ///
  /// In en, this message translates to:
  /// **'Bill Reminders'**
  String get billReminders;

  /// Keterangan pengingat tagihan
  ///
  /// In en, this message translates to:
  /// **'Reminders before bills (electricity, internet, water) are due'**
  String get billRemindersSubtitle;

  /// Peringatan anggaran
  ///
  /// In en, this message translates to:
  /// **'Budget Alerts'**
  String get budgetAlerts;

  /// Keterangan peringatan anggaran
  ///
  /// In en, this message translates to:
  /// **'Alerts when spending nears monthly limit'**
  String get budgetAlertsSubtitle;

  /// Keamanan & akun
  ///
  /// In en, this message translates to:
  /// **'Security & Account'**
  String get securityAndAccount;

  /// Keterangan keamanan & akun
  ///
  /// In en, this message translates to:
  /// **'New login detection, password changes & account verification'**
  String get securityAndAccountSubtitle;

  /// Promo & cashback
  ///
  /// In en, this message translates to:
  /// **'Promos & Cashback'**
  String get promoAndCashback;

  /// Keterangan promo & cashback
  ///
  /// In en, this message translates to:
  /// **'Discount info, promo offers & cashback bonuses'**
  String get promoAndCashbackSubtitle;

  /// Header suara & getaran
  ///
  /// In en, this message translates to:
  /// **'SOUND & VIBRATION'**
  String get soundAndVibrationSection;

  /// Suara notifikasi
  ///
  /// In en, this message translates to:
  /// **'Notification Sound'**
  String get notificationSound;

  /// Keterangan suara notifikasi
  ///
  /// In en, this message translates to:
  /// **'Play sound when a notification arrives'**
  String get notificationSoundSubtitle;

  /// Getaran
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// Keterangan getaran
  ///
  /// In en, this message translates to:
  /// **'Vibrate phone when notification is received'**
  String get vibrationSubtitle;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
