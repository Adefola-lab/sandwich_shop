class PricingRepository {
  final Map<String, double> _priceTable = {
    'six-inch': 7.00,
    'footlong': 11.00,
  };

  double calculateTotalPrice(String size, int quantity) {
    // Normalize size input (e.g., "Small" → "small")
    final normalizedSize = size.toLowerCase();

    // Validate and get the price
    final pricePerSandwich = _priceTable[normalizedSize];

    // Calculate total cost
    final total = pricePerSandwich! * quantity;
    return total;
  }
}
