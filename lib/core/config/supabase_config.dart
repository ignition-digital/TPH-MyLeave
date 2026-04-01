import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tph_myleave/models/leave_request.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  // ✅ FETCH all leave
  Future<List<LeaveRequest>> fetchLeave() async {
    try {
      final response = await client
          .from('leave_requests') // ⚠️ better rename table
          .select();

      final data = response as List<dynamic>;

      return data
          .map((json) => LeaveRequest.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching leave: $e');
      return [];
    }
  }

  // ✅ INSERT leave (submit)
  Future<void> submitLeave(LeaveRequest leave) async {
    try {
      await client.from('leave_requests').insert(leave.toJson());
      print("Leave submitted successfully");
    } catch (e) {
      print("Error submitting leave: $e");
    }
  }

  // ✅ UPDATE status (approve/reject)
  Future<void> updateLeaveStatus(int id, String status) async {
    try {
      await client
          .from('leave_requests')
          .update({'status': status})
          .eq('id', id);

      print("Leave updated");
    } catch (e) {
      print("Error updating leave: $e");
    }
  }
}