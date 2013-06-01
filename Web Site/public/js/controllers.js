/* Controllers */
function IndexCtrl($scope, webappService) {
	$scope.setPostcode = function(evt) {
		webappService.setPostcode(
			$('#postcode-input').val()
		);
	};
};
IndexCtrl.$inject = ['$scope', 'webappService'];

function PostcodeResultCtrl($scope, webappService, Postcode) {
	var result = Postcode.GetSLA(
		webappService.getPostcode(), 
		function(data){
			$('#postcode-results').html(JSON.stringify(data));
		});
};
PostcodeResultCtrl.$inject = ['$scope', 'webappService', 'Postcode'];