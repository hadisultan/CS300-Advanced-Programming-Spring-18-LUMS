
const fs = require('fs')
const http = require('http')
const socketio = require('socket.io')

const readFile = f => new Promise((resolve, reject) =>
	fs.readFile(f, (err,data) => err?reject(err):resolve(data) ))

const server = http.createServer(async (req, resp) => 
	resp.end(await readFile(req.url.substr(1))))


const io = socketio(server)

var count = 0
var top = 0

var table = [
  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' ', ' ', ' '], 
];

const redraw = (str, sprite) => {
	r=str[0] - '0'
	c=str[1] - '0'
	for(var i=0; i<6; i++)
	{
		if(i==5 && table[i][c]== ' ')
		{
			table[i][c] = sprite
			break
		}
		else if(table[i][c]!=' ')
		{
			if(i==0){
				top =1
				break
			}
			if(i>0)
			{
				table[i-1][c] = sprite
				break
				// console.log(`lun ${sprite}`)
			}
		}
	}
}

var state = 0
var statedic = {}
var winner = 0

const cw = () =>{
	var newspr = ''
	var spc = 0
	var check = 0
	for(var i=0; i<6; i++)
	{
		for(var j=0; j<7; j++)
		{
			check = 0
			newspr = table[i][j]
			if(newspr!=' ')
			{
				for(var k=0; k<4; k++)
				{
					if(j+k > 6)
					{
						check=0
						break
					}
					else if(newspr == table[i][k+j])
					{
						check++
					}
					else
					{
						check=0
						break
					}
				}
				if(check == 4)
				{
					if(statedic[1][1]==newspr)
					{
						winner = 1
					}
					else
					{
						winner = 2
					}
				}
				for(var k=0; k<4; k++)
				{
					if(i+k > 5)
					{
						check=0
						break
					}
					else if(newspr == table[i+k][j])
					{
						check++
					}
					else{
						check=0
						break
					}
				}
				if(check == 4)
				{
					if(statedic[1][1]==newspr)
					{
						winner = 1
					}
					else
					{
						winner = 2
					}
				}
				for(var k=0; k<4; k++)
				{
					if(j+k > 6 || k+i >5)
					{
						check=0;
						break;
					}
					else if(newspr == table[i+k][k+j])
					{
						check++
					}
					else{
						check =0
						break
					}
				}
				if(check == 4)
				{
					if(statedic[1][1]==newspr)
					{
						winner = 1
					}
					else
					{
						winner = 2
					}
				}
				for(var k=0; k<4; k++)
				{
					if(j+k > 6 || i-k<0)
					{
						check=0;
						break;
					}
					else if(newspr == table[i-k][k+j])
					{
						check++
					}
					else{
						check =0
						break
					}
				}
				if(check == 4)
				{
					if(statedic[1][1]==newspr)
					{
						winner = 1
					}
					else
					{
						winner = 2
					}
				}
			}
			else
			{
				spc++
			}
		}
	}
	if(spc == 0 && winner ==0)
	{
		winner = 3
	}
}

io.sockets.on('connection', socket => {
		count++
		io.sockets.emit('intromsg', 'Hello Client')
		socket.username = count
		socket.emit('user', socket.username)
		if(count%2 == 0)
		{
			if(statedic[2] == undefined){
				statedic[2] = [socket.username, 'X']
				socket.emit('player', 'You are player 2, your sprite is X.')
			}
			socket.emit('sprite', 'X')
		}
		else
		{
			if(statedic[1] == undefined){
				statedic[1] = [socket.username, 'O']
				socket.emit('player', 'You are player 1, your sprite is O.')
			}
			socket.emit('sprite', 'O')
		}
		if(statedic[1]!=undefined && statedic[2]!=undefined)
		{
			state = 1
			io.sockets.emit('msg', `Player 1's turn.`)
		}
		else
		{
			io.sockets.emit('msg', 'Waiting for player 2 to join.')
		}
		io.sockets.emit('table', table)
		socket.on('redraw', data => {
			if(statedic[state][0] == socket.username){
				let spr = data.mySprite
				//console.log(`sprite is ${spr}`)
				redraw(data.myStr, spr)
				cw()
				// if(winner == 0)
				// {
				// 	predict()
				// }
				io.sockets.emit('table', table)
				if(winner == 0){
					if(state==1){
						if(top == 0){
							state= 2
							io.sockets.emit('msg', `Player 2's turn.`)}
						else{
							top = 0
						}					
					}
					else if(state==2){
						if(top == 0){
							state = 1
							io.sockets.emit('msg', `Player 1's turn.`)}
						else{
							top = 0
						}
					}
				}
				else
				{
					if(winner == 1 || winner == 2)
					{
						var tempwinner = winner
						winner = 0;
						state = 1;
						table = [
								  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
								  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
								  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
								  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
								  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
								  [' ', ' ', ' ', ' ', ' ', ' ', ' '], 
								];
						io.sockets.emit('msg', `Player ${tempwinner} won, game restarted. Player 1's turn.`)				
					}
					else if(winner == 3){
						winner = 0;
						state = 1;
						table = [
								  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
								  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
								  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
								  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
								  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
								  [' ', ' ', ' ', ' ', ' ', ' ', ' '], 
								];
						io.sockets.emit('msg', `It's a draw! Game restarted. Player 1's turn.`)	
					}
				}
			}
		})
		// socket.on('mymsg', data => io.sockets.emit('yourmsg', data))
})





server.listen(8000, () => console.log('Started 8000...'))