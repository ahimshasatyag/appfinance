import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/config/l10n.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../data/datasources/split_bill_local_datasource.dart';
import '../../data/datasources/split_bill_remote_datasource.dart';
import '../../data/repositories/split_bill_repository_impl.dart';
import '../../domain/entities/bill_entity.dart';
import '../../domain/entities/bill_item_entity.dart';
import '../../domain/usecases/calculate_split_bill_usecase.dart';
import '../../domain/usecases/create_bill_usecase.dart';
import '../../domain/usecases/fetch_bill_history_usecase.dart';
import '../bloc/split_bill_bloc.dart';
import '../bloc/split_bill_event.dart';
import '../bloc/split_bill_state.dart';
import '../widgets/item_assignment_tile.dart';
import '../widgets/member_chip_widget.dart';
import '../widgets/summary_card_widget.dart';
import '../widgets/create_split_bill_skeleton.dart';
import 'split_bill_detail_page.dart';

class CreateSplitBillPage extends StatefulWidget {
  final BillEntity? initialDraft;

  const CreateSplitBillPage({super.key, this.initialDraft});

  @override
  State<CreateSplitBillPage> createState() => _CreateSplitBillPageState();
}

class _CreateSplitBillPageState extends State<CreateSplitBillPage> {
  late final SplitBillBloc _bloc;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final localDs = SplitBillLocalDataSourceImpl();
    final remoteDs = SplitBillRemoteDataSourceImpl();
    final repo = SplitBillRepositoryImpl(
      remoteDataSource: remoteDs,
      localDataSource: localDs,
    );

    _bloc = SplitBillBloc(
      calculateUseCase: CalculateSplitBillUseCase(),
      createBillUseCase: CreateBillUseCase(repo),
      fetchBillHistoryUseCase: FetchBillHistoryUseCase(repo),
      repository: repo,
    )..add(InitCreateBillEvent(initialBill: widget.initialDraft));

    if (widget.initialDraft != null) {
      _titleController.text = widget.initialDraft!.title;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _showAddMemberDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    String? memberError;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.addFriend,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(bottomSheetContext),
                    ),
                  ],
                ),
                if (memberError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    memberError!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                  decoration: InputDecoration(
                    labelText: context.l10n.friendName,
                    hintText: context.l10n.friendNameHint,
                    filled: true,
                    fillColor: isDark ? AppColors.darkBackground : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                  decoration: InputDecoration(
                    labelText: context.l10n.phoneNumberOptional,
                    hintText: '0812xxxxxxxx',
                    filled: true,
                    fillColor: isDark ? AppColors.darkBackground : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: context.l10n.saveFriend,
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      setModalState(() {
                        memberError = context.l10n.friendNameEmptyError;
                      });
                      return;
                    }
                    _bloc.add(
                      AddMemberEvent(
                        name: name,
                        phoneNumber: phoneController.text.trim().isEmpty
                            ? null
                            : phoneController.text.trim(),
                      ),
                    );
                    Navigator.pop(bottomSheetContext);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, {BillItemEntity? itemToEdit}) {
    final nameController =
        TextEditingController(text: itemToEdit?.name ?? '');
    final priceController = TextEditingController(
      text: itemToEdit != null ? itemToEdit.price.toStringAsFixed(0) : '',
    );
    int quantity = itemToEdit?.quantity ?? 1;
    String? itemError;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      itemToEdit != null ? context.l10n.editItem : context.l10n.addOrderItem,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(bottomSheetContext),
                    ),
                  ],
                ),
                if (itemError != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            itemError!,
                            style: const TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  autofocus: itemToEdit == null,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                  decoration: InputDecoration(
                    labelText: context.l10n.itemNameLabel,
                    hintText: context.l10n.itemNameHint,
                    filled: true,
                    fillColor: isDark ? AppColors.darkBackground : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                        decoration: InputDecoration(
                          labelText: context.l10n.unitPriceLabel,
                          hintText: '25000',
                          filled: true,
                          fillColor:
                              isDark ? AppColors.darkBackground : Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkBackground
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_rounded, size: 18),
                              onPressed: () {
                                if (quantity > 1) {
                                  setModalState(() => quantity--);
                                }
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            Text(
                              '$quantity',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_rounded, size: 18),
                              onPressed: () {
                                setModalState(() => quantity++);
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: itemToEdit != null ? context.l10n.updateItem : context.l10n.addToBill,
                  onPressed: () {
                    final name = nameController.text.trim();
                    final rawPrice = priceController.text.replaceAll(RegExp(r'[^\d]'), '');
                    final price = double.tryParse(rawPrice) ?? 0.0;

                    if (name.isEmpty) {
                      setModalState(() {
                        itemError = context.l10n.itemNameEmptyError;
                      });
                      return;
                    }

                    if (price <= 0) {
                      setModalState(() {
                        itemError = context.l10n.itemPriceZeroError;
                      });
                      return;
                    }

                    if (itemToEdit != null) {
                      _bloc.add(
                        UpdateBillItemEvent(
                          itemToEdit.copyWith(
                            name: name,
                            price: price,
                            quantity: quantity,
                          ),
                        ),
                      );
                    } else {
                      _bloc.add(
                        AddBillItemEvent(
                          BillItemEntity(
                            id: 'item_${DateTime.now().millisecondsSinceEpoch}',
                            name: name,
                            price: price,
                            quantity: quantity,
                          ),
                        ),
                      );
                    }
                    Navigator.pop(bottomSheetContext);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showTaxesDialog(BuildContext context, SplitBillFormState state) {
    final taxController = TextEditingController(
      text: state.taxPercentage > 0 ? state.taxPercentage.toString() : '10',
    );
    final serviceController = TextEditingController(
      text: state.servicePercentage > 0 ? state.servicePercentage.toString() : '0',
    );
    final discountController = TextEditingController(
      text: state.discountAmount > 0 ? state.discountAmount.toStringAsFixed(0) : '0',
    );
    final tipController = TextEditingController(
      text: state.tipAmount > 0 ? state.tipAmount.toStringAsFixed(0) : '0',
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.manageTaxesTip,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(bottomSheetContext),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taxController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      labelText: context.l10n.taxPercentageLabel,
                      suffixText: '%',
                      filled: true,
                      fillColor:
                          isDark ? AppColors.darkBackground : Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: serviceController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      labelText: context.l10n.servicePercentageLabel,
                      suffixText: '%',
                      filled: true,
                      fillColor:
                          isDark ? AppColors.darkBackground : Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      labelText: context.l10n.discountAmountLabel,
                      filled: true,
                      fillColor:
                          isDark ? AppColors.darkBackground : Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: tipController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      labelText: context.l10n.tipAmountLabel,
                      filled: true,
                      fillColor:
                          isDark ? AppColors.darkBackground : Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: context.l10n.apply,
              onPressed: () {
                final tax = double.tryParse(taxController.text) ?? 0.0;
                final service = double.tryParse(serviceController.text) ?? 0.0;
                final discount = double.tryParse(discountController.text) ?? 0.0;
                final tip = double.tryParse(tipController.text) ?? 0.0;

                _bloc.add(
                  UpdateBillTaxServiceEvent(
                    taxPercentage: tax,
                    servicePercentage: service,
                    discountAmount: discount,
                    tipAmount: tip,
                  ),
                );
                Navigator.pop(bottomSheetContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<SplitBillBloc, SplitBillState>(
        listener: (context, state) {
          if (state is SplitBillSuccess) {
            CustomDialog.showSuccess(
              context,
              title: context.l10n.success,
              message: state.message,
              onConfirm: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SplitBillDetailPage(billId: state.bill.id),
                  ),
                );
              },
            );
          } else if (state is SplitBillError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is! SplitBillFormState) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
                title: Text(
                  context.l10n.createSplitBill,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              body: const CreateSplitBillSkeleton(),
            );
          }

          final formState = state;
          final bill = formState.calculatedBill;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              title: Text(
                context.l10n.createSplitBill,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Bill Title Input
                  TextField(
                    controller: _titleController,
                    onChanged: (val) {
                      _bloc.add(UpdateBillTaxServiceEvent(title: val));
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: context.l10n.billTitleLabel,
                      hintText: context.l10n.billTitleHint,
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurface : Colors.white,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(
                        Icons.edit_note_rounded,
                        color: AppTheme.primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey.shade200,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey.shade200,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. Members Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.splitFriends(formState.members.length),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showAddMemberDialog(context),
                        icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                        label: Text(context.l10n.add),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  MemberChipWidget(
                    members: formState.members,
                    onAddMember: () => _showAddMemberDialog(context),
                    onRemoveMember: (id) => _bloc.add(RemoveMemberEvent(id)),
                  ),

                  const SizedBox(height: 24),

                  // 3. Bill Items Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.orderItems(formState.items.length),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showAddItemDialog(context),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(context.l10n.addItem),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (formState.items.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface.withValues(alpha: 0.5)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.grey.shade200,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_outlined,
                            size: 40,
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            context.l10n.noItemsYet,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.clickAddItemHint,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    ...formState.items.map((item) {
                      return ItemAssignmentTile(
                        item: item,
                        members: formState.members,
                        onToggleMember: (memberId) {
                          _bloc.add(
                            ToggleItemMemberAssignmentEvent(
                              itemId: item.id,
                              memberId: memberId,
                            ),
                          );
                        },
                        onAssignAll: () {
                          _bloc.add(AssignAllMembersToItemEvent(item.id));
                        },
                        onEdit: () => _showAddItemDialog(context, itemToEdit: item),
                        onDelete: () => _bloc.add(RemoveBillItemEvent(item.id)),
                      );
                    }),

                  const SizedBox(height: 24),

                  // 4. Summary Card (Subtotal, Tax, Service, Discount, Tip, Total)
                  SummaryCardWidget(
                    bill: bill,
                    showEditButton: true,
                    onEditTaxes: () => _showTaxesDialog(context, formState),
                  ),

                  const SizedBox(height: 32),

                  // 5. Submit Button
                  CustomButton(
                    text: context.l10n.calculateAndSaveBill,
                    isLoading: formState.isSubmitting,
                    onPressed: () {
                      final title = _titleController.text.trim();
                      if (title.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.enterBillTitleError),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      if (formState.items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.addAtLeastOneItemError),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      _bloc.add(UpdateBillTaxServiceEvent(title: title));
                      _bloc.add(const SubmitCreateBillEvent());
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
