var express = require('express'),	//web framework
	jade = require('jade'),	//templates
	app = express(),	//the web app :)
	data = require('./data'),	//user related functions
	port = process.env.PORT || 5001; //http port to listen on

//configure and start app
app
	.set('views', __dirname + '/views')
	.set('view engine', 'jade')
	.use(express.static(__dirname + '/public'))
	.use(express.bodyParser())
	//web routes
	.get('/', function(req, res) {
		res.render('index', { title: 'The A Team' });
	})
	//api
	.get('/api/sla/:postcode', function(req, res) {
		var postcode = req.params.postcode;
		res.setHeader('Content-Type', 'application/json');
		res.end(
			JSON.stringify(
				data.getSLA(postcode)
			)
		);
	})
	// 404
	.get('*', function(req, res) {
		res.render('404', { title: '404' });
	})
	.listen(port);
console.log('Listening on ' + port + '...');

