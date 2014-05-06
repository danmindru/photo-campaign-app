'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
	Schema = mongoose.Schema,
	ObjectId = mongoose.Schema.Types.ObjectId;

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
			type: ObjectId
		}
	}],
	judgeRating: [{
		rating: {
			type: Number,
			max: 10
		},
		userId: {
			type: ObjectId
		}
	}],
	user: {
		type: Schema.ObjectId,
		ref: 'User'
	}
});

/**
 * Validations
 */
PostSchema.path('title').validate(function(title) {
	return title.length;
}, 'Title cannot be blank');


mongoose.model('Post', PostSchema);