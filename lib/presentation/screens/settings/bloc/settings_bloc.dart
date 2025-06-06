import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:invoiceowl/constants/app_constants.dart';
import 'package:invoiceowl/data/repositories/business_repo.dart';
import 'package:invoiceowl/utils/app_methods.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(InitialSettingsState()) {
    on<SaveBusinessInfoEvent>(_onSaveBusinessInfoEvent);
    on<SaveUpiIdEvent>(_onSaveUpiIdEvent);
    on<SendFeedbackEvent>(_onSendFeedbackEvent);
    on<UpdateCurrencyEvent>(_onUpdateCurrencyEvent);
  }
  void _onUpdateCurrencyEvent(event, emit) async {
    try {
      emit(SettingsLoadingState());
      await BusinessRepo().updateCurrency(event.currency);
      emit(CurrencyUpdatedState());
    } catch (err) {
      debugPrint(err.toString());
      emit(
        SettingsErrorState(
          errorMessage: "Some error occured!, Currency not updated",
        ),
      );
    }
  }

  void _onSendFeedbackEvent(event, emit) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: AppConstants.feedbackEmail, // Pre-filled email address
        query: Uri.encodeFull(
          'subject=Feedback&body=I love this app!',
        ), // Pre-filled subject & body
      );
      bool isAbove10 = await AppMethods.isAndroid10OrAbove();
      if (isAbove10) {
        emit(EmailAppOpenedAndClosedState());
      } else {
        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri);
          emit(EmailAppOpenedAndClosedState());
        } else {
          throw 'Could not launch email app';
        }
      }
    } catch (err) {
      debugPrint(err.toString());
      emit(SettingsErrorState(errorMessage: err.toString()));
    }
  }

  void _onSaveBusinessInfoEvent(event, emit) async {
    emit(SettingsLoadingState());
    try {
      final businessRepo = BusinessRepo();
      businessRepo.saveBusinessInfo(event.business);

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
      await BusinessRepo().saveUpiId(event.upiId);

      emit(UpiIdSavedState());
    } catch (err) {
      debugPrint(err.toString());
      emit(SettingsErrorState(
        errorMessage: "Something went wrong while saving UPI ID ..!",
      ));
    }
  }
}
