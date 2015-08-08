directives = angular.module('directives')
directives.directive('templateFieldDirective', ['$http', '$compile', '$location', 'TemplateService',
($http, $compile, $location, TemplateService) ->
  
  getTemplate = (field) ->
    type = field.fieldtype
    supportedFields = TemplateService.supportedFields

    __indexOf = [].indexOf || (item)->
      i = 0
      for i in [0...this.length]
        if i in this && this[i] == item
          i++
          return i
      return -1

    if __indexOf.call(supportedFields, type) >= 0
      return type
    return

  linker = (scope, element, attrs)->

    fwstart = '<div class="form-group">'
    fwmid = '<label class="control-label">{{field.name}}
        <span class="required-error" ng-show="field.required && !field.values[0].input">*</span>
      </label>'
    fw = fwstart+fwmid

    textfield = '<input type="text" class="form-control" ng-model="field.values[0].input" ng-required="field.required" ng-disabled="field.disabled">'

    textarea = '<textarea type="text" class="form-control" ng-model="field.values[0].input" ng-required="field.required" ng-disabled="field.disabled"></textarea>'

    email = '<input type="email" class="form-control" placeholder="Email" ng-model="field.values[0].input" ng-required="field.required" ng-disabled="field.disabled"/>'

    checkbox = '<input type="checkbox" ng-model="$parent.field.values[0].input" ng-required="field.required" ng-disabled="field.disabled">'

    date = '<input type="date" class="form-control" ng-model="field.values[0].input" ng-required="field.required" ng-disabled="field.disabled">'

    time = '<input type="time" class="form-control" ng-model="field.values[0].input" ng-required="field.required" ng-disabled="field.disabled">'

    dropdown = '<select class="form-control" value="{{field.values[0].input}}" ng-model="field.values[0].input" ng-required="field.required" ng-disabled="field.disabled" ng-options="option.name as option.name for option in field.options">
        <option value="">Select Item</option>
      </select>'

    radio = '<div ng-repeat="option in field.options">
        <input type="radio" name="{{field.id}}" value="{{option.name}}" ng-model="field.values[0].input" ng-required="field.required" ng-disabled="field.disabled">
        &nbsp;{{option.name}}
      </div><h4 class="text-center" ng-if="field.options.length<1">Click to add options.</h4>'

    password = '<input type="password" class="form-control" ng-model="field.values[0].input"  ng-required="field.required" ng-disabled="field.disabled">'

    labelntext = '<p>{{field.values[0].input}}</p><h4 class="text-center" ng-if="!field.values[0].input">Click to add text.</h4>'

    hidden = '
    <input type="hidden" ng-model="field.values[0].input" value="{{field.values[0].input}}" ng-disabled="field.disabled">'

    fwend = '<div class="field-overlay" ng-if="editing"></div>
      </div>'

    # GET template content from path
    template = getTemplate(scope.field)
    
    switch template
      when "textfield" then element.html fw+textfield+fwend
      when "textarea" then element.html fw+textarea+fwend
      when "email" then element.html fw+email+fwend
      when "checkbox"
        if scope.field.values[0].input?
          scope.field.values[0].input = scope.field.values[0].input == 't' ? 1 : 0
        element.html fwstart+checkbox+fwmid+fwend
      when "date"
        scope.field.values[0].input = if scope.field.values[0].input?
          new Date(scope.field.values[0].input)
        else
          ''
        element.html fw+date+fwend
      when "time"
        scope.field.values[0].input = if scope.field.values[0].input?
          new Date(scope.field.values[0].input)
        else
          ''
        element.html fw+time+fwend
      when "labelntext" then element.html fw+labelntext+fwend
      when "dropdown" then element.html fw+dropdown+fwend
      when "radio" then element.html fw+radio+fwend
      when "password" then element.html fw+password+fwend
      when "hidden" then element.html hidden

    $compile(element.contents()) scope
    return

  {
    template: '<div>{{field}}</div>'
    restrict: 'E'
    scope:
      field: '='
      editing: '='
    link: linker
  }
])