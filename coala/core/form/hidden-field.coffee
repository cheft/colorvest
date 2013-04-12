define [
    'coala/core/form/form-field'
], (FormField) ->

    class HiddenField extends FormField
        constructor: ->
            super
            @type = 'hidden'

        getTemplateString: ->
            '<input id="<%= id %>" type="hidden" name="<%= name %>" value="{{<%= value %>}}"/>'

        loadFormData: ->

    FormField.add 'hidden', HiddenField

    HiddenField