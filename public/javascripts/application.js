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
     * Allods namespace. Provides helpers and the like. Here's the sh*t.
     */
    Allods = (function() {
      var _conf = {
        colors: {
          maxScore: '#446EFF',
          max:      '#87CBFF',
          wait:     '#C5D2FF'
        },
        dataTable: {
          // inspect http://www.datatables.net/usage/ and related submenus
          bRetrieve: true,
          bInfo: false,
          bLengthChange: false,
          bPaginate: false,
          oLanguage: {
            sSearch: '',
            sZeroRecords: 'Aucun résultat.'
          }
        },
        typeWatch: {
          wait: 350,
          captureLength: 1
        }
      };

      return {
        /**
         * Turn a static table into a LootMachine console.
         */
        LMConsole: function(elt) {
          $(elt).dataTable(_conf.dataTable);
        },

        /**
         * On Character edit pages, dynamically display appropriate roles checkboxes
         * matching the current archetype.
         */
        display_roles_radios_for: function(archetype) {
          $('.roles_for').fadeOut('fast', function() {
            $('.roles_for[data-archetype=' + archetype + ']').fadeIn('fast');
          });
        },

        /**
         * Dynamic filtering should trigger some status computation, based on
         * the scores of the filtered elements. This will outline the line(s)
         * with the highest score.
         */
        compute_status: function() {
          var scores = $('td.score');

          if (!scores.length) {
            return null;
          }

          scores = _(scores).map(function(score) {
            return $(score).data('score');
          });

          max = _.max(scores);
          min = _.min(scores);

          $('td.score').animate({ backgroundColor: _conf.colors.wait }, 100);
          $('td.score[data-score=' + max + ']').animate({ backgroundColor: _conf.colors.max }, 200);
          $('td:not(.editable)', 'tr.loot_status_line[data-score=' + max + ']').animate({ backgroundColor: _conf.colors.max }, 200);
        },

        /**
         * Reset styles which were set by compute_status()
         */
        resetFilteringStyle: function() {
          $('td:not(.editable)', 'tr.loot_status_line').css('background', 'none');
          $('td.score').css('background', 'none');
        },

        /**
         * When filtering is on, display a cross icon to reset filtering.
         */
        appendCloseConsoleFilter: function(lm_console) {
          if (!$('#closeConsoleFilter').length) {
            elt = '<span id="closeConsoleFilter"><img src="/images/close.svg" /></span>';
            $('input', '.dataTables_filter').after(elt);
            $('#closeConsoleFilter img').live('click', function() {
              Allods.removeCloseConsoleFilter(lm_console);
            });
          }
        },

        /**
         * Actions to be taken when reseting filtering.
         */
        removeCloseConsoleFilter: function(lm_console) {
          $('input', '.dataTables_filter').val('');
          $('#closeConsoleFilter').fadeOut('fast', function() { $(this).remove(); });
          // don't forget to reset filtering
          lm_console.dataTable().fnFilter('');
          this.resetFilteringStyle();
        }
      };
    })();

    /**
     * Raise LootMachine consoles to live.
     */
    $('.loot_machine_console').livequery(function(){
      var that = $(this);

      Allods.LMConsole(that);
    });

    /**
     * If necessary, make LootStatus lines editable (for admin, that is).
     *
     * Separated from the previous livequery, so that a LootStatus line
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

          // I don't understand why, but at this point, the dataTable
          // features are lost, yet the object remains…
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

    /**
     * Raise Character's edit pages to live.
     */
    $('.archetype')
    .livequery(function() {
      var that     = $(this)
        , selected = $(':selected', that);

      if (selected.length) {
        Allods.display_roles_radios_for(selected.val());
      }
    })
    .livequery('change', function(e) {
      var that      = $(this)
        , archetype = that.val();

      Allods.display_roles_radios_for(archetype);
    });

    /**
     * Monitor what's been typed into a LootMachine console's filtering
     * input and behave.
     */
    $('.dataTables_filter input[type=text]').bind('keyup', function() {
      var that       = $(this)
        , lm_console = $(that.parent().siblings('.loot_machine_console'));

      if (that.val().length > 0) {
        Allods.appendCloseConsoleFilter(lm_console);
      } else {
        Allods.removeCloseConsoleFilter(lm_console);
      }

      Allods.resetFilteringStyle();
    }).typeWatch($.extend(Allods.conf, {
      callback: Allods.compute_status
    }));

    /**
     * Raise plusOne links to live.
     *
     * They will trigger a request to increment selected LootStatus lines
     * counters.
     */
    $('a.plusOne').livequery('click', function(e) {
      e.preventDefault();

      var that       = $(this)
        , lm_console = that.parents('.loot_machine_console')
        , content    = lm_console.children('tbody')
        , grid       = lm_console.dataTable()
        , ids        = _.map($('input[type=checkbox]:checked.' + that.data('type')), function(cb) {
                         return $(cb).parents('.loot_status_line').data('id');
                       });

      $.post(
        that.attr('href'),
        {
          'ids[]': ids,
          loot_status_metadata: that.data('type'),
          loot_machine_id: lm_console.data('id')
        },
        function(data) {
          grid.fnDestroy();
          content.replaceWith(data);
          Allods.LMConsole(lm_console);
        }
      );
    });
  });
})(jQuery);
