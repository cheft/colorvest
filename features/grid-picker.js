// Generated by CoffeeScript 1.4.0
(function() {

  define(['coala/features/grid-picker/__handlers__/grid-picker-field', 'coala/features/grid-picker/__layouts__/one-region', 'coala/features/grid-picker/__views__/grid-picker-field', 'text!coala/features/grid-picker/__templates__/grid-picker-field.html', 'text!coala/features/grid-picker/__templates__/one-region.html', 'text!coala/features/grid-picker/__templates__/grid-picker-grid-view.html'], function() {
    return {
      layout: "one-region",
      views: [
        {
          name: "grid-picker-field",
          region: "main"
        }
      ],
      avoidLoadingModel: true,
      extend: {
        initRenderTarget: function() {
          return this.container = this.startupOptions.el;
        }
      }
    };
  });

}).call(this);
