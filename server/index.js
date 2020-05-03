
var app = require('express')();
var http = require('http').createServer(app);
var io = require('socket.io')(http);

let players = []

io.on('connection', (socket) => {
  console.log('a user is connected');
  socket.on('playerConnect', (msg) => {
    let player = JSON.parse(msg.player)    

    if (players.length < 2) {
        players.push(player)
        console.log("players", players)
    } 
    
    if (players.length == 2) {
        io.emit("GameIsReady")
    }
  })
  socket.on('disconnect', () => {
    console.log('user disconnected');
  });
});

http.listen(8080, () => {
  console.log('listening on *:8080');
});