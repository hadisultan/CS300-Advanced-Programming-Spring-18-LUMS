const socket = io()

const delay = secs => new Promise(resolve => setTimeout(resolve, 1000*secs))

const shipsize = {
    'aircraft_carrier': 5,
    'battleship': 4,
    'cruiser': 3,
    'destroyer': 2,
    'submarine': 1
}

var aircrafts = []
const state = {}

const makeAircraft = event => {
	iden = event.target.id - "0"
	if(iden%10>5)
	{
		return
	}
	aircrafts = []
	aircrafts.push(iden)
	aircrafts.push(iden+1)
	aircrafts.push(iden+2)
	aircrafts.push(iden+3)
	aircrafts.push(iden+4)
	console.log(aircrafts)
	setState()
}

const shipBoardRow = (rno) => {
	var row = []
	check = 0
	for(var i = 0; i < 10; i++)
	{
		var iden = rno*10+i
		for(var j=0; j<aircrafts.length; j++)
		{
			if(aircrafts[j]==iden){
				
				check++

			}
		}
		if(check==0){
			row.push(React.createElement('div', {id: iden, className: 'box', onClick: event => {makeAircraft(event)}}))
		}
		else{
			row.push(React.createElement('div', {id: iden, className: 'box ship-aircraft_carrier', onClick: event => {makeAircraft(event)}}))
			check=0	 
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

const setState = updates => {
    Object.assign(state, updates)
    ReactDOM.render(React.createElement('div', null,
    	React.createElement('div', null, makeTable()),
    	React.createElement('select', null,
    		React.createElement('option', {}, 'aircraft_carrier'),
    		React.createElement('option', {}, 'battleship'),
    		React.createElement('option', {}, 'cruiser'),
    		React.createElement('option', {}, 'destroyer'),
    		React.createElement('option', {}, 'submarine'),
    		),
    	),
        document.getElementById('root'))
}







setState({msg: 'Hello World'})
