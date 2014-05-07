'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
	Post = mongoose.model('Post'),
	User = mongoose.model('User'),
	Campaign = mongoose.model('Campaign'),
	_ = require('lodash');

/**
 * Create a post
 */
exports.create = function(req, res) {
	var post = new Post(req.body);
	post.owner = req.user._id;

	//get user id from DB
	User.findById(post.owner, function(err, user) {
		if(!err && user){
			if(user.campaignObject){
			//if campaign still exists (and active - future impl.)
				Campaign.findById(user.campaignObject, function(err, campaign){
					if(!err && campaign){
						post.save(function(err) {
							if (err) {
								return res.send('/posts', {
									errors: err.errors,
									post: post
								});
							} else {
								res.jsonp(post);
							}
						});
					} else {
						return res.send(500, {
							errors: 'The user is assigned to a campaign that has been deleted or deactivated, therefore it cannot post.'
						});
					}
				});
			} else {
				return res.send(500, {
					errors: 'User must belong to a campaign to post'
				});
			}
		}
		else{
			//user not found
			res.send(400, {
				message: 'User is not found'
			});
		}
	});
};

/**
 * Read a post
 */
exports.read = function(req, res) {
	res.jsonp(req.post);
};

/**
 * Delete a post
 */
exports.delete = function(req, res) {
	var post = req.post;

	post.remove(function(err) {
		if (err) {
			res.render('error', {
				status: 500
			});
		} else {
			res.jsonp(post);
		}
	});
};

/**
 * List post belonging to a campaign
 */
exports.list = function(req, res) {
	Post.find().sort('-created').exec(function(err, posts) {
		if (err) {
			res.render('error', {
				status: 500
			});
		} else {
			res.jsonp(posts);
		}
	});
};

/**
 * Post middleware
 */
exports.postByID = function(req, res, next, id) {
	Post.findOne({
		_id: id
	}).exec(function(err, post) {
		if (err) return next(err);
		if (!post) return next(new Error('Failed to load post ' + id));
		req.post = post;
		next();
	});
};

/**
 * Campaign authorization middleware
 */
exports.hasAuthorization = function(req, res, next) {
	//Here check campaign access & user level (type)
	//also check if user logged in

	/*if (req.post.user.id !== req.user.id) {
		return res.send(403, 'User is not authorized');
	}*/
	next();
};