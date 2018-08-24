require 'fixedqueue'

RSpec.describe FixedQueue do
  it 'has a version number' do
    expect(FixedQueue::VERSION).not_to be nil
  end

  it 'works' do
    fq = FixedQueue::FixedQueue.new(3)
    fq.each{ |x| expect(x).to eq(nil) }
    1.upto(3).each{ |x| expect(fq.push(x)).to eq(nil) }
    1.upto(3).each{ |x| expect(fq.pop()).to eq(x) }
    1.upto(3).each{ |x| expect(fq[x-1] = x).to eq(x) }
    1.upto(3).each{ |x| expect(fq[x-1]).to eq(x) }
  end
end
