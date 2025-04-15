import 'package:bloc/bloc.dart';
import 'package:chat_application/features/user/domain/usecases/user/get_device_number_usecase.dart';
import 'package:chat_application/features/user/presentation/cubit/get_device_number/get_device_number_state.dart';

class GetDeviceNumberCubit extends Cubit<GetDeviceNumberState> {
  GetDeviceNumberUseCase getDeviceNumberUseCase;
  GetDeviceNumberCubit({required this.getDeviceNumberUseCase})
    : super(GetDeviceNumberInitial());

  Future<void> getDeviceNumber() async {
    try {
      final contactNumbers = await getDeviceNumberUseCase();
      emit(GetDeviceNumberLoaded(contacts: contactNumbers));
    } catch (_) {
      emit(GetDeviceNumberFailure());
    }
  }
}
