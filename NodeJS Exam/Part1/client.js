const socket = io()

const delay = secs => new Promise(resolve => setTimeout(resolve, 1000*secs))

const shipsize = {
    'aircraft_carrier': 5,
    'battleship': 4,
    'cruiser': 3,
    'destroyer': 2,
    'submarine': 1
}


const state = {}

const shipBoardRow = () => {
    var row = []
	for(var i = 0; i < 10; i++)
	{
		row.push(React.createElement('div', {className: 'box'}))
	}
    return row
}

shipBoardRow()

const setState = updates => {
    Object.assign(state, updates)
    ReactDOM.render(React.createElement('div', null, shipBoardRow()),

        document.getElementById('root'))
}







setState({msg: 'Hello World'})
