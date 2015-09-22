directives = angular.module('directives')
directives.directive('templateFieldDirective', ['$compile', 'TemplatesService',
($compile, TemplatesService) ->
  
  getTemplate = (field) ->
    type = field.fieldtype
    supportedFields = TemplatesService.supportedFields

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
    fwmid = '<label class="control-label" for="{{field.name}}" ng-if="field.name">{{field.name}}
               <span class="required-error" ng-if="field.required && !field.value.input">*</span>
             </label>'

    fwend = '<div class="field-overlay" ng-class="{\'force-hover\':template.selectedOptions.id == field.id}" ng-if="template.editing"></div>
           </div>'

    fw = fwstart+fwmid

    # Break apart an <input> tag into common denominators
    inputstart = '<input'
    clas = 'class="form-control"'

    ngmodel = if scope.report then 'ng-model="field.value.input"' else 'ng-model="field.default_value"'
    checkboxmodel = if scope.report then 'ng-model="$parent.field.value.input"' else 'ng-model="$parent.field.default_value"'

    inputend = ' name="{{field.name}}" ng-required="field.required" ng-disabled="field.disabled">&nbsp;'
    
    standard = clas+' '+ngmodel+' '+inputend

    # Define the particulars of each supported field
    labelntext = '<p>{{field.value.input}}{{field.default_value}}</p>
    <h4 class="text-center" ng-if="!field.value.input && !field.default_value">Click to add text.</h4>'

    textfield = inputstart+' type="text" '+standard
    textarea = '<textarea type="text" '+standard+'</textarea>'
    email = inputstart+' type="email" placeholder="Email" '+standard

    integer = inputstart+' type="number" placeholder="Number" '+standard
    date = inputstart+' type="date" '+standard
    time = inputstart+' type="time" '+standard

    checkbox = inputstart+' id="{{field.name}}" type="checkbox" '+checkboxmodel+inputend
    radio = '<div ng-repeat="option in field.options track by $index">
              <label>'+inputstart+' type="radio" ng-value="field.options[$index]" '+ngmodel+inputend+'{{option}}</label>
            </div>
            <h4 class="text-center" ng-if="!field.options.length">Click to add options.</h4>'
    dropdown = '<select ng-options="option for option in field.options" '+standard+'
        <option value="">Select Item</option>
      </select>'

    # masked = inputstart+' type="password" '+standard

    # GET template content from path
    cur_field = getTemplate(scope.field)
    cur_value = if scope.report then scope.field.value.input else scope.field.default_value

    if cur_value?
      if cur_field == 'integer'
        cur_value = parseInt(cur_value, 10)
      else if cur_field == 'date' || cur_field == 'time'
        cur_value = if cur_value != '1970-01-01T00:00:00.000Z' then new Date(cur_value) else ''
      else if cur_field == 'checkbox'
        cur_value = cur_value == 't' ? 1 : 0

    if scope.field.default_value != undefined
      scope.field.default_value = cur_value
    else
      scope.field.value.input = cur_value

    # Compile the field display after doublechecking that values are appropriate for their fieldtype
    # If editing/viewing a template or editing a report, show <input> fields
    if !(scope.report && scope.report.viewing)
      switch cur_field
        when "labelntext" then element.html fw+labelntext+fwend

        when "textfield" then element.html fw+textfield+fwend
        when "textarea" then element.html fw+textarea+fwend
        when "email" then element.html fw+email+fwend

        when "integer" then element.html fw+integer+fwend
        when "date" then element.html fw+date+fwend
        when "time" then element.html fw+time+fwend

        when "checkbox" then element.html fwstart+checkbox+fwmid+fwend
        when "radio" then element.html fw+radio+fwend
        when "dropdown" then element.html fw+dropdown+fwend

        # when "masked" then element.html fw+masked+fwend
    else
      # Else we're viewing a report, so only show 
      # input text and not an actual <input> field

      if cur_field == "date" && scope.field.value.input != '' && scope.field.value.input?
        scope.field.value.input = new Date(scope.field.value.input).format("DDDD, MMMM DS, YYYY")
      else if cur_field == "time" && scope.field.value.input != '' && scope.field.value.input?
        console.log scope.field.value.input
        scope.field.value.input = new Date(scope.field.value.input).format("hh:mm TT")
      else if cur_field == "number"
        scope.field.value.input = parseInt(scope.field.value.input, 10)
      else if cur_field == "checkbox"
        scope.field.value.input = if scope.field.value.input == true then 'True' else 'False'
      else if (!scope.field.value.input? || scope.field.value.input == '')
        scope.field.value.input = 'No Data'

      element.html '<h4><strong>'+scope.field.name+'</strong></h4><blockquote>'+scope.field.value.input+'</blockquote>'

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