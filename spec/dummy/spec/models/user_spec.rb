require 'rails_helper'

describe User, type: :model do
  subject { user }
  let(:user) { User.new(:email => 'emn178@gmail.com', :password => '12345678') }
  let(:mobile) { '0987654321' }
  let(:now) { Time.at(1462260253) }

  [:mobile, :phone].each do |field|
    describe "field is #{field}" do
      before { User.mobile_field = field }
      let(:title) { field.capitalize }

      describe '#change_mobile' do
        before {
          setup
          allow(Time).to receive(:now).and_return(now)
          allow_any_instance_of(User).to receive(:generate_mobile_confirmation_token).and_return('123456')
          @result = user.change_mobile(mobile)
        }
        let(:setup) {}

        context 'when it can change' do
          it { expect(@result).to eq true }
          its(:mobile_confirmation_sent_at) { should eq now }
          its(:mobile_confirmation_token) { should eq '123456' }
          its(:mobile_confirmation_failure) { should eq 0 }
          its(:unconfirmed_mobile) { should eq '0987654321' }
          its(field) { should eq nil }
          it { expect(SmsCarrier::TestCarrier.deliveries[0].body).to eq "Your token is 123456" }
        end

        context 'when mobile is blank' do
          let(:mobile) { '' }

          it { expect(@result).to eq false }
          it { expect(user.errors.full_messages).to eq ["#{title} can't be blank"] }
        end

        context 'when mobile is indifferent' do
          let(:setup) { user.mobile = mobile }
          it { expect(@result).to eq false }
          it { expect(user.errors.full_messages).to eq ["#{title} is indifferent"] }
        end

        context 'when mobile is indifferent' do
          let(:setup) { user.change_mobile(mobile) }
          it { expect(@result).to eq false }
          it { expect(user.errors.full_messages).to eq ["Please retry later"] }
        end
      end

      describe '#mobile_confirmed?' do
        context 'when not confirmed' do
          it { expect(user.mobile_confirmed?).to eq false }
        end

        context 'when not confirmed' do
          before { user.mobile_confirmed_at = Time.now }
          it { expect(user.mobile_confirmed?).to eq true }
        end
      end

      describe '#can_send_mobile_confirmation_token?' do
        context 'when mobile_confirmation_sent_at is nil' do
          its(:can_send_mobile_confirmation_token?) { should eq true }
        end

        context 'when mobile_confirmation_sent_at is 1 minute ago' do
          before { user.mobile_confirmation_sent_at = Time.now - 1.minute }
          its(:can_send_mobile_confirmation_token?) { should eq true }
        end

        context 'when mobile_confirmation_sent_at is 59 seconds ago' do
          before { user.mobile_confirmation_sent_at = Time.now - 59.seconds }
          its(:can_send_mobile_confirmation_token?) { should eq false }
        end
      end

      describe '#mobile_confirmation_token_expired?' do
        context 'when mobile_confirmation_token is nil' do
          its(:mobile_confirmation_token_expired?) { should eq true }
        end

        context 'when mobile_confirmation_token is not nil' do
          before { 
            user.mobile_confirmation_token = '123456'
            user.mobile_confirmation_sent_at = Time.now
          }

          context 'and mobile_confirmation_failure is 2' do
            before { user.mobile_confirmation_failure = 2 }

            its(:mobile_confirmation_token_expired?) { should eq false }
          end

          context 'when mobile_confirmation_failure is 3' do
            before { user.mobile_confirmation_failure = 3 }

            context 'and max_mobile_confirmation_failure is 3' do
              its(:mobile_confirmation_token_expired?) { should eq true }
            end

            context 'and max_mobile_confirmation_failure is 0' do
              before { allow(Devise).to receive(:max_mobile_confirmation_failure).and_return(0) }
              its(:mobile_confirmation_token_expired?) { should eq false }
            end
          end
        end
      end

      describe '#confirm_mobile_token' do
        before { 
          allow(Time).to receive(:now).and_return(now)
          allow_any_instance_of(User).to receive(:generate_mobile_confirmation_token).and_return('123456')
          user.change_mobile(mobile) 
          user.confirm_mobile_token('wrong')
          user.errors.clear
          setup
          @result = user.confirm_mobile_token(token)
        }
        let(:setup) {}

        context 'when token is correct' do
          let(:token) { '123456' }

          it { expect(@result).to eq true }
          its(field) { should eq mobile }
          its(:mobile_confirmed_at) { should eq now }
          its(:mobile_confirmation_failure) { should eq 0 }
          its(:mobile_confirmation_token) { should eq nil }
        end

        context 'when token is blank' do
          let(:token) { '' }

          it { expect(@result).to eq false }
          its(:mobile_confirmation_failure) { should eq 1 }
          it { expect(user.errors.full_messages).to eq ["Mobile confirmation token can't be blank"] }
        end

        context 'when token is wrong' do
          let(:token) { 'wrong' }

          it { expect(@result).to eq false }
          its(:mobile_confirmation_failure) { should eq 2 }
          it { expect(user.errors.full_messages).to eq ["Mobile confirmation token is invalid"] }
        end

        context 'when token is expired' do
          let(:token) { 'wrong' }
          let(:setup) { user.mobile_confirmation_failure = 3 }

          it { expect(@result).to eq false }
          it { expect(user.errors.full_messages).to eq ["Mobile confirmation token has expired, please request a new one"] }
        end
      end
    end
  end
end
