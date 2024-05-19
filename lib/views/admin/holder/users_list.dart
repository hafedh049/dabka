import 'package:dabka/models/user_account_model.dart';
import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import 'add_user.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key, required this.users});
  final List<UserModel> users;
  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Users List", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
            const Spacer(),
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const AddUser())),
              icon: Icon(FontAwesome.circle_plus_solid, color: purple, size: 15),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Card(
              elevation: 6,
              shadowColor: dark,
              child: SizedBox(
                height: 40,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(5)),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                            contentPadding: const EdgeInsets.all(16),
                            hintStyle: GoogleFonts.itim(color: grey, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                      child: const Icon(FontAwesome.searchengin_brand, color: white, size: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder<bool>(
            future: null,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return ListView.separated(
                itemBuilder: (BuildContext context, int index) => GestureDetector(
                  onLongPress: () {
                    showBottomSheet(
                      context: context,
                      builder: (BuildContext context) => Container(
                        color: white,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("Are you sure ?", style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 20),
                            Row(
                              children: <Widget>[
                                const Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(purple)),
                                  child: Text("OK", style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(grey.withOpacity(.3))),
                                  child: Text("CANCEL", style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shadowColor: dark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: white,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: widget.users[index].userAvatar.isEmpty
                                  ? DecorationImage(
                                      image: AssetImage("assets/images/nobody.png"),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: NetworkImage(widget.users[index].userAvatar),
                                      fit: BoxFit.cover,
                                    ),
                              border: Border.all(width: 2, color: pink),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(2),
                                color: purple,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                child: Text("UID", style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(width: 10),
                              Flexible(child: Text(widget.users[index].userID, style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(2),
                                color: purple,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                child: Text("USERNAME", style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(width: 10),
                              Flexible(child: Text(widget.users[index].username, style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(2),
                                color: purple,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                child: Text("E-MAIL", style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(width: 10),
                              Flexible(child: Text(widget.users[index].email.isEmpty ? "NOT SET" : widget.users[index].email, style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(2),
                                color: purple,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                child: Text("PHONE NUMBER", style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(width: 10),
                              Flexible(child: Text(widget.users[index].phoneNumber, style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(2),
                                color: purple,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                child: Text("TYPE(S)", style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, int indexed) => Text(widget.users[index].userType[indexed].toUpperCase(), style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500)),
                                  separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
                                  itemCount: widget.users[index].userType.length,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                itemCount: widget.users.length,
              );
            },
          ),
        ),
      ],
    );
  }
}
