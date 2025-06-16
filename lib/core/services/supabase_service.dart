import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient supabase;

  Future<SupabaseService> init() async {
    await Supabase.initialize(
      url: 'Encrypted',
      anonKey:
          'Encrypted',
    );
    supabase = Supabase.instance.client;
    print("SupabaseService: Supabase initialized and client obtained.");
    return this;
  }
}
