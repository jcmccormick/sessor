do ->
    'use strict'

    contact = ->
        {
            controllerAs: 'cv'
            controller: ['$http', '$location', 'Flash', ($http, $location, Flash)->
                
                cv = this

                cv.newContact = (email, message)->
                    if message
                        $http.post('/contacts', {email: email, message: message}).then((res)->
                            Flash.create('success', '<h2>Success! <small>Contact</small></h2><p>Thanks for your message.</p>', 'customAlert')
                            cv.email = undefined
                            cv.message = undefined
                            $location.path('/')
                        )
                    else
                        Flash.create('danger', '<h2>Error! <small>Contact</small></h2><p>Please include a message.</p>', 'customAlert')

                return cv

            ]
        }

    angular.module('clerkr').directive('contact', contact)