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
        'LocalStorageModule',
        'ui.sortable',
        'googlechart',
        'flash'
    ]