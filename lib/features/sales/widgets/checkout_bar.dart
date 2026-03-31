import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../orders/models/create_order_dto.dart';
import '../../users/models/user_model.dart';
import '../providers/cart_provider.dart';
import '../providers/sales_providers.dart';

class CheckoutBar extends ConsumerWidget {
  final bool isLoading;

  const CheckoutBar({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final paymentType = ref.watch(selectedPaymentTypeProvider);
    final selectedCustomer = ref.watch(selectedCustomerProvider);
    final isEmpty = cart.isEmpty;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _PaymentTypeBtn(
                label: 'Cash',
                selected: paymentType == PaymentType.cash,
                onTap: () => ref
                    .read(selectedPaymentTypeProvider.notifier)
                    .state = PaymentType.cash,
              ),
              const SizedBox(width: 10),
              _PaymentTypeBtn(
                label: 'Credit',
                selected: paymentType == PaymentType.credit,
                onTap: () => ref
                    .read(selectedPaymentTypeProvider.notifier)
                    .state = PaymentType.credit,
              ),
            ],
          ),
          if (paymentType == PaymentType.credit) ...[
            const SizedBox(height: 10),
            _CustomerSelector(selected: selectedCustomer),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isEmpty || isLoading
                  ? null
                  : () => ref.read(orderSubmitProvider.notifier).submit(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Confirm Order',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTypeBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentTypeBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 44,
          decoration: BoxDecoration(
            color: selected ? Colors.blue.shade700 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomerSelector extends ConsumerWidget {
  final User? selected;

  const _CustomerSelector({required this.selected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return users.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const Text('Failed to load customers',
          style: TextStyle(color: Colors.red)),
      data: (users) => DropdownButtonFormField<User>(
        value: selected,
        hint: const Text('Select customer'),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          isDense: true,
        ),
        items: users
            .map((u) => DropdownMenuItem(value: u, child: Text(u.name)))
            .toList(),
        onChanged: (u) =>
            ref.read(selectedCustomerProvider.notifier).state = u,
      ),
    );
  }
}
