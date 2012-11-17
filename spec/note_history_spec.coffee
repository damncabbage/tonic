require("../lib/note_history")

describe "NoteHistory", ->

  describe "basic note storage", ->
    beforeEach ->
      @history = new NoteHistory
      @history.add('A')
      @history.add('B')
      @history.add('C')

    it "stores notes", ->
      expect(@history.notes()).toEqual(['A','B','C'])

    it "de-dupes stored notes", ->
      @history.add('A')
      expect(@history.notes()).toEqual(['A','B','C'])

    it "stores arbitrary strings", ->
      @history.add('Flibbish')
      expect(@history.notes()).toEqual(['A','B','C','Flibbish'])

    it "clears stored notes", ->
      @history.clear()
      expect(@history.notes()).toEqual([])

  describe "storage cut-off", ->
    beforeEach ->
      @cutOff = 3
      @history = new NoteHistory(@cutOff)

    it "exposes the cut-off setting", ->
      expect(@history.cutOff).toEqual(@cutOff)

    it "cuts off different notes after reaching the limit", ->
      @history.add('A')
      @history.add('B')
      @history.add('C')
      @history.add('D')
      expect(@history.notes()).toEqual(['B','C','D'])

    it "adding a previously-mentioned note brings it back into the list again", ->
      # See "fall-off" for more detailed specs; this test is a simplified example.
      @history.add('A')
      @history.add('B')
      @history.add('C')
      @history.add('D')
      @history.add('A')
      expect(@history.notes()).toEqual(['A','C','D'])

  describe "fall-off", ->
    beforeEach ->
      @cutoff = 5
      @histor = new NoteHistory(@cutOff)

