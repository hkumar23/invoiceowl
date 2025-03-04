import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../constants/app_language.dart';
import '../../../../constants/app_constants.dart';
import '../../../../data/repositories/invoice_repo.dart';
import '../../../../utils/app_methods.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(InitialSettingsState()) {
    on<SaveBusinessInfoEvent>(_onSaveBusinessInfoEvent);
    on<SaveUpiIdEvent>(_onSaveUpiIdEvent);
  }

  void _onSaveBusinessInfoEvent(event, emit) async {
    emit(SettingsLoadingState());
    try {
      // final UserRepo userRepo = UserRepo();
      // await userRepo.updateBusinessInfo(event.business);
      // await businessRepo.saveBusinessInfo(event.business);
      emit(BusinessInfoSavedState());
    } catch (err) {
      debugPrint(err.toString());
      emit(SettingsErrorState(
        errorMessage: "Something went wrong while saving Business details ..!",
      ));
    }
  }

  _onSaveUpiIdEvent(event, emit) async {
    emit(SettingsLoadingState());
    try {
      // await UserRepo().saveUpiId(event.upiId);
      emit(UpiIdSavedState());
    } catch (err) {
      debugPrint(err.toString());
      emit(SettingsErrorState(
        errorMessage: "Something went wrong while saving UPI ID ..!",
      ));
    }
  }
}
