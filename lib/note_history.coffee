_ = require('underscore')

root.NoteHistory = class NoteHistory
  constructor: (@cutOff=Infinity, @dropRate=3) ->
    @clear()
    @startingRelevancy = 1
    @maxRelevancy      = 5
    @relevancyBump     = 3

  find: (note) ->

  add: (note) ->
    if @items[note] == undefined
      @items[note] = {note: note, relevancy: @startingRelevancy, lastUpdated: undefined}
    item = @items[note]
    item.lastUpdated = @timer
    item.relevancy  += @scoreForItem(item.relevancy + @relevancyBump, item.lastUpdated)
    @timer += 1

  clear: ->
    @items = {}
    @timer = 1 # Fall-off calculation needs this to always
              # be at least one (Newtonian cooling minimum)

  notes: ->
    @notesByRelevancy().slice(0, @cutOff).sort()

  notesByRelevancy: ->
    (item.note for item in @itemsByRelevancy())

  itemsByRelevancy: ->
    _.sortBy(@items, (item) => @scoreForItem(item.relevancy, item.lastUpdated))

  scoreForItem: (relevancy, lastUpdated) ->
    relevancy * Math.exp( (-1 * @dropRate) * (@timer - lastUpdated) )

