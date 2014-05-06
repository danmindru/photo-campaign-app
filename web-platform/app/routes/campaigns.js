'use strict';

/**
 * Module dependencies.
 */
var passport = require('passport');

module.exports = function(app) {
	// Campaign Routes
	var users = require('../../app/controllers/users');
	var campaigns = require('../../app/controllers/campaigns');

	app.get('/campaigns', users.requiresLogin, campaigns.hasAuthorization, campaigns.list);
	app.get('/campaigns/:campaignId', users.requiresLogin, campaigns.hasAuthorization, campaigns.read);
	app.put('/campaigns/:campaignId', users.requiresLogin, campaigns.hasAuthorization, campaigns.update);
	app.post('/campaigns', users.requiresLogin, campaigns.hasAuthorization, campaigns.create);
	app.del('/campaigns/:campaignId', users.requiresLogin, campaigns.hasAuthorization, campaigns.delete);

	// Finish by binding the campaign middleware
	app.param('campaignId', campaigns.campaignByID);
};
