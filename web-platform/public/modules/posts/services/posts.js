'use strict';

//Posts service used for posts REST endpoint
angular.module('posts').factory('Posts', ['$resource', function($resource) {
    return $resource('posts/:postId', {
        postId: '@_id'
    }, {
        update: {
            method: 'PUT'
        }
    });
}]);