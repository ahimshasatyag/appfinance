import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/bill_item_entity.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/repositories/split_bill_repository.dart';
import '../../domain/usecases/calculate_split_bill_usecase.dart';
import '../../domain/usecases/create_bill_usecase.dart';
import '../../domain/usecases/fetch_bill_history_usecase.dart';
import 'split_bill_event.dart';
import 'split_bill_state.dart';

class SplitBillBloc extends Bloc<SplitBillEvent, SplitBillState> {
  final CalculateSplitBillUseCase calculateUseCase;
  final CreateBillUseCase createBillUseCase;
  final FetchBillHistoryUseCase fetchBillHistoryUseCase;
  final SplitBillRepository repository;

  SplitBillBloc({
    required this.calculateUseCase,
    required this.createBillUseCase,
    required this.fetchBillHistoryUseCase,
    required this.repository,
  }) : super(const SplitBillInitial()) {
    on<LoadBillHistoryEvent>(_onLoadHistory);
    on<LoadBillDetailEvent>(_onLoadDetail);
    on<InitCreateBillEvent>(_onInitCreateBill);
    on<AddMemberEvent>(_onAddMember);
    on<RemoveMemberEvent>(_onRemoveMember);
    on<AddBillItemEvent>(_onAddBillItem);
    on<UpdateBillItemEvent>(_onUpdateBillItem);
    on<RemoveBillItemEvent>(_onRemoveBillItem);
    on<ToggleItemMemberAssignmentEvent>(_onToggleItemAssignment);
    on<AssignAllMembersToItemEvent>(_onAssignAllMembersToItem);
    on<UpdateBillTaxServiceEvent>(_onUpdateBillTaxService);
    on<SubmitCreateBillEvent>(_onSubmitCreateBill);
    on<ToggleMemberPaymentStatusEvent>(_onTogglePaymentStatus);
  }

  Future<void> _onLoadHistory(
    LoadBillHistoryEvent event,
    Emitter<SplitBillState> emit,
  ) async {
    emit(const SplitBillLoading());
    try {
      final bills = await fetchBillHistoryUseCase.call();
      emit(SplitBillHistoryLoaded(bills));
    } catch (e) {
      emit(SplitBillError(e.toString()));
    }
  }

  Future<void> _onLoadDetail(
    LoadBillDetailEvent event,
    Emitter<SplitBillState> emit,
  ) async {
    emit(const SplitBillLoading());
    try {
      final bill = await fetchBillHistoryUseCase.getDetail(event.billId);
      emit(SplitBillDetailLoaded(bill));
    } catch (e) {
      emit(SplitBillError(e.toString()));
    }
  }

  void _onInitCreateBill(
    InitCreateBillEvent event,
    Emitter<SplitBillState> emit,
  ) {
    final initialBill = event.initialBill;
    if (initialBill != null) {
      emit(
        SplitBillFormState(
          title: initialBill.title,
          members: initialBill.members,
          items: initialBill.items,
          taxPercentage: initialBill.taxPercentage,
          servicePercentage: initialBill.servicePercentage,
          discountAmount: initialBill.discountAmount,
          tipAmount: initialBill.tipAmount,
          calculatedBill: initialBill,
        ),
      );
      return;
    }

    // Default: Includes current user "Saya"
    final defaultMembers = [
      const MemberEntity(
        id: 'user_me',
        name: 'Saya',
        isCurrentUser: true,
      ),
    ];

    final calculated = calculateUseCase.execute(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      title: '',
      date: DateTime.now(),
      members: defaultMembers,
      items: const [],
    );

    emit(
      SplitBillFormState(
        title: '',
        members: defaultMembers,
        items: const [],
        calculatedBill: calculated,
      ),
    );
  }

  void _onAddMember(
    AddMemberEvent event,
    Emitter<SplitBillState> emit,
  ) {
    if (state is! SplitBillFormState) return;
    final current = state as SplitBillFormState;

    final newMember = MemberEntity(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      name: event.name.trim(),
      phoneNumber: event.phoneNumber?.trim(),
    );

    final updatedMembers = [...current.members, newMember];
    _recalculateAndEmit(current, members: updatedMembers, emit: emit);
  }

  void _onRemoveMember(
    RemoveMemberEvent event,
    Emitter<SplitBillState> emit,
  ) {
    if (state is! SplitBillFormState) return;
    final current = state as SplitBillFormState;

    final updatedMembers =
        current.members.where((m) => m.id != event.memberId).toList();

    // Also remove this member from any assigned items
    final updatedItems = current.items.map((item) {
      if (item.assignedMemberIds.contains(event.memberId)) {
        return item.copyWith(
          assignedMemberIds: item.assignedMemberIds
              .where((id) => id != event.memberId)
              .toList(),
        );
      }
      return item;
    }).toList();

    _recalculateAndEmit(
      current,
      members: updatedMembers,
      items: updatedItems,
      emit: emit,
    );
  }

  void _onAddBillItem(
    AddBillItemEvent event,
    Emitter<SplitBillState> emit,
  ) {
    if (state is! SplitBillFormState) return;
    final current = state as SplitBillFormState;

    // Default assignment: assign to all members if none specified
    final item = event.item.assignedMemberIds.isEmpty
        ? event.item.copyWith(
            assignedMemberIds: current.members.map((m) => m.id).toList(),
          )
        : event.item;

    final updatedItems = [...current.items, item];
    _recalculateAndEmit(current, items: updatedItems, emit: emit);
  }

  void _onUpdateBillItem(
    UpdateBillItemEvent event,
    Emitter<SplitBillState> emit,
  ) {
    if (state is! SplitBillFormState) return;
    final current = state as SplitBillFormState;

    final updatedItems = current.items.map((item) {
      return item.id == event.item.id ? event.item : item;
    }).toList();

    _recalculateAndEmit(current, items: updatedItems, emit: emit);
  }

  void _onRemoveBillItem(
    RemoveBillItemEvent event,
    Emitter<SplitBillState> emit,
  ) {
    if (state is! SplitBillFormState) return;
    final current = state as SplitBillFormState;

    final updatedItems =
        current.items.where((i) => i.id != event.itemId).toList();
    _recalculateAndEmit(current, items: updatedItems, emit: emit);
  }

  void _onToggleItemAssignment(
    ToggleItemMemberAssignmentEvent event,
    Emitter<SplitBillState> emit,
  ) {
    if (state is! SplitBillFormState) return;
    final current = state as SplitBillFormState;

    final updatedItems = current.items.map((item) {
      if (item.id == event.itemId) {
        final currentAssignees = List<String>.from(item.assignedMemberIds);
        if (currentAssignees.contains(event.memberId)) {
          currentAssignees.remove(event.memberId);
        } else {
          currentAssignees.add(event.memberId);
        }
        return item.copyWith(assignedMemberIds: currentAssignees);
      }
      return item;
    }).toList();

    _recalculateAndEmit(current, items: updatedItems, emit: emit);
  }

  void _onAssignAllMembersToItem(
    AssignAllMembersToItemEvent event,
    Emitter<SplitBillState> emit,
  ) {
    if (state is! SplitBillFormState) return;
    final current = state as SplitBillFormState;

    final allMemberIds = current.members.map((m) => m.id).toList();
    final updatedItems = current.items.map((item) {
      if (item.id == event.itemId) {
        final isAllSelected = item.assignedMemberIds.length == current.members.length;
        return item.copyWith(
          assignedMemberIds: isAllSelected ? [] : allMemberIds,
        );
      }
      return item;
    }).toList();

    _recalculateAndEmit(current, items: updatedItems, emit: emit);
  }

  void _onUpdateBillTaxService(
    UpdateBillTaxServiceEvent event,
    Emitter<SplitBillState> emit,
  ) {
    if (state is! SplitBillFormState) return;
    final current = state as SplitBillFormState;

    _recalculateAndEmit(
      current,
      title: event.title,
      taxPercentage: event.taxPercentage,
      servicePercentage: event.servicePercentage,
      discountAmount: event.discountAmount,
      tipAmount: event.tipAmount,
      emit: emit,
    );
  }

  void _recalculateAndEmit(
    SplitBillFormState current, {
    String? title,
    List<MemberEntity>? members,
    List<BillItemEntity>? items,
    double? taxPercentage,
    double? servicePercentage,
    double? discountAmount,
    double? tipAmount,
    required Emitter<SplitBillState> emit,
  }) {
    final effectiveTitle = title ?? current.title;
    final effectiveMembers = members ?? current.members;
    final effectiveItems = items ?? current.items;
    final effectiveTax = taxPercentage ?? current.taxPercentage;
    final effectiveService = servicePercentage ?? current.servicePercentage;
    final effectiveDiscount = discountAmount ?? current.discountAmount;
    final effectiveTip = tipAmount ?? current.tipAmount;

    final calculated = calculateUseCase.execute(
      id: current.calculatedBill.id,
      title: effectiveTitle,
      date: current.calculatedBill.date,
      members: effectiveMembers,
      items: effectiveItems,
      taxPercentage: effectiveTax,
      servicePercentage: effectiveService,
      discountAmount: effectiveDiscount,
      tipAmount: effectiveTip,
    );

    emit(
      current.copyWith(
        title: effectiveTitle,
        members: effectiveMembers,
        items: effectiveItems,
        taxPercentage: effectiveTax,
        servicePercentage: effectiveService,
        discountAmount: effectiveDiscount,
        tipAmount: effectiveTip,
        calculatedBill: calculated,
      ),
    );
  }

  Future<void> _onSubmitCreateBill(
    SubmitCreateBillEvent event,
    Emitter<SplitBillState> emit,
  ) async {
    if (state is! SplitBillFormState) return;
    final current = state as SplitBillFormState;

    final titleToUse = current.title.trim().isNotEmpty
        ? current.title.trim()
        : (current.calculatedBill.title.trim().isNotEmpty
            ? current.calculatedBill.title.trim()
            : '');

    if (titleToUse.isEmpty) {
      emit(const SplitBillError('Judul tagihan tidak boleh kosong'));
      emit(current);
      return;
    }

    if (current.members.isEmpty) {
      emit(const SplitBillError('Tambahkan minimal 1 teman'));
      emit(current);
      return;
    }

    if (current.items.isEmpty) {
      emit(const SplitBillError('Tambahkan minimal 1 item pesanan'));
      emit(current);
      return;
    }

    emit(current.copyWith(isSubmitting: true));

    try {
      final billToSave = current.calculatedBill.copyWith(
        id: 'bill_${DateTime.now().millisecondsSinceEpoch}',
        title: titleToUse,
        date: DateTime.now(),
        status: 'pending',
      );

      final saved = await createBillUseCase.call(billToSave);
      emit(SplitBillSuccess(saved, message: 'Tagihan berhasil dibuat!'));
    } catch (e) {
      emit(SplitBillError(e.toString()));
      emit(current.copyWith(isSubmitting: false));
    }
  }

  Future<void> _onTogglePaymentStatus(
    ToggleMemberPaymentStatusEvent event,
    Emitter<SplitBillState> emit,
  ) async {
    try {
      await repository.markMemberPaid(
        event.billId,
        event.memberId,
        event.isPaid,
      );
      final updatedBill = await fetchBillHistoryUseCase.getDetail(event.billId);
      emit(SplitBillDetailLoaded(updatedBill));
    } catch (e) {
      emit(SplitBillError(e.toString()));
    }
  }
}
