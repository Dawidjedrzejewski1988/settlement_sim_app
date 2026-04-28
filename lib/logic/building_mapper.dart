class BuildingMapper {
  static String mapLabelToType(
    String label,
  ) {
    switch (label) {
      case "Obóz drwali":
        return "LumberCamp";

      case "Obóz zbieraczy":
        return "GatherersCamp";

      case "Chata":
        return "Cottage";

      case "Dom":
        return "House";

      case "Magazyn":
        return "Warehouse";

      case "Rynek":
        return "Market";

      case "Karczma":
        return "Tavern";

      case "Tartak":
        return "Sawmill";

      case "Kamieniołom":
        return "Quarry";

      case "Warsztat":
        return "Workshop";

      case "Farma":
        return "Farm";

      case "Młyn":
        return "Mill";

      case "Piekarnia":
        return "Bakery";

      default:
        return "House";
    }
  }
}
