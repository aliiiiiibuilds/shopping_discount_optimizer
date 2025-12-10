class DiscountResult {
  final double originalPrice;
  final double discountPercent;
  final double couponPercent;
  final double taxPercent;

  final double priceAfterDiscount;
  final double priceAfterCoupon;
  final double finalPriceWithTax;
  final double baselinePriceWithTax;
  final double savings;
  final double savingsPercent;
  final String dealMessage;

  DiscountResult({
    required this.originalPrice,
    required this.discountPercent,
    required this.couponPercent,
    required this.taxPercent,
    required this.priceAfterDiscount,
    required this.priceAfterCoupon,
    required this.finalPriceWithTax,
    required this.baselinePriceWithTax,
    required this.savings,
    required this.savingsPercent,
    required this.dealMessage,
  });

  factory DiscountResult.fromInputs({
    required double originalPrice,
    required double discountPercent,
    required double couponPercent,
    required double taxPercent,
  }) {
    final priceAfterDiscount =
        originalPrice * (1 - discountPercent / 100);

    final priceAfterCoupon =
        priceAfterDiscount * (1 - couponPercent / 100);

    final finalPriceWithTax =
        priceAfterCoupon * (1 + taxPercent / 100);

    final baselinePriceWithTax =
        originalPrice * (1 + taxPercent / 100);

    final savings = baselinePriceWithTax - finalPriceWithTax;

    // FIXED: must use 0.0 instead of 0
    final savingsPercent =
    baselinePriceWithTax > 0
        ? (savings / baselinePriceWithTax) * 100
        : 0.0;

    String dealMessage;
    if (savingsPercent >= 40) {
      dealMessage = 'Amazing deal 🎉';
    } else if (savingsPercent >= 20) {
      dealMessage = 'Good deal ✅';
    } else if (savingsPercent >= 5) {
      dealMessage = 'Small discount 🤏';
    } else {
      dealMessage = 'Not really a deal 😕';
    }

    return DiscountResult(
      originalPrice: originalPrice,
      discountPercent: discountPercent,
      couponPercent: couponPercent,
      taxPercent: taxPercent,
      priceAfterDiscount: priceAfterDiscount,
      priceAfterCoupon: priceAfterCoupon,
      finalPriceWithTax: finalPriceWithTax,
      baselinePriceWithTax: baselinePriceWithTax,
      savings: savings,
      savingsPercent: savingsPercent,
      dealMessage: dealMessage,
    );
  }
}
