'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
	Post = mongoose.model('Post'),
	User = mongoose.model('User'),
	Campaign = mongoose.model('Campaign'),
	fs = require('fs'),
	_ = require('lodash');

/**
 * Create a post
 */
exports.create = function(req, res) {
	//read post data
	var postData = {},
	fileUrl = './public/uploads/',
	uploadMessage = '',
	isiOS = req.body.isiOS;

	if (!req.files || req.files.postPhoto.size === 0) {
    uploadMessage = 'No file uploaded at ' + new Date().toString();
    return res.send(400, {error:uploadMessage});
  } else {
    var file = req.files.postPhoto;
    //append filename and date to file upload
    fileUrl += new Date().getTime().toString() + file.name;

   	fs.rename(file.path, fileUrl, function(err) {
	    if(err) {
				return res.send({
	      	error: 'Error while moving the file: ' + err
				});
	    } else {
				//uploadMessage = '<b>"' + file.name + '"<b> uploaded to the server at ' + new Date().toString();
        
        if(!isiOS){
        	//store data from req params
					postData.title = req.param('title');
					postData.description = req.param('description');
		    }
		    else{
		    	//handle iOS specific requests
		    	//store data from req params
					postData.title = req.body.title;
					postData.description = req.body.description;
		    }
        
				postData.photoURL = fileUrl.replace('./public/', '');

				var post = new Post(postData);

				//added missing fields
				if(!isiOS){
					post.owner = req.user._id;
				} else {
					post.owner = req.body._id;
				}

				//get user id from DB
				User.findById(post.owner, function(err, user) {
					if(!err && user){
						if(user.campaignObject){
						//if campaign still exists (and active - future impl.)
							Campaign.findById(user.campaignObject, function(err, campaign){
								if(!err && campaign){
									//if campaign found, assing it to the post
									post.campaignObject = campaign._id;

									//finally save post
									post.save(function(err) {
										if (err) {
											return res.send('/posts', {
												error: err.errors,
												post: post
											});
										} else {
											return res.jsonp(post);
										}
									});
								} else {
									return res.send(500, {
										error: 'The user is assigned to a campaign that has been deleted or deactivated, therefore it cannot post.'
									});
								}
							});
						} else {
							return res.send(500, {
								error: 'User must belong to a campaign to post'
							});
						}
					}
					else{
						//user not found
						res.send(400, {
							error: 'User is not found'
						});
					}
				});
      }            
		});
  }
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
	var userCampaignObject;

	if(req.user){
		userCampaignObject = req.user.campaignObject;
	} 
	else if(req.query.campaignObject){
		//queries coming from iOS
		//additional security measures can be taken here, although it's just for GET requests
		userCampaignObject = req.query.campaignObject;
	} 

	//list all posts if user is not logged in
	if(!userCampaignObject){
		Post.find().
		populate('campaignObject', 'identifier').
		populate('owner', 'firstName lastName').
		sort('-created').
		exec(function(err, posts) {
			if (err) {
				res.render('error', {
					status: 500
				});
			} else {
				res.jsonp(posts);
			}
		});
	} else {
		//list posts from the campaign assigned to the logged-in user
		Post.find({
			campaignObject: userCampaignObject
		}).
		populate('campaignObject', 'identifier').
		populate('owner', 'firstName lastName').
		sort('-created').
		exec(function(err, posts) {
			if (err) {
				res.render('error', {
					status: 500
				});
			} else {
				res.jsonp(posts);
			}
		});
	}
};

/**
 * Post middleware
 */
exports.postByID = function(req, res, next, id) {
	Post.findOne({
		_id: id
	}).
	populate('campaignObject', 'identifier').
	populate('owner', 'firstName lastName').
	exec(function(err, post) {
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