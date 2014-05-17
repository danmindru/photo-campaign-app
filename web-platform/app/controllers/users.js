'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
	passport = require('passport'),
	User = mongoose.model('User'),
	Campaign = mongoose.model('Campaign'),
	_ = require('lodash');

/**
 * Get current campaign id
 */
var getCurrentCampaignId = function(next){
	Campaign.findOne().sort('-created').exec(function(err, campaign) {
			if(err) return next(err);
			if(!campaign) return next('Error! No campaign to assign to');
			return next(false, campaign._id);
	});
};


/**
 * Get the error message from error object
 */
var getErrorMessage = function(err) {
	var message = '';

	if (err.code) {
		switch (err.code) {
			case 11000:
			case 11001:
				message = 'Email already exists';
				break;
			default:
				message = 'Something went wrong';
		}
	} else {
		for (var errName in err.errors) {
			if (err.errors[errName].message) message = err.errors[errName].message;
		}
	}

	return message;
};

/**
 * Signup
 */
exports.signup = function(req, res) {
	// Init Variables
	var user = new User(req.body);
	var message = null;

	// Add missing user fields
	user.provider = 'local';
	//don't hardcore! -> assign campaign ID to user removed (hardcoded in angular module: users, controller: authentication, method: signup), but might be an option for beta relase..
	//user.campaignObject = req.body.campaignIdentifier;

	//when the user signs up, look for a campaign, which is the latest one sorted by created
	//if there is no campaign created yet, the user gets nothing, but can be assigned to a campaign later
	//a user cannot post in that campaign if he is not assigned to it and cannot post at all if he is not assigned to any campaign

	getCurrentCampaignId(function(err, campaignObjectId){
		if(!err){
			//can assign the user to a campaign
			user.campaignObject = campaignObjectId;
		}

		//save user
		user.save(function(err) {
			if (err) {
				return res.send(400, {
					message: getErrorMessage(err)
				});
			} else {
				// Remove sensitive data before login
				user.password = undefined;
				user.salt = undefined;

				req.login(user, function(err) {
					if (err) {
						res.send(400, err);
					} else {
						res.jsonp(user);
					}
				});
			}
		});
	});
};

/**
 * Signin after passport authentication
 */
exports.signin = function(req, res, next) {
	//define variable that checks if request comes from iOS
	var isiOS = req.body.isiOS;

	passport.authenticate('local', function(err, user, info) {
		if (err || !user) {
			res.send(400, info);
		} else {

			if(isiOS){
				//create the token from id+timestamp
				

				//load user from db to avoid password overwriting
				User.findOne({
					_id: user._id
				}).select('-password').
				select('-salt').
				exec(function(err, user) {
					if (!err && user) {
						user.iOSToken = user._id+new Date().getTime().toString();
						
						//update user with the new token
						user.save(function(err) {
							if (err) {
								return res.send(400, {
									message: getErrorMessage(err),
									error: err
								});
							} else {
								req.login(user, function(err) {
									if (err) {
										res.send(400, err);
									} else {
										res.jsonp(user);
									}
								});
						}
				});
					}
					else{
						res.send(400, {
							message: 'User is not found'
						});
					}
				});
			} else {
				req.login(user, function(err) {
					if (err) {
						res.send(400, err);
					} else {
						res.jsonp(user);
					}
				});
			}
		}
	})(req, res, next);
};

/**
 * Update user details
 */
exports.update = function(req, res) {
	var user = req.user;
	var message = null;

	if (user) {
		// Merge existing user
		user = _.extend(user, req.body);
		user.updated = Date.now();
		//user.displayName = user.firstName + ' ' + user.lastName;

		user.save(function(err) {
			if (err) {
				return res.send(400, {
					message: getErrorMessage(err),
					error: err
				});
			} else {
				req.login(user, function(err) {
					if (err) {
						res.send(400, err);
					} else {
						res.jsonp(user);
					}
				});
			}
		});
	} else {
		res.send(400, {
			message: 'User is not signed in'
		});
	}
};

/**
 *	User campaign update
 */
exports.assignCampaign = function(req, res){
	var userToUpdate = req.params.userId;

	if(userToUpdate){
		//get current campaign id if exists
		getCurrentCampaignId(function(err, campaignObjectId){
			if(!err){
				User.findById(userToUpdate, function(err, user) {
					if(!err && user){
						user.updated = Date.now();
						user.campaignObject = campaignObjectId;

						//update user with new campaign
						user.save(function(err) {
							if (err) {
								return res.send(400, {
									message: getErrorMessage(err)
								});
							} else {
								req.login(user, function(err) {
									if (err) {
										res.send(400, err);
									} else {
										res.send({
											message: 'User ' + user.email + ' successfully assigned to campaign (DBID): ' + campaignObjectId
										});
									}
								});
							}
						});
					}
					else{
						//user not found
						res.send(400, {
							message: 'User is not found'
						});
					}
				});
			} else {
				//problems reading the campaign id
				return res.send(400, {
					message: err
				});
			}
		});
	}
	else{
		return res.send(500, {
			message: 'Invalid user id provided'
		});
	}
};

/**
 * Change Password
 */
exports.changePassword = function(req, res, next) {
	// Init Variables
	var passwordDetails = req.body;
	var message = null;

	if (req.user) {
		User.findById(req.user.id, function(err, user) {
			if (!err && user) {
				if (user.authenticate(passwordDetails.currentPassword)) {
					if (passwordDetails.newPassword === passwordDetails.verifyPassword) {
						user.password = passwordDetails.newPassword;

						user.save(function(err) {
							if (err) {
								return res.send(400, {
									message: getErrorMessage(err)
								});
							} else {
								req.login(user, function(err) {
									if (err) {
										res.send(400, err);
									} else {
										res.send({
											message: 'Password changed successfully'
										});
									}
								});
							}
						});
					} else {
						res.send(400, {
							message: 'Passwords do not match'
						});
					}
				} else {
					res.send(400, {
						message: 'Current password is incorrect'
					});
				}
			} else {
				res.send(400, {
					message: 'User is not found'
				});
			}
		});
	} else {
		res.send(400, {
			message: 'User is not signed in'
		});
	}
};

/**
 * Signout
 */
exports.signout = function(req, res) {
	req.logout();
	res.redirect('/');
};

/**
 * Send User
 */
exports.me = function(req, res) {
	User.findOne({
		_id: req.user._id
	}).select('-password').
	select('-salt').
	exec(function(err, user) {
		if (!err && user) {
			res.jsonp(user);
		}
		else{
			res.send(400, {
				message: 'User is not found'
			});
		}
	});
};

/*
 * List users
 */
exports.list = function(req, res){
	User.find().sort('-created').
		select('-password').
		select('-salt').
		populate('campaignObject', 'identifier').
		exec(function(err, users){
		if(err){
			res.render('error', {
				status: 500
			});
		} else {
			res.jsonp(users);
		}
	});
};


/**
 * User middleware
 */
exports.userByID = function(req, res, next, id) {
	User.findOne({
		_id: id
	}).exec(function(err, user) {
		if (err) return next(err);
		if (!user) return next(new Error('Failed to load User ' + id));
		req.profile = user;
		next();
	});
};

/**
 * Require login routing middleware
 */
exports.requiresLogin = function(req, res, next) {
	//iOS login token
	var loginToken = req.body.iOSToken;

	if (!req.isAuthenticated() && !loginToken) {
		return res.send(401, 'User is not logged in');
	}
	else{
		//continue, user is okay
		next();
		return true;
	}
	
	if(loginToken){
		//grab userid
		var userId = req.body._id;
		
		User.findOne({
		_id: userId
		}).exec(function(err, user) {
			if (!err && user) {
				
				if(loginToken === user.iOSToken){
					//user okay, go to next
					next();
				}
				else{
					return res.send(400, {
						message: 'User not allowed'
					});
				}
				
			}
			else{
				return res.send(400, {
					message: 'User is not found'
				});
			}
		});
	}
};

/**
 * User authorizations routing middleware
 */
exports.hasAuthorization = function(req, res, next) {
	if (req.profile.id !== req.user.id) {
		return res.send(403, 'User is not authorized');
	}

	next();
};