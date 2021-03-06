require 'frame'
require 'illegal_shot_error'

describe 'Frame' do
  let(:frame) { Frame.new(1) }

  context 'when initialised' do
    it 'knows its number' do
      expect(frame.number).to eq(1)
    end

    it 'is not complete' do
      expect(frame.complete?).to be(false)
    end

    it 'has 10 pins remaining' do
      expect(frame.pins_remaining).to be(10)
    end
  end

  context 'when bowling' do
    it 'knows how many pins are remaining' do
      frame.bowl(1)
      expect(frame.pins_remaining).to eq(9)
    end

    it 'can check if it is complete' do
      expect(frame).to respond_to(:complete?)
    end

    it 'adds the pins to the total' do
      frame.bowl(1)
      expect(frame.total).to eq(1)
    end

    it 'adds the pins of the second shot to the total' do
      frame.bowl(1)
      frame.bowl(2)
      expect(frame.total).to eq(3)
    end

    it 'is complete after two balls have been bowled' do
      2.times { frame.bowl(1) }
      expect(frame.complete?).to be(true)
    end

    it 'is complete if the first shot was a ten' do
      frame.bowl(10)
      expect(frame.complete?).to be(true)
    end

    it 'deducts pins from the pins remaining' do
      frame.bowl(2)
      expect(frame.pins_remaining).to eq(8)
    end

    it 'raises an error if the shot is greater than the pins remaining' do
      expect { frame.bowl(11) }.to raise_error(IllegalShotError)
    end
  end

  context 'when complete' do
    it 'knows its score' do
      frame.bowl(1)
      frame.bowl(2)
      expect(frame.score).to eq(3)
    end

    it 'includes bonus points in the total but not score' do
      2.times { frame.bowl(5) }
      frame.bowl_bonus(1)
      expect(frame.score).to eq(10)
      expect(frame.total).to eq(11)
    end

    it 'knows if it was a spare' do
      2.times { frame.bowl(5) }
      expect(frame.spare?).to be(true)
    end

    it 'knows if it was a strike' do
      frame.bowl(10)
      expect(frame.strike?).to be(true)
    end

    it 'it cannot be a spare and a strike' do
      frame.bowl(10)
      expect(frame.strike?).to be(true)
      expect(frame.spare?).not_to be(true)
    end

    it 'has two bonus rolls if it was a strike' do
      frame.bowl(10)
      expect(frame.bonus_shots.shots.length).to eq(2)
    end

    it 'has one bonus roll if it was a spare' do
      frame.bowl(1)
      frame.bowl(9)
      expect(frame.bonus_shots.shots.length).to eq(1)
    end
  end
end
