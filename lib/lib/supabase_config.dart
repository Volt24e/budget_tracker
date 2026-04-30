import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // IMPORTANT: Put quotes around these values!
  static const String url = 'https://fhbwirwasfgnysusdhan.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZoYndpcndhc2ZnbnlzdXNkaGFuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc0NTU2NDgsImV4cCI6MjA5MzAzMTY0OH0.kO3GJMyq0xQKQUGTWTVsOGgCs_QwQEc1WfgCPPIIbTQ';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}
