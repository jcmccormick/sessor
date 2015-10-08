directives = angular.module('directives')
directives.directive('newsletter', [()->
  {
    controllerAs: 'nv'
    controller: ['$http', 'Flash', ($http, Flash)->
      
      nv = this

      nv.newSubscribe = (email)->
      	$http.post('/newsletters', {email: email}).then((res)->
      		Flash.create('success', '<p>Thanks for signing up! We\'ll keep you up-to-date on all our developments.</p>', 'customAlert')
      		nv.email = undefined
      	)

      return nv

    ]
  }
])