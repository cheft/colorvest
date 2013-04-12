define ["jquery", "coala/core/loader-plugin-manager"], ($, LoaderManager) ->
    viewIt: ->
        me = this
        grid = me.feature.views["completed-grid"].components[0]
        gridView = me.feature.views["completed-grid"]
        selected = grid.getGridParam("selrow")
        app = me.feature.module.getApplication()
        return app.info("请选择要操作的记录")  unless selected
        gridView.model.set "id", selected
        $.when(gridView.model.fetch()).done ->
            LoaderManager.invoke("view", me.feature.module, me.feature, "forms:p" + selected).done (view) ->
                view.model = gridView.model
                app.showDialog
                    view: view
                    title: "Task Process"
                    buttons: [
                        label: "Revoke"
                        status: 'disabled'
                        fn: (btn) ->
                            me.feature.request(url: "revoke/" + btn.taskId).done ->
                                grid.trigger "reloadGrid"

                    ]



        true

    selectAll: ->
        grid = @feature.views["completed-grid"].components[0]
        grid.setGridParam(postData: status: null)
        grid.trigger('reloadGrid')

    selectFinished: ->
        grid = @feature.views["completed-grid"].components[0]
        grid.setGridParam(postData: status: 'finished')
        grid.trigger('reloadGrid')

    selectUnfinished: ->
        grid = @feature.views["completed-grid"].components[0]
        grid.setGridParam(postData: status: 'unfinished')
        grid.trigger('reloadGrid')