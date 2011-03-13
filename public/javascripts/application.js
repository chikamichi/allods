// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

(function($) {
  $(document).ready(function() {
    /**
     * Fade flash messages out.
     */
    $('.flash')
    .animate({
      opacity: 0.25
    }, 5000, function() {
      // Animation complete.
      $(this).delay(2000).fadeOut('slow', function() {
        $(this).remove();
      });
    });

    /**
     * Allods namespace. Provides helpers and the like.
     */
    Allods = (function() {
      var _conf = {
        dataTable: {
          // http://www.datatables.net/usage/ and related submenus
          bRetrieve: true,
          bInfo: false,
          bLengthChange: false,
          bPaginate: false,
          oLanguage: {
            sSearch: 'Filtrer :',
            sZeroRecords: 'Aucun résultat.'
          }
        }
      };

      return {
        LMConsole: function(elt) {
          $(elt).dataTable(_conf.dataTable);
        }
      }
    })();

    /**
     * Turn static LootMachine consoles into a dynamic table.
     */
    $('.loot_machine_console').livequery(function(){
      var that = $(this);

      Allods.LMConsole(that);
    });

    /**
     * Separated from the previous livequery so that a LootStatus line
     * can be rendered on its own.
     */
    $('td.editable', '.loot_machine_console[data-admin=true]').livequery(function() {
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
          Allods.LMConsole(lm_console);
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
