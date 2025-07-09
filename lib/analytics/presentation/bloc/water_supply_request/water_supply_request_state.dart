import 'package:equatable/equatable.dart';
import 'package:mobile_iot/analytics/domain/entities/water_request.dart';

/// Abstract base class for water supply request BLoC states.
/// 
/// This class defines the contract for all states that can be emitted
/// by the WaterSupplyRequestBloc. It extends Equatable to enable proper state
/// comparison and change detection.
/// 
/// All water supply request-related UI states should extend this class to ensure
/// consistent state management and UI updates.
abstract class WaterSupplyRequestState extends Equatable {
  const WaterSupplyRequestState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the water supply request BLoC is first created.
/// 
/// This state represents the starting point before any data
/// loading or user interaction has occurred.
class WaterSupplyRequestInitialState extends WaterSupplyRequestState {
  const WaterSupplyRequestInitialState();
}

/// Loading state when water supply requests data is being fetched.
/// 
/// This state is emitted when the application is loading
/// water supply requests data from the data source, typically showing
/// a loading indicator in the UI.
class WaterSupplyRequestLoadingState extends WaterSupplyRequestState {
  const WaterSupplyRequestLoadingState();
}

/// Loaded state when water supply requests data has been successfully retrieved.
/// 
/// This state contains the loaded water supply requests data and is emitted
/// when the data fetching process completes successfully.
/// 
/// Parameters:
/// - [requests]: The list of water supply requests
class WaterSupplyRequestLoadedState extends WaterSupplyRequestState {
  final List<WaterRequest> requests;

  const WaterSupplyRequestLoadedState(this.requests);

  @override
  List<Object?> get props => [requests];
}

/// Error state when water supply requests data loading has failed.
/// 
/// This state is emitted when an error occurs during data loading,
/// containing an error message to display to the user.
/// 
/// Parameters:
/// - [message]: The error message describing what went wrong
class WaterSupplyRequestErrorState extends WaterSupplyRequestState {
  final String message;


  const WaterSupplyRequestErrorState(this.message);

  @override
  List<Object?> get props => [message];
} 