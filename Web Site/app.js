var express = require('express'),	//web framework
	jade = require('jade'),	//templates
	app = express(),	//the web app :)
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
	// 404
	.get('*', function(req, res) {
		res.render('404', { title: '404' });
	})
	.listen(port);
console.log('Listening on ' + port + '...');

//iTQfhS)tSt
//ec2-54-252-162-11.ap-southeast-2.compute.amazonaws.com
