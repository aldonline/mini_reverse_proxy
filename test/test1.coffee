chai = require 'chai'
chai.should()

B = require '../lib'

slot = (value) ->
  (x) ->
    if arguments.length is 0
      value
    else
      value = x

describe 'bidibinder', ->

  it 'should work', -> 
    
    a = slot 'a'
    b = slot 'b'

    a().should.equal 'a'
    b().should.equal 'b'

    binding = B
      get_a: a
      set_a: a
      get_b: b
      set_b: b

    a().should.equal 'a'
    b().should.equal 'b'

    binding.touch_a()

    a().should.equal 'a'
    b().should.equal 'a'

    a 'c'
    a().should.equal 'c'
    b().should.equal 'a'

    binding.touch_a()

    a().should.equal 'c'
    b().should.equal 'c'

  it 'should safely stop immediate inverse invalidation', -> 

    a = slot 'a'
    b = slot 'b'

    a().should.equal 'a'
    b().should.equal 'b'
    
    binding = B
      get_a: a
      set_a: a
      get_b: b
      set_b: (v) ->
        b v
        binding.touch_b()
    
    binding.touch_a()


  it 'should safely stop a cyclic invalidation', -> 

    a = slot 'a'
    b = slot 'b'

    a().should.equal 'a'
    b().should.equal 'b'
    
    binding = B
      get_a: a
      set_a: a
      get_b: b
      set_b: (v) ->
        b v
        binding.touch_a()
    
    binding.touch_a()