import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/data/parking_lot_repository.dart';
import 'package:parking/models/parking_lot.dart';

abstract class ParkingLotsState {
  const ParkingLotsState();
}

class ParkingLotsInitial extends ParkingLotsState {
  const ParkingLotsInitial();
}

class ParkingLotsLoading extends ParkingLotsState {
  const ParkingLotsLoading();
}

class ParkingLotsLoaded extends ParkingLotsState {
  const ParkingLotsLoaded(this.lots);
  final List<ParkingLot> lots;
}

class ParkingLotsError extends ParkingLotsState {
  const ParkingLotsError(this.message);
  final String message;
}

class ParkingLotsCubit extends Cubit<ParkingLotsState> {
  ParkingLotsCubit(this._repository)
      : super(const ParkingLotsInitial());

  final ParkingLotRepository _repository;

  Future<void> loadParkingLots() async {
    emit(const ParkingLotsLoading());
    try {
      final lots = await _repository.getParkingLots();
      emit(ParkingLotsLoaded(lots));
    } catch (e) {
      emit(ParkingLotsError(e.toString()));
    }
  }

  Future<void> addParkingLot(ParkingLot lot) async {
    try {
      await _repository.addParkingLot(lot);
      await loadParkingLots();
    } catch (e) {
      emit(ParkingLotsError(e.toString()));
    }
  }

  Future<void> updateParkingLot(ParkingLot lot) async {
    try {
      await _repository.updateParkingLot(lot);
      await loadParkingLots();
    } catch (e) {
      emit(ParkingLotsError(e.toString()));
    }
  }

  Future<void> deleteParkingLot(String id) async {
    try {
      await _repository.deleteParkingLot(id);
      await loadParkingLots();
    } catch (e) {
      emit(ParkingLotsError(e.toString()));
    }
  }
}
