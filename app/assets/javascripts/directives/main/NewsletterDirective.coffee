do ->
    'use strict'

    newsletter = ->
        {
            controllerAs: 'nv'
            controller: ['$http', 'Flash', ($http, Flash)->
                
                nv = this

                nv.newSubscribe = (email, form)->
                    $http.post('/newsletters', {email: email}).then((res)->
                        Flash.create('success', '<h3>Success! <small>Newsletter</small></h3><p>Thanks for signing up! We\'ll keep you up-to-date on all our developments.</p>', 'customAlert')
                        nv.email = undefined
                        form.$setUntouched()
                    )

                return nv

            ]
        }

    angular.module('clerkr').directive('newsletter', newsletter)