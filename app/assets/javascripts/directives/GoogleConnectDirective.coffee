do ->
    'use strict'

    googleConnect = ->
        {
            template: '
                <md-button ng-click="gc.toggleService()" aria-label="{{(user.googler == \'f\' && \'enable\') || \'revoke\'}} clerkr to google sheets">
                    <md-tooltip md-direction="bottom" ng-if="!user.googler">
                        Clerkr can create Google Sheets based on the Pages you create, and we will populate the cells of those Google Sheets with the data from your Reports.
                    </md-tooltip>
                    <md-tooltip md-direction="bottom">
                        This will tell Clerkr to discontinue connecting to Google Sheets. However, you will still need to revoke access on your Google Account Permissions page if you no longer wish to use this service.
                    </md-tooltip>
                    {{(user.googler == \'f\'&& \'Enable\') || \'Disable\'}} Google Sheets Connection
                </md-button>'
            controllerAs: 'gc'
            controller: ['$auth', ($auth)->
                
                gc = this

                gc.toggleService = ->
                    if $auth.user.googler == "f"
                        $auth.authenticate('google', { params: { scope: 'email, profile, https://spreadsheets.google.com/feeds/'}}).then ((res)->
                            console.log res
                            $auth.updateAccount({googler:true})
                        )
                    else
                        $auth.updateAccount({googler:false})
                return gc

            ]
        }

    angular.module('clerkr').directive('googleConnect', googleConnect)