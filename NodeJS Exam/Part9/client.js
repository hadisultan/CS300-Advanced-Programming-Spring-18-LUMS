const socket = io()

const delay = secs => new Promise(resolve => setTimeout(resolve, 1000*secs))

const shipsize = {
    'aircraft_carrier': 5,
    'battleship': 4,
    'cruiser': 3,
    'destroyer': 2,
    'submarine': 1
}
var opt = 'aircraft_carrier'
var aircrafts = []
var battleships = []
var cruisers = []
var destroyers = []
var submarines = []
const state = {}
var gamee = 0

const makeAircraft = (event, t) => {
	if(gamee==1)
	{
		return
	}
	iden = event.target.id - "0"
	var tempaircrafts = []
	var place = []
	if(t == 0){
		if(iden%10>5)
		{
			return
		}
		if(aircrafts != [])
		{
			for(var i=0; i<5; i++){
				tempaircrafts[i]=aircrafts[i]
			}
		}
		aircrafts = []
		aircrafts.push(iden)
		aircrafts.push(iden+1)
		aircrafts.push(iden+2)
		aircrafts.push(iden+3)
		aircrafts.push(iden+4)
	}
	if(t == 1){
		if(iden/10>5.9)
		{
			return
		}
		if(aircrafts != [])
		{
			for(var i=0; i<5; i++){
				tempaircrafts[i]=aircrafts[i]
			}
		}
		aircrafts = []
		aircrafts.push(iden)
		aircrafts.push(iden+10)
		aircrafts.push(iden+20)
		aircrafts.push(iden+30)
		aircrafts.push(iden+40)
	}
	var newcheck = 0
	for(var c=0; c<5; c++)
	{
		place[c] = aircrafts[c]
	}
	for(var c=0; c<5; c++)
	{
		for(var d=0; d<4; d++)
		{
			if(place[c] == battleships[d]){
				newcheck++
			}
		}
		for(var d=0; d<3; d++)
		{
			if(place[c] == cruisers[d]){
				newcheck++
			}
		}
		for(var d=0; d<2; d++)
		{
			if(place[c] == destroyers[d]){
				newcheck++
			}
		}
		for(var d=0; d<1; d++)
		{
			if(place[c] == submarines[d]){
				newcheck++
			}
		}
	}
	if(newcheck>0){
		if(tempaircrafts != [])
		{
			for(var i=0; i<5; i++){
				aircrafts[i]=tempaircrafts[i]
			}
		}
		else{
			aircrafts = []
		}
	}
	else{
		for(var i=0; i<5; i++){
			aircrafts[i]=place[i]
		}
	}
	console.log(aircrafts)
	setState()
}

const makeBattleship = (event, t) => {
	if(gamee==1)
	{
		return
	}
	iden = event.target.id - "0"
	var tempbattleships = []
	var place = []
	if(t==0){
		console.log(`t is ${t}`)
		if(iden%10>6)
		{
			return
		}
		if(battleships != [])
		{
			for(var i=0; i<4; i++){
				tempbattleships[i]=battleships[i]
			}
		}
		battleships = []
		battleships.push(iden)
		battleships.push(iden+1)
		battleships.push(iden+2)
		battleships.push(iden+3)
	}
	if(t==1){
		if(iden/10>6.9)
		{
			return
		}
		if(battleships != [])
		{
			for(var i=0; i<4; i++){
				tempbattleships[i]=battleships[i]
			}
		}
		battleships = []
		battleships.push(iden)
		battleships.push(iden+10)
		battleships.push(iden+20)
		battleships.push(iden+30)
	}
	var newcheck = 0
	for(var c=0; c<4; c++)
	{
		place[c] = battleships[c]
	}
	for(var c=0; c<4; c++)
	{
		for(var d=0; d<5; d++)
		{
			if(place[c] == aircrafts[d]){
				newcheck++
			}
		}
		for(var d=0; d<3; d++)
		{
			if(place[c] == cruisers[d]){
				newcheck++
			}
		}
		for(var d=0; d<2; d++)
		{
			if(place[c] == destroyers[d]){
				newcheck++
			}
		}
		for(var d=0; d<1; d++)
		{
			if(place[c] == submarines[d]){
				newcheck++
			}
		}
	}
	if(newcheck>0){
		if(tempbattleships != [])
		{
			for(var i=0; i<4; i++){
				battleships[i]=tempbattleships[i]
			}
		}
		else{
			battleships = []
		}
	}
	else{
		for(var i=0; i<4; i++){
			battleships[i]=place[i]
		}
	}
	console.log(battleships)
	setState()
}

const makeCruiser = (event, t) => {
	if(gamee==1)
	{
		return
	}
	iden = event.target.id - "0"
	var tempcruisers = []
	var place = []
	if(t==0){
		if(iden%10>7)
		{
			return
		}
		if(cruisers != [])
		{
			for(var i=0; i<3; i++){
				tempcruisers[i]=cruisers[i]
			}
		}
		cruisers = []
		cruisers.push(iden)
		cruisers.push(iden+1)
		cruisers.push(iden+2)
	}
	if(t==1){
		if(iden/10>7.9)
		{
			return
		}
		if(cruisers != [])
		{
			for(var i=0; i<3; i++){
				tempcruisers[i]=cruisers[i]
			}
		}
		cruisers = []
		cruisers.push(iden)
		cruisers.push(iden+10)
		cruisers.push(iden+20)
	}
	var newcheck = 0
	for(var c=0; c<3; c++)
	{
		place[c] = cruisers[c]
	}
	for(var c=0; c<3; c++)
	{
		for(var d=0; d<5; d++)
		{
			if(place[c] == aircrafts[d]){
				newcheck++
			}
		}
		for(var d=0; d<4; d++)
		{
			if(place[c] == battleships[d]){
				newcheck++
			}
		}
		for(var d=0; d<2; d++)
		{
			if(place[c] == destroyers[d]){
				newcheck++
			}
		}
		for(var d=0; d<1; d++)
		{
			if(place[c] == submarines[d]){
				newcheck++
			}
		}
	}
	if(newcheck>0){
		if(tempcruisers != [])
		{
			for(var i=0; i<3; i++){
				cruisers[i]=tempcruisers[i]
			}
		}
		else{
			cruisers = []
		}
	}
	else{
		for(var i=0; i<3; i++){
			cruisers[i]=place[i]
		}
	}
	console.log(cruisers)
	setState()
}

const makeDestroyer = (event, t) => {
	if(gamee==1)
	{
		return
	}
	iden = event.target.id - "0"
	var tempdestroyers = []
	var place = []
	if(t==0){
		if(iden%10>8)
		{
			return
		}
		if(destroyers != [])
		{
			for(var i=0; i<2; i++){
				tempdestroyers[i]=destroyers[i]
			}
		}
		destroyers = []
		destroyers.push(iden)
		destroyers.push(iden+1)
	}
	if(t==1){
		if(iden/10>8.9)
		{
			return
		}
		if(destroyers != [])
		{
			for(var i=0; i<2; i++){
				tempdestroyers[i]=destroyers[i]
			}
		}
		destroyers = []
		destroyers.push(iden)
		destroyers.push(iden+10)
	}
	var newcheck = 0
	for(var c=0; c<2; c++)
	{
		place[c] = destroyers[c]
	}
	for(var c=0; c<2; c++)
	{
		for(var d=0; d<5; d++)
		{
			if(place[c] == aircrafts[d]){
				newcheck++
			}
		}
		for(var d=0; d<4; d++)
		{
			if(place[c] == battleships[d]){
				newcheck++
			}
		}
		for(var d=0; d<3; d++)
		{
			if(place[c] == cruisers[d]){
				newcheck++
			}
		}
		for(var d=0; d<1; d++)
		{
			if(place[c] == submarines[d]){
				newcheck++
			}
		}
	}
	if(newcheck>0){
		if(tempdestroyers != [])
		{
			for(var i=0; i<2; i++){
				destroyers[i]=tempdestroyers[i]
			}
		}
		else{
			destroyers = []
		}
	}
	else{
		for(var i=0; i<2; i++){
			destroyers[i]=place[i]
		}
	}
	console.log(destroyers)
	setState()
}

const makeSubmarine = (event, t) => {
	if(gamee==1)
	{
		return
	}
	iden = event.target.id - "0"
	var tempsubmarines = []
	var place = []
	if(iden%10>9)
	{
		return
	}
	if(submarines != [])
	{
		for(var i=0; i<1; i++){
			tempsubmarines[i]=submarines[i]
		}
	}
	submarines = []
	submarines.push(iden)
	var newcheck = 0
	for(var c=0; c<1; c++)
	{
		place[c] = submarines[c]
	}
	for(var c=0; c<1; c++)
	{
		for(var d=0; d<5; d++)
		{
			if(place[c] == aircrafts[d]){
				newcheck++
			}
		}
		for(var d=0; d<3; d++)
		{
			if(place[c] == cruisers[d]){
				newcheck++
			}
		}
		for(var d=0; d<2; d++)
		{
			if(place[c] == destroyers[d]){
				newcheck++
			}
		}
		for(var d=0; d<4; d++)
		{
			if(place[c] == battleships[d]){
				newcheck++
			}
		}
	}
	if(newcheck>0){
		if(tempsubmarines != [])
		{
			for(var i=0; i<1; i++){
				submarines[i]=tempsubmarines[i]
			}
		}
		else{
			submarines = []
		}
	}
	else{
		for(var i=0; i<1; i++){
			submarines[i]=place[i]
		}
	}
	console.log(submarines)
	setState()
}

const makeSomething = event => {
	if(opt == 'aircraft_carrier')
		makeAircraft(event, 0)
	else if(opt == 'battleship')
		makeBattleship(event, 0)
	else if(opt == 'cruiser')
		makeCruiser(event, 0)
	else if(opt == 'destroyer')
		makeDestroyer(event, 0)
	else if(opt == 'submarine')
		makeSubmarine(event, 0)

}
const makeSomethingV = event => {
	if(opt == 'aircraft_carrier')
		makeAircraft(event, 1)
	else if(opt == 'battleship')
		makeBattleship(event, 1)
	else if(opt == 'cruiser')
		makeCruiser(event, 1)
	else if(opt == 'destroyer')
		makeDestroyer(event, 1)
	else if(opt == 'submarine')
		makeSubmarine(event, 1)

}


const shipBoardRow = (rno) => {
	var row = []
	var check = 0
	for(var i = 0; i < 10; i++)
	{
		var iden = rno*10+i
		if(aircrafts!=[]){
			for(var c=0; c<5; c++)
			{
				if(iden == aircrafts[c])
				{
					row.push(React.createElement('div', {id: iden, className: 'box ship-aircraft_carrier', onClick: event => {makeSomething(event)}, onContextMenu: event => {makeSomethingV(event)} }))
					check++
				}
			}
		}
		if(check>0){
			check = 0
			continue
		}
		if(battleships!=[]){
			for(var c=0; c<4; c++)
			{
				if(iden == battleships[c])
				{
					row.push(React.createElement('div', {id: iden, className: 'box ship-battleship', onClick: event => {makeSomething(event)}, onContextMenu: event => {makeSomethingV(event)} }))
					check++
				}
			}
		}
		if(check>0){
			check = 0
			continue
		}
		if(cruisers!=[]){
			for(var c=0; c<3; c++)
			{
				if(iden == cruisers[c])
				{
					row.push(React.createElement('div', {id: iden, className: 'box ship-cruiser', onClick: event => {makeSomething(event)}, onContextMenu: event => {makeSomethingV(event)} }))
					check++
				}
			}
		}
		if(check>0){
			check = 0
			continue
		}
		if(destroyers!=[]){
			for(var c=0; c<2; c++)
			{
				if(iden == destroyers[c])
				{
					row.push(React.createElement('div', {id: iden, className: 'box ship-destroyer', onClick: event => {makeSomething(event)}, onContextMenu: event => {makeSomethingV(event)} }))
					check++
				}
			}
		}
		if(check>0){
			check = 0
			continue
		}

		if(submarines!=[]){
			for(var c=0; c<2; c++)
			{
				if(iden == submarines[c])
				{
					row.push(React.createElement('div', {id: iden, className: 'box ship-submarine', onClick: event => {makeSomething(event)}, onContextMenu: event => {makeSomethingV(event)} }))
					check++
				}
			}
		}
		if(check>0){
			check = 0
			continue
		}
		else
		{
			row.push(React.createElement('div', {id: iden, className: 'box', onClick: event => {makeSomething(event)}, onContextMenu: event => {makeSomethingV(event)} }))
		}

	}
	return row
}

const makeTable = () => {
	var table = []
	for(var r=0; r< 10; r++)
	{
		table.push(React.createElement('div', null, shipBoardRow(r)))
	}
	return table
}

makeTable()

const shipBoardRowN = () => {
	var row = []
	for(var i = 0; i < 10; i++)
	{
		row.push(React.createElement('div', {className: 'box'}))
	}
	return row
}

const makeTableN = () => {
	var table = []
	for(var r=0; r< 10; r++)
	{
		table.push(React.createElement('div', null, shipBoardRowN()))
	}
	return table
}

shipBoardRowN()
makeTableN()

const startGame = () => {
	gamee = 1
	socket.emit('aircrafts', aircrafts)
	socket.emit('battleships', battleships)
	socket.emit('cruisers', cruisers)
	socket.emit('destroyers', destroyers)
	socket.emit('submarines', submarines)

}


const setState = updates => {
    Object.assign(state, updates)
    ReactDOM.render(React.createElement('div', null,
    	React.createElement('div', null, makeTable()),
    	React.createElement('select', {onChange: ev => {
    		opt = ev.target.value
    		}
    	}, 
    		React.createElement('option', {}, 'aircraft_carrier'),
    		React.createElement('option', {}, 'battleship'),
    		React.createElement('option', {}, 'cruiser'),
    		React.createElement('option', {}, 'destroyer'),
    		React.createElement('option', {}, 'submarine'),
    		),
    	React.createElement('br'),
    	React.createElement('button', {onClick: e=> startGame()}, 'Start Game'),
    	React.createElement('br'),
    	React.createElement('text', null, 'Guess board: '),
    	React.createElement('div', null, makeTableN()),

    	),
        document.getElementById('root'))
}







setState({msg: 'Hello World'})
