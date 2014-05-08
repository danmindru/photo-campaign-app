'use strict';

angular.module('posts').controller('PostsController', ['$scope', '$stateParams', '$location', '$filter', 'Authentication', 'Posts',
    function($scope, $stateParams, $location, $filter, Authentication, Posts) {
        $scope.authentication = Authentication;

        $scope.uploadComplete = function (content) {
            $scope.error = null;

            if(content.error){
                $scope.error = content.error;
            }
            else{
                $scope.post = '';
                //cannot clear input type file atm..
                
                //redirect to view posts
                $location.path('/posts');
            }
        };

        //method changed to uploadComplete due to file upload..
        /*$scope.create = function() {
            $scope.success = $scope.error = null;

            var post = new Posts({
                title: this.post.title,
                description: this.post.description,
            });

            //save post, handle errors
            post.$save(function success() {
                //redirect to view posts
                $location.path('/posts');
            }, function error(response){
                $scope.error = response.data.errors;
            });

            this.post.title = '';
            this.post.description = '';
        };*/

        $scope.remove = function(post) {
            if (post) {
                post.$remove();

                for (var i in $scope.posts) {
                    if ($scope.posts[i] === post) {
                        $scope.posts.splice(i, 1);
                    }
                }
            } else {
                $scope.post.$remove(function() {
                    $location.path('/posts');
                });
            }
        };

        $scope.find = function() {
            Posts.query(function(posts) {
                $scope.posts = posts;
            });
        };

        $scope.findOne = function() {
            Posts.get({
                postId: $stateParams.postId
            }, function(post) {
                $scope.post = post;
            });
        };
    }
]);