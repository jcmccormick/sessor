# Clerkr
# Copyright Joe McCormick 2015 All Rights Reserved
do ->
    'use strict'

    angular.module 'clerkr', [
        'templates',
        'ngRoute',
        'ngResource',
        'ngAnimate',
        'ngMaterial',
        'ngAria',
        'ng-token-auth',
        'ngBootbox',
        'LocalStorageModule',
        'ui.sortable',
        'googlechart',
        'flash'
    ]