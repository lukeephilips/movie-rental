require('spec_helper')

describe(Actor) do
  describe('#name') do
    it('returns an empty array if no actors exist') do
      expect(Actor.all).to(eq([]))
    end
  end
  # describe('#name') do
  #
  # end
end
