import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tph_myleave/models/leave_request.dart';

class LeaveService {
  final SupabaseClient client = Supabase.instance.client;

  Future<List<LeaveRequest>> fetchPendingLeaves() async {
    final response = await client
        .from('leave_request')
        .select()
        .eq('status', 'pending');

    final data = response as List<dynamic>;
    return data.map((json) => LeaveRequest.fromJson(json)).toList();
  }

  Future<void> approveLeave(int id) async {
    await client
        .from('leave_request')
        .update({'status': 'approved'})
        .eq('id', id);
  }

  Future<void> rejectLeave(int id) async {
    await client
        .from('leave_request')
        .update({'status': 'rejected'})
        .eq('id', id);
  }
}