angular
	.module('webapp', ['webapp.services'])
	.config(['$routeProvider', function($routeProvider) {
		$routeProvider.when('/index', {templateUrl: 'partials/index.html', controller: "IndexCtrl" });
		$routeProvider.when('/postcode', {templateUrl: 'partials/postcoderesult.html', controller: "PostcodeResultCtrl" });
		$routeProvider.otherwise({redirectTo: '/index'});
	}]);