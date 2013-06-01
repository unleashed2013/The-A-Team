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
			var mapOptions = {
	          center: new google.maps.LatLng(data.Lattitude, data.Longitude),
	          zoom: 11,
	          mapTypeId: google.maps.MapTypeId.ROADMAP
	        };

	        //create the map
	        var map = new google.maps.Map(
	        	document.getElementById('postcode-map'),
	            mapOptions);

	        //bucket text
	        var bucketLabel = '',
	        	backetClass = 'bucket-' + data.Quintile;
        	switch(data.Quintile){
        		case 1:
        			bucketLabel = 'Low';
        			break;
    			case 2:
        			bucketLabel = 'Medium-low';
        			break;
    			case 3:
        			bucketLabel = 'Medium';
        			break;
    			case 4:
        			bucketLabel = 'High';
        			break;
    			case 5:
        			bucketLabel = 'Extreme';
        			break;
    			default:
    				bucketLabel = 'Low';
        	}
	        $('#bucket')
	        	.addClass(backetClass)
	        	.html(bucketLabel);
		});
};
PostcodeResultCtrl.$inject = ['$scope', 'webappService', 'Postcode'];