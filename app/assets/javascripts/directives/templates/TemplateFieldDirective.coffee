directives = angular.module('directives')
directives.directive('templateFieldDirective', ['$compile', 'TemplateService',
($compile, TemplateService) ->
  
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
               <span class="required-error" ng-if="field.required && !field.values[0].input">*</span>
             </label>'

    fwend = '<div class="field-overlay" ng-if="editing">
               <a href="javascript:;" class="close" ng-bootbox-confirm="<center><h4>Are you sure you want to delete this field?<br> It will be permanently deleted.</h4></center>" ng-bootbox-confirm-action="template.deleteField(template, field)">X</a>
             </div>
           </div>'

    fw = fwstart+fwmid

    inputstart = '<input'
    clas = 'class="form-control"'
    ngmodel = 'ng-model="field.values[0].input"'
    inputend = 'name="{{field.name}}" ng-required="field.required" ng-disabled="field.disabled">'

    textfield = inputstart+' type="text" '+clas+' '+ngmodel+' '+inputend 

    textarea = '<textarea type="text" '+clas+' '+ngmodel+' '+inputend+'</textarea>'

    email = inputstart+' type="email" placeholder="Email" '+clas+' '+ngmodel+' '+inputend

    checkbox = inputstart+' type="checkbox" ng-model="$parent.field.values[0].input" '+inputend

    date = inputstart+' type="date" '+clas+' '+ngmodel+' '+inputend

    time = inputstart+' type="time" '+clas+' '+ngmodel+' '+inputend

    password = inputstart+' type="password" '+clas+' '+ngmodel+' '+inputend

    labelntext = '<p>{{field.values[0].input}}</p><h4 class="text-center" ng-if="!field.values[0].input">Click to add text.</h4>'

    dropdown = '<select value="{{field.values[0].input}}" ng-options="option.name as option.name for option in field.options" '+clas+' '+ngmodel+' '+inputend+'
        <option value="">Select Item</option>
      </select>'

    radio = '<div ng-repeat="option in field.options">
              <label>'+inputstart+' type="radio" ng-value="option.name" '+ngmodel+' '+inputend+'&nbsp;{{option.name}}</label>
            </div>
            <h4 class="text-center" ng-if="!field.options.length">Click to add options.</h4>'

    hidden = inputstart+' type="hidden" value="{{field.values[0].input}}" '+ngmodel+' '+inputend


    # GET template content from path
    template = getTemplate(scope.field)

    switch template
      when "textfield" then element.html fw+textfield+fwend
      when "textarea" then element.html fw+textarea+fwend
      when "email" then element.html fw+email+fwend
      when "checkbox"
        if scope.field.values && scope.field.values[0].input?
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
      myForm: '='
      template: '='
      field: '='
      editing: '='
    link: linker
  }
])