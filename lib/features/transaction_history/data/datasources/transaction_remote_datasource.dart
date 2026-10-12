import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactionHistory({
    String? category,
    String? type,
    String? status,
    String? searchQuery,
  });
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  // Simulasi endpoint API: /api/v1/transactions/history
  final List<Map<String, dynamic>> _dummyData = [
    {
      "id": "TRX-20261012-001",
      "title": "Gaji Bulanan",
      "amount": 15000000.0,
      "date": DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
      "status": "Success",
      "category": "Salary",
      "type": "Income",
      "account": "BCA",
      "notes": "Transfer gaji bulanan dari PT Teknologi Maju"
    },
    {
      "id": "TRX-20261012-002",
      "title": "Makan Siang Restoran Padang",
      "amount": 48000.0,
      "date": DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      "status": "Success",
      "category": "Food & Dining",
      "type": "Expense",
      "account": "GoPay",
      "notes": "Nasi rendang + es teh manis"
    },
    {
      "id": "TRX-20261012-003",
      "title": "Kopi Latte & Toast",
      "amount": 35000.0,
      "date": DateTime.now().subtract(const Duration(hours: 7)).toIso8601String(),
      "status": "Success",
      "category": "Food & Dining",
      "type": "Expense",
      "account": "OVO",
      "notes": "Kopi kenangan bareng teman"
    },
    {
      "id": "TRX-20261011-001",
      "title": "Belanja Bulanan Supermarket",
      "amount": 625000.0,
      "date": DateTime.now().subtract(const Duration(days: 1, hours: 2)).toIso8601String(),
      "status": "Success",
      "category": "Shopping",
      "type": "Expense",
      "account": "Mandiri",
      "notes": "Bahan makanan pokok, buah & sayur"
    },
    {
      "id": "TRX-20261011-002",
      "title": "Transfer ke Rekening Tabungan",
      "amount": 2500000.0,
      "date": DateTime.now().subtract(const Duration(days: 1, hours: 6)).toIso8601String(),
      "status": "Success",
      "category": "Transfer",
      "type": "Transfer",
      "account": "Bank Jago",
      "notes": "Alokasi dana darurat"
    },
    {
      "id": "TRX-20261010-001",
      "title": "Tagihan Listrik PLN",
      "amount": 450000.0,
      "date": DateTime.now().subtract(const Duration(days: 2, hours: 4)).toIso8601String(),
      "status": "Success",
      "category": "Bills & Utilities",
      "type": "Expense",
      "account": "BCA",
      "notes": "Token listrik pascabayar rumah"
    },
    {
      "id": "TRX-20261010-002",
      "title": "Top Up E-Wallet OVO",
      "amount": 200000.0,
      "date": DateTime.now().subtract(const Duration(days: 2, hours: 8)).toIso8601String(),
      "status": "Pending",
      "category": "Transfer",
      "type": "Transfer",
      "account": "BCA",
      "notes": "Sedang menunggu konfirmasi perbankan"
    },
    {
      "id": "TRX-20261009-001",
      "title": "Bensin Pertamax Shell",
      "amount": 150000.0,
      "date": DateTime.now().subtract(const Duration(days: 3, hours: 1)).toIso8601String(),
      "status": "Success",
      "category": "Transport",
      "type": "Expense",
      "account": "Cash",
      "notes": "Pengisian bahan bakar motor"
    },
    {
      "id": "TRX-20261008-001",
      "title": "Dividen Saham BBCA",
      "amount": 850000.0,
      "date": DateTime.now().subtract(const Duration(days: 4, hours: 3)).toIso8601String(),
      "status": "Success",
      "category": "Investment",
      "type": "Income",
      "account": "BCA",
      "notes": "Dividen interim kuartal 3"
    },
    {
      "id": "TRX-20261007-001",
      "title": "Langganan Spotify & Netflix",
      "amount": 186000.0,
      "date": DateTime.now().subtract(const Duration(days: 5, hours: 5)).toIso8601String(),
      "status": "Success",
      "category": "Entertainment",
      "type": "Expense",
      "account": "Mandiri",
      "notes": "Auto-debit paket premium bulanan"
    },
    {
      "id": "TRX-20261006-001",
      "title": "Pembayaran Tagihan Wifi Internet",
      "amount": 375000.0,
      "date": DateTime.now().subtract(const Duration(days: 6, hours: 2)).toIso8601String(),
      "status": "Failed",
      "category": "Bills & Utilities",
      "type": "Expense",
      "account": "BCA",
      "notes": "Gagal: Saldo tidak mencukupi saat proses debet"
    },
    {
      "id": "TRX-20261005-001",
      "title": "Bonus Proyek Freelance UI/UX",
      "amount": 3500000.0,
      "date": DateTime.now().subtract(const Duration(days: 7, hours: 6)).toIso8601String(),
      "status": "Success",
      "category": "Income",
      "type": "Income",
      "account": "Mandiri",
      "notes": "Pembayaran milestone 2 desain aplikasi"
    },
  ];

  @override
  Future<List<TransactionModel>> getTransactionHistory({
    String? category,
    String? type,
    String? status,
    String? searchQuery,
  }) async {
    // Simulasi latency jaringan server API (600ms)
    await Future.delayed(const Duration(milliseconds: 600));

    var list = _dummyData.map((e) => TransactionModel.fromJson(e)).toList();

    // Filter type (Income, Expense, Transfer)
    if (type != null && type.isNotEmpty && type.toLowerCase() != 'all') {
      list = list.where((t) => t.type.toLowerCase() == type.toLowerCase()).toList();
    }

    // Filter category
    if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
      list = list.where((t) => t.category.toLowerCase() == category.toLowerCase()).toList();
    }

    // Filter status (Success, Pending, Failed)
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      list = list.where((t) => t.status.toLowerCase() == status.toLowerCase()).toList();
    }

    // Filter search query (title, notes, account, category)
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      list = list.where((t) {
        return t.title.toLowerCase().contains(q) ||
            t.category.toLowerCase().contains(q) ||
            t.account.toLowerCase().contains(q) ||
            (t.notes != null && t.notes!.toLowerCase().contains(q));
      }).toList();
    }

    // Sort descending by date (terbaru lebih dulu)
    list.sort((a, b) => b.date.compareTo(a.date));

    return list;
  }
}
