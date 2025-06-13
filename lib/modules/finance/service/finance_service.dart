import '../../auth/services/api_client.dart';

class FinanceService {
  final ApiClient _api = ApiClient();
Future<Map<String, dynamic>> fetchFinanceSummary(String studentId) async {
  try {
    final raw = await _api.get('/finance/finance-summary/$studentId');
    print('📦 Raw Finance Summary: $raw');

    // ✅ Navigate into the actual response payload
    final payload = raw['data'] ?? raw;

    final balanceRaw = payload['summary']?['balance'];
    print('🔍 payload[summary][balance] = $balanceRaw');

    final unpaid = double.tryParse(balanceRaw?.toString() ?? '0') ?? 0.0;
    print('✅ Parsed unpaid from summary.balance: $unpaid');

    return {
      'unpaidAmount': unpaid,
      'canGraduate': payload['canGraduate'] ?? false,
    };
  } catch (e) {
    print('❌ FinanceService Error: $e');
    return {
      'unpaidAmount': 0.0,
      'canGraduate': false,
    };
  }
}

  }
