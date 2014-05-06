'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
	Post = mongoose.model('Post'),
	_ = require('lodash');

/**
 * Create a post
 */
exports.create = function(req, res) {
	var post = new Post(req.body);

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