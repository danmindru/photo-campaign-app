'use strict';

// Setting up route
angular.module('campaigns').config(['$stateProvider',
	function($stateProvider) {
		// Campaigns state routing
		//WARNING! Order matters, if create is after view or edit, the loaded template will be the first in the list (in this case view)
		$stateProvider.
		state('createCampaign', {
			url: '/campaigns/create',
			templateUrl: 'modules/campaigns/views/create.html'
		}).
		state('listCampaigns', {
			url: '/campaigns',
			templateUrl: 'modules/campaigns/views/list.html'
		}).
		state('viewCampaign', {
			url: '/campaigns/:campaignId',
			templateUrl: 'modules/campaigns/views/view.html'
		}).
		state('editCampaign', {
			url: '/campaigns/:campaignId/edit',
			templateUrl: 'modules/campaigns/views/edit.html'
		});
	}
]);