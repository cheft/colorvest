define [
    'jquery'
    'coala/core/feature'
    'coala/core/loaders/default-feature-loader'
], ($, Feature, featureLoader) ->

    type: 'feature'
    name: 'DEFAULT'
    fn: (module, feature, featureName, args) ->
        options = args[0]
        deferred = $.Deferred()

        featureLoader.fn(module, feature, featureName, args).done (feature) ->
            if feature isnt null
                deferred.resolve feature
            else
                $.get(module.url(featureName) + '/configuration/feature').done (data) ->
                    views = []
                    if data.views
                        views = data.views
                    else
                        if data.style is 'grid'
                            views.push name: 'views:operators', region: 'operators'
                            views.push name: 'views:grid', region: 'grid'
                        else if data.style is 'tree'
                            views.push name: 'treeViews:operators', region: 'operators'
                            views.push name: 'treeViews:tree', region: 'grid'
                        else if data.style is 'treeTable'
                            views.push name: 'treeTableViews:operators', region: 'operators'
                            views.push name: 'treeTableViews:grid', region: 'grid'

                        views.push 'forms:add'
                        views.push 'forms:edit'
                        views.push 'forms:show'

                    opts =
                        baseName: featureName
                        module: module
                        avoidLoadingModel: true
                        avoidLoadingTemplate: true

                        layout: 'coala:grid'

                        views: views

                    if data.enableFrontendExtension is true
                        module.loadResource('__scaffold__/' + featureName).done (scaffold) ->
                            opts.scaffold = scaffold
                            deferred.resolve(new Feature opts, options)
                    else
                        deferred.resolve(new Feature opts, options)
        deferred.promise()
