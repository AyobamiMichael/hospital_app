import 'dart:io';

class UDPReceiver {
  final String host;
  final int port;
  late RawDatagramSocket _socket;

  UDPReceiver(this.host, this.port);

  Future<void> initSocket() async {
    print('okay socvket');
    _socket = await RawDatagramSocket.bind(InternetAddress(host), port);
    // print(host + port.toString());
    _socket.listen((event) {
      if (event == RawSocketEvent.read) {
        Datagram? datagram = _socket.receive();
        if (datagram != null) {
          print('Received message: ${String.fromCharCodes(datagram.data)}');
        }
      }
    });
  }

//  Stream<RawSocketEvent> get receiveStream => _socket.asBroadcastStream();

  void close() {
    _socket.close();
  }
}
