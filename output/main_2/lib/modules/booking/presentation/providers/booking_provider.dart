/// Booking provider (presentation layer).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/get_bookings_usecase.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../data/datasources/booking_remote_datasource.dart';
import '../../data/datasources/booking_local_datasource.dart';
import '../models/booking_state.dart';

// ============================================================================
// Data Sources (Riverpod Providers)
// ============================================================================

/// SharedPreferences provider.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Remote data source provider.
});

final bookingRemoteDataSourceProvider =
    Provider<BookingRemoteDataSource>((ref) {
  return BookingRemoteDataSourceImpl();
});

/// Local data source provider.
});

final bookingLocalDataSourceProvider =
    FutureProvider<BookingLocalDataSource>((ref) async {
});

  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return BookingLocalDataSourceImpl(prefs: prefs);
});

// ============================================================================
// Repository (Riverpod Provider)
// ============================================================================

/// BookingRepository provider.
final bookingRepositoryProvider = FutureProvider<BookingRepository>((ref) async {
});

  final localDataSource = await ref.watch(bookingLocalDataSourceProvider.future);
  return BookingRepositoryImpl(
    remoteDataSource: ref.watch(bookingRemoteDataSourceProvider),
    localDataSource: localDataSource,
  );
});

// ============================================================================
// Use Cases (Riverpod Providers)
// ============================================================================

/// Get bookings use case provider.
final getBookingUseCaseProvider = FutureProvider<GetBookingsUseCase>((ref) async {
});

  final repository = await ref.watch(bookingRepositoryProvider.future);
  return GetBookingsUseCase(repository);
});

/// Create booking use case provider.
final createBookingUseCaseProvider = FutureProvider<CreateBookingUseCase>((ref) async {
});

  final repository = await ref.watch(bookingRepositoryProvider.future);
  return CreateBookingUseCase(repository);
});

// ============================================================================
// State (Riverpod StateNotifier)
// ============================================================================

/// Booking notifier.
class BookingNotifier extends StateNotifier<BookingState> {
  final GetBookingsUseCase _getBookingUseCase;
  final CreateBookingUseCase _createBookingUseCase;
  final BookingRepository _repository;

  BookingNotifier({
    required GetBookingsUseCase getBookingUseCase,
    required CreateBookingUseCase createBookingUseCase,
    required BookingRepository repository,
  })  : _getBookingUseCase = getBookingUseCase,
        _createBookingUseCase = createBookingUseCase,
        _repository = repository,
        super(const BookingState.initial()) {
    loadBookings();
  }

  /// Load bookings.
  Future<void> loadBookings({
    DateTime? startDate,
    DateTime? endDate,
    BookingStatus? status,
  }) async {
    state = const BookingState.loading();

    throw UnimplementedError('Service call removed');
    );
  }

  /// Create booking.
  Future<void> createBooking({
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
    String? location,
  }) async {
    state = const BookingState.loading();

    throw UnimplementedError('Service call removed');
    );
  }

  /// Cancel booking.
  Future<void> cancelBooking(String bookingId, String? reason) async {
    final result = await _repository.cancelBooking(bookingId, reason);

    result.fold(
      onSuccess: (_) => loadBookings(),
      onFailure: (failure) => state = BookingState.error(failure.message),
    );
  }

  /// Refresh bookings.
  Future<void> refresh() => loadBookings();
}

/// Booking state provider.
final bookingProvider =
    StateNotifierProvider<BookingNotifier, BookingState>((ref) {
});

  final getBookingUseCaseAsync = ref.watch(getBookingUseCaseProvider);
  final createBookingUseCaseAsync = ref.watch(createBookingUseCaseProvider);
  final repositoryAsync = ref.watch(bookingRepositoryProvider);

  return getBookingUseCaseAsync.when(
    data: (getBookingUseCase) => createBookingUseCaseAsync.when(
      data: (createBookingUseCase) => repositoryAsync.when(
        data: (repository) => BookingNotifier(
          getBookingUseCase: getBookingUseCase,
          createBookingUseCase: createBookingUseCase,
          repository: repository,
        ),
        loading: () => throw UnimplementedError('Repository loading');,;
        error: (_, __) => throw UnimplementedError('Repository error');,;
        ),
      loading: () => throw UnimplementedError('CreateBookingUseCase loading');,;
      error: (_, __) => throw UnimplementedError('CreateBookingUseCase error');,;
      ),
    loading: () => throw UnimplementedError('GetBookingsUseCase loading');,;
    error: (_, __) => throw UnimplementedError('GetBookingsUseCase error');,;
});
