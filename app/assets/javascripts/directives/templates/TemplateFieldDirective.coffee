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

    # Create a format for field input box layout
    fwstart = '<div class="form-group">'
    fwmid = '<label class="control-label"  ng-if="field.name">{{field.name}}
               <span class="required-error" ng-if="field.required && !field.values[0].input">*</span>
             </label>'

    fwend = '<div class="field-overlay" ng-if="template.editing">
               <a href="javascript:;" class="close" ng-bootbox-confirm="<center><h4>Are you sure you want to delete this field?<br><br>It will be permanently deleted.</h4></center>" ng-bootbox-confirm-action="template.deleteField(template, field)">
                 <i class="glyphicon glyphicon-remove"></i>
               </a>
             </div>
           </div>'

    fw = fwstart+fwmid

    # Break apart an <input> tag into common denominators
    inputstart = '<input'
    clas = 'class="form-control"'
    ngmodel = 'ng-model="field.values[0].input"'
    inputend = 'name="{{field.name}}" ng-required="field.required" ng-disabled="field.disabled">'

    # Define the particulars of each supported field
    labelntext = '<p>{{field.values[0].input}}</p><h4 class="text-center" ng-if="!field.values[0].input">Click to add text.</h4>'

    textfield = inputstart+' type="text" '+clas+' '+ngmodel+' '+inputend 
    textarea = '<textarea type="text" '+clas+' '+ngmodel+' '+inputend+'</textarea>'

    integer = inputstart+' type="number" '+clas+' '+ngmodel+' '+inputend
    date = inputstart+' type="date" '+clas+' '+ngmodel+' '+inputend
    time = inputstart+' type="time" '+clas+' '+ngmodel+' '+inputend

    checkbox = inputstart+' type="checkbox" ng-model="$parent.field.values[0].input" '+inputend
    radio = '<div ng-repeat="option in field.options">
              <label>'+inputstart+' type="radio" ng-value="option.name" '+ngmodel+' '+inputend+'&nbsp;{{option.name}}</label>
            </div>
            <h4 class="text-center" ng-if="!field.options.length">Click to add options.</h4>'
    dropdown = '<select value="{{field.values[0].input}}" ng-options="option.name as option.name for option in field.options" '+clas+' '+ngmodel+' '+inputend+'
        <option value="">Select Item</option>
      </select>'

    email = inputstart+' type="email" placeholder="Email" '+clas+' '+ngmodel+' '+inputend
    # masked = inputstart+' type="password" '+clas+' '+ngmodel+' '+inputend

    # GET template content from path
    cur_field = getTemplate(scope.field)
    cur_value = scope.field.values[0].input

    # Compile the field display after doublechecking that values are appropriate for their fieldtype
    # If editing/viewing a template or editing a report, show <input> fields
    if (scope.template && (scope.template.editing || scope.template.viewing)) || (scope.report && scope.report.editing)
      switch cur_field
        when "labelntext" then element.html fw+labelntext+fwend

        when "textfield" then element.html fw+textfield+fwend
        when "textarea" then element.html fw+textarea+fwend

        when "integer"
          scope.field.values[0].input = if scope.field.values[0].input?
            parseInt(scope.field.values[0].input, 10)
          else
            ''
          element.html fw+integer+fwend
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

        when "checkbox"
          if scope.field.values && scope.field.values[0].input?
            scope.field.values[0].input = scope.field.values[0].input == 't' ? 1 : 0
          element.html fwstart+checkbox+fwmid+fwend
        when "radio" then element.html fw+radio+fwend
        when "dropdown" then element.html fw+dropdown+fwend

        when "email" then element.html fw+email+fwend
        # when "masked" then element.html fw+masked+fwend
    else
      # Else we're viewing a report, so only show 
      # input text and not an actual <input> field

      if cur_field == "date" && scope.field.values[0].input != ''
        scope.field.values[0].input = new Date(scope.field.values[0].input).format("DDDD, MMMM DS, YYYY")
      else if cur_field == "time" && scope.field.values[0].input != ''
        scope.field.values[0].input = new Date(scope.field.values[0].input).format("hh:mm TT")
      else if cur_field == "number"
        scope.field.values[0].input = parseInt(scope.field.values[0].input, 10)
      else if !scope.field.values[0].input? || scope.field.values[0].input == ''
        scope.field.values[0].input = 'No information provided.'

      element.html '<h4><strong>'+scope.field.name+'</strong></h4><blockquote>'+scope.field.values[0].input+'</blockquote>'

    $compile(element.contents()) scope
    return

  {
    template: '<div>{{field}}</div>'
    restrict: 'E'
    scope:
      myForm: '='
      field: '='
      template: '='
      report: '='
    link: linker
  }
])