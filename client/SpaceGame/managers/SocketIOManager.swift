import SocketIO
import UIKit

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()

    let manager = SocketManager(socketURL: URL(string: "ws://localhost:8080/")!, config: [.log(true), .compress])

    var socket: SocketIOClient!

    override init() {
        super.init()

        socket = manager.defaultSocket
    }

    //Function for your app to emit some information to your server.
    func emit(event: String, message: [String: Any]){
        print("Sending Message: \([message])")
        socket.emit(event, with: [message])
    }
    
    func emit(event: String, items: SocketData){
        print("Sending Message: \(items)")
        socket.emit(event, items)
    }
    
    func listen(event: String, callback: @escaping NormalCallback) {
        socket.on(event, callback: callback)
    }

    //Function to establish the socket connection with your server. Generally you want to call this method from your `Appdelegate` in the `applicationDidBecomeActive` method.
    func establishConnection() {
        socket.connect()
        print("Connected to Socket !")
    }

    //Function to close established socket connection. Call this method from `applicationDidEnterBackground` in your `Appdelegate` method.
    func closeConnection() {
        socket.disconnect()
        print("Disconnected from Socket !")
    }
}
