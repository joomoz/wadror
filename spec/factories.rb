FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :best_rating, class: Rating do
    score 50
  end

  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :beer do
    name "anonymous"
    brewery
    style
  end

  factory :style, class: Style do
    name 'Lager'
  end

  factory :style2, class: Style do
    name 'Porter'
  end

  factory :style3, class: Style do
    name 'IPA'
  end

end
