import SwiftUI
import Network

class TCPClient {
    private var connection: NWConnection?
    private let queue = DispatchQueue(label: "TCP Client Queue")

    init(host: String, port: UInt16) {
        let nwEndpoint = NWEndpoint.Host(host)
        let nwPort = NWEndpoint.Port(rawValue: port)!

        connection = NWConnection(host: nwEndpoint, port: nwPort, using: .tcp)
        connection?.start(queue: queue)
    }

    func send(_ message: String) {
        guard let connection = connection else { return }

        let data = message.data(using: .utf8) ?? Data()
        connection.send(content: data, completion: .contentProcessed({ error in
            if let error = error {
                print("Send error: \(error)")
            } else {
                print("Sent: \(message)")
            }
        }))
    }

    func stop() {
        connection?.cancel()
    }
}

struct ControlWithCircle: View {
    @State private var isRedScreen = false

    var body: some View {
        ZStack {
            if isRedScreen {
                Color.red
                    .ignoresSafeArea()
                    .onTapGesture {
                        isRedScreen = false
                        tcpClient.send("CMD_M_MOTOR#0#0#0#0")
                    }
            } else {
                Color.black.ignoresSafeArea()

                VStack(spacing: 15) {
                    Button(action: {
                        tcpClient.send("CMD_M_MOTOR#180#1500#0#0")
                    }) {
                        Image(systemName: "triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .rotationEffect(.degrees(0))
                            .foregroundColor(Color(red: 0.5, green: 0.96, blue: 0.60))
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())

                    HStack(spacing: 12) {
                        Button(action: {
                            tcpClient.send("CMD_M_MOTOR#90#1500#0#0")
                        }) {
                            Image(systemName: "triangle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .rotationEffect(.degrees(-90))
                                .foregroundColor(Color(red: 0.5, green: 0.96, blue: 0.60))
                                .frame(width: 60, height: 60)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Button(action: {
                            isRedScreen = true
                            tcpClient.send("CMD_M_MOTOR#0#0#0#0") // Stop
                        }) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 60, height: 60)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Button(action: {
                            tcpClient.send("CMD_M_MOTOR#-90#1500#0#0")
                        }) {
                            Image(systemName: "triangle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .rotationEffect(.degrees(90))
                                .foregroundColor(Color(red: 0.5, green: 0.96, blue: 0.60))
                                .frame(width: 60, height: 60)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Button(action: {
                        tcpClient.send("CMD_M_MOTOR#0#1500#0#0")
                    }) {
                        Image(systemName: "triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .rotationEffect(.degrees(180))
                            .foregroundColor(Color(red: 0.5, green: 0.96, blue: 0.60))
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(32)
            }
        }
    }
}

struct ControlWithCircle_Previews: PreviewProvider {
    static var previews: some View {
        ControlWithCircle()
    }
}

#Preview {
    ControlWithCircle()
}

let tcpClient = TCPClient(host: "10.42.0.1", port: 5000)
