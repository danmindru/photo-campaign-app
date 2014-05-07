'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
	Schema = mongoose.Schema;

/**
 * Post Schema
 */
var PostSchema = new Schema({
	title: {
		type: String,
		default: '',
	},
	description: {
		type: String,
		default: ''
	},
	photoURL: {
		type: String,
		trim: true,
		default: ''
	},
	created: {
		type: Date,
		default: Date.now
	},
	userRating: [{
		rating: {
			type: Number,
			max: 10
		},
		userId: {
			type: Schema.ObjectId,
			ref: 'User'
		}
	}],
	judgeRating: [{
		rating: {
			type: Number,
			max: 10
		},
		userId: {
			type:Schema.ObjectId,
			ref: 'User'
		}
	}],
	owner: {
		type: Schema.ObjectId,
		ref: 'User'
	},
	campaignObject: {
		type: Schema.ObjectId,
		ref: 'Campaign'
	}
});

/**
 * Validations
 */
PostSchema.path('title').validate(function(title) {
	return title.length;
}, 'Title cannot be blank');


mongoose.model('Post', PostSchema);