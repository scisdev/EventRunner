import 'dart:io';

import 'package:event_runner/business_logic/api/scan_qr_api.dart';
import 'package:event_runner/business_logic/cubit/scan_qr/cubit.dart';
import 'package:event_runner/business_logic/cubit/scan_qr/state.dart';
import 'package:event_runner/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrView extends StatefulWidget {
  const QrView({Key? key}) : super(key: key);

  @override
  _QrViewState createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
  final key = GlobalKey();
  QRViewController? controller;
  String _prev = '';

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<QrScanCubit, ScanQrState>(
        listener: (ctx, state) {
          if (state is ScanQrFailure) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.description),
            ));
          } else if (state is ScanQrSuccess) {
            final res = state.res;
            if (res is AchievementWithEvent) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Вы получили достижение ${res.achievement.name}!\n'
                  '${res.achievement.desc}',
                ),
              ));
            } else if (res is StepWithEvent) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  '"${res.event.name}"\n'
                  'Шаг "${res.step.name}" пройден!',
                ),
              ));
            } else if (res is EntryForEvent) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Добро пожаловать на "${res.event.name}"!',
                ),
              ));
            } else if (res is ExitForEvent) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Спасибо, что приняли участие в "${res.event.name}"!',
                ),
              ));
            }
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Opacity(
                opacity: state is ScanQrLoading ? .3 : 1,
                child: QRView(
                  key: key,
                  onQRViewCreated: (c) {
                    controller = c;
                    c.scannedDataStream.listen((scanData) {
                      final code = scanData.code;
                      if (code == null) return;

                      if (_prev == code) return;
                      BlocProvider.of<QrScanCubit>(context).scan(code);
                      _prev = code;
                    });
                  },
                  overlay: QrScannerOverlayShape(
                    cutOutSize: MediaQuery.of(context).size.width * 2 / 3,
                    borderRadius: 20,
                    borderColor: Colors.white,
                    borderWidth: 8,
                  ),
                ),
              ),
              Visibility(
                visible: state is ScanQrLoading,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
