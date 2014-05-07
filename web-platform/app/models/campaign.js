'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
	Schema = mongoose.Schema;

/**
 * Campaign Schema
 */
var CampaignSchema = new Schema({
	title: {
		type: String,
		default: '',
	},
	rules: {
		type: String,
		default: ''
	},
	description: {
		type: String,
		default: ''
	},
	identifier: {
		type: String,
		trim: true,
		default: ''
	},
	campaignEnd: {
		type: Date,
		default: Date.now
	},
	campaignStart: {
		type: Date,
		default: Date.now
	},
	created: {
		type: Date,
		default: Date.now
	}
});

/**
 * Validations
 */
CampaignSchema.path('title').validate(function(title) {
	return title.length;
}, 'Title cannot be blank');


mongoose.model('Campaign', CampaignSchema);