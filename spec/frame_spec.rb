require 'frame'
require 'frame_over_error'
require 'too_many_pins_error'

describe 'Frame' do
  let(:frame) { Frame.new(1) }

  context 'when initialised' do
    it 'knows its number' do
      expect(frame.number).to eq(1)
    end

    it 'has a first shot' do
      expect(frame).to respond_to(:first_shot_score)
    end

    it 'has a second shot' do
      expect(frame).to respond_to(:second_shot_score)
    end

    it 'is not complete' do
      expect(frame.completed).to be(false)
    end

    it 'has 10 pins remaining' do
      expect(frame.pins_remaining).to be(10)
    end
  end

  context 'when bowling' do
    it 'can check if the first shot is complete' do
      expect(frame).to respond_to(:first_shot_taken)
    end

    it 'changes the status of the first shot to complete after one shot' do
      frame.bowl(1)
      expect(frame.first_shot_taken).to eq(true)
    end

    it 'can check if it is complete' do
      expect(frame).to respond_to(:completed)
    end

    it 'can change its status to complete' do
      frame.complete
      expect(frame.completed).to be(true)
    end

    it 'adds the pins to the first shot' do
      frame.bowl(1)
      expect(frame.first_shot_score).to eq(1)
    end

    it 'knows when the first shot has been taken' do
      frame.bowl(1)
      expect(frame.first_shot_taken).to eq(true)
    end

    it 'adds the pins to the second shot' do
      frame.bowl(1)
      frame.bowl(2)
      expect(frame.second_shot_score).to eq(2)
    end

    it 'is complete after two balls have been bowled' do
      frame.bowl(1)
      frame.bowl(2)
      expect(frame.completed).to be(true)
    end

    it 'is complete if the first shot was a ten' do
      frame.bowl(10)
      expect(frame.completed).to be(true)
    end

    it 'deducts each shot from the pins remaining' do
      frame.bowl(2)
      expect(frame.pins_remaining).to eq(8)
    end

    it 'raises an error if the shot is greater than the pins remaining' do
      expect { frame.bowl(11) }.to raise_error(TooManyPinsError)
    end
  end

  context 'when complete' do
    it 'knows its score' do
      frame.bowl(1)
      frame.bowl(2)
      expect(frame.score).to eq(3)
    end

    it 'knows if it was a spare' do
      frame.bowl(5)
      frame.bowl(5)
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

    it 'raises error if second shot is taken' do
      frame.bowl(10)
      expect { frame.bowl(1) }.to raise_error(FrameOverError)
    end

    it 'raises an error if the first shot is taken twice' do
      frame.bowl(10)
      expect { frame.bowl(1) }.to raise_error(FrameOverError)
    end
  end
end
