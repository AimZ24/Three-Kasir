part of '../page.dart';

class _ProfileSection extends StatefulWidget {
  const _ProfileSection();

  @override
  State<_ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<_ProfileSection> {
  String _name = 'Contoh Nama';
  String _email = 'punyamu@gmail.com';
  String _phone = '+62123456789';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('profile_name') ?? _name;
      _email = prefs.getString('profile_email') ?? _email;
      _phone = prefs.getString('profile_phone') ?? _phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.defaultSize),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.dp50),
            child: Container(
              width: 64,
              height: 64,
              color: context.theme.primaryColor.withAlpha((0.2 * 255).round()),
              child: Icon(
                Icons.person,
                size: 40,
                color: context.theme.primaryColor,
              ),
            ),
          ),
          Dimens.dp16.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RegularText.semiBold(_name),
                Dimens.dp4.height,
                RegularText(
                  _email,
                  style: const TextStyle(
                    fontSize: Dimens.dp12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Dimens.dp4.height,
                RegularText(
                  _phone,
                  style: const TextStyle(
                    fontSize: Dimens.dp12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, ProfilePage.routeName);
              if (result == true) {
                _loadProfile();
              }
            },
            icon: Icon(
              AppIcons.edit,
              color: context.theme.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
