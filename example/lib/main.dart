// import 'package:device_preview/device_preview.dart';
import 'package:example/helpers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:solwave/solwave.dart';

/// Uncomment this once you intialize firebase
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

      /// Uncomment this once you intialize firebase
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  runApp(
    // DevicePreview(
    //   enabled: true,
    //   builder: (_) =>
    const MyApp(),
    // ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Solwave.instance.init(
      apiKey: 'YOUR API KEY',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solwave Flutter',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black87,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Solwave Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    getWallet();

    DateTime now = DateTime.now();
    currentYear = now.year;

    super.initState();
  }

  bool isWalletAvailable = false;
  WalletEntity? wallet;
  int balance = 0;

  late int currentYear;
  // Extract the current year

  getWallet() async {
    final w = await Solwave.instance.getUserWallet();
    if (w != null) {
      final b = await getBalance(w.publicAddress!);

      setState(() {
        wallet = w;
        balance = b;
        isWalletAvailable = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    getWallet();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF111218), Color(0xFF111218)],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: SvgPicture.asset(
                  'assets/rhombus.svg',
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Transform.scale(
                  scale: -1.0,
                  child: SvgPicture.asset(
                    'assets/rhombus.svg',
                    width: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  '© $currentYear Saganize',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white60,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Solwave',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/pbsaganize.svg',
                                fit: BoxFit.fitWidth,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SocialIcon(
                                icon: 'assets/github.svg',
                                onPress: () {
                                  launchURL('https://github.com/Saganize');
                                },
                              ),
                              SocialIcon(
                                icon: 'assets/twitter.svg',
                                onPress: () {
                                  launchURL('https://twitter.com/saganize');
                                },
                              ),
                              SocialIcon(
                                icon: 'assets/saga.svg',
                                onPress: () {
                                  launchURL('https://saganize.com/');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Solwave.instance.selectWallet(
                                context,
                                onWalletSelection: (wallet) {
                                  getWallet();
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey[500]!,
                                    width: 1.5,
                                  ),
                                  left: BorderSide(
                                    color: Colors.grey[500]!,
                                    width: 1.5,
                                  ),
                                  right: BorderSide(
                                    color: Colors.grey[500]!,
                                    width: 1.5,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF111220)
                                        // Color(0xFF2380EA)
                                        .withOpacity(0.35),
                                    blurRadius: 35,
                                    offset: const Offset(0, 30),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              child: Text(
                                !isWalletAvailable
                                    ? 'Select Wallet'
                                    : truncateString(wallet!.publicAddress!),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '${balance / 1000000000} SOL',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      const Text(
                        'Solwave Flutter Scaffold',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Unleash the full power of Blockchain with \nSolana and Flutter.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      SolwaveButton(
                        label: 'AIRDROP 1 SOL',
                        onPressed: !isWalletAvailable
                            ? null
                            : () async {
                                await requestAirdrop(wallet!.publicAddress!);
                                getWallet();
                              },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SolwaveButton(
                        label: 'SIGN MESSAGE',
                        onPressed: !isWalletAvailable
                            ? null
                            : () {
                                Solwave.instance.signMessage(context,
                                    message:
                                        '''The quick brown fox jumps over the lazy dog''',
                                    onMessageSigned: (singature, message) {
                                  debugPrint('Signature callback $singature');
                                });
                              },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SolwaveButton(
                        label: 'SEND TRANSACTION',
                        onPressed: !isWalletAvailable
                            ? null
                            : () {
                                Solwave.instance.sendTransaction(
                                  context,
                                  transaction: SolanaTransaction(
                                    instructions: [
                                      SystemInstruction.transfer(
                                        fundingAccount:
                                            Ed25519HDPublicKey.fromBase58(
                                                wallet!.publicAddress!),
                                        recipientAccount:
                                            Ed25519HDPublicKey.fromBase58(
                                                'Bu3mTU2X7SoZUkyNU37jispVqRLkSSwiQuN6rGbvQx9f'),
                                        lamports: 100000,
                                      )
                                    ],
                                  ),
                                  onTransacitonComplete: (_) {
                                    getWallet();
                                  },
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SolwaveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const SolwaveButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.7), width: 1.5),
            ),
            borderRadius: BorderRadius.circular(15)),
        child: TextButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
              const Size.fromHeight(50),
            ),
            elevation: const MaterialStatePropertyAll(2.0),
            backgroundColor: MaterialStateProperty.all<Color>(
                onPressed == null ? Colors.white30 : const Color(0xff2380EA)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final String icon;
  final VoidCallback onPress;
  const SocialIcon({
    Key? key,
    required this.icon,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: GestureDetector(
        onTap: onPress,
        child: SvgPicture.asset(
          icon,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
