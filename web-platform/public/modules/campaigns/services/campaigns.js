'use strict';

//Campaigns service used for campaigns REST endpoint
angular.module('campaigns').factory('Campaigns', ['$resource', function($resource) {
    return $resource('campaigns/:campaignId', {
        campaignId: '@_id'
    }, {
        update: {
            method: 'PUT'
        }
    });
}]);