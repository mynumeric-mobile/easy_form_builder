// ignore:  camel_case_types
// ignore_for_file: constant_identifier_names

enum CarTypes { A1, A2, A3, Zafira, Insigna, Vectra, EQE, EQS }

enum Brands {
  Audi,
  Opel,
  Mercedes;

  List<CarTypes> get modelsList {
    switch (this) {
      case Brands.Audi:
        return [CarTypes.A1, CarTypes.A2, CarTypes.A3];
      case Brands.Opel:
        return [CarTypes.Zafira, CarTypes.Insigna, CarTypes.Vectra];
      case Brands.Mercedes:
        return [CarTypes.EQE, CarTypes.EQS];
    }
  }
}

class Car {
  Brands brand = Brands.Opel;
  CarTypes carType = CarTypes.Insigna;

  Map<String, dynamic> toJson() {
    return {"brand": brand.index, "type": brand.modelsList.indexOf(carType)};
  }

  static Car fromJson(json) {
    var brand = json["brand"] == null ? Brands.Opel : Brands.values[json["brand"]];

    return Car()
      ..brand = brand
      ..carType = brand.modelsList[json["type"] ?? 0];
  }

  @override
  toString() {
    return "a ${brand.name} ${carType.name}";
  }
}
