FactoryGirl.define do
  factory :application do
    user
    software "PaymentSITE"
    gateway "CardKnox"
    omaha true
    nashville true
    north true
    buypass true
    elavon true
    tsys true
    source "www.secure.cardknox.com"
    agent "Yechiel Kalmenson"
    ticket "613770"
  end
end
