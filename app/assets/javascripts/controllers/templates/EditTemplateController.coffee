controllers = angular.module('controllers')
controllers.controller('EditTemplateController', ['$routeParams',  'TemplatesService',
($routeParams, TemplatesService)->


	vt = this

	if $routeParams.templateId
		TemplatesService.getTemplate($routeParams.templateId).then((res)->
			vt.template = res
		)
	else
		vt.template = TemplatesService.newTemplate()
	
	return vt

])