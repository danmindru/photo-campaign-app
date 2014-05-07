'use strict';

// Setting up route
angular.module('campaigns').config(['$stateProvider',
	function($stateProvider) {
		// Campaigns state routing
		//WARNING! Order matters, if create is after view or edit, the loaded template will be the first in the list (in this case view)
		$stateProvider.
		state('createPost', {
			url: '/post/create',
			templateUrl: 'modules/posts/views/create.html'
		}).
		state('viewPost', {
			url: '/posts/:postId',
			templateUrl: 'modules/posts/views/view.html'
		}).
		state('listPosts', {
			url: '/posts',
			templateUrl: 'modules/posts/views/list.html'
		});
	}
]);