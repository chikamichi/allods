// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

(function($) {
  $(document).ready(function() {
    $('.loot_machine_console').livequery(function(){
      var that = $(this);
      
      that.dataTable({
        bRetrieve: true
      });
    });

    /**
     * Separated from the previous livequery so that a LootStatus line
     * can be rendered on its own.
     */
    $('td.editable', '.loot_status_line').livequery(function() {
      var that       = $(this)
        , ls_line    = that.parents('.loot_status_line')
        , lm_console = ls_line.parents('.loot_machine_console')
        , content    = lm_console.children('tbody');

      that.editable(that.data('url_for_event'), {

        callback: function( sValue, y ) {
          var lm_console = $(this).parents('.loot_machine_console')
            , grid       = lm_console.dataTable();

          // I don't understand why, but at this point the dataTable
          // features are lost, yet the object remains.
          // @todo: try not to set bRetrieve, and call dataTable here (it
          // should recreate it). Try to call fnDraw() as well…
          grid.fnDestroy();
          content.replaceWith(sValue);
          lm_console.dataTable();
        },

        submitdata: function ( value, settings ) {
          // @todo: add a nice loader while processing the table
          return {
            loot_status_id:       ls_line.data('id'),
            loot_machine_id:      ls_line.data('machine_id'),
            loot_status_metadata: that.data('type')
          };
        },

        cssclass: 'editable',
        height: "12px"
      });
    });
  });
})(jQuery);
