import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const SelectedLanguage(Locale('vi')));

  void toVietNamese() => emit(const SelectedLanguage(Locale('vi')));

  void toEnglish() => emit(const SelectedLanguage(Locale('en')));

  void toKorea() => emit(const SelectedLanguage(Locale('ko')));

  void toJapan() => emit(const SelectedLanguage(Locale('ja')));
}
