'use strict';

angular.module('campaigns').controller('CampaignsController', ['$scope', '$stateParams', '$location', '$filter', 'Authentication', 'Campaigns',
    function($scope, $stateParams, $location, $filter, Authentication, Campaigns) {
        $scope.authentication = Authentication;

        $scope.create = function() {
            var campaign = new Campaigns({
                title: this.campaign.title,
                rules: this.campaign.rules,
                description: this.campaign.description,
                identifier: this.campaign.identifier,
                campaignEnd: this.campaign.campaignEnd,
                campaignStart: this.campaign.campaignStart
            });
            campaign.$save(function(response) {
                //redirect to view campaign
                $location.path('campaigns/' + response._id);
            });

            this.campaign.title = '';
            this.campaign.content = '';
            this.campaign.rules = '';
            this.campaign.description = '';
            this.campaign.identifier = '';
            this.campaign.campaignEnd = '';
            this.campaign.campaignStart = '';
        };

        $scope.remove = function(campaign) {
            if (campaign) {
                campaign.$remove();

                for (var i in $scope.campaigns) {
                    if ($scope.campaigns[i] === campaign) {
                        $scope.campaigns.splice(i, 1);
                    }
                }
            } else {
                $scope.campaign.$remove(function() {
                    $location.path('campaigns');
                });
            }
        };

        $scope.update = function() {
            var campaign = $scope.campaign;
            
            if (!campaign.updated) {
                campaign.updated = [];
            }
            campaign.updated.push(new Date().getTime());

            campaign.$update(function() {
                $location.path('campaigns/' + campaign._id);
            });
        };

        $scope.find = function() {
            Campaigns.query(function(campaigns) {
                $scope.campaigns = campaigns;
            });
        };

        $scope.findOne = function() {
            Campaigns.get({
                campaignId: $stateParams.campaignId
            }, function(campaign) {
                //filters SHOULD NOT be in single quotes
                //have to ignore this in jshint because it will issue warnings for use of double quotes..
                /* jshint ignore:start */
                campaign.campaignStart = $filter("date")(campaign.campaignStart, 'yyyy-MM-dd');
                campaign.campaignEnd = $filter("date")(campaign.campaignEnd, 'yyyy-MM-dd');
                /* jshint ignore:end */
                $scope.campaign = campaign;
            });
        };
    }
]);