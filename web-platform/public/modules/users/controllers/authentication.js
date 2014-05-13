'use strict';

angular.module('users').controller('AuthenticationController', ['$scope', '$http', '$location', 'Authentication',
    function($scope, $http, $location, Authentication) {
        $scope.authentication = Authentication;

        //If user is signed in then redirect back home
        if ($scope.authentication.user) $location.path('/');

        $scope.signup = function() {
            //don't hardcore! -> assign campaign ID to user removed, but might be an option for beta relase..
            //$scope.credentials.campaignIdentifier = '5367d2490c264be82b25bab3';

            $http.post('/auth/signup', $scope.credentials).success(function(response) {
                //If successful we assign the response to the global user model
                $scope.authentication.user = response;

                //And redirect to the index page
                $location.path('/campaigns');
            }).error(function(response) {
                $scope.error = response.message;
            });
        };

        $scope.signin = function() {
            //ios simulation
            //$scope.credentials.isiOS = true;
            
            $http.post('/auth/signin', $scope.credentials).success(function(response) {
                //If successful we assign the response to the global user model
                $scope.authentication.user = response;

                //And redirect to the index page
                $location.path('/campaigns');
            }).error(function(response) {
                $scope.error = response.message;
            });
        };
    }
]);