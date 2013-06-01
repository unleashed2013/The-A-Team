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

        	if(data.Points){
        		
		        var postcodePolygon = [],
		        	bounds = new google.maps.LatLngBounds();
		        for(var i = 0; i < data.Points.length; i++){
		        	var latlng = new google.maps.LatLng(data.Points[i][0], data.Points[i][1]);
		        	postcodePolygon.push(latlng);
		        	bounds.extend(latlng);
		        }
				var postcodePath = new google.maps.Polygon({
					path: postcodePolygon,
					strokeColor: "#7A0177",
					strokeOpacity: 0.8,
					strokeWeight: 2,
					fillColor: "F768A1",
					fillOpacity: 0.35
				});

				postcodePath.setMap(map);
				map.fitBounds(bounds);
			}

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