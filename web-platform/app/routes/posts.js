'use strict';

/**
 * Module dependencies.
 */
var passport = require('passport');

module.exports = function(app) {
	// Post Routes
	var users = require('../../app/controllers/users');
	var posts = require('../../app/controllers/posts');

	app.get('/posts', posts.list);
	app.get('/posts/:postId', posts.read);
	app.post('/posts', users.requiresLogin, posts.hasAuthorization, posts.create);
	app.del('/posts/:postId', users.requiresLogin, posts.hasAuthorization, posts.delete);

	// Finish by binding the posts middleware
	app.param('postId', posts.postByID);
};
