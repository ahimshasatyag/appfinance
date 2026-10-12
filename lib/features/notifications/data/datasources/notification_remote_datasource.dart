import '../models/notification_model.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> fetchNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    // Simulate network delay to remote backend / FCM service
    await Future.delayed(const Duration(milliseconds: 600));

    final now = DateTime.now();

    return [
      NotificationModel(
        id: 'notif_1',
        title: 'Transfer Masuk Rp 1.500.000',
        body: 'Kamu menerima transfer dari Ahmad Fauzi ke rekening BCA (•••• 2389).',
        type: NotificationType.transaction,
        timestamp: now.subtract(const Duration(minutes: 15)),
        isRead: false,
        payload: {
          'transactionId': 'trx_901',
          'amount': 1500000,
          'account': 'BCA',
          'category': 'Income',
        },
      ),
      NotificationModel(
        id: 'notif_2',
        title: 'Peringatan Tagihan: Listrik PLN',
        body: 'Tagihan listrik sebesar Rp 245.000 akan jatuh tempo besok. Bayar sekarang untuk menghindari denda.',
        type: NotificationType.bill,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
        payload: {
          'billId': 'bill_pln_01',
          'amount': 245000,
          'dueDate': now.add(const Duration(days: 1)).toIso8601String(),
        },
      ),
      NotificationModel(
        id: 'notif_3',
        title: 'Peringatan Keamanan',
        body: 'Terdeteksi login baru dari perangkat Chrome di Jakarta pada jam 12:40 WIB.',
        type: NotificationType.security,
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: false,
        payload: {
          'device': 'Chrome / Windows',
          'location': 'Jakarta, Indonesia',
        },
      ),
      NotificationModel(
        id: 'notif_4',
        title: 'Cashback Rp 50.000 Berhasil Masuk!',
        body: 'Selamat! Promo cashback QRIS telah dikreditkan ke saldo GoPay kamu.',
        type: NotificationType.promo,
        timestamp: now.subtract(const Duration(hours: 9)),
        isRead: true,
        payload: {
          'promoCode': 'CASHBACK50',
          'amount': 50000,
          'wallet': 'GoPay',
        },
      ),
      NotificationModel(
        id: 'notif_5',
        title: 'Peringatan Anggaran Bulanan',
        body: 'Pengeluaran kategori Makanan & Minuman telah mencapai 82% dari batas anggaran bulan ini.',
        type: NotificationType.system,
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
        isRead: true,
        payload: {
          'category': 'Food & Drinks',
          'threshold': 82,
        },
      ),
      NotificationModel(
        id: 'notif_6',
        title: 'Pembayaran Spotify Berhasil',
        body: 'Autodebet langganan Spotify Premium Rp 86.900 berhasil diproses melalui Mandiri.',
        type: NotificationType.transaction,
        timestamp: now.subtract(const Duration(days: 1, hours: 8)),
        isRead: true,
        payload: {
          'merchant': 'Spotify',
          'amount': 86900,
          'account': 'Mandiri',
        },
      ),
      NotificationModel(
        id: 'notif_7',
        title: 'Tagihan Internet Siap Dibayar',
        body: 'Tagihan IndiHome periode Oktober Rp 375.000 sudah terbit.',
        type: NotificationType.bill,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
        payload: {
          'billId': 'bill_telkom_01',
          'amount': 375000,
        },
      ),
    ];
  }
}
