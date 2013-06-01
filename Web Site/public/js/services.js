/* Services */
angular
	.module('webapp.services', ['ngResource'])
	.service('webappService', function() {
		var pcode;
		return {
			setPostcode: function(postcode){
				pcode = postcode;
			},
			getPostcode: function(){
				return pcode;
			}
		};
	})
	.factory('Postcode', function() {
		return {
			GetSLA: function(postcode, callback) {
				$.ajax({
					type: 'GET',
					url: '/api/sla/' + postcode,
					data: { },
					dataType: 'JSON'
				})
					.done(function(data) {
						callback(data);
					})
					.fail(function(data){
						callback(data);
					});
			},
			GetCafhs: function(postcode, callback) {
				$.ajax({
					type: 'GET',
					url: '/api/cafhs/' + postcode,
					data: { },
					dataType: 'JSON'
				})
					.done(function(data) {
						callback(data);
					})
					.fail(function(data){
						callback(data);
					});
			}
		}
	});