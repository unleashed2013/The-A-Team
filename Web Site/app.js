var express = require('express'),	//web framework
	jade = require('jade'),	//templates
	request = require('request'),
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
		res.render('index', { title: 'The A Team: Home' });
	})
	.get('/dashboard', function(req, res) {
		res.render('dashboard', { title: 'The A Team: Dashboard' });
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
	.get('/api/cafhs/:postcode', function(req, res){
		var postcode = req.params.postcode;
		res.setHeader('Content-Type', 'application/json');
		res.end(
			JSON.stringify(
				data.getClosestsCafhs(postcode)
			)
		);
	})
	.get('/api/tableau/', function(req, res){
		//get a tableau ticket
		// Build the post string from an object
		  var post_data = querystring.stringify({
		      'username' : 'unleashed',
		      'client_ip': req.connection.remoteAddress
		  });

		  // An object of options to indicate where to post to
		  var post_options = {
		      host: 'unleashed2013.org',
		      port: '81',
		      path: '/trusted',
		      method: 'POST',
		      headers: {
		          'Content-Type': 'application/x-www-form-urlencoded',
		          'Content-Length': post_data.length
		      }
		  };

		  // Set up the request
		  var post_req = http.request(post_options, function(res) {
		      res.setEncoding('utf8');
		      res.on('data', function (chunk) {
		          console.log('Response: ' + chunk);
		      });
		  });

		  // post the data
		  post_req.write(post_data);
		  post_req.end();
		  res.end.end();
	})
	// 404
	.get('*', function(req, res) {
		res.render('404', { title: '404' });
	})
	.listen(port);
console.log('Listening on ' + port + '...');

