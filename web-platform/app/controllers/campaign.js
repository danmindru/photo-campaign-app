'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
	Campaign = mongoose.model('Campaign'),
	_ = require('lodash');

/**
 * Create a campaign
 */
exports.create = function(req, res) {
	var campaign = new Campaign(req.body);

	campaign.save(function(err) {
		if (err) {
			return res.send('/campaigns', {
				errors: err.errors,
				campaign: campaign
			});
		} else {
			res.jsonp(campaign);
		}
	});
};

/**
 * Show the current campaign
 */
exports.read = function(req, res) {
	res.jsonp(req.campaign);
};

/**
 * Update a campaign
 */
exports.update = function(req, res) {
	var campaign = req.campaign;

	campaign = _.extend(campaign, req.body);

	campaign.save(function(err) {
		if (err) {
			res.render('error', {
				status: 500
			});
		} else {
			res.jsonp(campaign);
		}
	});
};

/**
 * Delete a campaign
 */
exports.delete = function(req, res) {
	var campaign = req.campaign;

	campaign.remove(function(err) {
		if (err) {
			res.render('error', {
				status: 500
			});
		} else {
			res.jsonp(campaign);
		}
	});
};

/**
 * List of Campaigns
 */
exports.list = function(req, res) {
	Campaign.find().sort('-title').exec(function(err, campaigns) {
		if (err) {
			res.render('error', {
				status: 500
			});
		} else {
			res.jsonp(campaigns);
		}
	});
};

/**
 * Campaign middleware
 */
exports.campaignByID = function(req, res, next, id) {
	Campaign.findOne({
		_id: id
	}).exec(function(err, campaign) {
		if (err) return next(err);
		if (!campaign) return next(new Error('Failed to load campaign ' + id));
		req.campaign = campaign;
		next();
	});
};

/**
 * Campaign authorization middleware
 */
exports.hasAuthorization = function(req, res, next) {
	//Here check user level for campaign access..
	//also check if user logged in

	/*if (req.campaign.user.id !== req.user.id) {
		return res.send(403, 'User is not authorized');
	}*/
	next();
};