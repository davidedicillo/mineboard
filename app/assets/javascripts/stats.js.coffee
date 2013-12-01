# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

load_func = () ->


  # Set the defaults for DataTables initialisation 
  $.extend true, $.fn.dataTable.defaults,
    sDom: "<'row'<'col-xs-5 col-sm-6'l><'col-xs-7 col-sm-6 text-right'f>r>t<'row'<'col-xs-3 col-sm-4 col-md-5'i><'col-xs-9 col-sm-8 col-md-7 text-right'p>>"
    sPaginationType: "bootstrap"
    oLanguage:
      sLengthMenu: "_MENU_ records per page"

    fnInitComplete: (oSettings, json) ->
      currentId = $(this).attr("id")
      console.log currentId
      if currentId
        thisLength = $("#" + currentId + "_length")
        thisLengthLabel = $("#" + currentId + "_length label")
        thisLengthSelect = $("#" + currentId + "_length label select")
        thisFilter = $("#" + currentId + "_filter")
        thisFilterLabel = $("#" + currentId + "_filter label")
        thisFilterInput = $("#" + currentId + "_filter label input")
        
        # Re-arrange the records selection for a form-horizontal layout
        thisLength.addClass "form-group"
        thisLengthLabel.addClass("control-label col-xs-12 col-sm-7 col-md-6").attr("for", currentId + "_length_select").css "text-align", "left"
        thisLengthSelect.addClass("form-control input-sm").attr "id", currentId + "_length_select"
        thisLengthSelect.prependTo(thisLength).wrap "<div class=\"col-xs-12 col-sm-5 col-md-6\" />"
        
        # Re-arrange the search input for a form-horizontal layout
        thisFilter.addClass "form-group"
        thisFilterLabel.addClass("control-label col-xs-4 col-sm-3 col-md-3").attr "for", currentId + "_filter_input"
        thisFilterInput.addClass("form-control input-sm").attr "id", currentId + "_filter_input"
        thisFilterInput.appendTo(thisFilter).wrap "<div class=\"col-xs-8 col-sm-9 col-md-9 \" />"

  $.extend $.fn.dataTableExt.oStdClasses,
    sWrapper: "dataTables_wrapper form-horizontal"


  # API method to get paging information 
  $.fn.dataTableExt.oApi.fnPagingInfo = (oSettings) ->
    iStart: oSettings._iDisplayStart
    iEnd: oSettings.fnDisplayEnd()
    iLength: oSettings._iDisplayLength
    iTotal: oSettings.fnRecordsTotal()
    iFilteredTotal: oSettings.fnRecordsDisplay()
    iPage: (if oSettings._iDisplayLength is -1 then 0 else Math.ceil(oSettings._iDisplayStart / oSettings._iDisplayLength))
    iTotalPages: (if oSettings._iDisplayLength is -1 then 0 else Math.ceil(oSettings.fnRecordsDisplay() / oSettings._iDisplayLength))


  # Bootstrap style pagination control 
  $.extend $.fn.dataTableExt.oPagination,
    bootstrap:
      fnInit: (oSettings, nPaging, fnDraw) ->
        oLang = oSettings.oLanguage.oPaginate
        fnClickHandler = (e) ->
          e.preventDefault()
          fnDraw oSettings  if oSettings.oApi._fnPageChange(oSettings, e.data.action)

        $(nPaging).append "<ul class=\"pagination\">" + "<li class=\"first disabled\"><a href=\"#\" title=\"" + oLang.sFirst + "\"><span class=\"glyphicon glyphicon-fast-backward\"></span></a></li>" + "<li class=\"prev disabled\"><a href=\"#\" title=\"" + oLang.sPrevious + "\"><span class=\"glyphicon glyphicon-chevron-left\"></span></a></li>" + "<li class=\"next disabled\"><a href=\"#\" title=\"" + oLang.sNext + "\"><span class=\"glyphicon glyphicon-chevron-right\"></span></a></li>" + "<li class=\"last disabled\"><a href=\"#\" title=\"" + oLang.sLast + "\"><span class=\"glyphicon glyphicon-fast-forward\"></span></a></li>" + "</ul>"
        els = $("a", nPaging)
        $(els[0]).bind "click.DT",
          action: "first"
        , fnClickHandler
        $(els[1]).bind "click.DT",
          action: "previous"
        , fnClickHandler
        $(els[2]).bind "click.DT",
          action: "next"
        , fnClickHandler
        $(els[3]).bind "click.DT",
          action: "last"
        , fnClickHandler

      fnUpdate: (oSettings, fnDraw) ->
        iListLength = 5
        oPaging = oSettings.oInstance.fnPagingInfo()
        an = oSettings.aanFeatures.p
        i = undefined
        j = undefined
        sClass = undefined
        iStart = undefined
        iEnd = undefined
        iHalf = Math.floor(iListLength / 2)
        if oPaging.iTotalPages < iListLength
          iStart = 1
          iEnd = oPaging.iTotalPages
        else if oPaging.iPage <= iHalf
          iStart = 1
          iEnd = iListLength
        else if oPaging.iPage >= oPaging.iTotalPages - iHalf
          iStart = oPaging.iTotalPages - iListLength + 1
          iEnd = oPaging.iTotalPages
        else
          iStart = oPaging.iPage - iHalf + 1
          iEnd = iStart + iListLength - 1
        i = 0
        iLen = an.length

        while i < iLen
          
          # Remove the middle elements
          $("li:gt(1)", an[i]).filter(":not(.next,.last)").remove()
          
          # Add the new list items and their event handlers
          j = iStart
          while j <= iEnd
            sClass = (if j is oPaging.iPage + 1 then "class=\"active\"" else "")
            $("<li " + sClass + "><a href=\"#\">" + j + "</a></li>").insertBefore($(".next,.last", an[i])[0]).bind "click", (a) ->
              a.preventDefault()
              oSettings._iDisplayStart = (parseInt($("a", this).text(), 10) - 1) * oPaging.iLength
              fnDraw oSettings

            j++
          
          # Add / remove disabled classes from the static elements
          if oPaging.iPage is 0
            $(".first,.prev", an[i]).addClass "disabled"
          else
            $(".first,.prev", an[i]).removeClass "disabled"
          if oPaging.iPage is oPaging.iTotalPages - 1 or oPaging.iTotalPages is 0
            $(".next,.last", an[i]).addClass "disabled"
          else
            $(".next,.last", an[i]).removeClass "disabled"
          i++


  #
  #* TableTools Bootstrap compatibility
  #* Required TableTools 2.1+
  #
  if $.fn.DataTable.TableTools
    
    # Set the classes that TableTools uses to something suitable for Bootstrap
    # Set the classes that TableTools uses to something suitable for Bootstrap
    $.extend true, $.fn.DataTable.TableTools.classes,
      container: "DTTT btn-group"
      buttons:
        normal: "btn btn-default"
        disabled: "disabled"

      collection:
        container: "DTTT_dropdown dropdown-menu"
        buttons:
          normal: ""
          disabled: "disabled"

      print:
        info: "DTTT_print_info modal"

      select:
        row: "active"

    
    # Have the collection use a bootstrap compatible dropdown
    $.extend true, $.fn.DataTable.TableTools.DEFAULTS.oTags,
      collection:
        container: "ul"
        button: "li"
        liner: "a"


  # Moved to the bottom.
  if $.fn.DataTable.defaults
    $.extend $.fn.dataTable.defaults,
      bAutoWidth: false
      aLengthMenu: [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]]
      iDisplayLength: 10
      bFilter: true


  $('#stats').dataTable
    aaSorting: [[1, "asc"]]
  $('#servers').dataTable()

$(document).ready(load_func);
$(document).on('page:load', load_func);
