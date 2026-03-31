import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';
import '../../payments/models/payment_model.dart';
import '../providers/order_detail_provider.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('#${orderId.substring(0, 8)}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.toString(),
                  style: TextStyle(color: Colors.red.shade700),
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(orderDetailProvider(orderId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (order) => _OrderDetailBody(order: order),
      ),
    );
  }
}

class _OrderDetailBody extends ConsumerWidget {
  final Order order;

  const _OrderDetailBody({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(orderPaymentsProvider(order.id));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _StatusHeader(order: order),
        const SizedBox(height: 14),
        _AmountSummaryCard(order: order),
        const SizedBox(height: 14),
        _ItemsCard(items: order.items),
        const SizedBox(height: 14),
        _PaymentHistoryCard(paymentsAsync: paymentsAsync),
      ],
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final Order order;

  const _StatusHeader({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case 'paid':
        return Colors.green.shade600;
      case 'partial':
        return Colors.orange.shade700;
      default:
        return Colors.red.shade700;
    }
  }

  String get _statusLabel {
    switch (order.status) {
      case 'paid':
        return 'Paid';
      case 'partial':
        return 'Partial';
      default:
        return 'Unpaid';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _statusColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _statusLabel,
            style: TextStyle(
              color: _statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            order.paymentType.toUpperCase(),
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _AmountSummaryCard extends StatelessWidget {
  final Order order;

  const _AmountSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final pct = order.totalAmount > 0
        ? (order.paidAmount / order.totalAmount).clamp(0.0, 1.0)
        : 0.0;

    return _Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AmountItem(
                label: 'Total',
                value: '${order.totalAmount.toStringAsFixed(0)} F',
                color: Colors.black87,
              ),
              _AmountItem(
                label: 'Paid',
                value: '${order.paidAmount.toStringAsFixed(0)} F',
                color: Colors.green.shade600,
              ),
              _AmountItem(
                label: 'Remaining',
                value: '${order.remainingAmount.toStringAsFixed(0)} F',
                color: order.remainingAmount > 0
                    ? Colors.red.shade700
                    : Colors.green.shade600,
                large: true,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: Colors.red.shade100,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.green.shade500),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(pct * 100).toStringAsFixed(0)}% paid',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool large;

  const _AmountItem({
    required this.label,
    required this.value,
    required this.color,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: large ? 18 : 15,
          ),
        ),
      ],
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final List<OrderItem> items;

  const _ItemsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Items',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const Text('No items',
                style: TextStyle(color: Colors.grey))
          else
            ...items.map((item) => _ItemRow(item: item)),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final OrderItem item;

  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final subtotal = item.unitPrice * item.quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${item.quantity}×',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.productId.substring(0, 8),
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
          Text(
            '${item.unitPrice.toStringAsFixed(0)} F',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Text(
            '${subtotal.toStringAsFixed(0)} F',
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _PaymentHistoryCard extends StatelessWidget {
  final AsyncValue<List<Payment>> paymentsAsync;

  const _PaymentHistoryCard({required this.paymentsAsync});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment History',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          paymentsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (e, _) => Text(e.toString(),
                style: TextStyle(color: Colors.red.shade700)),
            data: (payments) => payments.isEmpty
                ? const Text('No payments yet',
                    style: TextStyle(color: Colors.grey))
                : Column(
                    children: payments
                        .asMap()
                        .entries
                        .map((e) => _PaymentRow(
                            index: e.key + 1, payment: e.value))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final int index;
  final Payment payment;

  const _PaymentRow({required this.index, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '#${payment.id.substring(0, 8)}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Text(
            '+${payment.amount.toStringAsFixed(0)} F',
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
