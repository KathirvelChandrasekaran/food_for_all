class PostQuantity {
  final int foodQuantity;
  final int nosPersons;

  PostQuantity(this.foodQuantity, this.nosPersons);

  PostQuantity.fromMap(Map<String, dynamic> map)
      : assert(map['foodQuantity'] != null),
        assert(map['nosPersons'] != null),
        foodQuantity = map['foodQuantity'],
        nosPersons = map['nosPersons'];

  @override
  String toString() => "Record<$foodQuantity:$nosPersons>";
}
