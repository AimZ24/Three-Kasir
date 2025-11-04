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
            child: Image.network(
              'https://www.google.com/imgres?q=davina%20karamoy&imgurl=https%3A%2F%2Fcdns.klimg.com%2Fkapanlagi.com%2Fp%2Fdavinakaramoy7.jpg&imgrefurl=https%3A%2F%2Fwww.kapanlagi.com%2Fshowbiz%2Fselebriti%2Fprofil-dan-biodata-davina-karamoy-artis-cantik-yang-berubah-antagonis-di-film-ipar-adalah-maut-55e2d4.html&docid=QIujDkIYwLhgJM&tbnid=3TwaISB0xIki4M&vet=12ahUKEwifs-PJ2tOQAxWs-jgGHaOyL6kQM3oECBcQAA..i&w=1080&h=1350&hcb=2&ved=2ahUKEwifs-PJ2tOQAxWs-jgGHaOyL6kQM3oECBcQAA',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
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
                ),
                Dimens.dp4.height,
                RegularText(
                  _phone,
                  style: const TextStyle(
                    fontSize: Dimens.dp12,
                  ),
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
