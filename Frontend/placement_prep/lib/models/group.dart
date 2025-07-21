class Group{
  final String id;
  final String name;
  final String description;
  final List<String> members;
  final List<String> admins;

  Group({required this.id, required this.name, required this.description, required this.members, required this.admins});


 factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      members: List<String>.from(json['members']),
      admins: List<String>.from(json['admins']),
    );
  }
}
