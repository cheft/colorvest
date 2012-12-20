define ["zui/components/callbacks/tabs"], (cbTabs) ->
    components: [
        type: "tabs"
        selector: "center"
    ,
        type: "layout"
        defaults:
            spacing_open: 0
            hideTogglerOnSlide: true
            resizable: false

        north:
            size: 83
            togglerLength_open: 0

        south:
            size: 52

        west:
            size: 210

        center:
            findNestedContent: true
            onresize: (paneName, paneElement) ->
                $.layout.callbacks.resizeTabLayout paneName, paneElement
                cbTabs.resizeFitTabPanel paneName, paneElement
    ]
    regions:
        north: "north"
        south: "south"
        west: "west"

    avoidLoadingHandlers: true
