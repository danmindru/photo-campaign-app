'use strict';

/**
 * Module dependencies.
 */
var passport = require('passport');

module.exports = function(app) {
	// Post Routes
	var users = require('../../app/controllers/users');
	var campaigns = require('../../app/controllers/campaigns');
	var posts = require('../../app/controllers/posts');

	app.get('/posts/:campaignId', users.requiresLogin, posts.hasAuthorization, posts.list);
	app.post('/post', users.requiresLogin, posts.hasAuthorization, posts.create);
	app.del('/posts/:postId', users.requiresLogin, posts.hasAuthorization, posts.delete);

	// Finish by binding the campaign middleware
	app.param('campaignId', campaigns.campaignByID);
	app.param('postId', posts.postByID);
};
