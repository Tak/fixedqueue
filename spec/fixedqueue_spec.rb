require 'fixedqueue'

RSpec.describe FixedQueue do
  it 'has a version number' do
    expect(FixedQueue::VERSION).not_to be nil
  end

  it 'works' do
    fq = FixedQueue::FixedQueue.new(3)
    expect(fq.size).to eq(0)
    fq.each{ |x| expect(x).to eq(nil) }
    3.times { |x| expect(fq.push(x)).to eq(nil) }
    3.times { |x| expect(fq.pop()).to eq(x) }
    3.times { |x| expect(fq.push(x)).to eq(nil) }
    3.times { |x| expect(fq[x] = x + 1).to eq(x + 1) }
    3.times { |x| expect(fq[x]).to eq(x + 1) }
  end

  it "doesn't decrement size past zero" do
    fq = FixedQueue::FixedQueue.new(3)
    3.times { |i| fq.push(i) }
    10.times { fq.pop }
    expect(fq.size).to eq(0)
  end

  def verify_invalid_index(queue, index)
    expect{ queue[index] }.to raise_error(IndexError)
    expect{ queue[index] = 1 }.to raise_error(IndexError)
  end

  it "throws on positive indices" do
    fq = FixedQueue::FixedQueue.new(3)
    [0, -1].each { |index| verify_invalid_index(fq, index) }

    fq.push(0)
    [1, -2].each { |index| verify_invalid_index(fq, index) }

    10.times { fq.push(0) }
    [3, -4].each { |index| verify_invalid_index(fq, index) }
  end

  context "when the queue is filled" do
    it "doesn't increment size past limit" do
      fq = FixedQueue::FixedQueue.new(3)
      10.times { |i| fq.push(i) }
      expect(fq.size).to eq(3)
    end

    it 'decrements size when popping' do
      fq = FixedQueue::FixedQueue.new(3)
      3.times { |i| fq.push(i) }
      expect(fq.size).to eq(3)
      fq.pop
      expect(fq.size).to eq(2)
    end

    it "indexes in fifo order" do
      fq = FixedQueue::FixedQueue.new(3)
      3.times { |i| fq.push(i) }
      3.times { |i| expect(fq[i]).to eq(i) }
    end

    it "assigns by index in fifo order" do
      fq = FixedQueue::FixedQueue.new(3)
      3.times { fq.push(0) }
      3.times { |i| fq[i] = i }
      3.times { |i| expect(fq[i]).to eq(i) }
    end

    it "works with negative indices" do
      fq = FixedQueue::FixedQueue.new(3)
      3.times { |i| fq.push(i) }
      3.times { |i| expect(fq[-i-1]).to eq(fq.size - i - 1) }
    end

    it "enumerates correctly" do
      fq = FixedQueue::FixedQueue.new(3)
      3.times { |i| fq.push(i) }
      fq.each_with_index { |item, index| expect(item).to eq(index) }
    end
  end

  context "when the queue is partially filled" do
    it 'increments size when pushing' do
      fq = FixedQueue::FixedQueue.new(10)
      3.times do |i|
        expect(fq.size).to eq(i)
        fq.push(i)
        expect(fq.size).to eq(i + 1)
      end
    end

    it 'decrements size when popping' do
      fq = FixedQueue::FixedQueue.new(10)
      3.times { |i| fq.push(i) }
      3.times do |i|
        expect(fq.size).to eq(3 - i)
        fq.pop
        expect(fq.size).to eq(3 - i - 1)
      end
    end

    it "indexes in fifo order" do
      fq = FixedQueue::FixedQueue.new(10)
      3.times { |i| fq.push(i) }
      3.times { |i| expect(fq[i]).to eq(i) }
    end

    it "assigns by index in fifo order" do
      fq = FixedQueue::FixedQueue.new(10)
      3.times { fq.push(0) }
      3.times { |i| fq[i] = i }
      3.times { |i| expect(fq[i]).to eq(i) }
    end

    it "works with negative indices" do
      fq = FixedQueue::FixedQueue.new(10)
      3.times { |i| fq.push(i) }
      3.times { |i| expect(fq[-i-1]).to eq(fq.size - i - 1) }
    end

    it "enumerates correctly" do
      fq = FixedQueue::FixedQueue.new(10)
      3.times { |i| fq.push(i) }
      fq.each_with_index { |item, index| expect(item).to eq(index) }
    end
  end
end
