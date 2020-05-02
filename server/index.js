var WebSocketServer = require('websocket').server;
var http = require('http');
var players = []

var server = http.createServer(function(request, response) {
    console.log((new Date()) + ' Received request for ' + request.url);
    response.writeHead(404);
    response.end();
});
server.listen(8080, function() {
    console.log((new Date()) + ' Server is listening on port 8080');
});
 
wsServer = new WebSocketServer({
    httpServer: server,
    autoAcceptConnections: false
});
 
function originIsAllowed(origin) {
  return true;
}
 
wsServer.on('request', function(request) {
    if (!originIsAllowed(request.origin)) {
      request.reject();
      console.log((new Date()) + ' Connection from origin ' + request.origin + ' rejected.');
      return;
    }
    
    var connection = request.accept(null, request.origin);
    console.log((new Date()) + ' Connection accepted.');
    connection.on('message', function(message) {
        let player = JSON.parse(message.utf8Data)
        players.push(player)
        console.log("players", players)
        if (players.length >= 2) {
            console.log("send true")
            let test = {
                "bothAreConnected": true
            }
            let json = JSON.stringify(test)
            console.log("json", json)
            connection.send(json)
        } 
    });
    connection.on('close', function(reasonCode, description) {
        bothAreConnected = false
        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');
    });
});