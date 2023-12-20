import 'package:citame/Widgets/profile_row.dart';
import 'package:citame/models/user_model.dart';
import 'package:citame/pages/pages_1/pages_2/business_registration_page.dart';
import 'package:citame/pages/signin_page.dart';
import 'package:citame/providers/user_provider.dart';
import 'package:citame/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ProfilePage extends ConsumerWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Usuario user = ref.watch(userProvider);
    IO.Socket socket;
    void connect() {
      socket = IO.io('http://ubuntu.citame.store/', <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });
      socket.connect();
      socket.emit("UsuarioRegistrado", user.userEmail);
      socket.onConnect((data) => print('Connected'));
      print(socket.connected);
      //socket.disconnect();
    }

    connect();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: API.estiloJ16negro,
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(240, 240, 240, 1),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                //padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                  )
                ]),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(16),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Color(0x4d39d2c0),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(user.avatar),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: SizedBox(
                        height: 90,
                        width: 90,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.userName,
                            textAlign: TextAlign.left,
                            style: API.estiloJ24negro),
                        Text(user.userEmail,
                            textAlign: TextAlign.left,
                            style: API.estiloJ14gris),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  'Perfil',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.plusJakartaSans(
                    color: Color(0xff57636c),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              ProfileRow(
                description: 'Favoritos',
                icon: Icons.favorite,
                page: Placeholder(),
                method: 2,
              ),
              ProfileRow(
                description: 'Información personal',
                icon: Icons.person,
                page: Placeholder(),
                method: 2,
              ),
              ProfileRow(
                description: 'Ver mis negocios',
                icon: Icons.store,
                page: Placeholder(),
                method: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  'Beneficios',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.plusJakartaSans(
                    color: Color(0xff57636c),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              ProfileRow(
                description: 'Pagos',
                icon: Icons.payment,
                page: Placeholder(),
                method: 2,
              ),
              ProfileRow(
                description: 'Donaciones',
                icon: Icons.handshake,
                page: Placeholder(),
                method: 2,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  'Actividad',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.plusJakartaSans(
                    color: Color(0xff57636c),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              ProfileRow(
                description: 'Invitar amigos',
                icon: Icons.card_giftcard,
                page: Placeholder(),
                method: 2,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  'Configuración',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.plusJakartaSans(
                    color: Color(0xff57636c),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              ProfileRow(
                description: 'Notificaciones',
                icon: Icons.notifications,
                page: Placeholder(),
                method: 2,
              ),
              ProfileRow(
                description: 'Registrar mi negocio',
                icon: Icons.store,
                page: BusinessRegisterPage(),
                method: 2,
              ),
              ProfileRow(
                description: 'Cerrar sesión en otros dispositivos',
                icon: Icons.logout,
                page: SignInPage(),
                method: 0,
              ),
              ProfileRow(
                description: 'Cerrar sesión',
                icon: Icons.logout,
                page: SignInPage(),
                method: 0,
              ),
              SizedBox(height: 12)
            ],
          ),
        ),
      ),
    );
  }
}
