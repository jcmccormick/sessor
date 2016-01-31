# Clerkr
# Copyright Joe McCormick 2016 All Rights Reserved
do ->
    'use strict'

    angular.module 'clerkr', [
        'templates',
        'ngRoute',
        'ngResource',
        'ngAnimate',
        'ngMaterial',
        'ngAria',
        'angularStats',
        'ng-token-auth',
        'LocalStorageModule',
        'googlechart',
        'flash'
    ]