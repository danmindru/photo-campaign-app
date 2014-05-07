'use strict';

angular.module('users').controller('UsersController', ['$scope', '$stateParams', '$location', '$http', 'Authentication', 'Users', function($scope, $stateParams, $location, $http, Authentication, Users){
		$scope.authentication = Authentication;

		$scope.assignCampaign = function(user){
			$scope.success = $scope.error = null;
			$http.put('/users/assign-campaign/'+user._id).success(function(data){
          $scope.success = data.message;
      }).error(function(data){
          $scope.error = 'User could not be assigned to a campaign: ' + data.message;
          //error message can be displayed from data.message
      });
		};

		$scope.find = function(){
			Users.query(function(users){
				$scope.users = users;
			});
		};
	}
]);