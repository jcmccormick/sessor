directives = angular.module('directives')
directives.directive('contact', [()->
  {
    controllerAs: 'cv'
    controller: ['$http', 'Flash', ($http, Flash)->
      
      cv = this

      cv.newContact = (email, message, form)->
        $http.post('/contacts', {email: email, message: message}).then((res)->
          Flash.create('success', '<p>Thanks for your message.</p>', 'customAlert')
          cv.email = undefined
          cv.message = undefined
          form.$setUntouched()
        )

      return cv

    ]
  }
])