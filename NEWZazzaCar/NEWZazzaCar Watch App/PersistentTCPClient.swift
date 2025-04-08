//
//  PersistentTCPClient.swift
//  NEWZazzaCar
//
//  Created by Andrew Czarnik on 4/8/25.
//

import Network

import Foundation

import Combine // Needed for ObservableObject

 

class PersistentTCPClient: ObservableObject {

 

    // MARK: - Published Properties for UI Updates

    @Published var isConnected: Bool = false

    @Published var statusMessage: String = "Disconnected"

    @Published var lastReceivedMessage: String = "" // Optional: Display last message

 

    // MARK: - Private Properties

    private let host: NWEndpoint.Host

    private let port: NWEndpoint.Port

    private var connection: NWConnection?

    private let queue = DispatchQueue(label: "com.example.watchTCPClient.queue", qos: .background)

 

    // MARK: - Initialization

    init(host: String, port: UInt16) {

        self.host = NWEndpoint.Host(host)

        guard let endpointPort = NWEndpoint.Port(rawValue: port) else {

            fatalError("Invalid port specified: \(port)")

        }

        self.port = endpointPort

        updateStatus("Initialized for \(host):\(port)")

    }

 

    // MARK: - Connection Lifecycle

    func connect() {

        guard !isConnected && connection == nil else {

            updateStatus("Already connected or connecting.")

            return

        }

 

        updateStatus("Connecting to \(host):\(port)...")

        let parameters = NWParameters.tcp

        connection = NWConnection(host: host, port: port, using: parameters)

 

        connection?.stateUpdateHandler = { [weak self] newState in

            guard let self = self else { return }

           

            // Ensure UI updates are on the main thread

            DispatchQueue.main.async {

                self.handleStateUpdate(newState)

            }

        }

 

        // Start the connection process on our dedicated queue

        connection?.start(queue: queue)

    }

 

    private func handleStateUpdate(_ newState: NWConnection.State) {

         updateStatus("State: \(newState)") // Log state change

 

         switch newState {

         case .ready:

             self.isConnected = true

             self.updateStatus("✅ Connected")

             self.receive() // Start listening

 

         case .failed(let error):

             self.updateStatus("❌ Failed: \(error.localizedDescription)")

             self.cleanupConnection()

 

         case .cancelled:

             self.updateStatus("🔌 Disconnected")

             self.cleanupConnection()

 

         case .waiting(let error):

              self.updateStatus("⏳ Waiting: \(error.localizedDescription)")

              self.isConnected = false

 

         case .preparing:

              self.updateStatus("⚙️ Preparing...")

              self.isConnected = false

 

         case .setup:

              self.updateStatus("🛠️ Setup...")

              self.isConnected = false

 

         @unknown default:

             self.updateStatus("❓ Unknown state")

             self.isConnected = false // Assume not connected

         }

    }

 

 

    func disconnect() {

        guard let connection = connection else {

            updateStatus("Already disconnected.")

            return

        }

        updateStatus("Disconnecting...")

        connection.cancel()

        // The .cancelled state handler will call cleanupConnection

    }

 

    private func cleanupConnection() {

        // Ensure called on main thread if it might result from a direct UI action

        // If only called from stateUpdateHandler (already on main), this is fine.

        // Adding safety:

        DispatchQueue.main.async {

             self.connection = nil

             self.isConnected = false

             // Don't reset status message here, keep the last state (Failed/Disconnected)

        }

    }

 

    // MARK: - Sending Data

    func send(message: String) {

        guard let connection = self.connection else {

            updateStatus("Error: Not connected.")

            return

        }

 

        // Can optionally check isConnected here, but NWConnection queues sends before .ready

        // if !isConnected { updateStatus("Warning: Sending while not ready."); return }

 

        guard let data = message.data(using: .utf8) else {

            updateStatus("Error: Failed to encode message.")

            return

        }

 

        connection.send(content: data, completion: .contentProcessed { [weak self] error in

             DispatchQueue.main.async { // Update UI from main thread

                guard let self = self else { return }

                if let error = error {

                    self.updateStatus("❌ Send Error: \(error.localizedDescription)")

                    // Consider auto-disconnecting on send error

                    // self.disconnect()

                } else {

                    // Optionally update status on successful send

                     self.updateStatus("Sent: \(message.trimmingCharacters(in: .newlines))")

                    print("Sent: \(message)") // Log to console

                }

            }

        })

    }

 

    // MARK: - Receiving Data

    private func receive() {

        guard let connection = self.connection else { return }

 

        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] (data, context, isComplete, error) in

            guard let self = self else { return }

 

            // Ensure UI/State updates run on the main thread

            DispatchQueue.main.async {

                if let receivedData = data, !receivedData.isEmpty {

                    let receivedText = String(data: receivedData, encoding: .utf8) ?? "Non-UTF8 Data"

                    self.lastReceivedMessage = receivedText // Update published property

                    self.updateStatus("Received data") // Simple status update

                    print("Received: \(receivedText)") // Log

                }

 

                if isComplete {

                    self.updateStatus("Peer closed connection.")

                    self.cleanupConnection() // State handler might also call this via .cancelled

                    return // Stop receive loop

                }

 

                if let error = error {

                    // If error is posix(54) "Connection reset by peer", it's a common disconnect reason

                    if let nwError = error as? NWError, nwError == .posix(.ECONNRESET) {

                         self.updateStatus("Connection reset by peer.")

                    } else {

                         self.updateStatus("❌ Receive Error: \(error.localizedDescription)")

                    }

                    self.cleanupConnection() // Disconnect on receive error

                    return // Stop receive loop

                }

 

                // --- IMPORTANT ---

                // Continue listening if connection still active

                 if self.isConnected { // Check if we are still logically connected

                    self.receive()

                 }

            }

        }

    }

 

    // MARK: - Helper

    private func updateStatus(_ message: String) {

         // Ensure updates are on the main thread, especially if called from background queue directly

         DispatchQueue.main.async {

            print("Status Update: \(message)") // Log status changes

            self.statusMessage = message

         }

    }

}
