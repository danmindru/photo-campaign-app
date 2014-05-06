'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
	Schema = mongoose.Schema;

/**
 * Tag Schema
 */
var TagSchema = new Schema({
	tagText: [{
		text: {
			type: String,
			trim: true,
			default: ''
		}
	}],
	post: {
		type: Schema.ObjectId,
		ref: 'Post'
	}
});

mongoose.model('Tag', TagSchema);