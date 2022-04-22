part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivatedManualMarketEvent extends SearchEvent {}

class OffDeactivatedManualMarketEvent extends SearchEvent {}

class OnNewPlacesFoundEvent extends SearchEvent {
  final List<Feature> places;
  const OnNewPlacesFoundEvent(this.places);
}

class AddToHistoryEvent extends SearchEvent {
  final Feature placesHistory;
  const AddToHistoryEvent(this.placesHistory);
}
