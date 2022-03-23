class ListItem {
  final String id;
  final String naslov;
  final double vrednost;
  final String opis;

  ListItem({
    required this.id,
    required this.naslov,
    required this.vrednost,
    this.opis = "Ova e default opis",
  });
}
