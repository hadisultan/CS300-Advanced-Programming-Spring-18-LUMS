const fs = require('fs')
const http = require('http')
const socketio = require('socket.io')

const readFile = file => new Promise((resolve, reject) =>
    fs.readFile(file, 'utf8', (err, data) => err ? reject(err) : resolve(data)))

const delay = msecs => new Promise(resolve => setTimeout(resolve, msecs))

const server = http.createServer(async (request, response) =>
    response.end(await readFile(request.url.substr(1))))

const io = socketio(server)

players = {}
count = 0

const validate = () => {
	for(var i=0; i<players[1].aircrafts.length; i++)
	{
		if(aircrafts[i]>10)
		{
			aircrafts = []
		}
	}
	for(var i=0; i<players[1].battleships.length; i++)
	{
		if(battleships[i]>10)
		{
			battleships = []
		}
	}
	for(var i=0; i<players[1].cruisers.length; i++)
	{
		if(cruisers[i]>10)
		{
			cruisers = []
		}
	}
	for(var i=0; i<players[1].destroyers.length; i++)
	{
		if(destroyers[i]>10)
		{
			destroyers = []
		}
	}
	for(var i=0; i<players[1].submarines.length; i++)
	{
		if(submarines[i]>10)
		{
			submarines = []
		}
	}
}

io.sockets.on('connection', socket => {
    console.log('a client connected')
    count++
    players[count] = socket
    players[count][aircrafts] = []
    players[count][battleships] = []
    players[count][cruisers] = []
    players[count][destroyers] = []
    players[count][submarines] = []
    socket.on('aircrafts', data => socket[aircrafts])
    socket.on('battleships', data => socket[battleships])
    socket.on('cruisers', data => socket[cruisers])
    socket.on('destroyers', data => socket[destroyers])
    socket.on('submarines', data => socket[submarines])

    socket.on('disconnect', () => console.log('a client disconnected'))
})

server.listen(8000)
