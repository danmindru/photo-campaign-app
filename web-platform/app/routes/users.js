'use strict';

/**
 * Module dependencies.
 */
var passport = require('passport');

module.exports = function(app) {
	// User Routes
	var users = require('../../app/controllers/users');
	app.get('/users/me', users.me);
	app.put('/users', users.update);
	app.post('/users/password', users.changePassword);

	// Setting up the users api
	app.post('/auth/signup', users.signup);
	app.post('/auth/signin', users.signin);
	app.get('/auth/signout', users.signout);

	// Finish by binding the user middleware
	app.param('userId', users.userByID);
};
