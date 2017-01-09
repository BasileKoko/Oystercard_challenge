require 'oystercard'

describe Oystercard do
    subject { described_class.new }
    let(:station) {double :station}

    max_balance = Oystercard::MAXIMUM_BALANCE
    min_fare = Oystercard::MINIMUM_FARE

    describe '#balance' do
        it 'a new card should return 0 balance' do
            expect(subject.balance).to eq 0
        end
    end

    describe '#top_up' do
       it 'add amount of balance' do
        amount = 10
        expect{subject.top_up amount}.to change {subject.balance}.by amount
      end

      it 'can\'t top up over £90' do
          subject.top_up(max_balance)
          error_message = "Maximum balance of #{max_balance} exceeded"
          expect{ subject.top_up 1 }.to raise_error error_message
      end
    end

    describe '#touch_in' do
        it 'raise an error when you have less than minimum balance' do
          error_message = 'Sorry your balance is too low'
          expect {subject.touch_in(station)}.to raise_error error_message
        end

        it 'set an entry station' do
          subject.top_up(max_balance)
          subject.touch_in(station)
          expect(subject.entry_station).to eq station
        end
    end

    describe '#touch_out' do
        before do
            subject.top_up(max_balance)
            subject.touch_in(station)
        end
        it 'set entry station to nil'do
          expect {subject.touch_out}.to change{subject.entry_station}.to nil
        end

        it 'reduces balance by minimum fare' do
            expect{subject.touch_out}.to change {subject.balance}.by (-min_fare)
        end
    end
end
