import 'package:flutter/material.dart';
import 'discount_page.dart';
import 'discount_result.dart';

class ResultPage extends StatelessWidget {
  final DiscountResult result;
  final bool showAdvancedInfo;

  const ResultPage({
    super.key,
    required this.result,
    required this.showAdvancedInfo,
  });

  Color _dealColor(ColorScheme scheme) {
    if (result.savingsPercent >= 40) return scheme.primary;
    if (result.savingsPercent >= 20) return scheme.secondary;
    if (result.savingsPercent >= 5) return scheme.tertiary;
    return scheme.error;
  }

  IconData _dealIcon() {
    if (result.savingsPercent >= 40) return Icons.star;
    if (result.savingsPercent >= 20) return Icons.thumb_up_alt_rounded;
    if (result.savingsPercent >= 5) return Icons.local_offer_rounded;
    return Icons.warning_amber_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation Result'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 16),
              child: child,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Summary',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _dealIcon(),
                            color: _dealColor(scheme),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            result.dealMessage,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Original price: \$${result.originalPrice.toStringAsFixed(2)}',
                      ),
                      Text(
                        'Final price (with tax): \$${result.finalPriceWithTax.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You save: \$${result.savings.toStringAsFixed(2)} '
                            '(${result.savingsPercent.toStringAsFixed(1)}%)',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (showAdvancedInfo) ...[
                const Text(
                  'Detailed Breakdown',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _row(
                  'After discount (${result.discountPercent.toStringAsFixed(1)}%):',
                  '\$${result.priceAfterDiscount.toStringAsFixed(2)}',
                ),
                _row(
                  'After coupon (${result.couponPercent.toStringAsFixed(1)}%):',
                  '\$${result.priceAfterCoupon.toStringAsFixed(2)}',
                ),
                _row(
                  'Baseline with tax (${result.taxPercent.toStringAsFixed(1)}%):',
                  '\$${result.baselinePriceWithTax.toStringAsFixed(2)}',
                ),
              ],

              const SizedBox(height: 28),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to calculator'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String left, String right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(left)),
          Text(
            right,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
