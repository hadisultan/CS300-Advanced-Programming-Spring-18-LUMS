const socket = io()
// const state = {}

sprite = 'bleh'
user = 0

socket.on('intromsg', data => console.log(data))
socket.on('user', data=> {
	console.log(`Your username is ${data}`)
	user = data
	console.log(user)
})
socket.on('sprite', data=> {
	console.log(`Your sprite  is ${data}`)
	sprite = data
	console.log(sprite)
})
socket.on('msg', data => {
	messages = []
	messages.push(data)
	printBoard()
})
var playerpos = 'You could not be assigned a player because 2 other tabs have already been assigned, please close all tabs and restart server or continue the game in the previous 2 tabs.'
socket.on('player', data=> {
	playerpos = data
})

const inlineStyles = {backgroundColor: 'lightgrey', fontSize: 20, width: 30, height: 30, color: 'black', borderStyle: 'solid', borderWidth: 3.3, borderColor: 'black', float: 'left', textAlign: 'center'}
const inlineStyles1 = {opacity: 0, backgroundColor: 'lightgrey', fontSize: 0, width: 30, height: 30, color: 'black', borderStyle: 'solid', borderWidth: 3.3, borderColor: 'black', textAlign: 'center'}

// const inlineStyles2 = {backgroundColor: 'lightgrey', fontSize: 20, width: 30, height: 30, color: 'black', borderStyle: 'solid', borderWidth: 5, borderColor: 'black', position: 'relative', top:-5, left: 35}

var array = [
  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' ', ' ', ' '], 
];

socket.on('table', data => {
	array = data
	console.log('Recieved Table.')
	printBoard()
})

socket.on('update', ()=> {
	printBoard()
})

messages = []

colorarr = ['green', 'green', 'green', 'green', 'green', 'green', 'green']

const rdraw = str => {
	socket.emit('redraw', { myStr : str, mySprite : sprite})
}



const enter = event => {
	var col = 0
	col = event.target.id%10
	var changearr = []
	for(var i=0; i<6; i++)
	{
		changearr.push(i*10+col)
		if(col==0)
			changearr.push(i*100+col)
	
	}
	changearr.map(m => {
		document.getElementById(m).style.backgroundColor = colorarr[col]
	})
	printBoard()
}

const leave = event => {
	var col = 0
	col = event.target.id%10
	changearr = []	
	for(var i=0; i<6; i++)
	{
		changearr.push(i*10+col)
		if(col==0)
			changearr.push(i*100+col)
	}
	changearr.map(m => {
		document.getElementById(m).style.backgroundColor = 'lightgrey'
	})
	printBoard()
}


const printBoard = () => {
		ReactDOM.render(
		React.createElement('div', null , 
			React.createElement('h1', null, playerpos),
			React.createElement('div', null ,
				React.createElement('div', {id: 0, style: inlineStyles, onClick: event => {rdraw('00')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[0][0]),
				React.createElement('div', {id: 1, style: inlineStyles, onClick: event => {rdraw('01')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[0][1]),
				React.createElement('div', {id: 2, style: inlineStyles, onClick: event => {rdraw('02')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[0][2]),
				React.createElement('div', {id: 3, style: inlineStyles, onClick: event => {rdraw('03')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[0][3]),
				React.createElement('div', {id: 4, style: inlineStyles, onClick: event => {rdraw('04')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[0][4]),
				React.createElement('div', {id: 5, style: inlineStyles, onClick: event => {rdraw('05')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[0][5]),
				React.createElement('div', {id: 6, style: inlineStyles, onClick: event => {rdraw('06')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[0][6])),
			React.createElement('div', null ,
				React.createElement('div', {id: 10, style: inlineStyles1, onClick: event => {rdraw('10')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[1][0]),
				React.createElement('div', {id: 100, style: inlineStyles, onClick: event => {rdraw('10')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[1][0]),
				React.createElement('div', {id: 11, style: inlineStyles, onClick: event => {rdraw('11')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[1][1]),
				React.createElement('div', {id: 12, style: inlineStyles, onClick: event => {rdraw('12')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[1][2]),
				React.createElement('div', {id: 13, style: inlineStyles, onClick: event => {rdraw('13')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[1][3]),
				React.createElement('div', {id: 14, style: inlineStyles, onClick: event => {rdraw('14')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[1][4]),
				React.createElement('div', {id: 15, style: inlineStyles, onClick: event => {rdraw('15')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[1][5]),
				React.createElement('div', {id: 16, style: inlineStyles, onClick: event => {rdraw('16')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[1][6])),
			React.createElement('div', null ,
				React.createElement('div', {id: 20, style: inlineStyles1, onClick: event => {rdraw('20')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[2][0]),
				React.createElement('div', {id: 200, style: inlineStyles, onClick: event => {rdraw('20')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[2][0]),
				React.createElement('div', {id: 21, style: inlineStyles, onClick: event => {rdraw('21')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[2][1]),
				React.createElement('div', {id: 22, style: inlineStyles, onClick: event => {rdraw('22')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[2][2]),
				React.createElement('div', {id: 23, style: inlineStyles, onClick: event => {rdraw('23')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[2][3]),
				React.createElement('div', {id: 24, style: inlineStyles, onClick: event => {rdraw('24')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[2][4]),
				React.createElement('div', {id: 25, style: inlineStyles, onClick: event => {rdraw('25')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[2][5]),
				React.createElement('div', {id: 26, style: inlineStyles, onClick: event => {rdraw('26')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[2][6])),
			React.createElement('div', null ,
				React.createElement('div', {id: 30, style: inlineStyles1, onClick: event => {rdraw('30')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[3][0]),
				React.createElement('div', {id: 300, style: inlineStyles, onClick: event => {rdraw('30')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[3][0]),
				React.createElement('div', {id: 31, style: inlineStyles, onClick: event => {rdraw('31')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[3][1]),
				React.createElement('div', {id: 32, style: inlineStyles, onClick: event => {rdraw('32')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[3][2]),
				React.createElement('div', {id: 33, style: inlineStyles, onClick: event => {rdraw('33')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[3][3]),
				React.createElement('div', {id: 34, style: inlineStyles, onClick: event => {rdraw('34')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[3][4]),
				React.createElement('div', {id: 35, style: inlineStyles, onClick: event => {rdraw('35')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[3][5]),
				React.createElement('div', {id: 36, style: inlineStyles, onClick: event => {rdraw('36')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[3][6])),
			React.createElement('div', null ,
				React.createElement('div', {id: 40, style: inlineStyles1, onClick: event => {rdraw('40')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[4][0]),
				React.createElement('div', {id: 400, style: inlineStyles, onClick: event => {rdraw('40')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[4][0]),
				React.createElement('div', {id: 41, style: inlineStyles, onClick: event => {rdraw('41')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[4][1]),
				React.createElement('div', {id: 42, style: inlineStyles, onClick: event => {rdraw('42')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[4][2]),
				React.createElement('div', {id: 43, style: inlineStyles, onClick: event => {rdraw('43')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[4][3]),
				React.createElement('div', {id: 44, style: inlineStyles, onClick: event => {rdraw('44')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[4][4]),
				React.createElement('div', {id: 45, style: inlineStyles, onClick: event => {rdraw('45')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[4][5]),
				React.createElement('div', {id: 46, style: inlineStyles, onClick: event => {rdraw('46')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[4][6])),
			React.createElement('div', null ,
				React.createElement('div', {id: 50, style: inlineStyles1, onClick: event => {rdraw('50')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[5][0]),
				React.createElement('div', {id: 500, style: inlineStyles, onClick: event => {rdraw('50')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[5][0]),
				React.createElement('div', {id: 51, style: inlineStyles, onClick: event => {rdraw('51')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[5][1]),
				React.createElement('div', {id: 52, style: inlineStyles, onClick: event => {rdraw('52')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[5][2]),
				React.createElement('div', {id: 53, style: inlineStyles, onClick: event => {rdraw('53')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[5][3]),
				React.createElement('div', {id: 54, style: inlineStyles, onClick: event => {rdraw('54')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[5][4]),
				React.createElement('div', {id: 55, style: inlineStyles, onClick: event => {rdraw('55')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[5][5]),
				React.createElement('div', {id: 56, style: inlineStyles, onClick: event => {rdraw('56')}, onMouseOver: event => enter(event), onMouseOut: event => leave(event)} , array[5][6])),
			React.createElement('br'),
			React.createElement('br'),
			//React.createElement('p', null, `Player 1's turn.`),
			messages.map(m => React.createElement('p', null, m))
			),

		document.getElementById('root'))
	
	
}

