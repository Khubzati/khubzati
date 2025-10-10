import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:khubzati/features/customer/payment/data/services/payment_service.dart';

part 'payment_event.dart';
part 'payment_state.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentService paymentService;

  PaymentBloc({required this.paymentService}) : super(PaymentInitial()) {
    on<ProcessPayment>(_onProcessPayment);
    on<CheckPaymentStatus>(_onCheckPaymentStatus);
    on<GetPaymentMethods>(_onGetPaymentMethods);
    on<SavePaymentMethod>(_onSavePaymentMethod);
    on<DeletePaymentMethod>(_onDeletePaymentMethod);
  }

  Future<void> _onProcessPayment(
      ProcessPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentProcessing());
    try {
      final paymentResult = await paymentService.processPayment(
        orderId: event.orderId,
        amount: event.amount,
        paymentMethodId: event.paymentMethodId,
        paymentMethod: event.paymentMethod,
        cardDetails: event.cardDetails,
      );

      if (paymentResult['status'] == 'success') {
        emit(PaymentSuccess(
          transactionId: paymentResult['transaction_id'],
          orderId: event.orderId,
          amount: event.amount,
        ));
      } else {
        emit(PaymentFailure(paymentResult['message'] ?? 'Payment failed'));
      }
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> _onCheckPaymentStatus(
      CheckPaymentStatus event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final status = await paymentService.checkPaymentStatus(event.orderId);
      emit(PaymentStatusChecked(
        orderId: event.orderId,
        status: status['status'],
        transactionId: status['transaction_id'],
      ));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> _onGetPaymentMethods(
      GetPaymentMethods event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final paymentMethods = await paymentService.getPaymentMethods();
      emit(PaymentMethodsLoaded(paymentMethods: paymentMethods));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> _onSavePaymentMethod(
      SavePaymentMethod event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final savedMethod = await paymentService.savePaymentMethod(
        cardNumber: event.cardNumber,
        expiryDate: event.expiryDate,
        cvv: event.cvv,
        cardholderName: event.cardholderName,
        isDefault: event.isDefault,
      );
      emit(PaymentMethodSaved(paymentMethod: savedMethod));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> _onDeletePaymentMethod(
      DeletePaymentMethod event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      await paymentService.deletePaymentMethod(event.paymentMethodId);
      emit(PaymentMethodDeleted(paymentMethodId: event.paymentMethodId));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}
