# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(window).load ->
  $('.grid').masonry
    itemSelector: '.grid-item'
    columnWidth: 0
    isFitWidth: true
  return
