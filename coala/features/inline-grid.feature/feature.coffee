define ['jquery', 'underscore', 'coala/core/form-view'], ($, _, FormView) ->

    layout:
        regions:
            operators: 'operators'
            grid: 'body'

    views: [
        name: 'inline:operators', region: 'operators',
        components: [ ->
            {picker, readOnly} = @feature.startupOptions
            if picker and not readOnly
                _.extend selector: 'picker', picker
        ]
        events:
            'click pick': 'showPicker'
            'click remove': 'removeItem'
            'click add': 'createItem'
            'click edit': 'updateItem'
        extend:
            fakeId: (su, id) ->
                if id then id.indexOf('FAKEID-') is 0 else _.uniqueId 'FAKEID-'

            afterRender: (su) ->
                su.apply @
                picker = @components[0]

                if picker
                    grid = @feature.views['inline:grid'].components[0]
                    picker.setValue = (value) ->
                        value = [value] unless _.isArray value

                        data = grid.fnGetData()
                        for v in value
                            exists = false
                            exists = true for d in data when d.id is v.id
                            grid.addRow v if not exists
                    picker.getFormData = ->
                        grid.fnGetData()

                if @feature.startupOptions.allowAdd
                    app = @feature.module.getApplication()

                    if not @loadAddFormDeferred
                        @loadAddFormDeferred = $.Deferred()

                        app = @feature.module.getApplication()
                        url = app.url @feature.startupOptions.url + '/configuration/forms/add'
                        $.get(url).done (data) =>
                            def = _.extend
                                baseName: 'add'
                                module: @feature.module
                                feature: @feature
                                avoidLoadingHandlers: true
                                entityLabel: data.entityLabel
                                formName: 'add'
                            , data
                            def.form =
                                groups: data.groups or []
                                tabs: data.tabs

                            view = new FormView def
                            @loadAddFormDeferred.resolve view, data.entityLabel
                    if not @loadEditFormDeferred
                        @loadEditFormDeferred = $.Deferred()
                        url = app.url @feature.startupOptions.url + '/configuration/forms/edit'
                        $.get(url).done (data) =>
                            def = _.extend
                                baseName: 'edit'
                                module: @feature.module
                                feature: @feature
                                avoidLoadingHandlers: true
                                entityLabel: data.entityLabel
                                formName: 'edit'
                            , data
                            def.form =
                                groups: data.groups or []
                                tabs: data.tabs

                            view = new FormView def
                            @loadEditFormDeferred.resolve view, data.entityLabel

            serializeData: (su) ->
                data = su.apply @
                data.allowPick = @feature.startupOptions.allowPick
                data.allowAdd = @feature.startupOptions.allowAdd
                data.readOnly = @feature.startupOptions.readOnly

                data
    ,
        name: 'inline:grid', region: 'grid', avoidLoadingHandlers: true,
        components: [ ->
            options = @feature.startupOptions.gridOptions
            scaffold = options.form.feature.options.scaffold or {}
            columns = options.columns
            renderers = scaffold.renderers or {}

            @handlers = scaffold.handlers or {}
            @beforeShowInlineGridDialog = scaffold.beforeShowInlineGridDialog
            @afterShowInlineGridDialog = scaffold.afterShowInlineGridDialog
            @validInlineGridFormData = scaffold.validInlineGridFormData

            for column in columns
                column.renderer = renderers[column.renderer] if _.isString(column.renderer)

            _.extend
                type: 'grid'
                selector: 'grid'
                data: []
                fixedHeader: false
            , options
        ]
    ]

    extend:
        loadFormData: (ignore, values) ->
            grid = @views['inline:grid'].components[0]
            ids = []
            data = grid.fnGetData()
            for d in data or []
                ids.push d.id

            for v in values or []
                if ($.inArray v.id, ids) is -1
                    grid.addRow v

        getFormData: ->
            grid = @views['inline:grid'].components[0]
            view = @views['inline:operators']
            data = grid.fnGetData()
            return [null] if not data.length
            ids = []
            ids.push d.id for d in data when not view.fakeId(d.id)
            for d in data
                if view.fakeId(d.id)
                    dd = _.extend {}, d
                    delete dd.id
                    ids.push dd
            ids
