class Item {
  final String id;
  final String name;
  final int quantity;

  Item(this.id, this.name, this.quantity);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }
}
