import 'dart:math';
import 'package:flutter/material.dart';
import 'discount_result.dart';
import 'result_page.dart';

class DiscountPage extends StatefulWidget {
  final String userName;
  final String region;

  const DiscountPage({
    super.key,
    required this.userName,
    required this.region,
  });

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  final TextEditingController _originalPriceController =
  TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();

  late bool _isVatLocked;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _isVatLocked = widget.region.toLowerCase() == 'lebanon';

    if (_isVatLocked) {
      _taxController.text = '11';
    }
  }

  @override
  void dispose() {
    _originalPriceController.dispose();
    _discountController.dispose();
    _couponController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  double _randomDoubleInRange(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  void _calculate() {
    final originalPrice =
    double.tryParse(_originalPriceController.text.trim());
    final discount = double.tryParse(_discountController.text.trim());
    final coupon = double.tryParse(_couponController.text.trim());
    final tax = double.tryParse(_taxController.text.trim());

    if (originalPrice == null ||
        discount == null ||
        coupon == null ||
        tax == null) {
      _showError('Please fill all fields with valid numbers.');
      return;
    }

    if (originalPrice < 0 || discount < 0 || coupon < 0 || tax < 0) {
      _showError('Values cannot be negative.');
      return;
    }

    final result = DiscountResult.fromInputs(
      originalPrice: originalPrice,
      discountPercent: discount,
      couponPercent: coupon,
      taxPercent: tax,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: ResultPage(
            result: result,
            showAdvancedInfo: true,
          ),
        ),
      ),
    );
  }

  void _clear() {
    _originalPriceController.clear();
    _discountController.clear();
    _couponController.clear();

    if (_isVatLocked) {
      _taxController.text = '11';
    } else {
      _taxController.clear();
    }
  }

  void _fillExample() {
    // Random original price between 10 and 500
    final examplePrice = _randomDoubleInRange(10, 500);
    // Random discount between 5% and 60%
    final exampleDiscount = _randomDoubleInRange(5, 60);
    // Random coupon between 0% and 30%
    final exampleCoupon = _randomDoubleInRange(0, 30);
    // VAT: fixed 11% for Lebanon, random 0–20% otherwise
    final exampleVat = _isVatLocked
        ? 11.0
        : _randomDoubleInRange(0, 20);

    _originalPriceController.text = examplePrice.toStringAsFixed(2);
    _discountController.text = exampleDiscount.toStringAsFixed(0);
    _couponController.text = exampleCoupon.toStringAsFixed(0);
    _taxController.text = exampleVat.toStringAsFixed(0);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final isLebanon = _isVatLocked;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Offer Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Text(
                widget.userName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${widget.userName} 👋',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'VAT region: ${widget.region}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            const Text(
              'Fill the form:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _originalPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Original price',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Discount %',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _couponController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Extra coupon %',
                suffixText: '%',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _taxController,
              enabled: !_isVatLocked,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'VAT %',
                suffixText: '%',
                border: const OutlineInputBorder(),
                helperText: isLebanon
                    ? 'VAT is fixed to 11% for Lebanon.'
                    : 'You can change VAT when region is unspecified.',
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _calculate,
                    icon: const Icon(Icons.check),
                    label: const Text('Calculate'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clear,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _fillExample,
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('Use example values'),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
